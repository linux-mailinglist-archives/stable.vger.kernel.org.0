Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA076AB059
	for <lists+stable@lfdr.de>; Sun,  5 Mar 2023 14:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbjCENzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Mar 2023 08:55:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbjCENyx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Mar 2023 08:54:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A10719697;
        Sun,  5 Mar 2023 05:54:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A284B60B0D;
        Sun,  5 Mar 2023 13:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA88C433EF;
        Sun,  5 Mar 2023 13:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678024405;
        bh=hVaj6og0LbClymWKNGcpAzAKCpHUuhLXZEtvPd4Q1VA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hI+/oyONAZQMqOiVfBjfyj8oldFQOAYNaxrt7JLjkr4jMANeB+DIReTl68FoHYyEq
         OVHz6C9/G76Y+Hc+c4HSLMoYLjzxPOSxvF5JNaa/Pp8AQtve3fqLMaX5TAe6bqotwb
         dnI8rBycVkE0d/8xfGJM3b2KMd8GyYB1Sy+JscVLGmxWzq8RcSOaqWhHBvAqq2utbR
         CY+UcH6pKHp5ijTvPilpkb4HK4Qqy6C8mXtEN57BppXoLEwd/d5lLZj4O+ndETQD2p
         IQ0anWq0kwftfr2J0WFw6FpYxJlYoEqrEewLpZlOqcP/sWOkGjQhhcS/a2dCnwvED0
         8zD2LnbhH7tnQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, christophe.leroy@csgroup.eu,
        pmladek@suse.com, rmclure@linux.ibm.com, bigeasy@linutronix.de,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 6.1 04/15] powerpc/64: Don't recurse irq replay
Date:   Sun,  5 Mar 2023 08:52:55 -0500
Message-Id: <20230305135306.1793564-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230305135306.1793564-1-sashal@kernel.org>
References: <20230305135306.1793564-1-sashal@kernel.org>
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

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 5746ca131e2496ccd5bb4d7a0244d6c38070cbf5 ]

Interrupt handlers called by soft-pending irq replay code can run
softirqs, softirq replay enables and disables local irqs, which allows
interrupts to come in including soft-masked interrupts, and it can
cause pending irqs to be replayed again. That makes the soft irq replay
state machine and possible races more complicated and fragile than it
needs to be.

Use irq_enter/irq_exit around irq replay to prevent softirqs running
while interrupts are being replayed. Softirqs will now be run at the
irq_exit() call after all the irq replaying is done. This prevents irqs
being replayed while irqs are being replayed, and should hopefully make
things simpler and easier to think about and debug.

A new PACA_IRQ_REPLAYING is added to prevent asynchronous interrupt
handlers hard-enabling EE while pending irqs are being replayed, because
that causes new pending irqs to arrive which is also a complexity. This
means pending irqs won't be profiled quite so well because perf irqs
can't be taken.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230121102618.2824429-1-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/hw_irq.h |   6 +-
 arch/powerpc/kernel/irq_64.c      | 101 +++++++++++++++++++-----------
 2 files changed, 70 insertions(+), 37 deletions(-)

diff --git a/arch/powerpc/include/asm/hw_irq.h b/arch/powerpc/include/asm/hw_irq.h
index eb6d094083fd6..317659fdeacf2 100644
--- a/arch/powerpc/include/asm/hw_irq.h
+++ b/arch/powerpc/include/asm/hw_irq.h
@@ -36,15 +36,17 @@
 #define PACA_IRQ_DEC		0x08 /* Or FIT */
 #define PACA_IRQ_HMI		0x10
 #define PACA_IRQ_PMI		0x20
+#define PACA_IRQ_REPLAYING	0x40
 
 /*
  * Some soft-masked interrupts must be hard masked until they are replayed
  * (e.g., because the soft-masked handler does not clear the exception).
+ * Interrupt replay itself must remain hard masked too.
  */
 #ifdef CONFIG_PPC_BOOK3S
-#define PACA_IRQ_MUST_HARD_MASK	(PACA_IRQ_EE|PACA_IRQ_PMI)
+#define PACA_IRQ_MUST_HARD_MASK	(PACA_IRQ_EE|PACA_IRQ_PMI|PACA_IRQ_REPLAYING)
 #else
