Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7B2F6BB082
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232027AbjCOMS4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231921AbjCOMSu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:18:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B756A94778
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:18:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5194061D49
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:18:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6482AC4339B;
        Wed, 15 Mar 2023 12:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882714;
        bh=fsNS+3yOBe+bLHRjIJi1mdYGy0sg603Z8dfMR+7ugTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g6L2CGYUxLA+COY4sOcwfdOXCHj1tsAUebXfcdziAG1A/C1gogSofq7Wtq0BGWo0p
         RZSge+zQLUXq5gtKtcpPs5XSZAQjF49W3GAk/SItuD99md6v8xeMfDP/Awhx0r+/SF
         HqGPXaxMOUIIA5EPHXWNP22Q99iLE0GZBx2o75sE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wayne Lin <Wayne.Lin@amd.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 12/68] drm/edid: Add aspect ratios to HDMI 4K modes
Date:   Wed, 15 Mar 2023 13:12:06 +0100
Message-Id: <20230315115726.576168999@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115726.103942885@linuxfoundation.org>
References: <20230315115726.103942885@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wayne Lin <Wayne.Lin@amd.com>

[ Upstream commit d2b434730f301a7ad74473eb66422f0008186306 ]

[Why]
HDMI 2.0 adds aspect ratio attribute to distinguish different
4k modes. According to Appendix E of HDMI 2.0 spec, source should
use VSIF to indicate video mode only when the mode is one defined
in HDMI 1.4b 4K modes. Otherwise, use AVI infoframes to convey VIC.

Current code doesn't take aspect ratio into consideration while
constructing avi infoframe. Should modify that.

[How]
Inherit Ville Syrjälä's work
"drm/edid: Prep for HDMI VIC aspect ratio" at
https://patchwork.kernel.org/patch/11174639/

Add picture_aspect_ratio attributes to edid_4k_modes[] and
construct VIC and HDMI_VIC by taking aspect ratio into
consideration.

v2: Correct missing initializer error at adding aspect ratio of
SMPTE mode.

Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191118101832.15487-1-Wayne.Lin@amd.com
Stable-dep-of: 1cbc1f0d324b ("drm/edid: fix AVI infoframe aspect ratio handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_edid.c | 45 +++++++++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 245e495f57c93..f9735861741c1 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -1292,25 +1292,25 @@ static const struct drm_display_mode edid_4k_modes[] = {
 		   3840, 4016, 4104, 4400, 0,
 		   2160, 2168, 2178, 2250, 0,
 		   DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC),
-	  .vrefresh = 30, },
+	  .vrefresh = 30, .picture_aspect_ratio = HDMI_PICTURE_ASPECT_16_9, },
 	/* 2 - 3840x2160@25Hz */
 	{ DRM_MODE("3840x2160", DRM_MODE_TYPE_DRIVER, 297000,
 		   3840, 4896, 4984, 5280, 0,
 		   2160, 2168, 2178, 2250, 0,
 		   DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC),
-	  .vrefresh = 25, },
+	  .vrefresh = 25, .picture_aspect_ratio = HDMI_PICTURE_ASPECT_16_9, },
 	/* 3 - 3840x2160@24Hz */
 	{ DRM_MODE("3840x2160", DRM_MODE_TYPE_DRIVER, 297000,
 		   3840, 5116, 5204, 5500, 0,
 		   2160, 2168, 2178, 2250, 0,
 		   DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC),
-	  .vrefresh = 24, },
+	  .vrefresh = 24, .picture_aspect_ratio = HDMI_PICTURE_ASPECT_16_9, },
 	/* 4 - 4096x2160@24Hz (SMPTE) */
 	{ DRM_MODE("4096x2160", DRM_MODE_TYPE_DRIVER, 297000,
 		   4096, 5116, 5204, 5500, 0,
 		   2160, 2168, 2178, 2250, 0,
 		   DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC),
-	  .vrefresh = 24, },
+	  .vrefresh = 24, .picture_aspect_ratio = HDMI_PICTURE_ASPECT_256_135, },
 };
 
 /*** DDC fetch and block validation ***/
@@ -3122,6 +3122,11 @@ enum hdmi_picture_aspect drm_get_cea_aspect_ratio(const u8 video_code)
 }
 EXPORT_SYMBOL(drm_get_cea_aspect_ratio);
 
