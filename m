Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE3C2EB675
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 00:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbhAEXsF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 18:48:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:37464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726308AbhAEXsE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Jan 2021 18:48:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6487622D74;
        Tue,  5 Jan 2021 23:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609890443;
        bh=zcUE7a2/G58jNRImYuz4hpFGjeojWf+wyfALeIl/JyM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XnJuRnl16aEUAi/WbCI59ghPBzFiYyTEjYvWxbb2/uAJCgYc7R8MswFZmLMqeT5XE
         3VW/Ez7t/Xj2mfaIKN83cDHVm250+7zxqBNS/s1lkJPQjlD9Z/I4QLv09Mj3Y816AA
         SvovH8a73XH5jlI+8kaaZaC2fv0ltK0qzfbEGhJPWtku8u0Uofb8Fh66rjVplsPiFy
         tccpFuQgyfF0oyzBIMSQ6bJgJnzq6RC/RSFWApgRV/TYDr1XKadjDR+LnGxx5MlcF9
         Zm9yITa2MVr3IwDQMuo9SQQOHlq3RJP3oGZOsWjHu+L3VJwJnk+bloAaLMH5HcMEAV
         HCCbPaAynxfnA==
Date:   Wed, 6 Jan 2021 00:47:21 +0100
From:   Frederic Weisbecker <frederic@kernel.org>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Fabio Estevam <festevam@gmail.com>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Len Brown <lenb@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 1/4] sched/idle: Fix missing need_resched() check after
 rcu_idle_enter()
Message-ID: <20210105234721.GB68490@lothringen>
References: <20210104152058.36642-1-frederic@kernel.org>
 <20210104152058.36642-2-frederic@kernel.org>
 <20210105095503.GF3040@hirez.programming.kicks-ass.net>
 <20210105232510.GA16840@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105232510.GA16840@paulmck-ThinkPad-P72>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 05, 2021 at 03:25:10PM -0800, Paul E. McKenney wrote:
> On Tue, Jan 05, 2021 at 10:55:03AM +0100, Peter Zijlstra wrote:
> > On Mon, Jan 04, 2021 at 04:20:55PM +0100, Frederic Weisbecker wrote:
> > > Entering RCU idle mode may cause a deferred wake up of an RCU NOCB_GP
> > > kthread (rcuog) to be serviced.
> > > 
> > > Usually a wake up happening while running the idle task is spotted in
> > > one of the need_resched() checks carefully placed within the idle loop
> > > that can break to the scheduler.
> > 
> > Urgh, this is horrific and fragile :/ You having had to audit and fix a
> > number of rcu_idle_enter() callers should've made you realize that
> > making rcu_idle_enter() return something would've been saner.
> > 
> > Also, I might hope that when RCU does do that wakeup, it will not have
> > put RCU in idle mode? So it is a natural 'fail' state for
> > rcu_idle_enter(), *sigh* it continues to put RCU to sleep, so that needs
> > fixing too.
> 
> It depends on what is being awakened.  For example, the nocb rcuog
> and rcuoc kthreads might be well on some other CPU, so RCU might need
> the wakeup to happen, but might also need to go completely to sleep on
> this CPU.
> 
> But yes, if the wakeup needs to be on the current CPU, then idle must
> be exited and RCU needs to again be watching.  However, RCU has no idea
> what CPU the to-be-awakened kthread will be running on.  And even if
> it were to know at the time it does the wakeup, that kthread's location
> might well have changed by the time the current CPU enters idle.

A simple check for need_resched() would do the trick. Sure that could also
catch other sources of wake up that would have been otherwise handled once IRQs get
re-enabled but that's not a problem.

> 
> > I'm thinking that rcu_user_enter() will have the exact same problem? Did
> > you audit that?
> > 
> > Something like the below, combined with a fixup for all callers (which
> > the compiler will help us find thanks to __must_check).
> 
> Looks at least somewhat plausible at first glance.
> 
> Though given the above, it is possible (likely, even) that
> rcu_user_enter() returns true, but that this CPU still needs to enter
> idle.  So isn't a subsequent check of need_resched() or friends still
> required?  Or is your point that this will happen automatically upon
> exit from the idle loop?

Exactly, upon "wake_up_process(rdp_gp->nocb_gp_kthread)", we just need to
make sure that need_resched() is set before returning false, namely:

> > @@ -644,7 +644,14 @@ static noinstr void rcu_eqs_enter(bool user)
> >  	trace_rcu_dyntick(TPS("Start"), rdp->dynticks_nesting, 0, atomic_read(&rdp->dynticks));
> >  	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && !user && !is_idle_task(current));
> >  	rdp = this_cpu_ptr(&rcu_data);
> > -	do_nocb_deferred_wakeup(rdp);
> > +	if (do_nocb_deferred_wakeup(rdp)) {
> > +		/*
> > +		 * We did the wakeup, don't enter EQS, we'll need to abort idle
> > +		 * and schedule.
> > +		 */
> > +		return false;

Right here.

But still I think we should decouple the wake up from rcu_eqs_enter().

And have:

rcu_eqs_enter_prepare(): does the deferred wakeup and forbid from calling
call_rcu() from here.

rcu_eqs_enter(): enter RCU extended quiescent state

This way we can more easily fix the rcu_user_enter() case as it happens past
the last scheduler entrypoint before returning to userspace.

Thanks.
