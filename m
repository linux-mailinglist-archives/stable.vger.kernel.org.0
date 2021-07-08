Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3893BF63C
	for <lists+stable@lfdr.de>; Thu,  8 Jul 2021 09:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbhGHH3j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Jul 2021 03:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbhGHH3j (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Jul 2021 03:29:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D3EC061574;
        Thu,  8 Jul 2021 00:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vl5MbRdGwmlZh7qhtnufnGU16TVZ9C/OsTo2b3jA4CM=; b=IK5y5r7nAKeB3x4HLrBMKfQ2Dm
        Zob9xcDtZGLg/wdtxqqXN9bQSGYk4Sbxr2DMEKtbCsTvN6anqUayPDYVyyso6a0ar8GjGVCiBu480
        0TGlwVrvJimpl0UeiBKkz5CaaJo2LtRmHZXou+vWcTBVY7XDm1PyO9TSRmtPGSFtFxlfhUvuf/2kJ
        f2PMD134yqCjxSmd0pgM3PjAoj2YOEyIUiyz4+Zts4g76uBREqUggXtbbH5YMnIsrAMJJvALVfNCa
        UKk0s/pkMpOtS45zjDnJ+GjRkwzPc7V5d8XQ8To4/eDK5Z5fhK7fGrX7HOOfAjx2Xf4xAEWBnYHw0
        zsbDMTZQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m1OQV-00DBl7-Es; Thu, 08 Jul 2021 07:26:31 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 4A8F630007E;
        Thu,  8 Jul 2021 09:26:26 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 2A8F82D16D2AC; Thu,  8 Jul 2021 09:26:26 +0200 (CEST)
Date:   Thu, 8 Jul 2021 09:26:26 +0200
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
Message-ID: <YOaoomJAS2FzXi7I@hirez.programming.kicks-ass.net>
References: <20210707190457.60521-1-pauld@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210707190457.60521-1-pauld@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 07, 2021 at 03:04:57PM -0400, Phil Auld wrote:
> On systems with weaker memory ordering (e.g. power) commit dbfb089d360b
> ("sched: Fix loadavg accounting race") causes increasing values of load
> average (via rq->calc_load_active and calc_load_tasks) due to the wakeup
> CPU not always seeing the write to task->sched_contributes_to_load in
> __schedule(). Missing that we fail to decrement nr_uninterruptible when
> waking up a task which incremented nr_uninterruptible when it slept.
> 
> The rq->lock serialization is insufficient across different rq->locks.
> 
> Add smp_wmb() to schedule and smp_rmb() before the read in
> ttwu_do_activate().

> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 4ca80df205ce..ced7074716eb 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2992,6 +2992,8 @@ ttwu_do_activate(struct rq *rq, struct task_struct *p, int wake_flags,
>  
>  	lockdep_assert_held(&rq->lock);
>  
> +	/* Pairs with smp_wmb in __schedule() */
> +	smp_rmb();
>  	if (p->sched_contributes_to_load)
>  		rq->nr_uninterruptible--;
>  

Is this really needed ?! (this question is a big fat clue the comment is
insufficient). AFAICT try_to_wake_up() has a LOAD-ACQUIRE on p->on_rq
and hence the p->sched_contributed_to_load must already happen after.

> @@ -5084,6 +5086,11 @@ static void __sched notrace __schedule(bool preempt)
>  				!(prev_state & TASK_NOLOAD) &&
>  				!(prev->flags & PF_FROZEN);
>  
> +			/*
> +			 * Make sure the previous write is ordered before p->on_rq etc so
> +			 * that it is visible to other cpus in the wakeup path (ttwu_do_activate()).
> +			 */
> +			smp_wmb();
>  			if (prev->sched_contributes_to_load)
>  				rq->nr_uninterruptible++;

That comment is terrible, look at all the other barrier comments around
there for clues; in effect you're worrying about:

	p->sched_contributes_to_load = X	R1 = p->on_rq
	WMB					RMB
	p->on_rq = Y				R2 = p->sched_contributes_to_load

Right?


Bah bah bah.. I so detest having to add barriers here for silly
accounting. Let me think about this a little.


