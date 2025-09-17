#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
umask 077
APP="$HOME/WT/Apps/wt-chat-editor"
BIN="$HOME/.local/bin"
mkdir -p "$APP" "$BIN"
case ":$PATH:" in *":$HOME/.local/bin:"*) :;; *) echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.profile";; esac

U="warrenet"; R="Wt-chat-editor"   # exact case
ALT="$(echo "$R" | tr '[:upper:]' '[:lower:]')"  # lowercase alt

TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
fetch() { curl -fsSL "https://codeload.github.com/$U/$1/tar.gz/refs/heads/main" -o "$TMP/repo.tar.gz"; }
if ! fetch "$R"; then fetch "$ALT"; fi

tar -xzf "$TMP/repo.tar.gz" -C "$TMP"
ROOT="$(find "$TMP" -maxdepth 1 -type d -iname "${R}-*" -o -iname "${ALT}-*" | head -n1)"

SRC_APP="$ROOT/app"; [ -f "$SRC_APP/index.html" ] || SRC_APP="$ROOT"

cp -f "$SRC_APP/index.html" "$APP/index.html"
[ -f "$SRC_APP/sw.js" ] && cp -f "$SRC_APP/sw.js" "$APP/sw.js" || true
[ -f "$SRC_APP/manifest.webmanifest" ] && cp -f "$SRC_APP/manifest.webmanifest" "$APP/manifest.webmanifest" || true
[ -f "$SRC_APP/icon-192.png" ] && cp -f "$SRC_APP/icon-192.png" "$APP/icon-192.png" || true

cp -f "$ROOT/bin/wt-chat-editor" "$BIN/wt-chat-editor"; chmod 700 "$BIN/wt-chat-editor"
echo "✅ Installed. Run: wt-chat-editor 7707"
