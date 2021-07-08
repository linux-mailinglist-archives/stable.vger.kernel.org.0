Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B443BF67F
	for <lists+stable@lfdr.de>; Thu,  8 Jul 2021 09:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbhGHH4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Jul 2021 03:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbhGHH4z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Jul 2021 03:56:55 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02413C061574;
        Thu,  8 Jul 2021 00:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nkVxKSYXXRxgyLC9yJD7VSxAEdTupwMIYy3Y2ruFHMI=; b=KD0C+EhUOmz+53KKaw4nfB5FKD
        AN1a3gvobWB68l0kOEo/TnMjRY+B2ZtmiixKff6jrZA0ABc5XDrjUiz8euU5cdv9SfsDopS3T+kV2
        Jbx3OIrwCTbnhyq2KpaFua6pgZvpn2RtxaK3tzVu8ICbYO8aHZjZYoPpc4L4QmsQ0v1CPjey5zFV7
        Y3BBPKNghE02RPBzqgsEWG/5fDxjqaFAY/dAnjxxXm2JwcY7JAZ8m9NmljgIgp3rMWm+J1LkBQP/E
        5DVKrnDjXKi7St4q7/62ASMC9rXg+X/cE+ZkNvJbuy9cO6RYRsHleiZOnIpE4YFTsPOvYIOQYPfHb
        mnFnkrfA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m1OrH-00FZPR-L2; Thu, 08 Jul 2021 07:54:07 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id BA0D930007E;
        Thu,  8 Jul 2021 09:54:06 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id A5AE5200DF1C4; Thu,  8 Jul 2021 09:54:06 +0200 (CEST)
Date:   Thu, 8 Jul 2021 09:54:06 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Phil Auld <pauld@redhat.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Waiman Long <longman@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] sched: Fix nr_uninterruptible race causing increasing
 load average
Message-ID: <YOavHgRUBM6cc95s@hirez.programming.kicks-ass.net>
References: <20210707190457.60521-1-pauld@redhat.com>
 <YOaoomJAS2FzXi7I@hirez.programming.kicks-ass.net>
 <YOatszHNZc9XRbYB@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YOatszHNZc9XRbYB@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 08, 2021 at 09:48:03AM +0200, Peter Zijlstra wrote:
> On Thu, Jul 08, 2021 at 09:26:26AM +0200, Peter Zijlstra wrote:
> > On Wed, Jul 07, 2021 at 03:04:57PM -0400, Phil Auld wrote:
> > > On systems with weaker memory ordering (e.g. power) commit dbfb089d360b
> > > ("sched: Fix loadavg accounting race") causes increasing values of load
> > > average (via rq->calc_load_active and calc_load_tasks) due to the wakeup
> > > CPU not always seeing the write to task->sched_contributes_to_load in
> > > __schedule(). Missing that we fail to decrement nr_uninterruptible when
> > > waking up a task which incremented nr_uninterruptible when it slept.
> > > 
> > > The rq->lock serialization is insufficient across different rq->locks.
> > > 
> > > Add smp_wmb() to schedule and smp_rmb() before the read in
> > > ttwu_do_activate().
> > 
> > > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > > index 4ca80df205ce..ced7074716eb 100644
> > > --- a/kernel/sched/core.c
> > > +++ b/kernel/sched/core.c
> > > @@ -2992,6 +2992,8 @@ ttwu_do_activate(struct rq *rq, struct task_struct *p, int wake_flags,
> > >  
> > >  	lockdep_assert_held(&rq->lock);
> > >  
> > > +	/* Pairs with smp_wmb in __schedule() */
> > > +	smp_rmb();
> > >  	if (p->sched_contributes_to_load)
> > >  		rq->nr_uninterruptible--;
> > >  
> > 
> > Is this really needed ?! (this question is a big fat clue the comment is
> > insufficient). AFAICT try_to_wake_up() has a LOAD-ACQUIRE on p->on_rq
> > and hence the p->sched_contributed_to_load must already happen after.
> > 
> > > @@ -5084,6 +5086,11 @@ static void __sched notrace __schedule(bool preempt)
> > >  				!(prev_state & TASK_NOLOAD) &&
> > >  				!(prev->flags & PF_FROZEN);
> > >  
> > > +			/*
> > > +			 * Make sure the previous write is ordered before p->on_rq etc so
> > > +			 * that it is visible to other cpus in the wakeup path (ttwu_do_activate()).
> > > +			 */
> > > +			smp_wmb();
> > >  			if (prev->sched_contributes_to_load)
> > >  				rq->nr_uninterruptible++;
> > 
> > That comment is terrible, look at all the other barrier comments around
> > there for clues; in effect you're worrying about:
> > 
> > 	p->sched_contributes_to_load = X	R1 = p->on_rq
> > 	WMB					RMB
> > 	p->on_rq = Y				R2 = p->sched_contributes_to_load
> > 
> > Right?
> > 
> > 
> > Bah bah bah.. I so detest having to add barriers here for silly
> > accounting. Let me think about this a little.
> 
> I got the below:
> 
> __schedule()					ttwu()
> 
> rq_lock()					raw_spin_lock(&p->pi_lock)
> smp_mb__after_spinlock();			smp_mb__after_spinlock();
> 
> p->sched_contributes_to_load = X;		if (READ_ONCE(p->on_rq) && ...)
> 						  goto unlock;
> 						smp_acquire__after_ctrl_dep();
> 
> 						smp_cond_load_acquire(&p->on_cpu, !VAL)
> 
> deactivate_task()
>   p->on_rq = 0;
> 
> context_switch()
>   finish_task_switch()
>     finish_task()
>       smp_store_release(p->on_cpu, 0);
> 
> 						ttwu_queue()
> 						  rq_lock()
> 						    ttwu_do_activate()
> 						      if (p->sched_contributes_to_load)
> 						        ...
> 						  rq_unlock()
> 						raw_spin_unlock(&p->pi_lock);
>     finish_lock_switch()
>       rq_unlock();
> 
> 
> 
> The only way for ttwu() to end up in an enqueue, is if it did a
> LOAD-ACQUIRE on ->on_cpu, 

That's not completely true; there's the WF_ON_CPU case, but in that
scenario we IPI the CPU doing __schedule and it becomes simple UP/PO and
everything must trivially work.

> but that orders with the STORE-RELEASE on the
> same, which ensures the p->sched_contributes_to_load LOAD must happen
> after the STORE.
> 
> What am I missing? Your Changelog/comments provide insufficient clues..
