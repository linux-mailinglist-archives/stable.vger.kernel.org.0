Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9454F2662
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbiDEIFi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236233AbiDEIBo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:01:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09CBD49FB3;
        Tue,  5 Apr 2022 00:59:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAD76B81B14;
        Tue,  5 Apr 2022 07:59:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D54C340EE;
        Tue,  5 Apr 2022 07:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145583;
        bh=8Wl0kHDWkrYYKEbHj6G90fzuCsjMx9/bpl50/N3p/8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L6ycmAJ9Jlj63OVdQ23/Yu8fzBfSajZ4z0mYzxWGMVIx+9pp7hMyuslJ829/2Cqw7
         7GKj5UfxDWlkaKIh2T7ZlTGvW/wPf6sb/GHZR2LwDKswRR6F0j3jN1H1nxRV03uoHR
         9pJJyGSfCjikJenPqy83FIEUFBEP+RWxIFMX3HS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0455/1126] drm/edid: Split deep color modes between RGB and YUV444
Date:   Tue,  5 Apr 2022 09:20:02 +0200
Message-Id: <20220405070420.979727952@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c |  2 +-
 drivers/gpu/drm/drm_edid.c                     |  7 ++++---
 drivers/gpu/drm/i915/display/intel_hdmi.c      |  4 ++--
 drivers/gpu/drm/radeon/radeon_connectors.c     |  2 +-
 include/drm/drm_connector.h                    | 12 +++++++++---
 5 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
index c16a2704ced6..f3160b951df3 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
@@ -175,7 +175,7 @@ int amdgpu_connector_get_monitor_bpc(struct drm_connector *connector)
 
 			/* Check if bpc is within clock limit. Try to degrade gracefully otherwise */
 			if ((bpc == 12) && (mode_clock * 3/2 > max_tmds_clock)) {
-				if ((connector->display_info.edid_hdmi_dc_modes & DRM_EDID_HDMI_DC_30) &&
+				if ((connector->display_info.edid_hdmi_rgb444_dc_modes & DRM_EDID_HDMI_DC_30) &&
 				    (mode_clock * 5/4 <= max_tmds_clock))
 					bpc = 10;
 				else
diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 86a7c4a5253f..b8f5419e514a 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -5076,21 +5076,21 @@ static void drm_parse_hdmi_deep_color_info(struct drm_connector *connector,
 
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
@@ -5107,6 +5107,7 @@ static void drm_parse_hdmi_deep_color_info(struct drm_connector *connector,
 
 	/* YCRCB444 is optional according to spec. */
 	if (hdmi[6] & DRM_EDID_HDMI_DC_Y444) {
+		info->edid_hdmi_ycbcr444_dc_modes = info->edid_hdmi_rgb444_dc_modes;
 		DRM_DEBUG("%s: HDMI sink does YCRCB444 in deep color.\n",
 			  connector->name);
 	}
diff --git a/drivers/gpu/drm/i915/display/intel_hdmi.c b/drivers/gpu/drm/i915/display/intel_hdmi.c
index 3b5b9e7b05b7..6bb513f0564f 100644
--- a/drivers/gpu/drm/i915/display/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/display/intel_hdmi.c
@@ -1912,7 +1912,7 @@ static bool intel_hdmi_sink_bpc_possible(struct drm_connector *connector,
 		if (ycbcr420_output)
 			return hdmi->y420_dc_modes & DRM_EDID_YCBCR420_DC_36;
 		else
-			return info->edid_hdmi_dc_modes & DRM_EDID_HDMI_DC_36;
+			return info->edid_hdmi_rgb444_dc_modes & DRM_EDID_HDMI_DC_36;
 	case 10:
 		if (!has_hdmi_sink)
 			return false;
@@ -1920,7 +1920,7 @@ static bool intel_hdmi_sink_bpc_possible(struct drm_connector *connector,
 		if (ycbcr420_output)
 			return hdmi->y420_dc_modes & DRM_EDID_YCBCR420_DC_30;
 		else
-			return info->edid_hdmi_dc_modes & DRM_EDID_HDMI_DC_30;
+			return info->edid_hdmi_rgb444_dc_modes & DRM_EDID_HDMI_DC_30;
 	case 8:
 		return true;
 	default:
diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
index 607ad5620bd9..1546abcadacf 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -204,7 +204,7 @@ int radeon_get_monitor_bpc(struct drm_connector *connector)
 
 			/* Check if bpc is within clock limit. Try to degrade gracefully otherwise */
 			if ((bpc == 12) && (mode_clock * 3/2 > max_tmds_clock)) {
-				if ((connector->display_info.edid_hdmi_dc_modes & DRM_EDID_HDMI_DC_30) &&
+				if ((connector->display_info.edid_hdmi_rgb444_dc_modes & DRM_EDID_HDMI_DC_30) &&
 					(mode_clock * 5/4 <= max_tmds_clock))
 					bpc = 10;
 				else
diff --git a/include/drm/drm_connector.h b/include/drm/drm_connector.h
index b501d0badaea..eaf0ef5f1843 100644
--- a/include/drm/drm_connector.h
+++ b/include/drm/drm_connector.h
@@ -592,10 +592,16 @@ struct drm_display_info {
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
-- 
2.34.1



