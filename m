Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00E134F2CA9
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348038AbiDEJ3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245043AbiDEIxD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:53:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D0BE59;
        Tue,  5 Apr 2022 01:50:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5473F60FFC;
        Tue,  5 Apr 2022 08:50:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 608C1C385A1;
        Tue,  5 Apr 2022 08:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148626;
        bh=lxhTv+y5LTSOEePsof2zvsKpS5M4FU32apZjfBMdYg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=noL7+S1UMIdhCJosdf10xkS04BZ0TpQmSvb5vM/EO/NDnMe5gR0DPsaL7eYR0ZRaL
         o17chCZ3f5tY0JEXo1kp3rvIWIlPAYz5HqTjad6LWOz7nd74brKWY7cLz9RtQQXXxs
         PFl+9hDZ3bjBgPNNkdl4RQeVWm+bGciaD+kP0R7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0422/1017] drm/edid: Split deep color modes between RGB and YUV444
Date:   Tue,  5 Apr 2022 09:22:15 +0200
Message-Id: <20220405070406.816548703@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 4adc33f36d80489339f1b43dfeee96bb9ea8e459 ]

The current code assumes that the RGB444 and YUV444 formats are the
same, but the HDMI 2.0 specification states that:

   The three DC_XXbit bits above only indicate support for RGB 4:4:4 at
   that pixel size. Support for YCBCR 4:4:4 in Deep Color modes is
   indicated with the DC_Y444 bit. If DC_Y444 is set, then YCBCR 4:4:4
   is supported for all modes indicated by the DC_XXbit flags.

So if we have YUV444 support and any DC_XXbit flag set but the DC_Y444
flag isn't, we'll assume that we support that deep colour mode for
YUV444 which breaks the specification.

In order to fix this, let's split the edid_hdmi_dc_modes field in struct
drm_display_info into two fields, one for RGB444 and one for YUV444.

Suggested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Fixes: d0c94692e0a3 ("drm/edid: Parse and handle HDMI deep color modes.")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220120151625.594595-4-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c |    2 +-
 drivers/gpu/drm/drm_edid.c                     |    7 ++++---
 drivers/gpu/drm/i915/display/intel_hdmi.c      |    4 ++--
 drivers/gpu/drm/radeon/radeon_connectors.c     |    2 +-
 include/drm/drm_connector.h                    |   12 +++++++++---
 5 files changed, 17 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
@@ -175,7 +175,7 @@ int amdgpu_connector_get_monitor_bpc(str
 
 			/* Check if bpc is within clock limit. Try to degrade gracefully otherwise */
 			if ((bpc == 12) && (mode_clock * 3/2 > max_tmds_clock)) {
-				if ((connector->display_info.edid_hdmi_dc_modes & DRM_EDID_HDMI_DC_30) &&
+				if ((connector->display_info.edid_hdmi_rgb444_dc_modes & DRM_EDID_HDMI_DC_30) &&
 				    (mode_clock * 5/4 <= max_tmds_clock))
 					bpc = 10;
 				else
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -5076,21 +5076,21 @@ static void drm_parse_hdmi_deep_color_in
 
 	if (hdmi[6] & DRM_EDID_HDMI_DC_30) {
 		dc_bpc = 10;
-		info->edid_hdmi_dc_modes |= DRM_EDID_HDMI_DC_30;
+		info->edid_hdmi_rgb444_dc_modes |= DRM_EDID_HDMI_DC_30;
 		DRM_DEBUG("%s: HDMI sink does deep color 30.\n",
 			  connector->name);
 	}
 
 	if (hdmi[6] & DRM_EDID_HDMI_DC_36) {
 		dc_bpc = 12;
-		info->edid_hdmi_dc_modes |= DRM_EDID_HDMI_DC_36;
+		info->edid_hdmi_rgb444_dc_modes |= DRM_EDID_HDMI_DC_36;
 		DRM_DEBUG("%s: HDMI sink does deep color 36.\n",
 			  connector->name);
 	}
 
 	if (hdmi[6] & DRM_EDID_HDMI_DC_48) {
 		dc_bpc = 16;
-		info->edid_hdmi_dc_modes |= DRM_EDID_HDMI_DC_48;
+		info->edid_hdmi_rgb444_dc_modes |= DRM_EDID_HDMI_DC_48;
 		DRM_DEBUG("%s: HDMI sink does deep color 48.\n",
 			  connector->name);
 	}
@@ -5107,6 +5107,7 @@ static void drm_parse_hdmi_deep_color_in
 
 	/* YCRCB444 is optional according to spec. */
 	if (hdmi[6] & DRM_EDID_HDMI_DC_Y444) {
+		info->edid_hdmi_ycbcr444_dc_modes = info->edid_hdmi_rgb444_dc_modes;
 		DRM_DEBUG("%s: HDMI sink does YCRCB444 in deep color.\n",
 			  connector->name);
 	}
--- a/drivers/gpu/drm/i915/display/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/display/intel_hdmi.c
@@ -1892,7 +1892,7 @@ static bool intel_hdmi_bpc_possible(stru
 		if (ycbcr420_output)
 			return hdmi->y420_dc_modes & DRM_EDID_YCBCR420_DC_36;
 		else
-			return info->edid_hdmi_dc_modes & DRM_EDID_HDMI_DC_36;
+			return info->edid_hdmi_rgb444_dc_modes & DRM_EDID_HDMI_DC_36;
 	case 10:
 		if (DISPLAY_VER(i915) < 11)
 			return false;
@@ -1903,7 +1903,7 @@ static bool intel_hdmi_bpc_possible(stru
 		if (ycbcr420_output)
 			return hdmi->y420_dc_modes & DRM_EDID_YCBCR420_DC_30;
 		else
-			return info->edid_hdmi_dc_modes & DRM_EDID_HDMI_DC_30;
+			return info->edid_hdmi_rgb444_dc_modes & DRM_EDID_HDMI_DC_30;
 	case 8:
 		return true;
 	default:
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -204,7 +204,7 @@ int radeon_get_monitor_bpc(struct drm_co
 
 			/* Check if bpc is within clock limit. Try to degrade gracefully otherwise */
 			if ((bpc == 12) && (mode_clock * 3/2 > max_tmds_clock)) {
-				if ((connector->display_info.edid_hdmi_dc_modes & DRM_EDID_HDMI_DC_30) &&
+				if ((connector->display_info.edid_hdmi_rgb444_dc_modes & DRM_EDID_HDMI_DC_30) &&
 					(mode_clock * 5/4 <= max_tmds_clock))
 					bpc = 10;
 				else
--- a/include/drm/drm_connector.h
+++ b/include/drm/drm_connector.h
@@ -566,10 +566,16 @@ struct drm_display_info {
 	bool rgb_quant_range_selectable;
 
 	/**
-	 * @edid_hdmi_dc_modes: Mask of supported hdmi deep color modes. Even
-	 * more stuff redundant with @bus_formats.
+	 * @edid_hdmi_dc_rgb444_modes: Mask of supported hdmi deep color modes
+	 * in RGB 4:4:4. Even more stuff redundant with @bus_formats.
 	 */
-	u8 edid_hdmi_dc_modes;
+	u8 edid_hdmi_rgb444_dc_modes;
+
+	/**
+	 * @edid_hdmi_dc_ycbcr444_modes: Mask of supported hdmi deep color
+	 * modes in YCbCr 4:4:4. Even more stuff redundant with @bus_formats.
+	 */
+	u8 edid_hdmi_ycbcr444_dc_modes;
 
 	/**
 	 * @cea_rev: CEA revision of the HDMI sink.


