Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA8885949CD
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241798AbiHOXWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347438AbiHOXVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:21:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C2B14AEE9;
        Mon, 15 Aug 2022 13:04:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D007660690;
        Mon, 15 Aug 2022 20:04:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB06CC433D6;
        Mon, 15 Aug 2022 20:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593883;
        bh=ehe8B8zILd0oalAHC8ZfINlVH6xP1qPeuChFmGf3QbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f2C5kL1fKKE2BETF2WMgGnmA1ql1mZD8EMBADFZ/nOZh2AKwJM0T4EmYUbdXpSxij
         Hg4nTt8phtFuC/tn1XW8XysG8zscPNhIW7AMRnEKLh7ExGgWLJskL8tEMf9hNRogf+
         HI6chdJxZvVczo2dNMcDHi76fPhf0PQzqxqAetIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Andre Edich <andre.edich@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Ferry Toth <fntoth@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH 5.18 0987/1095] usbnet: smsc95xx: Forward PHY interrupts to PHY driver to avoid polling
Date:   Mon, 15 Aug 2022 20:06:26 +0200
Message-Id: <20220815180509.951877772@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit 1ce8b37241ed291af56f7a49bbdbf20c08728e88 ]

Link status of SMSC LAN95xx chips is polled once per second, even though
they're capable of signaling PHY interrupts through the MAC layer.

Forward those interrupts to the PHY driver to avoid polling.  Benefits
are reduced bus traffic, reduced CPU overhead and quicker interface
bringup.

