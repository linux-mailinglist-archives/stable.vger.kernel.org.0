Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA0C53C1444
	for <lists+stable@lfdr.de>; Thu,  8 Jul 2021 15:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbhGHN2n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Jul 2021 09:28:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40343 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229901AbhGHN2m (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Jul 2021 09:28:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625750760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sgAZqvIsySXyytpE1Vt0NiR8ftCkjzuXuMqm+w94wKQ=;
        b=FjUxm4y2LnnASd+oY8eBZ9IL7V7xPRFu2xLCQbJtK4vjqKK0No9oErwGuG9vLSbEcAONui
        r1VEVJyAZMlCjV/H/sdVe5IddgTNfHfXQ0Mqo2tBWaT9mE3rO+EAekqEP/r9QceD9+f2H/
        HDXmd9HH1SQk2L1fcWO8Wi/dAhZ95J0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-TBdO-pdmP0iry3uq5EAIqA-1; Thu, 08 Jul 2021 09:25:59 -0400
X-MC-Unique: TBdO-pdmP0iry3uq5EAIqA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E6388030B0;
        Thu,  8 Jul 2021 13:25:58 +0000 (UTC)
Received: from lorien.usersys.redhat.com (unknown [10.22.8.35])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C35C45D9D3;
        Thu,  8 Jul 2021 13:25:47 +0000 (UTC)
Date:   Thu, 8 Jul 2021 09:25:45 -0400
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
Message-ID: <YOb82exzMcrOxfHa@lorien.usersys.redhat.com>
References: <20210707190457.60521-1-pauld@redhat.com>
 <YOaoomJAS2FzXi7I@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YOaoomJAS2FzXi7I@hirez.programming.kicks-ass.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Peter,

On Thu, Jul 08, 2021 at 09:26:26AM +0200 Peter Zijlstra wrote:
> On Wed, Jul 07, 2021 at 03:04:57PM -0400, Phil Auld wrote:
> > On systems with weaker memory ordering (e.g. power) commit dbfb089d360b
> > ("sched: Fix loadavg accounting race") causes increasing values of load
> > average (via rq->calc_load_active and calc_load_tasks) due to the wakeup
> > CPU not always seeing the write to task->sched_contributes_to_load in
> > __schedule(). Missing that we fail to decrement nr_uninterruptible when
> > waking up a task which incremented nr_uninterruptible when it slept.
> > 
> > The rq->lock serialization is insufficient across different rq->locks.
> > 
> > Add smp_wmb() to schedule and smp_rmb() before the read in
> > ttwu_do_activate().
> 
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index 4ca80df205ce..ced7074716eb 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -2992,6 +2992,8 @@ ttwu_do_activate(struct rq *rq, struct task_struct *p, int wake_flags,
> >  
> >  	lockdep_assert_held(&rq->lock);
> >  
> > +	/* Pairs with smp_wmb in __schedule() */
> > +	smp_rmb();
> >  	if (p->sched_contributes_to_load)
> >  		rq->nr_uninterruptible--;
> >  
> 
> Is this really needed ?! (this question is a big fat clue the comment is
> insufficient). AFAICT try_to_wake_up() has a LOAD-ACQUIRE on p->on_rq
> and hence the p->sched_contributed_to_load must already happen after.
>

Yes, it is needed.  We've got idle power systems with load average of 530.21.
Calc_load_tasks is 530, and the sum of both nr_uninterruptible and
calc_load_active across all the runqueues is 530. Basically monotonically
non-decreasing load average. With the patch this no longer happens.

We need the sched_contributed_to_load to "happen before" so that it's seen
on the other cpu on wakeup.

> > @@ -5084,6 +5086,11 @@ static void __sched notrace __schedule(bool preempt)
> >  				!(prev_state & TASK_NOLOAD) &&
> >  				!(prev->flags & PF_FROZEN);
> >  
> > +			/*
> > +			 * Make sure the previous write is ordered before p->on_rq etc so
> > +			 * that it is visible to other cpus in the wakeup path (ttwu_do_activate()).
> > +			 */
> > +			smp_wmb();
> >  			if (prev->sched_contributes_to_load)
> >  				rq->nr_uninterruptible++;
> 
> That comment is terrible, look at all the other barrier comments around
> there for clues; in effect you're worrying about:
> 
> 	p->sched_contributes_to_load = X	R1 = p->on_rq
> 	WMB					RMB
> 	p->on_rq = Y				R2 = p->sched_contributes_to_load
> 
> Right?

The only way I can see that decrememnt being missed is if the write to
sched_contributes_to_load is not being seen on the wakeup cpu. 

Before the previous patch the _state condition was checked again on the
wakeup cpu and that is ordered.

> 
> 
> Bah bah bah.. I so detest having to add barriers here for silly
> accounting. Let me think about this a little.
> 
> 

Thanks,
Phil

-- 

