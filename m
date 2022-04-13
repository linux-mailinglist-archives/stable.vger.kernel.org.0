Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A04D54FF1E7
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 10:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiDMIbR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 04:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233629AbiDMIbQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 04:31:16 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE9249F83
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 01:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649838535; x=1681374535;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=uG3ZaMazPcEQ8CpNsNjf7aUkbb/evwjpUjJlhc89/WQ=;
  b=QNOJGiLopVFAvQBTDdLQjDUI0MxoSykULnVDU2AOT46c8LV8PzffVZ8e
   ixhrHE19li5tPt+7FjcTZGQ8e1xEWpQ+o7pBnz7NVXGn9uSgdndP7VAQj
   kMJ1qpbubAa3UOppulIyh54/kcOqKFyYuOfQgHwq23CnTMyAP2SO0qruk
   rIE8GCo6YBk4Nv5GVez9y7GG0WUKa9CTntf5QnXbYKmbACAFTj/U1mR58
   34LxTc602387SNWpdiIDJAAtFjFZrDhyfjlvXKspZr1RlaEKi790r9J+A
   Eoq+zA7DsSs4FfEi8oSeEwiDcz4w1NLw33ZHXvDA0t78EWfxthlH+F6kq
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10315"; a="244493550"
X-IronPort-AV: E=Sophos;i="5.90,256,1643702400"; 
   d="scan'208";a="244493550"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 01:28:54 -0700
X-IronPort-AV: E=Sophos;i="5.90,256,1643702400"; 
   d="scan'208";a="573172151"
Received: from marisaku-mobl.ger.corp.intel.com (HELO jhogande-mobl1.ger.corp.intel.com) ([10.249.45.38])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 01:28:52 -0700
From:   =?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     =?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
        Lyude Paul <lyude@redhat.com>,
        Mika Kahola <mika.kahola@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Filippo Falezza <filippo.falezza@outlook.it>,
        stable@vger.kernel.org
Subject: [PATCH v2] drm/i915: Check EDID for HDR static metadata when choosing blc
Date:   Wed, 13 Apr 2022 11:28:26 +0300
Message-Id: <20220413082826.120634-1-jouni.hogander@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We have now seen panel (XMG Core 15 e21 laptop) advertizing support
for Intel proprietary eDP backlight control via DPCD registers, but
actually working only with legacy pwm control.

This patch adds panel EDID check for possible HDR static metadata and
Intel proprietary eDP backlight control is used only if that exists.
Missing HDR static metadata is ignored if user specifically asks for
Intel proprietary eDP backlight control via enable_dpcd_backlight
parameter.

v2 :
- Ignore missing HDR static metadata if Intel proprietary eDP
  backlight control is forced via i915.enable_dpcd_backlight
- Printout info message if panel is missing HDR static metadata and
  support for Intel proprietary eDP backlight control is detected

Fixes: 4a8d79901d5b ("drm/i915/dp: Enable Intel's HDR backlight interface (only SDR for now)")
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/5284
Cc: Lyude Paul <lyude@redhat.com>
Cc: Mika Kahola <mika.kahola@intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Filippo Falezza <filippo.falezza@outlook.it>
Cc: stable@vger.kernel.org
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
---
 .../drm/i915/display/intel_dp_aux_backlight.c | 34 ++++++++++++++-----
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c b/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
index 97cf3cac0105..fb6cf30ee628 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
@@ -97,6 +97,14 @@
 
 #define INTEL_EDP_BRIGHTNESS_OPTIMIZATION_1                            0x359
 
+enum intel_dp_aux_backlight_modparam {
+	INTEL_DP_AUX_BACKLIGHT_AUTO = -1,
+	INTEL_DP_AUX_BACKLIGHT_OFF = 0,
+	INTEL_DP_AUX_BACKLIGHT_ON = 1,
+	INTEL_DP_AUX_BACKLIGHT_FORCE_VESA = 2,
+	INTEL_DP_AUX_BACKLIGHT_FORCE_INTEL = 3,
+};
+
 /* Intel EDP backlight callbacks */
 static bool
 intel_dp_aux_supports_hdr_backlight(struct intel_connector *connector)
@@ -126,6 +134,24 @@ intel_dp_aux_supports_hdr_backlight(struct intel_connector *connector)
 		return false;
 	}
 
+	/*
+	 * If we don't have HDR static metadata there is no way to
+	 * runtime detect used range for nits based control. For now
+	 * do not use Intel proprietary eDP backlight control if we
+	 * don't have this data in panel EDID. In case we find panel
+	 * which supports only nits based control, but doesn't provide
+	 * HDR static metadata we need to start maintaining table of
+	 * ranges for such panels.
+	 */
+	if (i915->params.enable_dpcd_backlight != INTEL_DP_AUX_BACKLIGHT_FORCE_INTEL &&
+	    !(connector->base.hdr_sink_metadata.hdmi_type1.metadata_type &
+	      BIT(HDMI_STATIC_METADATA_TYPE1))) {
+		drm_info(&i915->drm,
+			 "Panel is missing HDR static metadata. Possible support for Intel HDR backlight interface is not used. If your backlight controls don't work try booting with i915.enable_dpcd_backlight=%d. needs this, please file a _new_ bug report on drm/i915, see " FDO_BUG_URL " for details.\n",
+			 INTEL_DP_AUX_BACKLIGHT_FORCE_INTEL);
+		return false;
+	}
+
 	panel->backlight.edp.intel.sdr_uses_aux =
 		tcon_cap[2] & INTEL_EDP_SDR_TCON_BRIGHTNESS_AUX_CAP;
 
@@ -413,14 +439,6 @@ static const struct intel_panel_bl_funcs intel_dp_vesa_bl_funcs = {
 	.get = intel_dp_aux_vesa_get_backlight,
 };
 
-enum intel_dp_aux_backlight_modparam {
-	INTEL_DP_AUX_BACKLIGHT_AUTO = -1,
-	INTEL_DP_AUX_BACKLIGHT_OFF = 0,
-	INTEL_DP_AUX_BACKLIGHT_ON = 1,
-	INTEL_DP_AUX_BACKLIGHT_FORCE_VESA = 2,
-	INTEL_DP_AUX_BACKLIGHT_FORCE_INTEL = 3,
-};
-
 int intel_dp_aux_init_backlight_funcs(struct intel_connector *connector)
 {
 	struct drm_device *dev = connector->base.dev;
-- 
2.25.1

