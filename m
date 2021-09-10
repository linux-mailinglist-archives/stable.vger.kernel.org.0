Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC08406333
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233572AbhIJArA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:47:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234326AbhIJAXK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:23:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95A0960FE3;
        Fri, 10 Sep 2021 00:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233320;
        bh=D+QLyve1cn3xfj7bjTeGK+jKkdbDavOOIzQB1Q9hzLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GlWMi+BKcRNNq025ZXj7RP/0dio86ZlncrTn7gvrMiDJdUTQjKGA2MDjnq4lT+BC8
         M6f5ap2h63JuS3kAwHVP7murcP+kQInIC0Z3Jp+ewKSC0ZnvITPO37ZaeEKFYg86yl
         E1rhK/dRCT6I7xzqU3fDjklPeWLj7LTHu2POdjvn+BYgSfVsCwiauZR9/3/TGfAoWB
         7bAQBOwlAktbS8QXY/xv6B+OuXKF21qJ6RpeXN1mKRJ7JxG4vQNp8unRuuh7tV33H2
         wL4JhYTPMbL0KAkLEjd/hepLWCFcRgv5x/g1lduKKD1WVQcijYoPqOgXoYujvfvzBj
         ZjZjkZudM+h9g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 12/37] powerpc: make the install target not depend on any build artifact
Date:   Thu,  9 Sep 2021 20:21:17 -0400
Message-Id: <20210910002143.175731-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002143.175731-1-sashal@kernel.org>
References: <20210910002143.175731-1-sashal@kernel.org>
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
index 8c69bd07ada6..459ef5c780f7 100644
--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -438,7 +438,7 @@ $(obj)/zImage.initrd:	$(addprefix $(obj)/, $(initrd-y))
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

