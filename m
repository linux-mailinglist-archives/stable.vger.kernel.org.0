Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8750246A30
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729986AbgHQPbl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:31:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730280AbgHQPbY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:31:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C090C2075B;
        Mon, 17 Aug 2020 15:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678283;
        bh=dxCfi9tQH/CupglK9wQBVtwuJvqABs3o2KiG9C/1/ik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0oZU5EBxbqAGo6dt/FXoMHCv9d3SvybYT0TxOLPEhXx/StezfkyxWkl+f0Ic802sl
         RpZnELskCz3z1zi6X6og3CkjP1qCzVQmvaCDtup7iZzshyt7VrkML/jD1NDwsNM+iW
         wAyn4Y728FKgHAlAvRHs7ZxLODrzqa3IanXdQsIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 253/464] drm/imx: fix use after free
Date:   Mon, 17 Aug 2020 17:13:26 +0200
Message-Id: <20200817143845.914317182@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
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
index ba4ca17fd4d85..87869b9997a6e 100644
--- a/drivers/gpu/drm/imx/dw_hdmi-imx.c
+++ b/drivers/gpu/drm/imx/dw_hdmi-imx.c
@@ -209,9 +209,8 @@ static int dw_hdmi_imx_bind(struct device *dev, struct device *master,
 	if (!pdev->dev.of_node)
 		return -ENODEV;
 
-	hdmi = devm_kzalloc(&pdev->dev, sizeof(*hdmi), GFP_KERNEL);
-	if (!hdmi)
-		return -ENOMEM;
+	hdmi = dev_get_drvdata(dev);
+	memset(hdmi, 0, sizeof(*hdmi));
 
 	match = of_match_node(dw_hdmi_imx_dt_ids, pdev->dev.of_node);
 	plat_data = match->data;
@@ -235,8 +234,6 @@ static int dw_hdmi_imx_bind(struct device *dev, struct device *master,
 	drm_encoder_helper_add(encoder, &dw_hdmi_imx_encoder_helper_funcs);
 	drm_simple_encoder_init(drm, encoder, DRM_MODE_ENCODER_TMDS);
 
-	platform_set_drvdata(pdev, hdmi);
-
 	hdmi->hdmi = dw_hdmi_bind(pdev, encoder, plat_data);
 
 	/*
@@ -266,6 +263,14 @@ static const struct component_ops dw_hdmi_imx_ops = {
 
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
index 2e38f1a5cf8da..3421043a558d5 100644
--- a/drivers/gpu/drm/imx/imx-drm-core.c
+++ b/drivers/gpu/drm/imx/imx-drm-core.c
@@ -275,9 +275,10 @@ static void imx_drm_unbind(struct device *dev)
 
 	drm_kms_helper_poll_fini(drm);
 
+	component_unbind_all(drm->dev, drm);
+
 	drm_mode_config_cleanup(drm);
 
-	component_unbind_all(drm->dev, drm);
 	dev_set_drvdata(dev, NULL);
 
 	drm_dev_put(drm);
diff --git a/drivers/gpu/drm/imx/imx-ldb.c b/drivers/gpu/drm/imx/imx-ldb.c
index 66ea68e8da875..1823af9936c98 100644
--- a/drivers/gpu/drm/imx/imx-ldb.c
+++ b/drivers/gpu/drm/imx/imx-ldb.c
@@ -590,9 +590,8 @@ static int imx_ldb_bind(struct device *dev, struct device *master, void *data)
 	int ret;
 	int i;
 
-	imx_ldb = devm_kzalloc(dev, sizeof(*imx_ldb), GFP_KERNEL);
-	if (!imx_ldb)
-		return -ENOMEM;
+	imx_ldb = dev_get_drvdata(dev);
+	memset(imx_ldb, 0, sizeof(*imx_ldb));
 
 	imx_ldb->regmap = syscon_regmap_lookup_by_phandle(np, "gpr");
 	if (IS_ERR(imx_ldb->regmap)) {
@@ -700,8 +699,6 @@ static int imx_ldb_bind(struct device *dev, struct device *master, void *data)
 		}
 	}
 
-	dev_set_drvdata(dev, imx_ldb);
-
 	return 0;
 
 free_child:
@@ -733,6 +730,14 @@ static const struct component_ops imx_ldb_ops = {
 
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
index ee63782c77e9c..82d1ee1fb0c84 100644
--- a/drivers/gpu/drm/imx/imx-tve.c
+++ b/drivers/gpu/drm/imx/imx-tve.c
@@ -542,9 +542,8 @@ static int imx_tve_bind(struct device *dev, struct device *master, void *data)
 	int irq;
 	int ret;
 
-	tve = devm_kzalloc(dev, sizeof(*tve), GFP_KERNEL);
-	if (!tve)
-		return -ENOMEM;
+	tve = dev_get_drvdata(dev);
+	memset(tve, 0, sizeof(*tve));
 
 	tve->dev = dev;
 	spin_lock_init(&tve->lock);
@@ -655,8 +654,6 @@ static int imx_tve_bind(struct device *dev, struct device *master, void *data)
 	if (ret)
 		return ret;
 
-	dev_set_drvdata(dev, tve);
-
 	return 0;
 }
 
@@ -676,6 +673,14 @@ static const struct component_ops imx_tve_ops = {
 
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
index ac916c84a6318..622eabe9efb31 100644
--- a/drivers/gpu/drm/imx/parallel-display.c
+++ b/drivers/gpu/drm/imx/parallel-display.c
@@ -326,9 +326,8 @@ static int imx_pd_bind(struct device *dev, struct device *master, void *data)
 	u32 bus_format = 0;
 	const char *fmt;
 
-	imxpd = devm_kzalloc(dev, sizeof(*imxpd), GFP_KERNEL);
-	if (!imxpd)
-		return -ENOMEM;
+	imxpd = dev_get_drvdata(dev);
+	memset(imxpd, 0, sizeof(*imxpd));
 
 	edidp = of_get_property(np, "edid", &imxpd->edid_len);
 	if (edidp)
@@ -359,8 +358,6 @@ static int imx_pd_bind(struct device *dev, struct device *master, void *data)
 	if (ret)
 		return ret;
 
-	dev_set_drvdata(dev, imxpd);
-
 	return 0;
 }
 
@@ -382,6 +379,14 @@ static const struct component_ops imx_pd_ops = {
 
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



