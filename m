Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF3DD4094E2
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345358AbhIMOgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:36:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:51242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346498AbhIMOdQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:33:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A887D615E5;
        Mon, 13 Sep 2021 13:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541153;
        bh=2EFdkkmMJmy5JK8+meykr/qQReVA3QlFHBzl8v3VHlU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yk21kuy1rCdDJkrL0AN1gEH5hmZS0Kj+mdSfiYHbTQj6aSc6DKtIDx18TrMch7s7b
         tz5oA6fK+G+NHIhYr6S6zb0+WgHkGApXZLbwd2Q+vEAl3LPthD1ohUPBiuueoyAlz9
         dVwGBsgcEeP6OWEFwgQPKbbuHpKOCjr279hDAlUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Heidelberg <david@ixit.cz>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 185/334] drm/msm/mdp4: move HW revision detection to earlier phase
Date:   Mon, 13 Sep 2021 15:13:59 +0200
Message-Id: <20210913131119.606091266@linuxfoundation.org>
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

From: David Heidelberg <david@ixit.cz>

[ Upstream commit 4af4fc92939dc811ef291c0673946555aa4fb71f ]

Fixes if condition, which never worked inside mdp4_kms_init, since
HW detection has been done later in mdp4_hw_init.

Fixes: eb2b47bb9a03 ("drm/msm/mdp4: only use lut_clk on mdp4.2+")

Signed-off-by: David Heidelberg <david@ixit.cz>
Link: https://lore.kernel.org/r/20210705231641.315804-2-david@ixit.cz
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c | 45 ++++++++++++------------
 1 file changed, 22 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c b/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
index 3a7a01d801aa..0712752742f4 100644
--- a/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
+++ b/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
@@ -19,23 +19,12 @@ static int mdp4_hw_init(struct msm_kms *kms)
 {
 	struct mdp4_kms *mdp4_kms = to_mdp4_kms(to_mdp_kms(kms));
 	struct drm_device *dev = mdp4_kms->dev;
-	u32 major, minor, dmap_cfg, vg_cfg;
+	u32 dmap_cfg, vg_cfg;
 	unsigned long clk;
 	int ret = 0;
 
 	pm_runtime_get_sync(dev->dev);
 
-	read_mdp_hw_revision(mdp4_kms, &major, &minor);
-
-	if (major != 4) {
-		DRM_DEV_ERROR(dev->dev, "unexpected MDP version: v%d.%d\n",
-				major, minor);
-		ret = -ENXIO;
-		goto out;
-	}
-
-	mdp4_kms->rev = minor;
-
 	if (mdp4_kms->rev > 1) {
 		mdp4_write(mdp4_kms, REG_MDP4_CS_CONTROLLER0, 0x0707ffff);
 		mdp4_write(mdp4_kms, REG_MDP4_CS_CONTROLLER1, 0x03073f3f);
@@ -81,7 +70,6 @@ static int mdp4_hw_init(struct msm_kms *kms)
 	if (mdp4_kms->rev > 1)
 		mdp4_write(mdp4_kms, REG_MDP4_RESET_STATUS, 1);
 
-out:
 	pm_runtime_put_sync(dev->dev);
 
 	return ret;
@@ -428,6 +416,7 @@ struct msm_kms *mdp4_kms_init(struct drm_device *dev)
 	struct msm_kms *kms = NULL;
 	struct msm_gem_address_space *aspace;
 	int irq, ret;
+	u32 major, minor;
 
 	mdp4_kms = kzalloc(sizeof(*mdp4_kms), GFP_KERNEL);
 	if (!mdp4_kms) {
@@ -488,15 +477,6 @@ struct msm_kms *mdp4_kms_init(struct drm_device *dev)
 	if (IS_ERR(mdp4_kms->pclk))
 		mdp4_kms->pclk = NULL;
 
-	if (mdp4_kms->rev >= 2) {
-		mdp4_kms->lut_clk = devm_clk_get(&pdev->dev, "lut_clk");
-		if (IS_ERR(mdp4_kms->lut_clk)) {
-			DRM_DEV_ERROR(dev->dev, "failed to get lut_clk\n");
-			ret = PTR_ERR(mdp4_kms->lut_clk);
-			goto fail;
-		}
-	}
-
 	mdp4_kms->axi_clk = devm_clk_get(&pdev->dev, "bus_clk");
 	if (IS_ERR(mdp4_kms->axi_clk)) {
 		DRM_DEV_ERROR(dev->dev, "failed to get axi_clk\n");
@@ -505,8 +485,27 @@ struct msm_kms *mdp4_kms_init(struct drm_device *dev)
 	}
 
 	clk_set_rate(mdp4_kms->clk, config->max_clk);
-	if (mdp4_kms->lut_clk)
+
+	read_mdp_hw_revision(mdp4_kms, &major, &minor);
+
+	if (major != 4) {
+		DRM_DEV_ERROR(dev->dev, "unexpected MDP version: v%d.%d\n",
+			      major, minor);
+		ret = -ENXIO;
+		goto fail;
+	}
+
+	mdp4_kms->rev = minor;
+
+	if (mdp4_kms->rev >= 2) {
+		mdp4_kms->lut_clk = devm_clk_get(&pdev->dev, "lut_clk");
+		if (IS_ERR(mdp4_kms->lut_clk)) {
+			DRM_DEV_ERROR(dev->dev, "failed to get lut_clk\n");
+			ret = PTR_ERR(mdp4_kms->lut_clk);
+			goto fail;
+		}
 		clk_set_rate(mdp4_kms->lut_clk, config->max_clk);
+	}
 
 	pm_runtime_enable(dev->dev);
 	mdp4_kms->rpm_enabled = true;
-- 
2.30.2



