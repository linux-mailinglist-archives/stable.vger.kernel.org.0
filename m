Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2CD92FF8E0
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 00:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725765AbhAUX2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 18:28:55 -0500
Received: from mail.fireflyinternet.com ([77.68.26.236]:51739 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726672AbhAUX2w (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jan 2021 18:28:52 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 23666207-1500050 
        for multiple; Thu, 21 Jan 2021 23:28:07 +0000
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Matthew Auld <matthew.auld@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915: Always flush the active worker before returning from the wait
Date:   Thu, 21 Jan 2021 23:28:07 +0000
Message-Id: <20210121232807.16618-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The first thing the active retirement worker does is decrement the
i915_active count.

The first thing we do during i915_active_wait is try to increment the
i915_active count, but only if already active [non-zero].

The wait may see that the retirement is already started and so marked the
i915_active as idle, and skip waiting for the retirement handler.
However, the caller of i915_active_wait may immediately free the
i915_active upon returning (e.g. i915_vma_destroy) so we must not return
before the concurrent access from the worker are completed. We must
always flush the worker.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2473
Fixes: 274cbf20fd10 ("drm/i915: Push the i915_active.retire into a worker")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: <stable@vger.kernel.org> # v5.5+
---
 drivers/gpu/drm/i915/i915_active.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_active.c b/drivers/gpu/drm/i915/i915_active.c
index ab4382841c6b..3bc616cc1ad2 100644
--- a/drivers/gpu/drm/i915/i915_active.c
+++ b/drivers/gpu/drm/i915/i915_active.c
@@ -628,24 +628,26 @@ static int flush_lazy_signals(struct i915_active *ref)
 
 int __i915_active_wait(struct i915_active *ref, int state)
 {
-	int err;
-
 	might_sleep();
 
-	if (!i915_active_acquire_if_busy(ref))
-		return 0;
-
 	/* Any fence added after the wait begins will not be auto-signaled */
-	err = flush_lazy_signals(ref);
-	i915_active_release(ref);
-	if (err)
-		return err;
+	if (i915_active_acquire_if_busy(ref)) {
+		int err;
 
-	if (!i915_active_is_idle(ref) &&
-	    ___wait_var_event(ref, i915_active_is_idle(ref),
-			      state, 0, 0, schedule()))
-		return -EINTR;
+		err = flush_lazy_signals(ref);
+		i915_active_release(ref);
+		if (err)
+			return err;
 
+		if (___wait_var_event(ref, i915_active_is_idle(ref),
+				      state, 0, 0, schedule()))
+			return -EINTR;
+	}
+
+	/*
+	 * After the wait is complete, the caller may free the active.
+	 * We have to flush any concurrent retirement before returning.
+	 */
 	flush_work(&ref->work);
 	return 0;
 }
-- 
2.20.1

