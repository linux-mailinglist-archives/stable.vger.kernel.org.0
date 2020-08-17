Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558D72470DC
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390714AbgHQSQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:16:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388381AbgHQQFt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:05:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C9FD20825;
        Mon, 17 Aug 2020 16:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680348;
        bh=MDisDYN9kWXuxX8pXR7HyO8hvESKSlsaPKxP+jh3khI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VB7q4vq6yiV/Ohpm4a7JzzAlCXNXuB6RnkxH7QioDgMabnZVhfWcQEPx+sF4Kmx8Q
         YOVq3Ra9irUSb56xA5i+J+UeQhVOVJ7XnjEIa/Ts2FJiXzTgUQ37IZgZb4xFilwKwk
         jImAcKWg71QHpuspUMj34Mwjdg5vO3mEnn4p5D1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 151/270] drm/imx: fix use after free
Date:   Mon, 17 Aug 2020 17:15:52 +0200
Message-Id: <20200817143803.335408777@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Zabel <p.zabel@pengutronix.de>

[ Upstream commit ba807c94f67fd64b3051199810d9e4dd209fdc00 ]

Component driver structures allocated with devm_kmalloc() in bind() are
freed automatically after unbind(). Since the contained drm structures
are accessed afterwards in drm_mode_config_cleanup(), move the
allocation into probe() to extend the driver structure's lifetime to the
lifetime of the device. This should eventually be changed to use drm
resource managed allocations with lifetime of the drm device.

We also need to ensure that all componets are available during the
unbind() so we need to call component_unbind_all() before we free
non-devres resources like planes.

Note this patch fixes the the use after free bug but introduces a
possible boot loop issue. The issue is triggered if the HDMI support is
enabled and a component driver always return -EPROBE_DEFER, see
discussion [1] for more details.

[1] https://lkml.org/lkml/2020/3/24/1467

Fixes: 17b5001b5143 ("imx-drm: convert to componentised device support")
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
[m.felsch@pengutronix: fix imx_tve_probe()]
[m.felsch@pengutronix: resort component_unbind_all())
[m.felsch@pengutronix: adapt commit message]
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/dw_hdmi-imx.c      | 15 ++++++++++-----
 drivers/gpu/drm/imx/imx-drm-core.c     |  3 ++-
 drivers/gpu/drm/imx/imx-ldb.c          | 15 ++++++++++-----
 drivers/gpu/drm/imx/imx-tve.c          | 15 ++++++++++-----
 drivers/gpu/drm/imx/ipuv3-crtc.c       | 21 ++++++++++-----------
 drivers/gpu/drm/imx/parallel-display.c | 15 ++++++++++-----
 6 files changed, 52 insertions(+), 32 deletions(-)

