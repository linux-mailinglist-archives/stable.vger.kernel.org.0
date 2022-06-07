Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8170B5412E6
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357134AbiFGTy6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358480AbiFGTwc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:52:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD5BB15C8A0;
        Tue,  7 Jun 2022 11:20:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89B0DB8237D;
        Tue,  7 Jun 2022 18:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05BCC385A2;
        Tue,  7 Jun 2022 18:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626041;
        bh=wlau1dshHNRQvKJUZTXil8xlx3EVVAG/4k/WKwapXEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mUXyPmXgPQM8s3EWKiINmmnaycYK37+buthsMYKEGe7DFYKqZzYU2LPmZZJFGzqdS
         jhsPA1RXmvbxKK2QfbO1g9jI4dV61bbQN0zcc6XDgF57ZJ9gqdGvY1br2H8qyYCZcL
         ugcCm9wIy6UECgUq/nJt38DQmOg/r1NYgepZ6cYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Marek Vasut <marex@denx.de>,
        Jagan Teki <jagan@amarulasolutions.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 236/772] drm: bridge: icn6211: Fix HFP_HSW_HBP_HI and HFP_MIN handling
Date:   Tue,  7 Jun 2022 18:57:08 +0200
Message-Id: <20220607164955.986367106@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit c0ff7a649d62105a9308cc3ac36e52a4669d9cb4 ]

The HFP_HSW_HBP_HI register must be programmed with 2 LSbits of each
Horizontal Front Porch/Sync/Back Porch. Currently the driver programs
this register to 0, which breaks displays with either value above 255.

The HFP_MIN register must be set to the same value as HFP_LI, otherwise
there is visible image distortion, usually in the form of missing lines
at the bottom of the panel.

Fix this by correctly programming the HFP_HSW_HBP_HI and HFP_MIN registers.

Acked-by: Maxime Ripard <maxime@cerno.tech>
Fixes: ce517f18944e3 ("drm: bridge: Add Chipone ICN6211 MIPI-DSI to RGB bridge")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Jagan Teki <jagan@amarulasolutions.com>
Cc: Maxime Ripard <maxime@cerno.tech>
Cc: Robert Foss <robert.foss@linaro.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
To: dri-devel@lists.freedesktop.org
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220331150509.9838-3-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/chipone-icn6211.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/bridge/chipone-icn6211.c b/drivers/gpu/drm/bridge/chipone-icn6211.c
index eb26615b2993..d7eedf35e841 100644
--- a/drivers/gpu/drm/bridge/chipone-icn6211.c
+++ b/drivers/gpu/drm/bridge/chipone-icn6211.c
@@ -34,6 +34,9 @@
 #define HSYNC_LI		0x24
 #define HBP_LI			0x25
 #define HFP_HSW_HBP_HI		0x26
+#define HFP_HSW_HBP_HI_HFP(n)		(((n) & 0x300) >> 4)
+#define HFP_HSW_HBP_HI_HS(n)		(((n) & 0x300) >> 6)
+#define HFP_HSW_HBP_HI_HBP(n)		(((n) & 0x300) >> 8)
 #define VFP			0x27
 #define VSYNC			0x28
 #define VBP			0x29
@@ -165,6 +168,7 @@ static void chipone_enable(struct drm_bridge *bridge)
 {
 	struct chipone *icn = bridge_to_chipone(bridge);
 	struct drm_display_mode *mode = bridge_to_mode(bridge);
+	u16 hfp, hbp, hsync;
 
 	ICN6211_DSI(icn, MIPI_CFG_PW, MIPI_CFG_PW_CONFIG_DSI);
 
@@ -180,13 +184,18 @@ static void chipone_enable(struct drm_bridge *bridge)
 		    ((mode->hdisplay >> 8) & 0xf) |
 		    (((mode->vdisplay >> 8) & 0xf) << 4));
 
-	ICN6211_DSI(icn, HFP_LI, mode->hsync_start - mode->hdisplay);
+	hfp = mode->hsync_start - mode->hdisplay;
+	hsync = mode->hsync_end - mode->hsync_start;
+	hbp = mode->htotal - mode->hsync_end;
 
-	ICN6211_DSI(icn, HSYNC_LI, mode->hsync_end - mode->hsync_start);
-
-	ICN6211_DSI(icn, HBP_LI, mode->htotal - mode->hsync_end);
-
-	ICN6211_DSI(icn, HFP_HSW_HBP_HI, 0x00);
+	ICN6211_DSI(icn, HFP_LI, hfp & 0xff);
+	ICN6211_DSI(icn, HSYNC_LI, hsync & 0xff);
+	ICN6211_DSI(icn, HBP_LI, hbp & 0xff);
+	/* Top two bits of Horizontal Front porch/Sync/Back porch */
+	ICN6211_DSI(icn, HFP_HSW_HBP_HI,
+		    HFP_HSW_HBP_HI_HFP(hfp) |
+		    HFP_HSW_HBP_HI_HS(hsync) |
+		    HFP_HSW_HBP_HI_HBP(hbp));
 
 	ICN6211_DSI(icn, VFP, mode->vsync_start - mode->vdisplay);
 
@@ -196,7 +205,7 @@ static void chipone_enable(struct drm_bridge *bridge)
 
 	/* dsi specific sequence */
 	ICN6211_DSI(icn, SYNC_EVENT_DLY, 0x80);
-	ICN6211_DSI(icn, HFP_MIN, 0x28);
+	ICN6211_DSI(icn, HFP_MIN, hfp & 0xff);
 	ICN6211_DSI(icn, MIPI_PD_CK_LANE, 0xa0);
 	ICN6211_DSI(icn, PLL_CTRL(12), 0xff);
 	ICN6211_DSI(icn, BIST_POL, BIST_POL_DE_POL);
-- 
2.35.1



