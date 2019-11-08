Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB0CF4BBE
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbfKHMgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:36:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:43844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbfKHMgT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 07:36:19 -0500
Received: from localhost.localdomain (lfbn-mar-1-550-151.w90-118.abo.wanadoo.fr [90.118.131.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 801B722459;
        Fri,  8 Nov 2019 12:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573216578;
        bh=Qhze+DAxqnSql1irx5ReBUS36kARlhoQ16aQor49tM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=00/IrQhEl0bYbUl/eTrvS8rTdgFPdbpHpPGBKVCsT8etkALbkRQk9tP/G9zXYsJFa
         XfuZHs7ttBT3QaVWNCEO/k/8FkcdztxCZA+Ait06ZaUWnnzrIqDDrHhlGzwS+WO8/3
         zPKzWxfTELxTMvAOt1h4HCHd8RENUaWrv95IRr8g=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     stable@vger.kernel.org
Cc:     linus.walleij@linaro.org, rmk+kernel@armlinux.org.uk,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH for-stable-4.4 04/50] ARM: 8480/2: arm64: add implementation for arm-smccc
Date:   Fri,  8 Nov 2019 13:35:08 +0100
Message-Id: <20191108123554.29004-5-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108123554.29004-1-ardb@kernel.org>
References: <20191108123554.29004-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Wiklander <jens.wiklander@linaro.org>

Commit 14457459f9ca2ff8521686168ea179edc3a56a44 upstream.

Adds implementation for arm-smccc and enables CONFIG_HAVE_SMCCC.

Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/Kconfig              |  1 +
 arch/arm64/kernel/Makefile      |  2 +-
 arch/arm64/kernel/arm64ksyms.c  |  5 +++
 arch/arm64/kernel/asm-offsets.c |  3 ++
 arch/arm64/kernel/smccc-call.S  | 43 ++++++++++++++++++++
 5 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index f18b8c26a959..644f4326b3e7 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -92,6 +92,7 @@ config ARM64
 	select SPARSE_IRQ
 	select SYSCTL_EXCEPTION_TRACE
 	select HAVE_CONTEXT_TRACKING
+	select HAVE_ARM_SMCCC
 	help
 	  ARM 64-bit (AArch64) Linux support.
 
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 474691f8b13a..0170bea3d4ae 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -17,7 +17,7 @@ arm64-obj-y		:= debug-monitors.o entry.o irq.o fpsimd.o		\
 			   hyp-stub.o psci.o psci-call.o cpu_ops.o insn.o	\
 			   return_address.o cpuinfo.o cpu_errata.o		\
 			   cpufeature.o alternative.o cacheinfo.o		\
-			   smp.o smp_spin_table.o topology.o
+			   smp.o smp_spin_table.o topology.o smccc-call.o
 
 extra-$(CONFIG_EFI)			:= efi-entry.o
 
diff --git a/arch/arm64/kernel/arm64ksyms.c b/arch/arm64/kernel/arm64ksyms.c
index 3b6d8cc9dfe0..678f30b05a45 100644
--- a/arch/arm64/kernel/arm64ksyms.c
+++ b/arch/arm64/kernel/arm64ksyms.c
@@ -26,6 +26,7 @@
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
+#include <linux/arm-smccc.h>
 
 #include <asm/checksum.h>
 
@@ -68,3 +69,7 @@ EXPORT_SYMBOL(test_and_change_bit);
 #ifdef CONFIG_FUNCTION_TRACER
 EXPORT_SYMBOL(_mcount);
 #endif
+
+	/* arm-smccc */
+EXPORT_SYMBOL(arm_smccc_smc);
+EXPORT_SYMBOL(arm_smccc_hvc);
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 087cf9a65359..7c4146a4257b 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -28,6 +28,7 @@
 #include <asm/suspend.h>
 #include <asm/vdso_datapage.h>
 #include <linux/kbuild.h>
+#include <linux/arm-smccc.h>
 
 int main(void)
 {
@@ -162,5 +163,7 @@ int main(void)
   DEFINE(SLEEP_SAVE_SP_PHYS,	offsetof(struct sleep_save_sp, save_ptr_stash_phys));
   DEFINE(SLEEP_SAVE_SP_VIRT,	offsetof(struct sleep_save_sp, save_ptr_stash));
 #endif
+  DEFINE(ARM_SMCCC_RES_X0_OFFS,	offsetof(struct arm_smccc_res, a0));
+  DEFINE(ARM_SMCCC_RES_X2_OFFS,	offsetof(struct arm_smccc_res, a2));
   return 0;
 }
diff --git a/arch/arm64/kernel/smccc-call.S b/arch/arm64/kernel/smccc-call.S
new file mode 100644
index 000000000000..ae0496fa4235
--- /dev/null
+++ b/arch/arm64/kernel/smccc-call.S
@@ -0,0 +1,43 @@
+/*
+ * Copyright (c) 2015, Linaro Limited
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License Version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ */
+#include <linux/linkage.h>
+#include <asm/asm-offsets.h>
+
+	.macro SMCCC instr
+	.cfi_startproc
+	\instr	#0
+	ldr	x4, [sp]
+	stp	x0, x1, [x4, #ARM_SMCCC_RES_X0_OFFS]
+	stp	x2, x3, [x4, #ARM_SMCCC_RES_X2_OFFS]
+	ret
+	.cfi_endproc
+	.endm
+
+/*
+ * void arm_smccc_smc(unsigned long a0, unsigned long a1, unsigned long a2,
+ *		  unsigned long a3, unsigned long a4, unsigned long a5,
+ *		  unsigned long a6, unsigned long a7, struct arm_smccc_res *res)
+ */
+ENTRY(arm_smccc_smc)
+	SMCCC	smc
+ENDPROC(arm_smccc_smc)
+
+/*
+ * void arm_smccc_hvc(unsigned long a0, unsigned long a1, unsigned long a2,
+ *		  unsigned long a3, unsigned long a4, unsigned long a5,
+ *		  unsigned long a6, unsigned long a7, struct arm_smccc_res *res)
+ */
+ENTRY(arm_smccc_hvc)
+	SMCCC	hvc
+ENDPROC(arm_smccc_hvc)
-- 
2.20.1

