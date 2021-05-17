Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C941A38303F
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237469AbhEQOZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:25:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:38294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239057AbhEQOXY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:23:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B2486148E;
        Mon, 17 May 2021 14:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260748;
        bh=GbnpfRmvKGfTGeUaimrTOyM/DF0LtbD3kvDMlf3aLpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=er+KMbF6IDWmYipGdJf+gNhsWEtAKdVEKt8DDC0Q/DO28cAGuKY+yNsN6HaiXAIBV
         b7AdU96ZFUfTgFbSfa/j4psk0eJGC0mtGjNMLBIr9ukQ8BC+C/PIOhRbQQ/6DBf8Zo
         Q7s0d+AeDOiNeuEy8zWZDm/WR6IniuWB8X6hTKRU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Hector Martin <marcan@marcan.st>,
        James Morse <james.morse@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 215/363] arm64: entry: factor irq triage logic into macros
Date:   Mon, 17 May 2021 16:01:21 +0200
Message-Id: <20210517140309.843207262@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 9eb563cdabe1d583c262042d5d44cc256f644543 ]

In subsequent patches we'll allow an FIQ handler to be registered, and
FIQ exceptions will need to be triaged very similarly to IRQ exceptions.
So that we can reuse the existing logic, this patch factors the IRQ
triage logic out into macros that can be reused for FIQ.

The macros are named to follow the elX_foo_handler scheme used by the C
exception handlers. For consistency with other top-level exception
handlers, the kernel_entry/kernel_exit logic is not moved into the
macros. As FIQ will use a different C handler, this handler name is
provided as an argument to the macros.

There should be no functional change as a result of this patch.

Signed-off-by: Marc Zyngier <maz@kernel.org>
[Mark: rework macros, commit message, rebase before DAIF rework]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Tested-by: Hector Martin <marcan@marcan.st>
Cc: James Morse <james.morse@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20210315115629.57191-5-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/entry.S | 80 +++++++++++++++++++++------------------
 1 file changed, 43 insertions(+), 37 deletions(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 9b205744a233..feb9e4b9f9f2 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -493,8 +493,8 @@ tsk	.req	x28		// current thread_info
 /*
  * Interrupt handling.
  */
-	.macro	irq_handler
-	ldr_l	x1, handle_arch_irq
+	.macro	irq_handler, handler:req
+	ldr_l	x1, \handler
 	mov	x0, sp
 	irq_stack_entry
 	blr	x1
@@ -533,6 +533,45 @@ alternative_endif
 #endif
 	.endm
 
+	.macro el1_interrupt_handler, handler:req
+	gic_prio_irq_setup pmr=x20, tmp=x1
+	enable_da_f
+
+	mov	x0, sp
+	bl	enter_el1_irq_or_nmi
+
+	irq_handler	\handler
+
+#ifdef CONFIG_PREEMPTION
+	ldr	x24, [tsk, #TSK_TI_PREEMPT]	// get preempt count
+alternative_if ARM64_HAS_IRQ_PRIO_MASKING
+	/*
+	 * DA_F were cleared at start of handling. If anything is set in DAIF,
+	 * we come back from an NMI, so skip preemption
+	 */
+	mrs	x0, daif
+	orr	x24, x24, x0
+alternative_else_nop_endif
+	cbnz	x24, 1f				// preempt count != 0 || NMI return path
+	bl	arm64_preempt_schedule_irq	// irq en/disable is done inside
+1:
+#endif
+
+	mov	x0, sp
+	bl	exit_el1_irq_or_nmi
+	.endm
+
+	.macro el0_interrupt_handler, handler:req
+	gic_prio_irq_setup pmr=x20, tmp=x0
+	user_exit_irqoff
+	enable_da_f
+
+	tbz	x22, #55, 1f
+	bl	do_el0_irq_bp_hardening
+1:
+	irq_handler	\handler
+	.endm
+
 	.text
 
 /*
@@ -662,32 +701,7 @@ SYM_CODE_END(el1_sync)
 	.align	6
 SYM_CODE_START_LOCAL_NOALIGN(el1_irq)
 	kernel_entry 1
-	gic_prio_irq_setup pmr=x20, tmp=x1
-	enable_da_f
-
-	mov	x0, sp
-	bl	enter_el1_irq_or_nmi
-
-	irq_handler
-
-#ifdef CONFIG_PREEMPTION
-	ldr	x24, [tsk, #TSK_TI_PREEMPT]	// get preempt count
-alternative_if ARM64_HAS_IRQ_PRIO_MASKING
-	/*
-	 * DA_F were cleared at start of handling. If anything is set in DAIF,
-	 * we come back from an NMI, so skip preemption
-	 */
-	mrs	x0, daif
-	orr	x24, x24, x0
-alternative_else_nop_endif
-	cbnz	x24, 1f				// preempt count != 0 || NMI return path
-	bl	arm64_preempt_schedule_irq	// irq en/disable is done inside
-1:
-#endif
-
-	mov	x0, sp
-	bl	exit_el1_irq_or_nmi
-
+	el1_interrupt_handler handle_arch_irq
 	kernel_exit 1
 SYM_CODE_END(el1_irq)
 
@@ -727,15 +741,7 @@ SYM_CODE_END(el0_error_compat)
 SYM_CODE_START_LOCAL_NOALIGN(el0_irq)
 	kernel_entry 0
 el0_irq_naked:
-	gic_prio_irq_setup pmr=x20, tmp=x0
-	user_exit_irqoff
-	enable_da_f
-
-	tbz	x22, #55, 1f
-	bl	do_el0_irq_bp_hardening
-1:
-	irq_handler
-
+	el0_interrupt_handler handle_arch_irq
 	b	ret_to_user
 SYM_CODE_END(el0_irq)
 
-- 
2.30.2



