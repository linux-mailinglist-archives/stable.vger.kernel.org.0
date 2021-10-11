Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3BCF429099
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241064AbhJKOKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:10:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239058AbhJKOIQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:08:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E08B61056;
        Mon, 11 Oct 2021 14:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960869;
        bh=j1LIxd310G5te1DnCBq4Db8BBVpfxiJOkq5H8+UILJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r2Jpg+V5/+a6R6PvPwgw+cejE5Qu6VJJL3+h4Cj3gPXN2BC+p/+mVFIWbMUFnuT2P
         fUA3U/nyBtjXH7t92W578kCRJDEUg5fumNf14zkDXbXsLiVOh2mT0jg0HSDwAhau5C
         wMrT5lTPm3Xzd8kFo09C3UMW8VIe3od5Ka6PktQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 099/151] drm/sun4i: dw-hdmi: Fix HDMI PHY clock setup
Date:   Mon, 11 Oct 2021 15:46:11 +0200
Message-Id: <20211011134521.023383143@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit c64c8e04a12ed3e2238761e26cda78e72550dc98 ]

Recent rework, which made HDMI PHY driver a platform device, inadvertely
reversed clock setup order. HW is very touchy about it. Proper way is to
handle controllers resets and clocks first and HDMI PHYs second.

Currently, without this fix, first mode set completely fails (nothing on
HDMI monitor) on H3 era PHYs. On H6, it still somehow work.

Move HDMI PHY reset & clocks handling to sun8i_hdmi_phy_init() which
will assure that code is executed after controllers reset & clocks are
handled. Additionally, add sun8i_hdmi_phy_deinit() which will deinit
them at controllers driver unload.

Tested on A64, H3, H6 and R40.

Fixes: 9bf3797796f5 ("drm/sun4i: dw-hdmi: Make HDMI PHY into a platform device")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20210915175836.3158839-1-jernej.skrabec@gmail.com
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c  |  7 +-
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h  |  4 +-
 drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c | 97 ++++++++++++++------------
 3 files changed, 61 insertions(+), 47 deletions(-)

diff --git a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
index f75fb157f2ff..016b877051da 100644
--- a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
+++ b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
@@ -216,11 +216,13 @@ static int sun8i_dw_hdmi_bind(struct device *dev, struct device *master,
 		goto err_disable_clk_tmds;
 	}
 
+	ret = sun8i_hdmi_phy_init(hdmi->phy);
+	if (ret)
+		goto err_disable_clk_tmds;
+
 	drm_encoder_helper_add(encoder, &sun8i_dw_hdmi_encoder_helper_funcs);
 	drm_simple_encoder_init(drm, encoder, DRM_MODE_ENCODER_TMDS);
 
-	sun8i_hdmi_phy_init(hdmi->phy);
-
 	plat_data->mode_valid = hdmi->quirks->mode_valid;
 	plat_data->use_drm_infoframe = hdmi->quirks->use_drm_infoframe;
 	sun8i_hdmi_phy_set_ops(hdmi->phy, plat_data);
