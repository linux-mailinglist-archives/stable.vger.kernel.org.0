Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82F97F4BBF
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbfKHMgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:36:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:43876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbfKHMgV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 07:36:21 -0500
Received: from localhost.localdomain (lfbn-mar-1-550-151.w90-118.abo.wanadoo.fr [90.118.131.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3300B22466;
        Fri,  8 Nov 2019 12:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573216580;
        bh=ZGlooRu68ALzwcRr49X3h4MeIPaVrWziQxRIRV/+AUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dqhpvi2tklL5WdCKsvHk0ElP1/lXcmNjARiW0M6LUZGRVQIoJts/4Mw55SHWB+QJx
         3h8Y8Ga3zV+FPhrw7z6mLU0AQcXdV+hooKuCLl3t7UOlJOK54feiwsEADd61wXIitn
         pOhXQXoXhGCtY7J8Y5sV+KP2vw73Xa270A/UM9rA=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     stable@vger.kernel.org
Cc:     linus.walleij@linaro.org, rmk+kernel@armlinux.org.uk,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH for-stable-4.4 05/50] ARM: 8481/2: drivers: psci: replace psci firmware calls
Date:   Fri,  8 Nov 2019 13:35:09 +0100
Message-Id: <20191108123554.29004-6-ardb@kernel.org>
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

Commit e679660dbb8347f275fe5d83a5dd59c1fb6c8e63 upstream.

Switch to use a generic interface for issuing SMC/HVC based on ARM SMC
Calling Convention. Removes now the now unused psci-call.S.

Acked-by: Will Deacon <will.deacon@arm.com>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Tested-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Tested-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/Kconfig              |  2 +-
 arch/arm/kernel/Makefile      |  1 -
 arch/arm/kernel/psci-call.S   | 31 --------------------
 arch/arm64/kernel/Makefile    |  2 +-
 arch/arm64/kernel/psci-call.S | 28 ------------------
 drivers/firmware/psci.c       | 23 +++++++++++++--
 6 files changed, 23 insertions(+), 64 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index ef742bacd568..2ba69df49cf8 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1482,7 +1482,7 @@ config HOTPLUG_CPU
 
 config ARM_PSCI
 	bool "Support for the ARM Power State Coordination Interface (PSCI)"
-	depends on CPU_V7
+	depends on HAVE_ARM_SMCCC
 	select ARM_PSCI_FW
 	help
 	  Say Y here if you want Linux to communicate with system firmware
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 599c950468fc..82bdac0f2804 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -87,7 +87,6 @@ obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 
 obj-$(CONFIG_ARM_VIRT_EXT)	+= hyp-stub.o
 ifeq ($(CONFIG_ARM_PSCI),y)
-obj-y				+= psci-call.o
 obj-$(CONFIG_SMP)		+= psci_smp.o
 endif
 
diff --git a/arch/arm/kernel/psci-call.S b/arch/arm/kernel/psci-call.S
deleted file mode 100644
index a78e9e1e206d..000000000000
--- a/arch/arm/kernel/psci-call.S
+++ /dev/null
@@ -1,31 +0,0 @@
-/*
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * Copyright (C) 2015 ARM Limited
- *
- * Author: Mark Rutland <mark.rutland@arm.com>
- */
-
-#include <linux/linkage.h>
-
-#include <asm/opcodes-sec.h>
-#include <asm/opcodes-virt.h>
-
-/* int __invoke_psci_fn_hvc(u32 function_id, u32 arg0, u32 arg1, u32 arg2) */
-ENTRY(__invoke_psci_fn_hvc)
-	__HVC(0)
-	bx	lr
-ENDPROC(__invoke_psci_fn_hvc)
-
-/* int __invoke_psci_fn_smc(u32 function_id, u32 arg0, u32 arg1, u32 arg2) */
-ENTRY(__invoke_psci_fn_smc)
-	__SMC(0)
-	bx	lr
-ENDPROC(__invoke_psci_fn_smc)
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 0170bea3d4ae..27bf1e5180a1 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -14,7 +14,7 @@ CFLAGS_REMOVE_return_address.o = -pg
 arm64-obj-y		:= debug-monitors.o entry.o irq.o fpsimd.o		\
 			   entry-fpsimd.o process.o ptrace.o setup.o signal.o	\
 			   sys.o stacktrace.o time.o traps.o io.o vdso.o	\
-			   hyp-stub.o psci.o psci-call.o cpu_ops.o insn.o	\
+			   hyp-stub.o psci.o cpu_ops.o insn.o	\
 			   return_address.o cpuinfo.o cpu_errata.o		\
 			   cpufeature.o alternative.o cacheinfo.o		\
 			   smp.o smp_spin_table.o topology.o smccc-call.o
diff --git a/arch/arm64/kernel/psci-call.S b/arch/arm64/kernel/psci-call.S
deleted file mode 100644
index cf83e61cd3b5..000000000000
--- a/arch/arm64/kernel/psci-call.S
+++ /dev/null
@@ -1,28 +0,0 @@
-/*
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * Copyright (C) 2015 ARM Limited
- *
- * Author: Will Deacon <will.deacon@arm.com>
- */
-
-#include <linux/linkage.h>
-
-/* int __invoke_psci_fn_hvc(u64 function_id, u64 arg0, u64 arg1, u64 arg2) */
-ENTRY(__invoke_psci_fn_hvc)
-	hvc	#0
-	ret
-ENDPROC(__invoke_psci_fn_hvc)
-
-/* int __invoke_psci_fn_smc(u64 function_id, u64 arg0, u64 arg1, u64 arg2) */
-ENTRY(__invoke_psci_fn_smc)
-	smc	#0
-	ret
-ENDPROC(__invoke_psci_fn_smc)
diff --git a/drivers/firmware/psci.c b/drivers/firmware/psci.c
index ae70d2485ca1..b38305ba0965 100644
--- a/drivers/firmware/psci.c
+++ b/drivers/firmware/psci.c
@@ -13,6 +13,7 @@
 
 #define pr_fmt(fmt) "psci: " fmt
 
+#include <linux/arm-smccc.h>
 #include <linux/errno.h>
 #include <linux/linkage.h>
 #include <linux/of.h>
@@ -58,8 +59,6 @@ struct psci_operations psci_ops;
 
 typedef unsigned long (psci_fn)(unsigned long, unsigned long,
 				unsigned long, unsigned long);
-asmlinkage psci_fn __invoke_psci_fn_hvc;
-asmlinkage psci_fn __invoke_psci_fn_smc;
 static psci_fn *invoke_psci_fn;
 
 enum psci_function {
@@ -107,6 +106,26 @@ bool psci_power_state_is_valid(u32 state)
 	return !(state & ~valid_mask);
 }
 
+static unsigned long __invoke_psci_fn_hvc(unsigned long function_id,
+			unsigned long arg0, unsigned long arg1,
+			unsigned long arg2)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_hvc(function_id, arg0, arg1, arg2, 0, 0, 0, 0, &res);
+	return res.a0;
+}
+
+static unsigned long __invoke_psci_fn_smc(unsigned long function_id,
+			unsigned long arg0, unsigned long arg1,
+			unsigned long arg2)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_smc(function_id, arg0, arg1, arg2, 0, 0, 0, 0, &res);
+	return res.a0;
+}
+
 static int psci_to_linux_errno(int errno)
 {
 	switch (errno) {
-- 
2.20.1

