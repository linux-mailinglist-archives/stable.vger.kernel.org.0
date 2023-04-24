Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAD356E6391
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbjDRMlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231857AbjDRMlt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:41:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE8F146D2
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:41:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8340A632E8
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:41:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704D1C433D2;
        Tue, 18 Apr 2023 12:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821688;
        bh=Kkh/T7qLquu46klgVxcuiYYUiigSX/62NtnFfyQ0WV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=axLkVvK1Esx1O2m5wCB9Ebp35mSrf+rJiFLDL5NDIp4975SGXPcbwuRLuaYx2Ayag
         y6JlY3HFvC9j2bnA4SOBu/mPzo0MFTU9/nUX0sQzPPMNT6RuIH3pH43EC1WgOgzwD9
         4SB3oj5Cz0/Htzb3DGBHFH+hjcNO1Kc1K5FPpxDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Masahiro Yamada <masahiroy@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 75/91] kbuild: use more subdir- for visiting subdirectories while cleaning
Date:   Tue, 18 Apr 2023 14:22:19 +0200
Message-Id: <20230418120308.150328208@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 8212f8986d311ccf6a72305e6bdbd814691701d6 ]

Documentation/kbuild/makefiles.rst suggests to use "archclean" for
cleaning arch/$(SRCARCH)/boot/, but it is not a hard requirement.

