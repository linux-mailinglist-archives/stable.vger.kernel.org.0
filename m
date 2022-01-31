Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C22EE4A3EE6
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 09:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbiAaIzd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 03:55:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232658AbiAaIzc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 03:55:32 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0628C061714;
        Mon, 31 Jan 2022 00:55:31 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: kholk11)
        with ESMTPSA id 612F11F4302A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1643619330;
        bh=AXf56R+mRkAxLE1emIJ+KeI2b8KNGh0WluiTdMOniaQ=;
        h=From:To:Cc:Subject:Date:From;
        b=HOJE3bKxURe1A1NWeLZK4tFFhTScA0zVcr49UcMcsLlU7s0H4avY17NSkVocZuxHW
         /6iw2veP3wAAEiokRS2bko3k/ScNZNwbx4hTPiQPw3i2S0VPBmkbCaWAnrzVALVAdR
         MioiBkY2OuQHySb0Derc7Y0RpIXjbjmUNzZ4yRlq9DmsFbECYWsJYbu+v4N59WVLTB
         6mviuHc6oUVDHq3Juf8dkmFH8w0DkmNMy8SWxZiN0piHp4xtdjJW25nYlHK5o5ROCw
         LsWpjZIig7dayeQ5EcXgcsCW6Uu/ceL/GqP3tTsoUugTS8r+QdkHZuyxcnay59cTT5
         3iWNZ/WTVpSbw==
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
To:     dri-devel@lists.freedesktop.org
Cc:     linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        chunkuang.hu@kernel.org, p.zabel@pengutronix.de, airlied@linux.ie,
        daniel@ffwll.ch, matthias.bgg@gmail.com, kernel@collabora.com,
        andrzej.hajda@intel.com,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>, stable@vger.kernel.org,
        Jagan Teki <jagan@amarulasolutions.com>
Subject: [PATCH v4] drm/mediatek: mtk_dsi: Avoid EPROBE_DEFER loop with external bridge
Date:   Mon, 31 Jan 2022 09:55:20 +0100
Message-Id: <20220131085520.287105-1-angelogioacchino.delregno@collabora.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DRM bridge drivers are now attaching their DSI device at probe time,
which requires us to register our DSI host in order to let the bridge
to probe: this recently started producing an endless -EPROBE_DEFER
loop on some machines that are using external bridges, like the
parade-ps8640, found on the ACER Chromebook R13.

Now that the DSI hosts/devices probe sequence is documented, we can
do adjustments to the mtk_dsi driver as to both fix now and make sure
to avoid this situation in the future: for this, following what is
documented in drm_bridge.c, move the mtk_dsi component_add() to the
mtk_dsi_ops.attach callback and delete it in the detach callback;
keeping in mind that we are registering a drm_bridge for our DSI,
which is only used/attached if the DSI Host is bound, it wouldn't
make sense to keep adding our bridge at probe time (as it would
be useless to have it if mtk_dsi_ops.attach() fails!), so also move
that one to the dsi host attach function (and remove it in detach).

Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Reviewed-by: Jagan Teki <jagan@amarulasolutions.com>

---
 drivers/gpu/drm/mediatek/mtk_dsi.c | 167 +++++++++++++++--------------
 1 file changed, 84 insertions(+), 83 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_dsi.c b/drivers/gpu/drm/mediatek/mtk_dsi.c
index 5d90d2eb0019..bced4c7d668e 100644
--- a/drivers/gpu/drm/mediatek/mtk_dsi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dsi.c
@@ -786,18 +786,101 @@ void mtk_dsi_ddp_stop(struct device *dev)
 	mtk_dsi_poweroff(dsi);
 }
 