@@ -262,6 +264,7 @@ static void sun8i_dw_hdmi_unbind(struct device *dev, struct device *master,
 	struct sun8i_dw_hdmi *hdmi = dev_get_drvdata(dev);
 
 	dw_hdmi_unbind(hdmi->hdmi);
+	sun8i_hdmi_phy_deinit(hdmi->phy);
 	clk_disable_unprepare(hdmi->clk_tmds);
 	reset_control_assert(hdmi->rst_ctrl);
 	gpiod_set_value(hdmi->ddc_en, 0);
diff --git a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h
index 74f6ed0e2570..bffe1b9cd3dc 100644
--- a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h
+++ b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h
@@ -169,6 +169,7 @@ struct sun8i_hdmi_phy {
 	struct clk			*clk_phy;
 	struct clk			*clk_pll0;
 	struct clk			*clk_pll1;
+	struct device			*dev;
 	unsigned int			rcal;
 	struct regmap			*regs;
 	struct reset_control		*rst_phy;
@@ -205,7 +206,8 @@ encoder_to_sun8i_dw_hdmi(struct drm_encoder *encoder)
 
 int sun8i_hdmi_phy_get(struct sun8i_dw_hdmi *hdmi, struct device_node *node);
 
-void sun8i_hdmi_phy_init(struct sun8i_hdmi_phy *phy);
+int sun8i_hdmi_phy_init(struct sun8i_hdmi_phy *phy);
+void sun8i_hdmi_phy_deinit(struct sun8i_hdmi_phy *phy);
 void sun8i_hdmi_phy_set_ops(struct sun8i_hdmi_phy *phy,
 			    struct dw_hdmi_plat_data *plat_data);
 
diff --git a/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c b/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c
index c9239708d398..b64d93da651d 100644
--- a/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c
+++ b/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c
@@ -506,9 +506,60 @@ static void sun8i_hdmi_phy_init_h3(struct sun8i_hdmi_phy *phy)
 	phy->rcal = (val & SUN8I_HDMI_PHY_ANA_STS_RCAL_MASK) >> 2;
 }
 
-void sun8i_hdmi_phy_init(struct sun8i_hdmi_phy *phy)
+int sun8i_hdmi_phy_init(struct sun8i_hdmi_phy *phy)
 {
+	int ret;
+
+	ret = reset_control_deassert(phy->rst_phy);
+	if (ret) {
+		dev_err(phy->dev, "Cannot deassert phy reset control: %d\n", ret);
+		return ret;
+	}
+
+	ret = clk_prepare_enable(phy->clk_bus);
+	if (ret) {
+		dev_err(phy->dev, "Cannot enable bus clock: %d\n", ret);
+		goto err_assert_rst_phy;
+	}
+
+	ret = clk_prepare_enable(phy->clk_mod);
+	if (ret) {
+		dev_err(phy->dev, "Cannot enable mod clock: %d\n", ret);
+		goto err_disable_clk_bus;
+	}
+
+	if (phy->variant->has_phy_clk) {
+		ret = sun8i_phy_clk_create(phy, phy->dev,
+					   phy->variant->has_second_pll);
+		if (ret) {
+			dev_err(phy->dev, "Couldn't create the PHY clock\n");
+			goto err_disable_clk_mod;
+		}
+
+		clk_prepare_enable(phy->clk_phy);
+	}
+
 	phy->variant->phy_init(phy);
+
+	return 0;
+
+err_disable_clk_mod:
+	clk_disable_unprepare(phy->clk_mod);
+err_disable_clk_bus:
+	clk_disable_unprepare(phy->clk_bus);
+err_assert_rst_phy:
+	reset_control_assert(phy->rst_phy);
+
+	return ret;
+}
+
+void sun8i_hdmi_phy_deinit(struct sun8i_hdmi_phy *phy)
+{
+	clk_disable_unprepare(phy->clk_mod);
+	clk_disable_unprepare(phy->clk_bus);
+	clk_disable_unprepare(phy->clk_phy);
+
+	reset_control_assert(phy->rst_phy);
 }
 
 void sun8i_hdmi_phy_set_ops(struct sun8i_hdmi_phy *phy,
@@ -638,6 +689,7 @@ static int sun8i_hdmi_phy_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	phy->variant = (struct sun8i_hdmi_phy_variant *)match->data;
+	phy->dev = dev;
 
 	ret = of_address_to_resource(node, 0, &res);
 	if (ret) {
@@ -696,47 +748,10 @@ static int sun8i_hdmi_phy_probe(struct platform_device *pdev)
 		goto err_put_clk_pll1;
 	}
 
-	ret = reset_control_deassert(phy->rst_phy);
-	if (ret) {
-		dev_err(dev, "Cannot deassert phy reset control: %d\n", ret);
-		goto err_put_rst_phy;
-	}
-
-	ret = clk_prepare_enable(phy->clk_bus);
-	if (ret) {
-		dev_err(dev, "Cannot enable bus clock: %d\n", ret);
-		goto err_deassert_rst_phy;
-	}
-
-	ret = clk_prepare_enable(phy->clk_mod);
-	if (ret) {
-		dev_err(dev, "Cannot enable mod clock: %d\n", ret);
-		goto err_disable_clk_bus;
-	}
-
-	if (phy->variant->has_phy_clk) {
-		ret = sun8i_phy_clk_create(phy, dev,
-					   phy->variant->has_second_pll);
-		if (ret) {
-			dev_err(dev, "Couldn't create the PHY clock\n");
-			goto err_disable_clk_mod;
-		}
-
-		clk_prepare_enable(phy->clk_phy);
-	}
-
 	platform_set_drvdata(pdev, phy);
 
 	return 0;
 
-err_disable_clk_mod:
-	clk_disable_unprepare(phy->clk_mod);
-err_disable_clk_bus:
-	clk_disable_unprepare(phy->clk_bus);
-err_deassert_rst_phy:
-	reset_control_assert(phy->rst_phy);
-err_put_rst_phy:
-	reset_control_put(phy->rst_phy);
 err_put_clk_pll1:
 	clk_put(phy->clk_pll1);
 err_put_clk_pll0:
@@ -753,12 +768,6 @@ static int sun8i_hdmi_phy_remove(struct platform_device *pdev)
 {
 	struct sun8i_hdmi_phy *phy = platform_get_drvdata(pdev);
 
-	clk_disable_unprepare(phy->clk_mod);
-	clk_disable_unprepare(phy->clk_bus);
-	clk_disable_unprepare(phy->clk_phy);
-
-	reset_control_assert(phy->rst_phy);
-
 	reset_control_put(phy->rst_phy);
 
 	clk_put(phy->clk_pll0);
-- 
2.33.0



