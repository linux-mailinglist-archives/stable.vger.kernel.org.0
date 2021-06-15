Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 638203A853D
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbhFOPyM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:54:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232442AbhFOPwl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:52:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DB36616E8;
        Tue, 15 Jun 2021 15:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772217;
        bh=5B/sNgq6mLqhg5dcXERN/QFxhihe4SKiipJ5eFHh8fY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UOg9/H3zRFhbKVKHG6XMMwNsJLF3+n+nGGQvU6Gf4F7jN0y6SNEnHGRjvhf8K1bjo
         5dJHwy0934ao/jCo+AR0UVdrYdoxyyTUox43TPq4kh4/JVz0cB1T5nfkXMo9QDhLj8
         hLUMjowWJf8EUMUUDZBHD5VvGM58Giy1n6eR1BaO+9z9gdSuqc7LkHilgINrozyroz
         iAO1A/ddB3KUGogTk4tgexpQW+BjhuIl/jSq8iodQRFot3u9tmveNpGyH09ooaONle
         Af7l/k/kWOsS9avknqCKwrOQOZax7cCCU8fg8HJ4yRra75gouTUfUFsyOssQn9g9Ca
         JXygr1BbZ7oow==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Saravana Kannan <saravanak@google.com>,
        Ondrej Jirman <megous@megous.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev
Subject: [PATCH AUTOSEL 4.19 05/12] drm/sun4i: dw-hdmi: Make HDMI PHY into a platform device
Date:   Tue, 15 Jun 2021 11:50:02 -0400
Message-Id: <20210615155009.62894-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615155009.62894-1-sashal@kernel.org>
References: <20210615155009.62894-1-sashal@kernel.org>
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
index 5073622cbb56..ab048f9412e7 100644
--- a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
+++ b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
@@ -144,7 +144,7 @@ static int sun8i_dw_hdmi_bind(struct device *dev, struct device *master,
 		goto err_disable_clk_tmds;
 	}
 
-	ret = sun8i_hdmi_phy_probe(hdmi, phy_node);
+	ret = sun8i_hdmi_phy_get(hdmi, phy_node);
 	of_node_put(phy_node);
 	if (ret) {
 		dev_err(dev, "Couldn't get the HDMI PHY\n");
@@ -179,7 +179,6 @@ static int sun8i_dw_hdmi_bind(struct device *dev, struct device *master,
 
 cleanup_encoder:
 	drm_encoder_cleanup(encoder);
-	sun8i_hdmi_phy_remove(hdmi);
 err_disable_clk_tmds:
 	clk_disable_unprepare(hdmi->clk_tmds);
 err_assert_ctrl_reset:
@@ -194,7 +193,6 @@ static void sun8i_dw_hdmi_unbind(struct device *dev, struct device *master,
 	struct sun8i_dw_hdmi *hdmi = dev_get_drvdata(dev);
 
 	dw_hdmi_unbind(hdmi->hdmi);
-	sun8i_hdmi_phy_remove(hdmi);
 	clk_disable_unprepare(hdmi->clk_tmds);
 	reset_control_assert(hdmi->rst_ctrl);
 }
@@ -230,7 +228,32 @@ static struct platform_driver sun8i_dw_hdmi_pltfm_driver = {
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
index aadbe0a10b0c..41355bf3aca8 100644
--- a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h
+++ b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h
@@ -179,14 +179,15 @@ struct sun8i_dw_hdmi {
 	struct reset_control		*rst_ctrl;
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
 const struct dw_hdmi_phy_ops *sun8i_hdmi_phy_get_ops(void);
diff --git a/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c b/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c
index dc9b1398adb9..7e7a81f9d29a 100644
--- a/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c
+++ b/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c
@@ -5,6 +5,7 @@
 
 #include <linux/delay.h>
 #include <linux/of_address.h>
+#include <linux/of_platform.h>
 
 #include "sun8i_dw_hdmi.h"
 
@@ -433,10 +434,30 @@ static const struct of_device_id sun8i_hdmi_phy_of_table[] = {
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
@@ -540,7 +561,7 @@ int sun8i_hdmi_phy_probe(struct sun8i_dw_hdmi *hdmi, struct device_node *node)
 		clk_prepare_enable(phy->clk_phy);
 	}
 
-	hdmi->phy = phy;
+	platform_set_drvdata(pdev, phy);
 
 	return 0;
 
@@ -564,9 +585,9 @@ int sun8i_hdmi_phy_probe(struct sun8i_dw_hdmi *hdmi, struct device_node *node)
 	return ret;
 }
 
-void sun8i_hdmi_phy_remove(struct sun8i_dw_hdmi *hdmi)
+static int sun8i_hdmi_phy_remove(struct platform_device *pdev)
 {
-	struct sun8i_hdmi_phy *phy = hdmi->phy;
+	struct sun8i_hdmi_phy *phy = platform_get_drvdata(pdev);
 
 	clk_disable_unprepare(phy->clk_mod);
 	clk_disable_unprepare(phy->clk_bus);
@@ -580,4 +601,14 @@ void sun8i_hdmi_phy_remove(struct sun8i_dw_hdmi *hdmi)
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

