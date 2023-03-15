Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 225086BB06E
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbjCOMSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232056AbjCOMR7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:17:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADFF28B321
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:17:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0763161ABD
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:17:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A89FC4331D;
        Wed, 15 Mar 2023 12:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882675;
        bh=4kTsIwueTSgRPB/AFJahT6yK3JEXtmH6kz+px2rXK5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I3bjGIxtqFXPOmDnd+Wln3xuudGio201Pnoge4+cRYE1AGWY99q6G2uXADTH8FWJR
         fjx+RndnZO30CLgWKdiLZKQb3iWuVRImuw1suu453D6rSTbDWq3GCh1OXHEW/ujHbN
         4JHf2feqnmvJ8dkEtG/+W6UfTBYjn+NYkc1v7BkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wayne Lin <waynelin@amd.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Uma Shankar <uma.shankar@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 10/68] drm/edid: Extract drm_mode_cea_vic()
Date:   Wed, 15 Mar 2023 13:12:04 +0100
Message-Id: <20230315115726.498119715@linuxfoundation.org>
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

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit cfd6f8c3a94a96c003a8929b66d6d54181b9420d ]

Extract the logic to compute the final CEA VIC to a small helper.
We'll reorder it a bit to make future modifications more
straightforward. No function changes.

Cc: Wayne Lin <waynelin@amd.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191004141914.20600-2-ville.syrjala@linux.intel.com
Reviewed-by: Uma Shankar <uma.shankar@intel.com>
Stable-dep-of: 1cbc1f0d324b ("drm/edid: fix AVI infoframe aspect ratio handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_edid.c | 53 +++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 2dc6dd6230d76..10eb78b9347e1 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -5065,6 +5065,35 @@ drm_hdmi_infoframe_set_hdr_metadata(struct hdmi_drm_infoframe *frame,
 }
 EXPORT_SYMBOL(drm_hdmi_infoframe_set_hdr_metadata);
 
+static u8 drm_mode_cea_vic(struct drm_connector *connector,
+			   const struct drm_display_mode *mode)
+{
+	u8 vendor_if_vic = drm_match_hdmi_mode(mode);
+	bool is_s3d = mode->flags & DRM_MODE_FLAG_3D_MASK;
+	u8 vic;
+
+	/*
+	 * HDMI spec says if a mode is found in HDMI 1.4b 4K modes
+	 * we should send its VIC in vendor infoframes, else send the
+	 * VIC in AVI infoframes. Lets check if this mode is present in
+	 * HDMI 1.4b 4K modes
+	 */
+	if (drm_valid_hdmi_vic(vendor_if_vic) && !is_s3d)
+		return 0;
+
+	vic = drm_match_cea_mode(mode);
+
+	/*
+	 * HDMI 1.4 VIC range: 1 <= VIC <= 64 (CEA-861-D) but
+	 * HDMI 2.0 VIC range: 1 <= VIC <= 107 (CEA-861-F). So we
+	 * have to make sure we dont break HDMI 1.4 sinks.
+	 */
+	if (!is_hdmi2_sink(connector) && vic > 64)
+		return 0;
+
+	return vic;
+}
+
 /**
  * drm_hdmi_avi_infoframe_from_display_mode() - fill an HDMI AVI infoframe with
  *                                              data from a DRM display mode
@@ -5092,29 +5121,7 @@ drm_hdmi_avi_infoframe_from_display_mode(struct hdmi_avi_infoframe *frame,
 	if (mode->flags & DRM_MODE_FLAG_DBLCLK)
 		frame->pixel_repeat = 1;
 
-	frame->video_code = drm_match_cea_mode(mode);
-
-	/*
-	 * HDMI 1.4 VIC range: 1 <= VIC <= 64 (CEA-861-D) but
-	 * HDMI 2.0 VIC range: 1 <= VIC <= 107 (CEA-861-F). So we
-	 * have to make sure we dont break HDMI 1.4 sinks.
-	 */
-	if (!is_hdmi2_sink(connector) && frame->video_code > 64)
-		frame->video_code = 0;
-
-	/*
-	 * HDMI spec says if a mode is found in HDMI 1.4b 4K modes
-	 * we should send its VIC in vendor infoframes, else send the
-	 * VIC in AVI infoframes. Lets check if this mode is present in
-	 * HDMI 1.4b 4K modes
-	 */
-	if (frame->video_code) {
-		u8 vendor_if_vic = drm_match_hdmi_mode(mode);
-		bool is_s3d = mode->flags & DRM_MODE_FLAG_3D_MASK;
-
-		if (drm_valid_hdmi_vic(vendor_if_vic) && !is_s3d)
-			frame->video_code = 0;
-	}
+	frame->video_code = drm_mode_cea_vic(connector, mode);
 
 	frame->picture_aspect = HDMI_PICTURE_ASPECT_NONE;
 
-- 
2.39.2



