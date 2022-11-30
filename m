Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3CD63DF1E
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbiK3SoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:44:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbiK3Snt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:43:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6949E1A82A
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:43:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F372361D4F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:43:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 147B3C433D7;
        Wed, 30 Nov 2022 18:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833827;
        bh=Wc8JEWRI+UfRM1v9tLXWAGKl8UQcagNCtNbszPlvVhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ttwwVS7kT1wqSmwMyD7KN0qKLtvViZb8hSL8VX1lzxgp/KsCLC8FBN5ZeDxkirAwY
         tohSGhA4VUx0/EPZ2Gx2Mo0EBkVbLc+cPoXkdLNzUJ+JjUNBZBtRtun16VSG33ObZE
         CUw2Hwj5TV9/qO2JcyjHw6xSsbm9AtjxDMHkQtm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Heiko Carstens <hca@linux.ibm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 029/289] s390: always build relocatable kernel
Date:   Wed, 30 Nov 2022 19:20:14 +0100
Message-Id: <20221130180544.794112216@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



