Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02FD863099A
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 03:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234443AbiKSCPH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 21:15:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234513AbiKSCNd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 21:13:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80897A34D;
        Fri, 18 Nov 2022 18:12:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73B89B8267A;
        Sat, 19 Nov 2022 02:12:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F72C433D7;
        Sat, 19 Nov 2022 02:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668823944;
        bh=Wc8JEWRI+UfRM1v9tLXWAGKl8UQcagNCtNbszPlvVhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bK79vHdhDCmbsaONXmXU1CGQk88EOZe/syLrY8bspQoUzSOTCIOzH/bOG89ZH7jVH
         ZUQdaPLbrrA4KiMk2+rzkN0owLQj7CCJEkfABOzw4o5lgVMU29zbznT6tVjrrMAR6Z
         MB/E3VPDRcltlozE9fNvMupVuAG2zczdaf55cI11hglKCqnaxhjGFyIDqslA2ejeOf
         4/1GUThNbtJFyzsZlcWUTx4l2iyUjcJnoQbE/OMBAPO/PdwJDgE7en1d+kDCSImQt/
         Pkry8jT7/yaAnOh0BtspjhUI2TYHdt/u6RzMICjE1IQx0s+gYB0R4EM/rexmPcmB7k
         XBOloBsFP2a6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, gor@linux.ibm.com,
        oberpar@linux.ibm.com, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 29/44] s390: always build relocatable kernel
Date:   Fri, 18 Nov 2022 21:11:09 -0500
Message-Id: <20221119021124.1773699-29-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021124.1773699-1-sashal@kernel.org>
References: <20221119021124.1773699-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 80ddf5ce1c9291cb175d52ed1227134ad48c47ee ]

Nathan Chancellor reported several link errors on s390 with
CONFIG_RELOCATABLE disabled, after binutils commit 906f69cf65da ("IBM
zSystems: Issue error for *DBL relocs on misaligned symbols"). The binutils
commit reveals potential miscompiles that might have happened already
before with linker script defined symbols at odd addresses.

A similar bug was recently fixed in the kernel with commit c9305b6c1f52
("s390: fix nospec table alignments").

See https://github.com/ClangBuiltLinux/linux/issues/1747 for an analysis
from Ulich Weigand.

Therefore always build a relocatable kernel to avoid this problem. There is
hardly any use-case for non-relocatable kernels, so this shouldn't be
controversial.

Link: https://github.com/ClangBuiltLinux/linux/issues/1747
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Reported-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20221030182202.2062705-1-hca@linux.ibm.com
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/Kconfig        | 6 +++---
 arch/s390/Makefile       | 2 --
 arch/s390/boot/Makefile  | 3 +--
 arch/s390/boot/startup.c | 3 +--
 4 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 318fce77601d..de575af02ffe 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -568,8 +568,7 @@ config EXPOLINE_FULL
 endchoice
 
 config RELOCATABLE
-	bool "Build a relocatable kernel"
-	default y
+	def_bool y
 	help
 	  This builds a kernel image that retains relocation information
 	  so it can be loaded at an arbitrary address.
@@ -578,10 +577,11 @@ config RELOCATABLE
 	  bootup process.
 	  The relocations make the kernel image about 15% larger (compressed
 	  10%), but are discarded at runtime.
+	  Note: this option exists only for documentation purposes, please do
+	  not remove it.
 
 config RANDOMIZE_BASE
 	bool "Randomize the address of the kernel image (KASLR)"
-	depends on RELOCATABLE
 	default y
 	help
 	  In support of Kernel Address Space Layout Randomization (KASLR),
diff --git a/arch/s390/Makefile b/arch/s390/Makefile
index 4cb5d17e7ead..47bec926d6c0 100644
--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -14,10 +14,8 @@ KBUILD_AFLAGS_MODULE += -fPIC
 KBUILD_CFLAGS_MODULE += -fPIC
 KBUILD_AFLAGS	+= -m64
 KBUILD_CFLAGS	+= -m64
-ifeq ($(CONFIG_RELOCATABLE),y)
 KBUILD_CFLAGS	+= -fPIE
 LDFLAGS_vmlinux	:= -pie
-endif
 aflags_dwarf	:= -Wa,-gdwarf-2
 KBUILD_AFLAGS_DECOMPRESSOR := $(CLANG_FLAGS) -m64 -D__ASSEMBLY__
 ifndef CONFIG_AS_IS_LLVM
diff --git a/arch/s390/boot/Makefile b/arch/s390/boot/Makefile
index 883357a211a3..d52c3e2e16bc 100644
--- a/arch/s390/boot/Makefile
+++ b/arch/s390/boot/Makefile
@@ -37,9 +37,8 @@ CFLAGS_sclp_early_core.o += -I$(srctree)/drivers/s390/char
 
 obj-y	:= head.o als.o startup.o mem_detect.o ipl_parm.o ipl_report.o
 obj-y	+= string.o ebcdic.o sclp_early_core.o mem.o ipl_vmparm.o cmdline.o
-obj-y	+= version.o pgm_check_info.o ctype.o ipl_data.o
+obj-y	+= version.o pgm_check_info.o ctype.o ipl_data.o machine_kexec_reloc.o
 obj-$(findstring y, $(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) $(CONFIG_PGSTE))	+= uv.o
-obj-$(CONFIG_RELOCATABLE)	+= machine_kexec_reloc.o
 obj-$(CONFIG_RANDOMIZE_BASE)	+= kaslr.o
 obj-y	+= $(if $(CONFIG_KERNEL_UNCOMPRESSED),,decompressor.o) info.o
 obj-$(CONFIG_KERNEL_ZSTD) += clz_ctz.o
diff --git a/arch/s390/boot/startup.c b/arch/s390/boot/startup.c
index bc48fe82d949..e5026e1d277f 100644
--- a/arch/s390/boot/startup.c
+++ b/arch/s390/boot/startup.c
@@ -285,8 +285,7 @@ void startup_kernel(void)
 
 	clear_bss_section();
 	copy_bootdata();
-	if (IS_ENABLED(CONFIG_RELOCATABLE))
-		handle_relocs(__kaslr_offset);
+	handle_relocs(__kaslr_offset);
 
 	if (__kaslr_offset) {
 		/*
-- 
2.35.1