+static enum hdmi_picture_aspect drm_get_hdmi_aspect_ratio(const u8 video_code)
+{
+	return edid_4k_modes[video_code].picture_aspect_ratio;
+}
+
 /*
  * Calculate the alternate clock for HDMI modes (those from the HDMI vendor
  * specific block).
@@ -3148,6 +3153,9 @@ static u8 drm_match_hdmi_mode_clock_tolerance(const struct drm_display_mode *to_
 	if (!to_match->clock)
 		return 0;
 
+	if (to_match->picture_aspect_ratio)
+		match_flags |= DRM_MODE_MATCH_ASPECT_RATIO;
+
 	for (vic = 1; vic < ARRAY_SIZE(edid_4k_modes); vic++) {
 		const struct drm_display_mode *hdmi_mode = &edid_4k_modes[vic];
 		unsigned int clock1, clock2;
@@ -3183,6 +3191,9 @@ static u8 drm_match_hdmi_mode(const struct drm_display_mode *to_match)
 	if (!to_match->clock)
 		return 0;
 
+	if (to_match->picture_aspect_ratio)
+		match_flags |= DRM_MODE_MATCH_ASPECT_RATIO;
+
 	for (vic = 1; vic < ARRAY_SIZE(edid_4k_modes); vic++) {
 		const struct drm_display_mode *hdmi_mode = &edid_4k_modes[vic];
 		unsigned int clock1, clock2;
@@ -5123,6 +5134,7 @@ drm_hdmi_avi_infoframe_from_display_mode(struct hdmi_avi_infoframe *frame,
 					 const struct drm_display_mode *mode)
 {
 	enum hdmi_picture_aspect picture_aspect;
+	u8 vic, hdmi_vic;
 	int err;
 
 	if (!frame || !mode)
@@ -5135,7 +5147,8 @@ drm_hdmi_avi_infoframe_from_display_mode(struct hdmi_avi_infoframe *frame,
 	if (mode->flags & DRM_MODE_FLAG_DBLCLK)
 		frame->pixel_repeat = 1;
 
-	frame->video_code = drm_mode_cea_vic(connector, mode);
+	vic = drm_mode_cea_vic(connector, mode);
+	hdmi_vic = drm_mode_hdmi_vic(connector, mode);
 
 	frame->picture_aspect = HDMI_PICTURE_ASPECT_NONE;
 
@@ -5149,11 +5162,15 @@ drm_hdmi_avi_infoframe_from_display_mode(struct hdmi_avi_infoframe *frame,
 
 	/*
 	 * Populate picture aspect ratio from either
-	 * user input (if specified) or from the CEA mode list.
+	 * user input (if specified) or from the CEA/HDMI mode lists.
 	 */
 	picture_aspect = mode->picture_aspect_ratio;
-	if (picture_aspect == HDMI_PICTURE_ASPECT_NONE)
-		picture_aspect = drm_get_cea_aspect_ratio(frame->video_code);
+	if (picture_aspect == HDMI_PICTURE_ASPECT_NONE) {
+		if (vic)
+			picture_aspect = drm_get_cea_aspect_ratio(vic);
+		else if (hdmi_vic)
+			picture_aspect = drm_get_hdmi_aspect_ratio(hdmi_vic);
+	}
 
 	/*
 	 * The infoframe can't convey anything but none, 4:3
@@ -5161,12 +5178,20 @@ drm_hdmi_avi_infoframe_from_display_mode(struct hdmi_avi_infoframe *frame,
 	 * we can only satisfy it by specifying the right VIC.
 	 */
 	if (picture_aspect > HDMI_PICTURE_ASPECT_16_9) {
-		if (picture_aspect !=
-		    drm_get_cea_aspect_ratio(frame->video_code))
+		if (vic) {
+			if (picture_aspect != drm_get_cea_aspect_ratio(vic))
+				return -EINVAL;
+		} else if (hdmi_vic) {
+			if (picture_aspect != drm_get_hdmi_aspect_ratio(hdmi_vic))
+				return -EINVAL;
+		} else {
 			return -EINVAL;
+		}
+
 		picture_aspect = HDMI_PICTURE_ASPECT_NONE;
 	}
 
+	frame->video_code = vic;
 	frame->picture_aspect = picture_aspect;
 	frame->active_aspect = HDMI_ACTIVE_ASPECT_PICTURE;
 	frame->scan_mode = HDMI_SCAN_MODE_UNDERSCAN;
-- 
2.39.2



