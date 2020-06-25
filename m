Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 240D220A28B
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 18:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390491AbgFYQDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 12:03:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389860AbgFYQDH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jun 2020 12:03:07 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9D5620775;
        Thu, 25 Jun 2020 16:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593100986;
        bh=K6JHJo/0IjNgaEcWgtsnvmvPHucK9EUSVBDBkHLL2CM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1eSXYhjUSJAxKnnLB/JGk7y6Vp6r2rsR5B7R4JQHb1kNA4Pa+yP7ujk6HFKI6uJPa
         r0mgQpQ1+O3WvKtmwQ/YWfFHuPt6/WcDJR6zlQAmpDIVVR/nS1oq0KlCXFlUwMxeBR
         bmTsvVyoS6k8fF9bW2h9YXKVIEGA3Wg3abml4m9k=
Date:   Fri, 26 Jun 2020 01:03:02 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     Will Deacon <will@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        "Paul E . McKenney" <paulmck@linux.ibm.com>,
        James Morse <james.morse@arm.com>
Subject: Re: [PATCH] arm64: don't preempt_disable in do_debug_exception
Message-Id: <20200626010302.0b5b00aed36fdaf6d630bee5@kernel.org>
In-Reply-To: <20200623165557.GA12767@C02TD0UTHF1T.local>
References: <1592501369-27645-1-git-send-email-paul.gortmaker@windriver.com>
        <20200623155900.GA4777@willie-the-truck>
        <20200623165557.GA12767@C02TD0UTHF1T.local>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 23 Jun 2020 17:55:57 +0100
Mark Rutland <mark.rutland@arm.com> wrote:

> On Tue, Jun 23, 2020 at 04:59:01PM +0100, Will Deacon wrote:
> > On Thu, Jun 18, 2020 at 01:29:29PM -0400, Paul Gortmaker wrote:
> > > In commit d8bb6718c4db ("arm64: Make debug exception handlers visible
> > > from RCU") debug_exception_enter and exit were added to deal with better
> > > tracking of RCU state - however, in addition to that, but not mentioned
> > > in the commit log, a preempt_disable/enable pair were also added.
> > > 
> > > Based on the comment (being removed here) it would seem that the pair
> > > were not added to address a specific problem, but just as a proactive,
> > > preventative measure - as in "seemed like a good idea at the time".
> > > 
> > > The problem is that do_debug_exception() eventually calls out to
> > > generic kernel code like do_force_sig_info() which takes non-raw locks
> > > and on -rt enabled kernels, results in things looking like the following,
> > > since on -rt kernels, it is noticed that preemption is still disabled.
> > > 
> > >  BUG: sleeping function called from invalid context at kernel/locking/rtmutex.c:975
> > >  in_atomic(): 1, irqs_disabled(): 0, pid: 35658, name: gdbtest
> > >  Preemption disabled at:
> > >  [<ffff000010081578>] do_debug_exception+0x38/0x1a4
> > >  Call trace:
> > >  dump_backtrace+0x0/0x138
> > >  show_stack+0x24/0x30
> > >  dump_stack+0x94/0xbc
> > >  ___might_sleep+0x13c/0x168
> > >  rt_spin_lock+0x40/0x80
> > >  do_force_sig_info+0x30/0xe0
> > >  force_sig_fault+0x64/0x90
> > >  arm64_force_sig_fault+0x50/0x80
> > >  send_user_sigtrap+0x50/0x80
> > >  brk_handler+0x98/0xc8
> > >  do_debug_exception+0x70/0x1a4
> > >  el0_dbg+0x18/0x20
> > > 
> > > The reproducer was basically an automated gdb test that set a breakpoint
> > > on a simple "hello world" program and then quit gdb once the breakpoint
> > > was hit - i.e. "(gdb) A debugging session is active.  Quit anyway? "
> > 
> > Hmm, the debug exception handler path was definitely written with the
> > expectation that preemption is disabled, so this is unfortunate. For
> > exceptions from kernelspace, we need to keep that guarantee as we implement
> > things like BUG() using this path. For exceptions from userspace, it's
> > plausible that we could re-enable preemption, but then we should also
> > re-enable interrupts and debug exceptions too because we don't
> > context-switch pstate in switch_to() and we would end up with holes in our
> > kernel debug coverage (and these might be fatal if e.g. single step doesn't
> > work in a kprobe OOL buffer). However, that then means that any common code
> > when handling user and kernel debug exceptions needs to be re-entrant,
> > which it probably isn't at the moment (I haven't checked).
> 
> I'm pretty certain existing code is not reentrant, and regardless it's
> going to be a mess to reason about this generally if we have to undo our
> strict exception nesting rules.

Sounds like a kprobe post-handler hits another kprobe, which might invoke
the debug handler in debug context. If kprobes find that, it skips the
nested one, but it needs to do single stepping in it to exit.
Is that not possible on arm64?

Thank you,

> 
> I reckon we need to treat this like an NMI instead -- is that plausible?
> 
> Mark.


-- 
Masami Hiramatsu <mhiramat@kernel.org>
