Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2D5B6CC2E1
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbjC1Ot2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233380AbjC1OtF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:49:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFCC8E049
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:48:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2917F61827
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:48:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A880C433D2;
        Tue, 28 Mar 2023 14:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014908;
        bh=q/1pTXt3XY+LQ5ad5ifmbQw7VSy38wY2z0ZSQZ7MTMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tbshDomk+1pU3zsFoJpkGcMmw7h40Y5/MeJzwbxMkCEhagqSu6pbavZ38vHCUTUqd
         TAUArAls9Kk6NIsowxDY7DJ8xjWBAtpWtZ9Z7TTIRnO0f098pHBRkK8NvOwOnOfbwu
         7tOT+zzw5IxrrTx0vJmvGVPzt8Je+h7vaCv65Co0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Anton Lundin <glance@acc.umu.se>,
        Eizan Miyamoto <eizan@chromium.org>,
        Grant Grundler <grundler@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 095/240] net: asix: fix modprobe "sysfs: cannot create duplicate filename"
Date:   Tue, 28 Mar 2023 16:40:58 +0200
Message-Id: <20230328142623.721880933@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
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

From: Grant Grundler <grundler@chromium.org>

[ Upstream commit 8eac0095de355ee31e1b014f79f83d2cd62a2d04 ]

"modprobe asix ; rmmod asix ; modprobe asix" fails with:
   sysfs: cannot create duplicate filename \
   	'/devices/virtual/mdio_bus/usb-003:004'

Issue was originally reported by Anton Lundin on 2022-06-22 (link below).

Chrome OS team hit the same issue in Feb, 2023 when trying to find
work arounds for other issues with AX88172 devices.

The use of devm_mdiobus_register() with usbnet devices results in the
MDIO data being associated with the USB device. When the asix driver
is unloaded, the USB device continues to exist and the corresponding
"mdiobus_unregister()" is NOT called until the USB device is unplugged
or unauthorized. So the next "modprobe asix" will fail because the MDIO
phy sysfs attributes still exist.

The 'easy' (from a design PoV) fix is to use the non-devm variants of
mdiobus_* functions and explicitly manage this use in the asix_bind
and asix_unbind function calls. I've not explored trying to fix usbnet
initialization so devm_* stuff will work.

Fixes: e532a096be0e5 ("net: usb: asix: ax88772: add phylib support")
Reported-by: Anton Lundin <glance@acc.umu.se>
Link: https://lore.kernel.org/netdev/20220623063649.GD23685@pengutronix.de/T/
Tested-by: Eizan Miyamoto <eizan@chromium.org>
Signed-off-by: Grant Grundler <grundler@chromium.org>
Link: https://lore.kernel.org/r/20230321170539.732147-1-grundler@chromium.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/asix_devices.c | 32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 743cbf5d662c9..f7cff58fe0449 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -666,8 +666,9 @@ static int asix_resume(struct usb_interface *intf)
 static int ax88772_init_mdio(struct usbnet *dev)
 {
 	struct asix_common_private *priv = dev->driver_priv;
+	int ret;
 
-	priv->mdio = devm_mdiobus_alloc(&dev->udev->dev);
+	priv->mdio = mdiobus_alloc();
 	if (!priv->mdio)
 		return -ENOMEM;
 
@@ -679,7 +680,20 @@ static int ax88772_init_mdio(struct usbnet *dev)
 	snprintf(priv->mdio->id, MII_BUS_ID_SIZE, "usb-%03d:%03d",
 		 dev->udev->bus->busnum, dev->udev->devnum);
 
-	return devm_mdiobus_register(&dev->udev->dev, priv->mdio);
+	ret = mdiobus_register(priv->mdio);
+	if (ret) {
+		netdev_err(dev->net, "Could not register MDIO bus (err %d)\n", ret);
+		mdiobus_free(priv->mdio);
+		priv->mdio = NULL;
+	}
+
+	return ret;
+}
+
+static void ax88772_mdio_unregister(struct asix_common_private *priv)
+{
+	mdiobus_unregister(priv->mdio);
+	mdiobus_free(priv->mdio);
 }
 
 static int ax88772_init_phy(struct usbnet *dev)
@@ -896,16 +910,23 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
 
 	ret = ax88772_init_mdio(dev);
 	if (ret)
-		return ret;
+		goto mdio_err;
 
 	ret = ax88772_phylink_setup(dev);
 	if (ret)
-		return ret;
+		goto phylink_err;
 
 	ret = ax88772_init_phy(dev);
 	if (ret)
-		phylink_destroy(priv->phylink);
+		goto initphy_err;
 
+	return 0;
+
+initphy_err:
+	phylink_destroy(priv->phylink);
+phylink_err:
+	ax88772_mdio_unregister(priv);
+mdio_err:
 	return ret;
 }
 
@@ -926,6 +947,7 @@ static void ax88772_unbind(struct usbnet *dev, struct usb_interface *intf)
 	phylink_disconnect_phy(priv->phylink);
 	rtnl_unlock();
 	phylink_destroy(priv->phylink);
+	ax88772_mdio_unregister(priv);
 	asix_rx_fixup_common_free(dev->driver_priv);
 }
 
-- 
2.39.2



