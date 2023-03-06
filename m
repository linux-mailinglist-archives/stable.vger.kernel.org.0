Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A44C6AB85B
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 09:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjCFIch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 03:32:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbjCFIc2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 03:32:28 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321B421A16;
        Mon,  6 Mar 2023 00:32:05 -0800 (PST)
Received: from dggpeml500018.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PVWwK73JszKqFl;
        Mon,  6 Mar 2023 16:29:53 +0800 (CST)
Received: from [10.67.111.186] (10.67.111.186) by
 dggpeml500018.china.huawei.com (7.185.36.186) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 6 Mar 2023 16:31:57 +0800
Message-ID: <cf0108ec-d949-a5ab-7367-f358b6685873@huawei.com>
Date:   Mon, 6 Mar 2023 16:31:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: Patch "sched/fair: sanitize vruntime of entity being placed" has
 been added to the 4.14-stable tree
To:     Sasha Levin <sashal@kernel.org>, <stable-commits@vger.kernel.org>,
        <stable@vger.kernel.org>
CC:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>
References: <20230305040248.1787312-1-sashal@kernel.org>
From:   Zhang Qiao <zhangqiao22@huawei.com>
In-Reply-To: <20230305040248.1787312-1-sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.111.186]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500018.china.huawei.com (7.185.36.186)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



在 2023/3/5 12:02, Sasha Levin 写道:
> This is a note to let you know that I've just added the patch titled
> 
>     sched/fair: sanitize vruntime of entity being placed
> 
> to the 4.14-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      sched-fair-sanitize-vruntime-of-entity-being-placed.patch
> and it can be found in the queue-4.14 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
> 
> 
> 
> commit 38247e1de3305a6ef644404ac818bc6129440eae

Hi,
This patch has significant impact on the hackbench.throughput [1].
Please don't backport this patch.

[1] https://lore.kernel.org/lkml/202302211553.9738f304-yujie.liu@intel.com/T/#u

Thanks.
Zhang Qiao.

> Author: Zhang Qiao <zhangqiao22@huawei.com>
> Date:   Mon Jan 30 13:22:16 2023 +0100
> 
>     sched/fair: sanitize vruntime of entity being placed
>     
>     [ Upstream commit 829c1651e9c4a6f78398d3e67651cef9bb6b42cc ]
>     
>     When a scheduling entity is placed onto cfs_rq, its vruntime is pulled
>     to the base level (around cfs_rq->min_vruntime), so that the entity
>     doesn't gain extra boost when placed backwards.
>     
>     However, if the entity being placed wasn't executed for a long time, its
>     vruntime may get too far behind (e.g. while cfs_rq was executing a
>     low-weight hog), which can inverse the vruntime comparison due to s64
>     overflow.  This results in the entity being placed with its original
>     vruntime way forwards, so that it will effectively never get to the cpu.
>     
>     To prevent that, ignore the vruntime of the entity being placed if it
>     didn't execute for much longer than the characteristic sheduler time
>     scale.
>     
>     [rkagan: formatted, adjusted commit log, comments, cutoff value]
>     Signed-off-by: Zhang Qiao <zhangqiao22@huawei.com>
>     Co-developed-by: Roman Kagan <rkagan@amazon.de>
>     Signed-off-by: Roman Kagan <rkagan@amazon.de>
>     Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>     Link: https://lkml.kernel.org/r/20230130122216.3555094-1-rkagan@amazon.de
>     Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 3ff60230710c9..afa21e43477fa 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3615,6 +3615,7 @@ static void
>  place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
>  {
>  	u64 vruntime = cfs_rq->min_vruntime;
> +	u64 sleep_time;
>  
>  	/*
>  	 * The 'current' period is already promised to the current tasks,
> @@ -3639,8 +3640,18 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
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
> .
> 
