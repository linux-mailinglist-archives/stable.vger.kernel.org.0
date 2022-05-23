Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D399531CD0
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240570AbiEWRef (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241099AbiEWRdI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:33:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0EB66B665;
        Mon, 23 May 2022 10:27:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01313608C0;
        Mon, 23 May 2022 17:27:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07726C385A9;
        Mon, 23 May 2022 17:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326860;
        bh=ijzJ8gTCI2tpxHb0d4Z/XJHCnUqC/CuubuZHAu/u0VE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2IQCfR5wsgP4f/M3/xqDOwYxSdhMNgZfy9tk23mZ9h4/tCXMT/WCy6AtRSxcJ7abJ
         2ndKgSR538JbhLUB71wk0xrGaNs+lr4n3HUTQbA6YcozRYDq9xCFYVt4xaXAprFkA+
         VWvAHBC5MXOYEPXuuovS9jvqGpL7q+t7ZQuGFn5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
        Alan Previn <alan.previn.teres.alexis@intel.com>,
        John Harrison <John.C.Harrison@Intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 081/158] i915/guc/reset: Make __guc_reset_context aware of guilty engines
Date:   Mon, 23 May 2022 19:03:58 +0200
Message-Id: <20220523165844.491361523@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>

[ Upstream commit 89e96d822bd51f7afe2d3e95a34099480b5c3d55 ]

There are 2 ways an engine can get reset in i915 and the method of reset
affects how KMD labels a context as guilty/innocent.

(1) GuC initiated engine-reset: GuC resets a hung engine and notifies
KMD. The context that hung on the engine is marked guilty and all other
contexts are innocent. The innocent contexts are resubmitted.

(2) GT based reset: When an engine heartbeat fails to tick, KMD
initiates a gt/chip reset. All active contexts are marked as guilty and
discarded.

In order to correctly mark the contexts as guilty/innocent, pass a mask
of engines that were reset to __guc_reset_context.

Fixes: eb5e7da736f3 ("drm/i915/guc: Reset implementation for new GuC interface")
Signed-off-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Reviewed-by: Alan Previn <alan.previn.teres.alexis@intel.com>
Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220426003045.3929439-1-umesh.nerlige.ramappa@intel.com
(cherry picked from commit 303760aa914b7f5ac9602dbb4b471a2ad52eeb3e)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_reset.c            |  2 +-
 drivers/gpu/drm/i915/gt/uc/intel_guc.h           |  2 +-
 .../gpu/drm/i915/gt/uc/intel_guc_submission.c    | 16 ++++++++--------
 drivers/gpu/drm/i915/gt/uc/intel_uc.c            |  2 +-
 drivers/gpu/drm/i915/gt/uc/intel_uc.h            |  2 +-
 5 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_reset.c b/drivers/gpu/drm/i915/gt/intel_reset.c
index 7be0002d9d70..f577582ddd9f 100644
--- a/drivers/gpu/drm/i915/gt/intel_reset.c
+++ b/drivers/gpu/drm/i915/gt/intel_reset.c
@@ -791,7 +791,7 @@ static int gt_reset(struct intel_gt *gt, intel_engine_mask_t stalled_mask)
 		__intel_engine_reset(engine, stalled_mask & engine->mask);
 	local_bh_enable();
 
-	intel_uc_reset(&gt->uc, true);
+	intel_uc_reset(&gt->uc, ALL_ENGINES);
 
 	intel_ggtt_restore_fences(gt->ggtt);
 
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc.h b/drivers/gpu/drm/i915/gt/uc/intel_guc.h
index 3aabe164c329..e1fb8e1da128 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc.h
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc.h
@@ -417,7 +417,7 @@ int intel_guc_global_policies_update(struct intel_guc *guc);
 void intel_guc_context_ban(struct intel_context *ce, struct i915_request *rq);
 
 void intel_guc_submission_reset_prepare(struct intel_guc *guc);
