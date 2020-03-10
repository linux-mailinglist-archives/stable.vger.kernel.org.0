Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 927C417F736
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgCJMPl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:15:41 -0400
Received: from mga14.intel.com ([192.55.52.115]:14482 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgCJMPl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:15:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Mar 2020 05:15:40 -0700
X-IronPort-AV: E=Sophos;i="5.70,536,1574150400"; 
   d="scan'208";a="353613264"
Received: from pkosiack-mobl2.ger.corp.intel.com (HELO [10.252.21.27]) ([10.252.21.27])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 10 Mar 2020 05:15:39 -0700
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Defer semaphore priority bumping to
 a workqueue
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
References: <20200310101720.9944-1-chris@chris-wilson.co.uk>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
Message-ID: <a34d970a-2a9f-7b82-7900-202c656a9e96@linux.intel.com>
Date:   Tue, 10 Mar 2020 12:15:37 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200310101720.9944-1-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 10/03/2020 10:17, Chris Wilson wrote:
> Since the semaphore fence may be signaled from inside an interrupt
> handler from inside a request holding its request->lock, we cannot then
> enter into the engine->active.lock for processing the semaphore priority
> bump as we may traverse our call tree and end up on another held
> request.
> 
> CPU 0:
> [ 2243.218864]  _raw_spin_lock_irqsave+0x9a/0xb0
> [ 2243.218867]  i915_schedule_bump_priority+0x49/0x80 [i915]
> [ 2243.218869]  semaphore_notify+0x6d/0x98 [i915]
> [ 2243.218871]  __i915_sw_fence_complete+0x61/0x420 [i915]
> [ 2243.218874]  ? kmem_cache_free+0x211/0x290
> [ 2243.218876]  i915_sw_fence_complete+0x58/0x80 [i915]
> [ 2243.218879]  dma_i915_sw_fence_wake+0x3e/0x80 [i915]
> [ 2243.218881]  signal_irq_work+0x571/0x690 [i915]
> [ 2243.218883]  irq_work_run_list+0xd7/0x120
> [ 2243.218885]  irq_work_run+0x1d/0x50
> [ 2243.218887]  smp_irq_work_interrupt+0x21/0x30
> [ 2243.218889]  irq_work_interrupt+0xf/0x20
> 
> CPU 1:
> [ 2242.173107]  _raw_spin_lock+0x8f/0xa0
> [ 2242.173110]  __i915_request_submit+0x64/0x4a0 [i915]
> [ 2242.173112]  __execlists_submission_tasklet+0x8ee/0x2120 [i915]
> [ 2242.173114]  ? i915_sched_lookup_priolist+0x1e3/0x2b0 [i915]
> [ 2242.173117]  execlists_submit_request+0x2e8/0x2f0 [i915]
> [ 2242.173119]  submit_notify+0x8f/0xc0 [i915]
> [ 2242.173121]  __i915_sw_fence_complete+0x61/0x420 [i915]
> [ 2242.173124]  ? _raw_spin_unlock_irqrestore+0x39/0x40
> [ 2242.173137]  i915_sw_fence_complete+0x58/0x80 [i915]
> [ 2242.173140]  i915_sw_fence_commit+0x16/0x20 [i915]
> 
> CPU 2:
> [ 2242.173107]  _raw_spin_lock+0x8f/0xa0
> [ 2242.173110]  __i915_request_submit+0x64/0x4a0 [i915]
> [ 2242.173112]  __execlists_submission_tasklet+0x8ee/0x2120 [i915]
> [ 2242.173114]  ? i915_sched_lookup_priolist+0x1e3/0x2b0 [i915]
> [ 2242.173117]  execlists_submit_request+0x2e8/0x2f0 [i915]
> [ 2242.173119]  submit_notify+0x8f/0xc0 [i915]
> 
> Closes: https://gitlab.freedesktop.org/drm/intel/issues/1318
> Fixes: b7404c7ecb38 ("drm/i915: Bump ready tasks ahead of busywaits")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Cc: <stable@vger.kernel.org> # v5.2+
> ---
>   drivers/gpu/drm/i915/i915_request.c | 22 +++++++++++++++++-----
>   drivers/gpu/drm/i915/i915_request.h |  2 ++
>   2 files changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
> index 04b52bf347bf..129357d4b599 100644
> --- a/drivers/gpu/drm/i915/i915_request.c
> +++ b/drivers/gpu/drm/i915/i915_request.c
> @@ -588,19 +588,31 @@ submit_notify(struct i915_sw_fence *fence, enum i915_sw_fence_notify state)
>   	return NOTIFY_DONE;
>   }
>   
> +static void irq_semaphore_cb(struct irq_work *wrk)
> +{
> +	struct i915_request *rq =
> +		container_of(wrk, typeof(*rq), semaphore_work);
> +
> +	i915_schedule_bump_priority(rq, I915_PRIORITY_NOSEMAPHORE);
> +	i915_request_put(rq);
> +}
> +
>   static int __i915_sw_fence_call
>   semaphore_notify(struct i915_sw_fence *fence, enum i915_sw_fence_notify state)
>   {
> -	struct i915_request *request =
> -		container_of(fence, typeof(*request), semaphore);
> +	struct i915_request *rq = container_of(fence, typeof(*rq), semaphore);
>   
>   	switch (state) {
>   	case FENCE_COMPLETE:
> -		i915_schedule_bump_priority(request, I915_PRIORITY_NOSEMAPHORE);
> +		if (!(READ_ONCE(rq->sched.attr.priority) & I915_PRIORITY_NOSEMAPHORE)) {
> +			i915_request_get(rq);
> +			init_irq_work(&rq->semaphore_work, irq_semaphore_cb);
> +			irq_work_queue(&rq->semaphore_work);
> +		}
>   		break;
>   
>   	case FENCE_FREE:
> -		i915_request_put(request);
> +		i915_request_put(rq);
>   		break;
>   	}
>   
> @@ -1369,9 +1381,9 @@ void __i915_request_queue(struct i915_request *rq,
>   	 * decide whether to preempt the entire chain so that it is ready to
>   	 * run at the earliest possible convenience.
>   	 */
> -	i915_sw_fence_commit(&rq->semaphore);
>   	if (attr && rq->engine->schedule)
>   		rq->engine->schedule(rq, attr);
> +	i915_sw_fence_commit(&rq->semaphore);
>   	i915_sw_fence_commit(&rq->submit);
>   }
>   
> diff --git a/drivers/gpu/drm/i915/i915_request.h b/drivers/gpu/drm/i915/i915_request.h
> index 6020d5b2a3df..3c552bfea67a 100644
> --- a/drivers/gpu/drm/i915/i915_request.h
> +++ b/drivers/gpu/drm/i915/i915_request.h
> @@ -26,6 +26,7 @@
>   #define I915_REQUEST_H
>   
>   #include <linux/dma-fence.h>
> +#include <linux/irq_work.h>
>   #include <linux/lockdep.h>
>   
>   #include "gem/i915_gem_context_types.h"
> @@ -208,6 +209,7 @@ struct i915_request {
>   	};
>   	struct list_head execute_cb;
>   	struct i915_sw_fence semaphore;
> +	struct irq_work semaphore_work;
>   
>   	/*
>   	 * A list of everyone we wait upon, and everyone who waits upon us.
> 

Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

Regards,

Tvrtko
