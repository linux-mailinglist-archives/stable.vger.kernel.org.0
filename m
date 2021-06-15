Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABFAC3A8505
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbhFOPxA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:53:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232260AbhFOPwC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:52:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E53316162F;
        Tue, 15 Jun 2021 15:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772198;
        bh=h927+2IxhQUvmDsFhXiGWx7fuJ9Tik4yJCKJT0/qBEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k65u/IICe3ZzyaYSImIW9+7vqtuqdCshlfezFmlRsdGGyAwEOMBl2tndD8JSa93nM
         aWtw0E3htQrZZ/es73yocDQMbm0OnCmp1OcDVQG/fp8S4aRtBa2S2vJYV+2fkFf3RH
         L8BvkvdHGzyjRTixfAXgSmtYw9kNIf9jslyeWzHfHshj5uVtqFwutOio0kw20j9g+e
         uDxkUEFPiR08CMK6ubgtGpy1H91kzc26CwRidmxqT/zD7+jKOWkxgqnBQkf/bjAjCb
         eAqKZp2QRWjdy4uBwhTkmAqzfvE0IRQDfkwqcphAK5JFpTJtw9xxDofO5Fz64kAoHb
         SQoRlXe27jGaA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Saravana Kannan <saravanak@google.com>,
        Ondrej Jirman <megous@megous.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev
Subject: [PATCH AUTOSEL 5.4 07/15] drm/sun4i: dw-hdmi: Make HDMI PHY into a platform device
Date:   Tue, 15 Jun 2021 11:49:39 -0400
Message-Id: <20210615154948.62711-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615154948.62711-1-sashal@kernel.org>
References: <20210615154948.62711-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saravana Kannan <saravanak@google.com>

[ Upstream commit 9bf3797796f570b34438235a6a537df85832bdad ]

On sunxi boards that use HDMI output, HDMI device probe keeps being
avoided indefinitely with these repeated messages in dmesg:

  platform 1ee0000.hdmi: probe deferral - supplier 1ef0000.hdmi-phy
    not ready

There's a fwnode_link being created with fw_devlink=on between hdmi
and hdmi-phy nodes, because both nodes have 'compatible' property set.

Fw_devlink code assumes that nodes that have compatible property
set will also have a device associated with them by some driver
eventually. This is not the case with the current sun8i-hdmi
driver.

This commit makes sun8i-hdmi-phy into a proper platform device
and fixes the display pipeline probe on sunxi boards that use HDMI.

More context: https://lkml.org/lkml/2021/5/16/203

Signed-off-by: Saravana Kannan <saravanak@google.com>
Signed-off-by: Ondrej Jirman <megous@megous.com>
Tested-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20210607085836.2827429-1-megous@megous.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c  | 31 ++++++++++++++++---
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h  |  5 ++--
 drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c | 41 ++++++++++++++++++++++----
 3 files changed, 66 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
index 8f721be26477..cfb63cae4b12 100644
--- a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
+++ b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
@@ -211,7 +211,7 @@ static int sun8i_dw_hdmi_bind(struct device *dev, struct device *master,
 		goto err_disable_clk_tmds;
 	}
 
