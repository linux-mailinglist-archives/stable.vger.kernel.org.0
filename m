Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDBD5F300F
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 14:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbiJCMQu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 08:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiJCMQt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 08:16:49 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 951A037185
        for <stable@vger.kernel.org>; Mon,  3 Oct 2022 05:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664799407; x=1696335407;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R51OAp+f64kQaIBoysffby4cH37ByGJPbCUL8p6RLco=;
  b=NRvqGZ8h9Tf6ku9DY/JQwAmAmNg0ui1gxlHxshX3haxUrzqrKcyxZhUF
   Kanjq6u+H1x8t/BV680hyLLsOZu2T9wH4yihlgve5IxZ5alwoXwPAyPOv
   n/4vWw9qwgiJFDhb16ZIvo8U5lC6R7aXrkshHworCmhZJg3bg5BqtbEdD
   1/BDYee4H/qzSZVmfybpLrWHfp7A51Tr9Yrl5ZkvLUUjBe8vsFhQG8Byl
   O+PeFE1FU8h45Y1mAzmuu3rqC+eBsBaUw2ZV+MtJMi+pMiyp50a5bdo7l
   MwsSrd5c95awitJE6V7uoDrigSvgeeR6N+ckyZpSdPY+ZTcMJmL0zaFE1
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10488"; a="329012889"
X-IronPort-AV: E=Sophos;i="5.93,365,1654585200"; 
   d="scan'208";a="329012889"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2022 05:16:47 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10488"; a="712569369"
X-IronPort-AV: E=Sophos;i="5.93,365,1654585200"; 
   d="scan'208";a="712569369"
Received: from praffert-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.213.196.20])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2022 05:16:45 -0700
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
To:     Intel-gfx@lists.freedesktop.org
Cc:     dri-devel@lists.freedesktop.org,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        John Harrison <John.C.Harrison@Intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] drm/i915/guc: Fix revocation of non-persistent contexts
Date:   Mon,  3 Oct 2022 13:16:30 +0100
Message-Id: <20221003121630.694249-1-tvrtko.ursulin@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220930094716.430937-1-tvrtko.ursulin@linux.intel.com>
References: <20220930094716.430937-1-tvrtko.ursulin@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

Patch which added graceful exit for non-persistent contexts missed the
fact it is not enough to set the exiting flag on a context and let the
backend handle it from there.

GuC backend cannot handle it because it runs independently in the
firmware and driver might not see the requests ever again. Patch also
missed the fact some usages of intel_context_is_banned in the GuC backend
needed replacing with newly introduced intel_context_is_schedulable.

Fix the first issue by calling into backend revoke when we know this is
the last chance to do it. Fix the second issue by replacing
intel_context_is_banned with intel_context_is_schedulable, which should
always be safe since latter is a superset of the former.

v2:
 * Just call ce->ops->revoke unconditionally. (Andrzej)

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Fixes: 45c64ecf97ee ("drm/i915: Improve user experience and driver robustness under SIGINT or similar")
Cc: Andrzej Hajda <andrzej.hajda@intel.com>
Cc: John Harrison <John.C.Harrison@Intel.com>
Cc: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: <stable@vger.kernel.org> # v6.0+
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
---
 drivers/gpu/drm/i915/gem/i915_gem_context.c   |  8 +-----
 drivers/gpu/drm/i915/gt/intel_context.c       |  5 ++--
 drivers/gpu/drm/i915/gt/intel_context.h       |  3 +--
 .../gpu/drm/i915/gt/uc/intel_guc_submission.c | 26 +++++++++----------
 4 files changed, 17 insertions(+), 25 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_context.c b/drivers/gpu/drm/i915/gem/i915_gem_context.c
