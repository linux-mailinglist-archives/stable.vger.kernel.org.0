Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 649342CEF52
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 15:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729113AbgLDOED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Dec 2020 09:04:03 -0500
Received: from mail.fireflyinternet.com ([77.68.26.236]:56586 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727682AbgLDOED (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Dec 2020 09:04:03 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 23215309-1500050 
        for multiple; Fri, 04 Dec 2020 14:03:18 +0000
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     tvrtko.ursulin@intel.com, Chris Wilson <chris@chris-wilson.co.uk>,
        stable@vger.kernel.org
Subject: [PATCH 02/24] drm/i915/gt: Ignore repeated attempts to suspend request flow across reset
Date:   Fri,  4 Dec 2020 14:02:53 +0000
Message-Id: <20201204140315.24341-2-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201204140315.24341-1-chris@chris-wilson.co.uk>
References: <20201204140315.24341-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Before reseting the engine, we suspend the execution of the guilty
request, so that we can continue execution with a new context while we
slowly compress the captured error state for the guilty context. However,
if the reset fails, we will promptly attempt to reset the same request
again, and discover the ongoing capture. Ignore the second attempt to
suspend and capture the same request.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/1168
Fixes: 32ff621fd744 ("drm/i915/gt: Allow temporary suspension of inflight requests")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: <stable@vger.kernel.org> # v5.7+
---
 drivers/gpu/drm/i915/gt/intel_lrc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index 43703efb36d1..1d209a8a95e8 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -2823,6 +2823,9 @@ static void __execlists_hold(struct i915_request *rq)
 static bool execlists_hold(struct intel_engine_cs *engine,
 			   struct i915_request *rq)
 {
+	if (i915_request_on_hold(rq))
+		return false;
+
 	spin_lock_irq(&engine->active.lock);
 
 	if (i915_request_completed(rq)) { /* too late! */
-- 
2.20.1