+static int mtk_dsi_encoder_init(struct drm_device *drm, struct mtk_dsi *dsi)
+{
+	int ret;
+
+	ret = drm_simple_encoder_init(drm, &dsi->encoder,
+				      DRM_MODE_ENCODER_DSI);
+	if (ret) {
+		DRM_ERROR("Failed to encoder init to drm\n");
+		return ret;
+	}
+
+	dsi->encoder.possible_crtcs = mtk_drm_find_possible_crtc_by_comp(drm, dsi->host.dev);
+
+	ret = drm_bridge_attach(&dsi->encoder, &dsi->bridge, NULL,
+				DRM_BRIDGE_ATTACH_NO_CONNECTOR);
+	if (ret)
+		goto err_cleanup_encoder;
+
+	dsi->connector = drm_bridge_connector_init(drm, &dsi->encoder);
+	if (IS_ERR(dsi->connector)) {
+		DRM_ERROR("Unable to create bridge connector\n");
+		ret = PTR_ERR(dsi->connector);
+		goto err_cleanup_encoder;
+	}
+	drm_connector_attach_encoder(dsi->connector, &dsi->encoder);
+
+	return 0;
+
+err_cleanup_encoder:
+	drm_encoder_cleanup(&dsi->encoder);
+	return ret;
+}
+
+static int mtk_dsi_bind(struct device *dev, struct device *master, void *data)
+{
+	int ret;
+	struct drm_device *drm = data;
+	struct mtk_dsi *dsi = dev_get_drvdata(dev);
+
+	ret = mtk_dsi_encoder_init(drm, dsi);
+	if (ret)
+		return ret;
+
+	return device_reset_optional(dev);
+}
+
+static void mtk_dsi_unbind(struct device *dev, struct device *master,
+			   void *data)
+{
+	struct mtk_dsi *dsi = dev_get_drvdata(dev);
+
+	drm_encoder_cleanup(&dsi->encoder);
+}
+
+static const struct component_ops mtk_dsi_component_ops = {
+	.bind = mtk_dsi_bind,
+	.unbind = mtk_dsi_unbind,
+};
+
 static int mtk_dsi_host_attach(struct mipi_dsi_host *host,
 			       struct mipi_dsi_device *device)
 {
 	struct mtk_dsi *dsi = host_to_dsi(host);
+	struct device *dev = host->dev;
+	int ret;
 
 	dsi->lanes = device->lanes;
 	dsi->format = device->format;
 	dsi->mode_flags = device->mode_flags;
+	dsi->next_bridge = devm_drm_of_get_bridge(dev, dev->of_node, 0, 0);
+	if (IS_ERR(dsi->next_bridge))
+		return PTR_ERR(dsi->next_bridge);
+
+	drm_bridge_add(&dsi->bridge);
+
+	ret = component_add(host->dev, &mtk_dsi_component_ops);
+	if (ret) {
+		DRM_ERROR("failed to add dsi_host component: %d\n", ret);
+		drm_bridge_remove(&dsi->bridge);
+		return ret;
+	}
 
 	return 0;
 }
 
