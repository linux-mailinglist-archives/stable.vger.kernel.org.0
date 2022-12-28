Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02F84657C13
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233482AbiL1P2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:28:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbiL1P2f (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:28:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC69F14D1E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:28:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6621DB8172A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:28:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE07C433EF;
        Wed, 28 Dec 2022 15:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241312;
        bh=EcXksoM8Re/d5aHV+QElhZ1StwOq+x6n/do5HXugy9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oxd/3TkDvE/gejMtc8aqTxUglGGZg7xpC2VvtwXv5RX6mQ10QjFtHzmBukSHKyFRT
         1xr7S4xT6qWZkwvoUo+MqlFFB6tRhFoTDul+lnTYIoCkb9eAMsnSOfPLuhx4lPHYZy
         0293jlgVV7F15YiW5h6KnOZ+VH8lWL07uMTpJL5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0265/1073] drm/msm/mdp5: stop overriding drvdata
Date:   Wed, 28 Dec 2022 15:30:53 +0100
Message-Id: <20221228144335.218736060@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit c6122688f2652d7f8a44000ce21e84e82bae2b5e ]

The rest of the code expects that master's device drvdata is the
struct msm_drm_private instance. Do not override the mdp5's drvdata.

Fixes: 6874f48bb8b0 ("drm/msm: make mdp5/dpu devices master components")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/508334/
Link: https://lore.kernel.org/r/20221024152642.3213488-1-dmitry.baryshkov@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c | 32 +++++++++++++-----------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c
index b0d21838a134..b46f983f2b46 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c
@@ -203,7 +203,7 @@ static int mdp5_set_split_display(struct msm_kms *kms,
 							  slave_encoder);
 }
 
-static void mdp5_destroy(struct platform_device *pdev);
+static void mdp5_destroy(struct mdp5_kms *mdp5_kms);
 
 static void mdp5_kms_destroy(struct msm_kms *kms)
 {
@@ -223,7 +223,7 @@ static void mdp5_kms_destroy(struct msm_kms *kms)
 	}
 
 	mdp_kms_destroy(&mdp5_kms->base);
-	mdp5_destroy(mdp5_kms->pdev);
+	mdp5_destroy(mdp5_kms);
 }
 
 #ifdef CONFIG_DEBUG_FS
@@ -519,9 +519,10 @@ static void read_mdp_hw_revision(struct mdp5_kms *mdp5_kms,
 	struct device *dev = &mdp5_kms->pdev->dev;
 	u32 version;
 
-	pm_runtime_get_sync(dev);
+	/* Manually enable the MDP5, as pm runtime isn't usable yet. */
+	mdp5_enable(mdp5_kms);
 	version = mdp5_read(mdp5_kms, REG_MDP5_HW_VERSION);
-	pm_runtime_put_sync(dev);
+	mdp5_disable(mdp5_kms);
 
 	*major = FIELD(version, MDP5_HW_VERSION_MAJOR);
 	*minor = FIELD(version, MDP5_HW_VERSION_MINOR);
@@ -559,6 +560,8 @@ static int mdp5_kms_init(struct drm_device *dev)
 	int irq, i, ret;
 
 	ret = mdp5_init(to_platform_device(dev->dev), dev);
+	if (ret)
+		return ret;
 
 	/* priv->kms would have been populated by the MDP5 driver */
 	kms = priv->kms;
@@ -632,9 +635,8 @@ static int mdp5_kms_init(struct drm_device *dev)
 	return ret;
 }
 
-static void mdp5_destroy(struct platform_device *pdev)
+static void mdp5_destroy(struct mdp5_kms *mdp5_kms)
 {
-	struct mdp5_kms *mdp5_kms = platform_get_drvdata(pdev);
 	int i;
 
 	if (mdp5_kms->ctlm)
@@ -648,7 +650,7 @@ static void mdp5_destroy(struct platform_device *pdev)
 		kfree(mdp5_kms->intfs[i]);
 
 	if (mdp5_kms->rpm_enabled)
-		pm_runtime_disable(&pdev->dev);
+		pm_runtime_disable(&mdp5_kms->pdev->dev);
 
 	drm_atomic_private_obj_fini(&mdp5_kms->glob_state);
 	drm_modeset_lock_fini(&mdp5_kms->glob_state_lock);
@@ -797,8 +799,6 @@ static int mdp5_init(struct platform_device *pdev, struct drm_device *dev)
 		goto fail;
 	}
 
-	platform_set_drvdata(pdev, mdp5_kms);
-
 	spin_lock_init(&mdp5_kms->resource_lock);
 
 	mdp5_kms->dev = dev;
@@ -839,9 +839,6 @@ static int mdp5_init(struct platform_device *pdev, struct drm_device *dev)
 	 */
 	clk_set_rate(mdp5_kms->core_clk, 200000000);
 
-	pm_runtime_enable(&pdev->dev);
-	mdp5_kms->rpm_enabled = true;
-
 	read_mdp_hw_revision(mdp5_kms, &major, &minor);
 
 	mdp5_kms->cfg = mdp5_cfg_init(mdp5_kms, major, minor);
@@ -893,10 +890,13 @@ static int mdp5_init(struct platform_device *pdev, struct drm_device *dev)
 	/* set uninit-ed kms */
 	priv->kms = &mdp5_kms->base.base;
 
+	pm_runtime_enable(&pdev->dev);
+	mdp5_kms->rpm_enabled = true;
+
 	return 0;
 fail:
 	if (mdp5_kms)
-		mdp5_destroy(pdev);
+		mdp5_destroy(mdp5_kms);
 	return ret;
 }
 
@@ -953,7 +953,8 @@ static int mdp5_dev_remove(struct platform_device *pdev)
 static __maybe_unused int mdp5_runtime_suspend(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
-	struct mdp5_kms *mdp5_kms = platform_get_drvdata(pdev);
+	struct msm_drm_private *priv = platform_get_drvdata(pdev);
+	struct mdp5_kms *mdp5_kms = to_mdp5_kms(to_mdp_kms(priv->kms));
 
 	DBG("");
 
@@ -963,7 +964,8 @@ static __maybe_unused int mdp5_runtime_suspend(struct device *dev)
 static __maybe_unused int mdp5_runtime_resume(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
-	struct mdp5_kms *mdp5_kms = platform_get_drvdata(pdev);
+	struct msm_drm_private *priv = platform_get_drvdata(pdev);
+	struct mdp5_kms *mdp5_kms = to_mdp5_kms(to_mdp_kms(priv->kms));
 
 	DBG("");
 
-- 
2.35.1



