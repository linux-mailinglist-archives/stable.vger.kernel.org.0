Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A211C04DB
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 20:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725844AbgD3Sdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 14:33:33 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:52186 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726318AbgD3Sdc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Apr 2020 14:33:32 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 21075321-1500050 
        for multiple; Thu, 30 Apr 2020 19:33:25 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915/pmu: Keep a reference to module while active
Date:   Thu, 30 Apr 2020 19:33:24 +0100
Message-Id: <20200430183324.23984-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While a perf event is open, keep a reference to the module so we don't
remove the driver internals mid-sampling.

Testcase: igt/perf_pmu/module-unload
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/i915/i915_pmu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_pmu.c b/drivers/gpu/drm/i915/i915_pmu.c
index 83c6a8ccd2cb..e991a707bdb7 100644
--- a/drivers/gpu/drm/i915/i915_pmu.c
+++ b/drivers/gpu/drm/i915/i915_pmu.c
@@ -442,6 +442,7 @@ static u64 count_interrupts(struct drm_i915_private *i915)
 static void i915_pmu_event_destroy(struct perf_event *event)
 {
 	WARN_ON(event->parent);
+	module_put(THIS_MODULE);
 }
 
 static int
@@ -533,8 +534,10 @@ static int i915_pmu_event_init(struct perf_event *event)
 	if (ret)
 		return ret;
 
-	if (!event->parent)
+	if (!event->parent) {
+		__module_get(THIS_MODULE);
 		event->destroy = i915_pmu_event_destroy;
+	}
 
 	return 0;
 }
-- 
2.20.1