+static int mtk_dsi_host_detach(struct mipi_dsi_host *host,
+			       struct mipi_dsi_device *device)
+{
+	struct mtk_dsi *dsi = host_to_dsi(host);
+
+	component_del(host->dev, &mtk_dsi_component_ops);
+	drm_bridge_remove(&dsi->bridge);
+	return 0;
+}
+
 static void mtk_dsi_wait_for_idle(struct mtk_dsi *dsi)
 {
 	int ret;
@@ -938,73 +1021,14 @@ static ssize_t mtk_dsi_host_transfer(struct mipi_dsi_host *host,
 
 static const struct mipi_dsi_host_ops mtk_dsi_ops = {
 	.attach = mtk_dsi_host_attach,
+	.detach = mtk_dsi_host_detach,
 	.transfer = mtk_dsi_host_transfer,
 };
 
-static int mtk_dsi_encoder_init(struct drm_device *drm, struct mtk_dsi *dsi)
-{
-	int ret;
-
-	ret = drm_simple_encoder_init(drm, &dsi->encoder,
-				      DRM_MODE_ENCODER_DSI);
-	if (ret) {
-		DRM_ERROR("Failed to encoder init to drm\n");
-		return ret;
-	}
-
-	dsi->encoder.possible_crtcs = mtk_drm_find_possible_crtc_by_comp(drm, dsi->host.dev);
-
-	ret = drm_bridge_attach(&dsi->encoder, &dsi->bridge, NULL,
-				DRM_BRIDGE_ATTACH_NO_CONNECTOR);
-	if (ret)
-		goto err_cleanup_encoder;
-
-	dsi->connector = drm_bridge_connector_init(drm, &dsi->encoder);
-	if (IS_ERR(dsi->connector)) {
-		DRM_ERROR("Unable to create bridge connector\n");
-		ret = PTR_ERR(dsi->connector);
-		goto err_cleanup_encoder;
-	}
-	drm_connector_attach_encoder(dsi->connector, &dsi->encoder);
-
-	return 0;
-
-err_cleanup_encoder:
-	drm_encoder_cleanup(&dsi->encoder);
-	return ret;
-}
-
-static int mtk_dsi_bind(struct device *dev, struct device *master, void *data)
-{
-	int ret;
-	struct drm_device *drm = data;
-	struct mtk_dsi *dsi = dev_get_drvdata(dev);
-
-	ret = mtk_dsi_encoder_init(drm, dsi);
-	if (ret)
-		return ret;
-
-	return device_reset_optional(dev);
-}
-
-static void mtk_dsi_unbind(struct device *dev, struct device *master,
-			   void *data)
-{
-	struct mtk_dsi *dsi = dev_get_drvdata(dev);
-
-	drm_encoder_cleanup(&dsi->encoder);
-}
-
-static const struct component_ops mtk_dsi_component_ops = {
-	.bind = mtk_dsi_bind,
-	.unbind = mtk_dsi_unbind,
-};
-
 static int mtk_dsi_probe(struct platform_device *pdev)
 {
 	struct mtk_dsi *dsi;
 	struct device *dev = &pdev->dev;
-	struct drm_panel *panel;
 	struct resource *regs;
 	int irq_num;
 	int ret;
@@ -1021,19 +1045,6 @@ static int mtk_dsi_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	ret = drm_of_find_panel_or_bridge(dev->of_node, 0, 0,
-					  &panel, &dsi->next_bridge);
-	if (ret)
-		goto err_unregister_host;
-
-	if (panel) {
-		dsi->next_bridge = devm_drm_panel_bridge_add(dev, panel);
-		if (IS_ERR(dsi->next_bridge)) {
-			ret = PTR_ERR(dsi->next_bridge);
-			goto err_unregister_host;
-		}
-	}
-
 	dsi->driver_data = of_device_get_match_data(dev);
 
 	dsi->engine_clk = devm_clk_get(dev, "engine");
@@ -1098,14 +1109,6 @@ static int mtk_dsi_probe(struct platform_device *pdev)
 	dsi->bridge.of_node = dev->of_node;
 	dsi->bridge.type = DRM_MODE_CONNECTOR_DSI;
 
-	drm_bridge_add(&dsi->bridge);
-
-	ret = component_add(&pdev->dev, &mtk_dsi_component_ops);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to add component: %d\n", ret);
-		goto err_unregister_host;
-	}
-
 	return 0;
 
 err_unregister_host:
@@ -1118,8 +1121,6 @@ static int mtk_dsi_remove(struct platform_device *pdev)
 	struct mtk_dsi *dsi = platform_get_drvdata(pdev);
 
 	mtk_output_dsi_disable(dsi);
-	drm_bridge_remove(&dsi->bridge);
-	component_del(&pdev->dev, &mtk_dsi_component_ops);
 	mipi_dsi_host_unregister(&dsi->host);
 
 	return 0;
-- 
2.33.1