Since commit d92cc4d51643 ("kbuild: require all architectures to have
arch/$(SRCARCH)/Kbuild"), we can use the "subdir- += boot" trick for
all architectures. This can take advantage of the parallel option (-j)
for "make clean".

I also cleaned up the comments in arch/$(SRCARCH)/Makefile. The "archdep"
target no longer exists.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
Stable-dep-of: d83806c4c0cc ("purgatory: fix disabling debug info")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/kbuild/makefiles.rst | 17 ++---------------
 arch/alpha/Kbuild                  |  3 +++
 arch/alpha/Makefile                |  3 ---
 arch/arc/Kbuild                    |  3 +++
 arch/arc/Makefile                  |  3 ---
 arch/arm/Kbuild                    |  3 +++
 arch/arm/Makefile                  |  4 ----
 arch/arm64/Kbuild                  |  3 +++
 arch/arm64/Makefile                |  7 -------
 arch/arm64/kernel/Makefile         |  3 +++
 arch/csky/Kbuild                   |  3 +++
 arch/csky/Makefile                 |  3 ---
 arch/h8300/Kbuild                  |  3 +++
 arch/h8300/Makefile                |  3 ---
 arch/ia64/Makefile                 |  2 --
 arch/m68k/Makefile                 |  4 +---
 arch/microblaze/Kbuild             |  3 +++
 arch/microblaze/Makefile           |  3 ---
 arch/mips/Kbuild                   |  3 +++
 arch/mips/Makefile                 |  8 +-------
 arch/mips/boot/Makefile            |  3 +++
 arch/nds32/Kbuild                  |  3 +++
 arch/nds32/Makefile                |  3 ---
 arch/nios2/Kbuild                  |  3 +++
 arch/nios2/Makefile                |  6 +-----
 arch/openrisc/Kbuild               |  3 +++
 arch/openrisc/Makefile             |  7 +------
 arch/parisc/Kbuild                 |  3 +++
 arch/parisc/Makefile               |  7 +------
 arch/powerpc/Kbuild                |  3 +++
 arch/powerpc/Makefile              |  7 +------
 arch/riscv/Kbuild                  |  3 +++
 arch/riscv/Makefile                |  7 +------
 arch/s390/Kbuild                   |  3 +++
 arch/s390/Makefile                 |  8 +-------
 arch/sh/Kbuild                     |  3 +++
 arch/sh/Makefile                   |  3 ---
 arch/sparc/Kbuild                  |  3 +++
 arch/sparc/Makefile                |  3 ---
 arch/x86/Kbuild                    |  3 +++
 arch/x86/Makefile                  |  2 --
 arch/xtensa/Makefile               |  4 +---
 42 files changed, 71 insertions(+), 103 deletions(-)

diff --git a/Documentation/kbuild/makefiles.rst b/Documentation/kbuild/makefiles.rst
index db3af0b45bafa..b008b90b92c9f 100644
--- a/Documentation/kbuild/makefiles.rst
+++ b/Documentation/kbuild/makefiles.rst
@@ -1050,22 +1050,9 @@ is not sufficient this sometimes needs to be explicit.
 The above assignment instructs kbuild to descend down in the
 directory compressed/ when "make clean" is executed.
 
-To support the clean infrastructure in the Makefiles that build the
-final bootimage there is an optional target named archclean:
-
-	Example::
-
-		#arch/x86/Makefile
-		archclean:
-			$(Q)$(MAKE) $(clean)=arch/x86/boot
-
-When "make clean" is executed, make will descend down in arch/x86/boot,
-and clean as usual. The Makefile located in arch/x86/boot/ may use
-the subdir- trick to descend further down.
-
 Note 1: arch/$(SRCARCH)/Makefile cannot use "subdir-", because that file is
-included in the top level makefile, and the kbuild infrastructure
-is not operational at that point.
+included in the top level makefile. Instead, arch/$(SRCARCH)/Kbuild can use
+"subdir-".
 
 Note 2: All directories listed in core-y, libs-y, drivers-y and net-y will
 be visited during "make clean".
diff --git a/arch/alpha/Kbuild b/arch/alpha/Kbuild
index c2302017403a9..345d79df24bb9 100644
--- a/arch/alpha/Kbuild
+++ b/arch/alpha/Kbuild
@@ -1,3 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-y			+= kernel/ mm/
 obj-$(CONFIG_MATHEMU)	+= math-emu/
+
+# for cleaning
+subdir- += boot
diff --git a/arch/alpha/Makefile b/arch/alpha/Makefile
index 52529ee42dac9..881cb913e23ab 100644
--- a/arch/alpha/Makefile
+++ b/arch/alpha/Makefile
@@ -55,9 +55,6 @@ $(boot)/vmlinux.gz: vmlinux
 bootimage bootpfile bootpzfile: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
 
-archclean:
-	$(Q)$(MAKE) $(clean)=$(boot)
-
 archheaders:
 	$(Q)$(MAKE) $(build)=arch/alpha/kernel/syscalls all
 
diff --git a/arch/arc/Kbuild b/arch/arc/Kbuild
index 699d8cae9b1fc..b94102fff68b4 100644
--- a/arch/arc/Kbuild
+++ b/arch/arc/Kbuild
@@ -1,3 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-y += kernel/
 obj-y += mm/
+
+# for cleaning
+subdir- += boot
diff --git a/arch/arc/Makefile b/arch/arc/Makefile
index 8782a03f24a8e..f252e7b924e96 100644
--- a/arch/arc/Makefile
+++ b/arch/arc/Makefile
@@ -112,6 +112,3 @@ uImage: $(uimage-default-y)
 	@$(kecho) '  Image $(boot)/uImage is ready'
 
 CLEAN_FILES += $(boot)/uImage
-
-archclean:
-	$(Q)$(MAKE) $(clean)=$(boot)
diff --git a/arch/arm/Kbuild b/arch/arm/Kbuild
index 5208f7061524b..b506622e7e23a 100644
--- a/arch/arm/Kbuild
+++ b/arch/arm/Kbuild
@@ -9,3 +9,6 @@ obj-y				+= kernel/ mm/ common/
 obj-y				+= probes/
 obj-y				+= net/
 obj-y				+= crypto/
+
+# for cleaning
+subdir- += boot
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index fa45837b8065c..0fa2a6218e5eb 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -317,10 +317,6 @@ ifeq ($(CONFIG_VDSO),y)
 	$(Q)$(MAKE) $(build)=arch/arm/vdso $@
 endif
 
-# We use MRPROPER_FILES and CLEAN_FILES now
-archclean:
-	$(Q)$(MAKE) $(clean)=$(boot)
-
 # My testing targets (bypasses dependencies)
 bp:;	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $(boot)/bootpImage
 
diff --git a/arch/arm64/Kbuild b/arch/arm64/Kbuild
index ea7ab4ca81f92..5bfbf7d79c99b 100644
--- a/arch/arm64/Kbuild
+++ b/arch/arm64/Kbuild
@@ -4,3 +4,6 @@ obj-$(CONFIG_KVM)	+= kvm/
 obj-$(CONFIG_XEN)	+= xen/
 obj-$(subst m,y,$(CONFIG_HYPERV))	+= hyperv/
 obj-$(CONFIG_CRYPTO)	+= crypto/
+
+# for cleaning
+subdir- += boot
diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index c744b1e7b3569..e8cfc5868aa8e 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -182,13 +182,6 @@ ifeq ($(CONFIG_ARM64_USE_LSE_ATOMICS),y)
   endif
 endif
 
-
-# We use MRPROPER_FILES and CLEAN_FILES now
-archclean:
-	$(Q)$(MAKE) $(clean)=$(boot)
-	$(Q)$(MAKE) $(clean)=arch/arm64/kernel/vdso
-	$(Q)$(MAKE) $(clean)=arch/arm64/kernel/vdso32
-
 ifeq ($(KBUILD_EXTMOD),)
 # We need to generate vdso-offsets.h before compiling certain files in kernel/.
 # In order to do that, we should use the archprepare target, but we can't since
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 749e31475e413..db557856854e7 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -85,3 +85,6 @@ extra-y					+= $(head-y) vmlinux.lds
 ifeq ($(CONFIG_DEBUG_EFI),y)
 AFLAGS_head.o += -DVMLINUX_PATH="\"$(realpath $(objtree)/vmlinux)\""
 endif
+
+# for cleaning
+subdir- += vdso vdso32
diff --git a/arch/csky/Kbuild b/arch/csky/Kbuild
index a4e40e534e6a8..4e39f7abdeb6d 100644
--- a/arch/csky/Kbuild
+++ b/arch/csky/Kbuild
@@ -1 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+# for cleaning
+subdir- += boot
diff --git a/arch/csky/Makefile b/arch/csky/Makefile
index 37f593a4bf536..8668050776364 100644
--- a/arch/csky/Makefile
+++ b/arch/csky/Makefile
@@ -76,9 +76,6 @@ all: zImage
 zImage Image uImage: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
 
-archclean:
-	$(Q)$(MAKE) $(clean)=$(boot)
-
 define archhelp
   echo  '* zImage       - Compressed kernel image (arch/$(ARCH)/boot/zImage)'
   echo  '  Image        - Uncompressed kernel image (arch/$(ARCH)/boot/Image)'
diff --git a/arch/h8300/Kbuild b/arch/h8300/Kbuild
index b2583e7efbd1d..e4703f3534cca 100644
--- a/arch/h8300/Kbuild
+++ b/arch/h8300/Kbuild
@@ -1,2 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-y	+= kernel/ mm/ boot/dts/
+
+# for cleaning
+subdir- += boot
diff --git a/arch/h8300/Makefile b/arch/h8300/Makefile
index eb4cb8f6830c5..807f41e60ee4a 100644
--- a/arch/h8300/Makefile
+++ b/arch/h8300/Makefile
@@ -34,9 +34,6 @@ libs-y	+= arch/$(ARCH)/lib/
 
 boot := arch/h8300/boot
 
-archclean:
-	$(Q)$(MAKE) $(clean)=$(boot)
-
 vmlinux.srec vmlinux.bin zImage uImage.bin: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
 
diff --git a/arch/ia64/Makefile b/arch/ia64/Makefile
index 7e548c654a290..3b3ac3e1f2728 100644
--- a/arch/ia64/Makefile
+++ b/arch/ia64/Makefile
@@ -67,8 +67,6 @@ vmlinux.bin: vmlinux FORCE
 unwcheck: vmlinux
 	-$(Q)READELF=$(READELF) $(PYTHON3) $(srctree)/arch/ia64/scripts/unwcheck.py $<
 
-archclean:
-
 archheaders:
 	$(Q)$(MAKE) $(build)=arch/ia64/kernel/syscalls all
 
diff --git a/arch/m68k/Makefile b/arch/m68k/Makefile
index dd0c0ec67f670..740fc97b9c0f0 100644
--- a/arch/m68k/Makefile
+++ b/arch/m68k/Makefile
@@ -2,9 +2,7 @@
 # m68k/Makefile
 #
 # This file is included by the global makefile so that you can add your own
-# architecture-specific flags and dependencies. Remember to do have actions
-# for "archclean" and "archdep" for cleaning up and making dependencies for
-# this architecture
+# architecture-specific flags and dependencies.
 #
 # This file is subject to the terms and conditions of the GNU General Public
 # License.  See the file "COPYING" in the main directory of this archive
diff --git a/arch/microblaze/Kbuild b/arch/microblaze/Kbuild
index a1c5978893198..077a0b8e96157 100644
--- a/arch/microblaze/Kbuild
+++ b/arch/microblaze/Kbuild
@@ -3,3 +3,6 @@ obj-y			+= kernel/
 obj-y			+= mm/
 obj-$(CONFIG_PCI)	+= pci/
 obj-y			+= boot/dts/
+
+# for cleaning
+subdir- += boot
diff --git a/arch/microblaze/Makefile b/arch/microblaze/Makefile
index 9adc6b6434dfe..e775a696aa6fc 100644
--- a/arch/microblaze/Makefile
+++ b/arch/microblaze/Makefile
@@ -60,9 +60,6 @@ export DTB
 
 all: linux.bin
 
-archclean:
-	$(Q)$(MAKE) $(clean)=$(boot)
-
 archheaders:
 	$(Q)$(MAKE) $(build)=arch/microblaze/kernel/syscalls all
 
diff --git a/arch/mips/Kbuild b/arch/mips/Kbuild
index d5d6ef9bb9867..9e8071f0e58ff 100644
--- a/arch/mips/Kbuild
+++ b/arch/mips/Kbuild
@@ -25,3 +25,6 @@ obj-y += vdso/
 ifdef CONFIG_KVM
 obj-y += kvm/
 endif
+
+# for cleaning
+subdir- += boot
diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index f7b58da2f3889..ace7f033de07c 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -8,8 +8,7 @@
 # Copyright (C) 2002, 2003, 2004  Maciej W. Rozycki
 #
 # This file is included by the global makefile so that you can add your own
-# architecture-specific flags and dependencies. Remember to do have actions
-# for "archclean" cleaning up for this architecture.
+# architecture-specific flags and dependencies.
 #
 
 archscripts: scripts_basic
@@ -428,11 +427,6 @@ endif
 	$(Q)install -D -m 644 .config $(INSTALL_PATH)/config-$(KERNELRELEASE)
 	$(Q)install -D -m 644 System.map $(INSTALL_PATH)/System.map-$(KERNELRELEASE)
 
-archclean:
-	$(Q)$(MAKE) $(clean)=arch/mips/boot
-	$(Q)$(MAKE) $(clean)=arch/mips/boot/compressed
-	$(Q)$(MAKE) $(clean)=arch/mips/boot/tools
-
 archheaders:
 	$(Q)$(MAKE) $(build)=arch/mips/kernel/syscalls all
 
diff --git a/arch/mips/boot/Makefile b/arch/mips/boot/Makefile
index a3da2c5d63c21..196c44fa72d90 100644
--- a/arch/mips/boot/Makefile
+++ b/arch/mips/boot/Makefile
@@ -171,3 +171,6 @@ $(obj)/vmlinux.itb: $(obj)/vmlinux.its $(obj)/vmlinux.bin FORCE
 
 $(obj)/vmlinux.%.itb: $(obj)/vmlinux.%.its $(obj)/vmlinux.bin.% FORCE
 	$(call if_changed,itb-image,$<)
+
+# for cleaning
+subdir- += compressed tools
diff --git a/arch/nds32/Kbuild b/arch/nds32/Kbuild
index a4e40e534e6a8..4e39f7abdeb6d 100644
--- a/arch/nds32/Kbuild
+++ b/arch/nds32/Kbuild
@@ -1 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+# for cleaning
+subdir- += boot
diff --git a/arch/nds32/Makefile b/arch/nds32/Makefile
index ccdca71420201..1aa8659786096 100644
--- a/arch/nds32/Makefile
+++ b/arch/nds32/Makefile
@@ -62,9 +62,6 @@ prepare: vdso_prepare
 vdso_prepare: prepare0
 	$(Q)$(MAKE) $(build)=arch/nds32/kernel/vdso include/generated/vdso-offsets.h
 
-archclean:
-	$(Q)$(MAKE) $(clean)=$(boot)
-
 define archhelp
   echo  '  Image         - kernel image (arch/$(ARCH)/boot/Image)'
 endef
diff --git a/arch/nios2/Kbuild b/arch/nios2/Kbuild
index a4e40e534e6a8..4e39f7abdeb6d 100644
--- a/arch/nios2/Kbuild
+++ b/arch/nios2/Kbuild
@@ -1 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+# for cleaning
+subdir- += boot
diff --git a/arch/nios2/Makefile b/arch/nios2/Makefile
index 52c03e60b114d..ef41d1446302f 100644
--- a/arch/nios2/Makefile
+++ b/arch/nios2/Makefile
@@ -8,8 +8,7 @@
 # Written by Fredrik Markstrom
 #
 # This file is included by the global makefile so that you can add your own
-# architecture-specific flags and dependencies. Remember to do have actions
-# for "archclean" cleaning up for this architecture.
+# architecture-specific flags and dependencies.
 #
 # Nios2 port by Wind River Systems Inc trough:
 #   fredrik.markstrom@gmail.com and ivarholmqvist@gmail.com
@@ -53,9 +52,6 @@ core-y	+= $(nios2-boot)/dts/
 
 all: vmImage
 
-archclean:
-	$(Q)$(MAKE) $(clean)=$(nios2-boot)
-
 $(BOOT_TARGETS): vmlinux
 	$(Q)$(MAKE) $(build)=$(nios2-boot) $(nios2-boot)/$@
 
diff --git a/arch/openrisc/Kbuild b/arch/openrisc/Kbuild
index 4234b4c03e725..b0b0f2b03f872 100644
--- a/arch/openrisc/Kbuild
+++ b/arch/openrisc/Kbuild
@@ -1,3 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-y += lib/ kernel/ mm/
 obj-y += boot/dts/
+
+# for cleaning
+subdir- += boot
diff --git a/arch/openrisc/Makefile b/arch/openrisc/Makefile
index c52de526e5189..760b734fb8227 100644
--- a/arch/openrisc/Makefile
+++ b/arch/openrisc/Makefile
@@ -1,9 +1,7 @@
 # BK Id: %F% %I% %G% %U% %#%
 #
 # This file is included by the global makefile so that you can add your own
-# architecture-specific flags and dependencies. Remember to do have actions
-# for "archclean" and "archdep" for cleaning up and making dependencies for
-# this architecture
+# architecture-specific flags and dependencies.
 #
 # This file is subject to the terms and conditions of the GNU General Public
 # License.  See the file "COPYING" in the main directory of this archive
@@ -48,6 +46,3 @@ PHONY += vmlinux.bin
 
 vmlinux.bin: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
-
-archclean:
-	$(Q)$(MAKE) $(clean)=$(boot)
diff --git a/arch/parisc/Kbuild b/arch/parisc/Kbuild
index 3c068b700a810..a6d3b280ba0c2 100644
--- a/arch/parisc/Kbuild
+++ b/arch/parisc/Kbuild
@@ -1,2 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-y	+= mm/ kernel/ math-emu/
+
+# for cleaning
+subdir- += boot
diff --git a/arch/parisc/Makefile b/arch/parisc/Makefile
index fadb098de1545..82d77f4b0d083 100644
--- a/arch/parisc/Makefile
+++ b/arch/parisc/Makefile
@@ -2,9 +2,7 @@
 # parisc/Makefile
 #
 # This file is included by the global makefile so that you can add your own
-# architecture-specific flags and dependencies. Remember to do have actions
-# for "archclean" and "archdep" for cleaning up and making dependencies for
-# this architecture
+# architecture-specific flags and dependencies.
 #
 # This file is subject to the terms and conditions of the GNU General Public
 # License.  See the file "COPYING" in the main directory of this archive
@@ -186,8 +184,5 @@ define archhelp
 	@echo  '  zinstall	- Install compressed vmlinuz kernel'
 endef
 
-archclean:
-	$(Q)$(MAKE) $(clean)=$(boot)
-
 archheaders:
 	$(Q)$(MAKE) $(build)=arch/parisc/kernel/syscalls all
diff --git a/arch/powerpc/Kbuild b/arch/powerpc/Kbuild
index 5e2f9eaa3ee7d..22cd0d55a8924 100644
--- a/arch/powerpc/Kbuild
+++ b/arch/powerpc/Kbuild
@@ -16,3 +16,6 @@ obj-$(CONFIG_KVM)  += kvm/
 obj-$(CONFIG_PERF_EVENTS) += perf/
 obj-$(CONFIG_KEXEC_CORE)  += kexec/
 obj-$(CONFIG_KEXEC_FILE)  += purgatory/
+
+# for cleaning
+subdir- += boot
diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index a8e52e64c1a5b..3353188f1defb 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -1,7 +1,5 @@
 # This file is included by the global makefile so that you can add your own
-# architecture-specific flags and dependencies. Remember to do have actions
-# for "archclean" and "archdep" for cleaning up and making dependencies for
-# this architecture.
+# architecture-specific flags and dependencies.
 #
 # This file is subject to the terms and conditions of the GNU General Public
 # License.  See the file "COPYING" in the main directory of this archive
@@ -387,9 +385,6 @@ install:
 	sh -x $(srctree)/$(boot)/install.sh "$(KERNELRELEASE)" vmlinux \
 	System.map "$(INSTALL_PATH)"
 
-archclean:
-	$(Q)$(MAKE) $(clean)=$(boot)
-
 ifeq ($(KBUILD_EXTMOD),)
 # We need to generate vdso-offsets.h before compiling certain files in kernel/.
 # In order to do that, we should use the archprepare target, but we can't since
diff --git a/arch/riscv/Kbuild b/arch/riscv/Kbuild
index 4614c01ba5b32..fb3397223d520 100644
--- a/arch/riscv/Kbuild
+++ b/arch/riscv/Kbuild
@@ -2,3 +2,6 @@
 
 obj-y += kernel/ mm/ net/
 obj-$(CONFIG_BUILTIN_DTB) += boot/dts/
+
+# for cleaning
+subdir- += boot
diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index 0f17c6b6b7294..96772a32a87db 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -1,7 +1,5 @@
 # This file is included by the global makefile so that you can add your own
-# architecture-specific flags and dependencies. Remember to do have actions
-# for "archclean" and "archdep" for cleaning up and making dependencies for
-# this architecture
+# architecture-specific flags and dependencies.
 #
 # This file is subject to the terms and conditions of the GNU General Public
 # License.  See the file "COPYING" in the main directory of this archive
@@ -157,6 +155,3 @@ zinstall: install-image = Image.gz
 install zinstall:
 	$(CONFIG_SHELL) $(srctree)/$(boot)/install.sh $(KERNELRELEASE) \
 	$(boot)/$(install-image) System.map "$(INSTALL_PATH)"
-
-archclean:
-	$(Q)$(MAKE) $(clean)=$(boot)
diff --git a/arch/s390/Kbuild b/arch/s390/Kbuild
index 8b98c501142df..76e3622771791 100644
--- a/arch/s390/Kbuild
+++ b/arch/s390/Kbuild
@@ -8,3 +8,6 @@ obj-$(CONFIG_APPLDATA_BASE)	+= appldata/
 obj-y				+= net/
 obj-$(CONFIG_PCI)		+= pci/
 obj-$(CONFIG_ARCH_HAS_KEXEC_PURGATORY) += purgatory/
+
+# for cleaning
+subdir- += boot tools
diff --git a/arch/s390/Makefile b/arch/s390/Makefile
index c7b7a60f6405d..6e42252214dd8 100644
--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -3,9 +3,7 @@
 # s390/Makefile
 #
 # This file is included by the global makefile so that you can add your own
-# architecture-specific flags and dependencies. Remember to do have actions
-# for "archclean" and "archdep" for cleaning up and making dependencies for
-# this architecture
+# architecture-specific flags and dependencies.
 #
 # Copyright (C) 1994 by Linus Torvalds
 #
@@ -159,10 +157,6 @@ zfcpdump:
 vdso_install:
 	$(Q)$(MAKE) $(build)=arch/$(ARCH)/kernel/vdso64 $@
 
-archclean:
-	$(Q)$(MAKE) $(clean)=$(boot)
-	$(Q)$(MAKE) $(clean)=$(tools)
-
 archheaders:
 	$(Q)$(MAKE) $(build)=$(syscalls) uapi
 
diff --git a/arch/sh/Kbuild b/arch/sh/Kbuild
index 48c2a091a0720..be171880977e5 100644
--- a/arch/sh/Kbuild
+++ b/arch/sh/Kbuild
@@ -2,3 +2,6 @@
 obj-y				+= kernel/ mm/ boards/
 obj-$(CONFIG_SH_FPU_EMU)	+= math-emu/
 obj-$(CONFIG_USE_BUILTIN_DTB)	+= boot/dts/
+
+# for cleaning
+subdir- += boot
diff --git a/arch/sh/Makefile b/arch/sh/Makefile
index 7814639006213..b39412bf91fb0 100644
--- a/arch/sh/Makefile
+++ b/arch/sh/Makefile
@@ -198,9 +198,6 @@ compressed: zImage
 archprepare:
 	$(Q)$(MAKE) $(build)=arch/sh/tools include/generated/machtypes.h
 
-archclean:
-	$(Q)$(MAKE) $(clean)=$(boot)
-
 archheaders:
 	$(Q)$(MAKE) $(build)=arch/sh/kernel/syscalls all
 
diff --git a/arch/sparc/Kbuild b/arch/sparc/Kbuild
index c9e574906a9b9..71cb3d934bf6c 100644
--- a/arch/sparc/Kbuild
+++ b/arch/sparc/Kbuild
@@ -9,3 +9,6 @@ obj-y += math-emu/
 obj-y += net/
 obj-y += crypto/
 obj-$(CONFIG_SPARC64) += vdso/
+
+# for cleaning
+subdir- += boot
diff --git a/arch/sparc/Makefile b/arch/sparc/Makefile
index 24fb5a99f4394..c7008bbebc4cd 100644
--- a/arch/sparc/Makefile
+++ b/arch/sparc/Makefile
@@ -75,9 +75,6 @@ install:
 	sh $(srctree)/$(boot)/install.sh $(KERNELRELEASE) $(KBUILD_IMAGE) \
 		System.map "$(INSTALL_PATH)"
 
-archclean:
-	$(Q)$(MAKE) $(clean)=$(boot)
-
 archheaders:
 	$(Q)$(MAKE) $(build)=arch/sparc/kernel/syscalls all
 
diff --git a/arch/x86/Kbuild b/arch/x86/Kbuild
index 30dec019756b9..f384cb1a4f7a8 100644
--- a/arch/x86/Kbuild
+++ b/arch/x86/Kbuild
@@ -25,3 +25,6 @@ obj-y += platform/
 obj-y += net/
 
 obj-$(CONFIG_KEXEC_FILE) += purgatory/
+
+# for cleaning
+subdir- += boot tools
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 9c09bbd390cec..15c54fa1b435d 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -287,8 +287,6 @@ endif
 archclean:
 	$(Q)rm -rf $(objtree)/arch/i386
 	$(Q)rm -rf $(objtree)/arch/x86_64
-	$(Q)$(MAKE) $(clean)=$(boot)
-	$(Q)$(MAKE) $(clean)=arch/x86/tools
 
 define archhelp
   echo  '* bzImage		- Compressed kernel image (arch/x86/boot/bzImage)'
diff --git a/arch/xtensa/Makefile b/arch/xtensa/Makefile
index 96714ef7c89e3..9778216d6e09d 100644
--- a/arch/xtensa/Makefile
+++ b/arch/xtensa/Makefile
@@ -7,9 +7,7 @@
 # Copyright (C) 2014 Cadence Design Systems Inc.
 #
 # This file is included by the global makefile so that you can add your own
-# architecture-specific flags and dependencies. Remember to do have actions
-# for "archclean" and "archdep" for cleaning up and making dependencies for
-# this architecture
+# architecture-specific flags and dependencies.
 
 # Core configuration.
 # (Use VAR=<xtensa_config> to use another default compiler.)
-- 
2.39.2



