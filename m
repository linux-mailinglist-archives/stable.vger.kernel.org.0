Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAD751A9B6
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356790AbiEDRTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357581AbiEDRPH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A725521B;
        Wed,  4 May 2022 09:58:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B443617A6;
        Wed,  4 May 2022 16:58:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46940C385A5;
        Wed,  4 May 2022 16:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683524;
        bh=3TzXMKvd6eC55mqijotQiI6jDkYbdylBFY4G2KQvp5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RNn6tCc/kVSoSo9Ia8eSQJTYOAoXak4rpVKNNmJrbJqWiseUzPawjzo7yPQYCzKrv
         zWQcjaCIR/2tAzgLMdfllqcQcn6AK3zib9cNJI1JEhHINFFGCLQh3AvWRQjmmCMrDH
         1cn0NLNeGqfF0wHkbClk6+wHu94Cs3eIsVkeNBQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Mika Kahola <mika.kahola@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Filippo Falezza <filippo.falezza@outlook.it>,
        =?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 5.17 186/225] drm/i915: Check EDID for HDR static metadata when choosing blc
Date:   Wed,  4 May 2022 18:47:04 +0200
Message-Id: <20220504153126.956417972@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jouni Högander <jouni.hogander@intel.com>

commit c05d8332f5d23fa3b521911cbe55a2b67fb21248 upstream.

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
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220413082826.120634-1-jouni.hogander@intel.com
Reviewed-by: Lyude Paul <lyude@redhat.com>
(cherry picked from commit b4b157577cb1de13bee8bebc3576f1de6799a921)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c |   34 +++++++++++++-----
 1 file changed, 26 insertions(+), 8 deletions(-)

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
@@ -126,6 +134,24 @@ intel_dp_aux_supports_hdr_backlight(stru
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
 
@@ -413,14 +439,6 @@ static const struct intel_panel_bl_funcs
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


