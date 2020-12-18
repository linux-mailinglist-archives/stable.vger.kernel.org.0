Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C902DE272
	for <lists+stable@lfdr.de>; Fri, 18 Dec 2020 13:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725884AbgLRML2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 18 Dec 2020 07:11:28 -0500
Received: from mail.fireflyinternet.com ([77.68.26.236]:50400 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725908AbgLRML2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Dec 2020 07:11:28 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 23365904-1500050 
        for multiple; Fri, 18 Dec 2020 12:10:39 +0000
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20201218091944.32417-1-chris@chris-wilson.co.uk>
References: <20201218091944.32417-1-chris@chris-wilson.co.uk>
Subject: Re: [PATCH] drm/i915: Check for rq->hwsp validity after acquiring RCU lock
From:   Chris Wilson <chris@chris-wilson.co.uk>
Cc:     Tvrtko Ursulin <tvrtko.ursulin@intel.com>, stable@vger.kernel.org
To:     intel-gfx@lists.freedesktop.org
Date:   Fri, 18 Dec 2020 12:10:37 +0000
Message-ID: <160829343783.11872.1182020271398820285@build.alporthouse.com>
User-Agent: alot/0.9
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Chris Wilson (2020-12-18 09:19:44)
> Since we allow removing the timeline map at runtime, there is a risk
> that rq->hwsp points into a stale page. To control that risk, we hold
> the RCU read lock while reading *rq->hwsp, but we missed a couple of
> important barriers. First, the unpinning / removal of the timeline map
> must be after all RCU readers into that map are complete, i.e. after an
> rcu barrier (in this case courtesy of call_rcu()). Secondly, we must
> make sure that the rq->hwsp we are about to dereference under the RCU
> lock is valid. In this case, we make the rq->hwsp pointer safe during
> i915_request_retire() and so we know that rq->hwsp may become invalid
> only after the request has been signaled. Therefore is the request is
> not yet signaled when we acquire rq->hwsp under the RCU, we know that
> rq->hwsp will remain valid for the duration of the RCU read lock.
> 
> This is a very small window that may lead to either considering the
> request not completed (causing a delay until the request is checked
> again, any wait for the request is not affected) or dereferencing an
> invalid pointer.
> 
> Fixes: 3adac4689f58 ("drm/i915: Introduce concept of per-timeline (context) HWSP")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Cc: <stable@vger.kernel.org> # v5.1+
> ---
>  drivers/gpu/drm/i915/gt/intel_breadcrumbs.c | 11 ++----
>  drivers/gpu/drm/i915/gt/intel_timeline.c    |  6 ++--
>  drivers/gpu/drm/i915/i915_request.h         | 37 ++++++++++++++++++---
>  3 files changed, 39 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c b/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c
> index 3c62fd6daa76..f96cd7d9b419 100644
> --- a/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c
> +++ b/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c
> @@ -134,11 +134,6 @@ static bool remove_signaling_context(struct intel_breadcrumbs *b,
>         return true;
>  }
>  
> -static inline bool __request_completed(const struct i915_request *rq)
> -{
> -       return i915_seqno_passed(__hwsp_seqno(rq), rq->fence.seqno);
> -}
> -
>  __maybe_unused static bool
>  check_signal_order(struct intel_context *ce, struct i915_request *rq)
>  {
> @@ -245,7 +240,7 @@ static void signal_irq_work(struct irq_work *work)
>                 list_for_each_entry_rcu(rq, &ce->signals, signal_link) {
>                         bool release;
>  
> -                       if (!__request_completed(rq))
> +                       if (!__i915_request_is_complete(rq))
>                                 break;
>  
>                         if (!test_and_clear_bit(I915_FENCE_FLAG_SIGNAL,
> @@ -380,7 +375,7 @@ static void insert_breadcrumb(struct i915_request *rq)
>          * straight onto a signaled list, and queue the irq worker for
>          * its signal completion.
>          */
> -       if (__request_completed(rq)) {
> +       if (__i915_request_is_complete(rq)) {
>                 irq_signal_request(rq, b);
>                 return;
>         }
> @@ -468,7 +463,7 @@ void i915_request_cancel_breadcrumb(struct i915_request *rq)
>         if (release)
>                 intel_context_put(ce);
>  
> -       if (__request_completed(rq))
> +       if (__i915_request_is_complete(rq))
>                 irq_signal_request(rq, b);
>  
>         i915_request_put(rq);
> diff --git a/drivers/gpu/drm/i915/gt/intel_timeline.c b/drivers/gpu/drm/i915/gt/intel_timeline.c
> index 512afacd2bdc..a0ce2fb8737a 100644
> --- a/drivers/gpu/drm/i915/gt/intel_timeline.c
> +++ b/drivers/gpu/drm/i915/gt/intel_timeline.c
> @@ -126,6 +126,10 @@ static void __rcu_cacheline_free(struct rcu_head *rcu)
>         struct intel_timeline_cacheline *cl =
>                 container_of(rcu, typeof(*cl), rcu);
>  
> +       /* Must wait until after all *rq->hwsp are complete before removing */
> +       i915_gem_object_unpin_map(cl->hwsp->vma->obj);
> +       i915_vma_put(cl->hwsp->vma);
> +
>         i915_active_fini(&cl->active);
>         kfree(cl);
>  }
> @@ -134,8 +138,6 @@ static void __idle_cacheline_free(struct intel_timeline_cacheline *cl)
>  {
>         GEM_BUG_ON(!i915_active_is_idle(&cl->active));
>  
> -       i915_gem_object_unpin_map(cl->hwsp->vma->obj);
> -       i915_vma_put(cl->hwsp->vma);
>         __idle_hwsp_free(cl->hwsp, ptr_unmask_bits(cl->vaddr, CACHELINE_BITS));

I was thinking this was just marking it as being available, but no it
really does free.
-Chris