diff --git a/drivers/gpu/drm/imx/dw_hdmi-imx.c b/drivers/gpu/drm/imx/dw_hdmi-imx.c
index f22cfbf9353ed..2e12a4a3bfa11 100644
--- a/drivers/gpu/drm/imx/dw_hdmi-imx.c
+++ b/drivers/gpu/drm/imx/dw_hdmi-imx.c
@@ -212,9 +212,8 @@ static int dw_hdmi_imx_bind(struct device *dev, struct device *master,
 	if (!pdev->dev.of_node)
 		return -ENODEV;
 
-	hdmi = devm_kzalloc(&pdev->dev, sizeof(*hdmi), GFP_KERNEL);
-	if (!hdmi)
-		return -ENOMEM;
+	hdmi = dev_get_drvdata(dev);
+	memset(hdmi, 0, sizeof(*hdmi));
 
 	match = of_match_node(dw_hdmi_imx_dt_ids, pdev->dev.of_node);
 	plat_data = match->data;
@@ -239,8 +238,6 @@ static int dw_hdmi_imx_bind(struct device *dev, struct device *master,
 	drm_encoder_init(drm, encoder, &dw_hdmi_imx_encoder_funcs,
 			 DRM_MODE_ENCODER_TMDS, NULL);
 
-	platform_set_drvdata(pdev, hdmi);
-
 	hdmi->hdmi = dw_hdmi_bind(pdev, encoder, plat_data);
 
 	/*
@@ -270,6 +267,14 @@ static const struct component_ops dw_hdmi_imx_ops = {
 
 static int dw_hdmi_imx_probe(struct platform_device *pdev)
 {
+	struct imx_hdmi *hdmi;
+
+	hdmi = devm_kzalloc(&pdev->dev, sizeof(*hdmi), GFP_KERNEL);
+	if (!hdmi)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, hdmi);
+
 	return component_add(&pdev->dev, &dw_hdmi_imx_ops);
 }
 
diff --git a/drivers/gpu/drm/imx/imx-drm-core.c b/drivers/gpu/drm/imx/imx-drm-core.c
index da87c70e413b4..881c36d0f16bb 100644
--- a/drivers/gpu/drm/imx/imx-drm-core.c
+++ b/drivers/gpu/drm/imx/imx-drm-core.c
@@ -281,9 +281,10 @@ static void imx_drm_unbind(struct device *dev)
 
 	drm_kms_helper_poll_fini(drm);
 
+	component_unbind_all(drm->dev, drm);
+
 	drm_mode_config_cleanup(drm);
 
-	component_unbind_all(drm->dev, drm);
 	dev_set_drvdata(dev, NULL);
 
 	drm_dev_put(drm);
diff --git a/drivers/gpu/drm/imx/imx-ldb.c b/drivers/gpu/drm/imx/imx-ldb.c
index 695f307f36b28..9af5a08d5490f 100644
--- a/drivers/gpu/drm/imx/imx-ldb.c
+++ b/drivers/gpu/drm/imx/imx-ldb.c
@@ -593,9 +593,8 @@ static int imx_ldb_bind(struct device *dev, struct device *master, void *data)
 	int ret;
 	int i;
 
-	imx_ldb = devm_kzalloc(dev, sizeof(*imx_ldb), GFP_KERNEL);
-	if (!imx_ldb)
-		return -ENOMEM;
+	imx_ldb = dev_get_drvdata(dev);
+	memset(imx_ldb, 0, sizeof(*imx_ldb));
 
 	imx_ldb->regmap = syscon_regmap_lookup_by_phandle(np, "gpr");
 	if (IS_ERR(imx_ldb->regmap)) {
@@ -703,8 +702,6 @@ static int imx_ldb_bind(struct device *dev, struct device *master, void *data)
 		}
 	}
 
-	dev_set_drvdata(dev, imx_ldb);
-
 	return 0;
 
 free_child:
@@ -736,6 +733,14 @@ static const struct component_ops imx_ldb_ops = {
 
 static int imx_ldb_probe(struct platform_device *pdev)
 {
+	struct imx_ldb *imx_ldb;
+
+	imx_ldb = devm_kzalloc(&pdev->dev, sizeof(*imx_ldb), GFP_KERNEL);
+	if (!imx_ldb)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, imx_ldb);
+
 	return component_add(&pdev->dev, &imx_ldb_ops);
 }
 
diff --git a/drivers/gpu/drm/imx/imx-tve.c b/drivers/gpu/drm/imx/imx-tve.c
index 5bbfaa2cd0f47..9fd4b464e829c 100644
--- a/drivers/gpu/drm/imx/imx-tve.c
+++ b/drivers/gpu/drm/imx/imx-tve.c
@@ -546,9 +546,8 @@ static int imx_tve_bind(struct device *dev, struct device *master, void *data)
 	int irq;
 	int ret;
 
-	tve = devm_kzalloc(dev, sizeof(*tve), GFP_KERNEL);
-	if (!tve)
-		return -ENOMEM;
+	tve = dev_get_drvdata(dev);
+	memset(tve, 0, sizeof(*tve));
 
 	tve->dev = dev;
 	spin_lock_init(&tve->lock);
@@ -659,8 +658,6 @@ static int imx_tve_bind(struct device *dev, struct device *master, void *data)
 	if (ret)
 		return ret;
 
-	dev_set_drvdata(dev, tve);
-
 	return 0;
 }
 
@@ -680,6 +677,14 @@ static const struct component_ops imx_tve_ops = {
 
 static int imx_tve_probe(struct platform_device *pdev)
 {
+	struct imx_tve *tve;
+
+	tve = devm_kzalloc(&pdev->dev, sizeof(*tve), GFP_KERNEL);
+	if (!tve)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, tve);
+
 	return component_add(&pdev->dev, &imx_tve_ops);
 }
 
diff --git a/drivers/gpu/drm/imx/ipuv3-crtc.c b/drivers/gpu/drm/imx/ipuv3-crtc.c
index 63c0284f8b3c0..2256c9789fc2c 100644
--- a/drivers/gpu/drm/imx/ipuv3-crtc.c
+++ b/drivers/gpu/drm/imx/ipuv3-crtc.c
@@ -438,21 +438,13 @@ static int ipu_drm_bind(struct device *dev, struct device *master, void *data)
 	struct ipu_client_platformdata *pdata = dev->platform_data;
 	struct drm_device *drm = data;
 	struct ipu_crtc *ipu_crtc;
-	int ret;
 
-	ipu_crtc = devm_kzalloc(dev, sizeof(*ipu_crtc), GFP_KERNEL);
-	if (!ipu_crtc)
-		return -ENOMEM;
+	ipu_crtc = dev_get_drvdata(dev);
+	memset(ipu_crtc, 0, sizeof(*ipu_crtc));
 
 	ipu_crtc->dev = dev;
 
-	ret = ipu_crtc_init(ipu_crtc, pdata, drm);
-	if (ret)
-		return ret;
-
-	dev_set_drvdata(dev, ipu_crtc);
-
-	return 0;
+	return ipu_crtc_init(ipu_crtc, pdata, drm);
 }
 
 static void ipu_drm_unbind(struct device *dev, struct device *master,
@@ -474,6 +466,7 @@ static const struct component_ops ipu_crtc_ops = {
 static int ipu_drm_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
+	struct ipu_crtc *ipu_crtc;
 	int ret;
 
 	if (!dev->platform_data)
@@ -483,6 +476,12 @@ static int ipu_drm_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	ipu_crtc = devm_kzalloc(dev, sizeof(*ipu_crtc), GFP_KERNEL);
+	if (!ipu_crtc)
+		return -ENOMEM;
+
+	dev_set_drvdata(dev, ipu_crtc);
+
 	return component_add(dev, &ipu_crtc_ops);
 }
 
diff --git a/drivers/gpu/drm/imx/parallel-display.c b/drivers/gpu/drm/imx/parallel-display.c
index e7ce17503ae17..be55548f352af 100644
--- a/drivers/gpu/drm/imx/parallel-display.c
+++ b/drivers/gpu/drm/imx/parallel-display.c
@@ -204,9 +204,8 @@ static int imx_pd_bind(struct device *dev, struct device *master, void *data)
 	u32 bus_format = 0;
 	const char *fmt;
 
-	imxpd = devm_kzalloc(dev, sizeof(*imxpd), GFP_KERNEL);
-	if (!imxpd)
-		return -ENOMEM;
+	imxpd = dev_get_drvdata(dev);
+	memset(imxpd, 0, sizeof(*imxpd));
 
 	edidp = of_get_property(np, "edid", &imxpd->edid_len);
 	if (edidp)
@@ -236,8 +235,6 @@ static int imx_pd_bind(struct device *dev, struct device *master, void *data)
 	if (ret)
 		return ret;
 
-	dev_set_drvdata(dev, imxpd);
-
 	return 0;
 }
 
@@ -259,6 +256,14 @@ static const struct component_ops imx_pd_ops = {
 
 static int imx_pd_probe(struct platform_device *pdev)
 {
+	struct imx_parallel_display *imxpd;
+
+	imxpd = devm_kzalloc(&pdev->dev, sizeof(*imxpd), GFP_KERNEL);
+	if (!imxpd)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, imxpd);
+
 	return component_add(&pdev->dev, &imx_pd_ops);
 }
 
-- 
2.25.1



