Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED5BF1EF8A
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732586AbfEOLcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:32:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732968AbfEOLcE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:32:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1723720881;
        Wed, 15 May 2019 11:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919923;
        bh=Pbj+UVCC4TYDkmXlwC5abIs+I5M6h3icEkPBubW8FrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mc5KKry8vKnxwi6mmyHR4fgpA0dOhwS+bEv8RUmiPvgpRlMNNyziccKUnfaDI3tZg
         gmeZ5B9i8OUbwZjuzdAiiTe9eNxP9LCftknnNg9y2p7Qf3gobLjZXbuVBNHp9FUS66
         7nQh0/tFs1z2VYBbtnYDBzeF7VdiuVxRxn+XpNhc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.0 121/137] aqc111: fix writing to the phy on BE
Date:   Wed, 15 May 2019 12:56:42 +0200
Message-Id: <20190515090702.485563524@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit 369b46e9fbcfa5136f2cb5f486c90e5f7fa92630 ]

When writing to the phy on BE architectures an internal data structure
was directly given, leading to it being byte swapped in the wrong
way for the CPU in 50% of all cases. A temporary buffer must be used.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/aqc111.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/drivers/net/usb/aqc111.c
+++ b/drivers/net/usb/aqc111.c
@@ -320,6 +320,7 @@ static int aqc111_get_link_ksettings(str
 static void aqc111_set_phy_speed(struct usbnet *dev, u8 autoneg, u16 speed)
 {
 	struct aqc111_data *aqc111_data = dev->driver_priv;
+	u32 phy_on_the_wire;
 
 	aqc111_data->phy_cfg &= ~AQ_ADV_MASK;
 	aqc111_data->phy_cfg |= AQ_PAUSE;
@@ -361,7 +362,8 @@ static void aqc111_set_phy_speed(struct
 		}
 	}
 
-	aqc111_write32_cmd(dev, AQ_PHY_OPS, 0, 0, &aqc111_data->phy_cfg);
+	phy_on_the_wire = aqc111_data->phy_cfg;
+	aqc111_write32_cmd(dev, AQ_PHY_OPS, 0, 0, &phy_on_the_wire);
 }
 
 static int aqc111_set_link_ksettings(struct net_device *net,
@@ -755,6 +757,7 @@ static void aqc111_unbind(struct usbnet
 {
 	struct aqc111_data *aqc111_data = dev->driver_priv;
 	u16 reg16;
+	u32 phy_on_the_wire;
 
 	/* Force bz */
 	reg16 = SFR_PHYPWR_RSTCTL_BZ;
@@ -768,8 +771,9 @@ static void aqc111_unbind(struct usbnet
 	aqc111_data->phy_cfg &= ~AQ_ADV_MASK;
 	aqc111_data->phy_cfg |= AQ_LOW_POWER;
 	aqc111_data->phy_cfg &= ~AQ_PHY_POWER_EN;
+	phy_on_the_wire = aqc111_data->phy_cfg;
 	aqc111_write32_cmd_nopm(dev, AQ_PHY_OPS, 0, 0,
-				&aqc111_data->phy_cfg);
+				&phy_on_the_wire);
 
 	kfree(aqc111_data);
 }
@@ -992,6 +996,7 @@ static int aqc111_reset(struct usbnet *d
 {
 	struct aqc111_data *aqc111_data = dev->driver_priv;
 	u8 reg8 = 0;
+	u32 phy_on_the_wire;
 
 	dev->rx_urb_size = URB_SIZE;
 
@@ -1004,8 +1009,9 @@ static int aqc111_reset(struct usbnet *d
 
 	/* Power up ethernet PHY */
 	aqc111_data->phy_cfg = AQ_PHY_POWER_EN;
+	phy_on_the_wire = aqc111_data->phy_cfg;
 	aqc111_write32_cmd(dev, AQ_PHY_OPS, 0, 0,
-			   &aqc111_data->phy_cfg);
+			   &phy_on_the_wire);
 
 	/* Set the MAC address */
 	aqc111_write_cmd(dev, AQ_ACCESS_MAC, SFR_NODE_ID, ETH_ALEN,
@@ -1036,6 +1042,7 @@ static int aqc111_stop(struct usbnet *de
 {
 	struct aqc111_data *aqc111_data = dev->driver_priv;
 	u16 reg16 = 0;
+	u32 phy_on_the_wire;
 
 	aqc111_read16_cmd(dev, AQ_ACCESS_MAC, SFR_MEDIUM_STATUS_MODE,
 			  2, &reg16);
@@ -1047,8 +1054,9 @@ static int aqc111_stop(struct usbnet *de
 
 	/* Put PHY to low power*/
 	aqc111_data->phy_cfg |= AQ_LOW_POWER;
+	phy_on_the_wire = aqc111_data->phy_cfg;
 	aqc111_write32_cmd(dev, AQ_PHY_OPS, 0, 0,
-			   &aqc111_data->phy_cfg);
+			   &phy_on_the_wire);
 
 	netif_carrier_off(dev->net);
 
@@ -1324,6 +1332,7 @@ static int aqc111_suspend(struct usb_int
 	u16 temp_rx_ctrl = 0x00;
 	u16 reg16;
 	u8 reg8;
+	u32 phy_on_the_wire;
 
 	usbnet_suspend(intf, message);
 
@@ -1395,12 +1404,14 @@ static int aqc111_suspend(struct usb_int
 
 		aqc111_write_cmd(dev, AQ_WOL_CFG, 0, 0,
 				 WOL_CFG_SIZE, &wol_cfg);
+		phy_on_the_wire = aqc111_data->phy_cfg;
 		aqc111_write32_cmd(dev, AQ_PHY_OPS, 0, 0,
-				   &aqc111_data->phy_cfg);
+				   &phy_on_the_wire);
 	} else {
 		aqc111_data->phy_cfg |= AQ_LOW_POWER;
+		phy_on_the_wire = aqc111_data->phy_cfg;
 		aqc111_write32_cmd(dev, AQ_PHY_OPS, 0, 0,
-				   &aqc111_data->phy_cfg);
+				   &phy_on_the_wire);
 
 		/* Disable RX path */
 		aqc111_read16_cmd_nopm(dev, AQ_ACCESS_MAC,


