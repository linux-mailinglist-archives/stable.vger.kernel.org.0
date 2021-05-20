Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6179D389EF9
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 09:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhETHgz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 03:36:55 -0400
Received: from mga07.intel.com ([134.134.136.100]:17157 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229534AbhETHgy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 03:36:54 -0400
IronPort-SDR: 0NUkfEJhUQ85UDegfxOe8YC/aeMnIijd2aDul4tq9cqSnd5eUeoJQmn+3MKPesFdIZ93P+nQC5
 NO/HO2lzaB/g==
X-IronPort-AV: E=McAfee;i="6200,9189,9989"; a="265080227"
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="265080227"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2021 00:35:32 -0700
IronPort-SDR: rPkLRbszIc0XjAuyx4Wb4er9vrg5UvqyzlBeQ6CfhgzNVSPQmJyE/LAIAoE4K4FU5W5bSk6gW+
 6Fkz2JQ0tYMQ==
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="543237768"
Received: from nyeong-mobl.gar.corp.intel.com (HELO mwauld-desk1.intel.com) ([10.249.70.38])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2021 00:35:28 -0700
From:   Matthew Auld <matthew.auld@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Chintan M Patel <chintan.m.patel@intel.com>,
        Andi Shyti <andi.shyti@intel.com>, stable@vger.kernel.org
Subject: [PATCH] drm/i915: Use DRIVER_NAME for tracing unattached requests
Date:   Thu, 20 May 2021 08:35:14 +0100
Message-Id: <20210520073514.314893-1-matthew.auld@intel.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

The first tracepoint for a request is trace_dma_fence_init called before
we have associated the request with a device. The tracepoint uses
fence->ops->get_driver_name() as a pretty name, and as we try to report
the device name this oopses as it is then NULL. Support the early
tracepoint by reporting the DRIVER_NAME instead of the actual device
name.

Note that rq->engine remains during the course of request recycling
(SLAB_TYPESAFE_BY_RCU). For the physical engines, the pointer remains
valid, however a virtual engine may be destroyed after the request is
retired. If we process a preempt-to-busy completed request along the
virtual engine, we should make sure we mark the request as no longer
belonging to the virtual engine to remove the dangling pointers from the
tracepoint.

Fixes: 855e39e65cfc ("drm/i915: Initialise basic fence before acquiring seqno")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: Chintan M Patel <chintan.m.patel@intel.com>
Cc: Andi Shyti <andi.shyti@intel.com>
Cc: <stable@vger.kernel.org> # v5.7+
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
---
 .../drm/i915/gt/intel_execlists_submission.c  | 20 ++++++++++++++-----
 drivers/gpu/drm/i915/i915_request.c           |  7 ++++++-
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_execlists_submission.c b/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
index de124870af44..75604e927d34 100644
--- a/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
+++ b/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
@@ -3249,6 +3249,18 @@ static struct list_head *virtual_queue(struct virtual_engine *ve)
 	return &ve->base.execlists.default_priolist.requests;
 }
 
+static void
+virtual_submit_completed(struct virtual_engine *ve, struct i915_request *rq)
+{
+	GEM_BUG_ON(!__i915_request_is_complete(rq));
+	GEM_BUG_ON(rq->engine != &ve->base);
+
+	__i915_request_submit(rq);
+
+	/* Remove the dangling pointer to the stale virtual engine */
+	WRITE_ONCE(rq->engine, ve->siblings[0]);
+}
+
 static void rcu_virtual_context_destroy(struct work_struct *wrk)
 {
 	struct virtual_engine *ve =
@@ -3265,8 +3277,7 @@ static void rcu_virtual_context_destroy(struct work_struct *wrk)
 
 		old = fetch_and_zero(&ve->request);
 		if (old) {
-			GEM_BUG_ON(!__i915_request_is_complete(old));
-			__i915_request_submit(old);
+			virtual_submit_completed(ve, old);
 			i915_request_put(old);
 		}
 
@@ -3538,13 +3549,12 @@ static void virtual_submit_request(struct i915_request *rq)
 
 	/* By the time we resubmit a request, it may be completed */
 	if (__i915_request_is_complete(rq)) {
-		__i915_request_submit(rq);
+		virtual_submit_completed(ve, rq);
 		goto unlock;
 	}
 
 	if (ve->request) { /* background completion from preempt-to-busy */
-		GEM_BUG_ON(!__i915_request_is_complete(ve->request));
-		__i915_request_submit(ve->request);
+		virtual_submit_completed(ve, ve->request);
 		i915_request_put(ve->request);
 	}
 
diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
index 970d8f4986bb..aa124adb1051 100644
--- a/drivers/gpu/drm/i915/i915_request.c
+++ b/drivers/gpu/drm/i915/i915_request.c
@@ -61,7 +61,12 @@ static struct i915_global_request {
 
 static const char *i915_fence_get_driver_name(struct dma_fence *fence)
 {
-	return dev_name(to_request(fence)->engine->i915->drm.dev);
+	struct i915_request *rq = to_request(fence);
+
+	if (unlikely(!rq->engine)) /* not yet attached to any device */
+		return DRIVER_NAME;
+
+	return dev_name(rq->engine->i915->drm.dev);
 }
 
 static const char *i915_fence_get_timeline_name(struct dma_fence *fence)
-- 
2.26.3

