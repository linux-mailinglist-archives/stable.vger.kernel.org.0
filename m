Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2545130CC54
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240068AbhBBTvq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:51:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:40856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233120AbhBBNvn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:51:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7DFC64FBA;
        Tue,  2 Feb 2021 13:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273408;
        bh=RwMlqxsNOf7MJEbJCm7Yga/VY3R+118Kq4RXQrM1y30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zzvZJKZqCn6eZJP8o7QNwpXyrvzWcAJzSGP67qxVv/e/ApQR5ZmznkZ5aiYFH8fuV
         1trzE36Y69XqoSde/23zC/L9c3nRMGydYB6rgylragQgCFSPD7gIvCxXAkyGSbHwWd
         SsByQem5PWBg0wJVbK7lbd72jjW86SFZXX/2hYVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 095/142] powerpc/64s: prevent recursive replay_soft_interrupts causing superfluous interrupt
Date:   Tue,  2 Feb 2021 14:37:38 +0100
Message-Id: <20210202133001.630900187@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 4025c784c573cab7e3f84746cc82b8033923ec62 ]

When an asynchronous interrupt calls irq_exit, it checks for softirqs
that may have been created, and runs them. Running softirqs enables
local irqs, which can replay pending interrupts causing recursion in
replay_soft_interrupts. This abridged trace shows how this can occur:

! NIP replay_soft_interrupts
  LR  interrupt_exit_kernel_prepare
  Call Trace:
    interrupt_exit_kernel_prepare (unreliable)
    interrupt_return
  --- interrupt: ea0 at __rb_reserve_next
  NIP __rb_reserve_next
  LR __rb_reserve_next
  Call Trace:
    ring_buffer_lock_reserve
    trace_function
    function_trace_call
    ftrace_call
    __do_softirq
    irq_exit
    timer_interrupt
!   replay_soft_interrupts
    interrupt_exit_kernel_prepare
    interrupt_return
  --- interrupt: ea0 at arch_local_irq_restore

This can not be prevented easily, because softirqs must not block hard
irqs, so it has to be dealt with.

The recursion is bounded by design in the softirq code because softirq
replay disables softirqs and loops around again to check for new
softirqs created while it ran, so that's not a problem.

However it does mess up interrupt replay state, causing superfluous
interrupts when the second replay_soft_interrupts clears a pending
interrupt, leaving it still set in the first call in the 'happened'
local variable.

Fix this by not caching a copy of irqs_happened across interrupt
handler calls.

Fixes: 3282a3da25bd ("powerpc/64: Implement soft interrupt replay in C")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210123061244.2076145-1-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/irq.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 6b1eca53e36cc..cc7a6271b6b4e 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -180,13 +180,18 @@ void notrace restore_interrupts(void)
 
 void replay_soft_interrupts(void)
 {
+	struct pt_regs regs;
+
 	/*
-	 * We use local_paca rather than get_paca() to avoid all
-	 * the debug_smp_processor_id() business in this low level
-	 * function
+	 * Be careful here, calling these interrupt handlers can cause
+	 * softirqs to be raised, which they may run when calling irq_exit,
+	 * which will cause local_irq_enable() to be run, which can then
+	 * recurse into this function. Don't keep any state across
+	 * interrupt handler calls which may change underneath us.
+	 *
+	 * We use local_paca rather than get_paca() to avoid all the
+	 * debug_smp_processor_id() business in this low level function.
 	 */
-	unsigned char happened = local_paca->irq_happened;
-	struct pt_regs regs;
 
 	ppc_save_regs(&regs);
 	regs.softe = IRQS_ENABLED;
@@ -209,7 +214,7 @@ again:
 	 * This is a higher priority interrupt than the others, so
 	 * replay it first.
 	 */
-	if (IS_ENABLED(CONFIG_PPC_BOOK3S) && (happened & PACA_IRQ_HMI)) {
+	if (IS_ENABLED(CONFIG_PPC_BOOK3S) && (local_paca->irq_happened & PACA_IRQ_HMI)) {
 		local_paca->irq_happened &= ~PACA_IRQ_HMI;
 		regs.trap = 0xe60;
 		handle_hmi_exception(&regs);
@@ -217,7 +222,7 @@ again:
 			hard_irq_disable();
 	}
 
-	if (happened & PACA_IRQ_DEC) {
+	if (local_paca->irq_happened & PACA_IRQ_DEC) {
 		local_paca->irq_happened &= ~PACA_IRQ_DEC;
 		regs.trap = 0x900;
 		timer_interrupt(&regs);
@@ -225,7 +230,7 @@ again:
 			hard_irq_disable();
 	}
 
-	if (happened & PACA_IRQ_EE) {
+	if (local_paca->irq_happened & PACA_IRQ_EE) {
 		local_paca->irq_happened &= ~PACA_IRQ_EE;
 		regs.trap = 0x500;
 		do_IRQ(&regs);
@@ -233,7 +238,7 @@ again:
 			hard_irq_disable();
 	}
 
-	if (IS_ENABLED(CONFIG_PPC_DOORBELL) && (happened & PACA_IRQ_DBELL)) {
+	if (IS_ENABLED(CONFIG_PPC_DOORBELL) && (local_paca->irq_happened & PACA_IRQ_DBELL)) {
 		local_paca->irq_happened &= ~PACA_IRQ_DBELL;
 		if (IS_ENABLED(CONFIG_PPC_BOOK3E))
 			regs.trap = 0x280;
@@ -245,7 +250,7 @@ again:
 	}
 
 	/* Book3E does not support soft-masking PMI interrupts */
-	if (IS_ENABLED(CONFIG_PPC_BOOK3S) && (happened & PACA_IRQ_PMI)) {
+	if (IS_ENABLED(CONFIG_PPC_BOOK3S) && (local_paca->irq_happened & PACA_IRQ_PMI)) {
 		local_paca->irq_happened &= ~PACA_IRQ_PMI;
 		regs.trap = 0xf00;
 		performance_monitor_exception(&regs);
@@ -253,8 +258,7 @@ again:
 			hard_irq_disable();
 	}
 
-	happened = local_paca->irq_happened;
-	if (happened & ~PACA_IRQ_HARD_DIS) {
+	if (local_paca->irq_happened & ~PACA_IRQ_HARD_DIS) {
 		/*
 		 * We are responding to the next interrupt, so interrupt-off
 		 * latencies should be reset here.
-- 
2.27.0



