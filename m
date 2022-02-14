Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553154B4A8C
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347305AbiBNKcM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:32:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347634AbiBNKbR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:31:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 049BE9FACE;
        Mon, 14 Feb 2022 02:00:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3ABBC60B33;
        Mon, 14 Feb 2022 09:59:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B75C340E9;
        Mon, 14 Feb 2022 09:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832791;
        bh=tPEjF7F9Mz+qnlVTN+3+8I9Hs7K5Y+z4WT9v7HTWFkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kDcV5DdPntsEXiuM8FBTTjqL31K+IxK/d+PUxAvHnvlLC2ixAfS7/21S7WYRDcIlz
         VjLmwwJ0DBhR0CBEawClGV8E//QhRBQRGe+Gz9xsotRGQ8FQl2E2hsp/CBd7jywz4d
         R2NtOV4kfPpD+aBafwJ9+8eYtxLeipFwimdSo6QI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrzej Hajda <andrzej.hajda@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Liu Ying <victor.liu@nxp.com>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        =?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>
Subject: [PATCH 5.16 108/203] phy: dphy: Correct clk_pre parameter
Date:   Mon, 14 Feb 2022 10:25:52 +0100
Message-Id: <20220214092513.916358236@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Ying <victor.liu@nxp.com>

[ Upstream commit 9a8406ba1a9a2965c27e0db1d7753471d12ee9ff ]

The D-PHY specification (v1.2) explicitly mentions that the T-CLK-PRE
parameter's unit is Unit Interval(UI) and the minimum value is 8.  Also,
kernel doc of the 'clk_pre' member of struct phy_configure_opts_mipi_dphy
mentions that it should be in UI.  However, the dphy core driver wrongly
sets 'clk_pre' to 8000, which seems to hint that it's in picoseconds.

So, let's fix the dphy core driver to correctly reflect the T-CLK-PRE
parameter's minimum value according to the D-PHY specification.

I'm assuming that all impacted custom drivers shall program values in
TxByteClkHS cycles into hardware for the T-CLK-PRE parameter.  The D-PHY
specification mentions that the frequency of TxByteClkHS is exactly 1/8
the High-Speed(HS) bit rate(each HS bit consumes one UI).  So, relevant
custom driver code is changed to program those values as
DIV_ROUND_UP(cfg->clk_pre, BITS_PER_BYTE), then.

Note that I've only tested the patch with RM67191 DSI panel on i.MX8mq EVK.
Help is needed to test with other i.MX8mq, Meson and Rockchip platforms,
as I don't have the hardwares.

Fixes: 2ed869990e14 ("phy: Add MIPI D-PHY configuration options")
Tested-by: Liu Ying <victor.liu@nxp.com> # RM67191 DSI panel on i.MX8mq EVK
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com> # for phy-meson-axg-mipi-dphy.c
Tested-by: Neil Armstrong <narmstrong@baylibre.com> # for phy-meson-axg-mipi-dphy.c
Tested-by: Guido Günther <agx@sigxcpu.org> # Librem 5 (imx8mq) with it's rather picky panel
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Liu Ying <victor.liu@nxp.com>
Link: https://lore.kernel.org/r/20220124024007.1465018-1-victor.liu@nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/nwl-dsi.c                 | 12 +++++-------
 drivers/phy/amlogic/phy-meson-axg-mipi-dphy.c    |  3 ++-
 drivers/phy/phy-core-mipi-dphy.c                 |  4 ++--
 drivers/phy/rockchip/phy-rockchip-inno-dsidphy.c |  3 ++-
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/bridge/nwl-dsi.c b/drivers/gpu/drm/bridge/nwl-dsi.c
index a7389a0facfb4..af07eeb47ca02 100644
--- a/drivers/gpu/drm/bridge/nwl-dsi.c
+++ b/drivers/gpu/drm/bridge/nwl-dsi.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/bitfield.h>
+#include <linux/bits.h>
 #include <linux/clk.h>
 #include <linux/irq.h>
 #include <linux/math64.h>
@@ -196,12 +197,9 @@ static u32 ps2bc(struct nwl_dsi *dsi, unsigned long long ps)
 /*
  * ui2bc - UI time periods to byte clock cycles
  */
-static u32 ui2bc(struct nwl_dsi *dsi, unsigned long long ui)
+static u32 ui2bc(unsigned int ui)
 {
-	u32 bpp = mipi_dsi_pixel_format_to_bpp(dsi->format);
-
-	return DIV64_U64_ROUND_UP(ui * dsi->lanes,
-				  dsi->mode.clock * 1000 * bpp);
+	return DIV_ROUND_UP(ui, BITS_PER_BYTE);
 }
 
 /*
@@ -232,12 +230,12 @@ static int nwl_dsi_config_host(struct nwl_dsi *dsi)
 	}
 
 	/* values in byte clock cycles */
