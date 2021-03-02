Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5399D32B254
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343605AbhCCAxL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:53:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:45264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352198AbhCBS2y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 13:28:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8613A64EF4;
        Tue,  2 Mar 2021 18:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614709050;
        bh=Fvi+JXEEStlOtsOeG6Q7KIKVk9kG6/Bwve6drLAQeqU=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=CN1jLRVEVUGYvd4/y8lmv5wrHxNXBeD1a7VuTEbrvhTb78c3ZbDKk7UMIQVVnMGrh
         zI3Z1YqX+ZP9yAvDBb2lQQgqsW8QYQK40B4/V88T6TQT97VldLUJtACIjJ0kbr7nUq
         kVim20tPLJjx79zYsjiYdRmULWKqPbmepWaBRVeZAVyjM9nZSHyfe0aaDFRPmN3X5J
         sfL14SgjqXuCq6hau5FBSDBVtKzsMCa+Fma1QEACU4z8glaAnHVt5S1iRM16QmgcFS
         dBzoz9LjoDhgyUvix3Ty5T+iGJYYIErNHPpl/pKlcPJuVwWXVrMGw7fJlFfnkfgmcH
         yIsRT33GgzFlw==
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 02B45352259C; Tue,  2 Mar 2021 10:17:29 -0800 (PST)
Date:   Tue, 2 Mar 2021 10:17:29 -0800
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
Message-ID: <20210302181729.GN2696@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20210223001011.127063-1-frederic@kernel.org>
 <20210223001011.127063-2-frederic@kernel.org>
 <20210224183709.GI2743@paulmck-ThinkPad-P72>
 <20210224220606.GA3179@lothringen>
 <20210302014829.GK2696@paulmck-ThinkPad-P72>
 <20210302123444.GA97498@lothringen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210302123444.GA97498@lothringen>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 02, 2021 at 01:34:44PM +0100, Frederic Weisbecker wrote:
> On Mon, Mar 01, 2021 at 05:48:29PM -0800, Paul E. McKenney wrote:
> > On Wed, Feb 24, 2021 at 11:06:06PM +0100, Frederic Weisbecker wrote:
> > > On Wed, Feb 24, 2021 at 10:37:09AM -0800, Paul E. McKenney wrote:
> > > > On Tue, Feb 23, 2021 at 01:09:59AM +0100, Frederic Weisbecker wrote:
> > > > > Two situations can cause a missed nocb timer rearm:
> > > > > 
> > > > > 1) rdp(CPU A) queues its nocb timer. The grace period elapses before
> > > > >    the timer get a chance to fire. The nocb_gp kthread is awaken by
> > > > >    rdp(CPU B). The nocb_cb kthread for rdp(CPU A) is awaken and
> > > > >    process the callbacks, again before the nocb_timer for CPU A get a
> > > > >    chance to fire. rdp(CPU A) queues a callback and wakes up nocb_gp
> > > > >    kthread, cancelling the pending nocb_timer without resetting the
> > > > >    corresponding nocb_defer_wakeup.
> > > > 
> > > > As discussed offlist, expanding the above scenario results in this
> > > > sequence of steps:
> > 
> > I renumbered the CPUs, since the ->nocb_gp_kthread would normally be
> > associated with CPU 0.  If the first CPU to enqueue a callback was also
> > CPU 0, nocb_gp_wait() might clear that CPU's ->nocb_defer_wakeup, which
> > would prevent this scenario from playing out.  (But admittedly only if
> > some other CPU handled by this same ->nocb_gp_kthread used its bypass.)
> 
> Ok good point.
> 
> > 
> > > > 1.	There are no callbacks queued for any CPU covered by CPU 0-2's
> > > > 	->nocb_gp_kthread.
> > 
> > And ->nocb_gp_kthread is associated with CPU 0.
> > 
> > > > 2.	CPU 1 enqueues its first callback with interrupts disabled, and
> > > > 	thus must defer awakening its ->nocb_gp_kthread.  It therefore
> > > > 	queues its rcu_data structure's ->nocb_timer.
> > 
> > At this point, CPU 1's rdp->nocb_defer_wakeup is RCU_NOCB_WAKE.
> 
> Right.
> 
> > > > 7.	The grace period ends, so rcu_gp_kthread awakens the
> > > > 	->nocb_gp_kthread, which in turn awakens both CPU 1's and
> > > > 	CPU 2's ->nocb_cb_kthread.
> > 
> > And then ->nocb_cb_kthread sleeps waiting for more callbacks.
> 
> Yep
> 
> > > I managed to recollect some pieces of my brain. So keep the above but
> > > let's change the point 10:
> > > 
> > > 10.	CPU 1 enqueues its second callback, this time with interrupts
> > >  	enabled so it can wake directly	->nocb_gp_kthread.
> > > 	It does so with calling __wake_nocb_gp() which also cancels the
> > 
> > wake_nocb_gp() in current -rcu, correct?
> 
> Heh, right.
> 
> > > > So far so good, but why isn't the timer still queued from back in step 2?
> > > > What am I missing here?  Either way, could you please update the commit
> > > > logs to tell the full story?  At some later time, you might be very
> > > > happy that you did.  ;-)
> > > > 
> > > > > 2) The "nocb_bypass_timer" ends up calling wake_nocb_gp() which deletes
> > > > >    the pending "nocb_timer" (note they are not the same timers) for the
> > > > >    given rdp without resetting the matching state stored in nocb_defer
> > > > >    wakeup.
> > 
> > Would like to similarly expand this one, or would you prefer to rest your
> > case on Case 1) above?
> 
> I was about to say that we can skip that one, the changelog will already be
> big enough but the "Fixes:" tag refers to the second scenario, since it's the
> oldest vulnerable commit AFAICS.
> 
> > > > > Fixes: d1b222c6be1f (rcu/nocb: Add bypass callback queueing)

