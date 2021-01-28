Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0A2308112
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 23:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhA1W0R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 17:26:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:41626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229658AbhA1W0P (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 17:26:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50DF864D9E;
        Thu, 28 Jan 2021 22:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611872733;
        bh=yIp4518MesE0eu8I0SzfH+lGgzYY6ifruPM0Rphch6w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QbFFBgobeUDIy4P8FqD/iiwqW/5y0/8Fclphjaa1cIp7BFkceSMxMe9hzjafF3jXd
         wb97yTgK0iPwUzLKhSFbEIM+3HgdLhvwfJvKnAx9Sx8s2AdECOZPVXHwT/jTutNg1h
         MClvGDcV0eakYDJwGn+CRlkb3M/I/MqKws3MfYACbGfQ9sPFhuVKbSgXPuw0ZktgLT
         YzaxJwEw+fy55SJCxjAhbUaavPAcqC9+gByMzW+7XegdL6I0OIuKx5V01TsfS92j3d
         ybgg5HYIfA70FbPKgBUsCbhMsowPEUg1CkSTIrN8INjLlBJQvzVu8KnNVAomXD4BhT
         c90fRpzXv03+A==
Date:   Thu, 28 Jan 2021 23:25:31 +0100
From:   Frederic Weisbecker <frederic@kernel.org>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Stable <stable@vger.kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH 05/16] rcu/nocb: Disable bypass when CPU isn't completely
 offloaded
Message-ID: <20210128222531.GD122776@lothringen>
References: <20210128171222.131380-1-frederic@kernel.org>
 <20210128171222.131380-6-frederic@kernel.org>
 <20210128213133.GT2743@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128213133.GT2743@paulmck-ThinkPad-P72>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 28, 2021 at 01:31:33PM -0800, Paul E. McKenney wrote:
> On Thu, Jan 28, 2021 at 06:12:11PM +0100, Frederic Weisbecker wrote:
> > ---
> >  include/linux/rcu_segcblist.h |  7 ++++---
> >  kernel/rcu/tree_plugin.h      | 31 +++++++++++++++++++++++--------
> >  2 files changed, 27 insertions(+), 11 deletions(-)
> > 
> > diff --git a/include/linux/rcu_segcblist.h b/include/linux/rcu_segcblist.h
> > index 8afe886e85f1..5a2d6dadd720 100644
> > --- a/include/linux/rcu_segcblist.h
> > +++ b/include/linux/rcu_segcblist.h
> > @@ -109,7 +109,7 @@ struct rcu_cblist {
> >   *  |                           SEGCBLIST_KTHREAD_GP                           |
> >   *  |                                                                          |
> >   *  |   Kthreads handle callbacks holding nocb_lock, local rcu_core() stops    |
> > - *  |   handling callbacks.                                                    |
> > + *  |   handling callbacks. Allow bypass enqueue.                              |
> 
> "Allow bypass enqueue" as in bypass was disabled and entering this
> state causes it to be enabled, correct?

Right.

> If so, "Enable bypass
> queueing" would be less ambiguous and would match the change below.

Ok I'll fix that.

> > @@ -2412,6 +2423,7 @@ static long rcu_nocb_rdp_deoffload(void *arg)
> >  
> >  	rcu_nocb_lock_irqsave(rdp, flags);
> >  
> > +	WARN_ON_ONCE(!rcu_nocb_flush_bypass(rdp, NULL, jiffies));
> 
> This flush suffices because we are running on the target CPU
> holding ->nocb_lock (thus having interrupts disabled), and
> because rdp_offload_toggle() invokes rcu_segcblist_offload(),
> which clears SEGCBLIST_OFFLOADED.  Thus future calls to
> rcu_segcblist_completely_offloaded() will return false,
> which means that future calls to rcu_nocb_try_bypass() will
> refuse to put anything into the bypass.

Exactly!

> I believe that this deserves a comment, particularly if I am
> confused about what is really happening here.  ;-)

Yes indeed I've been greedy there, will comment this :o)

> 
> On another topic, since I saw it along the way...
> 
> The header comment for rcu_segcblist_offload() says that the
> structure must be empty, but that isn't really the case, is it?

Ah strange indeed, must be a leftover. I'll remove it.

> 
> >  	ret = rdp_offload_toggle(rdp, false, flags);
> >  	swait_event_exclusive(rdp->nocb_state_wq,
> >  			      !rcu_segcblist_test_flags(cblist, SEGCBLIST_KTHREAD_CB |
> > @@ -2422,19 +2434,22 @@ static long rcu_nocb_rdp_deoffload(void *arg)
> >  	rcu_nocb_unlock_irqrestore(rdp, flags);
> >  	del_timer_sync(&rdp->nocb_timer);
> >  
> > +	/* Sanity check */
> > +	WARN_ON_ONCE(rcu_cblist_n_cbs(&rdp->nocb_bypass));
> > +
> >  	/*
> > -	 * Flush bypass. While IRQs are disabled and once we set
> > -	 * SEGCBLIST_SOFTIRQ_ONLY, no callback is supposed to be
> > -	 * enqueued on bypass.
> > +	 * Lock one last time so we see latest updates from kthreads and timer
> 
> You lost me here.  What updates are we seeing from kthreads and timers?

We want to make sure that, whatever change has been made on the segcblist by
kthreads such as length or callbacks dequeue, this is visible on the current
CPU. The swait_event_exclusive() doesn't guarantee that everything from the
kthreads is visible here as the flags are checked lockless and I haven't added
specific barriers.

That said right after the swait_event there is a nocb_lock LOCK/UNLOCK cycle to
disable the timer, so that's enough for the local CPU to see those updates. What
remains is the updates made by pending timers flushed in del_timer_sync(). There
is nothing special there to be visible here but out of paranoia...

In fact this matters later in the series as the above timer disablement and
flush will disappear and the LOCK/UNLOCK cycle that comes along.

> 
> > +	 * so that we can later run callbacks locally without the lock.
> >  	 */
> >  	rcu_nocb_lock_irqsave(rdp, flags);
> > -	rcu_nocb_flush_bypass(rdp, NULL, jiffies);
> > +	/*
> > +	 * Theoretically we could set SEGCBLIST_SOFTIRQ_ONLY after the nocb
> > +	 * LOCK/UNLOCK but let's be paranoid.
> > +	 */
> >  	rcu_segcblist_set_flags(cblist, SEGCBLIST_SOFTIRQ_ONLY);
> 
> As long as we are being paranoid, should we also check that the
> bypass remains empty?

You missed it, check above for sanity check :-)

Thanks.

> 
> >  	/*
> >  	 * With SEGCBLIST_SOFTIRQ_ONLY, we can't use
> > -	 * rcu_nocb_unlock_irqrestore() anymore. Theoretically we
> > -	 * could set SEGCBLIST_SOFTIRQ_ONLY with cb unlocked and IRQs
> > -	 * disabled now, but let's be paranoid.
> > +	 * rcu_nocb_unlock_irqrestore() anymore.
> >  	 */
> >  	raw_spin_unlock_irqrestore(&rdp->nocb_lock, flags);
> >  
> > -- 
> > 2.25.1
> > 