-	ret = sun8i_hdmi_phy_probe(hdmi, phy_node);
+	ret = sun8i_hdmi_phy_get(hdmi, phy_node);
 	of_node_put(phy_node);
 	if (ret) {
 		dev_err(dev, "Couldn't get the HDMI PHY\n");
@@ -244,7 +244,6 @@ static int sun8i_dw_hdmi_bind(struct device *dev, struct device *master,
 
 cleanup_encoder:
 	drm_encoder_cleanup(encoder);
-	sun8i_hdmi_phy_remove(hdmi);
 err_disable_clk_tmds:
 	clk_disable_unprepare(hdmi->clk_tmds);
 err_assert_ctrl_reset:
@@ -265,7 +264,6 @@ static void sun8i_dw_hdmi_unbind(struct device *dev, struct device *master,
 	struct sun8i_dw_hdmi *hdmi = dev_get_drvdata(dev);
 
 	dw_hdmi_unbind(hdmi->hdmi);
-	sun8i_hdmi_phy_remove(hdmi);
 	clk_disable_unprepare(hdmi->clk_tmds);
 	reset_control_assert(hdmi->rst_ctrl);
 	gpiod_set_value(hdmi->ddc_en, 0);
@@ -322,7 +320,32 @@ static struct platform_driver sun8i_dw_hdmi_pltfm_driver = {
 		.of_match_table = sun8i_dw_hdmi_dt_ids,
 	},
 };
-module_platform_driver(sun8i_dw_hdmi_pltfm_driver);
+
+static int __init sun8i_dw_hdmi_init(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&sun8i_dw_hdmi_pltfm_driver);
+	if (ret)
+		return ret;
+
+	ret = platform_driver_register(&sun8i_hdmi_phy_driver);
+	if (ret) {
+		platform_driver_unregister(&sun8i_dw_hdmi_pltfm_driver);
+		return ret;
+	}
+
+	return ret;
+}
+
+static void __exit sun8i_dw_hdmi_exit(void)
+{
+	platform_driver_unregister(&sun8i_dw_hdmi_pltfm_driver);
+	platform_driver_unregister(&sun8i_hdmi_phy_driver);
+}
+
+module_init(sun8i_dw_hdmi_init);
+module_exit(sun8i_dw_hdmi_exit);
 
 MODULE_AUTHOR("Jernej Skrabec <jernej.skrabec@siol.net>");
 MODULE_DESCRIPTION("Allwinner DW HDMI bridge");
diff --git a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h
index d707c9171824..5a299a6f5aa5 100644
--- a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h
+++ b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h
@@ -194,14 +194,15 @@ struct sun8i_dw_hdmi {
 	struct gpio_desc		*ddc_en;
 };
 
+extern struct platform_driver sun8i_hdmi_phy_driver;
+
 static inline struct sun8i_dw_hdmi *
 encoder_to_sun8i_dw_hdmi(struct drm_encoder *encoder)
 {
 	return container_of(encoder, struct sun8i_dw_hdmi, encoder);
 }
 
-int sun8i_hdmi_phy_probe(struct sun8i_dw_hdmi *hdmi, struct device_node *node);
-void sun8i_hdmi_phy_remove(struct sun8i_dw_hdmi *hdmi);
+int sun8i_hdmi_phy_get(struct sun8i_dw_hdmi *hdmi, struct device_node *node);
 
 void sun8i_hdmi_phy_init(struct sun8i_hdmi_phy *phy);
 void sun8i_hdmi_phy_set_ops(struct sun8i_hdmi_phy *phy,
diff --git a/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c b/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c
index a4012ec13d4b..c6289328c874 100644
--- a/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c
+++ b/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c
@@ -5,6 +5,7 @@
 
 #include <linux/delay.h>
 #include <linux/of_address.h>
+#include <linux/of_platform.h>
 
 #include "sun8i_dw_hdmi.h"
 
@@ -596,10 +597,30 @@ static const struct of_device_id sun8i_hdmi_phy_of_table[] = {
 	{ /* sentinel */ }
 };
 
-int sun8i_hdmi_phy_probe(struct sun8i_dw_hdmi *hdmi, struct device_node *node)
+int sun8i_hdmi_phy_get(struct sun8i_dw_hdmi *hdmi, struct device_node *node)
+{
+	struct platform_device *pdev = of_find_device_by_node(node);
+	struct sun8i_hdmi_phy *phy;
+
+	if (!pdev)
+		return -EPROBE_DEFER;
+
+	phy = platform_get_drvdata(pdev);
+	if (!phy)
+		return -EPROBE_DEFER;
+
+	hdmi->phy = phy;
+
+	put_device(&pdev->dev);
+
+	return 0;
+}
+
+static int sun8i_hdmi_phy_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *match;
-	struct device *dev = hdmi->dev;
+	struct device *dev = &pdev->dev;
+	struct device_node *node = dev->of_node;
 	struct sun8i_hdmi_phy *phy;
 	struct resource res;
 	void __iomem *regs;
@@ -703,7 +724,7 @@ int sun8i_hdmi_phy_probe(struct sun8i_dw_hdmi *hdmi, struct device_node *node)
 		clk_prepare_enable(phy->clk_phy);
 	}
 
-	hdmi->phy = phy;
+	platform_set_drvdata(pdev, phy);
 
 	return 0;
 
@@ -727,9 +748,9 @@ int sun8i_hdmi_phy_probe(struct sun8i_dw_hdmi *hdmi, struct device_node *node)
 	return ret;
 }
 
-void sun8i_hdmi_phy_remove(struct sun8i_dw_hdmi *hdmi)
+static int sun8i_hdmi_phy_remove(struct platform_device *pdev)
 {
-	struct sun8i_hdmi_phy *phy = hdmi->phy;
+	struct sun8i_hdmi_phy *phy = platform_get_drvdata(pdev);
 
 	clk_disable_unprepare(phy->clk_mod);
 	clk_disable_unprepare(phy->clk_bus);
@@ -743,4 +764,14 @@ void sun8i_hdmi_phy_remove(struct sun8i_dw_hdmi *hdmi)
 	clk_put(phy->clk_pll1);
 	clk_put(phy->clk_mod);
 	clk_put(phy->clk_bus);
+	return 0;
 }
+
+struct platform_driver sun8i_hdmi_phy_driver = {
+	.probe  = sun8i_hdmi_phy_probe,
+	.remove = sun8i_hdmi_phy_remove,
+	.driver = {
+		.name = "sun8i-hdmi-phy",
+		.of_match_table = sun8i_hdmi_phy_of_table,
+	},
+};
-- 
2.30.2

