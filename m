Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B06C221FFD
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 11:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbgGPJqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jul 2020 05:46:48 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:58937 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726027AbgGPJqr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jul 2020 05:46:47 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 21836142-1500050 
        for multiple; Thu, 16 Jul 2020 10:46:44 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915: Provide the perf pmu.module
Date:   Thu, 16 Jul 2020 10:46:43 +0100
Message-Id: <20200716094643.31410-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Rather than manually implement our own module reference counting for perf
pmu events, finally realise that there is a module parameter to struct
pmu for this very purpose.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/i915/i915_pmu.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_pmu.c b/drivers/gpu/drm/i915/i915_pmu.c
index 28bc5f13ae52..056994224c6b 100644
--- a/drivers/gpu/drm/i915/i915_pmu.c
+++ b/drivers/gpu/drm/i915/i915_pmu.c
@@ -445,8 +445,6 @@ static void i915_pmu_event_destroy(struct perf_event *event)
 		container_of(event->pmu, typeof(*i915), pmu.base);
 
 	drm_WARN_ON(&i915->drm, event->parent);
-
-	module_put(THIS_MODULE);
 }
 
 static int
@@ -538,10 +536,8 @@ static int i915_pmu_event_init(struct perf_event *event)
 	if (ret)
 		return ret;
 
-	if (!event->parent) {
-		__module_get(THIS_MODULE);
+	if (!event->parent)
 		event->destroy = i915_pmu_event_destroy;
-	}
 
 	return 0;
 }
@@ -1130,6 +1126,7 @@ void i915_pmu_register(struct drm_i915_private *i915)
 	if (!pmu->base.attr_groups)
 		goto err_attr;
 
+	pmu->base.module	= THIS_MODULE;
 	pmu->base.task_ctx_nr	= perf_invalid_context;
 	pmu->base.event_init	= i915_pmu_event_init;
 	pmu->base.add		= i915_pmu_event_add;
-- 
2.20.1

