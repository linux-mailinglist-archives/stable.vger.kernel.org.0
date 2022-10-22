Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F09F6087BA
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbiJVIFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232996AbiJVIEg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:04:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 212532C56A4;
        Sat, 22 Oct 2022 00:52:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9828160B39;
        Sat, 22 Oct 2022 07:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85A6C433C1;
        Sat, 22 Oct 2022 07:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425015;
        bh=UJm+gn1TcHPDC6D7HJCQhNP5qveQ9yG2fJZsrvDSvBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=abH4jQApVUH57BNHX5aIDuO8sXvXv43H0Fq7F4mfty4WVnMgLqlu9FWesu/jhvgyv
         a7XqrsBrCmNuffStRA9ik/jrEZuVrkkF2PsvcxLrNe7BZOsuyGK9j1P/yVm0dKQ0yB
         n9lKV1EeO/sbfThbTKGdCpczRMUUw8h5TPA+PFvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Yassine Oudjana <y.oudjana@protonmail.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 330/717] drm/msm: lookup the ICC paths in both mdp5/dpu and mdss devices
Date:   Sat, 22 Oct 2022 09:23:29 +0200
Message-Id: <20221022072509.522131513@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 5ccdcecaf8f732f593e359ebfb65de96b11bae66 ]

The commit 6874f48bb8b0 ("drm/msm: make mdp5/dpu devices master
components") changed the MDP5 driver to look for the interconnect paths
in the MDSS device rather than in the MDP5 device itself. This was left
unnoticed since on my testing devices the interconnects probably didn't
reach the sync state.

Rather than just using the MDP5 device for ICC path lookups for the MDP5
devices, introduce an additional helper to check both MDP5/DPU and MDSS
nodes. This will be helpful for the MDP5->DPU conversion, since the
driver will have to check both nodes.

Fixes: 6874f48bb8b0 ("drm/msm: make mdp5/dpu devices master components")
Reported-by: Marijn Suijten <marijn.suijten@somainline.org>
Reported-by: Yassine Oudjana <y.oudjana@protonmail.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Tested-by: Marijn Suijten <marijn.suijten@somainline.org> # On sdm630
Tested-by: Yassine Oudjana <y.oudjana@protonmail.com> # msm8996
Patchwork: https://patchwork.freedesktop.org/patch/496488/
Link: https://lore.kernel.org/r/20220805115630.506391-1-dmitry.baryshkov@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c  |  7 ++-----
 drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c |  9 +++------
 drivers/gpu/drm/msm/msm_drv.h            |  2 ++
 drivers/gpu/drm/msm/msm_io_utils.c       | 22 ++++++++++++++++++++++
 4 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
index e23e2552e802..9eff6c2b1917 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
@@ -383,12 +383,9 @@ static int dpu_kms_parse_data_bus_icc_path(struct dpu_kms *dpu_kms)
 	struct icc_path *path1;
 	struct drm_device *dev = dpu_kms->dev;
 	struct device *dpu_dev = dev->dev;
-	struct device *mdss_dev = dpu_dev->parent;
 
-	/* Interconnects are a part of MDSS device tree binding, not the
-	 * MDP/DPU device. */
-	path0 = of_icc_get(mdss_dev, "mdp0-mem");
-	path1 = of_icc_get(mdss_dev, "mdp1-mem");
+	path0 = msm_icc_get(dpu_dev, "mdp0-mem");
+	path1 = msm_icc_get(dpu_dev, "mdp1-mem");
 
 	if (IS_ERR_OR_NULL(path0))
 		return PTR_ERR_OR_ZERO(path0);
diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c
index 3d5621a68f85..b0c372fef5d5 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c
@@ -921,12 +921,9 @@ static int mdp5_init(struct platform_device *pdev, struct drm_device *dev)
 
 static int mdp5_setup_interconnect(struct platform_device *pdev)
 {
-	/* Interconnects are a part of MDSS device tree binding, not the
-	 * MDP5 device. */
-	struct device *mdss_dev = pdev->dev.parent;
-	struct icc_path *path0 = of_icc_get(mdss_dev, "mdp0-mem");
-	struct icc_path *path1 = of_icc_get(mdss_dev, "mdp1-mem");
-	struct icc_path *path_rot = of_icc_get(mdss_dev, "rotator-mem");
+	struct icc_path *path0 = msm_icc_get(&pdev->dev, "mdp0-mem");
+	struct icc_path *path1 = msm_icc_get(&pdev->dev, "mdp1-mem");
+	struct icc_path *path_rot = msm_icc_get(&pdev->dev, "rotator-mem");
 
 	if (IS_ERR(path0))
 		return PTR_ERR(path0);
diff --git a/drivers/gpu/drm/msm/msm_drv.h b/drivers/gpu/drm/msm/msm_drv.h
index 099a67d10c3a..17e8b6571f6f 100644
--- a/drivers/gpu/drm/msm/msm_drv.h
+++ b/drivers/gpu/drm/msm/msm_drv.h
@@ -442,6 +442,8 @@ void __iomem *msm_ioremap_size(struct platform_device *pdev, const char *name,
 		phys_addr_t *size);
 void __iomem *msm_ioremap_quiet(struct platform_device *pdev, const char *name);
 
+struct icc_path *msm_icc_get(struct device *dev, const char *name);
+
 #define msm_writel(data, addr) writel((data), (addr))
 #define msm_readl(addr) readl((addr))
 
diff --git a/drivers/gpu/drm/msm/msm_io_utils.c b/drivers/gpu/drm/msm/msm_io_utils.c
index 7b504617833a..d02cd29ce829 100644
--- a/drivers/gpu/drm/msm/msm_io_utils.c
+++ b/drivers/gpu/drm/msm/msm_io_utils.c
@@ -5,6 +5,8 @@
  * Author: Rob Clark <robdclark@gmail.com>
  */
 
+#include <linux/interconnect.h>
+
 #include "msm_drv.h"
 
 /*
@@ -124,3 +126,23 @@ void msm_hrtimer_work_init(struct msm_hrtimer_work *work,
 	work->worker = worker;
 	kthread_init_work(&work->work, fn);
 }
+
+struct icc_path *msm_icc_get(struct device *dev, const char *name)
+{
+	struct device *mdss_dev = dev->parent;
+	struct icc_path *path;
+
+	path = of_icc_get(dev, name);
+	if (path)
+		return path;
+
+	/*
+	 * If there are no interconnects attached to the corresponding device
+	 * node, of_icc_get() will return NULL.
+	 *
+	 * If the MDP5/DPU device node doesn't have interconnects, lookup the
+	 * path in the parent (MDSS) device.
+	 */
+	return of_icc_get(mdss_dev, name);
+
+}
-- 
2.35.1



