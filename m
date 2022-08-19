Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1F359A36D
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353661AbiHSQmo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354121AbiHSQlw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:41:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5ECA1296DD;
        Fri, 19 Aug 2022 09:10:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63A59B82819;
        Fri, 19 Aug 2022 16:09:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F0DC433C1;
        Fri, 19 Aug 2022 16:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925356;
        bh=vBcnp/8+3iltka4BgipB5G0+Hb2FRfuz7ajUL1671+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1d56JLka8DnbxaQzgfSX0RUvQIUCB6CdyIocJTM/ubhjlLUe7BJ8iCmYfxNfScU1X
         HJAMFrXgWz60Sh2tWWZg5HeLitvi10XqVXuPSZXDWmaJSuaphJP+3gP6cn99bs9qeu
         IWiICy4FeLyIGQSSXY97OWLpaubIPR6gfQCnFd8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Ferry Toth <fntoth@gmail.com>
Subject: [PATCH 5.10 465/545] usbnet: smsc95xx: Avoid link settings race on interrupt reception
Date:   Fri, 19 Aug 2022 17:43:55 +0200
Message-Id: <20220819153850.209594560@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

[ Upstream commit 8960f878e39fadc03d74292a6731f1e914cf2019 ]

When a PHY interrupt is signaled, the SMSC LAN95xx driver updates the
MAC full duplex mode and PHY flow control registers based on cached data
in struct phy_device:

  smsc95xx_status()                 # raises EVENT_LINK_RESET
    usbnet_deferred_kevent()
      smsc95xx_link_reset()         # uses cached data in phydev

Simultaneously, phylib polls link status once per second and updates
that cached data:

  phy_state_machine()
    phy_check_link_status()
      phy_read_status()
        lan87xx_read_status()
          genphy_read_status()      # updates cached data in phydev

If smsc95xx_link_reset() wins the race against genphy_read_status(),
the registers may be updated based on stale data.

E.g. if the link was previously down, phydev->duplex is set to
DUPLEX_UNKNOWN and that's what smsc95xx_link_reset() will use, even
though genphy_read_status() may update it to DUPLEX_FULL afterwards.

PHY interrupts are currently only enabled on suspend to trigger wakeup,
so the impact of the race is limited, but we're about to enable them
perpetually.

Avoid the race by delaying execution of smsc95xx_link_reset() until
phy_state_machine() has done its job and calls back via
smsc95xx_handle_link_change().

Signaling EVENT_LINK_RESET on wakeup is not necessary because phylib
picks up link status changes through polling.  So drop the declaration
of a ->link_reset() callback.

Note that the semicolon on a line by itself added in smsc95xx_status()
is a placeholder for a function call which will be added in a subsequent
commit.  That function call will actually handle the INT_ENP_PHY_INT_
interrupt.

Tested-by: Oleksij Rempel <o.rempel@pengutronix.de> # LAN9514/9512/9500
Tested-by: Ferry Toth <fntoth@gmail.com> # LAN9514
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/smsc95xx.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index b1d7331c3c5c..65d42f5d42a3 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -564,7 +564,7 @@ static int smsc95xx_phy_update_flowcontrol(struct usbnet *dev)
 	return smsc95xx_write_reg(dev, AFC_CFG, afc_cfg);
 }
 
-static int smsc95xx_link_reset(struct usbnet *dev)
+static void smsc95xx_mac_update_fullduplex(struct usbnet *dev)
 {
 	struct smsc95xx_priv *pdata = dev->driver_priv;
 	unsigned long flags;
@@ -581,14 +581,16 @@ static int smsc95xx_link_reset(struct usbnet *dev)
 	spin_unlock_irqrestore(&pdata->mac_cr_lock, flags);
 
 	ret = smsc95xx_write_reg(dev, MAC_CR, pdata->mac_cr);
-	if (ret < 0)
-		return ret;
+	if (ret < 0) {
+		if (ret != -ENODEV)
+			netdev_warn(dev->net,
+				    "Error updating MAC full duplex mode\n");
+		return;
+	}
 
 	ret = smsc95xx_phy_update_flowcontrol(dev);
 	if (ret < 0)
 		netdev_warn(dev->net, "Error updating PHY flow control\n");
-
-	return ret;
 }
 
 static void smsc95xx_status(struct usbnet *dev, struct urb *urb)
@@ -605,7 +607,7 @@ static void smsc95xx_status(struct usbnet *dev, struct urb *urb)
 	netif_dbg(dev, link, dev->net, "intdata: 0x%08X\n", intdata);
 
 	if (intdata & INT_ENP_PHY_INT_)
-		usbnet_defer_kevent(dev, EVENT_LINK_RESET);
+		;
 	else
 		netdev_warn(dev->net, "unexpected interrupt, intdata=0x%08X\n",
 			    intdata);
@@ -1062,6 +1064,7 @@ static void smsc95xx_handle_link_change(struct net_device *net)
 	struct usbnet *dev = netdev_priv(net);
 
 	phy_print_status(net->phydev);
+	smsc95xx_mac_update_fullduplex(dev);
 	usbnet_defer_kevent(dev, EVENT_LINK_CHANGE);
 }
 
@@ -1968,7 +1971,6 @@ static const struct driver_info smsc95xx_info = {
 	.description	= "smsc95xx USB 2.0 Ethernet",
 	.bind		= smsc95xx_bind,
 	.unbind		= smsc95xx_unbind,
-	.link_reset	= smsc95xx_link_reset,
 	.reset		= smsc95xx_reset,
 	.check_connect	= smsc95xx_start_phy,
 	.stop		= smsc95xx_stop,
-- 
2.35.1



