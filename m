Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C61F194CBC
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 00:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbgCZXZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 19:25:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:46062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728255AbgCZXZQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Mar 2020 19:25:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9AE220409;
        Thu, 26 Mar 2020 23:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585265115;
        bh=VKo7GUQA1DEzSdCU5wZrrVDD4YMnhnpG+D9De3uLcFQ=;
        h=From:To:Cc:Subject:Date:From;
        b=OjUZF0a/99t3Gkb6e7xJ+cO9+MeYALU7Q/Sp5/gkwLpPs44qJ744yPc6afKl697+t
         6J19hNgcYo6Cl8cvzXFJ2r5TSpLCzJXf+dgPuEY63LfLYIg6H3YYmDLVjIRe3Z7vrG
         b3RCAicwggGC8ErOqB+hdWWSqfTAWt5E70LkfzXk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jernej Skrabec <jernej.skrabec@siol.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.14 01/10] drm/bridge: dw-hdmi: fix AVI frame colorimetry
Date:   Thu, 26 Mar 2020 19:25:04 -0400
Message-Id: <20200326232513.8212-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@siol.net>

[ Upstream commit e8dca30f7118461d47e1c3510d0e31b277439151 ]

CTA-861-F explicitly states that for RGB colorspace colorimetry should
be set to "none". Fix that.

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Fixes: def23aa7e982 ("drm: bridge: dw-hdmi: Switch to V4L bus format and encodings")
Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Link: https://patchwork.freedesktop.org/patch/msgid/20200304232512.51616-2-jernej.skrabec@siol.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c | 46 +++++++++++++----------
 1 file changed, 26 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
index cc1094f901255..96cf64d0ee824 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
@@ -1348,28 +1348,34 @@ static void hdmi_config_AVI(struct dw_hdmi *hdmi, struct drm_display_mode *mode)
 		frame.colorspace = HDMI_COLORSPACE_RGB;
 
 	/* Set up colorimetry */
-	switch (hdmi->hdmi_data.enc_out_encoding) {
-	case V4L2_YCBCR_ENC_601:
-		if (hdmi->hdmi_data.enc_in_encoding == V4L2_YCBCR_ENC_XV601)
-			frame.colorimetry = HDMI_COLORIMETRY_EXTENDED;
-		else
+	if (!hdmi_bus_fmt_is_rgb(hdmi->hdmi_data.enc_out_bus_format)) {
+		switch (hdmi->hdmi_data.enc_out_encoding) {
+		case V4L2_YCBCR_ENC_601:
+			if (hdmi->hdmi_data.enc_in_encoding == V4L2_YCBCR_ENC_XV601)
+				frame.colorimetry = HDMI_COLORIMETRY_EXTENDED;
+			else
+				frame.colorimetry = HDMI_COLORIMETRY_ITU_601;
+			frame.extended_colorimetry =
+					HDMI_EXTENDED_COLORIMETRY_XV_YCC_601;
+			break;
+		case V4L2_YCBCR_ENC_709:
+			if (hdmi->hdmi_data.enc_in_encoding == V4L2_YCBCR_ENC_XV709)
+				frame.colorimetry = HDMI_COLORIMETRY_EXTENDED;
+			else
+				frame.colorimetry = HDMI_COLORIMETRY_ITU_709;
+			frame.extended_colorimetry =
+					HDMI_EXTENDED_COLORIMETRY_XV_YCC_709;
+			break;
+		default: /* Carries no data */
 			frame.colorimetry = HDMI_COLORIMETRY_ITU_601;
+			frame.extended_colorimetry =
+					HDMI_EXTENDED_COLORIMETRY_XV_YCC_601;
+			break;
+		}
+	} else {
+		frame.colorimetry = HDMI_COLORIMETRY_NONE;
 		frame.extended_colorimetry =
-				HDMI_EXTENDED_COLORIMETRY_XV_YCC_601;
-		break;
-	case V4L2_YCBCR_ENC_709:
-		if (hdmi->hdmi_data.enc_in_encoding == V4L2_YCBCR_ENC_XV709)
-			frame.colorimetry = HDMI_COLORIMETRY_EXTENDED;
-		else
-			frame.colorimetry = HDMI_COLORIMETRY_ITU_709;
-		frame.extended_colorimetry =
-				HDMI_EXTENDED_COLORIMETRY_XV_YCC_709;
-		break;
-	default: /* Carries no data */
-		frame.colorimetry = HDMI_COLORIMETRY_ITU_601;
-		frame.extended_colorimetry =
-				HDMI_EXTENDED_COLORIMETRY_XV_YCC_601;
-		break;
+			HDMI_EXTENDED_COLORIMETRY_XV_YCC_601;
 	}
 
 	frame.scan_mode = HDMI_SCAN_MODE_NONE;
-- 
2.20.1

