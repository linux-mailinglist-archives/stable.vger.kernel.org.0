Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCB721F406A
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 18:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731193AbgFIQNl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 12:13:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:23416 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731126AbgFIQNW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 12:13:22 -0400
IronPort-SDR: mTzo8lA7H7gqXlGW2mzo0X9LHxI0oJJjx1SAfdKns+kW6u14+CyvMJLp1mUSDR/4Ko0IcXWHjL
 dmDhQ9PUbWXw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2020 09:13:21 -0700
IronPort-SDR: 3MT0a82VbHxYdpDdxwVZasiV9/OWeX7YjDFbud65t+6zGg+CtDIRaao1vEKzbgj9bbG8QaL5zk
 1xJC0p8It2uw==
X-IronPort-AV: E=Sophos;i="5.73,492,1583222400"; 
   d="scan'208";a="306307387"
Received: from gem-build.fi.intel.com (HELO localhost) ([10.237.72.180])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2020 09:13:20 -0700
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     gfx-internal-devel@eclists.intel.com
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 087/185] drm/i915: Defer semaphore priority bumping to a workqueue
Date:   Tue,  9 Jun 2020 16:05:52 +0000
Message-Id: <20200609160731.287073-88-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200609160731.287073-1-chris@chris-wilson.co.uk>
References: <20200609160731.287073-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since the semaphore fence may be signaled from inside an interrupt
handler from inside a request holding its request->lock, we cannot then
enter into the engine->active.lock for processing the semaphore priority
bump as we may traverse our call tree and end up on another held
request.

CPU 0:
[ 2243.218864]  _raw_spin_lock_irqsave+0x9a/0xb0
[ 2243.218867]  i915_schedule_bump_priority+0x49/0x80 [i915]
[ 2243.218869]  semaphore_notify+0x6d/0x98 [i915]
[ 2243.218871]  __i915_sw_fence_complete+0x61/0x420 [i915]
[ 2243.218874]  ? kmem_cache_free+0x211/0x290
[ 2243.218876]  i915_sw_fence_complete+0x58/0x80 [i915]
[ 2243.218879]  dma_i915_sw_fence_wake+0x3e/0x80 [i915]
[ 2243.218881]  signal_irq_work+0x571/0x690 [i915]
[ 2243.218883]  irq_work_run_list+0xd7/0x120
[ 2243.218885]  irq_work_run+0x1d/0x50
[ 2243.218887]  smp_irq_work_interrupt+0x21/0x30
[ 2243.218889]  irq_work_interrupt+0xf/0x20

CPU 1:
[ 2242.173107]  _raw_spin_lock+0x8f/0xa0
[ 2242.173110]  __i915_request_submit+0x64/0x4a0 [i915]
[ 2242.173112]  __execlists_submission_tasklet+0x8ee/0x2120 [i915]
[ 2242.173114]  ? i915_sched_lookup_priolist+0x1e3/0x2b0 [i915]
[ 2242.173117]  execlists_submit_request+0x2e8/0x2f0 [i915]
[ 2242.173119]  submit_notify+0x8f/0xc0 [i915]
[ 2242.173121]  __i915_sw_fence_complete+0x61/0x420 [i915]
[ 2242.173124]  ? _raw_spin_unlock_irqrestore+0x39/0x40
[ 2242.173137]  i915_sw_fence_complete+0x58/0x80 [i915]
[ 2242.173140]  i915_sw_fence_commit+0x16/0x20 [i915]

Closes: https://gitlab.freedesktop.org/drm/intel/issues/1318
Fixes: b7404c7ecb38 ("drm/i915: Bump ready tasks ahead of busywaits")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: <stable@vger.kernel.org> # v5.2+
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200310101720.9944-1-chris@chris-wilson.co.uk
(cherry picked from commit 209df10bb4536c81c2540df96c02cd079435357f)
---
 drivers/gpu/drm/i915/i915_request.c | 22 +++++++++++++++++-----
 drivers/gpu/drm/i915/i915_request.h |  2 ++
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
index e7f96ce0b071e..c7573e66107d0 100644
--- a/drivers/gpu/drm/i915/i915_request.c
+++ b/drivers/gpu/drm/i915/i915_request.c
@@ -629,19 +629,31 @@ submit_notify(struct i915_sw_fence *fence, enum i915_sw_fence_notify state)
 	return NOTIFY_DONE;
 }
 
+static void irq_semaphore_cb(struct irq_work *wrk)
+{
+	struct i915_request *rq =
+		container_of(wrk, typeof(*rq), semaphore_work);
+
+	i915_schedule_bump_priority(rq, I915_PRIORITY_NOSEMAPHORE);
+	i915_request_put(rq);
+}
+
 static int __i915_sw_fence_call
 semaphore_notify(struct i915_sw_fence *fence, enum i915_sw_fence_notify state)
 {
-	struct i915_request *request =
-		container_of(fence, typeof(*request), semaphore);
+	struct i915_request *rq = container_of(fence, typeof(*rq), semaphore);
 
 	switch (state) {
 	case FENCE_COMPLETE:
-		i915_schedule_bump_priority(request, I915_PRIORITY_NOSEMAPHORE);
+		if (!(READ_ONCE(rq->sched.attr.priority) & I915_PRIORITY_NOSEMAPHORE)) {
+			i915_request_get(rq);
+			init_irq_work(&rq->semaphore_work, irq_semaphore_cb);
+			irq_work_queue(&rq->semaphore_work);
+		}
 		break;
 
 	case FENCE_FREE:
-		i915_request_put(request);
+		i915_request_put(rq);
 		break;
 	}
 
@@ -1503,9 +1515,9 @@ void __i915_request_queue(struct i915_request *rq,
 	 * decide whether to preempt the entire chain so that it is ready to
 	 * run at the earliest possible convenience.
 	 */
-	i915_sw_fence_commit(&rq->semaphore);
 	if (attr && rq->engine->schedule)
 		rq->engine->schedule(rq, attr);
+	i915_sw_fence_commit(&rq->semaphore);
 	i915_sw_fence_commit(&rq->submit);
 }
 
diff --git a/drivers/gpu/drm/i915/i915_request.h b/drivers/gpu/drm/i915/i915_request.h
index 32ddba894243f..64501b4b3e3a2 100644
--- a/drivers/gpu/drm/i915/i915_request.h
+++ b/drivers/gpu/drm/i915/i915_request.h
@@ -26,6 +26,7 @@
 #define I915_REQUEST_H
 
 #include <linux/dma-fence.h>
+#include <linux/irq_work.h>
 #include <linux/lockdep.h>
 
 #include "gem/i915_gem_context_types.h"
@@ -208,6 +209,7 @@ struct i915_request {
 	};
 	struct list_head execute_cb;
 	struct i915_sw_fence semaphore;
+	struct irq_work semaphore_work;
 
 	/*
 	 * A list of everyone we wait upon, and everyone who waits upon us.
---------------------------------------------------------------------
Intel Corporation (UK) Limited
Registered No. 1134945 (England)
Registered Office: Pipers Way, Swindon SN3 1RJ
VAT No: 860 2173 47

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

