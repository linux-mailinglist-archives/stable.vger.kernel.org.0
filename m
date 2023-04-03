Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96E456D47F1
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbjDCOYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233237AbjDCOYp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:24:45 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EBED4EFF
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:24:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 59E79CE12C7
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:24:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C881C433EF;
        Mon,  3 Apr 2023 14:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531865;
        bh=6f7KR+ALwyBHlBBYzNUIYCXLI+wSJM7AL3O+2NtVGQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uwf/gqqak2nYbCIgNRaXdmyp86AmlAyJc1cMP1Rzf1QE5Gyt04W8p/8C3gdMoVBF7
         eHhOBRs4vydkJmw08b38psRaAEZ4ZQCPA9JXevorKERbVKDEoDcowZRiMgUGtCeA6r
         qDkA375YXd390KEtYJ8N7X4LMCb9aXq+NEoLwfHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maxime Bizon <mbizon@freebox.fr>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Simon Horman <simon.horman@corigine.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 036/173] net: mdio: fix owner field for mdio buses registered using device-tree
Date:   Mon,  3 Apr 2023 16:07:31 +0200
Message-Id: <20230403140415.569774429@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Bizon <mbizon@freebox.fr>

[ Upstream commit 99669259f3361d759219811e670b7e0742668556 ]

Bus ownership is wrong when using of_mdiobus_register() to register an mdio
bus. That function is not inline, so when it calls mdiobus_register() the wrong
THIS_MODULE value is captured.

Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
Fixes: 90eff9096c01 ("net: phy: Allow splitting MDIO bus/device support from PHYs")
[florian: fix kdoc, added Fixes tag]
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mdio/of_mdio.c    | 12 +++++++-----
 drivers/net/phy/mdio_devres.c | 11 ++++++-----
 include/linux/of_mdio.h       | 22 +++++++++++++++++++---
 3 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 5bae47f3da405..b254127cea50d 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -238,21 +238,23 @@ bool of_mdiobus_child_is_phy(struct device_node *child)
 EXPORT_SYMBOL(of_mdiobus_child_is_phy);
 
 /**
- * of_mdiobus_register - Register mii_bus and create PHYs from the device tree
+ * __of_mdiobus_register - Register mii_bus and create PHYs from the device tree
  * @mdio: pointer to mii_bus structure
  * @np: pointer to device_node of MDIO bus.
+ * @owner: module owning the @mdio object.
  *
  * This function registers the mii_bus structure and registers a phy_device
  * for each child node of @np.
  */
-int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
+int __of_mdiobus_register(struct mii_bus *mdio, struct device_node *np,
+			  struct module *owner)
 {
 	struct device_node *child;
 	bool scanphys = false;
 	int addr, rc;
 
 	if (!np)
-		return mdiobus_register(mdio);
+		return __mdiobus_register(mdio, owner);
 
 	/* Do not continue if the node is disabled */
 	if (!of_device_is_available(np))
@@ -272,7 +274,7 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 	of_property_read_u32(np, "reset-post-delay-us", &mdio->reset_post_delay_us);
 
 	/* Register the MDIO bus */
-	rc = mdiobus_register(mdio);
+	rc = __mdiobus_register(mdio, owner);
 	if (rc)
 		return rc;
 
@@ -336,7 +338,7 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 	mdiobus_unregister(mdio);
 	return rc;
 }
-EXPORT_SYMBOL(of_mdiobus_register);
+EXPORT_SYMBOL(__of_mdiobus_register);
 
 /**
  * of_mdio_find_device - Given a device tree node, find the mdio_device
diff --git a/drivers/net/phy/mdio_devres.c b/drivers/net/phy/mdio_devres.c
index b560e99695dfd..69b829e6ab35b 100644
--- a/drivers/net/phy/mdio_devres.c
+++ b/drivers/net/phy/mdio_devres.c
@@ -98,13 +98,14 @@ EXPORT_SYMBOL(__devm_mdiobus_register);
 
 #if IS_ENABLED(CONFIG_OF_MDIO)
 /**
- * devm_of_mdiobus_register - Resource managed variant of of_mdiobus_register()
+ * __devm_of_mdiobus_register - Resource managed variant of of_mdiobus_register()
  * @dev:	Device to register mii_bus for
  * @mdio:	MII bus structure to register
  * @np:		Device node to parse
+ * @owner:	Owning module
  */
-int devm_of_mdiobus_register(struct device *dev, struct mii_bus *mdio,
-			     struct device_node *np)
+int __devm_of_mdiobus_register(struct device *dev, struct mii_bus *mdio,
+			       struct device_node *np, struct module *owner)
 {
 	struct mdiobus_devres *dr;
 	int ret;
@@ -117,7 +118,7 @@ int devm_of_mdiobus_register(struct device *dev, struct mii_bus *mdio,
 	if (!dr)
 		return -ENOMEM;
 
-	ret = of_mdiobus_register(mdio, np);
+	ret = __of_mdiobus_register(mdio, np, owner);
 	if (ret) {
 		devres_free(dr);
 		return ret;
@@ -127,7 +128,7 @@ int devm_of_mdiobus_register(struct device *dev, struct mii_bus *mdio,
 	devres_add(dev, dr);
 	return 0;
 }
-EXPORT_SYMBOL(devm_of_mdiobus_register);
+EXPORT_SYMBOL(__devm_of_mdiobus_register);
 #endif /* CONFIG_OF_MDIO */
 
 MODULE_LICENSE("GPL");
diff --git a/include/linux/of_mdio.h b/include/linux/of_mdio.h
index f56c6a9230ac8..8cc6522ee43ab 100644
--- a/include/linux/of_mdio.h
+++ b/include/linux/of_mdio.h
@@ -14,9 +14,25 @@
 
 #if IS_ENABLED(CONFIG_OF_MDIO)
 bool of_mdiobus_child_is_phy(struct device_node *child);
-int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np);
-int devm_of_mdiobus_register(struct device *dev, struct mii_bus *mdio,
-			     struct device_node *np);
+int __of_mdiobus_register(struct mii_bus *mdio, struct device_node *np,
+			  struct module *owner);
+
+static inline int of_mdiobus_register(struct mii_bus *mdio,
+				      struct device_node *np)
+{
+	return __of_mdiobus_register(mdio, np, THIS_MODULE);
+}
+
+int __devm_of_mdiobus_register(struct device *dev, struct mii_bus *mdio,
+			       struct device_node *np, struct module *owner);
+
+static inline int devm_of_mdiobus_register(struct device *dev,
+					   struct mii_bus *mdio,
+					   struct device_node *np)
+{
+	return __devm_of_mdiobus_register(dev, mdio, np, THIS_MODULE);
+}
+
 struct mdio_device *of_mdio_find_device(struct device_node *np);
 struct phy_device *of_phy_find_device(struct device_node *phy_np);
 struct phy_device *
-- 
2.39.2



