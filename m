Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CA0396139
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbhEaOhh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:37:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233409AbhEaOfg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:35:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3707E61C4B;
        Mon, 31 May 2021 13:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469062;
        bh=OdtetdxlGqc2ms66zc94XV82oBrJojYNRV7/1ZIhSdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YRZXEa0OX6PVEXcAXuavupbI8TGuyJdK0UmAcZbLQtyHbFlun4GDcLR30mYczzJG4
         cDK9ihC2X963Ts5jXJ5gtrmpkD3E8fYGkc824pqIc8IYChRUIBPYI60qY/pm4vxfm7
         MmUqGOY4HuiDPMDryKgIdcAxHdJpuefz0VT0dtcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Khaled Almahallawy <khaled.almahallawy@intel.com>,
        Imre Deak <imre.deak@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Casey Harkins <caseyharkins@gmail.com>
Subject: [PATCH 5.12 054/296] drm/i915: Reenable LTTPR non-transparent LT mode for DPCD_REV<1.4
Date:   Mon, 31 May 2021 15:11:49 +0200
Message-Id: <20210531130705.646503518@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

commit e11851429fdc23524aa244f76508c3c7aeaefdf6 upstream.

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

Reported-and-tested-by: Casey Harkins <caseyharkins@gmail.com>
Tested-by: Khaled Almahallawy <khaled.almahallawy@intel.com>
Fixes: 264613b406eb ("drm/i915: Disable LTTPR support when the DPCD rev < 1.4")
Cc: <stable@vger.kernel.org> # v5.11+
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Khaled Almahallawy <khaled.almahallawy@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210512212809.1234701-1-imre.deak@intel.com
(cherry picked from commit cb4920cc40f630b5a247f4ed7d3dea66749df588)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp_link_training.c |   71 ++++++++----------
 1 file changed, 33 insertions(+), 38 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_dp_link_training.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
@@ -127,49 +127,13 @@ intel_dp_set_lttpr_transparent_mode(stru
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
@@ -210,6 +174,37 @@ int intel_dp_init_lttpr_and_dprx_caps(st
 
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


