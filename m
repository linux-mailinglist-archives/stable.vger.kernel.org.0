Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D87C13D3B4B
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 15:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235214AbhGWM6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 08:58:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55916 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233365AbhGWM6W (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 08:58:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627047536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vn0/0GkL0S3h1OMfPoUZw0xiOiSwbFnbpLTaXgDIttk=;
        b=efBRyDLCvO+iPHw9KoZHe49GCxC6fJsoGLMuyshLD2uwjwPvOU3Ra2xTGH8VryyVLlZxjs
        7tVexvKFVioBntE9McOkCqi8mDZOfOBDSolOgTjmKn8Hl4ocTJrGVrVixGbFvXSTSxlfs9
        J2pcN+gPsVc6YbER8Z66+S9jTIiFDfI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-pFCaFyLxMSav7OVAyPm3_w-1; Fri, 23 Jul 2021 09:38:54 -0400
X-MC-Unique: pFCaFyLxMSav7OVAyPm3_w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85F9087D543;
        Fri, 23 Jul 2021 13:38:53 +0000 (UTC)
Received: from lorien.usersys.redhat.com (unknown [10.22.32.128])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0CE88189BB;
        Fri, 23 Jul 2021 13:38:45 +0000 (UTC)
Date:   Fri, 23 Jul 2021 09:38:44 -0400
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
Message-ID: <YPrGZK+ud5A17lSL@lorien.usersys.redhat.com>
References: <20210707190457.60521-1-pauld@redhat.com>
 <YOaoomJAS2FzXi7I@hirez.programming.kicks-ass.net>
 <YOb82exzMcrOxfHa@lorien.usersys.redhat.com>
 <YOg1LHSDknjobJfR@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YOg1LHSDknjobJfR@hirez.programming.kicks-ass.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 09, 2021 at 01:38:20PM +0200 Peter Zijlstra wrote:
> On Thu, Jul 08, 2021 at 09:25:45AM -0400, Phil Auld wrote:
> > Hi Peter,
> > 
> > On Thu, Jul 08, 2021 at 09:26:26AM +0200 Peter Zijlstra wrote:
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
> > 
> > Yes, it is needed.  We've got idle power systems with load average of 530.21.
> > Calc_load_tasks is 530, and the sum of both nr_uninterruptible and
> > calc_load_active across all the runqueues is 530. Basically monotonically
> > non-decreasing load average. With the patch this no longer happens.
> 
> Have you tried without the rmb here? Do you really need both barriers?
>

You're right here. (I see now that you were asking about the rmb specifically
in the first question) The rmb is not needed. 

I was unable to reproducde it with the upstream kernel. I still think it is
a problem though since the code in question is all the same. The recent
changes to unbound workqueues which make it more likely to run on the
submitting cpu may be masking the problem since it obviously requires
multiple cpus to hit.

If I can isolate those changes I can try to revert them in upstream and
see if I can get it there.

I suppose pulling those changes back could get us past this but
I'm not a fan of just hiding it by making it harder to hit.

I've not gotten to the disable TTWU_QUEUE test, that's next...


Cheers,
Phil

-- 

