Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13FA62F125D
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 13:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbhAKMfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 07:35:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:44704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbhAKMfx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 07:35:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62179223DB;
        Mon, 11 Jan 2021 12:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610368513;
        bh=mg/Imn7k+NULxFNAhHU+LBlwGl7PuKLLZ/KT9Jr1zak=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RqmZLseJPCgyZCcc9uVsyvhrdFOhuF6kWEfNFtuylgh1N2gCiqK0WGyk5h085Ea4F
         PWi2hkC5xIa6T4+k59Qf0AIaYmfAPJEjPpa/n5Cc8SvTeISzpelSftpQSTjs0cJgCA
         wLICyuz5gBzCyZfJ/kTJuWqCUVESFIr873LEMCfszv2cLr9GEEYeASKqw9vpYYuRYt
         UPKQ9coHB+ua6ffoLJMSt57u/NUE1Eyxmyqi6DR50M4pJjb7NF20JKUjpvESZVjP5A
         PXxJiaT2tSLzWVRpzwWCmPHfRdPYTGAeENFX08GjzspjoefQjGWY7A7AI2lSAyLgAO
         UXlVEYhM3+ajg==
Date:   Mon, 11 Jan 2021 13:35:10 +0100
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     "Paul E . McKenney" <paulmck@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: Re: [RFC PATCH 4/8] rcu/nocb: Trigger self-IPI on late deferred wake
 up before user resume
Message-ID: <20210111123510.GD242508@lothringen>
References: <20210109020536.127953-1-frederic@kernel.org>
 <20210109020536.127953-5-frederic@kernel.org>
 <X/w+yJmCBnDWxtoE@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/w+yJmCBnDWxtoE@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 11, 2021 at 01:04:24PM +0100, Peter Zijlstra wrote:
> > +static DEFINE_PER_CPU(struct irq_work, late_wakeup_work) =
> > +	IRQ_WORK_INIT(late_wakeup_func);
> > +
> >  /**
> >   * rcu_user_enter - inform RCU that we are resuming userspace.
> >   *
> > @@ -692,9 +704,17 @@ noinstr void rcu_user_enter(void)
> >  	struct rcu_data *rdp = this_cpu_ptr(&rcu_data);
> >  
> >  	lockdep_assert_irqs_disabled();
> > -	do_nocb_deferred_wakeup(rdp);
> > +	/*
> > +	 * We may be past the last rescheduling opportunity in the entry code.
> > +	 * Trigger a self IPI that will fire and reschedule once we resume to
> > +	 * user/guest mode.
> > +	 */
> > +	if (do_nocb_deferred_wakeup(rdp) && need_resched())
> > +		irq_work_queue(this_cpu_ptr(&late_wakeup_work));
> > +
> >  	rcu_eqs_enter(true);
> >  }
> 
> Do we have the guarantee that every architecture that supports NOHZ_FULL
> has arch_irq_work_raise() on?

Yes it's a requirement for NOHZ_FULL to work. But you make me realize this
is tacit and isn't constrained anywhere in the code. I'm going to add
HAVE_IRQ_WORK_RAISE and replace the weak definition with a config
based.

> 
> Also, can't you do the same thing you did earlier and do that wakeup
> thing before we complete exit_to_user_mode_prepare() ?

I do it for CONFIG_GENERIC_ENTRY but the other architectures have their own
exit to user loop that I would need to audit and make sure that interrupts aren't
ever re-enabled before resuming to user and there is no possible rescheduling
point. I could manage to handle arm and arm64 but the others scare me:

$ git grep HAVE_CONTEXT_TRACKING
arch/csky/Kconfig:      select HAVE_CONTEXT_TRACKING
arch/mips/Kconfig:      select HAVE_CONTEXT_TRACKING
arch/powerpc/Kconfig:   select HAVE_CONTEXT_TRACKING            if PPC64
arch/riscv/Kconfig:     select HAVE_CONTEXT_TRACKING
arch/sparc/Kconfig:     select HAVE_CONTEXT_TRACKING

:-s
