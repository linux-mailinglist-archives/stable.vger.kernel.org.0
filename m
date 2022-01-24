Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A342499229
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343779AbiAXURo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:17:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55020 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350636AbiAXUOM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:14:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB64DB8121A;
        Mon, 24 Jan 2022 20:14:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5AD4C340E5;
        Mon, 24 Jan 2022 20:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055249;
        bh=o2QxWLeePrFosPdwgej/1hVzp0b2TWbWmKtp6ux2Ns0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nOpnlxM2U/TgWfwB6a23Pw2toYmidsFi/TqiEAWb+bVdcN/o+eBWfNLaeCUWGVgXf
         kq5TqfB/Rnv3s4BtoDwltjQE5CdGyY60mOoB1No6g6rwRNTI/S0impiQncO2wTc6NY
         hC+xmJ2cRQ31ogs8MCidEnv3l/dJRIMZxRa2KK5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Michael Stapelberg <michael@stapelberg.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 090/846] drm/vc4: hdmi: Move the HSM clock enable to runtime_pm
Date:   Mon, 24 Jan 2022 19:33:27 +0100
Message-Id: <20220124184104.093369677@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit c86b41214362e8e715e1343e16d5d6af0562db05 ]

In order to access the HDMI controller, we need to make sure the HSM
clock is enabled. If we were to access it with the clock disabled, the
CPU would completely hang, resulting in an hard crash.

Since we have different code path that would require it, let's move that
clock enable / disable to runtime_pm that will take care of the
reference counting for us.

Since we also want to change the HSM clock rate and it's only valid
while the clock is disabled, we need to move the clk_set_min_rate() call
on the HSM clock above pm_runtime_get_and_sync().

Fixes: 4f6e3d66ac52 ("drm/vc4: Add runtime PM support to the HDMI encoder driver")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Reviewed-by: Nicolas Saenz Julienne <nsaenz@kernel.org>
Tested-by: Nicolas Saenz Julienne <nsaenz@kernel.org>
Tested-by: Michael Stapelberg <michael@stapelberg.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20210922125419.4125779-5-maxime@cerno.tech
Link: https://lore.kernel.org/linux-arm-kernel/20210924152334.1342630-1-maxime@cerno.tech/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 70 +++++++++++++++++++++-------------
 1 file changed, 44 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 623a4699bd212..6b0700d0b408e 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -628,7 +628,6 @@ static void vc4_hdmi_encoder_post_crtc_powerdown(struct drm_encoder *encoder,
 		vc4_hdmi->variant->phy_disable(vc4_hdmi);
 
 	clk_disable_unprepare(vc4_hdmi->pixel_bvb_clock);
-	clk_disable_unprepare(vc4_hdmi->hsm_clock);
 	clk_disable_unprepare(vc4_hdmi->pixel_clock);
 
 	ret = pm_runtime_put(&vc4_hdmi->pdev->dev);
@@ -894,28 +893,10 @@ static void vc4_hdmi_encoder_pre_crtc_configure(struct drm_encoder *encoder,
 		conn_state_to_vc4_hdmi_conn_state(conn_state);
 	struct drm_display_mode *mode = &encoder->crtc->state->adjusted_mode;
 	struct vc4_hdmi *vc4_hdmi = encoder_to_vc4_hdmi(encoder);
-	unsigned long bvb_rate, pixel_rate, hsm_rate;
+	unsigned long pixel_rate = vc4_conn_state->pixel_rate;
+	unsigned long bvb_rate, hsm_rate;
 	int ret;
 
-	ret = pm_runtime_resume_and_get(&vc4_hdmi->pdev->dev);
-	if (ret < 0) {
-		DRM_ERROR("Failed to retain power domain: %d\n", ret);
-		return;
-	}
-
-	pixel_rate = vc4_conn_state->pixel_rate;
-	ret = clk_set_rate(vc4_hdmi->pixel_clock, pixel_rate);
-	if (ret) {
-		DRM_ERROR("Failed to set pixel clock rate: %d\n", ret);
-		return;
-	}
-
-	ret = clk_prepare_enable(vc4_hdmi->pixel_clock);
-	if (ret) {
-		DRM_ERROR("Failed to turn on pixel clock: %d\n", ret);
-		return;
-	}
-
 	/*
 	 * As stated in RPi's vc4 firmware "HDMI state machine (HSM) clock must
 	 * be faster than pixel clock, infinitesimally faster, tested in
@@ -939,10 +920,21 @@ static void vc4_hdmi_encoder_pre_crtc_configure(struct drm_encoder *encoder,
 		return;
 	}
 
-	ret = clk_prepare_enable(vc4_hdmi->hsm_clock);
+	ret = pm_runtime_resume_and_get(&vc4_hdmi->pdev->dev);
+	if (ret < 0) {
+		DRM_ERROR("Failed to retain power domain: %d\n", ret);
+		return;
+	}
+
+	ret = clk_set_rate(vc4_hdmi->pixel_clock, pixel_rate);
 	if (ret) {
-		DRM_ERROR("Failed to turn on HSM clock: %d\n", ret);
-		clk_disable_unprepare(vc4_hdmi->pixel_clock);
+		DRM_ERROR("Failed to set pixel clock rate: %d\n", ret);
+		return;
+	}
+
+	ret = clk_prepare_enable(vc4_hdmi->pixel_clock);
+	if (ret) {
+		DRM_ERROR("Failed to turn on pixel clock: %d\n", ret);
 		return;
 	}
 
@@ -958,7 +950,6 @@ static void vc4_hdmi_encoder_pre_crtc_configure(struct drm_encoder *encoder,
 	ret = clk_set_min_rate(vc4_hdmi->pixel_bvb_clock, bvb_rate);
 	if (ret) {
 		DRM_ERROR("Failed to set pixel bvb clock rate: %d\n", ret);
-		clk_disable_unprepare(vc4_hdmi->hsm_clock);
 		clk_disable_unprepare(vc4_hdmi->pixel_clock);
 		return;
 	}
@@ -966,7 +957,6 @@ static void vc4_hdmi_encoder_pre_crtc_configure(struct drm_encoder *encoder,
 	ret = clk_prepare_enable(vc4_hdmi->pixel_bvb_clock);
 	if (ret) {
 		DRM_ERROR("Failed to turn on pixel bvb clock: %d\n", ret);
-		clk_disable_unprepare(vc4_hdmi->hsm_clock);
 		clk_disable_unprepare(vc4_hdmi->pixel_clock);
 		return;
 	}
@@ -2099,6 +2089,27 @@ static int vc5_hdmi_init_resources(struct vc4_hdmi *vc4_hdmi)
 	return 0;
 }
 
+static int __maybe_unused vc4_hdmi_runtime_suspend(struct device *dev)
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
+
 static int vc4_hdmi_bind(struct device *dev, struct device *master, void *data)
 {
 	const struct vc4_hdmi_variant *variant = of_device_get_match_data(dev);
@@ -2366,11 +2377,18 @@ static const struct of_device_id vc4_hdmi_dt_match[] = {
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
2.34.1



