Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 923D839B666
	for <lists+stable@lfdr.de>; Fri,  4 Jun 2021 12:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbhFDKDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Jun 2021 06:03:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:24877 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229625AbhFDKDn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Jun 2021 06:03:43 -0400
IronPort-SDR: 6g3tB455rGEcJBEnVVQTACn+ADSclwur1OWNA7zU2kvByGRBSP57XWgZ1emMaFRGpZG3ySbitC
 IPgzVufW39Ww==
X-IronPort-AV: E=McAfee;i="6200,9189,10004"; a="191371158"
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="191371158"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 03:01:57 -0700
IronPort-SDR: ymoh7XPXJRQYnN+ekf2jXA2Qqd4/RZZG5B49xYJOwRD8QTLhqr/mINRMsGv5GGiirF9gk6wPtz
 i9YyquQecE2w==
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="400913822"
Received: from tsengwil-desk1.itwn.intel.com (HELO gar) ([10.5.224.21])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 03:01:55 -0700
From:   William Tseng <william.tseng@intel.com>
To:     william.tseng@intel.com
Cc:     Imre Deak <imre.deak@intel.com>, stable@vger.kernel.org
Subject: [PATCH 1/2] drm/i915: Reenable LTTPR non-transparent LT mode for DPCD_REV<1.4
Date:   Fri,  4 Jun 2021 18:01:50 +0800
Message-Id: <20210604100150.806-1-william.tseng@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

The driver currently disables the LTTPR non-transparent link training
mode for sinks with a DPCD_REV<1.4, based on the following description
of the LTTPR DPCD register range in DP standard 2.0 (at the 0xF0000
register description):

