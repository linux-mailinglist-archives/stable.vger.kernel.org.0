Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 935566A6CC3
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 14:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbjCANDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 08:03:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjCAND3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 08:03:29 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D8303E0A6;
        Wed,  1 Mar 2023 05:03:19 -0800 (PST)
Received: from dggpeml500018.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PRZCL0pQGzdbCR;
        Wed,  1 Mar 2023 21:02:38 +0800 (CST)
Received: from [10.67.111.186] (10.67.111.186) by
 dggpeml500018.china.huawei.com (7.185.36.186) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 1 Mar 2023 21:03:17 +0800
Message-ID: <62880d15-1a8b-6d71-05af-a80bad51c3cb@huawei.com>
Date:   Wed, 1 Mar 2023 21:03:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH AUTOSEL 6.2 13/21] sched/fair: sanitize vruntime of entity
 being placed
To:     Sasha Levin <sashal@kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
CC:     Roman Kagan <rkagan@amazon.de>,
        Peter Zijlstra <peterz@infradead.org>, <mingo@redhat.com>,
        <juri.lelli@redhat.com>, <vincent.guittot@linaro.org>
References: <20230226034150.771411-1-sashal@kernel.org>
 <20230226034150.771411-13-sashal@kernel.org>
From:   Zhang Qiao <zhangqiao22@huawei.com>
In-Reply-To: <20230226034150.771411-13-sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.111.186]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500018.china.huawei.com (7.185.36.186)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



在 2023/2/26 11:41, Sasha Levin 写道:
> From: Zhang Qiao <zhangqiao22@huawei.com>
> 
> [ Upstream commit 829c1651e9c4a6f78398d3e67651cef9bb6b42cc ]


Hi,
This patch has significant impact on the hackbench.throughput [1].
Please don't backport this patch.

[1] https://lore.kernel.org/lkml/202302211553.9738f304-yujie.liu@intel.com/T/#u

Thanks.
Zhang Qiao.

> 


> When a scheduling entity is placed onto cfs_rq, its vruntime is pulled
> to the base level (around cfs_rq->min_vruntime), so that the entity
> doesn't gain extra boost when placed backwards.
> 
> However, if the entity being placed wasn't executed for a long time, its
> vruntime may get too far behind (e.g. while cfs_rq was executing a
> low-weight hog), which can inverse the vruntime comparison due to s64
> overflow.  This results in the entity being placed with its original
> vruntime way forwards, so that it will effectively never get to the cpu.
> 
> To prevent that, ignore the vruntime of the entity being placed if it
> didn't execute for much longer than the characteristic sheduler time
> scale.
> 
> [rkagan: formatted, adjusted commit log, comments, cutoff value]
> Signed-off-by: Zhang Qiao <zhangqiao22@huawei.com>
> Co-developed-by: Roman Kagan <rkagan@amazon.de>
> Signed-off-by: Roman Kagan <rkagan@amazon.de>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Link: https://lkml.kernel.org/r/20230130122216.3555094-1-rkagan@amazon.de
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  kernel/sched/fair.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 0f87369914274..717c3ca970e15 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4656,6 +4656,7 @@ static void
>  place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
>  {
>  	u64 vruntime = cfs_rq->min_vruntime;
> +	u64 sleep_time;
>  
>  	/*
>  	 * The 'current' period is already promised to the current tasks,
> @@ -4685,8 +4686,18 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
>  		vruntime -= thresh;
>  	}
>  
> -	/* ensure we never gain time by being placed backwards. */
> -	se->vruntime = max_vruntime(se->vruntime, vruntime);
> +	/*
> +	 * Pull vruntime of the entity being placed to the base level of
> +	 * cfs_rq, to prevent boosting it if placed backwards.  If the entity
> +	 * slept for a long time, don't even try to compare its vruntime with
> +	 * the base as it may be too far off and the comparison may get
> +	 * inversed due to s64 overflow.
> +	 */
> +	sleep_time = rq_clock_task(rq_of(cfs_rq)) - se->exec_start;
> +	if ((s64)sleep_time > 60LL * NSEC_PER_SEC)
> +		se->vruntime = vruntime;
> +	else
> +		se->vruntime = max_vruntime(se->vruntime, vruntime);
>  }
>  
>  static void check_enqueue_throttle(struct cfs_rq *cfs_rq);
> 
