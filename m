Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5124A253146
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 16:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgHZO17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 10:27:59 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:59268 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbgHZO16 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 10:27:58 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1598452074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yLI1JliWBimG+ivF3z1VwX50dlgm/KDIAccbPnUPwJQ=;
        b=vZ0MQN940VxAwJgiVL2fdMU4aOCDK0uKAR4ZMl+9P6Z0aFtKL2WYTOlvB7xg/AcGx54knW
        DCypEonnJIWdlmkSc/Upao1amR5z/yCXLBIV9o8pt2NpbY5iu4v2qXkSZeIpxomOvoR5UJ
        uH5SxaU31UHt+7Ejm27bDJ3zDdQ404IEcyysrsIbpfLIV7wb0fqfy969+LupFf8nSMmV1U
        r8SBVxsgG5Ss5TQWEdRhAHzKyw0CL71P0IxXJWkThpU7WOWzJaOF/Yf2r38ZTkAE8CnPQZ
        s4n0xwsEag78WIHr3rWDNxJFiMFK8krl85qGhK+USJ+TC3auLk+vvu4d1nYmAw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1598452074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yLI1JliWBimG+ivF3z1VwX50dlgm/KDIAccbPnUPwJQ=;
        b=jkPC6xofKbboBQ68bXnjzKaQ0LzRqWIsS332zGOxhvCZcTte8FT5JrpCObaEYbOPtY3c61
        DM0S4JkSJMaxUYDg==
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
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/irq: Preserve vector in orig_ax for APIC code
In-Reply-To: <20200826115357.3049-1-graf@amazon.com>
References: <20200826115357.3049-1-graf@amazon.com>
Date:   Wed, 26 Aug 2020 16:27:54 +0200
Message-ID: <87k0xlv5w5.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 26 2020 at 13:53, Alexander Graf wrote:
> Commit 633260fa143 ("x86/irq: Convey vector as argument and not in ptregs")
> changed the handover logic of the vector identifier from ~vector in orig_ax
> to purely register based. Unfortunately, this field has another consumer
> in the APIC code which the commit did not touch. The net result was that
> IRQ balancing did not work and instead resulted in interrupt storms, slowing
> down the system.

The net result is an observationof the symptom but that does not explain
what the underlying technical issue is.

> This patch restores the original semantics that orig_ax contains the vector.
> When we receive an interrupt now, the actual vector number stays stored in
> the orig_ax field which then gets consumed by the APIC code.
>
> To ensure that nobody else trips over this in the future, the patch also adds
> comments at strategic places to warn anyone who would refactor the code that
> there is another consumer of the field.
>
> With this patch in place, IRQ balancing works as expected and performance
> levels are restored to previous levels.

There's a lot of 'This patch and we' in that changelog. Care to grep
for 'This patch' in Documentation/process/ ?

> diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
> index df8c017..22e829c 100644
> --- a/arch/x86/entry/entry_32.S
> +++ b/arch/x86/entry/entry_32.S
> @@ -727,7 +727,7 @@ SYM_CODE_START_LOCAL(asm_\cfunc)
>  	ENCODE_FRAME_POINTER
>  	movl	%esp, %eax
>  	movl	PT_ORIG_EAX(%esp), %edx		/* get the vector from stack */
> -	movl	$-1, PT_ORIG_EAX(%esp)		/* no syscall to restart */
> +	/* keep vector on stack for APIC's irq_complete_move() */

Yes that's fixing your observed wreckage, but it introduces a worse one.

user space
  -> interrupt
       push vector into orig_ax (values are in the ranges of 0-127 and -128 - 255
                                 except for the system vectors which do
                                 not go through this code)
      handle()
      ...
      exit_to_user_mode_loop()
         arch_do_signal()
            /* Did we come from a system call? */
	    if (syscall_get_nr(current, regs) >= 0) {

               ---> BOOM for any vector 0-127 because syscall_get_nr()
                         resolves to regs->orig_ax

Going to be fun to debug.

The below nasty hack cures it, but I hate it with a passion. I'll look
deeper for a sane variant.

Thanks,

        tglx
---
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -246,7 +246,9 @@ DEFINE_IDTENTRY_IRQ(common_interrupt)
 
 	desc = __this_cpu_read(vector_irq[vector]);
 	if (likely(!IS_ERR_OR_NULL(desc))) {
+		regs->orig_ax = (unsigned long)vector;
 		handle_irq(desc, regs);
+		regs->orig_ax = -1;
 	} else {
 		ack_APIC_irq();
