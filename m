Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C094604183
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbiJSKp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233050AbiJSKo2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:44:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E79159D63;
        Wed, 19 Oct 2022 03:21:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D65E1B822E2;
        Wed, 19 Oct 2022 08:46:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36690C433C1;
        Wed, 19 Oct 2022 08:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169177;
        bh=Ax5KO/F8Qs3odERen+hCIo5ZvjrN+avr3X0K3Ob5bsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eU03hgMAWKaHDxsq2kDroILH0QyMy8vrruvoyh3mjNZOiIy5ZSSfCYEI3Wb2c3Z0G
         8FUJJPLuDRyfB3MiwEd7vCQl6tH57ZZVHnOLOzMG2BOQv1+BMVoumTWJXf1605JJ2R
         J2JTnoj598IsyD0m1+rRTqEhraU/rkubVXz191ME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        John Harrison <John.C.Harrison@Intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Subject: [PATCH 6.0 183/862] drm/i915/guc: Fix revocation of non-persistent contexts
Date:   Wed, 19 Oct 2022 10:24:30 +0200
Message-Id: <20221019083258.048982114@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

commit 7023472834a39341460dae5c9b506c76c5940cad upstream.

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
(cherry picked from commit 0add082cebac8555ee3972ba768ae5c01db7a498)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_context.c       |    8 ------
 drivers/gpu/drm/i915/gt/intel_context.c           |    5 +---
 drivers/gpu/drm/i915/gt/intel_context.h           |    3 --
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c |   26 +++++++++++-----------
 4 files changed, 17 insertions(+), 25 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_context.c
@@ -1387,14 +1387,8 @@ kill_engines(struct i915_gem_engines *en
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
--- a/drivers/gpu/drm/i915/gt/intel_context.c
+++ b/drivers/gpu/drm/i915/gt/intel_context.c
@@ -614,13 +614,12 @@ bool intel_context_ban(struct intel_cont
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
--- a/drivers/gpu/drm/i915/gt/intel_context.h
+++ b/drivers/gpu/drm/i915/gt/intel_context.h
@@ -329,8 +329,7 @@ static inline bool intel_context_set_exi
 	return test_and_set_bit(CONTEXT_EXITING, &ce->flags);
 }
 
-bool intel_context_exit_nonpersistent(struct intel_context *ce,
-				      struct i915_request *rq);
+bool intel_context_revoke(struct intel_context *ce);
 
 static inline bool
 intel_context_force_single_submission(const struct intel_context *ce)
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -684,7 +684,7 @@ static int __guc_add_request(struct inte
 	 * Corner case where requests were sitting in the priority list or a
 	 * request resubmitted after the context was banned.
 	 */
-	if (unlikely(intel_context_is_banned(ce))) {
+	if (unlikely(!intel_context_is_schedulable(ce))) {
 		i915_request_put(i915_request_mark_eio(rq));
 		intel_engine_signal_breadcrumbs(ce->engine);
 		return 0;
@@ -870,15 +870,15 @@ static int guc_wq_item_append(struct int
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
@@ -897,7 +897,7 @@ static bool multi_lrc_submit(struct i915
 	 * submitting all the requests generated in parallel.
 	 */
 	return test_bit(I915_FENCE_FLAG_SUBMIT_PARALLEL, &rq->fence.flags) ||
-		intel_context_is_banned(ce);
+	       !intel_context_is_schedulable(ce);
 }
 
 static int guc_dequeue_one_context(struct intel_guc *guc)
@@ -966,7 +966,7 @@ register_context:
 		struct intel_context *ce = request_to_scheduling_context(last);
 
 		if (unlikely(!ctx_id_mapped(guc, ce->guc_id.id) &&
-			     !intel_context_is_banned(ce))) {
+			     intel_context_is_schedulable(ce))) {
 			ret = try_context_registration(ce, false);
 			if (unlikely(ret == -EPIPE)) {
 				goto deadlk;
@@ -1576,7 +1576,7 @@ static void guc_reset_state(struct intel
 {
 	struct intel_engine_cs *engine = __context_to_physical_engine(ce);
 
-	if (intel_context_is_banned(ce))
+	if (!intel_context_is_schedulable(ce))
 		return;
 
 	GEM_BUG_ON(!intel_context_is_pinned(ce));
@@ -4434,12 +4434,12 @@ static void guc_handle_context_reset(str
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


