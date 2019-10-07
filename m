Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACF49CE702
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 17:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727711AbfJGPOc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 11:14:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47180 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728245AbfJGPOc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Oct 2019 11:14:32 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 61ECDC0546F2;
        Mon,  7 Oct 2019 15:14:31 +0000 (UTC)
Received: from pauld.bos.csb (dhcp-17-51.bos.redhat.com [10.18.17.51])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6881F5D9CC;
        Mon,  7 Oct 2019 15:14:27 +0000 (UTC)
Date:   Mon, 7 Oct 2019 11:14:25 -0400
From:   Phil Auld <pauld@redhat.com>
To:     Xuewei Zhang <xueweiz@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Anton Blanchard <anton@ozlabs.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH] sched/fair: scale quota and period without losing
 quota/period ratio precision
Message-ID: <20191007151425.GD22412@pauld.bos.csb>
References: <20191004001243.140897-1-xueweiz@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191004001243.140897-1-xueweiz@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Mon, 07 Oct 2019 15:14:31 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 03, 2019 at 05:12:43PM -0700 Xuewei Zhang wrote:
> quota/period ratio is used to ensure a child task group won't get more
> bandwidth than the parent task group, and is calculated as:
> normalized_cfs_quota() = [(quota_us << 20) / period_us]
> 
> If the quota/period ratio was changed during this scaling due to
> precision loss, it will cause inconsistency between parent and child
> task groups. See below example:
> A userspace container manager (kubelet) does three operations:
> 1) Create a parent cgroup, set quota to 1,000us and period to 10,000us.
> 2) Create a few children cgroups.
> 3) Set quota to 1,000us and period to 10,000us on a child cgroup.
> 
> These operations are expected to succeed. However, if the scaling of
> 147/128 happens before step 3), quota and period of the parent cgroup
> will be changed:
> new_quota: 1148437ns, 1148us
> new_period: 11484375ns, 11484us
> 
> And when step 3) comes in, the ratio of the child cgroup will be 104857,
> which will be larger than the parent cgroup ratio (104821), and will
> fail.
> 
> Scaling them by a factor of 2 will fix the problem.
> 
> Fixes: 2e8e19226398 ("sched/fair: Limit sched_cfs_period_timer() loop to avoid hard lockup")
> Signed-off-by: Xuewei Zhang <xueweiz@google.com>


I managed to get it to trigger the second case. It took 50,000 children (20x my initial tests).

[ 1367.850630] cfs_period_timer[cpu11]: period too short, scaling up (new cfs_period_us = 4340, cfs_quota_us = 250000)
[ 1370.390832] cfs_period_timer[cpu11]: period too short, scaling up (new cfs_period_us = 8680, cfs_quota_us = 500000)
[ 1372.914689] cfs_period_timer[cpu11]: period too short, scaling up (new cfs_period_us = 17360, cfs_quota_us = 1000000)
[ 1375.447431] cfs_period_timer[cpu11]: period too short, scaling up (new cfs_period_us = 34720, cfs_quota_us = 2000000)
[ 1377.982785] cfs_period_timer[cpu11]: period too short, scaling up (new cfs_period_us = 69440, cfs_quota_us = 4000000)
[ 1380.481702] cfs_period_timer[cpu11]: period too short, scaling up (new cfs_period_us = 138880, cfs_quota_us = 8000000)
[ 1382.894692] cfs_period_timer[cpu11]: period too short, scaling up (new cfs_period_us = 277760, cfs_quota_us = 16000000)
[ 1385.264872] cfs_period_timer[cpu11]: period too short, scaling up (new cfs_period_us = 555520, cfs_quota_us = 32000000)
[ 1393.965140] cfs_period_timer[cpu11]: period too short, but cannot scale up without losing precision (cfs_period_us = 555520, cfs_quota_us = 32000000)

I suspect going higher could cause the original lockup, but that'd be the case with the old code as well. 
And this also gets us out of it faster.


Tested-by: Phil Auld <pauld@redhat.com>


Cheers,
Phil


> ---
>  kernel/sched/fair.c | 36 ++++++++++++++++++++++--------------
>  1 file changed, 22 insertions(+), 14 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 83ab35e2374f..b3d3d0a231cd 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4926,20 +4926,28 @@ static enum hrtimer_restart sched_cfs_period_timer(struct hrtimer *timer)
>  		if (++count > 3) {
>  			u64 new, old = ktime_to_ns(cfs_b->period);
>  
> -			new = (old * 147) / 128; /* ~115% */
> -			new = min(new, max_cfs_quota_period);
> -
> -			cfs_b->period = ns_to_ktime(new);
> -
> -			/* since max is 1s, this is limited to 1e9^2, which fits in u64 */
> -			cfs_b->quota *= new;
> -			cfs_b->quota = div64_u64(cfs_b->quota, old);
> -
> -			pr_warn_ratelimited(
> -	"cfs_period_timer[cpu%d]: period too short, scaling up (new cfs_period_us %lld, cfs_quota_us = %lld)\n",
> -				smp_processor_id(),
> -				div_u64(new, NSEC_PER_USEC),
> -				div_u64(cfs_b->quota, NSEC_PER_USEC));
> +			/*
> +			 * Grow period by a factor of 2 to avoid lossing precision.
> +			 * Precision loss in the quota/period ratio can cause __cfs_schedulable
> +			 * to fail.
> +			 */
> +			new = old * 2;
> +			if (new < max_cfs_quota_period) {
> +				cfs_b->period = ns_to_ktime(new);
> +				cfs_b->quota *= 2;
> +
> +				pr_warn_ratelimited(
> +	"cfs_period_timer[cpu%d]: period too short, scaling up (new cfs_period_us = %lld, cfs_quota_us = %lld)\n",
> +					smp_processor_id(),
> +					div_u64(new, NSEC_PER_USEC),
> +					div_u64(cfs_b->quota, NSEC_PER_USEC));
> +			} else {
> +				pr_warn_ratelimited(
> +	"cfs_period_timer[cpu%d]: period too short, but cannot scale up without losing precision (cfs_period_us = %lld, cfs_quota_us = %lld)\n",
> +					smp_processor_id(),
> +					div_u64(old, NSEC_PER_USEC),
> +					div_u64(cfs_b->quota, NSEC_PER_USEC));
> +			}
>  
>  			/* reset count so we don't come right back in here */
>  			count = 0;
> -- 
> 2.23.0.581.g78d2f28ef7-goog
> 

-- 
