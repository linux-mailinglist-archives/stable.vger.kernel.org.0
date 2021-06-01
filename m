Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A12F397A3A
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 20:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbhFASxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 14:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233853AbhFASxY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 14:53:24 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98899C061574
        for <stable@vger.kernel.org>; Tue,  1 Jun 2021 11:51:41 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d16so186126pfn.12
        for <stable@vger.kernel.org>; Tue, 01 Jun 2021 11:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DSj9r+I6mQwqS6Qt8QQEWfYtALv8xi/B3n5UYR2u0U4=;
        b=cEJqNUu0eDVB+mGU85DK+JWqEmKPDYvcVBjKbFG0FLNXicGIJDSZCWkWtSN4K0ePhc
         0WX48oedreGv2CZEVSIUMAb4WL4jBcCKFguPR/rxOVFPYnG8LuMl9fe1JjTGWSd2NALy
         nEVg3vV7AkwtHyqiL9pnJf0tJ4r+Vi6xaDaQB3s1yT2sQI2bP/gT044W5KMX95P+x/GQ
         5Op/pZ9XcMlC/b0JWI+LcKZhlpLN3pBRwfyFNP/lsbRmfFFyYyI1ej5A1TVER4pQvPtA
         3nGhPj2Z5l8w2QGAO3B80Xp55xySO9xruKhJw74XO+cUY5jp1sl4vV+qybNl7Ly1TSS5
         sZKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DSj9r+I6mQwqS6Qt8QQEWfYtALv8xi/B3n5UYR2u0U4=;
        b=ReyT+dHmBpV6B5mIYd1H2PC7K7Y05BmRc1hQs3AJdt3EuXyH7vsjZyc7fhlRxGfZNy
         8PSV1dTIwFNKEApRctT97JmBxe1R3SB/oZ8bRQ7X8SFm4/jB64EigjurOepCUVVmssKH
         fmByw1v4HqjLNfNwAzA/dQ5fPOadzlwPbmsa7zTKAwx07xc5iFQzv1Zg8lsMm9Ca1lNr
         fbwsXcQlD7LAfZc8HHclhpiSc4rjXfMv4MCdcWzfd869XZTEDRdMgT0Sj50z/y9yPe/2
         ERYqS/8o8a3M2hA4N5F0MaibcG47S4KSsBXXtwmSCAkoUCHc3QYW9HvqSWUj4QzAZwAv
         7AXQ==
X-Gm-Message-State: AOAM533LYzMR2f1JV82k5rHbAJRSv6B7XhW0L+pVhqqMZMSnhFzwYkih
        wl8MXVT09bUw0VjhFBEhJwSRQQ==
X-Google-Smtp-Source: ABdhPJziKwb66pmRq/d/yeAivqj2UalI+Sa9BOn94PSwKDFYaQcp2l83p2ZZyqO983DCAqkwhknMpg==
X-Received: by 2002:a05:6a00:a1e:b029:2e2:89d8:5c87 with SMTP id p30-20020a056a000a1eb02902e289d85c87mr23497510pfh.73.1622573500980;
        Tue, 01 Jun 2021 11:51:40 -0700 (PDT)
Received: from localhost.localdomain ([49.207.214.252])
        by smtp.gmail.com with ESMTPSA id a188sm6658199pfa.59.2021.06.01.11.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 11:51:40 -0700 (PDT)
From:   Amit Pundir <amit.pundir@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Stable <stable@vger.kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>
Subject: [PATCH for-5.10.y+] drm/msm/dpu: always use mdp device to scale bandwidth
Date:   Wed,  2 Jun 2021 00:21:37 +0530
Message-Id: <20210601185137.2558489-1-amit.pundir@linaro.org>
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
Fixes dpu_runtime_resume() WARN_ON, on db845c/RB3 (sdm845),
introduced by the backport of upstream commit 627dc55c273d
("drm/msm/disp/dpu1: icc path needs to be set before dpu
runtime resume") on v5.10.y.

Verified and smoke tested this fix on v5.12.y as well.

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

