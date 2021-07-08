Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 247363C1582
	for <lists+stable@lfdr.de>; Thu,  8 Jul 2021 16:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbhGHO5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Jul 2021 10:57:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27900 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231858AbhGHO5y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Jul 2021 10:57:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625756111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vn4Iw4rKn4KgREOV9J8dhiG81JB34qcsT1rWAqvgmiI=;
        b=hZ02kmRSVzqOF6qtYQnKhVl9k03SLe0gHx0pG2RfVly9zymIjSTq/pHowDManw1OS5igjm
        8k1Kgd2Fqwuubt4bQ1aAL65AWTJSwENEbCBFRboOTXuW7La6QHUsSaaJBhMSYPOKFFiE75
        RF4VXPfegHoXOt7R5HYtp/2qaQkFi6o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-LEzu5iB-NYiq8jTnSMKRnw-1; Thu, 08 Jul 2021 10:55:10 -0400
X-MC-Unique: LEzu5iB-NYiq8jTnSMKRnw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 385BA8030B0;
        Thu,  8 Jul 2021 14:55:09 +0000 (UTC)
Received: from lorien.usersys.redhat.com (unknown [10.22.8.35])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 094CA5D6D1;
        Thu,  8 Jul 2021 14:54:59 +0000 (UTC)
Date:   Thu, 8 Jul 2021 10:54:58 -0400
From:   Phil Auld <pauld@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Waiman Long <longman@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] sched: Fix nr_uninterruptible race causing increasing
 load average
Message-ID: <YOcRwhF6XkYWPjvV@lorien.usersys.redhat.com>
References: <20210707190457.60521-1-pauld@redhat.com>
 <YOaoomJAS2FzXi7I@hirez.programming.kicks-ass.net>
 <YOatszHNZc9XRbYB@hirez.programming.kicks-ass.net>
 <YOavHgRUBM6cc95s@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YOavHgRUBM6cc95s@hirez.programming.kicks-ass.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 08, 2021 at 09:54:06AM +0200 Peter Zijlstra wrote:
> On Thu, Jul 08, 2021 at 09:48:03AM +0200, Peter Zijlstra wrote:
> > On Thu, Jul 08, 2021 at 09:26:26AM +0200, Peter Zijlstra wrote:
> > > On Wed, Jul 07, 2021 at 03:04:57PM -0400, Phil Auld wrote:
> > > > On systems with weaker memory ordering (e.g. power) commit dbfb089d360b
> > > > ("sched: Fix loadavg accounting race") causes increasing values of load
> > > > average (via rq->calc_load_active and calc_load_tasks) due to the wakeup
> > > > CPU not always seeing the write to task->sched_contributes_to_load in
> > > > __schedule(). Missing that we fail to decrement nr_uninterruptible when
> > > > waking up a task which incremented nr_uninterruptible when it slept.
> > > > 
> > > > The rq->lock serialization is insufficient across different rq->locks.
> > > > 
> > > > Add smp_wmb() to schedule and smp_rmb() before the read in
> > > > ttwu_do_activate().
> > > 
> > > > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > > > index 4ca80df205ce..ced7074716eb 100644
> > > > --- a/kernel/sched/core.c
> > > > +++ b/kernel/sched/core.c
> > > > @@ -2992,6 +2992,8 @@ ttwu_do_activate(struct rq *rq, struct task_struct *p, int wake_flags,
> > > >  
> > > >  	lockdep_assert_held(&rq->lock);
> > > >  
> > > > +	/* Pairs with smp_wmb in __schedule() */
> > > > +	smp_rmb();
> > > >  	if (p->sched_contributes_to_load)
> > > >  		rq->nr_uninterruptible--;
> > > >  
> > > 
> > > Is this really needed ?! (this question is a big fat clue the comment is
> > > insufficient). AFAICT try_to_wake_up() has a LOAD-ACQUIRE on p->on_rq
> > > and hence the p->sched_contributed_to_load must already happen after.
> > > 
> > > > @@ -5084,6 +5086,11 @@ static void __sched notrace __schedule(bool preempt)
> > > >  				!(prev_state & TASK_NOLOAD) &&
> > > >  				!(prev->flags & PF_FROZEN);
> > > >  
> > > > +			/*
> > > > +			 * Make sure the previous write is ordered before p->on_rq etc so
> > > > +			 * that it is visible to other cpus in the wakeup path (ttwu_do_activate()).
> > > > +			 */
> > > > +			smp_wmb();
> > > >  			if (prev->sched_contributes_to_load)
> > > >  				rq->nr_uninterruptible++;
> > > 
> > > That comment is terrible, look at all the other barrier comments around
> > > there for clues; in effect you're worrying about:
> > > 
> > > 	p->sched_contributes_to_load = X	R1 = p->on_rq
> > > 	WMB					RMB
> > > 	p->on_rq = Y				R2 = p->sched_contributes_to_load
> > > 
> > > Right?
> > > 
> > > 
> > > Bah bah bah.. I so detest having to add barriers here for silly
> > > accounting. Let me think about this a little.
> > 
> > I got the below:
> > 
> > __schedule()					ttwu()
> > 
> > rq_lock()					raw_spin_lock(&p->pi_lock)
> > smp_mb__after_spinlock();			smp_mb__after_spinlock();
> > 
> > p->sched_contributes_to_load = X;		if (READ_ONCE(p->on_rq) && ...)
> > 						  goto unlock;
> > 						smp_acquire__after_ctrl_dep();
> > 
> > 						smp_cond_load_acquire(&p->on_cpu, !VAL)
> > 
> > deactivate_task()
> >   p->on_rq = 0;
> > 
> > context_switch()
> >   finish_task_switch()
> >     finish_task()
> >       smp_store_release(p->on_cpu, 0);
> > 
> > 						ttwu_queue()
> > 						  rq_lock()
> > 						    ttwu_do_activate()
> > 						      if (p->sched_contributes_to_load)
> > 						        ...
> > 						  rq_unlock()
> > 						raw_spin_unlock(&p->pi_lock);
> >     finish_lock_switch()
> >       rq_unlock();
> > 
> > 
> > 
> > The only way for ttwu() to end up in an enqueue, is if it did a
> > LOAD-ACQUIRE on ->on_cpu, 
> 
> That's not completely true; there's the WF_ON_CPU case, but in that
> scenario we IPI the CPU doing __schedule and it becomes simple UP/PO and
> everything must trivially work.
>
> > but that orders with the STORE-RELEASE on the
> > same, which ensures the p->sched_contributes_to_load LOAD must happen
> > after the STORE.
> > 
> > What am I missing? Your Changelog/comments provide insufficient clues..
> 

Sorry... I don't have a nice diagram. I'm still looking at what all those
macros actually mean on the various architectures.

"Works great in practice but how does it work in theory?" :)

Using what you have above I get the same thing. It looks like it should be
ordered but in practice it's not, and ordering it "more" as I did in the
patch, fixes it.

Is it possible that the bit field is causing some of the assumptions about
ordering in those various macros to be off?

I notice in all the comments about smp_mb__after_spinlock etc, it's always
WRITE_ONCE/READ_ONCE on the variables in question but we can't do that with
the bit field. 


I appreciate your time on this.


Cheers,
Phil

-- 

