Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A45517BFDE
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 15:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgCFOHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 09:07:49 -0500
Received: from mga09.intel.com ([134.134.136.24]:49735 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbgCFOHt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Mar 2020 09:07:49 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Mar 2020 06:07:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,522,1574150400"; 
   d="scan'208";a="244622655"
Received: from gaia.fi.intel.com ([10.237.72.192])
  by orsmga006.jf.intel.com with ESMTP; 06 Mar 2020 06:07:42 -0800
Received: by gaia.fi.intel.com (Postfix, from userid 1000)
        id 8D12A5C1DD1; Fri,  6 Mar 2020 16:06:24 +0200 (EET)
From:   Mika Kuoppala <mika.kuoppala@linux.intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     tvrtko.ursulin@intel.com, Chris Wilson <chris@chris-wilson.co.uk>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/3] drm/i915/execlists: Enable timeslice on partial virtual engine dequeue
In-Reply-To: <20200306113012.3184606-1-chris@chris-wilson.co.uk>
References: <20200306113012.3184606-1-chris@chris-wilson.co.uk>
Date:   Fri, 06 Mar 2020 16:06:24 +0200
Message-ID: <877dzx4ly7.fsf@gaia.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Chris Wilson <chris@chris-wilson.co.uk> writes:

> If we stop filling the ELSP due to an incompatible virtual engine
> request, check if we should enable the timeslice on behalf of the queue.
>
> This fixes the case where we are inspecting the last->next element when
> we know that the last element is the last request in the execution queue,
> and so decided we did not need to enable timeslicing despite the intent
> to do so!
>
> Fixes: 8ee36e048c98 ("drm/i915/execlists: Minimalistic timeslicing")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Cc: <stable@vger.kernel.org> # v5.4+

Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>

> ---
>  drivers/gpu/drm/i915/gt/intel_lrc.c | 29 ++++++++++++++++++-----------
>  1 file changed, 18 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
> index 13941d1c0a4a..a1d268880cfe 100644
> --- a/drivers/gpu/drm/i915/gt/intel_lrc.c
> +++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
> @@ -1757,11 +1757,9 @@ need_timeslice(struct intel_engine_cs *engine, const struct i915_request *rq)
>  	if (!intel_engine_has_timeslices(engine))
>  		return false;
>  
> -	if (list_is_last(&rq->sched.link, &engine->active.requests))
> -		return false;
> -
> -	hint = max(rq_prio(list_next_entry(rq, sched.link)),
> -		   engine->execlists.queue_priority_hint);
> +	hint = engine->execlists.queue_priority_hint;
> +	if (!list_is_last(&rq->sched.link, &engine->active.requests))
> +		hint = max(hint, rq_prio(list_next_entry(rq, sched.link)));
>  
>  	return hint >= effective_prio(rq);
>  }
> @@ -1803,6 +1801,18 @@ static void set_timeslice(struct intel_engine_cs *engine)
>  	set_timer_ms(&engine->execlists.timer, active_timeslice(engine));
>  }
>  
> +static void start_timeslice(struct intel_engine_cs *engine)
> +{
> +	struct intel_engine_execlists *execlists = &engine->execlists;
> +
> +	execlists->switch_priority_hint = execlists->queue_priority_hint;
> +
> +	if (timer_pending(&execlists->timer))
> +		return;
> +
> +	set_timer_ms(&execlists->timer, timeslice(engine));
> +}
> +
>  static void record_preemption(struct intel_engine_execlists *execlists)
>  {
>  	(void)I915_SELFTEST_ONLY(execlists->preempt_hang.count++);
> @@ -1966,11 +1976,7 @@ static void execlists_dequeue(struct intel_engine_cs *engine)
>  				 * Even if ELSP[1] is occupied and not worthy
>  				 * of timeslices, our queue might be.
>  				 */
> -				if (!execlists->timer.expires &&
> -				    need_timeslice(engine, last))
> -					set_timer_ms(&execlists->timer,
> -						     timeslice(engine));
> -
> +				start_timeslice(engine);
>  				return;
>  			}
>  		}
> @@ -2005,7 +2011,8 @@ static void execlists_dequeue(struct intel_engine_cs *engine)
>  
>  			if (last && !can_merge_rq(last, rq)) {
>  				spin_unlock(&ve->base.active.lock);
> -				return; /* leave this for another */
> +				start_timeslice(engine);
> +				return; /* leave this for another sibling */
>  			}
>  
>  			ENGINE_TRACE(engine,
> -- 
> 2.25.1
