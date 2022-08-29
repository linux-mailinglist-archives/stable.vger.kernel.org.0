Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D31A5A4945
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbiH2LWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231724AbiH2LVY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:21:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7EDF6334;
        Mon, 29 Aug 2022 04:14:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E55D2B80FD4;
        Mon, 29 Aug 2022 11:13:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5325BC433C1;
        Mon, 29 Aug 2022 11:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771596;
        bh=8tugZhuC6oRf8RJpwUQ9Xb2AB7C4/+bU00sZcnURoTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CeF9HXywnbmnDIPVq/cYyRu/PKyXCtGWgZKgU+kANo9AW88Efc82UOG7hSCVNp2cK
         78hnaHN+XM9vUy6+OfxhKPMuny0z/NTJJdC7ZecTKz+CsV3csObjj8YLVBQdVN2+wc
         Iz3XARQQHrjXF2dVSNGRtIw3T3RL7o27gx5IKCQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Ferry Toth <fntoth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Andre Edich <andre.edich@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 120/136] Revert "usbnet: smsc95xx: Forward PHY interrupts to PHY driver to avoid polling"
Date:   Mon, 29 Aug 2022 12:59:47 +0200
Message-Id: <20220829105809.603695465@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit eaf3a094d8924ecb0baacf6df62ae1c6a96083cf which is
upstream commit 1ce8b37241ed291af56f7a49bbdbf20c08728e88.

It is reported to cause problems, so drop it from the 5.15.y tree until
the root cause can be determined.

Reported-by: Lukas Wunner <lukas@wunner.de>
Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: Ferry Toth <fntoth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Andre Edich <andre.edich@microchip.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Sasha Levin <sashal@kernel.org>
Link: https://lore.kernel.org/r/20220826132137.GA24932@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/smsc95xx.c |  113 ++++++++++++++++++++-------------------------
 1 file changed, 52 insertions(+), 61 deletions(-)

--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -18,8 +18,6 @@
 #include <linux/usb/usbnet.h>
 #include <linux/slab.h>
 #include <linux/of_net.h>
-#include <linux/irq.h>
-#include <linux/irqdomain.h>
 #include <linux/mdio.h>
 #include <linux/phy.h>
 #include "smsc95xx.h"
@@ -53,9 +51,6 @@
 #define SUSPEND_ALLMODES		(SUSPEND_SUSPEND0 | SUSPEND_SUSPEND1 | \
 					 SUSPEND_SUSPEND2 | SUSPEND_SUSPEND3)
 
