Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0024594839
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241621AbiHOXns (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354331AbiHOXlx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:41:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69CA72C672;
        Mon, 15 Aug 2022 13:12:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05A296077B;
        Mon, 15 Aug 2022 20:12:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8188C433C1;
        Mon, 15 Aug 2022 20:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594369;
        bh=sdstJ24h+dK4SR3BtZSPOno5cdMvKfXM0mvbYIJmKDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yLUtRlyc4z8ijqEV8kkwaSYZXrsllUdL3ZZ4LFGOJVWoTMC3subm+1Q0+KKaxX3Na
         CNpALjgG3xfYXyLxL4QuiD08mwdjPYYgMIRHAzsbKYzfGwMhH6gAPZAstpdnuBGNDy
         p/2n5kOgt/C+o9pmO0/f5UPDDOVorIwQrMArX5x0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0424/1157] drm/vc4: hdmi: Move pixel doubling from Pixelvalve to HDMI block
Date:   Mon, 15 Aug 2022 19:56:20 +0200
Message-Id: <20220815180456.623861810@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index b2628afcb327..af0fcb41e420 100644
--- a/drivers/gpu/drm/vc4/vc4_crtc.c
+++ b/drivers/gpu/drm/vc4/vc4_crtc.c
@@ -316,7 +316,9 @@ static void vc4_crtc_config_pv(struct drm_crtc *crtc, struct drm_encoder *encode
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
index ad7fcfa5a068..23ff6aa5e8f6 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -79,6 +79,8 @@
 #define VC5_HDMI_VERTB_VSPO_SHIFT		16
 #define VC5_HDMI_VERTB_VSPO_MASK		VC4_MASK(29, 16)
 
+#define VC4_HDMI_MISC_CONTROL_PIXEL_REP_SHIFT	0
+#define VC4_HDMI_MISC_CONTROL_PIXEL_REP_MASK	VC4_MASK(3, 0)
 #define VC5_HDMI_MISC_CONTROL_PIXEL_REP_SHIFT	0
 #define VC5_HDMI_MISC_CONTROL_PIXEL_REP_MASK	VC4_MASK(3, 0)
 
@@ -996,6 +998,7 @@ static void vc4_hdmi_set_timings(struct vc4_hdmi *vc4_hdmi,
 					mode->crtc_vsync_end,
 					VC4_HDMI_VERTB_VBP));
 	unsigned long flags;
+	u32 reg;
 
 	spin_lock_irqsave(&vc4_hdmi->hw_lock, flags);
 
@@ -1022,6 +1025,11 @@ static void vc4_hdmi_set_timings(struct vc4_hdmi *vc4_hdmi,
 	HDMI_WRITE(HDMI_VERTB0, vertb_even);
 	HDMI_WRITE(HDMI_VERTB1, vertb);
 
+	reg = HDMI_READ(HDMI_MISC_CONTROL);
+	reg &= ~VC4_HDMI_MISC_CONTROL_PIXEL_REP_MASK;
+	reg |= VC4_SET_FIELD(pixel_rep - 1, VC4_HDMI_MISC_CONTROL_PIXEL_REP);
+	HDMI_WRITE(HDMI_MISC_CONTROL, reg);
+
 	spin_unlock_irqrestore(&vc4_hdmi->hw_lock, flags);
 }
 
@@ -1122,7 +1130,7 @@ static void vc5_hdmi_set_timings(struct vc4_hdmi *vc4_hdmi,
 
 	reg = HDMI_READ(HDMI_MISC_CONTROL);
 	reg &= ~VC5_HDMI_MISC_CONTROL_PIXEL_REP_MASK;
-	reg |= VC4_SET_FIELD(0, VC5_HDMI_MISC_CONTROL_PIXEL_REP);
+	reg |= VC4_SET_FIELD(pixel_rep - 1, VC5_HDMI_MISC_CONTROL_PIXEL_REP);
 	HDMI_WRITE(HDMI_MISC_CONTROL, reg);
 
 	HDMI_WRITE(HDMI_CLOCK_STOP, 0);
@@ -1632,11 +1640,25 @@ static int vc4_hdmi_encoder_atomic_check(struct drm_encoder *encoder,
 	unsigned long long tmds_bit_rate;
 	int ret;
 
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



