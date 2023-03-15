Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 469BA6BB085
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbjCOMTE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232053AbjCOMTA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:19:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88282200B
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:18:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E194761ABD
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:18:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A87C433D2;
        Wed, 15 Mar 2023 12:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882717;
        bh=xo4/8iwFxjaoFHVurbxZyRa9EWRHfS/CkAbZWLGjUwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=te6O7JcRhwVkrSU1C+eq69JlXTUbZd9kb0zbARwywaefGQikOGFn9abnkJo64TZzv
         KDoF08lLQ71t8Q14rKhUu7to2KTZ2p9awEyFFMArnGsFmYs/I/Ub+uZbO+6lEcgrtP
         +hm2h43W1nAYJyhs9ehif4wwwO9bqx8T8EEHEvPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, William Tseng <william.tseng@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 13/68] drm/edid: fix AVI infoframe aspect ratio handling
Date:   Wed, 15 Mar 2023 13:12:07 +0100
Message-Id: <20230315115726.625101321@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115726.103942885@linuxfoundation.org>
References: <20230315115726.103942885@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit 1cbc1f0d324ba6c4d1b10ac6362b5e0b029f63d5 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_edid.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index f9735861741c1..2e73042e5d070 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -5095,8 +5095,6 @@ static u8 drm_mode_hdmi_vic(struct drm_connector *connector,
 static u8 drm_mode_cea_vic(struct drm_connector *connector,
 			   const struct drm_display_mode *mode)
 {
-	u8 vic;
-
 	/*
 	 * HDMI spec says if a mode is found in HDMI 1.4b 4K modes
 	 * we should send its VIC in vendor infoframes, else send the
@@ -5106,13 +5104,18 @@ static u8 drm_mode_cea_vic(struct drm_connector *connector,
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
 
@@ -5191,7 +5194,7 @@ drm_hdmi_avi_infoframe_from_display_mode(struct hdmi_avi_infoframe *frame,
 		picture_aspect = HDMI_PICTURE_ASPECT_NONE;
 	}
 
-	frame->video_code = vic;
+	frame->video_code = vic_for_avi_infoframe(connector, vic);
 	frame->picture_aspect = picture_aspect;
 	frame->active_aspect = HDMI_ACTIVE_ASPECT_PICTURE;
 	frame->scan_mode = HDMI_SCAN_MODE_UNDERSCAN;
-- 
2.39.2



