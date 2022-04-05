Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2AD14F3719
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349842AbiDELKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348830AbiDEJsk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C33D7B18A6;
        Tue,  5 Apr 2022 02:36:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A72E616AE;
        Tue,  5 Apr 2022 09:36:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670B9C385A0;
        Tue,  5 Apr 2022 09:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151385;
        bh=nk/Q96BZa8mA2Z50lh8w1N3ZUgfqnJJxcKdBW1mM5CQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nNB9g/RAMexvMRF+KtBb3+PP9bP9ULKGX/Tb698AtE4uqYCBqCy1Vemjqpnxqjenv
         toyx7fT0HT6OlWLcadSqV6zRMCa1R2OiFkjAy5rdiMyG2o1alxhRn7f9LpeAXrg6i5
         o17JEIwKkIYpJnVqh5s2zKwkn4rvVinQhybUje4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 396/913] drm/edid: Split deep color modes between RGB and YUV444
Date:   Tue,  5 Apr 2022 09:24:18 +0200
Message-Id: <20220405070351.717956448@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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
@@ -5004,21 +5004,21 @@ static void drm_parse_hdmi_deep_color_in
 
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
@@ -5035,6 +5035,7 @@ static void drm_parse_hdmi_deep_color_in
 
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


