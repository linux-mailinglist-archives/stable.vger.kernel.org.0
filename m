Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0545868D7A9
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbjBGNCC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:02:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232108AbjBGNBt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:01:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3BF639BA0
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:01:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 668F261383
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:01:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC11C433D2;
        Tue,  7 Feb 2023 13:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774871;
        bh=fxDtAQu9A3N83ncA9h2d/+S1sl7i0pA+Nf1QSAQkRFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fUZQIIiE/UJ+rpLw38Lj64If5/NgAvnYCaqTIocA/P201dYTFz08bWeQiEXUM8cxc
         oke3ZtrtkxKd2CHWQVAyR7P4cOJe/sDShH17/6oigsx2otzqfnU4Tf5XRYYimvt5g3
         i77phSdEkMrxgCjhQXYPxSDiE4u0lszSkLyUMsBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, John Harrison <John.C.Harrison@Intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
        Michael Cheng <michael.cheng@intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Bruce Chang <yu.bruce.chang@intel.com>,
        Alan Previn <alan.previn.teres.alexis@intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 062/208] drm/i915: Fix up locking around dumping requests lists
Date:   Tue,  7 Feb 2023 13:55:16 +0100
Message-Id: <20230207125637.099961207@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Harrison <John.C.Harrison@Intel.com>

[ Upstream commit 5bc4b43d5c6c9692ddc7b96116650cdf9406f3da ]

The debugfs dump of requests was confused about what state requires
the execlist lock versus the GuC lock. There was also a bunch of
duplicated messy code between it and the error capture code.

So refactor the hung request search into a re-usable function. And
reduce the span of the execlist state lock to only the execlist
specific code paths. In order to do that, also move the report of hold
count (which is an execlist only concept) from the top level dump
function to the lower level execlist specific function. Also, move the
execlist specific code into the execlist source file.

v2: Rename some functions and move to more appropriate files (Daniele).
v3: Rename new execlist dump function (Daniele)

Fixes: dc0dad365c5e ("drm/i915/guc: Fix for error capture after full GPU reset with GuC")
Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Acked-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Cc: Michael Cheng <michael.cheng@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Bruce Chang <yu.bruce.chang@intel.com>
Cc: Alan Previn <alan.previn.teres.alexis@intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230127002842.3169194-4-John.C.Harrison@Intel.com
(cherry picked from commit a4be3dca53172d9d2091e4b474fb795c81ed3d6c)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_engine.h        |  4 +-
 drivers/gpu/drm/i915/gt/intel_engine_cs.c     | 74 +++++++++----------
 .../drm/i915/gt/intel_execlists_submission.c  | 27 +++++++
 .../drm/i915/gt/intel_execlists_submission.h  |  4 +
 drivers/gpu/drm/i915/i915_gpu_error.c         | 26 +------
 5 files changed, 73 insertions(+), 62 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_engine.h b/drivers/gpu/drm/i915/gt/intel_engine.h
index cbc8b857d5f7..7a4504ea35c3 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine.h
+++ b/drivers/gpu/drm/i915/gt/intel_engine.h
@@ -248,8 +248,8 @@ void intel_engine_dump_active_requests(struct list_head *requests,
 ktime_t intel_engine_get_busy_time(struct intel_engine_cs *engine,
 				   ktime_t *now);
 
-struct i915_request *
-intel_engine_execlist_find_hung_request(struct intel_engine_cs *engine);
+void intel_engine_get_hung_entity(struct intel_engine_cs *engine,
+				  struct intel_context **ce, struct i915_request **rq);
 
 u32 intel_engine_context_size(struct intel_gt *gt, u8 class);
 struct intel_context *
diff --git a/drivers/gpu/drm/i915/gt/intel_engine_cs.c b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
index 4327c6d91ce9..b458547e1fc6 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_cs.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
@@ -2078,17 +2078,6 @@ static void print_request_ring(struct drm_printer *m, struct i915_request *rq)
 	}
 }
 
-static unsigned long list_count(struct list_head *list)
-{
-	struct list_head *pos;
-	unsigned long count = 0;
-
-	list_for_each(pos, list)
-		count++;
-
-	return count;
-}
-
 static unsigned long read_ul(void *p, size_t x)
 {
 	return *(unsigned long *)(p + x);
@@ -2180,11 +2169,11 @@ void intel_engine_dump_active_requests(struct list_head *requests,
 	}
 }
 
