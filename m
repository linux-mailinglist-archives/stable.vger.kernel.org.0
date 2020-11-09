Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 530D72ABA3C
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732449AbgKINRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:17:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:44086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387534AbgKINQ7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:16:59 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E3B620731;
        Mon,  9 Nov 2020 13:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927818;
        bh=iBl7QcHeW99nusJn/uI8V7dx1V2IUg4flcnANZ0veZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q+gnzV4qJX8m3nR9Cj4/Cb2vdJ+M9bK71PCQaa+ggCboGUKeWeA8/NoR1KBt6kHQ7
         MTrhgCvMNdfisY6ZuzWEn4SXz4eonkIJ7AakqnhsDueUy8H1TA67xEHqQT1K7ezRj2
         GFSw1ChG6mlMZoWRA3pWgSdG0PtutJPUuJkzKpgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.9 006/133] drm/i915/gt: Always send a pulse down the engine after disabling heartbeat
Date:   Mon,  9 Nov 2020 13:54:28 +0100
Message-Id: <20201109125031.022270314@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit ca65fc0d8e01dca8fc82f0ccf433725469256c71 upstream.

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
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Acked-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200928221510.26044-2-chris@chris-wilson.co.uk
(cherry picked from commit 3dd66a94de59d7792e7917eb3075342e70f06f44)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/intel_engine_heartbeat.c |  106 ++++++++++++++---------
 1 file changed, 67 insertions(+), 39 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_engine_heartbeat.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_heartbeat.c
@@ -177,36 +177,82 @@ void intel_engine_init_heartbeat(struct
 	INIT_DELAYED_WORK(&engine->heartbeat.work, heartbeat);
 }
 
+static int __intel_engine_pulse(struct intel_engine_cs *engine)
+{
+	struct i915_sched_attr attr = { .priority = I915_PRIORITY_BARRIER };
+	struct intel_context *ce = engine->kernel_context;
+	struct i915_request *rq;
+
+	lockdep_assert_held(&ce->timeline->mutex);
+	GEM_BUG_ON(!intel_engine_has_preemption(engine));
+	GEM_BUG_ON(!intel_engine_pm_is_awake(engine));
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
+		goto out_rpm;
 
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
+
+out_rpm:
+	intel_engine_pm_put(engine);
+	return err;
 }
 
 int intel_engine_pulse(struct intel_engine_cs *engine)
 {
-	struct i915_sched_attr attr = { .priority = I915_PRIORITY_BARRIER };
 	struct intel_context *ce = engine->kernel_context;
-	struct i915_request *rq;
 	int err;
 
 	if (!intel_engine_has_preemption(engine))
@@ -215,30 +261,12 @@ int intel_engine_pulse(struct intel_engi
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


