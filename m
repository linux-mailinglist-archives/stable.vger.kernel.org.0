Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9E4F35238C
	for <lists+stable@lfdr.de>; Fri,  2 Apr 2021 01:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233974AbhDAX3e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Apr 2021 19:29:34 -0400
Received: from mga03.intel.com ([134.134.136.65]:22738 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233789AbhDAX3e (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Apr 2021 19:29:34 -0400
IronPort-SDR: OlVYQqfZyZcy1Ultn+oo/ht5E53lNmPr3CY7XlB/UZfMpaSDnAt/ED9imO0JGRMnM4CVvTPPDY
 QaUk/ufnNtVg==
X-IronPort-AV: E=McAfee;i="6000,8403,9941"; a="192383414"
X-IronPort-AV: E=Sophos;i="5.81,298,1610438400"; 
   d="scan'208";a="192383414"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2021 16:29:34 -0700
IronPort-SDR: JhZo7SC4PZaURe0/qZsakwRUhzNU5NzTy2bHtoKBycPq2xmXE0UqMw7cIQscSNhqjad7Md3ke6
 qR+N4GZxCdbg==
X-IronPort-AV: E=Sophos;i="5.81,298,1610438400"; 
   d="scan'208";a="419410721"
Received: from ideak-desk.fi.intel.com ([10.237.68.141])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2021 16:29:33 -0700
From:   Imre Deak <imre.deak@intel.com>
To:     gfx-internal-devel@eclists.intel.com
Cc:     stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>
Subject: [PATCH 2/3] drm/i915: Disable LTTPR support when the DPCD rev < 1.4
Date:   Fri,  2 Apr 2021 02:29:25 +0300
Message-Id: <20210401232927.1711811-3-imre.deak@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210401232927.1711811-1-imre.deak@intel.com>
References: <20210401232927.1711811-1-imre.deak@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Git-Pile: INTEL_DII
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

By the specification the 0xF0000-0xF02FF range is only valid when the
DPCD revision is 1.4 or higher. Disable LTTPR support if this isn't so.

Trying to detect LTTPRs returned corrupted values for the above DPCD
range at least on a Skylake host with an LG 43UD79-B monitor with a DPCD
revision 1.2 connected.

v2: Add the actual version check.
v3: Fix s/DRPX/DPRX/ typo.

Fixes: 7b2a4ab8b0ef ("drm/i915: Switch to LTTPR transparent mode link training")
Cc: <stable@vger.kernel.org> # v5.11
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210317190149.4032966-1-imre.deak@intel.com
(cherry picked from commit 264613b406eb0d74cd9ca582c717c5e2c5a975ea)
---
 drivers/gpu/drm/i915/display/intel_dp.c       |  4 +-
 .../drm/i915/display/intel_dp_link_training.c | 48 ++++++++++++++-----
 .../drm/i915/display/intel_dp_link_training.h |  2 +-
 3 files changed, 39 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 9fb09938c98d..31b8acca1b45 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -3712,9 +3712,7 @@ intel_dp_get_dpcd(struct intel_dp *intel_dp)
 {
 	int ret;
 
-	intel_dp_lttpr_init(intel_dp);
-
-	if (drm_dp_read_dpcd_caps(&intel_dp->aux, intel_dp->dpcd))
+	if (intel_dp_init_lttpr_and_dprx_caps(intel_dp) < 0)
 		return false;
 
 	/*
diff --git a/drivers/gpu/drm/i915/display/intel_dp_link_training.c b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
index 35cda72492d7..c10e81a3d64f 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_link_training.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
@@ -34,6 +34,11 @@ intel_dp_dump_link_status(const u8 link_status[DP_LINK_STATUS_SIZE])
 		      link_status[3], link_status[4], link_status[5]);
 }
 
+static void intel_dp_reset_lttpr_common_caps(struct intel_dp *intel_dp)
+{
+	memset(&intel_dp->lttpr_common_caps, 0, sizeof(intel_dp->lttpr_common_caps));
+}
+
 static void intel_dp_reset_lttpr_count(struct intel_dp *intel_dp)
 {
 	intel_dp->lttpr_common_caps[DP_PHY_REPEATER_CNT -
@@ -95,8 +100,7 @@ static bool intel_dp_read_lttpr_common_caps(struct intel_dp *intel_dp)
 
 	if (drm_dp_read_lttpr_common_caps(&intel_dp->aux,
 					  intel_dp->lttpr_common_caps) < 0) {
-		memset(intel_dp->lttpr_common_caps, 0,
-		       sizeof(intel_dp->lttpr_common_caps));
+		intel_dp_reset_lttpr_common_caps(intel_dp);
 		return false;
 	}
 
@@ -118,30 +122,49 @@ intel_dp_set_lttpr_transparent_mode(struct intel_dp *intel_dp, bool enable)
 }
 
 /**
- * intel_dp_lttpr_init - detect LTTPRs and init the LTTPR link training mode
+ * intel_dp_init_lttpr_and_dprx_caps - detect LTTPR and DPRX caps, init the LTTPR link training mode
  * @intel_dp: Intel DP struct
  *
- * Read the LTTPR common capabilities, switch to non-transparent link training
- * mode if any is detected and read the PHY capabilities for all detected
- * LTTPRs. In case of an LTTPR detection error or if the number of
+ * Read the LTTPR common and DPRX capabilities and switch to non-transparent
+ * link training mode if any is detected and read the PHY capabilities for all
+ * detected LTTPRs. In case of an LTTPR detection error or if the number of
  * LTTPRs is more than is supported (8), fall back to the no-LTTPR,
  * transparent mode link training mode.
  *
  * Returns:
- *   >0  if LTTPRs were detected and the non-transparent LT mode was set
+ *   >0  if LTTPRs were detected and the non-transparent LT mode was set. The
+ *       DPRX capabilities are read out.
  *    0  if no LTTPRs or more than 8 LTTPRs were detected or in case of a
- *       detection failure and the transparent LT mode was set
+ *       detection failure and the transparent LT mode was set. The DPRX
+ *       capabilities are read out.
+ *   <0  Reading out the DPRX capabilities failed.
  */
-int intel_dp_lttpr_init(struct intel_dp *intel_dp)
+int intel_dp_init_lttpr_and_dprx_caps(struct intel_dp *intel_dp)
 {
 	int lttpr_count;
 	bool ret;
 	int i;
 
 	ret = intel_dp_read_lttpr_common_caps(intel_dp);
+
+	/* The DPTX shall read the DPRX caps after LTTPR detection. */
+	if (drm_dp_read_dpcd_caps(&intel_dp->aux, intel_dp->dpcd)) {
+		intel_dp_reset_lttpr_common_caps(intel_dp);
+		return -EIO;
+	}
+
 	if (!ret)
 		return 0;
 
+	/*
+	 * The 0xF0000-0xF02FF range is only valid if the DPCD revision is
+	 * at least 1.4.
+	 */
+	if (intel_dp->dpcd[DP_DPCD_REV] < 0x14) {
+		intel_dp_reset_lttpr_common_caps(intel_dp);
+		return 0;
+	}
+
 	lttpr_count = drm_dp_lttpr_count(intel_dp->lttpr_common_caps);
 	/*
 	 * Prevent setting LTTPR transparent mode explicitly if no LTTPRs are
@@ -181,7 +204,7 @@ int intel_dp_lttpr_init(struct intel_dp *intel_dp)
 
 	return lttpr_count;
 }
-EXPORT_SYMBOL(intel_dp_lttpr_init);
+EXPORT_SYMBOL(intel_dp_init_lttpr_and_dprx_caps);
 
 static u8 dp_voltage_max(u8 preemph)
 {
@@ -816,7 +839,10 @@ void intel_dp_start_link_train(struct intel_dp *intel_dp,
 	 * TODO: Reiniting LTTPRs here won't be needed once proper connector
 	 * HW state readout is added.
 	 */
-	int lttpr_count = intel_dp_lttpr_init(intel_dp);
+	int lttpr_count = intel_dp_init_lttpr_and_dprx_caps(intel_dp);
+
+	if (lttpr_count < 0)
+		return;
 
 	if (!intel_dp_link_train_all_phys(intel_dp, crtc_state, lttpr_count))
 		intel_dp_schedule_fallback_link_training(intel_dp, crtc_state);
diff --git a/drivers/gpu/drm/i915/display/intel_dp_link_training.h b/drivers/gpu/drm/i915/display/intel_dp_link_training.h
index 6a1f76bd8c75..9cb7c28027f0 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_link_training.h
+++ b/drivers/gpu/drm/i915/display/intel_dp_link_training.h
@@ -11,7 +11,7 @@
 struct intel_crtc_state;
 struct intel_dp;
 
-int intel_dp_lttpr_init(struct intel_dp *intel_dp);
+int intel_dp_init_lttpr_and_dprx_caps(struct intel_dp *intel_dp);
 
 void intel_dp_get_adjust_train(struct intel_dp *intel_dp,
 			       const struct intel_crtc_state *crtc_state,
