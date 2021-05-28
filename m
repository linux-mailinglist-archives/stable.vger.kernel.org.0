Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 689A73941D5
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 13:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbhE1Lcw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 07:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234129AbhE1Lcm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 07:32:42 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B24C061760
        for <stable@vger.kernel.org>; Fri, 28 May 2021 04:31:06 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id q15so2298450pgg.12
        for <stable@vger.kernel.org>; Fri, 28 May 2021 04:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S1I4Qsf2xyySexj1ztEkbiIxy009KW3K9tSjVVFdRpQ=;
        b=Xz3PZrTaeS6rhOkQLvUcI4lmffBSMqeLujwIThRzHJilRQzGTexIahsWW3ZufS/12N
         O5KwXQvDw3UORfLiJOzYn/LwhOiqAXoUVop4JSwJGI9Uz+kzsCv3edU9vkiMahJkEph0
         xSj4HW9Pm5biAQpcmdFPyWIkfpgo+aaoUh0QrSZLEwJfCuFfDMqqyL/rGxhlkbfa6O/5
         K1uR0AjU/SbAnb8DkUiK9lvSMyfJuLaVxSGNXsj9uOsb+SeSOTZ41pqblnoKtyMY/Xy2
         a25NOR4vT+6hS93eW2xlBBk2FWknTefQfD665laqXGovInmv9lB+BlxFA+CIFXQ5PK3y
         ti3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S1I4Qsf2xyySexj1ztEkbiIxy009KW3K9tSjVVFdRpQ=;
        b=qpkbkYufekV6EVTfLyM6yt4fz0jVWreFU3dsvSLWHDj3pcPFHFHPAwWaGSYOLN/2gK
         TFU1AcgZZajkonq/hNFZNWoauS9SFcPVL2eUiiqPiSEQg6jwVHprPHVRW4e7Sz4ojcav
         8eQTiaPxto+OGL2jdB7rDzFXNZChPDzop8dX+FyB+nDi6i/Bn7XIri+pk2jBGl0777yx
         7RxBZiP0sv7wMxzExNJ293aub4Hju5vHrtBWFo3XFxH0Hd6Fa15QijgPIW5DaMWmXmML
         XpyV1pPf6rHBpREUSAPaHEfI4wnKgx+ecutUey9V6+KE3aP1WeRahW9pY9vmfOtjajG7
         m3Vg==
X-Gm-Message-State: AOAM532hiN+/hhGTQB6+IjPr81wcmFZGxQIdRjmREv0Me+tyKRtTJAbM
        499aTqGRSi3aeZZCykUO9g/xdQ==
X-Google-Smtp-Source: ABdhPJzaWEwhC25VePlrperoJPv3eArNY23XofpzqdyEN0a4dEBh0Q+ZGLda3x2kk+kT1BOcaZO4sw==
X-Received: by 2002:a63:6c08:: with SMTP id h8mr8519444pgc.226.1622201466452;
        Fri, 28 May 2021 04:31:06 -0700 (PDT)
Received: from localhost.localdomain ([49.207.204.226])
        by smtp.gmail.com with ESMTPSA id h76sm4763418pfe.161.2021.05.28.04.31.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 04:31:06 -0700 (PDT)
From:   Amit Pundir <amit.pundir@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Stable <stable@vger.kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>
Subject: [PATCH for-5.10.y] drm/msm/dpu: always use mdp device to scale bandwidth
Date:   Fri, 28 May 2021 17:01:02 +0530
Message-Id: <20210528113102.655950-1-amit.pundir@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit a670ff578f1fb855fedc7931fa5bbc06b567af22 ]

Currently DPU driver scales bandwidth and core clock for sc7180 only,
while the rest of chips get static bandwidth votes. Make all chipsets
scale bandwidth and clock per composition requirements like sc7180 does.
Drop old voting path completely.

Tested on RB3 (SDM845) and RB5 (SM8250).

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20210401020533.3956787-2-dmitry.baryshkov@linaro.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
---
Fixes dpu_runtime_resume() WARN_ON on db845c/RB3 (sdm845),
introduced by the backport of upstream commit 627dc55c273d
("drm/msm/disp/dpu1: icc path needs to be set before dpu
runtime resume") on v5.10.y.

 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c  |  3 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_mdss.c | 51 +-----------------------
 2 files changed, 2 insertions(+), 52 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
index e69ea810e18d..c8217f4858a1 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
@@ -931,8 +931,7 @@ static int dpu_kms_hw_init(struct msm_kms *kms)
 		DPU_DEBUG("REG_DMA is not defined");
 	}
 
