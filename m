Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F8421DB32
	for <lists+stable@lfdr.de>; Mon, 13 Jul 2020 18:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729593AbgGMQFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jul 2020 12:05:53 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:64242 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729027AbgGMQFx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jul 2020 12:05:53 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 21806082-1500050 
        for multiple; Mon, 13 Jul 2020 17:05:48 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915/gt: Only swap to a random sibling once upon creation
Date:   Mon, 13 Jul 2020 17:05:49 +0100
Message-Id: <20200713160549.17344-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The danger in switching at random upon intel_context_pin is that the
context may still actually be inflight, as it will not be scheduled out
until a context switch after it is complete -- that is after we do a
final intel_context_unpin.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2118
Fixes: 6d06779e8672 ("drm/i915: Load balancing across a virtual engine")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: <stable@vger.kernel.org> # v5.3+
---
 drivers/gpu/drm/i915/gt/intel_lrc.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index cd4262cc96e2..f4658849b08a 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -5435,13 +5435,8 @@ static void virtual_engine_initial_hint(struct virtual_engine *ve)
 	 * typically be the first we inspect for submission.
 	 */
 	swp = prandom_u32_max(ve->num_siblings);
-	if (!swp)
-		return;
-
-	swap(ve->siblings[swp], ve->siblings[0]);
-	if (!intel_engine_has_relative_mmio(ve->siblings[0]))
-		virtual_update_register_offsets(ve->context.lrc_reg_state,
-						ve->siblings[0]);
+	if (swp)
+		swap(ve->siblings[swp], ve->siblings[0]);
 }
 
 static int virtual_context_alloc(struct intel_context *ce)
@@ -5454,15 +5449,9 @@ static int virtual_context_alloc(struct intel_context *ce)
 static int virtual_context_pin(struct intel_context *ce)
 {
 	struct virtual_engine *ve = container_of(ce, typeof(*ve), context);
-	int err;
 
 	/* Note: we must use a real engine class for setting up reg state */
-	err = __execlists_context_pin(ce, ve->siblings[0]);
-	if (err)
-		return err;
-
-	virtual_engine_initial_hint(ve);
-	return 0;
+	return __execlists_context_pin(ce, ve->siblings[0]);
 }
 
 static void virtual_context_enter(struct intel_context *ce)
@@ -5808,6 +5797,7 @@ intel_execlists_create_virtual(struct intel_engine_cs **siblings,
 
 	ve->base.flags |= I915_ENGINE_IS_VIRTUAL;
 
+	virtual_engine_initial_hint(ve);
 	return &ve->context;
 
 err_put:
-- 
2.20.1

