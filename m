Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEAA69CE68
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbjBTN7A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:59:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232693AbjBTN6v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:58:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E6E104
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:58:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78E5D60E9D
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:57:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1DAC433D2;
        Mon, 20 Feb 2023 13:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901457;
        bh=YPi+RDyIP261whjr1SIMnIPIUEssDHEyvCcUPAkby70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EOXnjtnjbOHCsDn7CV7jXp+NVlhnP8fz+6OF68+S6Uumtb9NOBTNkQYVzpEAPmEPV
         VI4RIGbzpG83A96dvssglQ+g6LjdGSrngghyy3r8Vc5MjNh1CD18txhqilfSrjnBqZ
         h8cqFF31YknBBA768dlXVMeWbP6Rt7I19S/xjF74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/118] powerpc/64: Fix perf profiling asynchronous interrupt handlers
Date:   Mon, 20 Feb 2023 14:35:40 +0100
Message-Id: <20230220133601.403392060@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
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

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit c28548012ee2bac55772ef7685138bd1124b80c3 ]

Interrupt entry sets the soft mask to IRQS_ALL_DISABLED to match the
hard irq disabled state. So when should_hard_irq_enable() returns true
because we want PMI interrupts in irq handlers, MSR[EE] is enabled but
PMIs just get soft-masked. Fix this by clearing IRQS_PMI_DISABLED before
enabling MSR[EE].

This also tidies some of the warnings, no need to duplicate them in
both should_hard_irq_enable() and do_hard_irq_enable().

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230121100156.2824054-1-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/hw_irq.h | 41 ++++++++++++++++++++++---------
 arch/powerpc/kernel/dbell.c       |  2 +-
 arch/powerpc/kernel/irq.c         |  2 +-
 arch/powerpc/kernel/time.c        |  2 +-
 4 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/arch/powerpc/include/asm/hw_irq.h b/arch/powerpc/include/asm/hw_irq.h
index 0b7d01d408ac8..eb6d094083fd6 100644
--- a/arch/powerpc/include/asm/hw_irq.h
+++ b/arch/powerpc/include/asm/hw_irq.h
@@ -173,6 +173,15 @@ static inline notrace unsigned long irq_soft_mask_or_return(unsigned long mask)
 	return flags;
 }
 
+static inline notrace unsigned long irq_soft_mask_andc_return(unsigned long mask)
+{
+	unsigned long flags = irq_soft_mask_return();
+
+	irq_soft_mask_set(flags & ~mask);
+
+	return flags;
+}
+
 static inline unsigned long arch_local_save_flags(void)
 {
 	return irq_soft_mask_return();
@@ -331,10 +340,11 @@ bool power_pmu_wants_prompt_pmi(void);
  * is a different soft-masked interrupt pending that requires hard
  * masking.
  */
-static inline bool should_hard_irq_enable(void)
+static inline bool should_hard_irq_enable(struct pt_regs *regs)
 {
 	if (IS_ENABLED(CONFIG_PPC_IRQ_SOFT_MASK_DEBUG)) {
-		WARN_ON(irq_soft_mask_return() == IRQS_ENABLED);
+		WARN_ON(irq_soft_mask_return() != IRQS_ALL_DISABLED);
+		WARN_ON(!(get_paca()->irq_happened & PACA_IRQ_HARD_DIS));
 		WARN_ON(mfmsr() & MSR_EE);
 	}
 
@@ -347,8 +357,17 @@ static inline bool should_hard_irq_enable(void)
 	 *
 	 * TODO: Add test for 64e
 	 */
-	if (IS_ENABLED(CONFIG_PPC_BOOK3S_64) && !power_pmu_wants_prompt_pmi())
-		return false;
+	if (IS_ENABLED(CONFIG_PPC_BOOK3S_64)) {
+		if (!power_pmu_wants_prompt_pmi())
+			return false;
+		/*
+		 * If PMIs are disabled then IRQs should be disabled as well,
+		 * so we shouldn't see this condition, check for it just in
+		 * case because we are about to enable PMIs.
+		 */
+		if (WARN_ON_ONCE(regs->softe & IRQS_PMI_DISABLED))
+			return false;
+	}
 
 	if (get_paca()->irq_happened & PACA_IRQ_MUST_HARD_MASK)
 		return false;
@@ -358,18 +377,16 @@ static inline bool should_hard_irq_enable(void)
 
 /*
  * Do the hard enabling, only call this if should_hard_irq_enable is true.
+ * This allows PMI interrupts to profile irq handlers.
  */
 static inline void do_hard_irq_enable(void)
 {
-	if (IS_ENABLED(CONFIG_PPC_IRQ_SOFT_MASK_DEBUG)) {
-		WARN_ON(irq_soft_mask_return() == IRQS_ENABLED);
-		WARN_ON(get_paca()->irq_happened & PACA_IRQ_MUST_HARD_MASK);
-		WARN_ON(mfmsr() & MSR_EE);
-	}
 	/*
-	 * This allows PMI interrupts (and watchdog soft-NMIs) through.
-	 * There is no other reason to enable this way.
+	 * Asynch interrupts come in with IRQS_ALL_DISABLED,
+	 * PACA_IRQ_HARD_DIS, and MSR[EE]=0.
 	 */
+	if (IS_ENABLED(CONFIG_PPC_BOOK3S_64))
+		irq_soft_mask_andc_return(IRQS_PMI_DISABLED);
 	get_paca()->irq_happened &= ~PACA_IRQ_HARD_DIS;
 	__hard_irq_enable();
 }
@@ -452,7 +469,7 @@ static inline bool arch_irq_disabled_regs(struct pt_regs *regs)
 	return !(regs->msr & MSR_EE);
 }
 
-static __always_inline bool should_hard_irq_enable(void)
+static __always_inline bool should_hard_irq_enable(struct pt_regs *regs)
 {
 	return false;
 }
diff --git a/arch/powerpc/kernel/dbell.c b/arch/powerpc/kernel/dbell.c
index f55c6fb34a3a0..5712dd846263c 100644
--- a/arch/powerpc/kernel/dbell.c
+++ b/arch/powerpc/kernel/dbell.c
@@ -27,7 +27,7 @@ DEFINE_INTERRUPT_HANDLER_ASYNC(doorbell_exception)
 
 	ppc_msgsync();
 
-	if (should_hard_irq_enable())
+	if (should_hard_irq_enable(regs))
 		do_hard_irq_enable();
 
 	kvmppc_clear_host_ipi(smp_processor_id());
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 9ede61a5a469e..55142ff649f3f 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -238,7 +238,7 @@ static void __do_irq(struct pt_regs *regs, unsigned long oldsp)
 	irq = static_call(ppc_get_irq)();
 
 	/* We can hard enable interrupts now to allow perf interrupts */
-	if (should_hard_irq_enable())
+	if (should_hard_irq_enable(regs))
 		do_hard_irq_enable();
 
 	/* And finally process it */
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index a2ab397065c66..f157552d79b38 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -533,7 +533,7 @@ DEFINE_INTERRUPT_HANDLER_ASYNC(timer_interrupt)
 	}
 
 	/* Conditionally hard-enable interrupts. */
-	if (should_hard_irq_enable()) {
+	if (should_hard_irq_enable(regs)) {
 		/*
 		 * Ensure a positive value is written to the decrementer, or
 		 * else some CPUs will continue to take decrementer exceptions.
-- 
2.39.0



