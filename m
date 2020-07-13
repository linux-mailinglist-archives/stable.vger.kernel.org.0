Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9A7921D57C
	for <lists+stable@lfdr.de>; Mon, 13 Jul 2020 14:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729027AbgGMMEo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jul 2020 08:04:44 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:57422 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729143AbgGMMEn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jul 2020 08:04:43 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 21803010-1500050 
        for multiple; Mon, 13 Jul 2020 13:04:36 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915/gt: Free stale request on destroying the virtual engine
Date:   Mon, 13 Jul 2020 13:04:37 +0100
Message-Id: <20200713120437.4442-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since preempt-to-busy, we may unsubmit a request while it is still on
the HW and completes asynchronously. That means it may be retired and in
the process destroy the virtual engine (as the user has closed their
context), but that engine may still be holding onto the unsubmitted
compelted request. Therefore we need to potentially cleanup the old
request on destroying the virtual engine. We also have to keep the
virtual_engine alive until after the sibling's execlists_dequeue() have
finished peeking into the virtual engines, for which we serialise with
RCU.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2118
Fixes: 22b7a426bbe1 ("drm/i915/execlists: Preempt-to-busy")
References: 6d06779e8672 ("drm/i915: Load balancing across a virtual engine")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: <stable@vger.kernel.org> # v5.4+
---
 drivers/gpu/drm/i915/gt/intel_lrc.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index cd4262cc96e2..8425fd917d75 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -179,6 +179,7 @@
 #define EXECLISTS_REQUEST_SIZE 64 /* bytes */
 
 struct virtual_engine {
+	struct rcu_head rcu;
 	struct intel_engine_cs base;
 	struct intel_context context;
 
@@ -5385,10 +5386,25 @@ static void virtual_context_destroy(struct kref *kref)
 		container_of(kref, typeof(*ve), context.ref);
 	unsigned int n;
 
-	GEM_BUG_ON(!list_empty(virtual_queue(ve)));
-	GEM_BUG_ON(ve->request);
 	GEM_BUG_ON(ve->context.inflight);
 
+	if (unlikely(ve->request)) {
+		struct i915_request *old;
+		unsigned long flags;
+
+		spin_lock_irqsave(&ve->base.active.lock, flags);
+
+		old = fetch_and_zero(&ve->request);
+		if (old) {
+			GEM_BUG_ON(!i915_request_completed(old));
+			__i915_request_submit(old);
+			i915_request_put(old);
+		}
+
+		spin_unlock_irqrestore(&ve->base.active.lock, flags);
+	}
+	GEM_BUG_ON(!list_empty(virtual_queue(ve)));
+
 	for (n = 0; n < ve->num_siblings; n++) {
 		struct intel_engine_cs *sibling = ve->siblings[n];
 		struct rb_node *node = &ve->nodes[sibling->id].rb;
@@ -5414,7 +5430,7 @@ static void virtual_context_destroy(struct kref *kref)
 	intel_engine_free_request_pool(&ve->base);
 
 	kfree(ve->bonds);
-	kfree(ve);
+	kfree_rcu(ve, rcu);
 }
 
 static void virtual_engine_initial_hint(struct virtual_engine *ve)
-- 
2.20.1