-#define PACA_IRQ_MUST_HARD_MASK	(PACA_IRQ_EE)
+#define PACA_IRQ_MUST_HARD_MASK	(PACA_IRQ_EE|PACA_IRQ_REPLAYING)
 #endif
 
 #endif /* CONFIG_PPC64 */
diff --git a/arch/powerpc/kernel/irq_64.c b/arch/powerpc/kernel/irq_64.c
index eb2b380e52a0d..9dc0ad3c533a8 100644
--- a/arch/powerpc/kernel/irq_64.c
+++ b/arch/powerpc/kernel/irq_64.c
@@ -70,22 +70,19 @@ int distribute_irqs = 1;
 
 static inline void next_interrupt(struct pt_regs *regs)
 {
-	/*
-	 * Softirq processing can enable/disable irqs, which will leave
-	 * MSR[EE] enabled and the soft mask set to IRQS_DISABLED. Fix
-	 * this up.
-	 */
-	if (!(local_paca->irq_happened & PACA_IRQ_HARD_DIS))
-		hard_irq_disable();
-	else
-		irq_soft_mask_set(IRQS_ALL_DISABLED);
+	if (IS_ENABLED(CONFIG_PPC_IRQ_SOFT_MASK_DEBUG)) {
+		WARN_ON(!(local_paca->irq_happened & PACA_IRQ_HARD_DIS));
+		WARN_ON(irq_soft_mask_return() != IRQS_ALL_DISABLED);
+	}
 
 	/*
 	 * We are responding to the next interrupt, so interrupt-off
 	 * latencies should be reset here.
 	 */
+	lockdep_hardirq_exit();
 	trace_hardirqs_on();
 	trace_hardirqs_off();
+	lockdep_hardirq_enter();
 }
 
 static inline bool irq_happened_test_and_clear(u8 irq)
@@ -97,22 +94,11 @@ static inline bool irq_happened_test_and_clear(u8 irq)
 	return false;
 }
 
-void replay_soft_interrupts(void)
+static void __replay_soft_interrupts(void)
 {
 	struct pt_regs regs;
 
 	/*
-	 * Be careful here, calling these interrupt handlers can cause
-	 * softirqs to be raised, which they may run when calling irq_exit,
-	 * which will cause local_irq_enable() to be run, which can then
-	 * recurse into this function. Don't keep any state across
-	 * interrupt handler calls which may change underneath us.
-	 *
-	 * Softirqs can not be disabled over replay to stop this recursion
-	 * because interrupts taken in idle code may require RCU softirq
-	 * to run in the irq RCU tracking context. This is a hard problem
-	 * to fix without changes to the softirq or idle layer.
-	 *
 	 * We use local_paca rather than get_paca() to avoid all the
 	 * debug_smp_processor_id() business in this low level function.
 	 */
@@ -120,13 +106,20 @@ void replay_soft_interrupts(void)
 	if (IS_ENABLED(CONFIG_PPC_IRQ_SOFT_MASK_DEBUG)) {
 		WARN_ON_ONCE(mfmsr() & MSR_EE);
 		WARN_ON(!(local_paca->irq_happened & PACA_IRQ_HARD_DIS));
+		WARN_ON(local_paca->irq_happened & PACA_IRQ_REPLAYING);
 	}
 
+	/*
+	 * PACA_IRQ_REPLAYING prevents interrupt handlers from enabling
+	 * MSR[EE] to get PMIs, which can result in more IRQs becoming
+	 * pending.
+	 */
+	local_paca->irq_happened |= PACA_IRQ_REPLAYING;
+
 	ppc_save_regs(&regs);
 	regs.softe = IRQS_ENABLED;
 	regs.msr |= MSR_EE;
 
-again:
 	/*
 	 * Force the delivery of pending soft-disabled interrupts on PS3.
 	 * Any HV call will have this side effect.
@@ -175,13 +168,14 @@ void replay_soft_interrupts(void)
 		next_interrupt(&regs);
 	}
 
-	/*
-	 * Softirq processing can enable and disable interrupts, which can
-	 * result in new irqs becoming pending. Must keep looping until we
-	 * have cleared out all pending interrupts.
-	 */
-	if (local_paca->irq_happened & ~PACA_IRQ_HARD_DIS)
-		goto again;
+	local_paca->irq_happened &= ~PACA_IRQ_REPLAYING;
+}
+
+void replay_soft_interrupts(void)
+{
+	irq_enter(); /* See comment in arch_local_irq_restore */
+	__replay_soft_interrupts();
+	irq_exit();
 }
 
 #if defined(CONFIG_PPC_BOOK3S_64) && defined(CONFIG_PPC_KUAP)
