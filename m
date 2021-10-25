Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54E3143A28A
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236142AbhJYTtk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:49:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238012AbhJYTrh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:47:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9579E6121F;
        Mon, 25 Oct 2021 19:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190825;
        bh=CQl8tkXax3fFE35ErFqQ7DKH+g9XyLbaOeLeqgTW3mI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KFYtBItf66cIPCqPnP4IRYN5D2g1/3aCNR/WA3wnsp3GMjoru77Nv8sXTRIHAiIv0
         evkqBTawwhlrqejQILYw2VQEs8s7WquoQ6qExfHmSENtGB3SVy+hOokuciK8DUtf0/
         ucuUnl6LhkupMm4Th1onUuE8DRM5B9uu7XJJZe6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edmund Dea <edmund.j.dea@intel.com>,
        Anitha Chrisanthus <anitha.chrisanthus@intel.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 062/169] drm/kmb: Enable ADV bridge after modeset
Date:   Mon, 25 Oct 2021 21:14:03 +0200
Message-Id: <20211025191025.331968983@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anitha Chrisanthus <anitha.chrisanthus@intel.com>

[ Upstream commit 74056092ff415e7e20ce2544689b32ee811c4f0b ]

On KMB, ADV bridge must be programmed and powered on prior to
MIPI DSI HW initialization.

v2: changed to atomic_bridge_chain_enable (Sam)

Fixes: 98521f4d4b4c ("drm/kmb: Mipi DSI part of the display driver")
Co-developed-by: Edmund Dea <edmund.j.dea@intel.com>
Signed-off-by: Edmund Dea <edmund.j.dea@intel.com>
Signed-off-by: Anitha Chrisanthus <anitha.chrisanthus@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211019230719.789958-1-anitha.chrisanthus@intel.com
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/kmb/kmb_crtc.c | 7 ++++---
 drivers/gpu/drm/kmb/kmb_dsi.c  | 9 +++++----
 drivers/gpu/drm/kmb/kmb_dsi.h  | 2 +-
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/kmb/kmb_crtc.c b/drivers/gpu/drm/kmb/kmb_crtc.c
index 44327bc629ca..4f240466cf63 100644
--- a/drivers/gpu/drm/kmb/kmb_crtc.c
+++ b/drivers/gpu/drm/kmb/kmb_crtc.c
@@ -66,7 +66,8 @@ static const struct drm_crtc_funcs kmb_crtc_funcs = {
 	.disable_vblank = kmb_crtc_disable_vblank,
 };
 
-static void kmb_crtc_set_mode(struct drm_crtc *crtc)
+static void kmb_crtc_set_mode(struct drm_crtc *crtc,
+			      struct drm_atomic_state *old_state)
 {
 	struct drm_device *dev = crtc->dev;
 	struct drm_display_mode *m = &crtc->state->adjusted_mode;
@@ -75,7 +76,7 @@ static void kmb_crtc_set_mode(struct drm_crtc *crtc)
 	unsigned int val = 0;
 
 	/* Initialize mipi */
-	kmb_dsi_mode_set(kmb->kmb_dsi, m, kmb->sys_clk_mhz);
+	kmb_dsi_mode_set(kmb->kmb_dsi, m, kmb->sys_clk_mhz, old_state);
 	drm_info(dev,
 		 "vfp= %d vbp= %d vsync_len=%d hfp=%d hbp=%d hsync_len=%d\n",
 		 m->crtc_vsync_start - m->crtc_vdisplay,
@@ -138,7 +139,7 @@ static void kmb_crtc_atomic_enable(struct drm_crtc *crtc,
 	struct kmb_drm_private *kmb = crtc_to_kmb_priv(crtc);
 
 	clk_prepare_enable(kmb->kmb_clk.clk_lcd);
-	kmb_crtc_set_mode(crtc);
+	kmb_crtc_set_mode(crtc, state);
 	drm_crtc_vblank_on(crtc);
 }
 
diff --git a/drivers/gpu/drm/kmb/kmb_dsi.c b/drivers/gpu/drm/kmb/kmb_dsi.c
index 5bc6c84073a3..756490589e0a 100644
--- a/drivers/gpu/drm/kmb/kmb_dsi.c
+++ b/drivers/gpu/drm/kmb/kmb_dsi.c
@@ -1331,7 +1331,8 @@ static u32 mipi_tx_init_dphy(struct kmb_dsi *kmb_dsi,
 	return 0;
 }
 
-static void connect_lcd_to_mipi(struct kmb_dsi *kmb_dsi)
+static void connect_lcd_to_mipi(struct kmb_dsi *kmb_dsi,
+				struct drm_atomic_state *old_state)
 {
 	struct regmap *msscam;
 
@@ -1340,7 +1341,7 @@ static void connect_lcd_to_mipi(struct kmb_dsi *kmb_dsi)
 		dev_dbg(kmb_dsi->dev, "failed to get msscam syscon");
 		return;
 	}
-
+	drm_atomic_bridge_chain_enable(adv_bridge, old_state);
 	/* DISABLE MIPI->CIF CONNECTION */
 	regmap_write(msscam, MSS_MIPI_CIF_CFG, 0);
 
@@ -1351,7 +1352,7 @@ static void connect_lcd_to_mipi(struct kmb_dsi *kmb_dsi)
 }
 
 int kmb_dsi_mode_set(struct kmb_dsi *kmb_dsi, struct drm_display_mode *mode,
-		     int sys_clk_mhz)
+		     int sys_clk_mhz, struct drm_atomic_state *old_state)
 {
 	u64 data_rate;
 
@@ -1399,7 +1400,7 @@ int kmb_dsi_mode_set(struct kmb_dsi *kmb_dsi, struct drm_display_mode *mode,
 	/* Dphy initialization */
 	mipi_tx_init_dphy(kmb_dsi, &mipi_tx_init_cfg);
 
-	connect_lcd_to_mipi(kmb_dsi);
+	connect_lcd_to_mipi(kmb_dsi, old_state);
 	dev_info(kmb_dsi->dev, "mipi hw initialized");
 
 	return 0;
diff --git a/drivers/gpu/drm/kmb/kmb_dsi.h b/drivers/gpu/drm/kmb/kmb_dsi.h
index 66b7c500d9bc..09dc88743d77 100644
--- a/drivers/gpu/drm/kmb/kmb_dsi.h
+++ b/drivers/gpu/drm/kmb/kmb_dsi.h
@@ -380,7 +380,7 @@ int kmb_dsi_host_bridge_init(struct device *dev);
 struct kmb_dsi *kmb_dsi_init(struct platform_device *pdev);
 void kmb_dsi_host_unregister(struct kmb_dsi *kmb_dsi);
 int kmb_dsi_mode_set(struct kmb_dsi *kmb_dsi, struct drm_display_mode *mode,
-		     int sys_clk_mhz);
+		     int sys_clk_mhz, struct drm_atomic_state *old_state);
 int kmb_dsi_map_mmio(struct kmb_dsi *kmb_dsi);
 int kmb_dsi_clk_init(struct kmb_dsi *kmb_dsi);
 int kmb_dsi_encoder_init(struct drm_device *dev, struct kmb_dsi *kmb_dsi);
-- 
2.33.0



