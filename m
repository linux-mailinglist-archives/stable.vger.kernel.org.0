Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 990F71E1531
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 22:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390094AbgEYU3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 16:29:06 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:58296 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389665AbgEYU3F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 May 2020 16:29:05 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 21290259-1500050 
        for multiple; Mon, 25 May 2020 21:28:58 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/4] drm/i915/gt: Do not schedule normal requests immediately along virtual
Date:   Mon, 25 May 2020 21:28:58 +0100
Message-Id: <20200525202901.32244-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When we push a virtual request onto the HW, we update the rq->engine to
point to the physical engine. A request that is then submitted by the
user that waits upon the virtual engine, but along the physical engine
in use, will then see that it is due to be submitted to the same engine
and take a shortcut (and be queued without waiting for the completion
fence). However, the virtual request may be preempted (either by higher
priority users, or by timeslicing) and removed from the physical engine
to be migrated over to one of its siblings. The dependent normal request
however is oblivious to the removal of the virtual request and remains
queued to execute on HW, believing that once it reaches the head of its
queue all of its predecessors will have completed executing!

Fixes: 6d06779e8672 ("drm/i915: Load balancing across a virtual engine")
Testcase: igt/gem_exec_balancer/sliced
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: <stable@vger.kernel.org> # v5.3+
---
 drivers/gpu/drm/i915/i915_request.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
index c282719ad3ac..51588209bddd 100644
--- a/drivers/gpu/drm/i915/i915_request.c
+++ b/drivers/gpu/drm/i915/i915_request.c
@@ -1074,7 +1074,7 @@ i915_request_await_request(struct i915_request *to, struct i915_request *from)
 			return ret;
 	}
 
-	if (to->engine == from->engine)
+	if (is_power_of_2(to->execution_mask | READ_ONCE(from->execution_mask)))
 		ret = i915_sw_fence_await_sw_fence_gfp(&to->submit,
 						       &from->submit,
 						       I915_FENCE_GFP);
-- 
2.20.1

