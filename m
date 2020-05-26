Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 190031D8487
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732888AbgERSL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:11:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:49856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732718AbgERSEB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:04:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEFC3207D3;
        Mon, 18 May 2020 18:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825040;
        bh=TxFjLSAL5zDasn9oik92yX0UwttPZd52H+DlXDaqvRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kPWpWebnmUItS2DFmIcUjMO3C3nOd2Fdp2UON4pT5Hs+qonm1wLVBPd0RtHTO5GCb
         EyM6HHzkA8LUtxFITwpfkvGhfv0CnVhZrGmYeBTS5fRqaF8SmG416uaFJ1LLfILslv
         3Hw0Clh9LZl86L/i6RB2cIFXvmJ4cYfDtiUrSYHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 105/194] drm/i915: Mark concurrent submissions with a weak-dependency
Date:   Mon, 18 May 2020 19:36:35 +0200
Message-Id: <20200518173540.624943414@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

[ Upstream commit a9d094dcf7845af85f82adcad9f793e51e4d14c8 ]

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
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_lrc.c         | 3 +++
 drivers/gpu/drm/i915/i915_request.c         | 8 ++++++--
 drivers/gpu/drm/i915/i915_scheduler.c       | 6 +++---
 drivers/gpu/drm/i915/i915_scheduler.h       | 3 ++-
 drivers/gpu/drm/i915/i915_scheduler_types.h | 1 +
 5 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index 5bebda4a2d0b4..637c03ee1a57f 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -1626,6 +1626,9 @@ static void defer_request(struct i915_request *rq, struct list_head * const pl)
 			struct i915_request *w =
 				container_of(p->waiter, typeof(*w), sched);
 
+			if (p->flags & I915_DEPENDENCY_WEAK)
+				continue;
+
 			/* Leave semaphores spinning on the other engines */
 			if (w->engine != rq->engine)
 				continue;
diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
index a18b2a2447066..32ab154db788c 100644
--- a/drivers/gpu/drm/i915/i915_request.c
+++ b/drivers/gpu/drm/i915/i915_request.c
@@ -951,7 +951,9 @@ i915_request_await_request(struct i915_request *to, struct i915_request *from)
 		return 0;
 
 	if (to->engine->schedule) {
-		ret = i915_sched_node_add_dependency(&to->sched, &from->sched);
+		ret = i915_sched_node_add_dependency(&to->sched,
+						     &from->sched,
+						     I915_DEPENDENCY_EXTERNAL);
 		if (ret < 0)
 			return ret;
 	}
@@ -1084,7 +1086,9 @@ __i915_request_await_execution(struct i915_request *to,
 
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
index 34b654b4e58af..8e419d897c2b4 100644
--- a/drivers/gpu/drm/i915/i915_scheduler.c
+++ b/drivers/gpu/drm/i915/i915_scheduler.c
@@ -455,7 +455,8 @@ bool __i915_sched_node_add_dependency(struct i915_sched_node *node,
 }
 
 int i915_sched_node_add_dependency(struct i915_sched_node *node,
-				   struct i915_sched_node *signal)
+				   struct i915_sched_node *signal,
+				   unsigned long flags)
 {
 	struct i915_dependency *dep;
 
@@ -464,8 +465,7 @@ int i915_sched_node_add_dependency(struct i915_sched_node *node,
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
-- 
2.20.1



