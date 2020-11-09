Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6C12ABB3D
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733100AbgKIN0J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:26:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:44058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387538AbgKINQ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:16:56 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95E14206D8;
        Mon,  9 Nov 2020 13:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927815;
        bh=qbk1WoHgHgHlsw/kxP8eAvW70JAzh828PHxMDc3Np2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lFr6XmsrMFK5NqstYQQKsMcEt9+QTsDmHgFjmi4WIPkiCA+b3iprpGrBN66NMzdrT
         mBTOM6rYw/wuJlNhda2HTMqhzful0tcKfH1GTNfOCu/2w36F0CQtMFNCFApHGl4raP
         dIDUQ5XZXRJMW7+urtOYelFpi0r4fvaHm5sCaR0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.9 005/133] drm/i915/gem: Always test execution status on closing the context
Date:   Mon,  9 Nov 2020 13:54:27 +0100
Message-Id: <20201109125030.973852196@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 651dabe27f9638f569f6a794f9d3cc1889cd315e upstream.

Verify that if a context is active at the time it is closed, that it is
either persistent and preemptible (with hangcheck running) or it shall
be removed from execution.

Fixes: 9a40bddd47ca ("drm/i915/gt: Expose heartbeat interval via sysfs")
Testcase: igt/gem_ctx_persistence/heartbeat-close
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.7+
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Acked-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200928221510.26044-3-chris@chris-wilson.co.uk
(cherry picked from commit d3bb2f9b5ee66d5e000293edd6b6575e59d11db9)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gem/i915_gem_context.c |   48 +++++-----------------------
 1 file changed, 10 insertions(+), 38 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_context.c
@@ -390,24 +390,6 @@ __context_engines_static(const struct i9
 	return rcu_dereference_protected(ctx->engines, true);
 }
 
-static bool __reset_engine(struct intel_engine_cs *engine)
-{
-	struct intel_gt *gt = engine->gt;
-	bool success = false;
-
-	if (!intel_has_reset_engine(gt))
-		return false;
-
-	if (!test_and_set_bit(I915_RESET_ENGINE + engine->id,
-			      &gt->reset.flags)) {
-		success = intel_engine_reset(engine, NULL) == 0;
-		clear_and_wake_up_bit(I915_RESET_ENGINE + engine->id,
-				      &gt->reset.flags);
-	}
-
-	return success;
-}
-
 static void __reset_context(struct i915_gem_context *ctx,
 			    struct intel_engine_cs *engine)
 {
@@ -431,12 +413,7 @@ static bool __cancel_engine(struct intel
 	 * kill the banned context, we fallback to doing a local reset
 	 * instead.
 	 */
-	if (IS_ACTIVE(CONFIG_DRM_I915_PREEMPT_TIMEOUT) &&
-	    !intel_engine_pulse(engine))
-		return true;
-
-	/* If we are unable to send a pulse, try resetting this engine. */
-	return __reset_engine(engine);
+	return intel_engine_pulse(engine) == 0;
 }
 
 static bool
@@ -493,7 +470,7 @@ static struct intel_engine_cs *active_en
 	return engine;
 }
 
-static void kill_engines(struct i915_gem_engines *engines)
+static void kill_engines(struct i915_gem_engines *engines, bool ban)
 {
 	struct i915_gem_engines_iter it;
 	struct intel_context *ce;
@@ -508,7 +485,7 @@ static void kill_engines(struct i915_gem
 	for_each_gem_engine(ce, engines, it) {
 		struct intel_engine_cs *engine;
 
-		if (intel_context_set_banned(ce))
+		if (ban && intel_context_set_banned(ce))
 			continue;
 
 		/*
@@ -521,7 +498,7 @@ static void kill_engines(struct i915_gem
 		engine = active_engine(ce);
 
 		/* First attempt to gracefully cancel the context */
-		if (engine && !__cancel_engine(engine))
+		if (engine && !__cancel_engine(engine) && ban)
 			/*
 			 * If we are unable to send a preemptive pulse to bump
 			 * the context from the GPU, we have to resort to a full
@@ -531,8 +508,10 @@ static void kill_engines(struct i915_gem
 	}
 }
 
-static void kill_stale_engines(struct i915_gem_context *ctx)
+static void kill_context(struct i915_gem_context *ctx)
 {
+	bool ban = (!i915_gem_context_is_persistent(ctx) ||
+		    !ctx->i915->params.enable_hangcheck);
 	struct i915_gem_engines *pos, *next;
 
 	spin_lock_irq(&ctx->stale.lock);
@@ -545,7 +524,7 @@ static void kill_stale_engines(struct i9
 
 		spin_unlock_irq(&ctx->stale.lock);
 
-		kill_engines(pos);
+		kill_engines(pos, ban);
 
 		spin_lock_irq(&ctx->stale.lock);
 		GEM_BUG_ON(i915_sw_fence_signaled(&pos->fence));
@@ -557,11 +536,6 @@ static void kill_stale_engines(struct i9
 	spin_unlock_irq(&ctx->stale.lock);
 }
 
-static void kill_context(struct i915_gem_context *ctx)
-{
-	kill_stale_engines(ctx);
-}
-
 static void engines_idle_release(struct i915_gem_context *ctx,
 				 struct i915_gem_engines *engines)
 {
@@ -596,7 +570,7 @@ static void engines_idle_release(struct
 
 kill:
 	if (list_empty(&engines->link)) /* raced, already closed */
-		kill_engines(engines);
+		kill_engines(engines, true);
 
 	i915_sw_fence_commit(&engines->fence);
 }
@@ -654,9 +628,7 @@ static void context_close(struct i915_ge
 	 * case we opt to forcibly kill off all remaining requests on
 	 * context close.
 	 */
-	if (!i915_gem_context_is_persistent(ctx) ||
-	    !ctx->i915->params.enable_hangcheck)
-		kill_context(ctx);
+	kill_context(ctx);
 
 	i915_gem_context_put(ctx);
 }


