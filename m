Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2477827AD91
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 14:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbgI1MNA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 08:13:00 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:50001 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726393AbgI1MNA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 08:13:00 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 22556665-1500050 
        for multiple; Mon, 28 Sep 2020 13:12:53 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 2/3] drm/i915/gt: Always send a pulse down the engine after disabling heartbeat
Date:   Mon, 28 Sep 2020 13:12:54 +0100
Message-Id: <20200928121255.21494-2-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200928121255.21494-1-chris@chris-wilson.co.uk>
References: <20200928121255.21494-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently, we check we can send a pulse prior to disabling the
heartbeat to verify that we can change the heartbeat, but since we may
re-evaluate execution upon changing the heartbeat interval we need another
pulse afterwards to refresh execution.

v2: Tvrtko asked if we could reduce the double pulse to a single, which
opened up a discussion of how we should handle the pulse-error after
attempting to change the property, and the desire to serialise
adjustment of the property with its validating pulse, and unwind upon
failure.

Fixes: 9a40bddd47ca ("drm/i915/gt: Expose heartbeat interval via sysfs")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: <stable@vger.kernel.org> # v5.7+
---
 .../gpu/drm/i915/gt/intel_engine_heartbeat.c  | 105 +++++++++++-------
 1 file changed, 66 insertions(+), 39 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_engine_heartbeat.c b/drivers/gpu/drm/i915/gt/intel_engine_heartbeat.c
index 8ffdf676c0a0..eda475f50fa7 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_heartbeat.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_heartbeat.c
@@ -177,36 +177,81 @@ void intel_engine_init_heartbeat(struct intel_engine_cs *engine)
 	INIT_DELAYED_WORK(&engine->heartbeat.work, heartbeat);
 }
 
+static int __intel_engine_pulse(struct intel_engine_cs *engine)
+{
+	struct i915_sched_attr attr = { .priority = I915_PRIORITY_BARRIER };
+	struct intel_context *ce = engine->kernel_context;
+	struct i915_request *rq;
+
+	lockdep_assert_held(&ce->timeline->mutex);
+	GEM_BUG_ON(intel_engine_has_preemption(engine));
+	GEM_BUG_ON(intel_engine_pm_is_awake(engine));
+
+	intel_context_enter(ce);
+	rq = __i915_request_create(ce, GFP_NOWAIT | __GFP_NOWARN);
+	intel_context_exit(ce);
+	if (IS_ERR(rq))
+		return PTR_ERR(rq);
+
+	__set_bit(I915_FENCE_FLAG_SENTINEL, &rq->fence.flags);
+	idle_pulse(engine, rq);
+
+	__i915_request_commit(rq);
+	__i915_request_queue(rq, &attr);
+	GEM_BUG_ON(rq->sched.attr.priority < I915_PRIORITY_BARRIER);
+
+	return 0;
+}
+
+static unsigned long set_heartbeat(struct intel_engine_cs *engine,
+				   unsigned long delay)
+{
+	unsigned long old;
+
+	old = xchg(&engine->props.heartbeat_interval_ms, delay);
+	if (delay)
+		intel_engine_unpark_heartbeat(engine);
+	else
+		intel_engine_park_heartbeat(engine);
+
+	return old;
+}
+
 int intel_engine_set_heartbeat(struct intel_engine_cs *engine,
 			       unsigned long delay)
 {
-	int err;
+	struct intel_context *ce = engine->kernel_context;
+	int err = 0;
 
-	/* Send one last pulse before to cleanup persistent hogs */
-	if (!delay && IS_ACTIVE(CONFIG_DRM_I915_PREEMPT_TIMEOUT)) {
-		err = intel_engine_pulse(engine);
-		if (err)
-			return err;
-	}
+	if (!delay && !intel_engine_has_preempt_reset(engine))
+		return -ENODEV;
+
+	intel_engine_pm_get(engine);
+
+	err = mutex_lock_interruptible(&ce->timeline->mutex);
+	if (err)
+		return err;
 
-	WRITE_ONCE(engine->props.heartbeat_interval_ms, delay);
+	if (delay != engine->props.heartbeat_interval_ms) {
+		unsigned long saved = set_heartbeat(engine, delay);
 
-	if (intel_engine_pm_get_if_awake(engine)) {
-		if (delay)
-			intel_engine_unpark_heartbeat(engine);
-		else
-			intel_engine_park_heartbeat(engine);
-		intel_engine_pm_put(engine);
+		/* recheck current execution */
+		if (intel_engine_has_preemption(engine)) {
+			err = __intel_engine_pulse(engine);
+			if (err)
+				set_heartbeat(engine, saved);
+		}
 	}
 
-	return 0;
+	mutex_unlock(&ce->timeline->mutex);
+	intel_engine_pm_put(engine);
+
+	return err;
 }
 
 int intel_engine_pulse(struct intel_engine_cs *engine)
 {
-	struct i915_sched_attr attr = { .priority = I915_PRIORITY_BARRIER };
 	struct intel_context *ce = engine->kernel_context;
-	struct i915_request *rq;
 	int err;
 
 	if (!intel_engine_has_preemption(engine))
@@ -215,30 +260,12 @@ int intel_engine_pulse(struct intel_engine_cs *engine)
 	if (!intel_engine_pm_get_if_awake(engine))
 		return 0;
 
-	if (mutex_lock_interruptible(&ce->timeline->mutex)) {
-		err = -EINTR;
-		goto out_rpm;
+	err = -EINTR;
+	if (!mutex_lock_interruptible(&ce->timeline->mutex)) {
+		err = __intel_engine_pulse(engine);
+		mutex_unlock(&ce->timeline->mutex);
 	}
 
-	intel_context_enter(ce);
-	rq = __i915_request_create(ce, GFP_NOWAIT | __GFP_NOWARN);
-	intel_context_exit(ce);
-	if (IS_ERR(rq)) {
-		err = PTR_ERR(rq);
-		goto out_unlock;
-	}
-
-	__set_bit(I915_FENCE_FLAG_SENTINEL, &rq->fence.flags);
-	idle_pulse(engine, rq);
-
-	__i915_request_commit(rq);
-	__i915_request_queue(rq, &attr);
-	GEM_BUG_ON(rq->sched.attr.priority < I915_PRIORITY_BARRIER);
-	err = 0;
-
-out_unlock:
-	mutex_unlock(&ce->timeline->mutex);
-out_rpm:
 	intel_engine_pm_put(engine);
 	return err;
 }
-- 
2.20.1