""
LTTPR-related registers at DPCD Addresses F0000h through F02FFh are valid
only for DPCD r1.4 (or higher).
"""

The transparent link training mode should still work fine, however the
implementation for this in some retimer FWs seems to be broken, see the
References: link below.

After discussions with DP standard authors the above "DPCD r1.4" does
not refer to the DPCD revision (stored in the DPCD_REV reg at 0x00000),
rather to the "LTTPR field data structure revision" stored in the
0xF0000 reg. An update request has been filed at vesa.org (see
wg/Link/documentComment/3746) for the upcoming v2.1 specification to
clarify the above description along the following lines:

"""
LTTPR-related registers at DPCD Addresses F0000h through F02FFh are
valid only for LT_TUNABLE_PHY_REPEATER_FIELD_DATA_STRUCTURE_REV 1.4 (or
higher)
"""

Based on my tests Windows uses the non-transparent link training mode
for DPCD_REV==1.2 sinks as well (so presumably for all DPCD_REVs), and
forcing it to use transparent mode on ICL/TGL platforms leads to the
same LT failure as reported at the References: link.

Based on the above let's assume that the transparent link training mode
is not well tested/supported and align the code to the correct
interpretation of what the r1.4 version refers to.

References: https://gitlab.freedesktop.org/drm/intel/-/issues/3415
Fixes: 264613b406eb ("drm/i915: Disable LTTPR support when the DPCD rev < 1.4")
Cc: <stable@vger.kernel.org> # v5.11+
Signed-off-by: Imre Deak <imre.deak@intel.com>
Tested-by: Khaled Almahallawy <khaled.almahallawy@intel.com>
Reviewed-by: Khaled Almahallawy <khaled.almahallawy@intel.com>
---
 .../drm/i915/display/intel_dp_link_training.c | 71 +++++++++----------
 1 file changed, 33 insertions(+), 38 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp_link_training.c b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
index 02a003fd48fb..50cae0198a3d 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_link_training.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
@@ -128,49 +128,13 @@ intel_dp_set_lttpr_transparent_mode(struct intel_dp *intel_dp, bool enable)
 	return drm_dp_dpcd_write(&intel_dp->aux, DP_PHY_REPEATER_MODE, &val, 1) == 1;
 }
 
-/**
- * intel_dp_init_lttpr_and_dprx_caps - detect LTTPR and DPRX caps, init the LTTPR link training mode
- * @intel_dp: Intel DP struct
- *
- * Read the LTTPR common and DPRX capabilities and switch to non-transparent
- * link training mode if any is detected and read the PHY capabilities for all
- * detected LTTPRs. In case of an LTTPR detection error or if the number of
- * LTTPRs is more than is supported (8), fall back to the no-LTTPR,
- * transparent mode link training mode.
- *
- * Returns:
- *   >0  if LTTPRs were detected and the non-transparent LT mode was set. The
- *       DPRX capabilities are read out.
- *    0  if no LTTPRs or more than 8 LTTPRs were detected or in case of a
- *       detection failure and the transparent LT mode was set. The DPRX
- *       capabilities are read out.
- *   <0  Reading out the DPRX capabilities failed.
- */
-int intel_dp_init_lttpr_and_dprx_caps(struct intel_dp *intel_dp)
+static int intel_dp_init_lttpr(struct intel_dp *intel_dp)
 {
 	int lttpr_count;
-	bool ret;
 	int i;
 
-	ret = intel_dp_read_lttpr_common_caps(intel_dp);
-
-	/* The DPTX shall read the DPRX caps after LTTPR detection. */
-	if (drm_dp_read_dpcd_caps(&intel_dp->aux, intel_dp->dpcd)) {
-		intel_dp_reset_lttpr_common_caps(intel_dp);
-		return -EIO;
-	}
-
-	if (!ret)
-		return 0;
-
-	/*
-	 * The 0xF0000-0xF02FF range is only valid if the DPCD revision is
-	 * at least 1.4.
-	 */
-	if (intel_dp->dpcd[DP_DPCD_REV] < 0x14) {
-		intel_dp_reset_lttpr_common_caps(intel_dp);
+	if (!intel_dp_read_lttpr_common_caps(intel_dp))
 		return 0;
-	}
 
 	lttpr_count = drm_dp_lttpr_count(intel_dp->lttpr_common_caps);
 	/*
@@ -211,6 +175,37 @@ int intel_dp_init_lttpr_and_dprx_caps(struct intel_dp *intel_dp)
 
 	return lttpr_count;
 }
+
+/**
+ * intel_dp_init_lttpr_and_dprx_caps - detect LTTPR and DPRX caps, init the LTTPR link training mode
+ * @intel_dp: Intel DP struct
+ *
+ * Read the LTTPR common and DPRX capabilities and switch to non-transparent
+ * link training mode if any is detected and read the PHY capabilities for all
+ * detected LTTPRs. In case of an LTTPR detection error or if the number of
+ * LTTPRs is more than is supported (8), fall back to the no-LTTPR,
+ * transparent mode link training mode.
+ *
+ * Returns:
+ *   >0  if LTTPRs were detected and the non-transparent LT mode was set. The
+ *       DPRX capabilities are read out.
+ *    0  if no LTTPRs or more than 8 LTTPRs were detected or in case of a
+ *       detection failure and the transparent LT mode was set. The DPRX
+ *       capabilities are read out.
+ *   <0  Reading out the DPRX capabilities failed.
+ */
+int intel_dp_init_lttpr_and_dprx_caps(struct intel_dp *intel_dp)
+{
+	int lttpr_count = intel_dp_init_lttpr(intel_dp);
+
+	/* The DPTX shall read the DPRX caps after LTTPR detection. */
+	if (drm_dp_read_dpcd_caps(&intel_dp->aux, intel_dp->dpcd)) {
+		intel_dp_reset_lttpr_common_caps(intel_dp);
+		return -EIO;
+	}
+
+	return lttpr_count;
+}
 EXPORT_SYMBOL(intel_dp_init_lttpr_and_dprx_caps);
 
 static u8 dp_voltage_max(u8 preemph)
-- 
2.17.1

