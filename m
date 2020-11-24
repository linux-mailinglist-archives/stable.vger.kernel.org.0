Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB782C3007
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 19:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404275AbgKXSf0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 13:35:26 -0500
Received: from mail.fireflyinternet.com ([77.68.26.236]:64335 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S2404271AbgKXSfZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Nov 2020 13:35:25 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 23095651-1500050 
        for multiple; Tue, 24 Nov 2020 18:35:22 +0000
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Edward Baker <edward.baker@intel.com>,
        Andi Shyti <andi.shyti@intel.com>,
        Lyude Paul <lyude@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] drm/i915/gt: Limit frequency drop to RPe on parking
Date:   Tue, 24 Nov 2020 18:35:21 +0000
Message-Id: <20201124183521.28623-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We treat idling the GT (intel_rps_park) as a downclock event, and reduce
the frequency we intend to restart the GT with. Since the two workloads
are likely related (e.g. a compositor rendering every 16ms), we want to
carry the frequency and load information from across the idling.
However, we do also need to update the frequencies so that workloads
that run for less than 1ms are autotuned by RPS (otherwise we leave
compositors running at max clocks, draining excess power). Conversely,
if we try to run too slowly, the next workload has to run longer. Since
there is a hysteresis in the power graph, below a certain frequency
running a short workload for longer consumes more energy than running it
slightly higher for less time. The exact balance point is unknown
beforehand, but measurements with 30fps media playback indicate that RPe
is a better choice.

Reported-by: Edward Baker <edward.baker@intel.com>
Fixes: 043cd2d14ede ("drm/i915/gt: Leave rps->cur_freq on unpark")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Edward Baker <edward.baker@intel.com>
Cc: Andi Shyti <andi.shyti@intel.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: <stable@vger.kernel.org> # v5.8+
---
 drivers/gpu/drm/i915/gt/intel_rps.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/i915/gt/intel_rps.c b/drivers/gpu/drm/i915/gt/intel_rps.c
index b13e7845d483..f74d5e09e176 100644
--- a/drivers/gpu/drm/i915/gt/intel_rps.c
+++ b/drivers/gpu/drm/i915/gt/intel_rps.c
@@ -907,6 +907,10 @@ void intel_rps_park(struct intel_rps *rps)
 		adj = -2;
 	rps->last_adj = adj;
 	rps->cur_freq = max_t(int, rps->cur_freq + adj, rps->min_freq);
+	if (rps->cur_freq < rps->efficient_freq) {
+		rps->cur_freq = rps->efficient_freq;
+		rps->last_adj = 0;
+	}
 
 	GT_TRACE(rps_to_gt(rps), "park:%x\n", rps->cur_freq);
 }
-- 
2.20.1

