Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 542624CF7A3
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238467AbiCGJq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:46:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238392AbiCGJpI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:45:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9BC66AFA;
        Mon,  7 Mar 2022 01:41:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E9C0B810B9;
        Mon,  7 Mar 2022 09:41:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA08C340E9;
        Mon,  7 Mar 2022 09:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646106;
        bh=0dmLrK1qMtQoUWt/uHyXwuJ+mEZOHXrSg0gn9w1hEwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rMjbrRWnpJ7AKXopE8EkluqEV5BGCc1mM8qN/eLv4jv1P570SL8/JKNF+Nb5eWWVE
         SiWuVxReqe2KYSBy/Iy9qkR+3iQjrfmr0k5ZRmx/A9PNCaI3iWxeNnJRH4fHI72DBv
         c0fwhw/hEJTwJFiYRo1mXvblu6vUIgHewtpFAmyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Jagan Teki <jagan@amarulasolutions.com>,
        "=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" 
        <nfraprado@collabora.com>, Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 128/262] drm/mediatek: mtk_dsi: Avoid EPROBE_DEFER loop with external bridge
Date:   Mon,  7 Mar 2022 10:17:52 +0100
Message-Id: <20220307091706.068438693@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAD_ENC_HEADER,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 647474b8d980256b26b1cd112d7333a4dbd4260a ]

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
Tested-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_dsi.c | 167 +++++++++++++++--------------
 1 file changed, 84 insertions(+), 83 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_dsi.c b/drivers/gpu/drm/mediatek/mtk_dsi.c
index 5d90d2eb00193..bced4c7d668e3 100644
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
2.34.1



