Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40F8927AD93
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 14:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgI1MNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 08:13:02 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:50005 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726617AbgI1MNC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 08:13:02 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 22556664-1500050 
        for multiple; Mon, 28 Sep 2020 13:12:52 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        stable@vger.kernel.org, Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH v2 1/3] drm/i915: Cancel outstanding work after disabling heartbeats on an engine
Date:   Mon, 28 Sep 2020 13:12:53 +0100
Message-Id: <20200928121255.21494-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We only allow persistent requests to remain on the GPU past the closure
of their containing context (and process) so long as they are continuously
checked for hangs or allow other requests to preempt them, as we need to
ensure forward progress of the system. If we allow persistent contexts
to remain on the system after the the hangcheck mechanism is disabled,
the system may grind to a halt. On disabling the mechanism, we sent a
pulse along the engine to remove all executing contexts from the engine
which would check for hung contexts -- but we did not prevent those
contexts from being resubmitted if they survived the final hangcheck.

Fixes: 9a40bddd47ca ("drm/i915/gt: Expose heartbeat interval via sysfs")
Testcase: igt/gem_ctx_persistence/heartbeat-stop
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.7+
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
---
 drivers/gpu/drm/i915/gt/intel_engine.h | 9 +++++++++
 drivers/gpu/drm/i915/i915_request.c    | 5 +++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/i915/gt/intel_engine.h b/drivers/gpu/drm/i915/gt/intel_engine.h
index 08e2c000dcc3..7c3a1012e702 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine.h
+++ b/drivers/gpu/drm/i915/gt/intel_engine.h
@@ -337,4 +337,13 @@ intel_engine_has_preempt_reset(const struct intel_engine_cs *engine)
 	return intel_engine_has_preemption(engine);
 }
 
+static inline bool
+intel_engine_has_heartbeat(const struct intel_engine_cs *engine)
+{
+	if (!IS_ACTIVE(CONFIG_DRM_I915_HEARTBEAT_INTERVAL))
+		return false;
+
+	return READ_ONCE(engine->props.heartbeat_interval_ms);
+}
+
 #endif /* _INTEL_RINGBUFFER_H_ */
diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
index 436ce368ddaa..0e813819b041 100644
--- a/drivers/gpu/drm/i915/i915_request.c
+++ b/drivers/gpu/drm/i915/i915_request.c
@@ -542,8 +542,13 @@ bool __i915_request_submit(struct i915_request *request)
 	if (i915_request_completed(request))
 		goto xfer;
 
+	if (unlikely(intel_context_is_closed(request->context) &&
+		     !intel_engine_has_heartbeat(engine)))
+		intel_context_set_banned(request->context);
+
 	if (unlikely(intel_context_is_banned(request->context)))
 		i915_request_set_error_once(request, -EIO);
+
 	if (unlikely(fatal_error(request->fence.error)))
 		__i915_request_skip(request);
 
-- 
2.20.1

