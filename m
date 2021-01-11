Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0BC82F12A1
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 13:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbhAKMza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 07:55:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:47692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727328AbhAKMz3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 07:55:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CD0820728;
        Mon, 11 Jan 2021 12:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610369688;
        bh=HuyDIlefzS9pOGuogHytTfEprxzWqtveZHaAkNqfZug=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RVeE+oQDDb2JYoKRuuWXXU0FhMUSVglquRFu+sPNRZqW+MXlZAHdTSRxNoI337kGp
         iI125xwSGxZsFtixy0Sx9LSklRcLj2Ww+X2Os0TqMsx+nfhpZAsN3xbFuDBcqJeMKX
         2VBXhDHurokKjclQSweCHiyzhlSbPi57UOpotLG3DrFePLYlJqrxnh6ofxdvmsY1OK
         Nx3au6d+hAijkkv0iftaaPKLo0r2+Xb+dgjf+lUQBsJO09YpiCz3fllwLXORZwAco6
         wOeAEoiSeH6LC/4jJ7EZkzQf2uk7/g44/ArCg0ad7EgjRu6NKJP2MxAaw6+Q0UKznK
         EpUBfkQ45iuFQ==
Date:   Mon, 11 Jan 2021 13:54:46 +0100
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     "Paul E . McKenney" <paulmck@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: Re: [RFC PATCH 5/8] entry: Explicitly flush pending rcuog wakeup
 before last rescheduling points
Message-ID: <20210111125446.GE242508@lothringen>
References: <20210109020536.127953-1-frederic@kernel.org>
 <20210109020536.127953-6-frederic@kernel.org>
 <X/w/qBdnnQ5pFQxJ@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/w/qBdnnQ5pFQxJ@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 11, 2021 at 01:08:08PM +0100, Peter Zijlstra wrote:
> On Sat, Jan 09, 2021 at 03:05:33AM +0100, Frederic Weisbecker wrote:
> > Following the idle loop model, cleanly check for pending rcuog wakeup
> > before the last rescheduling point on resuming to user mode. This
> > way we can avoid to do it from rcu_user_enter() with the last resort
> > self-IPI hack that enforces rescheduling.
> > 
> > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar<mingo@kernel.org>
> > Cc: Paul E. McKenney <paulmck@kernel.org>
> > Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> >  kernel/entry/common.c |  6 ++++++
> >  kernel/rcu/tree.c     | 12 +++++++-----
> >  2 files changed, 13 insertions(+), 5 deletions(-)
> > 
> > diff --git a/kernel/entry/common.c b/kernel/entry/common.c
> > index 378341642f94..8f3292b5f9b7 100644
> > --- a/kernel/entry/common.c
> > +++ b/kernel/entry/common.c
> > @@ -178,6 +178,9 @@ static unsigned long exit_to_user_mode_loop(struct pt_regs *regs,
> >  		/* Architecture specific TIF work */
> >  		arch_exit_to_user_mode_work(regs, ti_work);
> >  
> > +		/* Check if any of the above work has queued a deferred wakeup */
> > +		rcu_nocb_flush_deferred_wakeup();
> > +
> >  		/*
> >  		 * Disable interrupts and reevaluate the work flags as they
> >  		 * might have changed while interrupts and preemption was
> > @@ -197,6 +200,9 @@ static void exit_to_user_mode_prepare(struct pt_regs *regs)
> >  
> >  	lockdep_assert_irqs_disabled();
> >  
> > +	/* Flush pending rcuog wakeup before the last need_resched() check */
> > +	rcu_nocb_flush_deferred_wakeup();
> > +
> >  	if (unlikely(ti_work & EXIT_TO_USER_MODE_WORK))
> >  		ti_work = exit_to_user_mode_loop(regs, ti_work);
> >  
> > diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> > index 2920dfc9f58c..3c4c0d5cea65 100644
> > --- a/kernel/rcu/tree.c
> > +++ b/kernel/rcu/tree.c
> > @@ -705,12 +705,14 @@ noinstr void rcu_user_enter(void)
> >  
> >  	lockdep_assert_irqs_disabled();
> >  	/*
> > -	 * We may be past the last rescheduling opportunity in the entry code.
> > -	 * Trigger a self IPI that will fire and reschedule once we resume to
> > -	 * user/guest mode.
> > +	 * Other than generic entry implementation, we may be past the last
> > +	 * rescheduling opportunity in the entry code. Trigger a self IPI
> > +	 * that will fire and reschedule once we resume in user/guest mode.
> >  	 */
> > -	if (do_nocb_deferred_wakeup(rdp) && need_resched())
> > -		irq_work_queue(this_cpu_ptr(&late_wakeup_work));
> > +	if (!IS_ENABLED(CONFIG_GENERIC_ENTRY) || (current->flags & PF_VCPU)) {
> 
> We have xfer_to_guest_mode_work() for that PF_VCPU case.

Ah very nice! I'll integrate that on the next iteration.

Thanks.

> 
> > +		if (do_nocb_deferred_wakeup(rdp) && need_resched())
> > +			irq_work_queue(this_cpu_ptr(&late_wakeup_work));
> > +	}
