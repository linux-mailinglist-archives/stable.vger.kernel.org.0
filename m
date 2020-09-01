Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC8B2594F9
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731854AbgIAPpC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:45:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:60998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731850AbgIAPo6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:44:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10C772098B;
        Tue,  1 Sep 2020 15:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975097;
        bh=OsDPWOjTlJBEoGSrXV0BEw0wDBAhMFxP/FEO/hUrZ04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q1gRMajFF5l+aFCx59NeyUsJOu0jju6el3BNdPXsgSPRhN1Hf2cPqBHWVONFcY3P5
         oxAh9h87bS0zZTXZmlQLc5lTVL/hWGMPb4dKPm8WbqnSdcSKC4W/tH22ft0kXIgbyR
         cRmV3tsL6isdNTLuGAiIz+czsAwm6avZNVbE8Rio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex bykov <alex.bykov@scylladb.com>,
        Avi Kivity <avi@scylladb.com>,
        Alexander Graf <graf@amazon.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.8 208/255] x86/irq: Unbreak interrupt affinity setting
Date:   Tue,  1 Sep 2020 17:11:04 +0200
Message-Id: <20200901151010.666161462@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit e027fffff799cdd70400c5485b1a54f482255985 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/apic/vector.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -161,6 +161,7 @@ static void apic_update_vector(struct ir
 		apicd->move_in_progress = true;
 		apicd->prev_vector = apicd->vector;
 		apicd->prev_cpu = apicd->cpu;
+		WARN_ON_ONCE(apicd->cpu == newcpu);
 	} else {
 		irq_matrix_free(vector_matrix, apicd->cpu, apicd->vector,
 				managed);
@@ -910,7 +911,7 @@ void send_cleanup_vector(struct irq_cfg
 		__send_cleanup_vector(apicd);
 }
 
-static void __irq_complete_move(struct irq_cfg *cfg, unsigned vector)
+void irq_complete_move(struct irq_cfg *cfg)
 {
 	struct apic_chip_data *apicd;
 
@@ -918,15 +919,16 @@ static void __irq_complete_move(struct i
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


