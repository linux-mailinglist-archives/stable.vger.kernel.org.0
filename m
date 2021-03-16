Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9B4833CA3C
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 01:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbhCPACr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 20:02:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:54120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232311AbhCPACY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 20:02:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7C7964F69;
        Tue, 16 Mar 2021 00:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615852943;
        bh=cCPtcfC6y/bQ53uA3JP2Q60s/aTHQrbfUVjCzmiQHos=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=RSX+b6Yr2sYWezhjbeEVcKNjFqYY9Xt6woqN9ml0lUuow8y1NSmRhZSVtcO1Qllk6
         yFg1Md00BdFaTuAYKZVDgK7u9XJCLBUUTqAh39Kal7K8NmxBxG7PXwfgFTI2TumPu/
         5+TS1wjFO5u/hPc4FVQIX9Xfs/ZRSJiZiR4idkMR8Wy+Z/PHgcioofmZyRaGFZV9Bo
         GvdlS35QWR57iPTDH5EaDTbgKbvGHMiH1qOngOe0Ak4mHQaFGn1xjCiOBcS/pHJdhI
         ipDUmCecWflXmBS7yLNknZniaxp3MCCNpFU0DNPbcXMlfukcMvbS+qn1/l/illOzjQ
         bWrIDLNohcrPA==
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 8FA7635226FD; Mon, 15 Mar 2021 17:02:23 -0700 (PDT)
Date:   Mon, 15 Mar 2021 17:02:23 -0700
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
Subject: Re: [PATCH 05/13] rcu/nocb: Use the rcuog CPU's ->nocb_timer
Message-ID: <20210316000223.GR2696@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20210223001011.127063-1-frederic@kernel.org>
 <20210223001011.127063-6-frederic@kernel.org>
 <20210303011557.GA20917@paulmck-ThinkPad-P72>
 <20210310220507.GA2949@lothringen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310220507.GA2949@lothringen>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 10, 2021 at 11:05:07PM +0100, Frederic Weisbecker wrote:
> On Tue, Mar 02, 2021 at 05:15:57PM -0800, Paul E. McKenney wrote:
> > The first question is of course: Did you try this with lockdep enabled?  ;-)
> 
> Yep I always do. But I may miss some configs on my testings. I usually
> test at least TREE01 on x86 and arm64.
> 
> > > @@ -1702,43 +1692,50 @@ bool rcu_is_nocb_cpu(int cpu)
> > >  	return false;
> > >  }
> > >  
> > > -/*
> > > - * Kick the GP kthread for this NOCB group.  Caller holds ->nocb_lock
> > > - * and this function releases it.
> > > - */
> > > -static bool wake_nocb_gp(struct rcu_data *rdp, bool force,
> > > -			 unsigned long flags)
> > > -	__releases(rdp->nocb_lock)
> > > +static bool __wake_nocb_gp(struct rcu_data *rdp_gp,
> > > +			   struct rcu_data *rdp,
> > > +			   bool force, unsigned long flags)
> > > +	__releases(rdp_gp->nocb_gp_lock)
> > >  {
> > >  	bool needwake = false;
> > > -	struct rcu_data *rdp_gp = rdp->nocb_gp_rdp;
> > >  
> > > -	lockdep_assert_held(&rdp->nocb_lock);
> > >  	if (!READ_ONCE(rdp_gp->nocb_gp_kthread)) {
> > > -		rcu_nocb_unlock_irqrestore(rdp, flags);
> > > +		raw_spin_unlock_irqrestore(&rdp_gp->nocb_gp_lock, flags);
> > >  		trace_rcu_nocb_wake(rcu_state.name, rdp->cpu,
> > >  				    TPS("AlreadyAwake"));
> > >  		return false;
> > >  	}
> > >  
> > > -	if (READ_ONCE(rdp->nocb_defer_wakeup) > RCU_NOCB_WAKE_NOT) {
> > > -		WRITE_ONCE(rdp->nocb_defer_wakeup, RCU_NOCB_WAKE_NOT);
> > > -		del_timer(&rdp->nocb_timer);
> > > +	if (rdp_gp->nocb_defer_wakeup > RCU_NOCB_WAKE_NOT) {
> > 
> > So there are no longer any data races involving ->nocb_defer_wakeup?
> > 
> > (Yes, I could fire up KCSAN, but my KCSAN-capable system is otherwise
> > occupied for several more hours.)
> 
> To be more specific, there is no more unlocked write to the timer (queue/cancel)
> and its nocb_defer_wakeup matching state. And there is only one (on purpose) racy
> reader of ->nocb_defer_wakeup which is the non-timer deferred wakeup.
> 
> So the writes to the timer keep their WRITE_ONCE() and only the reader in
> do_nocb_deferred_wakeup() keeps its READ_ONCE(). Other readers are protected
> by the ->nocb_gp_lock.
> 
> > > +
> > >  		// Advance callbacks if helpful and low contention.
> > >  		needwake_gp = false;
> > >  		if (!rcu_segcblist_restempty(&rdp->cblist,
> > > @@ -2178,11 +2182,18 @@ static void nocb_gp_wait(struct rcu_data *my_rdp)
> > >  	my_rdp->nocb_gp_bypass = bypass;
> > >  	my_rdp->nocb_gp_gp = needwait_gp;
> > >  	my_rdp->nocb_gp_seq = needwait_gp ? wait_gp_seq : 0;
> > > -	if (bypass && !rcu_nocb_poll) {
> > > -		// At least one child with non-empty ->nocb_bypass, so set
> > > -		// timer in order to avoid stranding its callbacks.
> > > +	if (bypass) {
> > >  		raw_spin_lock_irqsave(&my_rdp->nocb_gp_lock, flags);
> > > -		mod_timer(&my_rdp->nocb_bypass_timer, j + 2);
> > > +		// Avoid race with first bypass CB.
> > > +		if (my_rdp->nocb_defer_wakeup > RCU_NOCB_WAKE_NOT) {
> > > +			WRITE_ONCE(my_rdp->nocb_defer_wakeup, RCU_NOCB_WAKE_NOT);
> > > +			del_timer(&my_rdp->nocb_timer);
> > > +		}
> > 
> > Given that the timer does not get queued if rcu_nocb_poll, why not move the
> > above "if" statement under the one following?
> 
> It's done later in the set.
> 
> > 
> > > +		if (!rcu_nocb_poll) {
> > > +			// At least one child with non-empty ->nocb_bypass, so set
> > > +			// timer in order to avoid stranding its callbacks.
> > > +			mod_timer(&my_rdp->nocb_bypass_timer, j + 2);
> > > +		}
> > >  		raw_spin_unlock_irqrestore(&my_rdp->nocb_gp_lock, flags);
> > >  	}
> > >  	if (rcu_nocb_poll) {
> > > @@ -2385,7 +2399,10 @@ static void do_nocb_deferred_wakeup_timer(struct timer_list *t)
> > >   */
> > >  static bool do_nocb_deferred_wakeup(struct rcu_data *rdp)
> > >  {
> > > -	if (rcu_nocb_need_deferred_wakeup(rdp))
> > > +	if (!rdp->nocb_gp_rdp)
> > > +		return false;
> > 
> > This check was not necessary previously because each CPU used its own rdp,
> > correct?
> 
> Exactly!
> 
> > The theory is that this early return is taken only during boot,
> > and that the spawning of the kthreads will act as an implicit wakeup?
> 
> You guessed right! That probably deserve a comment.

OK, I have queued these for for further review and testing.  Also to
look at the overall effect.  Thank you very much!

							Thanx, Paul
