Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5248D98F35
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 11:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729721AbfHVJVf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 05:21:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55174 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfHVJVe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Aug 2019 05:21:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ZU2ASxjY4y40F5fNZVZIP1i3254t78xZNM9CDZ27nN0=; b=dRUvQBbJEXUQIJDp9AjQZ1rlM
        qiRBOFZXX3f3onyQpXt2n4D45H54+M6xVU1RlAnoAidOXpcLuUKZBAoS9JGB8JlcsorGE7fH+vEIX
        1SYdjXQy8iJjlQ0Xuif5vAhTp8v/m/rgvN4JDAU+BlLcAQiaTDuseL90HPH+oR9jLw8oEMC/DDR5Q
        WKIQvkS+fvNlgSJcXGZyeFDefd23kTEoLmGXQzlxL0zn34YudSXp6ZZ55uSwCSONylCaia1tZjq4a
        2hRioAUUF7+leJRLJihwCBju+Tp0IkHN6EWS9+O/UUvuNhH0hsvJCr88hn8asOKs0GrqbauibwfrB
        u8eeHbWVQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1i0jHZ-00017z-9F; Thu, 22 Aug 2019 09:21:26 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 9C8F9307598;
        Thu, 22 Aug 2019 11:20:51 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 92BFA2029B084; Thu, 22 Aug 2019 11:21:23 +0200 (CEST)
Date:   Thu, 22 Aug 2019 11:21:23 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Valentin Schneider <valentin.schneider@arm.com>
Cc:     linux-kernel@vger.kernel.org, mingo@kernel.org,
        liangyan.peng@linux.alibaba.com, shanpeic@linux.alibaba.com,
        xlpang@linux.alibaba.com, pjt@google.com, stable@vger.kernel.org,
        Ben Segall <bsegall@google.com>
Subject: Re: [PATCH] sched/fair: Add missing unthrottle_cfs_rq()
Message-ID: <20190822092123.GL2349@hirez.programming.kicks-ass.net>
References: <0004fb54-cdee-2197-1cbf-6e2111d39ed9@arm.com>
 <20190820105420.7547-1-valentin.schneider@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820105420.7547-1-valentin.schneider@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 20, 2019 at 11:54:20AM +0100, Valentin Schneider wrote:
> Turns out a cfs_rq->runtime_remaining can become positive in
> assign_cfs_rq_runtime(), but this codepath has no call to
> unthrottle_cfs_rq().
> 
> This can leave us in a situation where we have a throttled cfs_rq with
> positive ->runtime_remaining, which breaks the math in
> distribute_cfs_runtime(): this function expects a negative value so that
> it may safely negate it into a positive value.
> 
> Add the missing unthrottle_cfs_rq(). While at it, add a WARN_ON where
> we expect negative values, and pull in a comment from the mailing list
> that didn't make it in [1].
> 
> [1]: https://lkml.kernel.org/r/BANLkTi=NmCxKX6EbDQcJYDJ5kKyG2N1ssw@mail.gmail.com
> 
> Cc: <stable@vger.kernel.org>
> Fixes: ec12cb7f31e2 ("sched: Accumulate per-cfs_rq cpu usage and charge against bandwidth")
> Reported-by: Liangyan <liangyan.peng@linux.alibaba.com>
> Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>

Thanks!

> ---
>  kernel/sched/fair.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 1054d2cf6aaa..219ff3f328e5 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4385,6 +4385,11 @@ static inline u64 cfs_rq_clock_task(struct cfs_rq *cfs_rq)
>  	return rq_clock_task(rq_of(cfs_rq)) - cfs_rq->throttled_clock_task_time;
>  }
>  
> +static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
> +{
> +	return cfs_bandwidth_used() && cfs_rq->throttled;
> +}
> +
>  /* returns 0 on failure to allocate runtime */
>  static int assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
>  {
> @@ -4411,6 +4416,9 @@ static int assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
>  
>  	cfs_rq->runtime_remaining += amount;
>  
> +	if (cfs_rq->runtime_remaining > 0 && cfs_rq_throttled(cfs_rq))
> +		unthrottle_cfs_rq(cfs_rq);
> +
>  	return cfs_rq->runtime_remaining > 0;
>  }
>  
> @@ -4439,11 +4447,6 @@ void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, u64 delta_exec)
>  	__account_cfs_rq_runtime(cfs_rq, delta_exec);
>  }
>  
> -static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
> -{
> -	return cfs_bandwidth_used() && cfs_rq->throttled;
> -}
> -
>  /* check whether cfs_rq, or any parent, is throttled */
>  static inline int throttled_hierarchy(struct cfs_rq *cfs_rq)
>  {
> @@ -4628,6 +4631,10 @@ static u64 distribute_cfs_runtime(struct cfs_bandwidth *cfs_b, u64 remaining)
>  		if (!cfs_rq_throttled(cfs_rq))
>  			goto next;
>  
> +		/* By the above check, this should never be true */
> +		WARN_ON(cfs_rq->runtime_remaining > 0);
> +
> +		/* Pick the minimum amount to return to a positive quota state */
>  		runtime = -cfs_rq->runtime_remaining + 1;
>  		if (runtime > remaining)
>  			runtime = remaining;
> -- 
> 2.22.0
> 
