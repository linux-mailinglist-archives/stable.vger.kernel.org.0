Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E976C2057F8
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 18:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732408AbgFWQ4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 12:56:07 -0400
Received: from foss.arm.com ([217.140.110.172]:36038 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728916AbgFWQ4H (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 12:56:07 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D6B3B31B;
        Tue, 23 Jun 2020 09:56:06 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.20.203])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AD50F3F7BB;
        Tue, 23 Jun 2020 09:56:04 -0700 (PDT)
Date:   Tue, 23 Jun 2020 17:55:57 +0100
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
Message-ID: <20200623165557.GA12767@C02TD0UTHF1T.local>
References: <1592501369-27645-1-git-send-email-paul.gortmaker@windriver.com>
 <20200623155900.GA4777@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623155900.GA4777@willie-the-truck>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 23, 2020 at 04:59:01PM +0100, Will Deacon wrote:
> On Thu, Jun 18, 2020 at 01:29:29PM -0400, Paul Gortmaker wrote:
> > In commit d8bb6718c4db ("arm64: Make debug exception handlers visible
> > from RCU") debug_exception_enter and exit were added to deal with better
> > tracking of RCU state - however, in addition to that, but not mentioned
> > in the commit log, a preempt_disable/enable pair were also added.
> > 
> > Based on the comment (being removed here) it would seem that the pair
> > were not added to address a specific problem, but just as a proactive,
> > preventative measure - as in "seemed like a good idea at the time".
> > 
> > The problem is that do_debug_exception() eventually calls out to
> > generic kernel code like do_force_sig_info() which takes non-raw locks
> > and on -rt enabled kernels, results in things looking like the following,
> > since on -rt kernels, it is noticed that preemption is still disabled.
> > 
> >  BUG: sleeping function called from invalid context at kernel/locking/rtmutex.c:975
> >  in_atomic(): 1, irqs_disabled(): 0, pid: 35658, name: gdbtest
> >  Preemption disabled at:
> >  [<ffff000010081578>] do_debug_exception+0x38/0x1a4
> >  Call trace:
> >  dump_backtrace+0x0/0x138
> >  show_stack+0x24/0x30
> >  dump_stack+0x94/0xbc
> >  ___might_sleep+0x13c/0x168
> >  rt_spin_lock+0x40/0x80
> >  do_force_sig_info+0x30/0xe0
> >  force_sig_fault+0x64/0x90
> >  arm64_force_sig_fault+0x50/0x80
> >  send_user_sigtrap+0x50/0x80
> >  brk_handler+0x98/0xc8
> >  do_debug_exception+0x70/0x1a4
> >  el0_dbg+0x18/0x20
> > 
> > The reproducer was basically an automated gdb test that set a breakpoint
> > on a simple "hello world" program and then quit gdb once the breakpoint
> > was hit - i.e. "(gdb) A debugging session is active.  Quit anyway? "
> 
> Hmm, the debug exception handler path was definitely written with the
> expectation that preemption is disabled, so this is unfortunate. For
> exceptions from kernelspace, we need to keep that guarantee as we implement
> things like BUG() using this path. For exceptions from userspace, it's
> plausible that we could re-enable preemption, but then we should also
> re-enable interrupts and debug exceptions too because we don't
> context-switch pstate in switch_to() and we would end up with holes in our
> kernel debug coverage (and these might be fatal if e.g. single step doesn't
> work in a kprobe OOL buffer). However, that then means that any common code
> when handling user and kernel debug exceptions needs to be re-entrant,
> which it probably isn't at the moment (I haven't checked).

I'm pretty certain existing code is not reentrant, and regardless it's
going to be a mess to reason about this generally if we have to undo our
strict exception nesting rules.

I reckon we need to treat this like an NMI instead -- is that plausible?

Mark.
