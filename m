Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B0F409487
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343753AbhIMObp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:31:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:51346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347084AbhIMOaN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:30:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 044D2615E1;
        Mon, 13 Sep 2021 13:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541065;
        bh=pOh5xUDiTV61O+uQgj+boLTw7u9thlar7oAAdqAFvVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1DC8TsrN31uczEvPq4aYx3UAqaAIvvbLoR8Ns4HCchD+NwaAhIy4upgOQyeOv9eDw
         prlx0LsHoLucpcW3FddPZyidPVa+lIeHPIatr/1nKQw1lVS4CwaopNk7w5OL9ahk+p
         MXfrOy9JFCs3uBuy6+TsNl6ZBhII8Fn5ygxXkUr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jagan Teki <jagan@amarulasolutions.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 149/334] drm/bridge: ti-sn65dsi86: Wrap panel with panel-bridge
Date:   Mon, 13 Sep 2021 15:13:23 +0200
Message-Id: <20210913131118.396364303@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

[ Upstream commit 4e5763f03e105fedfcd7a83bec1dccae96e334dd ]

To simplify interfacing with the panel, wrap it in a panel-bridge and
let the DRM bridge helpers handle chaining of operations.

This also prepares for support of DRM_BRIDGE_ATTACH_NO_CONNECTOR, which
requires all components in the display pipeline to be represented by
bridges.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Jagan Teki <jagan@amarulasolutions.com>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210624000304.16281-5-laurent.pinchart+renesas@ideasonboard.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-sn65dsi86.c | 32 +++++++++++++++++----------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi86.c b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
index 4d1483cf7b58..970a4859eea3 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi86.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
@@ -125,7 +125,7 @@
  * @host_node:    Remote DSI node.
  * @dsi:          Our MIPI DSI source.
  * @refclk:       Our reference clock.
- * @panel:        Our panel.
+ * @next_bridge:  The bridge on the eDP side.
  * @enable_gpio:  The GPIO we toggle to enable the bridge.
  * @supplies:     Data for bulk enabling/disabling our regulators.
  * @dp_lanes:     Count of dp_lanes we're using.
@@ -156,7 +156,7 @@ struct ti_sn65dsi86 {
 	struct device_node		*host_node;
 	struct mipi_dsi_device		*dsi;
 	struct clk			*refclk;
-	struct drm_panel		*panel;
+	struct drm_bridge		*next_bridge;
 	struct gpio_desc		*enable_gpio;
 	struct regulator_bulk_data	supplies[SN_REGULATOR_SUPPLY_NUM];
 	int				dp_lanes;
@@ -401,7 +401,8 @@ connector_to_ti_sn65dsi86(struct drm_connector *connector)
 static int ti_sn_bridge_connector_get_modes(struct drm_connector *connector)
 {
 	struct ti_sn65dsi86 *pdata = connector_to_ti_sn65dsi86(connector);
-	return drm_panel_get_modes(pdata->panel, connector);
+
+	return drm_bridge_get_modes(pdata->next_bridge, connector);
 }
 
 static enum drm_mode_status
@@ -527,8 +528,16 @@ static int ti_sn_bridge_attach(struct drm_bridge *bridge,
 	}
 	pdata->dsi = dsi;
 
+	/* Attach the next bridge */
+	ret = drm_bridge_attach(bridge->encoder, pdata->next_bridge,
+				&pdata->bridge, flags);
+	if (ret < 0)
+		goto err_dsi_detach;
+
 	return 0;
 
+err_dsi_detach:
+	mipi_dsi_detach(dsi);
 err_dsi_attach:
 	mipi_dsi_device_unregister(dsi);
 err_dsi_host:
@@ -547,8 +556,6 @@ static void ti_sn_bridge_disable(struct drm_bridge *bridge)
 {
 	struct ti_sn65dsi86 *pdata = bridge_to_ti_sn65dsi86(bridge);
 
-	drm_panel_disable(pdata->panel);
-
 	/* disable video stream */
 	regmap_update_bits(pdata->regmap, SN_ENH_FRAME_REG, VSTREAM_ENABLE, 0);
 	/* semi auto link training mode OFF */
@@ -873,8 +880,6 @@ static void ti_sn_bridge_enable(struct drm_bridge *bridge)
 	/* enable video stream */
 	regmap_update_bits(pdata->regmap, SN_ENH_FRAME_REG, VSTREAM_ENABLE,
 			   VSTREAM_ENABLE);
-
-	drm_panel_enable(pdata->panel);
 }
 
 static void ti_sn_bridge_pre_enable(struct drm_bridge *bridge)
@@ -885,16 +890,12 @@ static void ti_sn_bridge_pre_enable(struct drm_bridge *bridge)
 
 	if (!pdata->refclk)
 		ti_sn65dsi86_enable_comms(pdata);
-
-	drm_panel_prepare(pdata->panel);
 }
 
 static void ti_sn_bridge_post_disable(struct drm_bridge *bridge)
 {
 	struct ti_sn65dsi86 *pdata = bridge_to_ti_sn65dsi86(bridge);
 
-	drm_panel_unprepare(pdata->panel);
-
 	if (!pdata->refclk)
 		ti_sn65dsi86_disable_comms(pdata);
 
@@ -1299,13 +1300,20 @@ static int ti_sn_bridge_probe(struct auxiliary_device *adev,
 {
 	struct ti_sn65dsi86 *pdata = dev_get_drvdata(adev->dev.parent);
 	struct device_node *np = pdata->dev->of_node;
+	struct drm_panel *panel;
 	int ret;
 
-	ret = drm_of_find_panel_or_bridge(np, 1, 0, &pdata->panel, NULL);
+	ret = drm_of_find_panel_or_bridge(np, 1, 0, &panel, NULL);
 	if (ret)
 		return dev_err_probe(&adev->dev, ret,
 				     "could not find any panel node\n");
 
+	pdata->next_bridge = devm_drm_panel_bridge_add(pdata->dev, panel);
+	if (IS_ERR(pdata->next_bridge)) {
+		DRM_ERROR("failed to create panel bridge\n");
+		return PTR_ERR(pdata->next_bridge);
+	}
+
 	ti_sn_bridge_parse_lanes(pdata, np);
 
 	ret = ti_sn_bridge_parse_dsi_host(pdata);
-- 
2.30.2