-static void engine_dump_active_requests(struct intel_engine_cs *engine, struct drm_printer *m)
+static void engine_dump_active_requests(struct intel_engine_cs *engine,
+					struct drm_printer *m)
 {
+	struct intel_context *hung_ce = NULL;
 	struct i915_request *hung_rq = NULL;
-	struct intel_context *ce;
-	bool guc;
 
 	/*
 	 * No need for an engine->irq_seqno_barrier() before the seqno reads.
@@ -2193,29 +2182,20 @@ static void engine_dump_active_requests(struct intel_engine_cs *engine, struct d
 	 * But the intention here is just to report an instantaneous snapshot
 	 * so that's fine.
 	 */
-	lockdep_assert_held(&engine->sched_engine->lock);
+	intel_engine_get_hung_entity(engine, &hung_ce, &hung_rq);
 
 	drm_printf(m, "\tRequests:\n");
 
-	guc = intel_uc_uses_guc_submission(&engine->gt->uc);
-	if (guc) {
-		ce = intel_engine_get_hung_context(engine);
-		if (ce)
-			hung_rq = intel_context_get_active_request(ce);
-	} else {
-		hung_rq = intel_engine_execlist_find_hung_request(engine);
-		if (hung_rq)
-			hung_rq = i915_request_get_rcu(hung_rq);
-	}
-
 	if (hung_rq)
 		engine_dump_request(hung_rq, m, "\t\thung");
+	else if (hung_ce)
+		drm_printf(m, "\t\tGot hung ce but no hung rq!\n");
 
-	if (guc)
+	if (intel_uc_uses_guc_submission(&engine->gt->uc))
 		intel_guc_dump_active_requests(engine, hung_rq, m);
 	else
-		intel_engine_dump_active_requests(&engine->sched_engine->requests,
-						  hung_rq, m);
+		intel_execlists_dump_active_requests(engine, hung_rq, m);
+
 	if (hung_rq)
 		i915_request_put(hung_rq);
 }
