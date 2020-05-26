Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 773D11CAD40
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbgEHM7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:59:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729832AbgEHMw4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:52:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8F4024959;
        Fri,  8 May 2020 12:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942374;
        bh=r2EjWEVUPezkNE5CyIxnKq1/Poy/iWkkjjfp4PKowvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DaYyIYSy6d15K5lH/XVqD0eJCI30gzsR9qzk7W+3j/fH/mbP88QtpNHkxGA2QQCbU
         KpU+xOGTLVBF3V2v9pMavLQa5enK1YTp/BRv6msJRLVlaIduYHh0lV7L3+RN254uSJ
         LQthhN2x4K2Aaqu5GVoQLsgRLaq/VCe3BFEeBdxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Andy Yan <andy.yan@rock-chips.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 02/50] drm/bridge: analogix_dp: Split bind() into probe() and real bind()
Date:   Fri,  8 May 2020 14:35:08 +0200
Message-Id: <20200508123043.546501854@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123043.085296641@linuxfoundation.org>
References: <20200508123043.085296641@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 83a196773b8bc6702f49df1eddc848180e350340 ]

Analogix_dp driver acquires all its resources in the ->bind() callback,
what is a bit against the component driver based approach, where the
driver initialization is split into a probe(), where all resources are
gathered, and a bind(), where all objects are created and a compound
driver is initialized.

Extract all the resource related operations to analogix_dp_probe() and
analogix_dp_remove(), then call them before/after registration of the
device components from the main Exynos DP and Rockchip DP drivers. Also
move the plat_data initialization to the probe() to make it available for
the analogix_dp_probe() function.

This fixes the multiple calls to the bind() of the DRM compound driver
when the DP PHY driver is not yet loaded/probed:

[drm] Exynos DRM: using 14400000.fimd device for DMA mapping operations
exynos-drm exynos-drm: bound 14400000.fimd (ops fimd_component_ops [exynosdrm])
exynos-drm exynos-drm: bound 14450000.mixer (ops mixer_component_ops [exynosdrm])
exynos-dp 145b0000.dp-controller: no DP phy configured
exynos-drm exynos-drm: failed to bind 145b0000.dp-controller (ops exynos_dp_ops [exynosdrm]): -517
exynos-drm exynos-drm: master bind failed: -517
...
[drm] Exynos DRM: using 14400000.fimd device for DMA mapping operations
exynos-drm exynos-drm: bound 14400000.fimd (ops hdmi_enable [exynosdrm])
exynos-drm exynos-drm: bound 14450000.mixer (ops hdmi_enable [exynosdrm])
exynos-drm exynos-drm: bound 145b0000.dp-controller (ops hdmi_enable [exynosdrm])
exynos-drm exynos-drm: bound 14530000.hdmi (ops hdmi_enable [exynosdrm])
[drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
Console: switching to colour frame buffer device 170x48
exynos-drm exynos-drm: fb0: exynosdrmfb frame buffer device
[drm] Initialized exynos 1.1.0 20180330 for exynos-drm on minor 1
...

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Andy Yan <andy.yan@rock-chips.com>
Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200310103427.26048-1-m.szyprowski@samsung.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/bridge/analogix/analogix_dp_core.c    | 33 +++++++++++------
 drivers/gpu/drm/exynos/exynos_dp.c            | 29 ++++++++-------
 .../gpu/drm/rockchip/analogix_dp-rockchip.c   | 36 ++++++++++---------
 include/drm/bridge/analogix_dp.h              |  5 +--
 4 files changed, 61 insertions(+), 42 deletions(-)

diff --git a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
index 22885dceaa177..1f26890a8da6e 100644
--- a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
+++ b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
@@ -1635,8 +1635,7 @@ static ssize_t analogix_dpaux_transfer(struct drm_dp_aux *aux,
 }
 
 struct analogix_dp_device *
-analogix_dp_bind(struct device *dev, struct drm_device *drm_dev,
-		 struct analogix_dp_plat_data *plat_data)
+analogix_dp_probe(struct device *dev, struct analogix_dp_plat_data *plat_data)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct analogix_dp_device *dp;
@@ -1739,22 +1738,30 @@ analogix_dp_bind(struct device *dev, struct drm_device *drm_dev,
 					irq_flags, "analogix-dp", dp);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to request irq\n");
-		goto err_disable_pm_runtime;
+		return ERR_PTR(ret);
 	}
 	disable_irq(dp->irq);
 
