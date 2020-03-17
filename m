Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAF7A18811E
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbgCQLLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:11:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:54142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728587AbgCQLLD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:11:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DACA205ED;
        Tue, 17 Mar 2020 11:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443462;
        bh=oKUQcNoM+pCBU8d14JbIiqP37ZEJTlXryKcN8HNgmOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HlAXxLd8Wrdg/L43CjtKOLrvL6kVBSEzYvyiblS+nCBAWQV46NEqJx6knKd0Ga8dG
         cvKg67qwV/BGwAcv09Jh88LehDXDIQV62UIGgAWlGgkoLZDE/EZdjZqTbNvaV2k9NB
         NjDtR/G/5ffSipehNCCKnZO1CjwlYy7qRdynZH1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.5 088/151] drm/i915: Defer semaphore priority bumping to a workqueue
Date:   Tue, 17 Mar 2020 11:54:58 +0100
Message-Id: <20200317103332.701376068@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 14a0d527a479eb2cb6067f9e5e163e1bf35db2a9 upstream.

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
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_request.c |   22 +++++++++++++++++-----
 drivers/gpu/drm/i915/i915_request.h |    2 ++
 2 files changed, 19 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/i915_request.c
+++ b/drivers/gpu/drm/i915/i915_request.c
@@ -529,19 +529,31 @@ submit_notify(struct i915_sw_fence *fenc
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
 
@@ -1283,9 +1295,9 @@ void __i915_request_queue(struct i915_re
 	 * decide whether to preempt the entire chain so that it is ready to
 	 * run at the earliest possible convenience.
 	 */
-	i915_sw_fence_commit(&rq->semaphore);
 	if (attr && rq->engine->schedule)
 		rq->engine->schedule(rq, attr);
+	i915_sw_fence_commit(&rq->semaphore);
 	i915_sw_fence_commit(&rq->submit);
 }
 
--- a/drivers/gpu/drm/i915/i915_request.h
+++ b/drivers/gpu/drm/i915/i915_request.h
@@ -26,6 +26,7 @@
 #define I915_REQUEST_H
 
 #include <linux/dma-fence.h>
+#include <linux/irq_work.h>
 #include <linux/lockdep.h>
 
 #include "gt/intel_context_types.h"
@@ -147,6 +148,7 @@ struct i915_request {
 	};
 	struct list_head execute_cb;
 	struct i915_sw_fence semaphore;
+	struct irq_work semaphore_work;
 
 	/*
 	 * A list of everyone we wait upon, and everyone who waits upon us.


