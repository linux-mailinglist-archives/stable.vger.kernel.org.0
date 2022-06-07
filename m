Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3E55408ED
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236628AbiFGSD5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351444AbiFGSCE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:02:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7A612DBEE;
        Tue,  7 Jun 2022 10:44:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 691AC615B8;
        Tue,  7 Jun 2022 17:44:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 778C6C341C0;
        Tue,  7 Jun 2022 17:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623873;
        bh=x4B8zV580+azv9vAE3GUqPaunN3G/DT9gCW5iU7BFrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I5eDg/SyaIEMOhge/8ac07vnpL4iKurnMhQgJfb0AvxLMEWUvVOfLpt8+41OW0a7X
         DcvT5MyMtAfTVfpAMk4FXCu3AMarfm0ZS5+gXBROUzVTzmwjFHTeEZD9VplhdBX4or
         GyBZfZ3FY72RH0iawSUCWFoMxt99zHxlPmkcXQ8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Oliver Neukum <oneukum@suse.com>,
        Martyn Welch <martyn.welch@collabora.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Ferry Toth <fntoth@gmail.com>
Subject: [PATCH 5.15 122/667] usbnet: Run unregister_netdev() before unbind() again
Date:   Tue,  7 Jun 2022 18:56:27 +0200
Message-Id: <20220607164938.482771057@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit d1408f6b4dd78fb1b9e26bcf64477984e5f85409 ]

Commit 2c9d6c2b871d ("usbnet: run unbind() before unregister_netdev()")
sought to fix a use-after-free on disconnect of USB Ethernet adapters.

It turns out that a different fix is necessary to address the issue:
https://lore.kernel.org/netdev/18b3541e5372bc9b9fc733d422f4e698c089077c.1650177997.git.lukas@wunner.de/

So the commit was not necessary.

The commit made binding and unbinding of USB Ethernet asymmetrical:
Before, usbnet_probe() first invoked the ->bind() callback and then
register_netdev().  usbnet_disconnect() mirrored that by first invoking
unregister_netdev() and then ->unbind().

Since the commit, the order in usbnet_disconnect() is reversed and no
longer mirrors usbnet_probe().

One consequence is that a PHY disconnected (and stopped) in ->unbind()
is afterwards stopped once more by unregister_netdev() as it closes the
netdev before unregistering.  That necessitates a contortion in ->stop()
because the PHY may only be stopped if it hasn't already been
disconnected.

Reverting the commit allows making the call to phy_stop() unconditional
in ->stop().

Tested-by: Oleksij Rempel <o.rempel@pengutronix.de> # LAN9514/9512/9500
Tested-by: Ferry Toth <fntoth@gmail.com> # LAN9514
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Acked-by: Oliver Neukum <oneukum@suse.com>
Cc: Martyn Welch <martyn.welch@collabora.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/asix_devices.c | 6 +-----
 drivers/net/usb/smsc95xx.c     | 3 +--
 drivers/net/usb/usbnet.c       | 6 +++---
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index bd8f8619ad6f..396505396a2e 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -799,11 +799,7 @@ static int ax88772_stop(struct usbnet *dev)
 {
 	struct asix_common_private *priv = dev->driver_priv;
 
-	/* On unplugged USB, we will get MDIO communication errors and the
-	 * PHY will be set in to PHY_HALTED state.
-	 */
-	if (priv->phydev->state != PHY_HALTED)
-		phy_stop(priv->phydev);
+	phy_stop(priv->phydev);
 
 	return 0;
 }
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index eb0d325e92b7..4e39e4345084 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1217,8 +1217,7 @@ static int smsc95xx_start_phy(struct usbnet *dev)
 
 static int smsc95xx_stop(struct usbnet *dev)
 {
-	if (dev->net->phydev)
-		phy_stop(dev->net->phydev);
+	phy_stop(dev->net->phydev);
 
 	return 0;
 }
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index a33d7fb82a00..af2bbaff2478 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1614,9 +1614,6 @@ void usbnet_disconnect (struct usb_interface *intf)
 		   xdev->bus->bus_name, xdev->devpath,
 		   dev->driver_info->description);
 
-	if (dev->driver_info->unbind)
-		dev->driver_info->unbind(dev, intf);
-
 	net = dev->net;
 	unregister_netdev (net);
 
@@ -1624,6 +1621,9 @@ void usbnet_disconnect (struct usb_interface *intf)
 
 	usb_scuttle_anchored_urbs(&dev->deferred);
 
+	if (dev->driver_info->unbind)
+		dev->driver_info->unbind(dev, intf);
+
 	usb_kill_urb(dev->interrupt);
 	usb_free_urb(dev->interrupt);
 	kfree(dev->padding_pkt);
-- 
2.35.1



