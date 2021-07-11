Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6776D3C3CC7
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 15:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232544AbhGKNXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 09:23:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46205 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232658AbhGKNXE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 09:23:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626009617;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ii+7ydEQcrkoc4EY60mMuxmS0HQ1FH1ba93hoFgQD7Q=;
        b=bEDNsNxkqs1rZ2ZWZL9IAuqZ6oAVCM+pzO4DGviw3FIdGuWymqkC9SQ0ExcvCgtgxCKCt3
        EBtkUbyByScdQpHevvz39kapt598bM5PY7jjhcY71F2Q7RwPHdz+So2VFT7VLZxVxWMTJr
        6ezDHmIiqvaEnhPhu9iH9bRsrltRFMU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-LEf1oYJsMVipokhaqNcy_w-1; Sun, 11 Jul 2021 09:20:16 -0400
X-MC-Unique: LEf1oYJsMVipokhaqNcy_w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7AAE801107;
        Sun, 11 Jul 2021 13:20:14 +0000 (UTC)
Received: from lorien.usersys.redhat.com (unknown [10.22.8.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EED2B5C22B;
        Sun, 11 Jul 2021 13:19:57 +0000 (UTC)
Date:   Sun, 11 Jul 2021 09:19:56 -0400
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
Message-ID: <YOrv/PvjudQ3HLPD@lorien.usersys.redhat.com>
References: <20210707190457.60521-1-pauld@redhat.com>
 <YOaoomJAS2FzXi7I@hirez.programming.kicks-ass.net>
 <YOatszHNZc9XRbYB@hirez.programming.kicks-ass.net>
 <YOavHgRUBM6cc95s@hirez.programming.kicks-ass.net>
 <YOcRwhF6XkYWPjvV@lorien.usersys.redhat.com>
 <YOhHphFWGbfAVODd@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YOhHphFWGbfAVODd@hirez.programming.kicks-ass.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Peter,

On Fri, Jul 09, 2021 at 02:57:10PM +0200 Peter Zijlstra wrote:
> On Thu, Jul 08, 2021 at 10:54:58AM -0400, Phil Auld wrote:
> > Sorry... I don't have a nice diagram. I'm still looking at what all those
> > macros actually mean on the various architectures.
> 
> Don't worry about other architectures, lets focus on Power, because
> that's the case where you can reprouce funnies. Now Power only has 2
> barrier ops (not quite true, but close enough for all this):
> 
>  - SYNC is the full barrier
> 
>  - LWSYNC is a TSO like barrier
> 
> Pretty much everything (LOAD-ACQUIRE, STORE-RELEASE, WMB, RMB) uses
> LWSYNC. Only MB result in SYNC.
> 
> Power is 'funny' because their spinlocks are weaker than everybody
> else's, but AFAICT that doesn't seem relevant here.
>

Thanks.

> > Using what you have above I get the same thing. It looks like it should be
> > ordered but in practice it's not, and ordering it "more" as I did in the
> > patch, fixes it.
> 
> And you're running Linus' tree, not some franken-kernel from RHT, right?
> As asked in that other email, can you try with just the WMB added? I
> really don't believe that RMB you added can make a difference.

So, no. Right now the reproducer is on the franken-kernel :(

As far as I can tell the relevant code paths (schedule, barriers, wakeup
etc) are all current and the same. I traced through your diagram and
it all matches exactly.

I have a suspicion that Linus's tree may hide it. I believe this is tickled
by NFS io, which I _think_ is effected by the unboud workqueue changes
that may make it less likely to do the wakeup on a different cpu. But
that's just speculation. 

The issue is that the systems under test here are in a partner's lab
to which I have no direct access. 

I will try to get an upstream build on there, if possible, as soon
as I can.

> 
> Also, can you try with TTWU_QUEUE disabled (without any additional
> barriers added), that simplifies the wakeup path a lot.
>

Will do. 


> > Is it possible that the bit field is causing some of the assumptions about
> > ordering in those various macros to be off?
> 
> *should* not matter...
> 
> 	prev->sched_contributes_to_load = X;
> 
> 	smp_store_release(&prev->on_cpu, 0);
> 	  asm("LWSYNC" : : : "memory");
> 	  WRITE_ONCE(prev->on_cpu, 0);
> 
> due to that memory clobber, the compiler must emit whatever stores are
> required for the bitfield prior to the LWSYNC.
> 
> > I notice in all the comments about smp_mb__after_spinlock etc, it's always
> > WRITE_ONCE/READ_ONCE on the variables in question but we can't do that with
> > the bit field.
> 
> Yeah, but both ->on_rq and ->sched_contributes_to_load are 'normal'
> stores. That said, given that ttwu() does a READ_ONCE() on ->on_rq, we
> should match that with WRITE_ONCE()...
> 
> So I think we should do the below, but I don't believe it'll make a
> difference. Let me stare more.
>

I'm out of the office for the next week+ so don't stare to hard. I'll try to
get the tests you asked for as soon as I get back in the (home) office.

I'm not sure the below will make a difference either, but will try it too.

Thanks again for the help. And sorry for the timing.


Cheers,
Phil


> ---
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index ca9a523c9a6c..da93551b298d 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1973,12 +1973,12 @@ void activate_task(struct rq *rq, struct task_struct *p, int flags)
>  {
>  	enqueue_task(rq, p, flags);
>  
> -	p->on_rq = TASK_ON_RQ_QUEUED;
> +	WRITE_ONCE(p->on_rq, TASK_ON_RQ_QUEUED);
>  }
>  
>  void deactivate_task(struct rq *rq, struct task_struct *p, int flags)
>  {
> -	p->on_rq = (flags & DEQUEUE_SLEEP) ? 0 : TASK_ON_RQ_MIGRATING;
> +	WRITE_ONCE(p->on_rq, (flags & DEQUEUE_SLEEP) ? 0 : TASK_ON_RQ_MIGRATING);
>  
>  	dequeue_task(rq, p, flags);
>  }
> @@ -5662,11 +5662,11 @@ static bool try_steal_cookie(int this, int that)
>  		if (p->core_occupation > dst->idle->core_occupation)
>  			goto next;
>  
> -		p->on_rq = TASK_ON_RQ_MIGRATING;
> +		WRITE_ONCE(p->on_rq, TASK_ON_RQ_MIGRATING);
>  		deactivate_task(src, p, 0);
>  		set_task_cpu(p, this);
>  		activate_task(dst, p, 0);
> -		p->on_rq = TASK_ON_RQ_QUEUED;
> +		WRITE_ONCE(p->on_rq, TASK_ON_RQ_QUEUED);
>  
>  		resched_curr(dst);
>  
> 

-- 

