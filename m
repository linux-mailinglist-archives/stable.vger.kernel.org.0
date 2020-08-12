Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7765F2430DC
	for <lists+stable@lfdr.de>; Thu, 13 Aug 2020 00:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgHLWg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 18:36:29 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:62003 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726531AbgHLWg3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Aug 2020 18:36:29 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 22111009-1500050 
        for multiple; Wed, 12 Aug 2020 23:36:23 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Subject: [PATCH 3/3] drm/i915/gem: Always test execution status on closing the context
Date:   Wed, 12 Aug 2020 23:36:21 +0100
Message-Id: <20200812223621.22292-3-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200812223621.22292-1-chris@chris-wilson.co.uk>
References: <20200812223621.22292-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Verify that if a context is active at the time it is closed, that it is
either persistent and preemptible (with hangcheck running) or it shall
be removed from execution.

Fixes: 9a40bddd47ca ("drm/i915/gt: Expose heartbeat interval via sysfs")
Testcase: igt/gem_ctx_persistence/heartbeat-close
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: <stable@vger.kernel.org> # v5.7+
---
 drivers/gpu/drm/i915/gem/i915_gem_context.c | 24 ++++++++-------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_context.c b/drivers/gpu/drm/i915/gem/i915_gem_context.c
index db893f6c516b..49715ae71386 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_context.c
@@ -431,8 +431,7 @@ static bool __cancel_engine(struct intel_engine_cs *engine)
 	 * kill the banned context, we fallback to doing a local reset
 	 * instead.
 	 */
-	if (IS_ACTIVE(CONFIG_DRM_I915_PREEMPT_TIMEOUT) &&
-	    !intel_engine_pulse(engine))
+	if (intel_engine_pulse(engine) == 0)
 		return true;
 
 	/* If we are unable to send a pulse, try resetting this engine. */
@@ -493,7 +492,7 @@ static struct intel_engine_cs *active_engine(struct intel_context *ce)
 	return engine;
 }
 
-static void kill_engines(struct i915_gem_engines *engines)
+static void kill_engines(struct i915_gem_engines *engines, bool ban)
 {
 	struct i915_gem_engines_iter it;
 	struct intel_context *ce;
@@ -508,7 +507,7 @@ static void kill_engines(struct i915_gem_engines *engines)
 	for_each_gem_engine(ce, engines, it) {
 		struct intel_engine_cs *engine;
 
-		if (intel_context_set_banned(ce))
+		if (ban && intel_context_set_banned(ce))
 			continue;
 
 		/*
@@ -531,8 +530,10 @@ static void kill_engines(struct i915_gem_engines *engines)
 	}
 }
 
-static void kill_stale_engines(struct i915_gem_context *ctx)
+static void kill_context(struct i915_gem_context *ctx)
 {
+	bool ban = (!i915_gem_context_is_persistent(ctx) ||
+		    !ctx->i915->params.enable_hangcheck);
 	struct i915_gem_engines *pos, *next;
 
 	spin_lock_irq(&ctx->stale.lock);
@@ -545,7 +546,7 @@ static void kill_stale_engines(struct i915_gem_context *ctx)
 
 		spin_unlock_irq(&ctx->stale.lock);
 
-		kill_engines(pos);
+		kill_engines(pos, ban);
 
 		spin_lock_irq(&ctx->stale.lock);
 		GEM_BUG_ON(i915_sw_fence_signaled(&pos->fence));
@@ -557,11 +558,6 @@ static void kill_stale_engines(struct i915_gem_context *ctx)
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
@@ -596,7 +592,7 @@ static void engines_idle_release(struct i915_gem_context *ctx,
 
 kill:
 	if (list_empty(&engines->link)) /* raced, already closed */
-		kill_engines(engines);
+		kill_engines(engines, true);
 
 	i915_sw_fence_commit(&engines->fence);
 }
@@ -654,9 +650,7 @@ static void context_close(struct i915_gem_context *ctx)
 	 * case we opt to forcibly kill off all remaining requests on
 	 * context close.
 	 */
-	if (!i915_gem_context_is_persistent(ctx) ||
-	    !ctx->i915->params.enable_hangcheck)
-		kill_context(ctx);
+	kill_context(ctx);
 
 	i915_gem_context_put(ctx);
 }
-- 
2.20.1

