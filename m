Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D09926088D4
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbiJVIXV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233819AbiJVIVS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:21:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3742E0433;
        Sat, 22 Oct 2022 00:58:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E508760B1F;
        Sat, 22 Oct 2022 07:57:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E486CC433C1;
        Sat, 22 Oct 2022 07:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425441;
        bh=js3v98GcGKRV1eEWcT7nHaJQYSSKM8ZDnkx4SxjvrwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p9QJ237KjH8bjoPO7QbhzHmlC0afNSf0Jy7Of6bAmkVpWJXdtjhn2YUznlQYfgar7
         3YMl04xUFSvOXaeYf3GZOeYpu6dOV/GJuXEjMv7MlF+4UUKL9OXbEQZrB7Q9j/Xzxh
         8rspNIcpVvg6M5QED4rpH/xjM8kjC7tyanhaznrE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 503/717] powerpc/64/interrupt: Fix return to masked context after hard-mask irq becomes pending
Date:   Sat, 22 Oct 2022 09:26:22 +0200
Message-Id: <20221022072520.514630503@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit e485f6c751e0a969327336c635ca602feea117f0 ]

If a synchronous interrupt (e.g., hash fault) is taken inside an
irqs-disabled region which has MSR[EE]=1, then an asynchronous interrupt
that is PACA_IRQ_MUST_HARD_MASK (e.g., PMI) is taken inside the
synchronous interrupt handler, then the synchronous interrupt will
return with MSR[EE]=1 and the asynchronous interrupt fires again.

If the asynchronous interrupt is a PMI and the original context does not
have PMIs disabled (only Linux IRQs), the asynchronous interrupt will
fire despite having the PMI marked soft pending. This can confuse the
perf code and cause warnings.

This patch changes the interrupt return so that irqs-disabled MSR[EE]=1
contexts will be returned to with MSR[EE]=0 if a PACA_IRQ_MUST_HARD_MASK
interrupt has become pending in the meantime.

The longer explanation for what happens:
1. local_irq_disable()
2. Hash fault interrupt fires, do_hash_fault handler runs
3. interrupt_enter_prepare() sets IRQS_ALL_DISABLED
4. interrupt_enter_prepare() sets MSR[EE]=1
5. PMU interrupt fires, masked handler runs
6. Masked handler marks PMI pending
7. Masked handler returns with PACA_IRQ_HARD_DIS set, MSR[EE]=0
8. do_hash_fault interrupt return handler runs
9. interrupt_exit_kernel_prepare() clears PACA_IRQ_HARD_DIS
10. interrupt returns with MSR[EE]=1
11. PMU interrupt fires, perf handler runs

Fixes: 4423eb5ae32e ("powerpc/64/interrupt: make normal synchronous interrupts enable MSR[EE] if possible")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220926054305.2671436-4-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/interrupt.c    | 10 ---------
 arch/powerpc/kernel/interrupt_64.S | 34 +++++++++++++++++++++++++++---
 2 files changed, 31 insertions(+), 13 deletions(-)

diff --git a/arch/powerpc/kernel/interrupt.c b/arch/powerpc/kernel/interrupt.c
index 784ea3289c84..0b656b897f99 100644
--- a/arch/powerpc/kernel/interrupt.c
+++ b/arch/powerpc/kernel/interrupt.c
@@ -592,16 +592,6 @@ notrace unsigned long interrupt_exit_kernel_prepare(struct pt_regs *regs)
 
 		if (unlikely(stack_store))
 			__hard_EE_RI_disable();
-		/*
-		 * Returning to a kernel context with local irqs disabled.
-		 * Here, if EE was enabled in the interrupted context, enable
-		 * it on return as well. A problem exists here where a soft
-		 * masked interrupt may have cleared MSR[EE] and set HARD_DIS
-		 * here, and it will still exist on return to the caller. This
-		 * will be resolved by the masked interrupt firing again.
-		 */
-		if (regs->msr & MSR_EE)
-			local_paca->irq_happened &= ~PACA_IRQ_HARD_DIS;
 #endif /* CONFIG_PPC64 */
 	}
 
diff --git a/arch/powerpc/kernel/interrupt_64.S b/arch/powerpc/kernel/interrupt_64.S
index ce25b28cf418..d76376ce7291 100644
--- a/arch/powerpc/kernel/interrupt_64.S
+++ b/arch/powerpc/kernel/interrupt_64.S
@@ -559,15 +559,43 @@ _ASM_NOKPROBE_SYMBOL(interrupt_return_\srr\()_kernel)
 	ld	r11,SOFTE(r1)
 	cmpwi	r11,IRQS_ENABLED
 	stb	r11,PACAIRQSOFTMASK(r13)
-	bne	1f
+	beq	.Linterrupt_return_\srr\()_soft_enabled
+
+	/*
+	 * Returning to soft-disabled context.
+	 * Check if a MUST_HARD_MASK interrupt has become pending, in which
+	 * case we need to disable MSR[EE] in the return context.
+	 */
+	ld	r12,_MSR(r1)
+	andi.	r10,r12,MSR_EE
+	beq	.Lfast_kernel_interrupt_return_\srr\() // EE already disabled
+	lbz	r11,PACAIRQHAPPENED(r13)
+	andi.	r10,r11,PACA_IRQ_MUST_HARD_MASK
+	beq	1f // No HARD_MASK pending
+
+	/* Must clear MSR_EE from _MSR */
+#ifdef CONFIG_PPC_BOOK3S
+	li	r10,0
+	/* Clear valid before changing _MSR */
+	.ifc \srr,srr
+	stb	r10,PACASRR_VALID(r13)
+	.else
+	stb	r10,PACAHSRR_VALID(r13)
+	.endif
+#endif
+	xori	r12,r12,MSR_EE
+	std	r12,_MSR(r1)
+	b	.Lfast_kernel_interrupt_return_\srr\()
+
+.Linterrupt_return_\srr\()_soft_enabled:
 #ifdef CONFIG_PPC_BOOK3S
 	lbz	r11,PACAIRQHAPPENED(r13)
 	andi.	r11,r11,(~PACA_IRQ_HARD_DIS)@l
 	bne-	interrupt_return_\srr\()_kernel_restart
 #endif
-	li	r11,0
-	stb	r11,PACAIRQHAPPENED(r13) # clear out possible HARD_DIS
 1:
+	li	r11,0
+	stb	r11,PACAIRQHAPPENED(r13) // clear the possible HARD_DIS
 
 .Lfast_kernel_interrupt_return_\srr\():
 	cmpdi	cr1,r3,0
-- 
2.35.1



