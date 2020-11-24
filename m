Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBF52C1B9C
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 03:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbgKXCsU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 21:48:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:36622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726508AbgKXCsT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 21:48:19 -0500
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B9242067C;
        Tue, 24 Nov 2020 02:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606186098;
        bh=DifF5KiKF9Z3qJbFxfsfNCx0cjrKfrDIQko7nyOBRt8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VOkJWl6XDSNIbKYMcde50Gro6w7QUypJjHsyluqR/zIlw9ii5zh9boF9afY1z1euE
         VgtBkuz2XjYmCONqpy834L3SMNeL1QmMGbW4I/bHIgYweQKOGXMiy/PHGTASM9LQTN
         GaiP4Rj4rInVn5lXauCbp7qyRdXmN2prO8AlwDyo=
Date:   Tue, 24 Nov 2020 11:48:13 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Will Deacon <will@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        "Paul E . McKenney" <paulmck@linux.ibm.com>,
        James Morse <james.morse@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: Re: [PATCH] arm64: don't preempt_disable in do_debug_exception
Message-Id: <20201124114813.677e57eb591218a98b70af0e@kernel.org>
In-Reply-To: <20200626095551.GA9312@willie-the-truck>
References: <1592501369-27645-1-git-send-email-paul.gortmaker@windriver.com>
        <20200623155900.GA4777@willie-the-truck>
        <20200623165557.GA12767@C02TD0UTHF1T.local>
        <20200626095551.GA9312@willie-the-truck>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 26 Jun 2020 10:55:54 +0100
Will Deacon <will@kernel.org> wrote:

> On Tue, Jun 23, 2020 at 05:55:57PM +0100, Mark Rutland wrote:
> > On Tue, Jun 23, 2020 at 04:59:01PM +0100, Will Deacon wrote:
> > > On Thu, Jun 18, 2020 at 01:29:29PM -0400, Paul Gortmaker wrote:
> > > >  BUG: sleeping function called from invalid context at kernel/locking/rtmutex.c:975
> > > >  in_atomic(): 1, irqs_disabled(): 0, pid: 35658, name: gdbtest
> > > >  Preemption disabled at:
> > > >  [<ffff000010081578>] do_debug_exception+0x38/0x1a4
> > > >  Call trace:
> > > >  dump_backtrace+0x0/0x138
> > > >  show_stack+0x24/0x30
> > > >  dump_stack+0x94/0xbc
> > > >  ___might_sleep+0x13c/0x168
> > > >  rt_spin_lock+0x40/0x80
> > > >  do_force_sig_info+0x30/0xe0
> > > >  force_sig_fault+0x64/0x90
> > > >  arm64_force_sig_fault+0x50/0x80
> > > >  send_user_sigtrap+0x50/0x80
> > > >  brk_handler+0x98/0xc8
> > > >  do_debug_exception+0x70/0x1a4
> > > >  el0_dbg+0x18/0x20
> > > > 
> > > > The reproducer was basically an automated gdb test that set a breakpoint
> > > > on a simple "hello world" program and then quit gdb once the breakpoint
> > > > was hit - i.e. "(gdb) A debugging session is active.  Quit anyway? "
> > > 
> > > Hmm, the debug exception handler path was definitely written with the
> > > expectation that preemption is disabled, so this is unfortunate. For
> > > exceptions from kernelspace, we need to keep that guarantee as we implement
> > > things like BUG() using this path. For exceptions from userspace, it's
> > > plausible that we could re-enable preemption, but then we should also
> > > re-enable interrupts and debug exceptions too because we don't
> > > context-switch pstate in switch_to() and we would end up with holes in our
> > > kernel debug coverage (and these might be fatal if e.g. single step doesn't
> > > work in a kprobe OOL buffer). However, that then means that any common code
> > > when handling user and kernel debug exceptions needs to be re-entrant,
> > > which it probably isn't at the moment (I haven't checked).
> > 
> > I'm pretty certain existing code is not reentrant, and regardless it's
> > going to be a mess to reason about this generally if we have to undo our
> > strict exception nesting rules.
> 
> Are these rules written down somewhere? I'll need to update them if we
> get this working for preempt-rt (and we should try to do that).
> 
> > I reckon we need to treat this like an NMI instead -- is that plausible?
> 
> I don't think so. It's very much a synchronous exception, and delivering a
> signal to the exceptional context doesn't feel like an NMI to me. There's
> also a fair amount of code that can run in debug context (hw_breakpoint,
> kprobes, uprobes, kasan) which might not be happy to suddenly be in an
> NMI-like environment. Furthermore, the masking rules are different depending
> on what triggers the exception.
> 
> One of the things I've started looking at is ripping out our dodgy
> hw_breakpoint code so that kernel debug exceptions are easier to reason
> about. Specifically, I think we end up with something like:
> 
> - On taking a non-debug exception from EL0, unmask D as soon as we can.
> 
> - On taking a debug exception from EL0, unmask {D,I} and invoke user
>   handlers. I think this always means SIGTRAP, apart from uprobes.
>   This will mean making those paths preemptible, as I don't think they
>   are right now (e.g. traversing the callback hooks uses an RCU-protected
>   list).
> 
> - On taking a non-debug, non-fatal synchronous exception from EL1, unmask
>   D as soon as we can (i.e. we step into these exceptions). Fatal exceptions
>   can obviously leave D masked.

To make clear, the BRK exception will be non-fatal synchronous exception,
correct? If so, would you mean single-stepping into these exception handlers
too?

As we discussed in another thread, after the BRK only kprobes is merged,
I'm OK for this. But also we need to care about the BRK recursive call.
If someone puts a kprobe in the single-step handler, we can break into the
other break handler is running. (kprobes itself can handle this case, because
it sets the current_kprobe as the recursion-detect flag)

> 
> - On taking an interrupt from EL1, stash MDSCR_EL1.SS in a pcpu variable and
>   clear the register bit if it was set. Then unmask only D and leave I set. On
>   return from the exception, set D and restore MDSCR_EL1.SS. If we decide to
>   reschedule, unmask D (i.e. we only step into interrupts if we need a
>   reschedule. Alternatively, we could skip the reschedule if we were
>   stepping.)

This sounds good to me (context-based single-stepping).

Thank you,

> 
> - On taking a debug exception from EL1, leave {D,I} set. Watchpoints on
>   uaccess are silently stepped over.
> 
> Thoughts? We could probably simplify this if we could state that stepping an
> instruction in kernel space could only ever be interrupted by an interrupt.
> That's probably true for kprobes, but relying on it feels like it might bite
> us later on.
> 
> Will


-- 
Masami Hiramatsu <mhiramat@kernel.org>
