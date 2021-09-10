Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6570D406398
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbhIJAsG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:48:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234814AbhIJAY1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:24:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CCDD60FDA;
        Fri, 10 Sep 2021 00:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233397;
        bh=Skk1y91WJSa/AERaoFTESdAFmZcXOU/Cr8bE+QgJAf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=csvxWu3gTowsYOoPrGwFQJi5aA7+PcKO/bLQGDNpBC876VXtcxrIDXcnUzMT7sbbk
         DPbbuoMCk2VtJAuI3K8ou5rmdbKkqHMjFUhr7botmTTD2e2zm4BsLnBPT2MxTXLm1U
         L8nKaCkqCzQfe6kgQvvk7vaOYFv5k7d0YyKoODhLWgrn8I48NTJKIPyYjLT8eCMpCv
         vDZVfLQ1hwZO+iyecVpAao8ZhiwfKEyZPcaecCGca3/9A8MckNCKTAznlznwRSiHND
         p/BE7/SToTtlUN3IQJO3ad1c4gXA/G+hGCRtwKppvkdOsOm8NBBYh8QhdiGYGYSyEg
         skkZLP8qSJe7A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 05/19] powerpc: make the install target not depend on any build artifact
Date:   Thu,  9 Sep 2021 20:22:55 -0400
Message-Id: <20210910002309.176412-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002309.176412-1-sashal@kernel.org>
References: <20210910002309.176412-1-sashal@kernel.org>
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
index 5807c9d8e56d..a74573b4e027 100644
--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -435,7 +435,7 @@ $(obj)/zImage.initrd:	$(addprefix $(obj)/, $(initrd-y))
 	$(Q)rm -f $@; ln $< $@
 
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

