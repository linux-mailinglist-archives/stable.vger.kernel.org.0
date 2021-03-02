Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9199B32AEA2
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 03:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234643AbhCBX6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 18:58:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:44478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380206AbhCBBtM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 20:49:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39A29601FF;
        Tue,  2 Mar 2021 01:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614649710;
        bh=/XPX7Hhm7eIzJqYzIL1g1QrveY2QUuhKuNxsPI+M/Lg=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=OQtTyVEWhhueoTJWWJukOuLIJ4cilMcNr1Ff6AC3e8s04qSfsyeIkNpvwlnTMUAAR
         D4M0u8C+yhV8cib+TLADxRy05Rn3AI30xgBYueNMjOOxvyZC9NfDYHJ0x3RSMWcO/g
         8cJrLvytDdaaNcmXb70lIp1EjHY5CisRcgu74YpUqyc0vZi5+0CgVkKnApM5+8QWpw
         K5ox6VN0II+nopJ1wTRjcMtWPcbj0Ajd+MBV0YhWmk2HkWzP9ncjdT/Hv7yHi/BtHK
         ujqPfXzKa24JZB/HJVbjw47DKW5giqUg9WCwKLKP9bV1GTsPqnawUM6E44byDPOq8V
         kxvyCP7lxK0Dw==
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id CE7DD35239CA; Mon,  1 Mar 2021 17:48:29 -0800 (PST)
Date:   Mon, 1 Mar 2021 17:48:29 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Boqun Feng <boqun.feng@gmail.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Stable <stable@vger.kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH 01/13] rcu/nocb: Fix potential missed nocb_timer rearm
Message-ID: <20210302014829.GK2696@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20210223001011.127063-1-frederic@kernel.org>
 <20210223001011.127063-2-frederic@kernel.org>
 <20210224183709.GI2743@paulmck-ThinkPad-P72>
 <20210224220606.GA3179@lothringen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224220606.GA3179@lothringen>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 24, 2021 at 11:06:06PM +0100, Frederic Weisbecker wrote:
> On Wed, Feb 24, 2021 at 10:37:09AM -0800, Paul E. McKenney wrote:
> > On Tue, Feb 23, 2021 at 01:09:59AM +0100, Frederic Weisbecker wrote:
> > > Two situations can cause a missed nocb timer rearm:
> > > 
> > > 1) rdp(CPU A) queues its nocb timer. The grace period elapses before
> > >    the timer get a chance to fire. The nocb_gp kthread is awaken by
> > >    rdp(CPU B). The nocb_cb kthread for rdp(CPU A) is awaken and
> > >    process the callbacks, again before the nocb_timer for CPU A get a
> > >    chance to fire. rdp(CPU A) queues a callback and wakes up nocb_gp
> > >    kthread, cancelling the pending nocb_timer without resetting the
> > >    corresponding nocb_defer_wakeup.
> > 
> > As discussed offlist, expanding the above scenario results in this
> > sequence of steps:

I renumbered the CPUs, since the ->nocb_gp_kthread would normally be
associated with CPU 0.  If the first CPU to enqueue a callback was also
CPU 0, nocb_gp_wait() might clear that CPU's ->nocb_defer_wakeup, which
would prevent this scenario from playing out.  (But admittedly only if
some other CPU handled by this same ->nocb_gp_kthread used its bypass.)

> > 1.	There are no callbacks queued for any CPU covered by CPU 0-2's
> > 	->nocb_gp_kthread.

And ->nocb_gp_kthread is associated with CPU 0.

> > 2.	CPU 1 enqueues its first callback with interrupts disabled, and
> > 	thus must defer awakening its ->nocb_gp_kthread.  It therefore
> > 	queues its rcu_data structure's ->nocb_timer.

At this point, CPU 1's rdp->nocb_defer_wakeup is RCU_NOCB_WAKE.

> > 3.	CPU 2, which shares the same ->nocb_gp_kthread, also enqueues a
> > 	callback, but with interrupts enabled, allowing it to directly
> > 	awaken the ->nocb_gp_kthread.
> > 
> > 4.	The newly awakened ->nocb_gp_kthread associates both CPU 1's
> > 	and CPU 2's callbacks with a future grace period and arranges
> > 	for that grace period to be started.
> > 
> > 5.	This ->nocb_gp_kthread goes to sleep waiting for the end of this
> > 	future grace period.
> > 
> > 6.	This grace period elapses before the CPU 1's timer fires.
> > 	This is normally improbably given that the timer is set for only
> > 	one jiffy, but timers can be delayed.  Besides, it is possible
> > 	that kernel was built with CONFIG_RCU_STRICT_GRACE_PERIOD=y.
> > 
> > 7.	The grace period ends, so rcu_gp_kthread awakens the
> > 	->nocb_gp_kthread, which in turn awakens both CPU 1's and
> > 	CPU 2's ->nocb_cb_kthread.

And then ->nocb_cb_kthread sleeps waiting for more callbacks.

> > 8.	CPU 1's ->nocb_cb_kthread invokes its callback.
> > 
> > 9.	Note that neither kthread updated any ->nocb_timer state,
> > 	so CPU 1's ->nocb_defer_wakeup is still set to RCU_NOCB_WAKE.
> > 
> > 10.	CPU 1 enqueues its second callback, again with interrupts
> > 	disabled, and thus must again defer awakening its
> > 	->nocb_gp_kthread.  However, ->nocb_defer_wakeup prevents
> > 	CPU 1 from queueing the timer.
> 
> I managed to recollect some pieces of my brain. So keep the above but
> let's change the point 10:
> 
> 10.	CPU 1 enqueues its second callback, this time with interrupts
>  	enabled so it can wake directly	->nocb_gp_kthread.
> 	It does so with calling __wake_nocb_gp() which also cancels the