-	if (of_device_is_compatible(dev->dev->of_node, "qcom,sc7180-mdss"))
-		dpu_kms_parse_data_bus_icc_path(dpu_kms);
+	dpu_kms_parse_data_bus_icc_path(dpu_kms);
 
 	pm_runtime_get_sync(&dpu_kms->pdev->dev);
 
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_mdss.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_mdss.c
index cd4078807db1..3416e9617ee9 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_mdss.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_mdss.c
@@ -31,40 +31,8 @@ struct dpu_mdss {
 	void __iomem *mmio;
 	struct dss_module_power mp;
 	struct dpu_irq_controller irq_controller;
-	struct icc_path *path[2];
-	u32 num_paths;
 };
 
-static int dpu_mdss_parse_data_bus_icc_path(struct drm_device *dev,
-						struct dpu_mdss *dpu_mdss)
-{
-	struct icc_path *path0 = of_icc_get(dev->dev, "mdp0-mem");
-	struct icc_path *path1 = of_icc_get(dev->dev, "mdp1-mem");
-
-	if (IS_ERR_OR_NULL(path0))
-		return PTR_ERR_OR_ZERO(path0);
-
-	dpu_mdss->path[0] = path0;
-	dpu_mdss->num_paths = 1;
-
-	if (!IS_ERR_OR_NULL(path1)) {
-		dpu_mdss->path[1] = path1;
-		dpu_mdss->num_paths++;
-	}
-
-	return 0;
-}
-
-static void dpu_mdss_icc_request_bw(struct msm_mdss *mdss)
-{
-	struct dpu_mdss *dpu_mdss = to_dpu_mdss(mdss);
-	int i;
-	u64 avg_bw = dpu_mdss->num_paths ? MAX_BW / dpu_mdss->num_paths : 0;
-
-	for (i = 0; i < dpu_mdss->num_paths; i++)
-		icc_set_bw(dpu_mdss->path[i], avg_bw, kBps_to_icc(MAX_BW));
-}
-
 static void dpu_mdss_irq(struct irq_desc *desc)
 {
 	struct dpu_mdss *dpu_mdss = irq_desc_get_handler_data(desc);
@@ -178,8 +146,6 @@ static int dpu_mdss_enable(struct msm_mdss *mdss)
 	struct dss_module_power *mp = &dpu_mdss->mp;
 	int ret;
 
-	dpu_mdss_icc_request_bw(mdss);
-
 	ret = msm_dss_enable_clk(mp->clk_config, mp->num_clk, true);
 	if (ret) {
 		DPU_ERROR("clock enable failed, ret:%d\n", ret);
@@ -213,15 +179,12 @@ static int dpu_mdss_disable(struct msm_mdss *mdss)
 {
 	struct dpu_mdss *dpu_mdss = to_dpu_mdss(mdss);
 	struct dss_module_power *mp = &dpu_mdss->mp;
-	int ret, i;
+	int ret;
 
 	ret = msm_dss_enable_clk(mp->clk_config, mp->num_clk, false);
 	if (ret)
 		DPU_ERROR("clock disable failed, ret:%d\n", ret);
 
-	for (i = 0; i < dpu_mdss->num_paths; i++)
-		icc_set_bw(dpu_mdss->path[i], 0, 0);
-
 	return ret;
 }
 
@@ -232,7 +195,6 @@ static void dpu_mdss_destroy(struct drm_device *dev)
 	struct dpu_mdss *dpu_mdss = to_dpu_mdss(priv->mdss);
 	struct dss_module_power *mp = &dpu_mdss->mp;
 	int irq;
-	int i;
 
 	pm_runtime_suspend(dev->dev);
 	pm_runtime_disable(dev->dev);
@@ -242,9 +204,6 @@ static void dpu_mdss_destroy(struct drm_device *dev)
 	msm_dss_put_clk(mp->clk_config, mp->num_clk);
 	devm_kfree(&pdev->dev, mp->clk_config);
 
-	for (i = 0; i < dpu_mdss->num_paths; i++)
-		icc_put(dpu_mdss->path[i]);
-
 	if (dpu_mdss->mmio)
 		devm_iounmap(&pdev->dev, dpu_mdss->mmio);
 	dpu_mdss->mmio = NULL;
@@ -276,12 +235,6 @@ int dpu_mdss_init(struct drm_device *dev)
 
 	DRM_DEBUG("mapped mdss address space @%pK\n", dpu_mdss->mmio);
 
-	if (!of_device_is_compatible(dev->dev->of_node, "qcom,sc7180-mdss")) {
-		ret = dpu_mdss_parse_data_bus_icc_path(dev, dpu_mdss);
-		if (ret)
-			return ret;
-	}
-
 	mp = &dpu_mdss->mp;
 	ret = msm_dss_parse_clock(pdev, mp);
 	if (ret) {
@@ -307,8 +260,6 @@ int dpu_mdss_init(struct drm_device *dev)
 
 	pm_runtime_enable(dev->dev);
 
-	dpu_mdss_icc_request_bw(priv->mdss);
-
 	return ret;
 
 irq_error:
-- 
2.25.1

