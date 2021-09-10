Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBDDA4063C2
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242111AbhIJAsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:48:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234560AbhIJAZS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:25:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90335610A3;
        Fri, 10 Sep 2021 00:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233448;
        bh=wv/k2L2DyIztoavixNHhp2woLxM0/Z3FrQ/qhAv9Mcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G1B9NjAPT3qOCdT3K0p57RGNkehuYljqcHhHarWUliXg80HQeyIQgOKiF+07iPLVm
         0qcpj6Qo6hz7OxPw5JjirkYjshOOiq8XYhJ8OUypvNNexg1LinW+pzbvwx2ftpdewA
         fnLyMaR4KJbhSGm2YpvCCxd45Fe1vUPP9yDXo2XHO0//IlxHYfQ2TtCC0aWUUAQ3OS
         pMehJKjqA4W4Fx1qW+xFxU8s0DnvyjfsPaAWXO1cJcnLjz1fcUmJo0/lArdk20VfLd
         yZ3w+aeZvJR8qUzCxU22hE55j2LT09Iy4bO72gxoYJPSK6GFuTb2JKocdl3em9w04/
         QnsiUfyqiTR3w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.4 03/14] powerpc: make the install target not depend on any build artifact
Date:   Thu,  9 Sep 2021 20:23:52 -0400
Message-Id: <20210910002403.176887-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002403.176887-1-sashal@kernel.org>
References: <20210910002403.176887-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 9bef456b20581e630ef9a13555ca04fed65a859d ]

The install target should not depend on any build artifact.

The reason is explained in commit 19514fc665ff ("arm, kbuild: make
"make install" not depend on vmlinux").

Change the PowerPC installation code in a similar way.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210729141937.445051-2-masahiroy@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/Makefile   |  2 +-
 arch/powerpc/boot/install.sh | 14 ++++++++++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
index 57003d1bd243..137f3a7c951d 100644
--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -395,7 +395,7 @@ $(obj)/zImage.initrd:	$(addprefix $(obj)/, $(initrd-y))
 	@rm -f $@; ln $< $@
 
 # Only install the vmlinux
-install: $(CONFIGURE) $(addprefix $(obj)/, $(image-y))
+install:
 	sh -x $(srctree)/$(src)/install.sh "$(KERNELRELEASE)" vmlinux System.map "$(INSTALL_PATH)"
 
 # Install the vmlinux and other built boot targets.
diff --git a/arch/powerpc/boot/install.sh b/arch/powerpc/boot/install.sh
index b6a256bc96ee..8d669cf1ccda 100644
--- a/arch/powerpc/boot/install.sh
+++ b/arch/powerpc/boot/install.sh
@@ -21,6 +21,20 @@
 # Bail with error code if anything goes wrong
 set -e
 
+verify () {
+	if [ ! -f "$1" ]; then
+		echo ""                                                   1>&2
+		echo " *** Missing file: $1"                              1>&2
+		echo ' *** You need to run "make" before "make install".' 1>&2
+		echo ""                                                   1>&2
+		exit 1
+	fi
+}
+
+# Make sure the files actually exist
+verify "$2"
+verify "$3"
+
 # User may have a custom install script
 
 if [ -x ~/bin/${INSTALLKERNEL} ]; then exec ~/bin/${INSTALLKERNEL} "$@"; fi
-- 
2.30.2

