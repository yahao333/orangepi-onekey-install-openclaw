#!/usr/bin/env bash
# 一键安装 OpenClaw（个人本地AI助理） - Linux 专用
# 官方仓库：https://github.com/openclaw/openclaw
# 官方安装文档：https://docs.openclaw.ai/install

set -euo pipefail

cat << 'EOF'
╔════════════════════════════════════╗
║       OpenClaw 一键安装脚本       ║
║   个人本地AI助理 • Linux 专用     ║
╚════════════════════════════════════╝

EOF

# 检查是否已安装
if command -v openclaw >/dev/null 2>&1; then
    echo "⚠️  已检测到 openclaw 已安装：$(openclaw --version 2>/dev/null || echo '未知版本')"
    read -p "是否要重新安装最新版？(y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "已取消，脚本结束。"
        exit 0
    fi
fi

echo "→ 检查 Node.js 环境..."

# 确保 nvm 已加载
if [[ -d "$HOME/.nvm" ]]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# 检查 Node 版本，不符合则强制用 nvm 安装
if ! command -v node >/dev/null 2>&1 || [[ $(node -v 2>/dev/null | cut -d. -f1 | tr -d 'v' 2>/dev/null || echo 0) -lt 22 ]]; then
    echo "未找到合适的 Node.js（需要 ≥22.16，推荐 24.x）"

    # 安装 nvm（如未安装）
    if [[ ! -d "$HOME/.nvm" ]]; then
        echo "→ 安装 nvm..."
        curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
    fi

    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    echo "→ 使用 nvm 安装 Node.js 24..."
    nvm install 24 --latest-npm
    nvm use 24
    nvm alias default 24

    echo "✓ Node.js $(node -v) 安装完成"
else
    echo "✓ Node.js $(node -v) 符合要求，继续..."
fi

echo
echo "→ 安装/更新 openclaw 到最新版..."
# 加载 nvm 并安装 openclaw
if [[ -d "$HOME/.nvm" ]]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi
npm install -g openclaw@latest

if ! command -v openclaw >/dev/null 2>&1; then
    echo "安装失败！请尝试手动运行："
    echo "  npm install -g openclaw@latest"
    exit 1
fi

cat << 'EOF'

安装完成！🎉

运行以下命令开始设置你的 AI 助理（需要配置模型 API Key）：
    openclaw

想要跳过引导直接使用（适合已配置好环境的用户）：
    openclaw --no-onboard

官方文档： https://docs.openclaw.ai
快速开始： https://docs.openclaw.ai/start/getting-started

祝使用愉快！🦞
EOF
