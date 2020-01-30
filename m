Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3FCF14E25C
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbgA3Sor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:44:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:54034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730876AbgA3Sop (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:44:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 688912082E;
        Thu, 30 Jan 2020 18:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409884;
        bh=uoiKXNIuubbeNw3qBmSN+cRwAkJofhSu4WMXkX5YgXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O3j2KeTs+5CIaWhFelGAW+hmkgGd8soS1f9QZJsEg2dMWvyFKpaTR6LRP4dAVdDbC
         lrK8wjVskABAbG0B0Su7cKN/DXMWyI10LGlsCOhOSNtAAMS7QHdm8MwFbEoXbIiCxh
         b8YaaPiQIry6KjRrEuYnmVjVS+ow27L/nzWoFVp0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Thomas Anderson <thomasanderson@google.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 071/110] drm/amd/display: Reduce HDMI pixel encoding if max clock is exceeded
Date:   Thu, 30 Jan 2020 19:38:47 +0100
Message-Id: <20200130183622.883885909@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Anderson <thomasanderson@google.com>

[ Upstream commit 840c90fce6c78bc6b2c4cb9e836d70985ed32066 ]

For high-res (8K) or HFR (4K120) displays, using uncompressed pixel
formats like YCbCr444 would exceed the bandwidth of HDMI 2.0, so the
"interesting" modes would be disabled, leaving only low-res or low
framerate modes.

This change lowers the pixel encoding to 4:2:2 or 4:2:0 if the max TMDS
clock is exceeded. Verified that 8K30 and 4K120 are now available and
working with a Samsung Q900R over an HDMI 2.0b link from a Radeon 5700.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Thomas Anderson <thomasanderson@google.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 45 ++++++++++---------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 4e9c15c409bac..360c87ba45956 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3266,27 +3266,21 @@ get_output_color_space(const struct dc_crtc_timing *dc_crtc_timing)
 	return color_space;
 }
 
-static void reduce_mode_colour_depth(struct dc_crtc_timing *timing_out)
-{
-	if (timing_out->display_color_depth <= COLOR_DEPTH_888)
-		return;
-
-	timing_out->display_color_depth--;
-}
-
-static void adjust_colour_depth_from_display_info(struct dc_crtc_timing *timing_out,
-						const struct drm_display_info *info)
+static bool adjust_colour_depth_from_display_info(
+	struct dc_crtc_timing *timing_out,
+	const struct drm_display_info *info)
 {
+	enum dc_color_depth depth = timing_out->display_color_depth;
 	int normalized_clk;
-	if (timing_out->display_color_depth <= COLOR_DEPTH_888)
-		return;
 	do {
 		normalized_clk = timing_out->pix_clk_100hz / 10;
 		/* YCbCr 4:2:0 requires additional adjustment of 1/2 */
 		if (timing_out->pixel_encoding == PIXEL_ENCODING_YCBCR420)
 			normalized_clk /= 2;
 		/* Adjusting pix clock following on HDMI spec based on colour depth */
-		switch (timing_out->display_color_depth) {
+		switch (depth) {
+		case COLOR_DEPTH_888:
+			break;
 		case COLOR_DEPTH_101010:
 			normalized_clk = (normalized_clk * 30) / 24;
 			break;
@@ -3297,14 +3291,15 @@ static void adjust_colour_depth_from_display_info(struct dc_crtc_timing *timing_
 			normalized_clk = (normalized_clk * 48) / 24;
 			break;
 		default:
-			return;
+			/* The above depths are the only ones valid for HDMI. */
+			return false;
 		}
-		if (normalized_clk <= info->max_tmds_clock)
-			return;
-		reduce_mode_colour_depth(timing_out);
-
-	} while (timing_out->display_color_depth > COLOR_DEPTH_888);
-
+		if (normalized_clk <= info->max_tmds_clock) {
+			timing_out->display_color_depth = depth;
+			return true;
+		}
+	} while (--depth > COLOR_DEPTH_666);
+	return false;
 }
 
 static void fill_stream_properties_from_drm_display_mode(
@@ -3370,8 +3365,14 @@ static void fill_stream_properties_from_drm_display_mode(
 
 	stream->out_transfer_func->type = TF_TYPE_PREDEFINED;
 	stream->out_transfer_func->tf = TRANSFER_FUNCTION_SRGB;
-	if (stream->signal == SIGNAL_TYPE_HDMI_TYPE_A)
-		adjust_colour_depth_from_display_info(timing_out, info);
+	if (stream->signal == SIGNAL_TYPE_HDMI_TYPE_A) {
+		if (!adjust_colour_depth_from_display_info(timing_out, info) &&
+		    drm_mode_is_420_also(info, mode_in) &&
+		    timing_out->pixel_encoding != PIXEL_ENCODING_YCBCR420) {
+			timing_out->pixel_encoding = PIXEL_ENCODING_YCBCR420;
+			adjust_colour_depth_from_display_info(timing_out, info);
+		}
+	}
 }
 
 static void fill_audio_info(struct audio_info *audio_info,
-- 
2.20.1



