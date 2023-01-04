Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB9F965D64B
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239657AbjADOnt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:43:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239672AbjADOne (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:43:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE8FEB2A
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:43:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B00C61746
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:43:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6AAC433F1;
        Wed,  4 Jan 2023 14:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672843412;
        bh=ZTZPhGLZIoWlEp6kAMOwQdELI6JUDN45BhbTIjKnPQQ=;
        h=Subject:To:Cc:From:Date:From;
        b=EfJSn2aypwaaTdUKng3AYuWLLnsKRgk2PSWALFM9JQIe6DCoVdZXP430LYXvFhtG8
         TTOf15Sa0UuvuUK7Sbx2BXtHk2PlJPzyUWSRTNHX4iHR6Ds2sttXu/3kE1MdwJHx6G
         TAzEzH0RmgYbUS+T6uwiqPxKLUU/AdPK/R4sRm1U=
Subject: FAILED: patch "[PATCH] drm/i915/guc: Fix revocation of non-persistent contexts" failed to apply to 6.0-stable tree
To:     tvrtko.ursulin@intel.com, John.C.Harrison@Intel.com,
        andrzej.hajda@intel.com, daniele.ceraolospurio@intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:43:19 +0100
Message-ID: <167284339916018@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

0add082cebac ("drm/i915/guc: Fix revocation of non-persistent contexts")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0add082cebac8555ee3972ba768ae5c01db7a498 Mon Sep 17 00:00:00 2001
From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Date: Mon, 3 Oct 2022 13:16:30 +0100
Subject: [PATCH] drm/i915/guc: Fix revocation of non-persistent contexts

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
Acked-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221003121630.694249-1-tvrtko.ursulin@linux.intel.com

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
index d81f68fef9a8..693b07a97789 100644
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