-	cycles = ui2bc(dsi, cfg->clk_pre);
+	cycles = ui2bc(cfg->clk_pre);
 	DRM_DEV_DEBUG_DRIVER(dsi->dev, "cfg_t_pre: 0x%x\n", cycles);
 	nwl_dsi_write(dsi, NWL_DSI_CFG_T_PRE, cycles);
 	cycles = ps2bc(dsi, cfg->lpx + cfg->clk_prepare + cfg->clk_zero);
 	DRM_DEV_DEBUG_DRIVER(dsi->dev, "cfg_tx_gap (pre): 0x%x\n", cycles);
-	cycles += ui2bc(dsi, cfg->clk_pre);
+	cycles += ui2bc(cfg->clk_pre);
 	DRM_DEV_DEBUG_DRIVER(dsi->dev, "cfg_t_post: 0x%x\n", cycles);
 	nwl_dsi_write(dsi, NWL_DSI_CFG_T_POST, cycles);
 	cycles = ps2bc(dsi, cfg->hs_exit);
diff --git a/drivers/phy/amlogic/phy-meson-axg-mipi-dphy.c b/drivers/phy/amlogic/phy-meson-axg-mipi-dphy.c
index cd2332bf0e31a..fdbd64c03e12b 100644
--- a/drivers/phy/amlogic/phy-meson-axg-mipi-dphy.c
+++ b/drivers/phy/amlogic/phy-meson-axg-mipi-dphy.c
@@ -9,6 +9,7 @@
 
 #include <linux/bitfield.h>
 #include <linux/bitops.h>
+#include <linux/bits.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/io.h>
@@ -250,7 +251,7 @@ static int phy_meson_axg_mipi_dphy_power_on(struct phy *phy)
 		     (DIV_ROUND_UP(priv->config.clk_zero, temp) << 16) |
 		     (DIV_ROUND_UP(priv->config.clk_prepare, temp) << 24));
 	regmap_write(priv->regmap, MIPI_DSI_CLK_TIM1,
-		     DIV_ROUND_UP(priv->config.clk_pre, temp));
+		     DIV_ROUND_UP(priv->config.clk_pre, BITS_PER_BYTE));
 
 	regmap_write(priv->regmap, MIPI_DSI_HS_TIM,
 		     DIV_ROUND_UP(priv->config.hs_exit, temp) |
diff --git a/drivers/phy/phy-core-mipi-dphy.c b/drivers/phy/phy-core-mipi-dphy.c
index 288c9c67aa748..ccb4045685cdd 100644
--- a/drivers/phy/phy-core-mipi-dphy.c
+++ b/drivers/phy/phy-core-mipi-dphy.c
@@ -36,7 +36,7 @@ int phy_mipi_dphy_get_default_config(unsigned long pixel_clock,
 
 	cfg->clk_miss = 0;
 	cfg->clk_post = 60000 + 52 * ui;
-	cfg->clk_pre = 8000;
+	cfg->clk_pre = 8;
 	cfg->clk_prepare = 38000;
 	cfg->clk_settle = 95000;
 	cfg->clk_term_en = 0;
@@ -97,7 +97,7 @@ int phy_mipi_dphy_config_validate(struct phy_configure_opts_mipi_dphy *cfg)
 	if (cfg->clk_post < (60000 + 52 * ui))
 		return -EINVAL;
 
-	if (cfg->clk_pre < 8000)
+	if (cfg->clk_pre < 8)
 		return -EINVAL;
 
 	if (cfg->clk_prepare < 38000 || cfg->clk_prepare > 95000)
diff --git a/drivers/phy/rockchip/phy-rockchip-inno-dsidphy.c b/drivers/phy/rockchip/phy-rockchip-inno-dsidphy.c
index 347dc79a18c18..630e01b5c19b9 100644
--- a/drivers/phy/rockchip/phy-rockchip-inno-dsidphy.c
+++ b/drivers/phy/rockchip/phy-rockchip-inno-dsidphy.c
@@ -5,6 +5,7 @@
  * Author: Wyon Bi <bivvy.bi@rock-chips.com>
  */
 
+#include <linux/bits.h>
 #include <linux/kernel.h>
 #include <linux/clk.h>
 #include <linux/iopoll.h>
@@ -364,7 +365,7 @@ static void inno_dsidphy_mipi_mode_enable(struct inno_dsidphy *inno)
 	 * The value of counter for HS Tclk-pre
 	 * Tclk-pre = Tpin_txbyteclkhs * value
 	 */
-	clk_pre = DIV_ROUND_UP(cfg->clk_pre, t_txbyteclkhs);
+	clk_pre = DIV_ROUND_UP(cfg->clk_pre, BITS_PER_BYTE);
 
 	/*
 	 * The value of counter for HS Tlpx Time
-- 
2.34.1



