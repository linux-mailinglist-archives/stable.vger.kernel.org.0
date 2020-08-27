Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59114253F32
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 09:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgH0HdC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 03:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgH0HdB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Aug 2020 03:33:01 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B693C061264;
        Thu, 27 Aug 2020 00:33:01 -0700 (PDT)
Date:   Thu, 27 Aug 2020 07:32:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1598513579;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P36oEIEW26lLr8KitaGaEAxdQfOhpK7tlWZ1uAmlAPg=;
        b=R4kppq6gCarrgv4Wj/1bsmaT8bWSKuRsJAzjqOiAwxDY2+iId+a45xo/aXd591FMBH6jLJ
        BD8wd4YRD8+Im+QiyGLhYSkB4ONGfD14k7q77dyXJGnJUbYaz70YDjVKZ/9QESpywClu7f
        V3q6OxS9mkQblibpAcKk6YIAQ/mHPpZ2Hz2KHu8QoevJ/8pANGLlCIoILd254bhaJi/sdV
        pme0jlAjss/gU/9Q7w/ps12NmQ7urTVnbbsvdlXXce5EPntNUe7JEH0jZvHypljq4g5uO3
        isLFuCYqSGjM8N3gR8BO9XeFBVly5cVIbP1xsd3KV/K0lG9bFgboGjRo83LWqw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1598513579;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P36oEIEW26lLr8KitaGaEAxdQfOhpK7tlWZ1uAmlAPg=;
        b=dPQi7FZ2pLqoOmbUJIhXAeyNjpe3EX3TVQ6m9ARpyv3LdqdegWbDSA8MuP3Q8IlmsyFS6l
        EB81OGIsvX3HzxCg==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/irq: Unbreak interrupt affinity setting
Cc:     Alex bykov <alex.bykov@scylladb.com>,
        Avi Kivity <avi@scylladb.com>,
        Alexander Graf <graf@amazon.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <87wo1ltaxz.fsf@nanos.tec.linutronix.de>
References: <87wo1ltaxz.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Message-ID: <159851357826.20229.12114410199815745845.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     e027fffff799cdd70400c5485b1a54f482255985
Gitweb:        https://git.kernel.org/tip/e027fffff799cdd70400c5485b1a54f482255985
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Wed, 26 Aug 2020 22:21:44 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Thu, 27 Aug 2020 09:29:23 +02:00

x86/irq: Unbreak interrupt affinity setting

Several people reported that 5.8 broke the interrupt affinity setting
mechanism.

The consolidation of the entry code reused the regular exception entry code
for device interrupts and changed the way how the vector number is conveyed
from ptregs->orig_ax to a function argument.

The low level entry uses the hardware error code slot to push the vector
number onto the stack which is retrieved from there into a function
argument and the slot on stack is set to -1.

The reason for setting it to -1 is that the error code slot is at the
position where pt_regs::orig_ax is. A positive value in pt_regs::orig_ax
indicates that the entry came via a syscall. If it's not set to a negative
value then a signal delivery on return to userspace would try to restart a
syscall. But there are other places which rely on pt_regs::orig_ax being a
valid indicator for syscall entry.

But setting pt_regs::orig_ax to -1 has a nasty side effect vs. the
interrupt affinity setting mechanism, which was overlooked when this change
was made.

Moving interrupts on x86 happens in several steps. A new vector on a
different CPU is allocated and the relevant interrupt source is
reprogrammed to that. But that's racy and there might be an interrupt
already in flight to the old vector. So the old vector is preserved until
the first interrupt arrives on the new vector and the new target CPU. Once
that happens the old vector is cleaned up, but this cleanup still depends
on the vector number being stored in pt_regs::orig_ax, which is now -1.

That -1 makes the check for cleanup: pt_regs::orig_ax == new_vector
always false. As a consequence the interrupt is moved once, but then it
cannot be moved anymore because the cleanup of the old vector never
happens.

There would be several ways to convey the vector information to that place
in the guts of the interrupt handling, but on deeper inspection it turned
out that this check is pointless and a leftover from the old affinity model
of X86 which supported multi-CPU affinities. Under this model it was
possible that an interrupt had an old and a new vector on the same CPU, so
the vector match was required.

Under the new model the effective affinity of an interrupt is always a
single CPU from the requested affinity mask. If the affinity mask changes
then either the interrupt stays on the CPU and on the same vector when that
CPU is still in the new affinity mask or it is moved to a different CPU, but
it is never moved to a different vector on the same CPU.

Ergo the cleanup check for the matching vector number is not required and
can be removed which makes the dependency on pt_regs:orig_ax go away.

The remaining check for new_cpu == smp_processsor_id() is completely
sufficient. If it matches then the interrupt was successfully migrated and
the cleanup can proceed.

For paranoia sake add a warning into the vector assignment code to
validate that the assumption of never moving to a different vector on
the same CPU holds.

Fixes: 633260fa143 ("x86/irq: Convey vector as argument and not in ptregs")
Reported-by: Alex bykov <alex.bykov@scylladb.com>
Reported-by: Avi Kivity <avi@scylladb.com>
Reported-by: Alexander Graf <graf@amazon.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Alexander Graf <graf@amazon.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/87wo1ltaxz.fsf@nanos.tec.linutronix.de

---
 arch/x86/kernel/apic/vector.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index dae32d9..f8a56b5 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -161,6 +161,7 @@ static void apic_update_vector(struct irq_data *irqd, unsigned int newvec,
 		apicd->move_in_progress = true;
 		apicd->prev_vector = apicd->vector;
 		apicd->prev_cpu = apicd->cpu;
+		WARN_ON_ONCE(apicd->cpu == newcpu);
 	} else {
 		irq_matrix_free(vector_matrix, apicd->cpu, apicd->vector,
 				managed);
@@ -910,7 +911,7 @@ void send_cleanup_vector(struct irq_cfg *cfg)
 		__send_cleanup_vector(apicd);
 }
 
-static void __irq_complete_move(struct irq_cfg *cfg, unsigned vector)
+void irq_complete_move(struct irq_cfg *cfg)
 {
 	struct apic_chip_data *apicd;
 
@@ -918,15 +919,16 @@ static void __irq_complete_move(struct irq_cfg *cfg, unsigned vector)
 	if (likely(!apicd->move_in_progress))
 		return;
 
-	if (vector == apicd->vector && apicd->cpu == smp_processor_id())
+	/*
+	 * If the interrupt arrived on the new target CPU, cleanup the
+	 * vector on the old target CPU. A vector check is not required
+	 * because an interrupt can never move from one vector to another
+	 * on the same CPU.
+	 */
+	if (apicd->cpu == smp_processor_id())
 		__send_cleanup_vector(apicd);
 }
 
-void irq_complete_move(struct irq_cfg *cfg)
-{
-	__irq_complete_move(cfg, ~get_irq_regs()->orig_ax);
-}
-
 /*
  * Called from fixup_irqs() with @desc->lock held and interrupts disabled.
  */