Polling was introduced in 2016 by commit d69d16949346 ("usbnet:
smsc95xx: fix link detection for disabled autonegotiation").
Back then, the LAN95xx driver neglected to enable the ENERGYON interrupt,
hence couldn't detect link-up events when auto-negotiation was disabled.
The proper solution would have been to enable the ENERGYON interrupt
instead of polling.

Since then, PHY handling was moved from the LAN95xx driver to the SMSC
PHY driver with commit 05b35e7eb9a1 ("smsc95xx: add phylib support").
That PHY driver is capable of link detection with auto-negotiation
disabled because it enables the ENERGYON interrupt.

Note that signaling interrupts through the MAC layer not only works with
the integrated PHY, but also with an external PHY, provided its
interrupt pin is attached to LAN95xx's nPHY_INT pin.

In the unlikely event that the interrupt pin of an external PHY is
attached to a GPIO of the SoC (or not connected at all), the driver can
be amended to retrieve the irq from the PHY's of_node.

To forward PHY interrupts to phylib, it is not sufficient to call
phy_mac_interrupt().  Instead, the PHY's interrupt handler needs to run
so that PHY interrupts are cleared.  That's because according to page
119 of the LAN950x datasheet, "The source of this interrupt is a level.
The interrupt persists until it is cleared in the PHY."

https://www.microchip.com/content/dam/mchp/documents/UNG/ProductDocuments/DataSheets/LAN950x-Data-Sheet-DS00001875D.pdf

Therefore, create an IRQ domain with a single IRQ for the PHY.  In the
future, the IRQ domain may be extended to support the 11 GPIOs on the
LAN95xx.

Normally the PHY interrupt should be masked until the PHY driver has
cleared it.  However masking requires a (sleeping) USB transaction and
interrupts are received in (non-sleepable) softirq context.  I decided
not to mask the interrupt at all (by using the dummy_irq_chip's noop
->irq_mask() callback):  The USB interrupt endpoint is polled in 1 msec
intervals and normally that's sufficient to wake the PHY driver's IRQ
thread and have it clear the interrupt.  If it does take longer, worst
thing that can happen is the IRQ thread is woken again.  No big deal.

Because PHY interrupts are now perpetually enabled, there's no need to
selectively enable them on suspend.  So remove all invocations of
smsc95xx_enable_phy_wakeup_interrupts().

In smsc95xx_resume(), move the call of phy_init_hw() before
usbnet_resume() (which restarts the status URB) to ensure that the PHY
is fully initialized when an interrupt is handled.

Tested-by: Oleksij Rempel <o.rempel@pengutronix.de> # LAN9514/9512/9500
Tested-by: Ferry Toth <fntoth@gmail.com> # LAN9514
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch> # from a PHY perspective
Cc: Andre Edich <andre.edich@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/smsc95xx.c | 113 ++++++++++++++++++++-----------------
 1 file changed, 61 insertions(+), 52 deletions(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index f5a208948d22..358b170cc8fb 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -18,6 +18,8 @@
 #include <linux/usb/usbnet.h>
 #include <linux/slab.h>
 #include <linux/of_net.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
 #include <linux/mdio.h>
 #include <linux/phy.h>
 #include <net/selftests.h>
@@ -53,6 +55,9 @@
 #define SUSPEND_ALLMODES		(SUSPEND_SUSPEND0 | SUSPEND_SUSPEND1 | \
 					 SUSPEND_SUSPEND2 | SUSPEND_SUSPEND3)
 
+#define SMSC95XX_NR_IRQS		(1) /* raise to 12 for GPIOs */
+#define PHY_HWIRQ			(SMSC95XX_NR_IRQS - 1)
+
 struct smsc95xx_priv {
 	u32 mac_cr;
 	u32 hash_hi;
@@ -61,6 +66,9 @@ struct smsc95xx_priv {
 	spinlock_t mac_cr_lock;
 	u8 features;
 	u8 suspend_flags;
+	struct irq_chip irqchip;
+	struct irq_domain *irqdomain;
+	struct fwnode_handle *irqfwnode;
 	struct mii_bus *mdiobus;
 	struct phy_device *phydev;
 };
@@ -597,6 +605,8 @@ static void smsc95xx_mac_update_fullduplex(struct usbnet *dev)
 
 static void smsc95xx_status(struct usbnet *dev, struct urb *urb)
 {
+	struct smsc95xx_priv *pdata = dev->driver_priv;
+	unsigned long flags;
 	u32 intdata;
 
 	if (urb->actual_length != 4) {
@@ -608,11 +618,15 @@ static void smsc95xx_status(struct usbnet *dev, struct urb *urb)
 	intdata = get_unaligned_le32(urb->transfer_buffer);
 	netif_dbg(dev, link, dev->net, "intdata: 0x%08X\n", intdata);
 
+	local_irq_save(flags);
+
 	if (intdata & INT_ENP_PHY_INT_)
-		;
+		generic_handle_domain_irq(pdata->irqdomain, PHY_HWIRQ);
 	else
 		netdev_warn(dev->net, "unexpected interrupt, intdata=0x%08X\n",
 			    intdata);
+
+	local_irq_restore(flags);
 }
 
 /* Enable or disable Tx & Rx checksum offload engines */
@@ -1098,8 +1112,9 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 {
 	struct smsc95xx_priv *pdata;
 	bool is_internal_phy;
+	char usb_path[64];
+	int ret, phy_irq;
 	u32 val;
-	int ret;
 
 	printk(KERN_INFO SMSC_CHIPNAME " v" SMSC_DRIVER_VERSION "\n");
 
@@ -1139,10 +1154,38 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	if (ret)
 		goto free_pdata;
 
+	/* create irq domain for use by PHY driver and GPIO consumers */
+	usb_make_path(dev->udev, usb_path, sizeof(usb_path));
+	pdata->irqfwnode = irq_domain_alloc_named_fwnode(usb_path);
+	if (!pdata->irqfwnode) {
+		ret = -ENOMEM;
+		goto free_pdata;
+	}
+
+	pdata->irqdomain = irq_domain_create_linear(pdata->irqfwnode,
+						    SMSC95XX_NR_IRQS,
+						    &irq_domain_simple_ops,
+						    pdata);
+	if (!pdata->irqdomain) {
+		ret = -ENOMEM;
+		goto free_irqfwnode;
+	}
+
+	phy_irq = irq_create_mapping(pdata->irqdomain, PHY_HWIRQ);
+	if (!phy_irq) {
+		ret = -ENOENT;
+		goto remove_irqdomain;
+	}
+
+	pdata->irqchip = dummy_irq_chip;
+	pdata->irqchip.name = SMSC_CHIPNAME;
+	irq_set_chip_and_handler_name(phy_irq, &pdata->irqchip,
+				      handle_simple_irq, "phy");
+
 	pdata->mdiobus = mdiobus_alloc();
 	if (!pdata->mdiobus) {
 		ret = -ENOMEM;
-		goto free_pdata;
+		goto dispose_irq;
 	}
 
 	ret = smsc95xx_read_reg(dev, HW_CFG, &val);
@@ -1175,6 +1218,7 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 		goto unregister_mdio;
 	}
 
+	pdata->phydev->irq = phy_irq;
 	pdata->phydev->is_internal = is_internal_phy;
 
 	/* detect device revision as different features may be available */
@@ -1217,6 +1261,15 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 free_mdio:
 	mdiobus_free(pdata->mdiobus);
 
+dispose_irq:
+	irq_dispose_mapping(phy_irq);
+
+remove_irqdomain:
+	irq_domain_remove(pdata->irqdomain);
+
+free_irqfwnode:
+	irq_domain_free_fwnode(pdata->irqfwnode);
+
 free_pdata:
 	kfree(pdata);
 	return ret;
@@ -1229,6 +1282,9 @@ static void smsc95xx_unbind(struct usbnet *dev, struct usb_interface *intf)
 	phy_disconnect(dev->net->phydev);
 	mdiobus_unregister(pdata->mdiobus);
 	mdiobus_free(pdata->mdiobus);
+	irq_dispose_mapping(irq_find_mapping(pdata->irqdomain, PHY_HWIRQ));
+	irq_domain_remove(pdata->irqdomain);
+	irq_domain_free_fwnode(pdata->irqfwnode);
 	netif_dbg(dev, ifdown, dev->net, "free pdata\n");
 	kfree(pdata);
 }
@@ -1253,29 +1309,6 @@ static u32 smsc_crc(const u8 *buffer, size_t len, int filter)
 	return crc << ((filter % 2) * 16);
 }
 
-static int smsc95xx_enable_phy_wakeup_interrupts(struct usbnet *dev, u16 mask)
-{
-	int ret;
-
-	netdev_dbg(dev->net, "enabling PHY wakeup interrupts\n");
-
-	/* read to clear */
-	ret = smsc95xx_mdio_read_nopm(dev, PHY_INT_SRC);
-	if (ret < 0)
-		return ret;
-
-	/* enable interrupt source */
-	ret = smsc95xx_mdio_read_nopm(dev, PHY_INT_MASK);
-	if (ret < 0)
-		return ret;
-
-	ret |= mask;
-
-	smsc95xx_mdio_write_nopm(dev, PHY_INT_MASK, ret);
-
-	return 0;
-}
-
 static int smsc95xx_link_ok_nopm(struct usbnet *dev)
 {
 	int ret;
@@ -1442,7 +1475,6 @@ static int smsc95xx_enter_suspend3(struct usbnet *dev)
 static int smsc95xx_autosuspend(struct usbnet *dev, u32 link_up)
 {
 	struct smsc95xx_priv *pdata = dev->driver_priv;
-	int ret;
 
 	if (!netif_running(dev->net)) {
 		/* interface is ifconfig down so fully power down hw */
@@ -1461,27 +1493,10 @@ static int smsc95xx_autosuspend(struct usbnet *dev, u32 link_up)
 		}
 
 		netdev_dbg(dev->net, "autosuspend entering SUSPEND1\n");
-
-		/* enable PHY wakeup events for if cable is attached */
-		ret = smsc95xx_enable_phy_wakeup_interrupts(dev,
-			PHY_INT_MASK_ANEG_COMP_);
-		if (ret < 0) {
-			netdev_warn(dev->net, "error enabling PHY wakeup ints\n");
-			return ret;
-		}
-
 		netdev_info(dev->net, "entering SUSPEND1 mode\n");
 		return smsc95xx_enter_suspend1(dev);
 	}
 
-	/* enable PHY wakeup events so we remote wakeup if cable is pulled */
-	ret = smsc95xx_enable_phy_wakeup_interrupts(dev,
-		PHY_INT_MASK_LINK_DOWN_);
-	if (ret < 0) {
-		netdev_warn(dev->net, "error enabling PHY wakeup ints\n");
-		return ret;
-	}
-
 	netdev_dbg(dev->net, "autosuspend entering SUSPEND3\n");
 	return smsc95xx_enter_suspend3(dev);
 }
@@ -1547,13 +1562,6 @@ static int smsc95xx_suspend(struct usb_interface *intf, pm_message_t message)
 	}
 
 	if (pdata->wolopts & WAKE_PHY) {
-		ret = smsc95xx_enable_phy_wakeup_interrupts(dev,
-			(PHY_INT_MASK_ANEG_COMP_ | PHY_INT_MASK_LINK_DOWN_));
-		if (ret < 0) {
-			netdev_warn(dev->net, "error enabling PHY wakeup ints\n");
-			goto done;
-		}
-
 		/* if link is down then configure EDPD and enter SUSPEND1,
 		 * otherwise enter SUSPEND0 below
 		 */
@@ -1787,11 +1795,12 @@ static int smsc95xx_resume(struct usb_interface *intf)
 			return ret;
 	}
 
+	phy_init_hw(pdata->phydev);
+
 	ret = usbnet_resume(intf);
 	if (ret < 0)
 		netdev_warn(dev->net, "usbnet_resume error\n");
 
-	phy_init_hw(pdata->phydev);
 	return ret;
 }
 
-- 
2.35.1



