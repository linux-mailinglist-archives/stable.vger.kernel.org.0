Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2401A8461
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 18:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391331AbgDNQPZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 12:15:25 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:59593 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390411AbgDNQOg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 12:14:36 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 20897748-1500050 
        for multiple; Tue, 14 Apr 2020 17:14:25 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Andi Shyti <andi.shyti@intel.com>,
        Lyude Paul <lyude@redhat.com>,
        Francisco Jerez <currojerez@riseup.net>, stable@vger.kernel.org
Subject: [PATCH 2/2] drm/i915/gt: Shrink the RPS evalution intervals
Date:   Tue, 14 Apr 2020 17:14:23 +0100
Message-Id: <20200414161423.23830-2-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200414161423.23830-1-chris@chris-wilson.co.uk>
References: <20200414161423.23830-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Try to make RPS dramatically more responsive by shrinking the evaluation
intervales by a factor of 100! The issue is as we now park the GPU
rapidly upon idling, a short or bursty workload such as the composited
desktop never sustains enough work to fill and complete an evaluation
window. As such, the frequency we program remains stuck. This was first
reported as once boosted, we never relinquished the boost [see commit
21abf0bf168d ("drm/i915/gt: Treat idling as a RPS downclock event")] but
it equally applies in the order direction for bursty workloads that
*need* low latency, like desktop animations.

What we could try is preserve the incomplete EI history across idling,
it is not clear whether that would be effective, nor whether the
presumption of continuous workloads is accurate. A clearer path seems to
treat it as symptomatic that we fail to handle bursty workload with the
current EI, and seek to address that by shrinking the EI so the
evaluations are run much more often.

This will likely entail more frequent interrupts, and by the time we
process the interrupt in the bottom half [from inside a worker], the
workload on the GPU has changed. To address the changeable nature, in
the previous patch we compared the previous complete EI with the
interrupt request and only up/down clock if both agree. The impact of
asking for, and presumably, receiving more interrupts is still to be
determined and mitigations sought. The first idea is to differentiate
between up/down responsivity and make upclocking more responsive than
downlocking. This should both help thwart jitter on bursty workloads by
making it easier to increase than it is to decrease frequencies, and
reduce the number of interrupts we would need to process.

Fixes: 21abf0bf168d ("drm/i915/gt: Treat idling as a RPS downclock event")
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/1698
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: Andi Shyti <andi.shyti@intel.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Francisco Jerez <currojerez@riseup.net>
Cc: <stable@vger.kernel.org> # v5.5+
---
 drivers/gpu/drm/i915/gt/intel_rps.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_rps.c b/drivers/gpu/drm/i915/gt/intel_rps.c
index 367132092bed..47ddb25edc97 100644
--- a/drivers/gpu/drm/i915/gt/intel_rps.c
+++ b/drivers/gpu/drm/i915/gt/intel_rps.c
@@ -542,37 +542,38 @@ static void rps_set_power(struct intel_rps *rps, int new_power)
 	/* Note the units here are not exactly 1us, but 1280ns. */
 	switch (new_power) {
 	case LOW_POWER:
-		/* Upclock if more than 95% busy over 16ms */
-		ei_up = 16000;
+		/* Upclock if more than 95% busy over 160us */
+		ei_up = 160;
 		threshold_up = 95;
 
-		/* Downclock if less than 85% busy over 32ms */
-		ei_down = 32000;
+		/* Downclock if less than 85% busy over 1600us */
+		ei_down = 1600;
 		threshold_down = 85;
 		break;
 
 	case BETWEEN:
-		/* Upclock if more than 90% busy over 13ms */
-		ei_up = 13000;
+		/* Upclock if more than 90% busy over 160us */
+		ei_up = 160;
 		threshold_up = 90;
 
-		/* Downclock if less than 75% busy over 32ms */
-		ei_down = 32000;
+		/* Downclock if less than 75% busy over 1600us */
+		ei_down = 1600;
 		threshold_down = 75;
 		break;
 
 	case HIGH_POWER:
-		/* Upclock if more than 85% busy over 10ms */
-		ei_up = 10000;
+		/* Upclock if more than 85% busy over 160us */
+		ei_up = 160;
 		threshold_up = 85;
 
-		/* Downclock if less than 60% busy over 32ms */
-		ei_down = 32000;
+		/* Downclock if less than 60% busy over 1600us */
+		ei_down = 1600;
 		threshold_down = 60;
 		break;
 	}
 
-	/* When byt can survive without system hang with dynamic
+	/*
+	 * When byt can survive without system hang with dynamic
 	 * sw freq adjustments, this restriction can be lifted.
 	 */
 	if (IS_VALLEYVIEW(i915))
-- 
2.20.1

