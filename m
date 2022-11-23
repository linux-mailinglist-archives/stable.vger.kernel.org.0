Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45064635928
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235763AbiKWKHY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:07:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235939AbiKWKGj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:06:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85339EE3B
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:57:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44F74B81E60
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:57:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27039C433D6;
        Wed, 23 Nov 2022 09:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197426;
        bh=EJKVBmmxT9ZawJPNZh+81LieRoViEH8O+fJpZ3CifxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OgfC0pATGzFAetArjjtWgS6GfVIepKFHG1xGjfZ68sF+IKX6l7EKeJFbBbES4eLNP
         lwEqsyC+0+HUmR82Li80uFdD+X9B45YXIGqQv+B8hHJyqhq9rdKIzuLjdhPYrQw+OA
         9AtnNzQy407n1SnztA4aIG1tzCWZBs2iSc2qlovc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 290/314] net: usb: smsc95xx: fix external PHY reset
Date:   Wed, 23 Nov 2022 09:52:15 +0100
Message-Id: <20221123084638.670300551@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

From: Alexandru Tachici <alexandru.tachici@analog.com>

[ Upstream commit 809ff97a677ff85dfb7ce2b63be261d1633dcf29 ]

An external PHY needs settling time after power up or reset.
In the bind() function an mdio bus is registered. If at this point
the external PHY is still initialising, no valid PHY ID will be
read and on phy_find_first() the bind() function will fail.

If an external PHY is present, wait the maximum time specified
in 802.3 45.2.7.1.1.

Fixes: 05b35e7eb9a1 ("smsc95xx: add phylib support")
Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20221115114434.9991-2-alexandru.tachici@analog.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/smsc95xx.c | 46 ++++++++++++++++++++++++++++++++++----
 1 file changed, 42 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index bfb58c91db04..32d2c60d334d 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -66,6 +66,7 @@ struct smsc95xx_priv {
 	spinlock_t mac_cr_lock;
 	u8 features;
 	u8 suspend_flags;
+	bool is_internal_phy;
 	struct irq_chip irqchip;
 	struct irq_domain *irqdomain;
 	struct fwnode_handle *irqfwnode;
@@ -252,6 +253,43 @@ static void smsc95xx_mdio_write(struct usbnet *dev, int phy_id, int idx,
 	mutex_unlock(&dev->phy_mutex);
 }
 
+static int smsc95xx_mdiobus_reset(struct mii_bus *bus)
+{
+	struct smsc95xx_priv *pdata;
+	struct usbnet *dev;
+	u32 val;
+	int ret;
+
+	dev = bus->priv;
+	pdata = dev->driver_priv;
+
+	if (pdata->is_internal_phy)
+		return 0;
+
+	mutex_lock(&dev->phy_mutex);
+
+	ret = smsc95xx_read_reg(dev, PM_CTRL, &val);
+	if (ret < 0)
+		goto reset_out;
+
+	val |= PM_CTL_PHY_RST_;
+
+	ret = smsc95xx_write_reg(dev, PM_CTRL, val);
+	if (ret < 0)
+		goto reset_out;
+
+	/* Driver has no knowledge at this point about the external PHY.
+	 * The 802.3 specifies that the reset process shall
+	 * be completed within 0.5 s.
+	 */
+	fsleep(500000);
+
+reset_out:
+	mutex_unlock(&dev->phy_mutex);
+
+	return 0;
+}
+
 static int smsc95xx_mdiobus_read(struct mii_bus *bus, int phy_id, int idx)
 {
 	struct usbnet *dev = bus->priv;
@@ -1052,7 +1090,6 @@ static void smsc95xx_handle_link_change(struct net_device *net)
 static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 {
 	struct smsc95xx_priv *pdata;
-	bool is_internal_phy;
 	char usb_path[64];
 	int ret, phy_irq;
 	u32 val;
@@ -1133,13 +1170,14 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	if (ret < 0)
 		goto free_mdio;
 
-	is_internal_phy = !(val & HW_CFG_PSEL_);
-	if (is_internal_phy)
+	pdata->is_internal_phy = !(val & HW_CFG_PSEL_);
+	if (pdata->is_internal_phy)
 		pdata->mdiobus->phy_mask = ~(1u << SMSC95XX_INTERNAL_PHY_ID);
 
 	pdata->mdiobus->priv = dev;
 	pdata->mdiobus->read = smsc95xx_mdiobus_read;
 	pdata->mdiobus->write = smsc95xx_mdiobus_write;
+	pdata->mdiobus->reset = smsc95xx_mdiobus_reset;
 	pdata->mdiobus->name = "smsc95xx-mdiobus";
 	pdata->mdiobus->parent = &dev->udev->dev;
 
@@ -1160,7 +1198,7 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	}
 
 	pdata->phydev->irq = phy_irq;
-	pdata->phydev->is_internal = is_internal_phy;
+	pdata->phydev->is_internal = pdata->is_internal_phy;
 
 	/* detect device revision as different features may be available */
 	ret = smsc95xx_read_reg(dev, ID_REV, &val);
-- 
2.35.1



