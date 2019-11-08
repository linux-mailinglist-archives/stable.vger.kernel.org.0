Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C35C7F53F7
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 19:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732061AbfKHSxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 13:53:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:49444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732030AbfKHSxB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:53:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0592214DB;
        Fri,  8 Nov 2019 18:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239179;
        bh=3z24VMb6w2aEusAaHy6nE0web8vjYf2I0RI5Q+3sXNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GVxJS/RHh4/fU/DaUIxKITCgZ+g7F6pEQWkhL9zVWa14nwZeaOYwjHnLlA1exioBf
         7PXSnFgrl+47XdEwerUgPDp2TcuMPXuPe12Efq66f+vIAyQ7YRrKtlgREjtZRcwHsc
         FtpXItvdpHeQIBpwnWqCzH33R3UdRLMElQubW/00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lars Persson <lars.persson@axis.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 4.4 26/75] ARM: 8479/2: add implementation for arm-smccc
Date:   Fri,  8 Nov 2019 19:49:43 +0100
Message-Id: <20191108174733.563457851@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174708.135680837@linuxfoundation.org>
References: <20191108174708.135680837@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Wiklander <jens.wiklander@linaro.org>

Commit b329f95d70f3f955093e9a2b18ac1ed3587a8f73 upstream.

Adds implementation for arm-smccc and enables CONFIG_HAVE_SMCCC for
architectures that may support arm-smccc. It's the responsibility of the
caller to know if the SMC instruction is supported by the platform.

Reviewed-by: Lars Persson <lars.persson@axis.com>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/Kconfig             |    1 
 arch/arm/kernel/Makefile     |    2 +
 arch/arm/kernel/armksyms.c   |    6 ++++
 arch/arm/kernel/smccc-call.S |   62 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 71 insertions(+)

--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -37,6 +37,7 @@ config ARM
 	select HAVE_ARCH_KGDB if !CPU_ENDIAN_BE32
 	select HAVE_ARCH_SECCOMP_FILTER if (AEABI && !OABI_COMPAT)
 	select HAVE_ARCH_TRACEHOOK
+	select HAVE_ARM_SMCCC if CPU_V7
 	select HAVE_BPF_JIT
 	select HAVE_CC_STACKPROTECTOR
 	select HAVE_CONTEXT_TRACKING
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -91,4 +91,6 @@ obj-y				+= psci-call.o
 obj-$(CONFIG_SMP)		+= psci_smp.o
 endif
 
+obj-$(CONFIG_HAVE_ARM_SMCCC)	+= smccc-call.o
+
 extra-y := $(head-y) vmlinux.lds
--- a/arch/arm/kernel/armksyms.c
+++ b/arch/arm/kernel/armksyms.c
@@ -16,6 +16,7 @@
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
+#include <linux/arm-smccc.h>
 
 #include <asm/checksum.h>
 #include <asm/ftrace.h>
@@ -175,3 +176,8 @@ EXPORT_SYMBOL(__gnu_mcount_nc);
 EXPORT_SYMBOL(__pv_phys_pfn_offset);
 EXPORT_SYMBOL(__pv_offset);
 #endif
+
+#ifdef CONFIG_HAVE_ARM_SMCCC
+EXPORT_SYMBOL(arm_smccc_smc);
+EXPORT_SYMBOL(arm_smccc_hvc);
+#endif
--- /dev/null
+++ b/arch/arm/kernel/smccc-call.S
@@ -0,0 +1,62 @@
+/*
+ * Copyright (c) 2015, Linaro Limited
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#include <linux/linkage.h>
+
+#include <asm/opcodes-sec.h>
+#include <asm/opcodes-virt.h>
+#include <asm/unwind.h>
+
+	/*
+	 * Wrap c macros in asm macros to delay expansion until after the
+	 * SMCCC asm macro is expanded.
+	 */
+	.macro SMCCC_SMC
+	__SMC(0)
+	.endm
+
+	.macro SMCCC_HVC
+	__HVC(0)
+	.endm
+
+	.macro SMCCC instr
+UNWIND(	.fnstart)
+	mov	r12, sp
+	push	{r4-r7}
+UNWIND(	.save	{r4-r7})
+	ldm	r12, {r4-r7}
+	\instr
+	pop	{r4-r7}
+	ldr	r12, [sp, #(4 * 4)]
+	stm	r12, {r0-r3}
+	bx	lr
+UNWIND(	.fnend)
+	.endm
+
+/*
+ * void smccc_smc(unsigned long a0, unsigned long a1, unsigned long a2,
+ *		  unsigned long a3, unsigned long a4, unsigned long a5,
+ *		  unsigned long a6, unsigned long a7, struct arm_smccc_res *res)
+ */
+ENTRY(arm_smccc_smc)
+	SMCCC SMCCC_SMC
+ENDPROC(arm_smccc_smc)
+
+/*
+ * void smccc_hvc(unsigned long a0, unsigned long a1, unsigned long a2,
+ *		  unsigned long a3, unsigned long a4, unsigned long a5,
+ *		  unsigned long a6, unsigned long a7, struct arm_smccc_res *res)
+ */
+ENTRY(arm_smccc_hvc)
+	SMCCC SMCCC_HVC
+ENDPROC(arm_smccc_hvc)


