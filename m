Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B04D17A34D
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 11:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbgCEKmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 05:42:18 -0500
Received: from mail.fireflyinternet.com ([109.228.58.192]:51086 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725937AbgCEKmS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Mar 2020 05:42:18 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from haswell.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 20451968-1500050 
        for multiple; Thu, 05 Mar 2020 10:42:10 +0000
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915: Actually emit the await_start
Date:   Thu,  5 Mar 2020 10:42:10 +0000
Message-Id: <20200305104210.2619967-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix the inverted test to emit the wait on the end of the previous
request if we /haven't/ already.

Fixes: 6a79d848403d ("drm/i915: Lock signaler timeline while navigating")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.5+
---
 drivers/gpu/drm/i915/i915_request.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
index 4bfe68edfc81..46dae33c1a20 100644
--- a/drivers/gpu/drm/i915/i915_request.c
+++ b/drivers/gpu/drm/i915/i915_request.c
@@ -882,7 +882,7 @@ i915_request_await_start(struct i915_request *rq, struct i915_request *signal)
 		return 0;
 
 	err = 0;
-	if (intel_timeline_sync_is_later(i915_request_timeline(rq), fence))
+	if (!intel_timeline_sync_is_later(i915_request_timeline(rq), fence))
 		err = i915_sw_fence_await_dma_fence(&rq->submit,
 						    fence, 0,
 						    I915_FENCE_GFP);
-- 
2.25.1

