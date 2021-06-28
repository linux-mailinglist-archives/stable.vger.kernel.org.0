Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC123B60DD
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233896AbhF1Oa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:30:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:36912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234451AbhF1O3u (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:29:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0ED861C9A;
        Mon, 28 Jun 2021 14:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890383;
        bh=D/8qI1JY9A2PEQb8nd5M7pYimRyXnzzuN+W4vjx7Bdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ejl67TrDlQCvjC69yrUd4229JgiWI1wsYBPzyPsA243tWzDPBv5MUfzrN1seXXcw9
         P1Sll1HN5kcTIH4Y4N6TT8A+hb2DIJCSG7lUfux05a+quD00er+oNwLjKI4qbA/GF3
         QsKBO55R/5C20bDdnSJYCEJNCQZMIvUvl9pn6qQ+5u3zfQiDv+mdKguRPxwZVEmBIS
         uss/LMTvPHgWs40nXU9fFJAkhkruM6ksr/x4jSu9gwLu8jtk61vvqKxDJ4+/oCrL/i
         XIly5286krwiuTIYwxeXqtA0KJN1LXcgpiQITvZq8KGWBKGjLiMq0avgco367P9MJo
         QQUcgSzJLjg7Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxime Ripard <maxime@cerno.tech>,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 015/101] drm/vc4: hdmi: Move the HSM clock enable to runtime_pm
Date:   Mon, 28 Jun 2021 10:24:41 -0400
Message-Id: <20210628142607.32218-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
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
index af5f01eff872..5978e99a0e85 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -415,7 +415,6 @@ static void vc4_hdmi_encoder_post_crtc_powerdown(struct drm_encoder *encoder)
 		   HDMI_READ(HDMI_VID_CTL) & ~VC4_HD_VID_CTL_ENABLE);
 
 	clk_disable_unprepare(vc4_hdmi->pixel_bvb_clock);
-	clk_disable_unprepare(vc4_hdmi->hsm_clock);
 	clk_disable_unprepare(vc4_hdmi->pixel_clock);
 
 	ret = pm_runtime_put(&vc4_hdmi->pdev->dev);
@@ -666,13 +665,6 @@ static void vc4_hdmi_encoder_pre_crtc_configure(struct drm_encoder *encoder)
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
@@ -683,7 +675,6 @@ static void vc4_hdmi_encoder_pre_crtc_configure(struct drm_encoder *encoder)
 			       (hsm_rate > VC4_HSM_MID_CLOCK ? 150000000 : 75000000));
 	if (ret) {
 		DRM_ERROR("Failed to set pixel bvb clock rate: %d\n", ret);
-		clk_disable_unprepare(vc4_hdmi->hsm_clock);
 		clk_disable_unprepare(vc4_hdmi->pixel_clock);
 		return;
 	}
@@ -691,7 +682,6 @@ static void vc4_hdmi_encoder_pre_crtc_configure(struct drm_encoder *encoder)
 	ret = clk_prepare_enable(vc4_hdmi->pixel_bvb_clock);
 	if (ret) {
 		DRM_ERROR("Failed to turn on pixel bvb clock: %d\n", ret);
-		clk_disable_unprepare(vc4_hdmi->hsm_clock);
 		clk_disable_unprepare(vc4_hdmi->pixel_clock);
 		return;
 	}
@@ -1724,6 +1714,29 @@ static int vc5_hdmi_init_resources(struct vc4_hdmi *vc4_hdmi)
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
@@ -1959,11 +1972,18 @@ static const struct of_device_id vc4_hdmi_dt_match[] = {
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

