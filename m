Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D28661F4056
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 18:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731030AbgFIQMk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 12:12:40 -0400
Received: from mga12.intel.com ([192.55.52.136]:24074 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728888AbgFIQMk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 12:12:40 -0400
IronPort-SDR: 0qhCwY1EVF8XVy+P9NkWokQIJtgPWtgPWjyrQwC/ea2UqHvqr5x4kXsCUlmFKFn8QZ/oSi2jh5
 q3UsqAbskTaQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2020 09:12:39 -0700
IronPort-SDR: ddb7h0265o+Y+3268qanSqCRHLr5tO1RkJS0WOLDmYby4Szeff/S79c1upG0lO/YWG9omQXPhI
 0i/9K4kkOkCg==
X-IronPort-AV: E=Sophos;i="5.73,492,1583222400"; 
   d="scan'208";a="306307079"
Received: from gem-build.fi.intel.com (HELO localhost) ([10.237.72.180])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2020 09:12:38 -0700
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     gfx-internal-devel@eclists.intel.com
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 076/185] drm/i915: Mark concurrent submissions with a weak-dependency
Date:   Tue,  9 Jun 2020 16:05:41 +0000
Message-Id: <20200609160731.287073-77-chris@chris-wilson.co.uk>
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
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200507155109.8892-1-chris@chris-wilson.co.uk
(cherry picked from commit 6b6cd2ebd8d071e55998e32b648bb8081f7f02bb)
---
 drivers/gpu/drm/i915/gt/intel_lrc.c         | 3 +++
 drivers/gpu/drm/i915/i915_request.c         | 8 ++++++--
 drivers/gpu/drm/i915/i915_scheduler.c       | 6 +++---
 drivers/gpu/drm/i915/i915_scheduler.h       | 3 ++-
 drivers/gpu/drm/i915/i915_scheduler_types.h | 1 +
 5 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index 2237d03545440..e57b827b00b1e 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -1902,6 +1902,9 @@ static void defer_request(struct i915_request *rq, struct list_head * const pl)
 			struct i915_request *w =
 				container_of(p->waiter, typeof(*w), sched);
 
+			if (p->flags & I915_DEPENDENCY_WEAK)
+				continue;
+
 			/* Leave semaphores spinning on the other engines */
 			if (w->engine != rq->engine)
 				continue;
diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
index ee406fa6774ad..ed1af57d1db18 100644
--- a/drivers/gpu/drm/i915/i915_request.c
+++ b/drivers/gpu/drm/i915/i915_request.c
@@ -1048,7 +1048,9 @@ i915_request_await_request(struct i915_request *to, struct i915_request *from)
 		return 0;
 
 	if (to->engine->schedule) {
-		ret = i915_sched_node_add_dependency(&to->sched, &from->sched);
+		ret = i915_sched_node_add_dependency(&to->sched,
+						     &from->sched,
+						     I915_DEPENDENCY_EXTERNAL);
 		if (ret < 0)
 			return ret;
 	}
@@ -1179,7 +1181,9 @@ __i915_request_await_execution(struct i915_request *to,
 
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
index e99423e548c99..09d6d4538ff38 100644
--- a/drivers/gpu/drm/i915/i915_scheduler.c
+++ b/drivers/gpu/drm/i915/i915_scheduler.c
@@ -463,7 +463,8 @@ bool __i915_sched_node_add_dependency(struct i915_sched_node *node,
 }
 
 int i915_sched_node_add_dependency(struct i915_sched_node *node,
-				   struct i915_sched_node *signal)
+				   struct i915_sched_node *signal,
+				   unsigned long flags)
 {
 	struct i915_dependency *dep;
 
@@ -472,8 +473,7 @@ int i915_sched_node_add_dependency(struct i915_sched_node *node,
 		return -ENOMEM;
 
 	if (!__i915_sched_node_add_dependency(node, signal, dep,
-					      I915_DEPENDENCY_EXTERNAL |
-					      I915_DEPENDENCY_ALLOC))
+					      flags | I915_DEPENDENCY_ALLOC))
 		i915_dependency_free(dep);
 
 	return 0;
diff --git a/drivers/gpu/drm/i915/i915_scheduler.h b/drivers/gpu/drm/i915/i915_scheduler.h
index d1dc4efef77b5..6f0bf00fc5690 100644
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
index d18e705500542..7186875088a0a 100644
--- a/drivers/gpu/drm/i915/i915_scheduler_types.h
+++ b/drivers/gpu/drm/i915/i915_scheduler_types.h
@@ -78,6 +78,7 @@ struct i915_dependency {
 	unsigned long flags;
 #define I915_DEPENDENCY_ALLOC		BIT(0)
 #define I915_DEPENDENCY_EXTERNAL	BIT(1)
+#define I915_DEPENDENCY_WEAK		BIT(2)
 };
 
 #endif /* _I915_SCHEDULER_TYPES_H_ */
---------------------------------------------------------------------
Intel Corporation (UK) Limited
Registered No. 1134945 (England)
Registered Office: Pipers Way, Swindon SN3 1RJ
VAT No: 860 2173 47

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