@@ -200,13 +194,13 @@ static inline void replay_soft_interrupts_irqrestore(void)
 	if (kuap_state != AMR_KUAP_BLOCKED)
 		set_kuap(AMR_KUAP_BLOCKED);
 
-	replay_soft_interrupts();
+	__replay_soft_interrupts();
 
 	if (kuap_state != AMR_KUAP_BLOCKED)
 		set_kuap(kuap_state);
 }
 #else
-#define replay_soft_interrupts_irqrestore() replay_soft_interrupts()
+#define replay_soft_interrupts_irqrestore() __replay_soft_interrupts()
 #endif
 
 notrace void arch_local_irq_restore(unsigned long mask)
@@ -219,9 +213,13 @@ notrace void arch_local_irq_restore(unsigned long mask)
 		return;
 	}
 
-	if (IS_ENABLED(CONFIG_PPC_IRQ_SOFT_MASK_DEBUG))
-		WARN_ON_ONCE(in_nmi() || in_hardirq());
+	if (IS_ENABLED(CONFIG_PPC_IRQ_SOFT_MASK_DEBUG)) {
+		WARN_ON_ONCE(in_nmi());
+		WARN_ON_ONCE(in_hardirq());
+		WARN_ON_ONCE(local_paca->irq_happened & PACA_IRQ_REPLAYING);
+	}
 
+again:
 	/*
 	 * After the stb, interrupts are unmasked and there are no interrupts
 	 * pending replay. The restart sequence makes this atomic with
@@ -248,6 +246,12 @@ notrace void arch_local_irq_restore(unsigned long mask)
 	if (IS_ENABLED(CONFIG_PPC_IRQ_SOFT_MASK_DEBUG))
 		WARN_ON_ONCE(!(mfmsr() & MSR_EE));
 
+	/*
+	 * If we came here from the replay below, we might have a preempt
+	 * pending (due to preempt_enable_no_resched()). Have to check now.
+	 */
+	preempt_check_resched();
+
 	return;
 
 happened:
@@ -261,6 +265,7 @@ notrace void arch_local_irq_restore(unsigned long mask)
 		irq_soft_mask_set(IRQS_ENABLED);
 		local_paca->irq_happened = 0;
 		__hard_irq_enable();
+		preempt_check_resched();
 		return;
 	}
 
@@ -296,12 +301,38 @@ notrace void arch_local_irq_restore(unsigned long mask)
 	irq_soft_mask_set(IRQS_ALL_DISABLED);
 	trace_hardirqs_off();
 
+	/*
+	 * Now enter interrupt context. The interrupt handlers themselves
+	 * also call irq_enter/exit (which is okay, they can nest). But call
+	 * it here now to hold off softirqs until the below irq_exit(). If
+	 * we allowed replayed handlers to run softirqs, that enables irqs,
+	 * which must replay interrupts, which recurses in here and makes
+	 * things more complicated. The recursion is limited to 2, and it can
+	 * be made to work, but it's complicated.
+	 *
+	 * local_bh_disable can not be used here because interrupts taken in
+	 * idle are not in the right context (RCU, tick, etc) to run softirqs
+	 * so irq_enter must be called.
+	 */
+	irq_enter();
+
 	replay_soft_interrupts_irqrestore();
 
+	irq_exit();
+
+	if (unlikely(local_paca->irq_happened != PACA_IRQ_HARD_DIS)) {
+		/*
+		 * The softirq processing in irq_exit() may enable interrupts
+		 * temporarily, which can result in MSR[EE] being enabled and
+		 * more irqs becoming pending. Go around again if that happens.
+		 */
+		trace_hardirqs_on();
+		preempt_enable_no_resched();
+		goto again;
+	}
+
 	trace_hardirqs_on();
 	irq_soft_mask_set(IRQS_ENABLED);
-	if (IS_ENABLED(CONFIG_PPC_IRQ_SOFT_MASK_DEBUG))
-		WARN_ON(local_paca->irq_happened != PACA_IRQ_HARD_DIS);
 	local_paca->irq_happened = 0;
 	__hard_irq_enable();
 	preempt_enable();
-- 
2.39.2

