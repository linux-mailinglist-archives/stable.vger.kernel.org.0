Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31BF51E781E
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 10:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbgE2IUc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 May 2020 04:20:32 -0400
Received: from mga18.intel.com ([134.134.136.126]:10357 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgE2IUb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 May 2020 04:20:31 -0400
IronPort-SDR: HSHvvXBChkGiGML0D7VSzmYbGuwzezBnafZ8SE6QQ10rnnzYUzqyy6tfa1mQN9f1zP0KnaQKgW
 fLu03xWjYNzA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 01:20:31 -0700
IronPort-SDR: 7xsbwjTLoEbflCOwohYlw0DhA4C3m6T+1s+AbvYmpA7e9kHJCDifwlErA4EyddV8Agk4Cn9T7G
 BhxN/BaXgWlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,447,1583222400"; 
   d="scan'208";a="376641794"
Received: from vtt.iind.intel.com ([10.145.162.194])
  by fmsmga001.fm.intel.com with ESMTP; 29 May 2020 01:20:28 -0700
From:   Prasad Nallani <prasad.nallani@intel.com>
To:     gfx-internal-devel@eclists.intel.com
Cc:     andi.shyti@intel.com, Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 08/23] drm/i915: Defer semaphore priority bumping to a workqueue
Date:   Fri, 29 May 2020 13:47:55 +0530
Message-Id: <20200529081810.10747-9-prasad.nallani@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200529081810.10747-1-prasad.nallani@intel.com>
References: <20200529081810.10747-1-prasad.nallani@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

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
index 1efc82f78f44..1fd94723a5cd 100644
--- a/drivers/gpu/drm/i915/i915_request.c
+++ b/drivers/gpu/drm/i915/i915_request.c
@@ -527,19 +527,31 @@ submit_notify(struct i915_sw_fence *fence, enum i915_sw_fence_notify state)
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
 
@@ -1296,9 +1308,9 @@ void __i915_request_queue(struct i915_request *rq,
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
index f57eadcf3583..fccc339949ec 100644
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
