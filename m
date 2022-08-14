Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B90C5923D0
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240359AbiHNQZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241453AbiHNQYs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:24:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E3BC309;
        Sun, 14 Aug 2022 09:22:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F41C7B80B78;
        Sun, 14 Aug 2022 16:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51361C433B5;
        Sun, 14 Aug 2022 16:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494148;
        bh=KO435wy8C215M33h5zMvq+8oWCSWgC8TLtuQTl/Hsf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PY4NxpbCunFtALQujjHH1mQsStoc3gvpThj+NXmjNbXO7NaM4LGGCBQI9dKv4vVam
         k5wJmJe2i0vWNhbdpj7ipeIeffK4HQKA2xElBoVtb/eo+5dF69TU+WDvWbRefKHr6W
         c2Mb0XMuWvb9WDdCpu7m+7Ks2PrROWmDlJhO5yGLUbdsQ7L6Tk3yTM/o3BrjJE5r5X
         KrUeKFOjNaG64uE2MABhDtqRwhnWgQA14Yl8ue2wIbr5i7vlKgG39jtjItcVGO/0sp
         E6f+jbiFBthMDIReKsSNIp43b6GxY4Mq11niRCO82b4am5SFl6ePtF2lwgJPm+2jkd
         moo5iIAtwi4EQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Segher Boessenkool <segher@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, npiggin@gmail.com,
        dja@axtens.net, lukas.bulwahn@gmail.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.19 32/48] powerpc/32: Don't always pass -mcpu=powerpc to the compiler
Date:   Sun, 14 Aug 2022 12:19:25 -0400
Message-Id: <20220814161943.2394452-32-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814161943.2394452-1-sashal@kernel.org>
References: <20220814161943.2394452-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 446cda1b21d9a6b3697fe399c6a3a00ff4a285f5 ]

Since commit 4bf4f42a2feb ("powerpc/kbuild: Set default generic
machine type for 32-bit compile"), when building a 32 bits kernel
with a bi-arch version of GCC, or when building a book3s/32 kernel,
the option -mcpu=powerpc is passed to GCC at all time, relying on it
being eventually overriden by a subsequent -mcpu=xxxx.

But when building the same kernel with a 32 bits only version of GCC,
that is not done, relying on gcc being built with the expected default
CPU.

This logic has two problems. First, it is a bit fragile to rely on
whether the GCC version is bi-arch or not, because today we can have
bi-arch versions of GCC configured with a 32 bits default. Second,
there are some versions of GCC which don't support -mcpu=powerpc,
for instance for e500 SPE-only versions.

So, stop relying on this approximative logic and allow the user to
decide whether he/she wants to use the toolchain's default CPU or if
he/she wants to set one, and allow only possible CPUs based on the
selected target.

Reported-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Tested-by: Pali Rohár <pali@kernel.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Segher Boessenkool <segher@kernel.crashing.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/d4df724691351531bf46d685d654689e5dfa0d74.1657549153.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/Makefile                  | 26 +-------------------------
 arch/powerpc/platforms/Kconfig.cputype | 21 ++++++++++++++++++---
 2 files changed, 19 insertions(+), 28 deletions(-)

diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index a0cd70712061..d54e1fe03551 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -15,23 +15,6 @@ HAS_BIARCH	:= $(call cc-option-yn, -m32)
 # Set default 32 bits cross compilers for vdso and boot wrapper
 CROSS32_COMPILE ?=
 
-ifeq ($(HAS_BIARCH),y)
-ifeq ($(CROSS32_COMPILE),)
-ifdef CONFIG_PPC32
-# These options will be overridden by any -mcpu option that the CPU
-# or platform code sets later on the command line, but they are needed
-# to set a sane 32-bit cpu target for the 64-bit cross compiler which
-# may default to the wrong ISA.
-KBUILD_CFLAGS		+= -mcpu=powerpc
-KBUILD_AFLAGS		+= -mcpu=powerpc
-endif
-endif
-endif
-
-ifdef CONFIG_PPC_BOOK3S_32
-KBUILD_CFLAGS		+= -mcpu=powerpc
-endif
-
 # If we're on a ppc/ppc64/ppc64le machine use that defconfig, otherwise just use
 # ppc64_defconfig because we have nothing better to go on.
 uname := $(shell uname -m)
@@ -183,6 +166,7 @@ endif
 endif
 
 CFLAGS-$(CONFIG_TARGET_CPU_BOOL) += $(call cc-option,-mcpu=$(CONFIG_TARGET_CPU))
+AFLAGS-$(CONFIG_TARGET_CPU_BOOL) += $(call cc-option,-mcpu=$(CONFIG_TARGET_CPU))
 
 # Altivec option not allowed with e500mc64 in GCC.
 ifdef CONFIG_ALTIVEC
@@ -193,14 +177,6 @@ endif
 CFLAGS-$(CONFIG_E5500_CPU) += $(E5500_CPU)
 CFLAGS-$(CONFIG_E6500_CPU) += $(call cc-option,-mcpu=e6500,$(E5500_CPU))
 
-ifdef CONFIG_PPC32
-ifdef CONFIG_PPC_E500MC
-CFLAGS-y += $(call cc-option,-mcpu=e500mc,-mcpu=powerpc)
-else
-CFLAGS-$(CONFIG_E500) += $(call cc-option,-mcpu=8540 -msoft-float,-mcpu=powerpc)
-endif
-endif
-
 asinstr := $(call as-instr,lis 9$(comma)foo@high,-DHAVE_AS_ATHIGH=1)
 
 KBUILD_CPPFLAGS	+= -I $(srctree)/arch/$(ARCH) $(asinstr)
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index 9e2df4b66478..198f1c1c58ef 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -136,9 +136,9 @@ config GENERIC_CPU
 	select ARCH_HAS_FAST_MULTIPLIER
 	select PPC_64S_HASH_MMU
 
-config GENERIC_CPU
+config POWERPC_CPU
 	bool "Generic 32 bits powerpc"
-	depends on PPC32 && !PPC_8xx
+	depends on PPC32 && !PPC_8xx && !PPC_85xx
 
 config CELL_CPU
 	bool "Cell Broadband Engine"
@@ -197,11 +197,23 @@ config G4_CPU
 	depends on PPC_BOOK3S_32
 	select ALTIVEC
 
+config E500_CPU
+	bool "e500 (8540)"
+	depends on PPC_85xx && !PPC_E500MC
+
+config E500MC_CPU
+	bool "e500mc"
+	depends on PPC_85xx && PPC_E500MC
+
+config TOOLCHAIN_DEFAULT_CPU
+	bool "Rely on the toolchain's implicit default CPU"
+	depends on PPC32
+
 endchoice
 
 config TARGET_CPU_BOOL
 	bool
-	default !GENERIC_CPU
+	default !GENERIC_CPU && !TOOLCHAIN_DEFAULT_CPU
 
 config TARGET_CPU
 	string
@@ -216,6 +228,9 @@ config TARGET_CPU
 	default "e300c2" if E300C2_CPU
 	default "e300c3" if E300C3_CPU
 	default "G4" if G4_CPU
+	default "8540" if E500_CPU
+	default "e500mc" if E500MC_CPU
+	default "powerpc" if POWERPC_CPU
 
 config PPC_BOOK3S
 	def_bool y
-- 
2.35.1

