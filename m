Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB3523E140
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 20:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729154AbgHFSl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 14:41:56 -0400
Received: from foss.arm.com ([217.140.110.172]:46570 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728322AbgHFSXb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Aug 2020 14:23:31 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1FCCA1FB;
        Thu,  6 Aug 2020 11:11:26 -0700 (PDT)
Received: from [10.57.35.143] (unknown [10.57.35.143])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1BB813F7D7;
        Thu,  6 Aug 2020 11:11:24 -0700 (PDT)
Subject: Re: [tip: perf/core] perf/core: Fix endless multiplex timer
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc:     linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        x86 <x86@kernel.org>
References: <20200305123851.GX2596@hirez.programming.kicks-ass.net>
 <158470908175.28353.4859180707604949658.tip-bot2@tip-bot2>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <abd1dde6-2761-ae91-195c-cd7c4e4515c6@arm.com>
Date:   Thu, 6 Aug 2020 19:11:24 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <158470908175.28353.4859180707604949658.tip-bot2@tip-bot2>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-03-20 12:58, tip-bot2 for Peter Zijlstra wrote:
> The following commit has been merged into the perf/core branch of tip:
> 
> Commit-ID:     90c91dfb86d0ff545bd329d3ddd72c147e2ae198
> Gitweb:        https://git.kernel.org/tip/90c91dfb86d0ff545bd329d3ddd72c147e2ae198
> Author:        Peter Zijlstra <peterz@infradead.org>
> AuthorDate:    Thu, 05 Mar 2020 13:38:51 +01:00
> Committer:     Peter Zijlstra <peterz@infradead.org>
> CommitterDate: Fri, 20 Mar 2020 13:06:22 +01:00
> 
> perf/core: Fix endless multiplex timer
> 
> Kan and Andi reported that we fail to kill rotation when the flexible
> events go empty, but the context does not. XXX moar
> 
> Fixes: fd7d55172d1e ("perf/cgroups: Don't rotate events for cgroups unnecessarily")

Can this patch (commit 90c91dfb86d0 ("perf/core: Fix endless multiplex 
timer") upstream) be applied to stable please? For PMU drivers built as 
modules, the bug can actually kill the system, since the runaway hrtimer 
loop keeps calling pmu->{enable,disable} after all the events have been 
closed and dropped their references to pmu->module. Thus legitimately 
unloading the module once things have got into this state quickly 
results in a crash when those callbacks disappear.

(FWIW I spent about two days fighting with this while testing a new 
driver as a module against the 5.3 kernel installed on someone else's 
machine, assuming it was a bug in my code...)

Robin.

> Reported-by: Andi Kleen <ak@linux.intel.com>
> Reported-by: Kan Liang <kan.liang@linux.intel.com>
> Tested-by: Kan Liang <kan.liang@linux.intel.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Link: https://lkml.kernel.org/r/20200305123851.GX2596@hirez.programming.kicks-ass.net
> ---
>   kernel/events/core.c | 20 ++++++++++++++------
>   1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index ccf8d4f..b5a68d2 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -2291,6 +2291,7 @@ __perf_remove_from_context(struct perf_event *event,
>   
>   	if (!ctx->nr_events && ctx->is_active) {
>   		ctx->is_active = 0;
> +		ctx->rotate_necessary = 0;
>   		if (ctx->task) {
>   			WARN_ON_ONCE(cpuctx->task_ctx != ctx);
>   			cpuctx->task_ctx = NULL;
> @@ -3188,12 +3189,6 @@ static void ctx_sched_out(struct perf_event_context *ctx,
>   	if (!ctx->nr_active || !(is_active & EVENT_ALL))
>   		return;
>   
> -	/*
> -	 * If we had been multiplexing, no rotations are necessary, now no events
> -	 * are active.
> -	 */
> -	ctx->rotate_necessary = 0;
> -
>   	perf_pmu_disable(ctx->pmu);
>   	if (is_active & EVENT_PINNED) {
>   		list_for_each_entry_safe(event, tmp, &ctx->pinned_active, active_list)
> @@ -3203,6 +3198,13 @@ static void ctx_sched_out(struct perf_event_context *ctx,
>   	if (is_active & EVENT_FLEXIBLE) {
>   		list_for_each_entry_safe(event, tmp, &ctx->flexible_active, active_list)
>   			group_sched_out(event, cpuctx, ctx);
> +
> +		/*
> +		 * Since we cleared EVENT_FLEXIBLE, also clear
> +		 * rotate_necessary, is will be reset by
> +		 * ctx_flexible_sched_in() when needed.
> +		 */
> +		ctx->rotate_necessary = 0;
>   	}
>   	perf_pmu_enable(ctx->pmu);
>   }
> @@ -3985,6 +3987,12 @@ ctx_event_to_rotate(struct perf_event_context *ctx)
>   				      typeof(*event), group_node);
>   	}
>   
> +	/*
> +	 * Unconditionally clear rotate_necessary; if ctx_flexible_sched_in()
> +	 * finds there are unschedulable events, it will set it again.
> +	 */
> +	ctx->rotate_necessary = 0;
> +
>   	return event;
>   }
>   
> 
