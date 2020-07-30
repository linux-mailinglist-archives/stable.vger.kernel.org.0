Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3919232FA0
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 11:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgG3JiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 05:38:13 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:55928 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726615AbgG3JiM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jul 2020 05:38:12 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 21979070-1500050 
        for multiple; Thu, 30 Jul 2020 10:38:03 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     tvrtko.ursulin@intel.com, thomas.hellstrom@intel.com,
        Chris Wilson <chris@chris-wilson.co.uk>,
        CQ Tang <cq.tang@intel.com>, stable@vger.kernel.org,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>
Subject: [PATCH 21/21] drm/i915/gem: Delay tracking the GEM context until it is registered
Date:   Thu, 30 Jul 2020 10:37:56 +0100
Message-Id: <20200730093756.16737-22-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200730093756.16737-1-chris@chris-wilson.co.uk>
References: <20200730093756.16737-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Avoid exposing a partially constructed context by deferring the
list_add() from the initial construction to the end of registration.
Otherwise, if we peek into the list of contexts from inside debugfs, we
may see the partially constructed context and chase down some dangling
incomplete pointers.

Reported-by: CQ Tang <cq.tang@intel.com>
Fixes: 3aa9945a528e ("drm/i915: Separate GEM context construction and registration to userspace")
References: f6e8aa387171 ("drm/i915: Report the number of closed vma held by each context in debugfs")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: CQ Tang <cq.tang@intel.com>
Cc: <stable@vger.kernel.org> # v5.2+
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
---
 drivers/gpu/drm/i915/gem/i915_gem_context.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_context.c b/drivers/gpu/drm/i915/gem/i915_gem_context.c
index f43f0ca4eec9..d308cefb2b34 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_context.c
@@ -713,6 +713,7 @@ __create_context(struct drm_i915_private *i915)
 	ctx->i915 = i915;
 	ctx->sched.priority = I915_USER_PRIORITY(I915_PRIORITY_NORMAL);
 	mutex_init(&ctx->mutex);
+	INIT_LIST_HEAD(&ctx->link);
 
 	spin_lock_init(&ctx->stale.lock);
 	INIT_LIST_HEAD(&ctx->stale.engines);
@@ -740,10 +741,6 @@ __create_context(struct drm_i915_private *i915)
 	for (i = 0; i < ARRAY_SIZE(ctx->hang_timestamp); i++)
 		ctx->hang_timestamp[i] = jiffies - CONTEXT_FAST_HANG_JIFFIES;
 
-	spin_lock(&i915->gem.contexts.lock);
-	list_add_tail(&ctx->link, &i915->gem.contexts.list);
-	spin_unlock(&i915->gem.contexts.lock);
-
 	return ctx;
 
 err_free:
@@ -936,6 +933,7 @@ static int gem_context_register(struct i915_gem_context *ctx,
 				struct drm_i915_file_private *fpriv,
 				u32 *id)
 {
+	struct drm_i915_private *i915 = ctx->i915;
 	struct i915_address_space *vm;
 	int ret;
 
@@ -954,8 +952,16 @@ static int gem_context_register(struct i915_gem_context *ctx,
 	/* And finally expose ourselves to userspace via the idr */
 	ret = xa_alloc(&fpriv->context_xa, id, ctx, xa_limit_32b, GFP_KERNEL);
 	if (ret)
-		put_pid(fetch_and_zero(&ctx->pid));
+		goto err_pid;
+
+	spin_lock(&i915->gem.contexts.lock);
+	list_add_tail(&ctx->link, &i915->gem.contexts.list);
+	spin_unlock(&i915->gem.contexts.lock);
+
+	return 0;
 
+err_pid:
+	put_pid(fetch_and_zero(&ctx->pid));
 	return ret;
 }
 
-- 
2.20.1

