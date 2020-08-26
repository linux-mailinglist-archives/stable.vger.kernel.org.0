Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E08125390D
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 22:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgHZUVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 16:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726241AbgHZUVs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 16:21:48 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34BE5C061574;
        Wed, 26 Aug 2020 13:21:47 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1598473304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4Gx2C3ZUcKyZNb4xGzlZpmhk1STR769KFOAc3dj+CHM=;
        b=jf1otqlj4EWIHhczPrAZqfb1pfsbG9Uka55qqs7Evh3UX8kO+R/QLpKIL2Aq295LgbrCjV
        Hng3bxzADPluLhtSHaIEFN+io28sJE960ACYJI1CAzEpIh1K5myB/MBr4pg68i0FvqScjJ
        3mYV5/cTKTroAr2dvC517qctXN1Uv2mEs92jDrx+U/tI93NPtPe5iSqQSvrfHiQByyl6sf
        gdqwxpS/lzA2zo2jtTSHvlUGISfiBZRXPCoWkfOrHa4c0ZwvfePMoCqXXWlXnDgrc+Xz5W
        JVceU1RjPJVaF1jArqvPBzEuNNOsKNog35QTvry+egZ2ifuR1kVxq6oq+YDTlg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1598473304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4Gx2C3ZUcKyZNb4xGzlZpmhk1STR769KFOAc3dj+CHM=;
        b=cfxuptz1Bb2FJUAzBJutTGUCmnDt5kbGxLSpXhRrYrmbYw5kKdVhMa7kfVsgmgx2fyMeAu
        THII0DICWYk/tjDA==
To:     Alexander Graf <graf@amazon.com>, X86 ML <x86@kernel.org>
Cc:     Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Will Deacon <will@kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Wei Liu <wei.liu@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Jason Chen CJ <jason.cj.chen@intel.com>,
        Zhao Yakui <yakui.zhao@intel.com>,
        "Peter Zijlstra \(Intel\)" <peterz@infradead.org>,
        Avi Kivity <avi@scylladb.com>,
        "Herrenschmidt\, Benjamin" <benh@amazon.com>, robketr@amazon.de,
        amos@scylladb.com, Brian Gerst <brgerst@gmail.com>,
        stable@vger.kernel.org, Alex bykov <alex.bykov@scylladb.com>
Subject: x86/irq: Unbreak interrupt affinity setting
In-Reply-To: <873649utm4.fsf@nanos.tec.linutronix.de>
References: <20200826115357.3049-1-graf@amazon.com> <87k0xlv5w5.fsf@nanos.tec.linutronix.de> <fd87a87d-7d8a-9959-6c81-f49003a43c21@amazon.com> <87blixuuny.fsf@nanos.tec.linutronix.de> <873649utm4.fsf@nanos.tec.linutronix.de>
Date:   Wed, 26 Aug 2020 22:21:44 +0200
Message-ID: <87wo1ltaxz.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Reported-by: Alex bykov <alex.bykov@scylladb.com>
Reported-by: Avi Kivity <avi@scylladb.com>
Reported-by: Alexander Graf <graf@amazon.com>
Fixes: 633260fa143 ("x86/irq: Convey vector as argument and not in ptregs")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
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
@@ -909,7 +910,7 @@ void send_cleanup_vector(struct irq_cfg
 		__send_cleanup_vector(apicd);
 }
 
-static void __irq_complete_move(struct irq_cfg *cfg, unsigned vector)
+void irq_complete_move(struct irq_cfg *cfg)
 {
 	struct apic_chip_data *apicd;
 
@@ -917,15 +918,16 @@ static void __irq_complete_move(struct i
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