-#define SMSC95XX_NR_IRQS		(1) /* raise to 12 for GPIOs */
-#define PHY_HWIRQ			(SMSC95XX_NR_IRQS - 1)
-
 struct smsc95xx_priv {
 	u32 mac_cr;
 	u32 hash_hi;
@@ -64,9 +59,6 @@ struct smsc95xx_priv {
 	spinlock_t mac_cr_lock;
 	u8 features;
 	u8 suspend_flags;
-	struct irq_chip irqchip;
-	struct irq_domain *irqdomain;
-	struct fwnode_handle *irqfwnode;
 	struct mii_bus *mdiobus;
 	struct phy_device *phydev;
 };
@@ -603,8 +595,6 @@ static void smsc95xx_mac_update_fulldupl
 
 static void smsc95xx_status(struct usbnet *dev, struct urb *urb)
 {
-	struct smsc95xx_priv *pdata = dev->driver_priv;
-	unsigned long flags;
 	u32 intdata;
 
 	if (urb->actual_length != 4) {
@@ -616,15 +606,11 @@ static void smsc95xx_status(struct usbne
 	intdata = get_unaligned_le32(urb->transfer_buffer);
 	netif_dbg(dev, link, dev->net, "intdata: 0x%08X\n", intdata);
 
-	local_irq_save(flags);
-
 	if (intdata & INT_ENP_PHY_INT_)
-		generic_handle_domain_irq(pdata->irqdomain, PHY_HWIRQ);
+		;
 	else
 		netdev_warn(dev->net, "unexpected interrupt, intdata=0x%08X\n",
 			    intdata);
-
-	local_irq_restore(flags);
 }
 
 /* Enable or disable Tx & Rx checksum offload engines */
@@ -1086,9 +1072,8 @@ static int smsc95xx_bind(struct usbnet *
 {
 	struct smsc95xx_priv *pdata;
 	bool is_internal_phy;
-	char usb_path[64];
-	int ret, phy_irq;
 	u32 val;
+	int ret;
 
 	printk(KERN_INFO SMSC_CHIPNAME " v" SMSC_DRIVER_VERSION "\n");
 
@@ -1128,38 +1113,10 @@ static int smsc95xx_bind(struct usbnet *
 	if (ret)
 		goto free_pdata;
 
-	/* create irq domain for use by PHY driver and GPIO consumers */
-	usb_make_path(dev->udev, usb_path, sizeof(usb_path));
-	pdata->irqfwnode = irq_domain_alloc_named_fwnode(usb_path);
-	if (!pdata->irqfwnode) {
-		ret = -ENOMEM;
-		goto free_pdata;
-	}
-
-	pdata->irqdomain = irq_domain_create_linear(pdata->irqfwnode,
-						    SMSC95XX_NR_IRQS,
-						    &irq_domain_simple_ops,
-						    pdata);
-	if (!pdata->irqdomain) {
-		ret = -ENOMEM;
-		goto free_irqfwnode;
-	}
-
-	phy_irq = irq_create_mapping(pdata->irqdomain, PHY_HWIRQ);
-	if (!phy_irq) {
-		ret = -ENOENT;
-		goto remove_irqdomain;
-	}
-
-	pdata->irqchip = dummy_irq_chip;
-	pdata->irqchip.name = SMSC_CHIPNAME;
-	irq_set_chip_and_handler_name(phy_irq, &pdata->irqchip,
-				      handle_simple_irq, "phy");
-
 	pdata->mdiobus = mdiobus_alloc();
 	if (!pdata->mdiobus) {
 		ret = -ENOMEM;
-		goto dispose_irq;
+		goto free_pdata;
 	}
 
 	ret = smsc95xx_read_reg(dev, HW_CFG, &val);
@@ -1192,7 +1149,6 @@ static int smsc95xx_bind(struct usbnet *
 		goto unregister_mdio;
 	}
 
-	pdata->phydev->irq = phy_irq;
 	pdata->phydev->is_internal = is_internal_phy;
 
 	/* detect device revision as different features may be available */
@@ -1235,15 +1191,6 @@ unregister_mdio:
 free_mdio:
 	mdiobus_free(pdata->mdiobus);
 
-dispose_irq:
-	irq_dispose_mapping(phy_irq);
-
-remove_irqdomain:
-	irq_domain_remove(pdata->irqdomain);
-
-free_irqfwnode:
-	irq_domain_free_fwnode(pdata->irqfwnode);
-
 free_pdata:
 	kfree(pdata);
 	return ret;
@@ -1256,9 +1203,6 @@ static void smsc95xx_unbind(struct usbne
 	phy_disconnect(dev->net->phydev);
 	mdiobus_unregister(pdata->mdiobus);
 	mdiobus_free(pdata->mdiobus);
-	irq_dispose_mapping(irq_find_mapping(pdata->irqdomain, PHY_HWIRQ));
-	irq_domain_remove(pdata->irqdomain);
-	irq_domain_free_fwnode(pdata->irqfwnode);
 	netif_dbg(dev, ifdown, dev->net, "free pdata\n");
 	kfree(pdata);
 }
@@ -1283,6 +1227,29 @@ static u32 smsc_crc(const u8 *buffer, si
 	return crc << ((filter % 2) * 16);
 }
 
+static int smsc95xx_enable_phy_wakeup_interrupts(struct usbnet *dev, u16 mask)
+{
+	int ret;
+
+	netdev_dbg(dev->net, "enabling PHY wakeup interrupts\n");
+
+	/* read to clear */
+	ret = smsc95xx_mdio_read_nopm(dev, PHY_INT_SRC);
+	if (ret < 0)
+		return ret;
+
+	/* enable interrupt source */
+	ret = smsc95xx_mdio_read_nopm(dev, PHY_INT_MASK);
+	if (ret < 0)
+		return ret;
+
+	ret |= mask;
+
+	smsc95xx_mdio_write_nopm(dev, PHY_INT_MASK, ret);
+
+	return 0;
+}
+
 static int smsc95xx_link_ok_nopm(struct usbnet *dev)
 {
 	int ret;
@@ -1449,6 +1416,7 @@ static int smsc95xx_enter_suspend3(struc
 static int smsc95xx_autosuspend(struct usbnet *dev, u32 link_up)
 {
 	struct smsc95xx_priv *pdata = dev->driver_priv;
+	int ret;
 
 	if (!netif_running(dev->net)) {
 		/* interface is ifconfig down so fully power down hw */
@@ -1467,10 +1435,27 @@ static int smsc95xx_autosuspend(struct u
 		}
 
 		netdev_dbg(dev->net, "autosuspend entering SUSPEND1\n");
+
+		/* enable PHY wakeup events for if cable is attached */
+		ret = smsc95xx_enable_phy_wakeup_interrupts(dev,
+			PHY_INT_MASK_ANEG_COMP_);
+		if (ret < 0) {
+			netdev_warn(dev->net, "error enabling PHY wakeup ints\n");
+			return ret;
+		}
+
 		netdev_info(dev->net, "entering SUSPEND1 mode\n");
 		return smsc95xx_enter_suspend1(dev);
 	}
 
+	/* enable PHY wakeup events so we remote wakeup if cable is pulled */
+	ret = smsc95xx_enable_phy_wakeup_interrupts(dev,
+		PHY_INT_MASK_LINK_DOWN_);
+	if (ret < 0) {
+		netdev_warn(dev->net, "error enabling PHY wakeup ints\n");
+		return ret;
+	}
+
 	netdev_dbg(dev->net, "autosuspend entering SUSPEND3\n");
 	return smsc95xx_enter_suspend3(dev);
 }
@@ -1536,6 +1521,13 @@ static int smsc95xx_suspend(struct usb_i
 	}
 
 	if (pdata->wolopts & WAKE_PHY) {
+		ret = smsc95xx_enable_phy_wakeup_interrupts(dev,
+			(PHY_INT_MASK_ANEG_COMP_ | PHY_INT_MASK_LINK_DOWN_));
+		if (ret < 0) {
+			netdev_warn(dev->net, "error enabling PHY wakeup ints\n");
+			goto done;
+		}
+
 		/* if link is down then configure EDPD and enter SUSPEND1,
 		 * otherwise enter SUSPEND0 below
 		 */
@@ -1769,12 +1761,11 @@ static int smsc95xx_resume(struct usb_in
 			return ret;
 	}
 
-	phy_init_hw(pdata->phydev);
-
 	ret = usbnet_resume(intf);
 	if (ret < 0)
 		netdev_warn(dev->net, "usbnet_resume error\n");
 
+	phy_init_hw(pdata->phydev);
 	return ret;
 }
 


