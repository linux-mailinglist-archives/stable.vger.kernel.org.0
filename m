Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C45474509FE
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 17:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbhKOQuG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 11:50:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:39960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231175AbhKOQtn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 11:49:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BC7C61BE1;
        Mon, 15 Nov 2021 16:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636994807;
        bh=WWEm3UnCdjvFHMMfL8QIQQzDwMIYIadesI7CfB6mZuw=;
        h=From:To:Cc:Subject:Date:From;
        b=ASXWXWTD2KNiMBP3BnCduO+hvaF10HQAYw7antHWjHTHjKpEL26E9yMxiNkLDmAdr
         aN++a6m4SGW9xRBAoeLkf4NMkncRtTC0BGl6m3fzro8pHNjfO9XpF13p+ey3Ytdnvi
         utvU06Jk3A4FXT62G0hHf1ouMwXpevx1C0Xy2HJPjsvzsdGC9sWPOEsBFU+Fx6p8Cy
         f5Xu0E11ViUGL3A4AXS6G3xf5l7UIMbCLFsVPVKJsdZptUP37xMbQ0xl+W+KVfRfEz
         5MGptWRpEGLomHoza438Ku7vcgUMzmjSBK0fpDKdeilHLr4nzo9/WAxuYCQlfiUfYO
         u9SELepTkmhPg==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>, stable@vger.kernel.org,
        llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.10] scripts/lld-version.sh: Rewrite based on upstream ld-version.sh
Date:   Mon, 15 Nov 2021 09:43:23 -0700
Message-Id: <20211115164322.560965-1-nathan@kernel.org>
X-Mailer: git-send-email 2.34.0.rc0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch is for linux-5.10.y only.

When scripts/lld-version.sh was initially written, it did not account
for the LLD_VENDOR cmake flag, which changes the output of ld.lld's
--version flag slightly.

Without LLD_VENDOR:

$ ld.lld --version
LLD 14.0.0 (compatible with GNU linkers)

With LLD_VENDOR:

$ ld.lld --version
Debian LLD 14.0.0 (compatible with GNU linkers)

As a result, CONFIG_LLD_VERSION is messed up and configuration values
that are dependent on it cannot be selected:

scripts/lld-version.sh: 20: printf: LLD: expected numeric value
scripts/lld-version.sh: 20: printf: LLD: expected numeric value
scripts/lld-version.sh: 20: printf: LLD: expected numeric value
init/Kconfig:52:warning: 'LLD_VERSION': number is invalid
.config:11:warning: symbol value '00000' invalid for LLD_VERSION
.config:8800:warning: override: CPU_BIG_ENDIAN changes choice state

This was fixed upstream by commit 1f09af062556 ("kbuild: Fix
ld-version.sh script if LLD was built with LLD_VENDOR") in 5.12 but that
was done to ld-version.sh after it was massively rewritten in
commit 02aff8592204 ("kbuild: check the minimum linker version in
Kconfig").

To avoid bringing in that change plus its prerequisites and fixes, just
modify lld-version.sh to make it similar to the upstream ld-version.sh,
which handles ld.lld with or without LLD_VENDOR and ld.bfd without any
errors.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---

Our CI caught this error with newer versions of Debian's ld.lld, which
added LLD_VENDOR it seems:

https://github.com/ClangBuiltLinux/continuous-integration2/runs/4206343929?check_suite_focus=true

A similar change was done by me for Android, where it has seen no
issues:

https://android-review.googlesource.com/c/kernel/common/+/1744324

I believe this is a safer change than backporting the fixes from
upstream but if you guys feel otherwise, I can do so. This is only
needed in 5.10 as CONFIG_LLD_VERSION does not exist in 5.4 and it was
fixed in 5.12 upstream.

 scripts/lld-version.sh | 35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/scripts/lld-version.sh b/scripts/lld-version.sh
index d70edb4d8a4f..f1eeee450a23 100755
--- a/scripts/lld-version.sh
+++ b/scripts/lld-version.sh
@@ -6,15 +6,32 @@
 # Print the linker version of `ld.lld' in a 5 or 6-digit form
 # such as `100001' for ld.lld 10.0.1 etc.
 
-linker_string="$($* --version)"
+set -e
 
-if ! ( echo $linker_string | grep -q LLD ); then
+# Convert the version string x.y.z to a canonical 5 or 6-digit form.
+get_canonical_version()
+{
+	IFS=.
+	set -- $1
+
+	# If the 2nd or 3rd field is missing, fill it with a zero.
+	echo $((10000 * $1 + 100 * ${2:-0} + ${3:-0}))
+}
+
+# Get the first line of the --version output.
+IFS='
+'
+set -- $(LC_ALL=C "$@" --version)
+
+# Split the line on spaces.
+IFS=' '
+set -- $1
+
+while [ $# -gt 1 -a "$1" != "LLD" ]; do
+	shift
+done
+if [ "$1" = LLD ]; then
+	echo $(get_canonical_version ${2%-*})
+else
 	echo 0
-	exit 1
 fi
-
-VERSION=$(echo $linker_string | cut -d ' ' -f 2)
-MAJOR=$(echo $VERSION | cut -d . -f 1)
-MINOR=$(echo $VERSION | cut -d . -f 2)
-PATCHLEVEL=$(echo $VERSION | cut -d . -f 3)
-printf "%d%02d%02d\\n" $MAJOR $MINOR $PATCHLEVEL

base-commit: bd816c278316f20a5575debc64dde4422229a880
-- 
2.34.0.rc0

