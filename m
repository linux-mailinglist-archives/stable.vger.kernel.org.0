Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAF5A1EA9FC
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729187AbgFASEJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:04:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730160AbgFASEI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:04:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B0A42074B;
        Mon,  1 Jun 2020 18:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034646;
        bh=Dyh1HFr/hMeXDBKF4xrHfraUrfZYZpeA+6iF6/j00lU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GMnbY4QDV66dp7iLfPpfWpvv0PsNjPr9m5l0RFrrB/8kNW6iaEqxSzIUsDZ1xkscl
         Ymp7p77ged7HY3zNk++HjkQfHEdnCcStDEbtph645f5g0OwLW5ZMtoQlgSspnm27gw
         ypEa04gdy5zfUvY914V68wroDkmou7qyf31MOFyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 47/95] ARM: uaccess: consolidate uaccess asm to asm/uaccess-asm.h
Date:   Mon,  1 Jun 2020 19:53:47 +0200
Message-Id: <20200601174028.239653484@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174020.759151073@linuxfoundation.org>
References: <20200601174020.759151073@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit 747ffc2fcf969eff9309d7f2d1d61cb8b9e1bb40 ]

Consolidate the user access assembly code to asm/uaccess-asm.h.  This
moves the csdb, check_uaccess, uaccess_mask_range_ptr, uaccess_enable,
uaccess_disable, uaccess_save, uaccess_restore macros, and creates two
new ones for exception entry and exit - uaccess_entry and uaccess_exit.

This makes the uaccess_save and uaccess_restore macros private to
asm/uaccess-asm.h.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/include/asm/assembler.h   |  75 +-------------------
 arch/arm/include/asm/uaccess-asm.h | 106 +++++++++++++++++++++++++++++
 arch/arm/kernel/entry-armv.S       |  11 +--
 arch/arm/kernel/entry-header.S     |   9 +--
 4 files changed, 112 insertions(+), 89 deletions(-)
 create mode 100644 arch/arm/include/asm/uaccess-asm.h

diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
index 965224d14e6c..1935b580f0e8 100644
--- a/arch/arm/include/asm/assembler.h
+++ b/arch/arm/include/asm/assembler.h
@@ -21,11 +21,11 @@
 #endif
 
 #include <asm/ptrace.h>
-#include <asm/domain.h>
 #include <asm/opcodes-virt.h>
 #include <asm/asm-offsets.h>
 #include <asm/page.h>
 #include <asm/thread_info.h>
+#include <asm/uaccess-asm.h>
 
 #define IOMEM(x)	(x)
 