index 0bcde53c50c6..1e29b1e6d186 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_context.c
@@ -1387,14 +1387,8 @@ kill_engines(struct i915_gem_engines *engines, bool exit, bool persistent)
 	 */
 	for_each_gem_engine(ce, engines, it) {
 		struct intel_engine_cs *engine;
-		bool skip = false;
 
-		if (exit)
-			skip = intel_context_set_exiting(ce);
-		else if (!persistent)
-			skip = intel_context_exit_nonpersistent(ce, NULL);
-
-		if (skip)
+		if ((exit || !persistent) && intel_context_revoke(ce))
 			continue; /* Already marked. */
 
 		/*
diff --git a/drivers/gpu/drm/i915/gt/intel_context.c b/drivers/gpu/drm/i915/gt/intel_context.c
index 654a092ed3d6..e94365b08f1e 100644
--- a/drivers/gpu/drm/i915/gt/intel_context.c
+++ b/drivers/gpu/drm/i915/gt/intel_context.c
@@ -614,13 +614,12 @@ bool intel_context_ban(struct intel_context *ce, struct i915_request *rq)
 	return ret;
 }
 
-bool intel_context_exit_nonpersistent(struct intel_context *ce,
-				      struct i915_request *rq)
+bool intel_context_revoke(struct intel_context *ce)
 {
 	bool ret = intel_context_set_exiting(ce);
 
 	if (ce->ops->revoke)
-		ce->ops->revoke(ce, rq, ce->engine->props.preempt_timeout_ms);
+		ce->ops->revoke(ce, NULL, ce->engine->props.preempt_timeout_ms);
 
 	return ret;
 }
diff --git a/drivers/gpu/drm/i915/gt/intel_context.h b/drivers/gpu/drm/i915/gt/intel_context.h
index 8e2d70630c49..be09fb2e883a 100644
--- a/drivers/gpu/drm/i915/gt/intel_context.h
+++ b/drivers/gpu/drm/i915/gt/intel_context.h
@@ -329,8 +329,7 @@ static inline bool intel_context_set_exiting(struct intel_context *ce)
 	return test_and_set_bit(CONTEXT_EXITING, &ce->flags);
 }
 
-bool intel_context_exit_nonpersistent(struct intel_context *ce,
-				      struct i915_request *rq);
+bool intel_context_revoke(struct intel_context *ce);
 
 static inline bool
 intel_context_force_single_submission(const struct intel_context *ce)
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
index 0ef295a94060..88a4476b8e92 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -685,7 +685,7 @@ static int __guc_add_request(struct intel_guc *guc, struct i915_request *rq)
 	 * Corner case where requests were sitting in the priority list or a
 	 * request resubmitted after the context was banned.
 	 */
-	if (unlikely(intel_context_is_banned(ce))) {
+	if (unlikely(!intel_context_is_schedulable(ce))) {
 		i915_request_put(i915_request_mark_eio(rq));
 		intel_engine_signal_breadcrumbs(ce->engine);
 		return 0;
@@ -871,15 +871,15 @@ static int guc_wq_item_append(struct intel_guc *guc,
 			      struct i915_request *rq)
 {
 	struct intel_context *ce = request_to_scheduling_context(rq);
-	int ret = 0;
+	int ret;
 
-	if (likely(!intel_context_is_banned(ce))) {
-		ret = __guc_wq_item_append(rq);
+	if (unlikely(!intel_context_is_schedulable(ce)))
+		return 0;
 
-		if (unlikely(ret == -EBUSY)) {
-			guc->stalled_request = rq;
-			guc->submission_stall_reason = STALL_MOVE_LRC_TAIL;
-		}
+	ret = __guc_wq_item_append(rq);
+	if (unlikely(ret == -EBUSY)) {
+		guc->stalled_request = rq;
+		guc->submission_stall_reason = STALL_MOVE_LRC_TAIL;
 	}
 
 	return ret;
@@ -898,7 +898,7 @@ static bool multi_lrc_submit(struct i915_request *rq)
 	 * submitting all the requests generated in parallel.
 	 */
 	return test_bit(I915_FENCE_FLAG_SUBMIT_PARALLEL, &rq->fence.flags) ||
-		intel_context_is_banned(ce);
+	       !intel_context_is_schedulable(ce);
 }
 
 static int guc_dequeue_one_context(struct intel_guc *guc)
@@ -967,7 +967,7 @@ static int guc_dequeue_one_context(struct intel_guc *guc)
 		struct intel_context *ce = request_to_scheduling_context(last);
 
 		if (unlikely(!ctx_id_mapped(guc, ce->guc_id.id) &&
-			     !intel_context_is_banned(ce))) {
+			     intel_context_is_schedulable(ce))) {
 			ret = try_context_registration(ce, false);
 			if (unlikely(ret == -EPIPE)) {
 				goto deadlk;
@@ -1577,7 +1577,7 @@ static void guc_reset_state(struct intel_context *ce, u32 head, bool scrub)
 {
 	struct intel_engine_cs *engine = __context_to_physical_engine(ce);
 
-	if (intel_context_is_banned(ce))
+	if (!intel_context_is_schedulable(ce))
 		return;
 
 	GEM_BUG_ON(!intel_context_is_pinned(ce));
@@ -4518,12 +4518,12 @@ static void guc_handle_context_reset(struct intel_guc *guc,
 {
 	trace_intel_context_reset(ce);
 
-	if (likely(!intel_context_is_banned(ce))) {
+	if (likely(intel_context_is_schedulable(ce))) {
 		capture_error_state(guc, ce);
 		guc_context_replay(ce);
 	} else {
 		drm_info(&guc_to_gt(guc)->i915->drm,
-			 "Ignoring context reset notification of banned context 0x%04X on %s",
+			 "Ignoring context reset notification of exiting context 0x%04X on %s",
 			 ce->guc_id.id, ce->engine->name);
 	}
 }
-- 
2.34.1

