Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F08D53B5FE3
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbhF1OVS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:21:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232684AbhF1OVJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:21:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCB1361C7F;
        Mon, 28 Jun 2021 14:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889922;
        bh=pr2RjHWHc8rFfot+Body560wA3mLcqTnexuc3AbKGfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lQrtt480LJpXd7zDiYHLYWt7reQeL4cGhU4vhVh1byVgEpqKKVtGGPlaJF6YkmMfE
         0PDqld794cIBnV73c0sJ9RnRqwTuwKjwOQqDhdYcUh3cuKtPUCiveO3sN/o4tzbdNw
         gQVcW7zOF4XgGWxavIPmRB2XhQN2tKpEh/JiXhpeuLCZjw3iX66ECiRwXwkwnPwc01
         ioBYUv1M4oVdBI+/Oz5/+vHIWhZbCHUf3LSin6AX24Fg8o8ftdIW85MONOdIcLMGtz
         ZUnCebxM7+PhTdcDebLwG0YTEnhDxnMbKa/qb2hYMYyPA4qqIppN1QQS6jJtzlFt1X
         VS3sgxazPiU+Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxime Ripard <maxime@cerno.tech>,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 013/110] drm/vc4: hdmi: Move the HSM clock enable to runtime_pm
Date:   Mon, 28 Jun 2021 10:16:51 -0400
Message-Id: <20210628141828.31757-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 411efa18e4b03840553ff58ad9b4621b82a30c04 ]

In order to access the HDMI controller, we need to make sure the HSM
clock is enabled. If we were to access it with the clock disabled, the
CPU would completely hang, resulting in an hard crash.

Since we have different code path that would require it, let's move that
clock enable / disable to runtime_pm that will take care of the
reference counting for us.

Fixes: 4f6e3d66ac52 ("drm/vc4: Add runtime PM support to the HDMI encoder driver")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210525091059.234116-3-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 40 +++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 1fda574579af..84e218365045 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -473,7 +473,6 @@ static void vc4_hdmi_encoder_post_crtc_powerdown(struct drm_encoder *encoder,
 		   HDMI_READ(HDMI_VID_CTL) & ~VC4_HD_VID_CTL_ENABLE);
 
 	clk_disable_unprepare(vc4_hdmi->pixel_bvb_clock);
-	clk_disable_unprepare(vc4_hdmi->hsm_clock);
 	clk_disable_unprepare(vc4_hdmi->pixel_clock);
 
 	ret = pm_runtime_put(&vc4_hdmi->pdev->dev);
@@ -784,13 +783,6 @@ static void vc4_hdmi_encoder_pre_crtc_configure(struct drm_encoder *encoder,
 		return;
 	}
 
-	ret = clk_prepare_enable(vc4_hdmi->hsm_clock);
-	if (ret) {
-		DRM_ERROR("Failed to turn on HSM clock: %d\n", ret);
-		clk_disable_unprepare(vc4_hdmi->pixel_clock);
-		return;
-	}
-
 	vc4_hdmi_cec_update_clk_div(vc4_hdmi);
 
 	/*
@@ -801,7 +793,6 @@ static void vc4_hdmi_encoder_pre_crtc_configure(struct drm_encoder *encoder,
 			       (hsm_rate > VC4_HSM_MID_CLOCK ? 150000000 : 75000000));
 	if (ret) {
 		DRM_ERROR("Failed to set pixel bvb clock rate: %d\n", ret);
-		clk_disable_unprepare(vc4_hdmi->hsm_clock);
 		clk_disable_unprepare(vc4_hdmi->pixel_clock);
 		return;
 	}
@@ -809,7 +800,6 @@ static void vc4_hdmi_encoder_pre_crtc_configure(struct drm_encoder *encoder,
 	ret = clk_prepare_enable(vc4_hdmi->pixel_bvb_clock);
 	if (ret) {
 		DRM_ERROR("Failed to turn on pixel bvb clock: %d\n", ret);
-		clk_disable_unprepare(vc4_hdmi->hsm_clock);
 		clk_disable_unprepare(vc4_hdmi->pixel_clock);
 		return;
 	}
@@ -1929,6 +1919,29 @@ static int vc5_hdmi_init_resources(struct vc4_hdmi *vc4_hdmi)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int vc4_hdmi_runtime_suspend(struct device *dev)
+{
+	struct vc4_hdmi *vc4_hdmi = dev_get_drvdata(dev);
+
+	clk_disable_unprepare(vc4_hdmi->hsm_clock);
+
+	return 0;
+}
+
+static int vc4_hdmi_runtime_resume(struct device *dev)
+{
+	struct vc4_hdmi *vc4_hdmi = dev_get_drvdata(dev);
+	int ret;
+
+	ret = clk_prepare_enable(vc4_hdmi->hsm_clock);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+#endif
+
 static int vc4_hdmi_bind(struct device *dev, struct device *master, void *data)
 {
 	const struct vc4_hdmi_variant *variant = of_device_get_match_data(dev);
@@ -2165,11 +2178,18 @@ static const struct of_device_id vc4_hdmi_dt_match[] = {
 	{}
 };
 
+static const struct dev_pm_ops vc4_hdmi_pm_ops = {
+	SET_RUNTIME_PM_OPS(vc4_hdmi_runtime_suspend,
+			   vc4_hdmi_runtime_resume,
+			   NULL)
+};
+
 struct platform_driver vc4_hdmi_driver = {
 	.probe = vc4_hdmi_dev_probe,
 	.remove = vc4_hdmi_dev_remove,
 	.driver = {
 		.name = "vc4_hdmi",
 		.of_match_table = vc4_hdmi_dt_match,
+		.pm = &vc4_hdmi_pm_ops,
 	},
 };
-- 
2.30.2

