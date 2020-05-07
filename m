Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70A811C956E
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 17:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgEGPvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 11:51:15 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:61665 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726616AbgEGPvP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 11:51:15 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 21140761-1500050 
        for multiple; Thu, 07 May 2020 16:51:12 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] drm/i915: Mark concurrent submissions with a weak-dependency
Date:   Thu,  7 May 2020 16:51:09 +0100
Message-Id: <20200507155109.8892-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507152338.7452-1-chris@chris-wilson.co.uk>
References: <20200507152338.7452-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We recorded the dependencies for WAIT_FOR_SUBMIT in order that we could
correctly perform priority inheritance from the parallel branches to the
common trunk. However, for the purpose of timeslicing and reset
handling, the dependency is weak -- as we the pair of requests are
allowed to run in parallel and not in strict succession.

The real significance though is that this allows us to rearrange
groups of WAIT_FOR_SUBMIT linked requests along the single engine, and
so can resolve user level inter-batch scheduling dependencies from user
semaphores.

Fixes: c81471f5e95c ("drm/i915: Copy across scheduler behaviour flags across submit fences")
Testcase: igt/gem_exec_fence/submit
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: <stable@vger.kernel.org> # v5.6+
---
 drivers/gpu/drm/i915/gt/intel_lrc.c         | 3 +++
 drivers/gpu/drm/i915/i915_request.c         | 8 ++++++--
 drivers/gpu/drm/i915/i915_scheduler.c       | 6 +++---
 drivers/gpu/drm/i915/i915_scheduler.h       | 3 ++-
 drivers/gpu/drm/i915/i915_scheduler_types.h | 1 +
 5 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index bbdb0e2a4571..dd0fd4c4cf32 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -1880,6 +1880,9 @@ static void defer_request(struct i915_request *rq, struct list_head * const pl)
 			struct i915_request *w =
 				container_of(p->waiter, typeof(*w), sched);
 
+			if (p->flags & I915_DEPENDENCY_WEAK)
+				continue;
+
 			/* Leave semaphores spinning on the other engines */
 			if (w->engine != rq->engine)
 				continue;
diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
index 4d18f808fda2..3c38d61c90f8 100644
--- a/drivers/gpu/drm/i915/i915_request.c
+++ b/drivers/gpu/drm/i915/i915_request.c
@@ -1040,7 +1040,9 @@ i915_request_await_request(struct i915_request *to, struct i915_request *from)
 	}
 
 	if (to->engine->schedule) {
-		ret = i915_sched_node_add_dependency(&to->sched, &from->sched);
+		ret = i915_sched_node_add_dependency(&to->sched,
+						     &from->sched,
+						     I915_DEPENDENCY_EXTERNAL);
 		if (ret < 0)
 			return ret;
 	}
@@ -1202,7 +1204,9 @@ __i915_request_await_execution(struct i915_request *to,
 
 	/* Couple the dependency tree for PI on this exposed to->fence */
 	if (to->engine->schedule) {
-		err = i915_sched_node_add_dependency(&to->sched, &from->sched);
+		err = i915_sched_node_add_dependency(&to->sched,
+						     &from->sched,
+						     I915_DEPENDENCY_WEAK);
 		if (err < 0)
 			return err;
 	}
diff --git a/drivers/gpu/drm/i915/i915_scheduler.c b/drivers/gpu/drm/i915/i915_scheduler.c
index 37cfcf5b321b..6e2d4190099f 100644
--- a/drivers/gpu/drm/i915/i915_scheduler.c
+++ b/drivers/gpu/drm/i915/i915_scheduler.c
@@ -462,7 +462,8 @@ bool __i915_sched_node_add_dependency(struct i915_sched_node *node,
 }
 
 int i915_sched_node_add_dependency(struct i915_sched_node *node,
-				   struct i915_sched_node *signal)
+				   struct i915_sched_node *signal,
+				   unsigned long flags)
 {
 	struct i915_dependency *dep;
 
@@ -473,8 +474,7 @@ int i915_sched_node_add_dependency(struct i915_sched_node *node,
 	local_bh_disable();
 
 	if (!__i915_sched_node_add_dependency(node, signal, dep,
-					      I915_DEPENDENCY_EXTERNAL |
-					      I915_DEPENDENCY_ALLOC))
+					      flags | I915_DEPENDENCY_ALLOC))
 		i915_dependency_free(dep);
 
 	local_bh_enable(); /* kick submission tasklet */
diff --git a/drivers/gpu/drm/i915/i915_scheduler.h b/drivers/gpu/drm/i915/i915_scheduler.h
index d1dc4efef77b..6f0bf00fc569 100644
--- a/drivers/gpu/drm/i915/i915_scheduler.h
+++ b/drivers/gpu/drm/i915/i915_scheduler.h
@@ -34,7 +34,8 @@ bool __i915_sched_node_add_dependency(struct i915_sched_node *node,
 				      unsigned long flags);
 
 int i915_sched_node_add_dependency(struct i915_sched_node *node,
-				   struct i915_sched_node *signal);
+				   struct i915_sched_node *signal,
+				   unsigned long flags);
 
 void i915_sched_node_fini(struct i915_sched_node *node);
 
diff --git a/drivers/gpu/drm/i915/i915_scheduler_types.h b/drivers/gpu/drm/i915/i915_scheduler_types.h
index d18e70550054..7186875088a0 100644
--- a/drivers/gpu/drm/i915/i915_scheduler_types.h
+++ b/drivers/gpu/drm/i915/i915_scheduler_types.h
@@ -78,6 +78,7 @@ struct i915_dependency {
 	unsigned long flags;
 #define I915_DEPENDENCY_ALLOC		BIT(0)
 #define I915_DEPENDENCY_EXTERNAL	BIT(1)
+#define I915_DEPENDENCY_WEAK		BIT(2)
 };
 
 #endif /* _I915_SCHEDULER_TYPES_H_ */
-- 
2.20.1

