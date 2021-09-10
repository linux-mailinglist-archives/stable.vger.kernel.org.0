Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF327406205
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbhIJAo1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:44:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231318AbhIJAUT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:20:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E50B611AF;
        Fri, 10 Sep 2021 00:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233141;
        bh=4i0FMzCXh/A5Ie7Ab+TC6N2jHv8OoP+o6EcwIegyOTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AsVjwJFta0D1+D4G3xD8FWncwB5EWzOrLqlvhMVhXNUqjnQxml7gPvr31JxWxZG5g
         gOTjWOYMtMSAOZMVb3jxP1/U7ge1OpWETbu7WXce99jJ+eMuid1ePpBQos4iTmPJU6
         YaOJpTzW+eI2+uqUL30Qr/DBcR24M4UutdWCpiZakdYdoYXYRJifd4yfJkdae+mZlQ
         4AQ7m0KiJ6vbW4WxDKKCO+1NdWiARg7F+BiJsUnXrXWL0mDV9bddt3d8RzG9cxoQsy
         NuOAdigL1kAsf7WEmZVNProJXhotoyvjig5w5fXcKXqfq8gkamhcNBom21KIT/RQ9x
         7Q13Rhyne1N/Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.13 28/88] powerpc: make the install target not depend on any build artifact
Date:   Thu,  9 Sep 2021 20:17:20 -0400
Message-Id: <20210910001820.174272-28-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001820.174272-1-sashal@kernel.org>
References: <20210910001820.174272-1-sashal@kernel.org>
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
index 2b8da923ceca..a1b330f66a03 100644
--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -441,7 +441,7 @@ $(obj)/zImage.initrd:	$(addprefix $(obj)/, $(initrd-y))
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