OK, how about if I queue a temporary commit (shown below) that just
calls out the first scenario so that I can start testing, and you get
me more detail on the second scenario?  I can then update the commit.

							Thanx, Paul

------------------------------------------------------------------------

commit 302fd54b9ae98f678624cbf9bf7a4ca88455a8f9
Author: Frederic Weisbecker <frederic@kernel.org>
Date:   Tue Feb 23 01:09:59 2021 +0100

    rcu/nocb: Fix missed nocb_timer requeue
    
    This sequence of events can lead to a failure to requeue a CPU's
    ->nocb_timer:
    
    1.      There are no callbacks queued for any CPU covered by CPU 0-2's
            ->nocb_gp_kthread.  Note that ->nocb_gp_kthread is associated
            with CPU 0.
    
    2.      CPU 1 enqueues its first callback with interrupts disabled, and
            thus must defer awakening its ->nocb_gp_kthread.  It therefore
            queues its rcu_data structure's ->nocb_timer.  At this point,
            CPU 1's rdp->nocb_defer_wakeup is RCU_NOCB_WAKE.
    
    3.      CPU 2, which shares the same ->nocb_gp_kthread, also enqueues a
            callback, but with interrupts enabled, allowing it to directly
            awaken the ->nocb_gp_kthread.
    
    4.      The newly awakened ->nocb_gp_kthread associates both CPU 1's
            and CPU 2's callbacks with a future grace period and arranges
            for that grace period to be started.
    
    5.      This ->nocb_gp_kthread goes to sleep waiting for the end of this
            future grace period.
    
    6.      This grace period elapses before the CPU 1's timer fires.
            This is normally improbably given that the timer is set for only
            one jiffy, but timers can be delayed.  Besides, it is possible
            that kernel was built with CONFIG_RCU_STRICT_GRACE_PERIOD=y.
    
    7.      The grace period ends, so rcu_gp_kthread awakens the
            ->nocb_gp_kthread, which in turn awakens both CPU 1's and
            CPU 2's ->nocb_cb_kthread.  Then ->nocb_gb_kthread sleeps
            waiting for more newly queued callbacks.
    
    8.      CPU 1's ->nocb_cb_kthread invokes its callback, then sleeps
            waiting for more invocable callbacks.
    
    9.      Note that neither kthread updated any ->nocb_timer state,
            so CPU 1's ->nocb_defer_wakeup is still set to RCU_NOCB_WAKE.
    
    10.     CPU 1 enqueues its second callback, this time with interrupts
            enabled so it can wake directly ->nocb_gp_kthread.
            It does so with calling wake_nocb_gp() which also cancels the
            pending timer that got queued in step 2. But that doesn't reset
            CPU 1's ->nocb_defer_wakeup which is still set to RCU_NOCB_WAKE.
            So CPU 1's ->nocb_defer_wakeup and its ->nocb_timer are now
            desynchronized.
    
    11.     ->nocb_gp_kthread associates the callback queued in 10 with a new
            grace period, arranges for that grace period to start and sleeps
            waiting for it to complete.
    
    12.     The grace period ends, rcu_gp_kthread awakens ->nocb_gp_kthread,
            which in turn wakes up CPU 1's ->nocb_cb_kthread which then
            invokes the callback queued in 10.
    
    13.     CPU 1 enqueues its third callback, this time with interrupts
            disabled so it must queue a timer for a deferred wakeup. However
            the value of its ->nocb_defer_wakeup is RCU_NOCB_WAKE which
            incorrectly indicates that a timer is already queued.  Instead,
            CPU 1's ->nocb_timer was cancelled in 10.  CPU 1 therefore fails
            to queue the ->nocb_timer.
    
    14.     CPU 1 has its pending callback and it may go unnoticed until
            some other CPU ever wakes up ->nocb_gp_kthread or CPU 1 ever
            calls an explicit deferred wakeup, for example, during idle entry.
    
    This commit fixes this bug by resetting rdp->nocb_defer_wakeup everytime
    we delete the ->nocb_timer.
    
    Fixes: d1b222c6be1f (rcu/nocb: Add bypass callback queueing)
    Cc: Stable <stable@vger.kernel.org>
    Cc: Josh Triplett <josh@joshtriplett.org>
    Cc: Lai Jiangshan <jiangshanlai@gmail.com>
    Cc: Joel Fernandes <joel@joelfernandes.org>
    Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
    Cc: Boqun Feng <boqun.feng@gmail.com>
    Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
    Signed-off-by: Paul E. McKenney <paulmck@kernel.org>

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 44746d8..429491d 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1721,7 +1721,11 @@ static bool wake_nocb_gp(struct rcu_data *rdp, bool force,
 		rcu_nocb_unlock_irqrestore(rdp, flags);
 		return false;
 	}
-	del_timer(&rdp->nocb_timer);
+
+	if (READ_ONCE(rdp->nocb_defer_wakeup) > RCU_NOCB_WAKE_NOT) {
+		WRITE_ONCE(rdp->nocb_defer_wakeup, RCU_NOCB_WAKE_NOT);
+		del_timer(&rdp->nocb_timer);
+	}
 	rcu_nocb_unlock_irqrestore(rdp, flags);
 	raw_spin_lock_irqsave(&rdp_gp->nocb_gp_lock, flags);
 	if (force || READ_ONCE(rdp_gp->nocb_gp_sleep)) {
@@ -2350,7 +2354,6 @@ static bool do_nocb_deferred_wakeup_common(struct rcu_data *rdp)
 		return false;
 	}
 	ndw = READ_ONCE(rdp->nocb_defer_wakeup);
-	WRITE_ONCE(rdp->nocb_defer_wakeup, RCU_NOCB_WAKE_NOT);
 	ret = wake_nocb_gp(rdp, ndw == RCU_NOCB_WAKE_FORCE, flags);
 	trace_rcu_nocb_wake(rcu_state.name, rdp->cpu, TPS("DeferredWake"));
 
