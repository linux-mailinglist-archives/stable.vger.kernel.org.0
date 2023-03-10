Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF4306B49CC
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234101AbjCJPPj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:15:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234190AbjCJPPN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:15:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE80B126986
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:06:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F54061A41
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:05:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B2BC433EF;
        Fri, 10 Mar 2023 15:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460707;
        bh=4imHVhIkNcFlJjU7Pj1L8y3wsuLGOJBv0DADlr74iAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rYNqp/2umE1mHKyy0z7peWpyaLnWhpGK5tIyHywFzICKje78YNPK/u0pxUIAfoy6p
         +i9gZ0j+eFDTjOBnKB+Sa2RlTS4s5aF+nTrbUb/XA8mYYXhieUb56kXCQPkfnOx9lQ
         84Z9hTGAGJAt3iCUy4ekynQGaIPJDFEklPehAF4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, William Tseng <william.tseng@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.10 425/529] drm/edid: fix AVI infoframe aspect ratio handling
Date:   Fri, 10 Mar 2023 14:39:28 +0100
Message-Id: <20230310133824.671269712@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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

From: Jani Nikula <jani.nikula@intel.com>

commit 1cbc1f0d324ba6c4d1b10ac6362b5e0b029f63d5 upstream.

We try to avoid sending VICs defined in the later specs in AVI
infoframes to sinks that conform to the earlier specs, to not upset
them, and use 0 for the VIC instead. However, we do this detection and
conversion to 0 too early, as we'll need the actual VIC to figure out
the aspect ratio.

In particular, for a mode with 64:27 aspect ratio, 0 for VIC fails the
AVI infoframe generation altogether with -EINVAL.

Separate the VIC lookup from the "filtering", and postpone the
filtering, to use the proper VIC for aspect ratio handling, and the 0
VIC for the infoframe video code as needed.

Reported-by: William Tseng <william.tseng@intel.com>
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/6153
Cc: <stable@vger.kernel.org>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/c3e78cc6d01ed237f71ad0038826b08d83d75eef.1672826282.git.jani.nikula@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_edid.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -5560,8 +5560,6 @@ static u8 drm_mode_hdmi_vic(const struct
 static u8 drm_mode_cea_vic(const struct drm_connector *connector,
 			   const struct drm_display_mode *mode)
 {
-	u8 vic;
-
 	/*
 	 * HDMI spec says if a mode is found in HDMI 1.4b 4K modes
 	 * we should send its VIC in vendor infoframes, else send the
@@ -5571,13 +5569,18 @@ static u8 drm_mode_cea_vic(const struct
 	if (drm_mode_hdmi_vic(connector, mode))
 		return 0;
 
-	vic = drm_match_cea_mode(mode);
+	return drm_match_cea_mode(mode);
+}
 
-	/*
-	 * HDMI 1.4 VIC range: 1 <= VIC <= 64 (CEA-861-D) but
-	 * HDMI 2.0 VIC range: 1 <= VIC <= 107 (CEA-861-F). So we
-	 * have to make sure we dont break HDMI 1.4 sinks.
-	 */
+/*
+ * Avoid sending VICs defined in HDMI 2.0 in AVI infoframes to sinks that
+ * conform to HDMI 1.4.
+ *
+ * HDMI 1.4 (CTA-861-D) VIC range: [1..64]
+ * HDMI 2.0 (CTA-861-F) VIC range: [1..107]
+ */
+static u8 vic_for_avi_infoframe(const struct drm_connector *connector, u8 vic)
+{
 	if (!is_hdmi2_sink(connector) && vic > 64)
 		return 0;
 
@@ -5653,7 +5656,7 @@ drm_hdmi_avi_infoframe_from_display_mode
 		picture_aspect = HDMI_PICTURE_ASPECT_NONE;
 	}
 
-	frame->video_code = vic;
+	frame->video_code = vic_for_avi_infoframe(connector, vic);
 	frame->picture_aspect = picture_aspect;
 	frame->active_aspect = HDMI_ACTIVE_ASPECT_PICTURE;
 	frame->scan_mode = HDMI_SCAN_MODE_UNDERSCAN;


