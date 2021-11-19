Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 404C64575AA
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 18:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236821AbhKSRlg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 12:41:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:42810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236873AbhKSRla (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 12:41:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C752361A7D;
        Fri, 19 Nov 2021 17:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637343508;
        bh=BL8/H3y2TQZOpJ+/pRUPYvUquyBGPO8kEdeg39HOqrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jXTiDxtfVybbLaLkuSsOkuNZYmgVhbYPlkETEaMFvtf9j/x2GhOk5/dFfsOji/0ju
         P3/RC7gJWk2Zngd7/p72WJIaPc813qSEVE8SWxTRg3nDRgeQUPrR/oW/InIujUo074
         Ax3vcB4rRs8W0DODy+kIsEhV5O+NIL3mie3Ad2Ys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 5.10 19/21] scripts/lld-version.sh: Rewrite based on upstream ld-version.sh
Date:   Fri, 19 Nov 2021 18:37:54 +0100
Message-Id: <20211119171444.503251464@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211119171443.892729043@linuxfoundation.org>
References: <20211119171443.892729043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

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
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/lld-version.sh |   35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

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


