Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4583A0C6D
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 08:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbhFIGat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 02:30:49 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:57390 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232702AbhFIGas (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Jun 2021 02:30:48 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0Ubq9gf9_1623220132;
Received: from IT-C02W23QPG8WN.local(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0Ubq9gf9_1623220132)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 09 Jun 2021 14:28:53 +0800
Subject: Re: [PATCH 4.19 1/2] perf/cgroups: Don't rotate events for cgroups
 unnecessarily
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable <stable@vger.kernel.org>
References: <20210607075938.8840-1-wenyang@linux.alibaba.com>
From:   Wen Yang <wenyang@linux.alibaba.com>
Message-ID: <27b1368f-400e-6345-245d-a956e18b3752@linux.alibaba.com>
Date:   Wed, 9 Jun 2021 14:28:52 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210607075938.8840-1-wenyang@linux.alibaba.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi,

except for the following two patches:

fd7d55172d1e ("perf/cgroups: Don't rotate events for cgroups unnecessarily")

7fa343b7fdc4 ("perf/core: Fix corner case in perf_rotate_context()")

And this patch is also needed:

90c91dfb86d0 ("perf/core: Fix endless multiplex timer")


Would you please merge them into the 4.19 stable branch?
Thanks


--
Best wishes£¬
Wen


ÔÚ 2021/6/7 ÏÂÎç3:59, Wen Yang Ð´µÀ:
> From: Ian Rogers <irogers@google.com>
> 
> [ Upstream commit fd7d55172d1e2e501e6da0a5c1de25f06612dc2e ]
> 
> Currently perf_rotate_context assumes that if the context's nr_events !=
> nr_active a rotation is necessary for perf event multiplexing. With
> cgroups, nr_events is the total count of events for all cgroups and
> nr_active will not include events in a cgroup other than the current
> task's. This makes rotation appear necessary for cgroups when it is not.
> 
> Add a perf_event_context flag that is set when rotation is necessary.
> Clear the flag during sched_out and set it when a flexible sched_in
> fails due to resources.
> 
> Signed-off-by: Ian Rogers <irogers@google.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Kan Liang <kan.liang@linux.intel.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Vince Weaver <vincent.weaver@maine.edu>
> Link: https://lkml.kernel.org/r/20190601082722.44543-1-irogers@google.com
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Cc: stable@vger.kernel.org # 4.19+
> Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
> ---
>   include/linux/perf_event.h |  5 +++++
>   kernel/events/core.c       | 42 ++++++++++++++++++++++--------------------
>   2 files changed, 27 insertions(+), 20 deletions(-)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index d8b4d31..efe30b9 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -747,6 +747,11 @@ struct perf_event_context {
>   	int				nr_stat;
>   	int				nr_freq;
>   	int				rotate_disable;
> +	/*
> +	 * Set when nr_events != nr_active, except tolerant to events not
> +	 * necessary to be active due to scheduling constraints, such as cgroups.
> +	 */
> +	int				rotate_necessary;
>   	atomic_t			refcount;
>   	struct task_struct		*task;
>   
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index b8b74a4..56e3789 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -2952,6 +2952,12 @@ static void ctx_sched_out(struct perf_event_context *ctx,
>   	if (!ctx->nr_active || !(is_active & EVENT_ALL))
>   		return;
>   
> +	/*
> +	 * If we had been multiplexing, no rotations are necessary, now no events
> +	 * are active.
> +	 */
> +	ctx->rotate_necessary = 0;
> +
>   	perf_pmu_disable(ctx->pmu);
>   	if (is_active & EVENT_PINNED) {
>   		list_for_each_entry_safe(event, tmp, &ctx->pinned_active, active_list)
> @@ -3319,10 +3325,13 @@ static int flexible_sched_in(struct perf_event *event, void *data)
>   		return 0;
>   
>   	if (group_can_go_on(event, sid->cpuctx, sid->can_add_hw)) {
> -		if (!group_sched_in(event, sid->cpuctx, sid->ctx))
> -			list_add_tail(&event->active_list, &sid->ctx->flexible_active);
> -		else
> +		int ret = group_sched_in(event, sid->cpuctx, sid->ctx);
> +		if (ret) {
>   			sid->can_add_hw = 0;
> +			sid->ctx->rotate_necessary = 1;
> +			return 0;
> +		}
> +		list_add_tail(&event->active_list, &sid->ctx->flexible_active);
>   	}
>   
>   	return 0;
> @@ -3690,24 +3699,17 @@ static void rotate_ctx(struct perf_event_context *ctx, struct perf_event *event)
>   static bool perf_rotate_context(struct perf_cpu_context *cpuctx)
>   {
>   	struct perf_event *cpu_event = NULL, *task_event = NULL;
> -	bool cpu_rotate = false, task_rotate = false;
> -	struct perf_event_context *ctx = NULL;
> +	struct perf_event_context *task_ctx = NULL;
> +	int cpu_rotate, task_rotate;
>   
>   	/*
>   	 * Since we run this from IRQ context, nobody can install new
>   	 * events, thus the event count values are stable.
>   	 */
>   
> -	if (cpuctx->ctx.nr_events) {
> -		if (cpuctx->ctx.nr_events != cpuctx->ctx.nr_active)
> -			cpu_rotate = true;
> -	}
> -
> -	ctx = cpuctx->task_ctx;
> -	if (ctx && ctx->nr_events) {
> -		if (ctx->nr_events != ctx->nr_active)
> -			task_rotate = true;
> -	}
> +	cpu_rotate = cpuctx->ctx.rotate_necessary;
> +	task_ctx = cpuctx->task_ctx;
> +	task_rotate = task_ctx ? task_ctx->rotate_necessary : 0;
>   
>   	if (!(cpu_rotate || task_rotate))
>   		return false;
> @@ -3716,7 +3718,7 @@ static bool perf_rotate_context(struct perf_cpu_context *cpuctx)
>   	perf_pmu_disable(cpuctx->ctx.pmu);
>   
>   	if (task_rotate)
> -		task_event = ctx_first_active(ctx);
> +		task_event = ctx_first_active(task_ctx);
>   	if (cpu_rotate)
>   		cpu_event = ctx_first_active(&cpuctx->ctx);
>   
> @@ -3724,17 +3726,17 @@ static bool perf_rotate_context(struct perf_cpu_context *cpuctx)
>   	 * As per the order given at ctx_resched() first 'pop' task flexible
>   	 * and then, if needed CPU flexible.
>   	 */
> -	if (task_event || (ctx && cpu_event))
> -		ctx_sched_out(ctx, cpuctx, EVENT_FLEXIBLE);
> +	if (task_event || (task_ctx && cpu_event))
> +		ctx_sched_out(task_ctx, cpuctx, EVENT_FLEXIBLE);
>   	if (cpu_event)
>   		cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
>   
>   	if (task_event)
> -		rotate_ctx(ctx, task_event);
> +		rotate_ctx(task_ctx, task_event);
>   	if (cpu_event)
>   		rotate_ctx(&cpuctx->ctx, cpu_event);
>   
> -	perf_event_sched_in(cpuctx, ctx, current);
> +	perf_event_sched_in(cpuctx, task_ctx, current);
>   
>   	perf_pmu_enable(cpuctx->ctx.pmu);
>   	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
> 
