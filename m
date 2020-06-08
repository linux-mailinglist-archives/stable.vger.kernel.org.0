Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4A71F16B1
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 12:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729368AbgFHK2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 06:28:53 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:56317 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729315AbgFHK2w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jun 2020 06:28:52 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 21429419-1500050 
        for multiple; Mon, 08 Jun 2020 11:28:46 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915/gt: Prevent enabling breadcrumbs on the virtual engine
Date:   Mon,  8 Jun 2020 11:28:45 +0100
Message-Id: <20200608102845.26194-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The virtual engines are not connected directly to hardware, so do not
generate interrupts themselves, nor do we expect to enable breadcrumb
tracking on them. However, if we clear out a stale virtual request, we
will process the breadcrumbs on the current virtual engine. Here, we
only need to add the delayed signal onto the stale signal queue, and
send the signal once clear of the engine locks. In the meantime, this
may be transferred onto the next sibling if we execute the next virtual
request before the work is completed.

The effect of losing tracking of the virtual breadcrumb interrupt is
that we leak the GT wakeref, keeping the device awake.

Reported-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Fixes: b647c7df01b7 ("drm/i915: Fixup preempt-to-busy vs resubmission of a virtual request")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: <stable@vger.kernel.org> # v5.5+
---
 drivers/gpu/drm/i915/gt/intel_breadcrumbs.c | 6 ++++++
 drivers/gpu/drm/i915/gt/intel_engine_cs.c   | 3 +++
 drivers/gpu/drm/i915/gt/intel_lrc.c         | 2 ++
 3 files changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c b/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c
index d907d538176e..a6ab1c1dc2cd 100644
--- a/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c
+++ b/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c
@@ -225,6 +225,9 @@ static bool __intel_breadcrumbs_arm_irq(struct intel_breadcrumbs *b)
 	struct intel_engine_cs *engine =
 		container_of(b, struct intel_engine_cs, breadcrumbs);
 
+	if (intel_engine_is_virtual(engine))
+		return true;
+
 	lockdep_assert_held(&b->irq_lock);
 	if (b->irq_armed)
 		return true;
@@ -308,6 +311,9 @@ void intel_engine_transfer_stale_breadcrumbs(struct intel_engine_cs *engine,
 
 void intel_engine_fini_breadcrumbs(struct intel_engine_cs *engine)
 {
+	struct intel_breadcrumbs *b = &engine->breadcrumbs;
+
+	irq_work_sync(&b->irq_work);
 }
 
 bool i915_request_enable_breadcrumb(struct i915_request *rq)
diff --git a/drivers/gpu/drm/i915/gt/intel_engine_cs.c b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
index e5141a897786..4f2c348aa32c 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_cs.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
@@ -1515,6 +1515,9 @@ void intel_engine_dump(struct intel_engine_cs *engine,
 		drm_printf(m, "*** WEDGED ***\n");
 
 	drm_printf(m, "\tAwake? %d\n", atomic_read(&engine->wakeref.count));
+	drm_printf(m, "\tBreadcrumbs? armed:%s, signalers:%s\n",
+		   yesno(engine->breadcrumbs.irq_armed),
+		   yesno(!list_empty(&engine->breadcrumbs.signalers)));
 	drm_printf(m, "\tBarriers?: %s\n",
 		   yesno(!llist_empty(&engine->barrier_tasks)));
 	drm_printf(m, "\tLatency: %luus\n",
diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index d55a5e0466e5..9d932e985d96 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -5339,6 +5339,8 @@ static void virtual_context_destroy(struct kref *kref)
 	GEM_BUG_ON(ve->request);
 	GEM_BUG_ON(ve->context.inflight);
 
+	intel_engine_fini_breadcrumbs(&ve->base);
+
 	for (n = 0; n < ve->num_siblings; n++) {
 		struct intel_engine_cs *sibling = ve->siblings[n];
 		struct rb_node *node = &ve->nodes[sibling->id].rb;
-- 
2.20.1