+	return dp;
+}
+EXPORT_SYMBOL_GPL(analogix_dp_probe);
+
+int analogix_dp_bind(struct analogix_dp_device *dp, struct drm_device *drm_dev)
+{
+	int ret;
+
 	dp->drm_dev = drm_dev;
 	dp->encoder = dp->plat_data->encoder;
 
 	dp->aux.name = "DP-AUX";
 	dp->aux.transfer = analogix_dpaux_transfer;
-	dp->aux.dev = &pdev->dev;
+	dp->aux.dev = dp->dev;
 
 	ret = drm_dp_aux_register(&dp->aux);
 	if (ret)
-		return ERR_PTR(ret);
+		return ret;
 
-	pm_runtime_enable(dev);
+	pm_runtime_enable(dp->dev);
 
 	ret = analogix_dp_create_bridge(drm_dev, dp);
 	if (ret) {
@@ -1762,13 +1769,12 @@ analogix_dp_bind(struct device *dev, struct drm_device *drm_dev,
 		goto err_disable_pm_runtime;
 	}
 
-	return dp;
+	return 0;
 
 err_disable_pm_runtime:
+	pm_runtime_disable(dp->dev);
 
-	pm_runtime_disable(dev);
-
-	return ERR_PTR(ret);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(analogix_dp_bind);
 
@@ -1785,10 +1791,15 @@ void analogix_dp_unbind(struct analogix_dp_device *dp)
 
 	drm_dp_aux_unregister(&dp->aux);
 	pm_runtime_disable(dp->dev);
-	clk_disable_unprepare(dp->clock);
 }
 EXPORT_SYMBOL_GPL(analogix_dp_unbind);
 
+void analogix_dp_remove(struct analogix_dp_device *dp)
+{
+	clk_disable_unprepare(dp->clock);
+}
+EXPORT_SYMBOL_GPL(analogix_dp_remove);
+
 #ifdef CONFIG_PM
 int analogix_dp_suspend(struct analogix_dp_device *dp)
 {
diff --git a/drivers/gpu/drm/exynos/exynos_dp.c b/drivers/gpu/drm/exynos/exynos_dp.c
index 3a0f0ba8c63a0..e0cfae744afc9 100644
--- a/drivers/gpu/drm/exynos/exynos_dp.c
+++ b/drivers/gpu/drm/exynos/exynos_dp.c
@@ -158,15 +158,8 @@ static int exynos_dp_bind(struct device *dev, struct device *master, void *data)
 	struct drm_device *drm_dev = data;
 	int ret;
 
-	dp->dev = dev;
 	dp->drm_dev = drm_dev;
 
-	dp->plat_data.dev_type = EXYNOS_DP;
-	dp->plat_data.power_on_start = exynos_dp_poweron;
-	dp->plat_data.power_off = exynos_dp_poweroff;
-	dp->plat_data.attach = exynos_dp_bridge_attach;
-	dp->plat_data.get_modes = exynos_dp_get_modes;
-
 	if (!dp->plat_data.panel && !dp->ptn_bridge) {
 		ret = exynos_dp_dt_parse_panel(dp);
 		if (ret)
@@ -184,13 +177,11 @@ static int exynos_dp_bind(struct device *dev, struct device *master, void *data)
 
 	dp->plat_data.encoder = encoder;
 
-	dp->adp = analogix_dp_bind(dev, dp->drm_dev, &dp->plat_data);
-	if (IS_ERR(dp->adp)) {
+	ret = analogix_dp_bind(dp->adp, dp->drm_dev);
+	if (ret)
 		dp->encoder.funcs->destroy(&dp->encoder);
-		return PTR_ERR(dp->adp);
-	}
 
-	return 0;
+	return ret;
 }
 
 static void exynos_dp_unbind(struct device *dev, struct device *master,
@@ -221,6 +212,7 @@ static int exynos_dp_probe(struct platform_device *pdev)
 	if (!dp)
 		return -ENOMEM;
 
+	dp->dev = dev;
 	/*
 	 * We just use the drvdata until driver run into component
 	 * add function, and then we would set drvdata to null, so
@@ -246,16 +238,29 @@ static int exynos_dp_probe(struct platform_device *pdev)
 
 	/* The remote port can be either a panel or a bridge */
 	dp->plat_data.panel = panel;
+	dp->plat_data.dev_type = EXYNOS_DP;
+	dp->plat_data.power_on_start = exynos_dp_poweron;
+	dp->plat_data.power_off = exynos_dp_poweroff;
+	dp->plat_data.attach = exynos_dp_bridge_attach;
+	dp->plat_data.get_modes = exynos_dp_get_modes;
 	dp->plat_data.skip_connector = !!bridge;
+
 	dp->ptn_bridge = bridge;
 
 out:
+	dp->adp = analogix_dp_probe(dev, &dp->plat_data);
+	if (IS_ERR(dp->adp))
+		return PTR_ERR(dp->adp);
+
 	return component_add(&pdev->dev, &exynos_dp_ops);
 }
 
 static int exynos_dp_remove(struct platform_device *pdev)
 {
+	struct exynos_dp_device *dp = platform_get_drvdata(pdev);
+
 	component_del(&pdev->dev, &exynos_dp_ops);
+	analogix_dp_remove(dp->adp);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/rockchip/analogix_dp-rockchip.c b/drivers/gpu/drm/rockchip/analogix_dp-rockchip.c
index f38f5e113c6b3..ce98c08aa8b44 100644
--- a/drivers/gpu/drm/rockchip/analogix_dp-rockchip.c
+++ b/drivers/gpu/drm/rockchip/analogix_dp-rockchip.c
@@ -325,15 +325,9 @@ static int rockchip_dp_bind(struct device *dev, struct device *master,
 			    void *data)
 {
 	struct rockchip_dp_device *dp = dev_get_drvdata(dev);
-	const struct rockchip_dp_chip_data *dp_data;
 	struct drm_device *drm_dev = data;
 	int ret;
 
-	dp_data = of_device_get_match_data(dev);
-	if (!dp_data)
-		return -ENODEV;
-
-	dp->data = dp_data;
 	dp->drm_dev = drm_dev;
 
 	ret = rockchip_dp_drm_create_encoder(dp);
@@ -344,16 +338,9 @@ static int rockchip_dp_bind(struct device *dev, struct device *master,
 
 	dp->plat_data.encoder = &dp->encoder;
 
-	dp->plat_data.dev_type = dp->data->chip_type;
-	dp->plat_data.power_on_start = rockchip_dp_poweron_start;
-	dp->plat_data.power_off = rockchip_dp_powerdown;
-	dp->plat_data.get_modes = rockchip_dp_get_modes;
-
-	dp->adp = analogix_dp_bind(dev, dp->drm_dev, &dp->plat_data);
-	if (IS_ERR(dp->adp)) {
-		ret = PTR_ERR(dp->adp);
+	ret = analogix_dp_bind(dp->adp, drm_dev);
+	if (ret)
 		goto err_cleanup_encoder;
-	}
 
 	return 0;
 err_cleanup_encoder:
@@ -368,8 +355,6 @@ static void rockchip_dp_unbind(struct device *dev, struct device *master,
 
 	analogix_dp_unbind(dp->adp);
 	dp->encoder.funcs->destroy(&dp->encoder);
-
-	dp->adp = ERR_PTR(-ENODEV);
 }
 
 static const struct component_ops rockchip_dp_component_ops = {
@@ -380,10 +365,15 @@ static const struct component_ops rockchip_dp_component_ops = {
 static int rockchip_dp_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
+	const struct rockchip_dp_chip_data *dp_data;
 	struct drm_panel *panel = NULL;
 	struct rockchip_dp_device *dp;
 	int ret;
 
+	dp_data = of_device_get_match_data(dev);
+	if (!dp_data)
+		return -ENODEV;
+
 	ret = drm_of_find_panel_or_bridge(dev->of_node, 1, 0, &panel, NULL);
 	if (ret < 0)
 		return ret;
@@ -394,7 +384,12 @@ static int rockchip_dp_probe(struct platform_device *pdev)
 
 	dp->dev = dev;
 	dp->adp = ERR_PTR(-ENODEV);
+	dp->data = dp_data;
 	dp->plat_data.panel = panel;
+	dp->plat_data.dev_type = dp->data->chip_type;
+	dp->plat_data.power_on_start = rockchip_dp_poweron_start;
+	dp->plat_data.power_off = rockchip_dp_powerdown;
+	dp->plat_data.get_modes = rockchip_dp_get_modes;
 
 	ret = rockchip_dp_of_probe(dp);
 	if (ret < 0)
@@ -402,12 +397,19 @@ static int rockchip_dp_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, dp);
 
+	dp->adp = analogix_dp_probe(dev, &dp->plat_data);
+	if (IS_ERR(dp->adp))
+		return PTR_ERR(dp->adp);
+
 	return component_add(dev, &rockchip_dp_component_ops);
 }
 
 static int rockchip_dp_remove(struct platform_device *pdev)
 {
+	struct rockchip_dp_device *dp = platform_get_drvdata(pdev);
+
 	component_del(&pdev->dev, &rockchip_dp_component_ops);
+	analogix_dp_remove(dp->adp);
 
 	return 0;
 }
diff --git a/include/drm/bridge/analogix_dp.h b/include/drm/bridge/analogix_dp.h
index 7aa2f93da49ca..b0dcc07334a1e 100644
--- a/include/drm/bridge/analogix_dp.h
+++ b/include/drm/bridge/analogix_dp.h
@@ -42,9 +42,10 @@ int analogix_dp_resume(struct analogix_dp_device *dp);
 int analogix_dp_suspend(struct analogix_dp_device *dp);
 
 struct analogix_dp_device *
-analogix_dp_bind(struct device *dev, struct drm_device *drm_dev,
-		 struct analogix_dp_plat_data *plat_data);
+analogix_dp_probe(struct device *dev, struct analogix_dp_plat_data *plat_data);
+int analogix_dp_bind(struct analogix_dp_device *dp, struct drm_device *drm_dev);
 void analogix_dp_unbind(struct analogix_dp_device *dp);
+void analogix_dp_remove(struct analogix_dp_device *dp);
 
 int analogix_dp_start_crc(struct drm_connector *connector);
 int analogix_dp_stop_crc(struct drm_connector *connector);
-- 
2.20.1



