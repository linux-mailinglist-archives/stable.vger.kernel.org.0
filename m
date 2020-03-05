Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B47317A6A8
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 14:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbgCENs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 08:48:26 -0500
Received: from mail.fireflyinternet.com ([109.228.58.192]:54141 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725990AbgCENs0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Mar 2020 08:48:26 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from haswell.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 20454530-1500050 
        for multiple; Thu, 05 Mar 2020 13:48:22 +0000
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915: Return early for await_start on same timeline
Date:   Thu,  5 Mar 2020 13:48:22 +0000
Message-Id: <20200305134822.2750496-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Requests within a timeline are ordered by that timeline, so awaiting for
the start of a request within the timeline is a no-op. This used to work
by falling out of the mutex_trylock() as the signaler and waiter had the
same timeline and not returning an error.

Fixes: 6a79d848403d ("drm/i915: Lock signaler timeline while navigating")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.5+
---
 drivers/gpu/drm/i915/i915_request.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
index 46dae33c1a20..ca5361eb1f0b 100644
--- a/drivers/gpu/drm/i915/i915_request.c
+++ b/drivers/gpu/drm/i915/i915_request.c
@@ -837,8 +837,8 @@ i915_request_await_start(struct i915_request *rq, struct i915_request *signal)
 	struct dma_fence *fence;
 	int err;
 
-	GEM_BUG_ON(i915_request_timeline(rq) ==
-		   rcu_access_pointer(signal->timeline));
+	if (i915_request_timeline(rq) == rcu_access_pointer(signal->timeline))
+		return 0;
 
 	if (i915_request_started(signal))
 		return 0;
-- 
2.25.1