@@ -447,79 +447,6 @@ THUMB(	orr	\reg , \reg , #PSR_T_BIT	)
 	.size \name , . - \name
 	.endm
 
-	.macro	csdb
-#ifdef CONFIG_THUMB2_KERNEL
-	.inst.w	0xf3af8014
-#else
-	.inst	0xe320f014
-#endif
-	.endm
-
-	.macro check_uaccess, addr:req, size:req, limit:req, tmp:req, bad:req
-#ifndef CONFIG_CPU_USE_DOMAINS
-	adds	\tmp, \addr, #\size - 1
-	sbcscc	\tmp, \tmp, \limit
-	bcs	\bad
-#ifdef CONFIG_CPU_SPECTRE
-	movcs	\addr, #0
-	csdb
-#endif
-#endif
-	.endm
-
-	.macro uaccess_mask_range_ptr, addr:req, size:req, limit:req, tmp:req
-#ifdef CONFIG_CPU_SPECTRE
-	sub	\tmp, \limit, #1
-	subs	\tmp, \tmp, \addr	@ tmp = limit - 1 - addr
-	addhs	\tmp, \tmp, #1		@ if (tmp >= 0) {
-	subshs	\tmp, \tmp, \size	@ tmp = limit - (addr + size) }
-	movlo	\addr, #0		@ if (tmp < 0) addr = NULL
-	csdb
-#endif
-	.endm
-
-	.macro	uaccess_disable, tmp, isb=1
-#ifdef CONFIG_CPU_SW_DOMAIN_PAN
-	/*
-	 * Whenever we re-enter userspace, the domains should always be
-	 * set appropriately.
-	 */
-	mov	\tmp, #DACR_UACCESS_DISABLE
-	mcr	p15, 0, \tmp, c3, c0, 0		@ Set domain register
-	.if	\isb
-	instr_sync
-	.endif
-#endif
-	.endm
-
-	.macro	uaccess_enable, tmp, isb=1
-#ifdef CONFIG_CPU_SW_DOMAIN_PAN
-	/*
-	 * Whenever we re-enter userspace, the domains should always be
-	 * set appropriately.
-	 */
-	mov	\tmp, #DACR_UACCESS_ENABLE
-	mcr	p15, 0, \tmp, c3, c0, 0
-	.if	\isb
-	instr_sync
-	.endif
-#endif
-	.endm
-
-	.macro	uaccess_save, tmp
-#ifdef CONFIG_CPU_SW_DOMAIN_PAN
-	mrc	p15, 0, \tmp, c3, c0, 0
-	str	\tmp, [sp, #SVC_DACR]
-#endif
-	.endm
-
-	.macro	uaccess_restore
-#ifdef CONFIG_CPU_SW_DOMAIN_PAN
-	ldr	r0, [sp, #SVC_DACR]
-	mcr	p15, 0, r0, c3, c0, 0
-#endif
-	.endm
-
 	.irp	c,,eq,ne,cs,cc,mi,pl,vs,vc,hi,ls,ge,lt,gt,le,hs,lo
 	.macro	ret\c, reg
 #if __LINUX_ARM_ARCH__ < 6
diff --git a/arch/arm/include/asm/uaccess-asm.h b/arch/arm/include/asm/uaccess-asm.h
new file mode 100644
index 000000000000..d475e3e8145d
--- /dev/null
+++ b/arch/arm/include/asm/uaccess-asm.h
@@ -0,0 +1,106 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef __ASM_UACCESS_ASM_H__
+#define __ASM_UACCESS_ASM_H__
+
+#include <asm/asm-offsets.h>
+#include <asm/domain.h>
+#include <asm/memory.h>
+#include <asm/thread_info.h>
+
+	.macro	csdb
+#ifdef CONFIG_THUMB2_KERNEL
+	.inst.w	0xf3af8014
+#else
+	.inst	0xe320f014
+#endif
+	.endm
+
+	.macro check_uaccess, addr:req, size:req, limit:req, tmp:req, bad:req
+#ifndef CONFIG_CPU_USE_DOMAINS
+	adds	\tmp, \addr, #\size - 1
+	sbcscc	\tmp, \tmp, \limit
+	bcs	\bad
+#ifdef CONFIG_CPU_SPECTRE
+	movcs	\addr, #0
+	csdb
+#endif
+#endif
+	.endm
+
+	.macro uaccess_mask_range_ptr, addr:req, size:req, limit:req, tmp:req
+#ifdef CONFIG_CPU_SPECTRE
+	sub	\tmp, \limit, #1
+	subs	\tmp, \tmp, \addr	@ tmp = limit - 1 - addr
+	addhs	\tmp, \tmp, #1		@ if (tmp >= 0) {
+	subshs	\tmp, \tmp, \size	@ tmp = limit - (addr + size) }
+	movlo	\addr, #0		@ if (tmp < 0) addr = NULL
+	csdb
+#endif
+	.endm
+
+	.macro	uaccess_disable, tmp, isb=1
+#ifdef CONFIG_CPU_SW_DOMAIN_PAN
+	/*
+	 * Whenever we re-enter userspace, the domains should always be
+	 * set appropriately.
+	 */
+	mov	\tmp, #DACR_UACCESS_DISABLE
+	mcr	p15, 0, \tmp, c3, c0, 0		@ Set domain register
+	.if	\isb
+	instr_sync
+	.endif
+#endif
+	.endm
+
+	.macro	uaccess_enable, tmp, isb=1
+#ifdef CONFIG_CPU_SW_DOMAIN_PAN
+	/*
+	 * Whenever we re-enter userspace, the domains should always be
+	 * set appropriately.
+	 */
+	mov	\tmp, #DACR_UACCESS_ENABLE
+	mcr	p15, 0, \tmp, c3, c0, 0
+	.if	\isb
+	instr_sync
+	.endif
+#endif
+	.endm
+
+	.macro	uaccess_save, tmp
+#ifdef CONFIG_CPU_SW_DOMAIN_PAN
+	mrc	p15, 0, \tmp, c3, c0, 0
+	str	\tmp, [sp, #SVC_DACR]
+#endif
+	.endm
+
+	.macro	uaccess_restore
+#ifdef CONFIG_CPU_SW_DOMAIN_PAN
+	ldr	r0, [sp, #SVC_DACR]
+	mcr	p15, 0, r0, c3, c0, 0
+#endif
+	.endm
+
+	/*
+	 * Save the address limit on entry to a privileged exception and
+	 * if using PAN, save and disable usermode access.
+	 */
+	.macro	uaccess_entry, tsk, tmp0, tmp1, tmp2, disable
+	ldr	\tmp0, [\tsk, #TI_ADDR_LIMIT]
+	mov	\tmp1, #TASK_SIZE
+	str	\tmp1, [\tsk, #TI_ADDR_LIMIT]
+	str	\tmp0, [sp, #SVC_ADDR_LIMIT]
+	uaccess_save \tmp0
+	.if \disable
+	uaccess_disable \tmp0
+	.endif
+	.endm
+
+	/* Restore the user access state previously saved by uaccess_entry */
+	.macro	uaccess_exit, tsk, tmp0, tmp1
+	ldr	\tmp1, [sp, #SVC_ADDR_LIMIT]
+	uaccess_restore
+	str	\tmp1, [\tsk, #TI_ADDR_LIMIT]
+	.endm
+
+#endif /* __ASM_UACCESS_ASM_H__ */
diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index e85a3af9ddeb..89e551eebff1 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -30,6 +30,7 @@
 #include <asm/unistd.h>
 #include <asm/tls.h>
 #include <asm/system_info.h>
+#include <asm/uaccess-asm.h>
 
 #include "entry-header.S"
 #include <asm/entry-macro-multi.S>
@@ -182,15 +183,7 @@ ENDPROC(__und_invalid)
 	stmia	r7, {r2 - r6}
 
 	get_thread_info tsk
-	ldr	r0, [tsk, #TI_ADDR_LIMIT]
-	mov	r1, #TASK_SIZE
-	str	r1, [tsk, #TI_ADDR_LIMIT]
-	str	r0, [sp, #SVC_ADDR_LIMIT]
-
-	uaccess_save r0
-	.if \uaccess
-	uaccess_disable r0
-	.endif
+	uaccess_entry tsk, r0, r1, r2, \uaccess
 
 	.if \trace
 #ifdef CONFIG_TRACE_IRQFLAGS
diff --git a/arch/arm/kernel/entry-header.S b/arch/arm/kernel/entry-header.S
index 62db1c9746cb..7b595f2d4a28 100644
--- a/arch/arm/kernel/entry-header.S
+++ b/arch/arm/kernel/entry-header.S
@@ -6,6 +6,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/errno.h>
 #include <asm/thread_info.h>
+#include <asm/uaccess-asm.h>
 #include <asm/v7m.h>
 
 @ Bad Abort numbers
@@ -217,9 +218,7 @@
 	blne	trace_hardirqs_off
 #endif
 	.endif
-	ldr	r1, [sp, #SVC_ADDR_LIMIT]
-	uaccess_restore
-	str	r1, [tsk, #TI_ADDR_LIMIT]
+	uaccess_exit tsk, r0, r1
 
 #ifndef CONFIG_THUMB2_KERNEL
 	@ ARM mode SVC restore
@@ -263,9 +262,7 @@
 	@ on the stack remains correct).
 	@
 	.macro  svc_exit_via_fiq
-	ldr	r1, [sp, #SVC_ADDR_LIMIT]
-	uaccess_restore
-	str	r1, [tsk, #TI_ADDR_LIMIT]
+	uaccess_exit tsk, r0, r1
 #ifndef CONFIG_THUMB2_KERNEL
 	@ ARM mode restore
 	mov	r0, sp
-- 
2.25.1



