Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9E766040C8
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbiJSKRg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbiJSKQl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:16:41 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC0D410B787;
        Wed, 19 Oct 2022 02:57:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E1A31CE2183;
        Wed, 19 Oct 2022 09:05:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C259AC433D6;
        Wed, 19 Oct 2022 09:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170346;
        bh=QR0ElYQy4q9YU76kzPzxhsB29u2pO0wfg3SgVquJrmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PTWlcAdbs2+3mf/yztbuU6JzEwarjj6pmA39ukFlsEZp2OC7I9rzxUOh0nt+dp3cq
         rP0iHMC3Bk/gISPkuJdPO/73zIjXgoEeYwq4FMG8ntW068G+rfvyaeVqQsazTwLzyz
         N7r+k+4jT6ED+2/D3IHnGdEbdYs6y8vfw+2rLx9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 620/862] powerpc/64/interrupt: Fix return to masked context after hard-mask irq becomes pending
Date:   Wed, 19 Oct 2022 10:31:47 +0200
Message-Id: <20221019083317.332868643@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 0e75cb03244a..f9db0a172401 100644
--- a/arch/powerpc/kernel/interrupt.c
+++ b/arch/powerpc/kernel/interrupt.c
@@ -431,16 +431,6 @@ notrace unsigned long interrupt_exit_kernel_prepare(struct pt_regs *regs)
 
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



