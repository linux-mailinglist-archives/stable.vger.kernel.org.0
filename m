Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 155FA1E3AE6
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 09:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387580AbgE0Hr1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 27 May 2020 03:47:27 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:62788 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387423AbgE0Hr0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 May 2020 03:47:26 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 21305686-1500050 
        for multiple; Wed, 27 May 2020 08:47:22 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <4447522d-704e-33b1-7d8a-fef095781200@linux.intel.com>
References: <20200526090753.11329-1-chris@chris-wilson.co.uk> <20200526090753.11329-2-chris@chris-wilson.co.uk> <2f6be936-043d-23f7-873f-6c2228f2abe5@linux.intel.com> <159056303478.21924.12941497462148590096@build.alporthouse.com> <4447522d-704e-33b1-7d8a-fef095781200@linux.intel.com>
To:     Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
From:   Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [Intel-gfx] [PATCH 2/2] drm/i915/gt: Do not schedule normal requests immediately along virtual
Message-ID: <159056564189.24269.17952997651487673956@build.alporthouse.com>
User-Agent: alot/0.8.1
Date:   Wed, 27 May 2020 08:47:21 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Tvrtko Ursulin (2020-05-27 08:32:05)
> 
> On 27/05/2020 08:03, Chris Wilson wrote:
> > Quoting Tvrtko Ursulin (2020-05-27 07:51:44)
> >>
> >> On 26/05/2020 10:07, Chris Wilson wrote:
> >>> When we push a virtual request onto the HW, we update the rq->engine to
> >>> point to the physical engine. A request that is then submitted by the
> >>> user that waits upon the virtual engine, but along the physical engine
> >>> in use, will then see that it is due to be submitted to the same engine
> >>> and take a shortcut (and be queued without waiting for the completion
> >>> fence). However, the virtual request may be preempted (either by higher
> >>> priority users, or by timeslicing) and removed from the physical engine
> >>> to be migrated over to one of its siblings. The dependent normal request
> >>> however is oblivious to the removal of the virtual request and remains
> >>> queued to execute on HW, believing that once it reaches the head of its
> >>> queue all of its predecessors will have completed executing!
> >>>
> >>> v2: Beware restriction of signal->execution_mask prior to submission.
> >>>
> >>> Fixes: 6d06779e8672 ("drm/i915: Load balancing across a virtual engine")
> >>> Testcase: igt/gem_exec_balancer/sliced
> >>> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> >>> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> >>> Cc: <stable@vger.kernel.org> # v5.3+
> >>> ---
> >>>    drivers/gpu/drm/i915/i915_request.c | 25 +++++++++++++++++++++----
> >>>    1 file changed, 21 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
> >>> index 33bbad623e02..0b07ccc7e9bc 100644
> >>> --- a/drivers/gpu/drm/i915/i915_request.c
> >>> +++ b/drivers/gpu/drm/i915/i915_request.c
> >>> @@ -1237,6 +1237,25 @@ i915_request_await_execution(struct i915_request *rq,
> >>>        return 0;
> >>>    }
> >>>    
> >>> +static int
> >>> +await_request_submit(struct i915_request *to, struct i915_request *from)
> >>> +{
> >>> +     /*
> >>> +      * If we are waiting on a virtual engine, then it may be
> >>> +      * constrained to execute on a single engine *prior* to submission.
> >>> +      * When it is submitted, it will be first submitted to the virtual
> >>> +      * engine and then passed to the physical engine. We cannot allow
> >>> +      * the waiter to be submitted immediately to the physical engine
> >>> +      * as it may then bypass the virtual request.
> >>> +      */
> >>> +     if (to->engine == READ_ONCE(from->engine))
> >>> +             return i915_sw_fence_await_sw_fence_gfp(&to->submit,
> >>> +                                                     &from->submit,
> >>> +                                                     I915_FENCE_GFP);
> >>> +     else
> >>> +             return __i915_request_await_execution(to, from, NULL);
> >>
> >> If I am following correctly this branch will be the virtual <-> physical
> >> or virtual <-> virtual dependency on the same physical engine. Why is
> >> await_execution sufficient in this case? Is there something preventing
> >> timeslicing between the two (not wanted right!) once from start
> >> execution (not finishes).
> > 
> > Timeslicing is only between independent requests. When we expire a
> > request, we also expire all of its waiters along the same engine, so
> > that the execution order remains intact.
> 
> Via scheduler dependencies - they are enough?

Yes.
-Chris
