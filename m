Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCEF21C53C8
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 12:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbgEEK4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 06:56:11 -0400
Received: from mga18.intel.com ([134.134.136.126]:20635 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728180AbgEEK4K (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 May 2020 06:56:10 -0400
IronPort-SDR: WcZLvKP3y26X0CBaBEfC02uQQdA0i5hxcpXzojUo9JRMDmBqJ8BsfhCFI/g4l6d4M4rVsQvAZP
 F8i82cWMAPPg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2020 03:56:10 -0700
IronPort-SDR: u03PA3SfpjIihAuSc4N4arcU3PljFGr4csxwOHg7Z9/FDhwo7QE6Dd+1d6PJCcruGUBij8v393
 hSszcikM2FFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,354,1583222400"; 
   d="scan'208";a="460997418"
Received: from gem-build.fi.intel.com (HELO localhost) ([10.237.72.180])
  by fmsmga005.fm.intel.com with ESMTP; 05 May 2020 03:56:08 -0700
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     gfx-internal-devel@eclists.intel.com
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Andi Shyti <andi.shyti@intel.com>,
        Lyude Paul <lyude@redhat.com>, stable@vger.kernel.org
Subject: [PATCH 04/55] drm/i915/gt: Treat idling as a RPS downclock event
Date:   Tue,  5 May 2020 10:55:06 +0000
Message-Id: <20200505105558.127979-5-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200505105558.127979-1-chris@chris-wilson.co.uk>
References: <20200505105558.127979-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If we park/unpark faster than we can respond to RPS events, we never
will process a downclock event after expiring a waitboost, and thus we
will forever restart the GPU at max clocks even if the workload switches
and doesn't justify full power.

Closes: https://gitlab.freedesktop.org/drm/intel/issues/1500
Fixes: 3e7abf814193 ("drm/i915: Extract GT render power state management")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Andi Shyti <andi.shyti@intel.com>
Cc: Lyude Paul <lyude@redhat.com>
Reviewed-by: Andi Shyti <andi.shyti@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200322163225.28791-1-chris@chris-wilson.co.uk
Cc: <stable@vger.kernel.org> # v5.5+
(cherry picked from commit 21abf0bf168dffff1192e0f072af1dc74ae1ff0e)
---
 drivers/gpu/drm/i915/gt/intel_rps.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/gpu/drm/i915/gt/intel_rps.c b/drivers/gpu/drm/i915/gt/intel_rps.c
index 3a3f49a71974..8accea06185b 100644
--- a/drivers/gpu/drm/i915/gt/intel_rps.c
+++ b/drivers/gpu/drm/i915/gt/intel_rps.c
@@ -765,6 +765,19 @@ void intel_rps_park(struct intel_rps *rps)
 	intel_uncore_forcewake_get(rps_to_uncore(rps), FORCEWAKE_MEDIA);
 	rps_set(rps, rps->idle_freq, false);
 	intel_uncore_forcewake_put(rps_to_uncore(rps), FORCEWAKE_MEDIA);
+
+	/*
+	 * Since we will try and restart from the previously requested
+	 * frequency on unparking, treat this idle point as a downclock
+	 * interrupt and reduce the frequency for resume. If we park/unpark
+	 * more frequently than the rps worker can run, we will not respond
+	 * to any EI and never see a change in frequency.
+	 *
+	 * (Note we accommodate Cherryview's limitation of only using an
+	 * even bin by applying it to all.)
+	 */
+	rps->cur_freq =
+		max_t(int, round_down(rps->cur_freq - 1, 2), rps->min_freq);
 }
 
 void intel_rps_boost(struct i915_request *rq)
---------------------------------------------------------------------
Intel Corporation (UK) Limited
Registered No. 1134945 (England)
Registered Office: Pipers Way, Swindon SN3 1RJ
VAT No: 860 2173 47

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

