Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06504F6AEB
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 19:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbfKJS6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Nov 2019 13:58:12 -0500
Received: from mail.fireflyinternet.com ([109.228.58.192]:52999 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726778AbfKJS6M (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Nov 2019 13:58:12 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from haswell.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 19151885-1500050 
        for multiple; Sun, 10 Nov 2019 18:58:10 +0000
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 05/25] drm/i915/pmu: "Frequency" is reported as accumulated cycles
Date:   Sun, 10 Nov 2019 18:57:46 +0000
Message-Id: <20191110185806.17413-5-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191110185806.17413-1-chris@chris-wilson.co.uk>
References: <20191110185806.17413-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We report "frequencies" (actual-frequency, requested-frequency) as the
number of accumulated cycles so that the average frequency over that
period may be determined by the user. This means the units we report to
the user are Mcycles (or just M), not MHz.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/i915/i915_pmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_pmu.c b/drivers/gpu/drm/i915/i915_pmu.c
index 4804775644bf..9b02be0ad4e6 100644
--- a/drivers/gpu/drm/i915/i915_pmu.c
+++ b/drivers/gpu/drm/i915/i915_pmu.c
@@ -908,8 +908,8 @@ create_event_attributes(struct i915_pmu *pmu)
 		const char *name;
 		const char *unit;
 	} events[] = {
-		__event(I915_PMU_ACTUAL_FREQUENCY, "actual-frequency", "MHz"),
-		__event(I915_PMU_REQUESTED_FREQUENCY, "requested-frequency", "MHz"),
+		__event(I915_PMU_ACTUAL_FREQUENCY, "actual-frequency", "M"),
+		__event(I915_PMU_REQUESTED_FREQUENCY, "requested-frequency", "M"),
 		__event(I915_PMU_INTERRUPTS, "interrupts", NULL),
 		__event(I915_PMU_RC6_RESIDENCY, "rc6-residency", "ns"),
 	};
-- 
2.24.0

