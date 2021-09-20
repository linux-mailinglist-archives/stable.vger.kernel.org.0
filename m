Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 967F74122A6
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377230AbhITSQg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:16:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357830AbhITSFI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:05:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1DB863245;
        Mon, 20 Sep 2021 17:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158252;
        bh=7mFka9LzrtqigieZU60zukE5rqmPUDqyqXjmuylp0YU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xg8ZcKOPaINsXZx+qcpeyOu995+cdbRNkYeS5rXXyCH85MxV0UcPlXmzYs4VWiyWB
         TAT9rT5DIRP7O7Cx6JxR38NmwjoFUnLjr8jOQX+g2siRzB9R0Lj2qiJ7rnDQK6Ktf2
         xLltULKXDL1ggF1litJOQCjZiGjGPpXk2Dk/SIgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 070/260] kbuild: Fix no symbols warning when CONFIG_TRIM_UNUSD_KSYMS=y
Date:   Mon, 20 Sep 2021 18:41:28 +0200
Message-Id: <20210920163933.504199911@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 52d83df682c82055961531853c066f4f16e234ea ]

When CONFIG_TRIM_UNUSED_KSYMS is enabled, I see some warnings like this:

  nm: arch/x86/entry/vdso/vdso32/note.o: no symbols

$NM (both GNU nm and llvm-nm) warns when no symbol is found in the
object. Suppress the stderr.

Fangrui Song mentioned binutils>=2.37 `nm -q` can be used to suppress
"no symbols" [1], and llvm-nm>=13.0.0 supports -q as well.

We cannot use it for now, but note it as a TODO.

[1]: https://sourceware.org/bugzilla/show_bug.cgi?id=27408

Fixes: bbda5ec671d3 ("kbuild: simplify dependency generation for CONFIG_TRIM_UNUSED_KSYMS")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gen_ksymdeps.sh | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/scripts/gen_ksymdeps.sh b/scripts/gen_ksymdeps.sh
index 1324986e1362..725e8c9c1b53 100755
--- a/scripts/gen_ksymdeps.sh
+++ b/scripts/gen_ksymdeps.sh
@@ -4,7 +4,13 @@
 set -e
 
 # List of exported symbols
-ksyms=$($NM $1 | sed -n 's/.*__ksym_marker_\(.*\)/\1/p' | tr A-Z a-z)
+#
+# If the object has no symbol, $NM warns 'no symbols'.
+# Suppress the stderr.
+# TODO:
+#   Use -q instead of 2>/dev/null when we upgrade the minimum version of
+#   binutils to 2.37, llvm to 13.0.0.
+ksyms=$($NM $1 2>/dev/null | sed -n 's/.*__ksym_marker_\(.*\)/\1/p' | tr A-Z a-z)
 
 if [ -z "$ksyms" ]; then
 	exit 0
-- 
2.30.2