@@ -2227,7 +2207,6 @@ void intel_engine_dump(struct intel_engine_cs *engine,
 	struct i915_gpu_error * const error = &engine->i915->gpu_error;
 	struct i915_request *rq;
 	intel_wakeref_t wakeref;
-	unsigned long flags;
 	ktime_t dummy;
 
 	if (header) {
@@ -2264,13 +2243,8 @@ void intel_engine_dump(struct intel_engine_cs *engine,
 		   i915_reset_count(error));
 	print_properties(engine, m);
 
-	spin_lock_irqsave(&engine->sched_engine->lock, flags);
 	engine_dump_active_requests(engine, m);
 
-	drm_printf(m, "\tOn hold?: %lu\n",
-		   list_count(&engine->sched_engine->hold));
-	spin_unlock_irqrestore(&engine->sched_engine->lock, flags);
-
 	drm_printf(m, "\tMMIO base:  0x%08x\n", engine->mmio_base);
 	wakeref = intel_runtime_pm_get_if_in_use(engine->uncore->rpm);
 	if (wakeref) {
@@ -2316,8 +2290,7 @@ intel_engine_create_virtual(struct intel_engine_cs **siblings,
 	return siblings[0]->cops->create_virtual(siblings, count, flags);
 }
 
-struct i915_request *
-intel_engine_execlist_find_hung_request(struct intel_engine_cs *engine)
+static struct i915_request *engine_execlist_find_hung_request(struct intel_engine_cs *engine)
 {
 	struct i915_request *request, *active = NULL;
 
@@ -2369,6 +2342,33 @@ intel_engine_execlist_find_hung_request(struct intel_engine_cs *engine)
 	return active;
 }
 
+void intel_engine_get_hung_entity(struct intel_engine_cs *engine,
+				  struct intel_context **ce, struct i915_request **rq)
+{
+	unsigned long flags;
+
+	*ce = intel_engine_get_hung_context(engine);
+	if (*ce) {
+		intel_engine_clear_hung_context(engine);
+
+		*rq = intel_context_get_active_request(*ce);
+		return;
+	}
+
+	/*
+	 * Getting here with GuC enabled means it is a forced error capture
+	 * with no actual hang. So, no need to attempt the execlist search.
+	 */
+	if (intel_uc_uses_guc_submission(&engine->gt->uc))
+		return;
+
+	spin_lock_irqsave(&engine->sched_engine->lock, flags);
+	*rq = engine_execlist_find_hung_request(engine);
+	if (*rq)
+		*rq = i915_request_get_rcu(*rq);
+	spin_unlock_irqrestore(&engine->sched_engine->lock, flags);
+}
+
 void xehp_enable_ccs_engines(struct intel_engine_cs *engine)
 {
 	/*
diff --git a/drivers/gpu/drm/i915/gt/intel_execlists_submission.c b/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
index c718e6dc40b5..bfd1ffc71a48 100644
--- a/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
+++ b/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
@@ -4144,6 +4144,33 @@ void intel_execlists_show_requests(struct intel_engine_cs *engine,
 	spin_unlock_irqrestore(&sched_engine->lock, flags);
 }
 
+static unsigned long list_count(struct list_head *list)
+{
+	struct list_head *pos;
+	unsigned long count = 0;
+
+	list_for_each(pos, list)
+		count++;
+
+	return count;
+}
+
+void intel_execlists_dump_active_requests(struct intel_engine_cs *engine,
+					  struct i915_request *hung_rq,
+					  struct drm_printer *m)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&engine->sched_engine->lock, flags);
+
+	intel_engine_dump_active_requests(&engine->sched_engine->requests, hung_rq, m);
+
+	drm_printf(m, "\tOn hold?: %lu\n",
+		   list_count(&engine->sched_engine->hold));
+
+	spin_unlock_irqrestore(&engine->sched_engine->lock, flags);
+}
+
 #if IS_ENABLED(CONFIG_DRM_I915_SELFTEST)
 #include "selftest_execlists.c"
 #endif
diff --git a/drivers/gpu/drm/i915/gt/intel_execlists_submission.h b/drivers/gpu/drm/i915/gt/intel_execlists_submission.h
index a1aa92c983a5..d2c7d45ea062 100644
--- a/drivers/gpu/drm/i915/gt/intel_execlists_submission.h
+++ b/drivers/gpu/drm/i915/gt/intel_execlists_submission.h
@@ -32,6 +32,10 @@ void intel_execlists_show_requests(struct intel_engine_cs *engine,
 							int indent),
 				   unsigned int max);
 
+void intel_execlists_dump_active_requests(struct intel_engine_cs *engine,
+					  struct i915_request *hung_rq,
+					  struct drm_printer *m);
+
 bool
 intel_engine_in_execlists_submission_mode(const struct intel_engine_cs *engine);
 
diff --git a/drivers/gpu/drm/i915/i915_gpu_error.c b/drivers/gpu/drm/i915/i915_gpu_error.c
index a8ee4cd2ff16..847b9e6af1a1 100644
--- a/drivers/gpu/drm/i915/i915_gpu_error.c
+++ b/drivers/gpu/drm/i915/i915_gpu_error.c
@@ -1592,35 +1592,15 @@ capture_engine(struct intel_engine_cs *engine,
 {
 	struct intel_engine_capture_vma *capture = NULL;
 	struct intel_engine_coredump *ee;
-	struct intel_context *ce;
+	struct intel_context *ce = NULL;
 	struct i915_request *rq = NULL;
-	unsigned long flags;
 
 	ee = intel_engine_coredump_alloc(engine, ALLOW_FAIL, dump_flags);
 	if (!ee)
 		return NULL;
 
-	ce = intel_engine_get_hung_context(engine);
-	if (ce) {
-		intel_engine_clear_hung_context(engine);
-		rq = intel_context_get_active_request(ce);
-		if (!rq || !i915_request_started(rq))
-			goto no_request_capture;
-	} else {
-		/*
-		 * Getting here with GuC enabled means it is a forced error capture
-		 * with no actual hang. So, no need to attempt the execlist search.
-		 */
-		if (!intel_uc_uses_guc_submission(&engine->gt->uc)) {
-			spin_lock_irqsave(&engine->sched_engine->lock, flags);
-			rq = intel_engine_execlist_find_hung_request(engine);
-			if (rq)
-				rq = i915_request_get_rcu(rq);
-			spin_unlock_irqrestore(&engine->sched_engine->lock,
-					       flags);
-		}
-	}
-	if (!rq)
+	intel_engine_get_hung_entity(engine, &ce, &rq);
+	if (!rq || !i915_request_started(rq))
 		goto no_request_capture;
 
 	capture = intel_engine_coredump_add_request(ee, rq, ATOMIC_MAYFAIL);
-- 
2.39.0