wake_nocb_gp() in current -rcu, correct?

> 	pending timer that got queued in step 2. But that doesn't reset
> 	CPU 1's ->nocb_defer_wakeup which is still set to RCU_NOCB_WAKE.
> 	So CPU 1's ->nocb_defer_wakeup and CPU 1's ->nocb_timer are now
> 	desynchronized.

Agreed, and agreed that this is a bug.  Thank you for persisting on
this one!

> 11.	->nocb_gp_kthread associates the callback queued in 10 with a new
> 	grace period, arrange for it to start and sleeps on it.
> 
> 12.	The grace period ends, ->nocb_gp_kthread awakens and wakes up
> 	CPU 1's ->nocb_cb_kthread which invokes the callback queued in 10.
> 
> 13.	CPU 1 enqueues its third callback, this time with interrupts
> 	disabled so it tries to queue a deferred wakeup. However
> 	->nocb_defer_wakeup has a stalled RCU_NOCB_WAKE value which prevents
> 	the CPU 1's ->nocb_timer, that got cancelled in 10, from being armed.
> 
> 14.	CPU 1 has its pending callback and it may go unnoticed until
> 	some other CPU ever wakes up ->nocb_gp_kthread or CPU 1 ever calls
> 	an explicit deferred wake up caller like idle entry.
> 
> I hope I'm not missing something this time...

If you are missing something, then so am I!  ;-)

> > So far so good, but why isn't the timer still queued from back in step 2?
> > What am I missing here?  Either way, could you please update the commit
> > logs to tell the full story?  At some later time, you might be very
> > happy that you did.  ;-)
> > 
> > > 2) The "nocb_bypass_timer" ends up calling wake_nocb_gp() which deletes
> > >    the pending "nocb_timer" (note they are not the same timers) for the
> > >    given rdp without resetting the matching state stored in nocb_defer
> > >    wakeup.

Would like to similarly expand this one, or would you prefer to rest your
case on Case 1) above?

							Thanx, Paul

> > > On both situations, a future call_rcu() on that rdp may be fooled and
> > > think the timer is armed when it's not, missing a deferred nocb_gp
> > > wakeup.
> > > 
> > > Case 1) is very unlikely due to timing constraint (the timer fires after
> > > 1 jiffy) but still possible in theory. Case 2) is more likely to happen.
> > > But in any case such scenario require the CPU to spend a long time
> > > within a kernel thread without exiting to idle or user space, which is
> > > a pretty exotic behaviour.
> > > 
> > > Fix this with resetting rdp->nocb_defer_wakeup everytime we disarm the
> > > timer.
> > > 
> > > Fixes: d1b222c6be1f (rcu/nocb: Add bypass callback queueing)
> > > Cc: Stable <stable@vger.kernel.org>
> > > Cc: Josh Triplett <josh@joshtriplett.org>
> > > Cc: Lai Jiangshan <jiangshanlai@gmail.com>
> > > Cc: Joel Fernandes <joel@joelfernandes.org>
> > > Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
> > > Cc: Boqun Feng <boqun.feng@gmail.com>
> > > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > > ---
> > >  kernel/rcu/tree_plugin.h | 7 +++++--
> > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> > > index 2ec9d7f55f99..dd0dc66c282d 100644
> > > --- a/kernel/rcu/tree_plugin.h
> > > +++ b/kernel/rcu/tree_plugin.h
> > > @@ -1720,7 +1720,11 @@ static bool wake_nocb_gp(struct rcu_data *rdp, bool force,
> > >  		rcu_nocb_unlock_irqrestore(rdp, flags);
> > >  		return false;
> > >  	}
> > > -	del_timer(&rdp->nocb_timer);
> > > +
> > > +	if (READ_ONCE(rdp->nocb_defer_wakeup) > RCU_NOCB_WAKE_NOT) {
> > > +		WRITE_ONCE(rdp->nocb_defer_wakeup, RCU_NOCB_WAKE_NOT);
> > > +		del_timer(&rdp->nocb_timer);
> > > +	}
> > >  	rcu_nocb_unlock_irqrestore(rdp, flags);
> > >  	raw_spin_lock_irqsave(&rdp_gp->nocb_gp_lock, flags);
> > >  	if (force || READ_ONCE(rdp_gp->nocb_gp_sleep)) {
> > > @@ -2349,7 +2353,6 @@ static bool do_nocb_deferred_wakeup_common(struct rcu_data *rdp)
> > >  		return false;
> > >  	}
> > >  	ndw = READ_ONCE(rdp->nocb_defer_wakeup);
> > > -	WRITE_ONCE(rdp->nocb_defer_wakeup, RCU_NOCB_WAKE_NOT);
> > >  	ret = wake_nocb_gp(rdp, ndw == RCU_NOCB_WAKE_FORCE, flags);
> > >  	trace_rcu_nocb_wake(rcu_state.name, rdp->cpu, TPS("DeferredWake"));
> > >  
> > > -- 
> > > 2.25.1
> > > 
