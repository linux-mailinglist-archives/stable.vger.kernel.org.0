Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0ABB35D3EA
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 01:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237609AbhDLXYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 19:24:39 -0400
Received: from mga05.intel.com ([192.55.52.43]:14530 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237594AbhDLXYj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 19:24:39 -0400
IronPort-SDR: k7vv5N4BvMYB/YnoAW7ZIUTWiKSP8YL4qQNsLzp7LXAvaJ8X5rr1G7u6PRAQix4JTYqaXbB5vg
 GUFRizQ9dktA==
X-IronPort-AV: E=McAfee;i="6200,9189,9952"; a="279600773"
X-IronPort-AV: E=Sophos;i="5.82,216,1613462400"; 
   d="scan'208";a="279600773"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2021 16:24:17 -0700
IronPort-SDR: tpx5dUKFdd/ZCplLSDi02vfr+0D/p9KtBWV3le/f3l4sh7kaUOQpBArtSjqRbM556A9hEhl7Mk
 flmakaEy76Ag==
X-IronPort-AV: E=Sophos;i="5.82,216,1613462400"; 
   d="scan'208";a="398552813"
Received: from ideak-desk.fi.intel.com ([10.237.68.141])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2021 16:24:16 -0700
From:   Imre Deak <imre.deak@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>
Subject: [PATCH 1/2] drm/i915: Fix modesetting in case of unexpected AUX timeouts
Date:   Tue, 13 Apr 2021 02:24:12 +0300
Message-Id: <20210412232413.2755054-1-imre.deak@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In case AUX failures happen unexpectedly during a modeset, the driver
should still complete the modeset. In particular the driver should
perform the link training sequence steps even in case of an AUX failure,
as this sequence also includes port initialization steps. Not doing that
can leave the port/pipe in a broken state and lead for instance to a
flip done timeout.

Fix this by continuing with link training (in a no-LTTPR mode) if the
DPRX DPCD readout failed for some reason at the beginning of link
training. After a successful connector detection we already have the
DPCD read out and cached, so the failed repeated read for it should not
cause a problem. Note that a partial AUX read could in theory partly
overwrite the cached DPCD (and return error) but this overwrite should
not happen if the returned values are corrupted (due to a timeout or
some other IO error).

Kudos to Ville to root cause the problem.

Fixes: 7dffbdedb96a ("drm/i915: Disable LTTPR support when the DPCD rev < 1.4")
References: https://gitlab.freedesktop.org/drm/intel/-/issues/3308
Cc: stable@vger.kernel.org # 5.11
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 drivers/gpu/drm/i915/display/intel_dp_link_training.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp_link_training.c b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
index 5e9c3c74310ca..cbcfb0c4c3708 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_link_training.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
@@ -882,7 +882,8 @@ void intel_dp_start_link_train(struct intel_dp *intel_dp,
 	int lttpr_count = intel_dp_init_lttpr_and_dprx_caps(intel_dp);
 
 	if (lttpr_count < 0)
-		return;
+		/* Still continue with enabling the port and link training. */
+		lttpr_count = 0;
 
 	if (!intel_dp_link_train_all_phys(intel_dp, crtc_state, lttpr_count))
 		intel_dp_schedule_fallback_link_training(intel_dp, crtc_state);
-- 
2.27.0

