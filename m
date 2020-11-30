Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0A02C82EE
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 12:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgK3LN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 06:13:27 -0500
Received: from foss.arm.com ([217.140.110.172]:52612 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725902AbgK3LN1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Nov 2020 06:13:27 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5D73E1042;
        Mon, 30 Nov 2020 03:12:41 -0800 (PST)
Received: from C02TD0UTHF1T.local (unknown [10.57.31.53])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4AF4B3F66B;
        Mon, 30 Nov 2020 03:12:39 -0800 (PST)
Date:   Mon, 30 Nov 2020 11:12:33 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        "Paul E . McKenney" <paulmck@linux.ibm.com>,
        James Morse <james.morse@arm.com>
Subject: Re: [PATCH] arm64: don't preempt_disable in do_debug_exception
Message-ID: <20201130111204.GA1251@C02TD0UTHF1T.local>
References: <1592501369-27645-1-git-send-email-paul.gortmaker@windriver.com>
 <20200623155900.GA4777@willie-the-truck>
 <20200623165557.GA12767@C02TD0UTHF1T.local>
 <20200626095551.GA9312@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200626095551.GA9312@willie-the-truck>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Will,

Sorry for the delay on this -- chasing up now that I have the entry
logic paged-in.

On Fri, Jun 26, 2020 at 10:55:54AM +0100, Will Deacon wrote:
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

When I was investigating the entry interaction with lockdep and tracing,
I figure out that we'll want to (at least partially) separate the BRK
handling from the rest of the debug exception handling, as is done on
x86. That way we can make WARN/BUG/KASAN BRK usage inherit the context
they interrupted rather than acting NMI-like.

With that, we could reconsider how exactly the HW breakpoint, HW
watchpoint, and HW single-step cases should behave (e.g. whether we
should align with x86 and treat those as true NMIs).

> One of the things I've started looking at is ripping out our dodgy
> hw_breakpoint code so that kernel debug exceptions are easier to reason
> about. Specifically, I think we end up with something like:
> 
> - On taking a non-debug exception from EL0, unmask D as soon as we can.

Sure. We already try to do this ASAP (in the entry code rather than in
the specific handler), but since ERET makes ESR and FAR UNKNOWN we have
a reasonable amount of work that has to be done first. We can do this
earlier if we snapshot the exception sysregs before the triage logic
(even if that means reading those redundantly).

> - On taking a debug exception from EL0, unmask {D,I} and invoke user
>   handlers. I think this always means SIGTRAP, apart from uprobes.
>   This will mean making those paths preemptible, as I don't think they
>   are right now (e.g. traversing the callback hooks uses an RCU-protected
>   list).

I'm not sure exactly how to manage the callback hooks here, but
otherwise this sounds plausible. We already treat the EL0 cases fairly
differenly from the EL1 cases.

> - On taking a non-debug, non-fatal synchronous exception from EL1, unmask
>   D as soon as we can (i.e. we step into these exceptions). Fatal exceptions
>   can obviously leave D masked.

As above, we try to do this today, and can move it earlier if we
snapshot the exception sysregs earlier.

> - On taking an interrupt from EL1, stash MDSCR_EL1.SS in a pcpu variable and
>   clear the register bit if it was set. Then unmask only D and leave I set. On
>   return from the exception, set D and restore MDSCR_EL1.SS. If we decide to
>   reschedule, unmask D (i.e. we only step into interrupts if we need a
>   reschedule. Alternatively, we could skip the reschedule if we were
>   stepping.)

I'm not entirely sure how this works with softirqs (as I thought they
could unmask IRQ before returning), but I'd need to relearn how those
work.

> - On taking a debug exception from EL1, leave {D,I} set. Watchpoints on
>   uaccess are silently stepped over.

This sounds fine to me.

> Thoughts? We could probably simplify this if we could state that stepping an
> instruction in kernel space could only ever be interrupted by an interrupt.
> That's probably true for kprobes, but relying on it feels like it might bite
> us later on.

I think trying to simplify this is worthwhile. I'd rather make this do
less than try to account for a myriad rare and untested edge cases.

Thanks,
Mark.
