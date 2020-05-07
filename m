Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEAD1C9523
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 17:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgEGPei convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 7 May 2020 11:34:38 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:60773 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725985AbgEGPei (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 11:34:38 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 21140512-1500050 
        for multiple; Thu, 07 May 2020 16:34:36 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <2ea266b4-64a7-e494-65e9-6435d4455a71@linux.intel.com>
References: <20200507082124.1673-1-chris@chris-wilson.co.uk> <f5d72c82-7a9e-3142-f297-b2231f2e9b9f@linux.intel.com> <158886364344.20858.57212288691515302@build.alporthouse.com> <2ea266b4-64a7-e494-65e9-6435d4455a71@linux.intel.com>
Subject: Re: [Intel-gfx] [PATCH 1/3] drm/i915: Mark concurrent submissions with a weak-dependency
To:     Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
From:   Chris Wilson <chris@chris-wilson.co.uk>
Message-ID: <158886567396.20858.16515551637133920867@build.alporthouse.com>
User-Agent: alot/0.8.1
Date:   Thu, 07 May 2020 16:34:33 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Tvrtko Ursulin (2020-05-07 16:23:59)
> 
> 
> On 07/05/2020 16:00, Chris Wilson wrote:
> > Quoting Tvrtko Ursulin (2020-05-07 15:53:08)
> >> On 07/05/2020 09:21, Chris Wilson wrote:
> >>> We recorded the dependencies for WAIT_FOR_SUBMIT in order that we could
> >>> correctly perform priority inheritance from the parallel branches to the
> >>> common trunk. However, for the purpose of timeslicing and reset
> >>> handling, the dependency is weak -- as we the pair of requests are
> >>> allowed to run in parallel and not in strict succession. So for example
> >>> we do need to suspend one if the other hangs.
> >>>
> >>> The real significance though is that this allows us to rearrange
> >>> groups of WAIT_FOR_SUBMIT linked requests along the single engine, and
> >>> so can resolve user level inter-batch scheduling dependencies from user
> >>> semaphores.
> >>>
> >>> Fixes: c81471f5e95c ("drm/i915: Copy across scheduler behaviour flags across submit fences")
> >>> Testcase: igt/gem_exec_fence/submit
> >>> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> >>> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> >>> Cc: <stable@vger.kernel.org> # v5.6+
> >>> ---
> >>>    drivers/gpu/drm/i915/gt/intel_lrc.c         | 9 +++++++++
> >>>    drivers/gpu/drm/i915/i915_request.c         | 8 ++++++--
> >>>    drivers/gpu/drm/i915/i915_scheduler.c       | 6 +++---
> >>>    drivers/gpu/drm/i915/i915_scheduler.h       | 3 ++-
> >>>    drivers/gpu/drm/i915/i915_scheduler_types.h | 1 +
> >>>    5 files changed, 21 insertions(+), 6 deletions(-)
> >>>
> >>> diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
> >>> index dc3f2ee7136d..10109f661bcb 100644
> >>> --- a/drivers/gpu/drm/i915/gt/intel_lrc.c
> >>> +++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
> >>> @@ -1880,6 +1880,9 @@ static void defer_request(struct i915_request *rq, struct list_head * const pl)
> >>>                        struct i915_request *w =
> >>>                                container_of(p->waiter, typeof(*w), sched);
> >>>    
> >>> +                     if (p->flags & I915_DEPENDENCY_WEAK)
> >>> +                             continue;
> >>> +
> >>
> >> I did not quite get it - submit fence dependency would mean different
> >> engines, so the below check (w->engine != rq->engine) would effectively
> >> have the same effect. What am I missing?
> > 
> > That submit fences can be between different contexts on the same engine.
> > The example (from mesa) is where we have two interdependent clients
> > which are using their own userlevel scheduling inside each batch, i.e.
> > waiting on semaphores.
> 
> But if submit fence was used that means the waiter should never be 
> submitted ahead of the signaler. And with this change it could get ahead 
> in the priolist, no?

You do recall the starting point for this series was future fences :)

The test case for this is:

	execbuf.flags = engine | I915_EXEC_FENCE_OUT;
	execbuf.batch_start_offset = 0;
       	gem_execbuf_wr(i915, &execbuf);

       	execbuf.rsvd1 = gem_context_clone_with_engines(i915, 0);
       	execbuf.rsvd2 >>= 32;
       	execbuf.flags = e->flags;
       	execbuf.flags |= I915_EXEC_FENCE_SUBMIT | I915_EXEC_FENCE_OUT;
       	execbuf.batch_start_offset = offset;
       	gem_execbuf_wr(i915, &execbuf);
       	gem_context_destroy(i915, execbuf.rsvd1);

       	gem_sync(i915, obj.handle);

	/* no hangs! */
	out = execbuf.rsvd2;
       	igt_assert_eq(sync_fence_status(out), 1);
       	close(out);

       	out = execbuf.rsvd2 >> 32;
       	igt_assert_eq(sync_fence_status(out), 1);
       	close(out);

Where the batches are a couple of semaphore waits, which is the essence
of a bonded request but being run on a single engine.

Unless we treat the submit fence as a weak dependency here, we can't
timeslice between the two.

The other observation is that we may not have to suspend the request if
the other hangs as the linkage is implicit. If the request does continue
to wait on the hung request, we can only hope it too hangs. I should
make that a second patch, since it is a distinct change.
-Chris