-void intel_guc_submission_reset(struct intel_guc *guc, bool stalled);
+void intel_guc_submission_reset(struct intel_guc *guc, intel_engine_mask_t stalled);
 void intel_guc_submission_reset_finish(struct intel_guc *guc);
 void intel_guc_submission_cancel_requests(struct intel_guc *guc);
 
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
index 154ad726e266..1e51a365833b 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -1603,9 +1603,9 @@ __unwind_incomplete_requests(struct intel_context *ce)
 	spin_unlock_irqrestore(&sched_engine->lock, flags);
 }
 
-static void __guc_reset_context(struct intel_context *ce, bool stalled)
+static void __guc_reset_context(struct intel_context *ce, intel_engine_mask_t stalled)
 {
-	bool local_stalled;
+	bool guilty;
 	struct i915_request *rq;
 	unsigned long flags;
 	u32 head;
@@ -1647,7 +1647,7 @@ static void __guc_reset_context(struct intel_context *ce, bool stalled)
 		if (!intel_context_is_pinned(ce))
 			goto next_context;
 
-		local_stalled = false;
+		guilty = false;
 		rq = intel_context_find_active_request(ce);
 		if (!rq) {
 			head = ce->ring->tail;
@@ -1655,14 +1655,14 @@ static void __guc_reset_context(struct intel_context *ce, bool stalled)
 		}
 
 		if (i915_request_started(rq))
-			local_stalled = true;
+			guilty = stalled & ce->engine->mask;
 
 		GEM_BUG_ON(i915_active_is_idle(&ce->active));
 		head = intel_ring_wrap(ce->ring, rq->head);
 
-		__i915_request_reset(rq, local_stalled && stalled);
+		__i915_request_reset(rq, guilty);
 out_replay:
-		guc_reset_state(ce, head, local_stalled && stalled);
+		guc_reset_state(ce, head, guilty);
 next_context:
 		if (i != number_children)
 			ce = list_next_entry(ce, parallel.child_link);
@@ -1673,7 +1673,7 @@ static void __guc_reset_context(struct intel_context *ce, bool stalled)
 	intel_context_put(parent);
 }
 
-void intel_guc_submission_reset(struct intel_guc *guc, bool stalled)
+void intel_guc_submission_reset(struct intel_guc *guc, intel_engine_mask_t stalled)
 {
 	struct intel_context *ce;
 	unsigned long index;
@@ -4042,7 +4042,7 @@ static void guc_context_replay(struct intel_context *ce)
 {
 	struct i915_sched_engine *sched_engine = ce->engine->sched_engine;
 
-	__guc_reset_context(ce, true);
+	__guc_reset_context(ce, ce->engine->mask);
 	tasklet_hi_schedule(&sched_engine->tasklet);
 }
 
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_uc.c b/drivers/gpu/drm/i915/gt/uc/intel_uc.c
index 09ed29df67bc..cbfb5a01cc1d 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_uc.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_uc.c
@@ -592,7 +592,7 @@ void intel_uc_reset_prepare(struct intel_uc *uc)
 	__uc_sanitize(uc);
 }
 
-void intel_uc_reset(struct intel_uc *uc, bool stalled)
+void intel_uc_reset(struct intel_uc *uc, intel_engine_mask_t stalled)
 {
 	struct intel_guc *guc = &uc->guc;
 
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_uc.h b/drivers/gpu/drm/i915/gt/uc/intel_uc.h
index 866b462821c0..a8f38c2c60e2 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_uc.h
+++ b/drivers/gpu/drm/i915/gt/uc/intel_uc.h
@@ -42,7 +42,7 @@ void intel_uc_driver_late_release(struct intel_uc *uc);
 void intel_uc_driver_remove(struct intel_uc *uc);
 void intel_uc_init_mmio(struct intel_uc *uc);
 void intel_uc_reset_prepare(struct intel_uc *uc);
-void intel_uc_reset(struct intel_uc *uc, bool stalled);
+void intel_uc_reset(struct intel_uc *uc, intel_engine_mask_t stalled);
 void intel_uc_reset_finish(struct intel_uc *uc);
 void intel_uc_cancel_requests(struct intel_uc *uc);
 void intel_uc_suspend(struct intel_uc *uc);
-- 
2.35.1



