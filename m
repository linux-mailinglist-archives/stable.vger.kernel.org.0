Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B337594100
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240624AbiHOVJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347860AbiHOVHl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:07:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C62D86C2;
        Mon, 15 Aug 2022 12:16:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DFFD6009B;
        Mon, 15 Aug 2022 19:16:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351B5C433C1;
        Mon, 15 Aug 2022 19:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590974;
        bh=P0ta2E98eViqb8E8o8a6Gqzg4ZfJXdlI8NtXdE30U5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JsKG+VYue/nxXPcnqh62ioxLtNzF0rTjIIo96BqKaqYzzKBH6aVDdEf/YQGi2kcwR
         nDsojK0j9GvYQRuJ/HV6H5sSUn8w0XQiNp3p0oWyYuwTK1NA3ywUlwDPwp8k6VpvZk
         rYACe5TLi32/X71ZBES1SV+rBsN/slIucQExSt5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0400/1095] drm/vc4: hdmi: Move pixel doubling from Pixelvalve to HDMI block
Date:   Mon, 15 Aug 2022 19:56:39 +0200
Message-Id: <20220815180446.242731488@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit 3650062e4281ab28a6f8c9d59606d0a6266be736 ]

With the change to 2 pixels/clock, the pixel doubling in the PV
results in doubling each pair of pixels, ie ABABCDCD instead of
AABBCCDD.

Move the pixel doubling to the HDMI block, however this means
that DBLCLK modes now fall foul of requiring even values for
all the horizontal timing parameters.
As both 480i and 576i fail this, attempt to fix up DBLCLK modes
that have odd timings values.

Fixes: 8323989140f3 ("drm/vc4: hdmi: Support the BCM2711 HDMI controllers")
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Link: https://lore.kernel.org/r/20220613144800.326124-34-maxime@cerno.tech
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_crtc.c |  4 +++-
 drivers/gpu/drm/vc4/vc4_hdmi.c | 34 ++++++++++++++++++++++++++++------
 2 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_crtc.c b/drivers/gpu/drm/vc4/vc4_crtc.c
index 2810b0d9e78c..18e2a246f7c1 100644
--- a/drivers/gpu/drm/vc4/vc4_crtc.c
+++ b/drivers/gpu/drm/vc4/vc4_crtc.c
@@ -314,7 +314,9 @@ static void vc4_crtc_config_pv(struct drm_crtc *crtc, struct drm_encoder *encode
 	struct drm_crtc_state *crtc_state = crtc->state;
 	struct drm_display_mode *mode = &crtc_state->adjusted_mode;
 	bool interlace = mode->flags & DRM_MODE_FLAG_INTERLACE;
-	u32 pixel_rep = (mode->flags & DRM_MODE_FLAG_DBLCLK) ? 2 : 1;
+	bool is_hdmi = vc4_encoder->type == VC4_ENCODER_TYPE_HDMI0 ||
+		       vc4_encoder->type == VC4_ENCODER_TYPE_HDMI1;
+	u32 pixel_rep = ((mode->flags & DRM_MODE_FLAG_DBLCLK) && !is_hdmi) ? 2 : 1;
 	bool is_dsi = (vc4_encoder->type == VC4_ENCODER_TYPE_DSI0 ||
 		       vc4_encoder->type == VC4_ENCODER_TYPE_DSI1);
 	bool is_dsi1 = vc4_encoder->type == VC4_ENCODER_TYPE_DSI1;
diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index f7781d171687..8b1e52145082 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -79,6 +79,8 @@
 #define VC5_HDMI_VERTB_VSPO_SHIFT		16
 #define VC5_HDMI_VERTB_VSPO_MASK		VC4_MASK(29, 16)
 
+#define VC4_HDMI_MISC_CONTROL_PIXEL_REP_SHIFT	0
+#define VC4_HDMI_MISC_CONTROL_PIXEL_REP_MASK	VC4_MASK(3, 0)
 #define VC5_HDMI_MISC_CONTROL_PIXEL_REP_SHIFT	0
 #define VC5_HDMI_MISC_CONTROL_PIXEL_REP_MASK	VC4_MASK(3, 0)
 
@@ -878,6 +880,7 @@ static void vc4_hdmi_set_timings(struct vc4_hdmi *vc4_hdmi,
 					mode->crtc_vsync_end,
 					VC4_HDMI_VERTB_VBP));
 	unsigned long flags;
+	u32 reg;
 
 	spin_lock_irqsave(&vc4_hdmi->hw_lock, flags);
 
@@ -904,6 +907,11 @@ static void vc4_hdmi_set_timings(struct vc4_hdmi *vc4_hdmi,
 	HDMI_WRITE(HDMI_VERTB0, vertb_even);
 	HDMI_WRITE(HDMI_VERTB1, vertb);
 
+	reg = HDMI_READ(HDMI_MISC_CONTROL);
+	reg &= ~VC4_HDMI_MISC_CONTROL_PIXEL_REP_MASK;
+	reg |= VC4_SET_FIELD(pixel_rep - 1, VC4_HDMI_MISC_CONTROL_PIXEL_REP);
+	HDMI_WRITE(HDMI_MISC_CONTROL, reg);
+
 	spin_unlock_irqrestore(&vc4_hdmi->hw_lock, flags);
 }
 
@@ -993,7 +1001,7 @@ static void vc5_hdmi_set_timings(struct vc4_hdmi *vc4_hdmi,
 
 	reg = HDMI_READ(HDMI_MISC_CONTROL);
 	reg &= ~VC5_HDMI_MISC_CONTROL_PIXEL_REP_MASK;
-	reg |= VC4_SET_FIELD(0, VC5_HDMI_MISC_CONTROL_PIXEL_REP);
+	reg |= VC4_SET_FIELD(pixel_rep - 1, VC5_HDMI_MISC_CONTROL_PIXEL_REP);
 	HDMI_WRITE(HDMI_MISC_CONTROL, reg);
 
 	HDMI_WRITE(HDMI_CLOCK_STOP, 0);
@@ -1276,11 +1284,25 @@ static int vc4_hdmi_encoder_atomic_check(struct drm_encoder *encoder,
 	unsigned long long pixel_rate = mode->clock * 1000;
 	unsigned long long tmds_rate;
 
-	if (vc4_hdmi->variant->unsupported_odd_h_timings &&
-	    !(mode->flags & DRM_MODE_FLAG_DBLCLK) &&
-	    ((mode->hdisplay % 2) || (mode->hsync_start % 2) ||
-	     (mode->hsync_end % 2) || (mode->htotal % 2)))
-		return -EINVAL;
+	if (vc4_hdmi->variant->unsupported_odd_h_timings) {
+		if (mode->flags & DRM_MODE_FLAG_DBLCLK) {
+			/* Only try to fixup DBLCLK modes to get 480i and 576i
+			 * working.
+			 * A generic solution for all modes with odd horizontal
+			 * timing values seems impossible based on trying to
+			 * solve it for 1366x768 monitors.
+			 */
+			if ((mode->hsync_start - mode->hdisplay) & 1)
+				mode->hsync_start--;
+			if ((mode->hsync_end - mode->hsync_start) & 1)
+				mode->hsync_end--;
+		}
+
+		/* Now check whether we still have odd values remaining */
+		if ((mode->hdisplay % 2) || (mode->hsync_start % 2) ||
+		    (mode->hsync_end % 2) || (mode->htotal % 2))
+			return -EINVAL;
+	}
 
 	/*
 	 * The 1440p@60 pixel rate is in the same range than the first
-- 
2.35.1



