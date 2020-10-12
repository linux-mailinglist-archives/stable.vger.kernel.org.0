Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDB5528B892
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390289AbgJLNxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:53:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:53874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731429AbgJLNq5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:46:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AD52208B8;
        Mon, 12 Oct 2020 13:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510389;
        bh=YQmTHEgQK45UWR8Zv7twbvN/rtpSMcm8CB9CAec1tiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QHuucRSA/J+xLpqi+s7Jfg2PaGJfVYeF1YWT71UHwi420c5ZLQ5PH2RaoDiGPZLKa
         eRZvSi8tRi2qyGSJp9dRGb+mBPbZ8SQIae9UOnIemO/Y8QysAT6cJpw335qSefVR30
         8QSi0B/rcQNqSrTN3pEHBg9vokcVVXp6ZG4m21S0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willy Liu <willy.liu@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 078/124] net: phy: realtek: fix rtl8211e rx/tx delay config
Date:   Mon, 12 Oct 2020 15:31:22 +0200
Message-Id: <20201012133150.635550581@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willy Liu <willy.liu@realtek.com>

[ Upstream commit bbc4d71d63549bcd003a430de18a72a742d8c91e ]

There are two chip pins named TXDLY and RXDLY which actually adds the 2ns
delays to TXC and RXC for TXD/RXD latching. These two pins can config via
4.7k-ohm resistor to 3.3V hw setting, but also config via software setting
(extension page 0xa4 register 0x1c bit13 12 and 11).

The configuration register definitions from table 13 official PHY datasheet:
PHYAD[2:0] = PHY Address
AN[1:0] = Auto-Negotiation
Mode = Interface Mode Select
RX Delay = RX Delay
TX Delay = TX Delay
SELRGV = RGMII/GMII Selection

This table describes how to config these hw pins via external pull-high or pull-
low resistor.

It is a misunderstanding that mapping it as register bits below:
8:6 = PHY Address
5:4 = Auto-Negotiation
3 = Interface Mode Select
2 = RX Delay
1 = TX Delay
0 = SELRGV
So I removed these descriptions above and add related settings as below:
14 = reserved
13 = force Tx RX Delay controlled by bit12 bit11
12 = Tx Delay
11 = Rx Delay
10:0 = Test && debug settings reserved by realtek

Test && debug settings are not recommend to modify by default.

Fixes: f81dadbcf7fd ("net: phy: realtek: Add rtl8211e rx/tx delays config")
Signed-off-by: Willy Liu <willy.liu@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/realtek.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index c7229d022a27b..48ba757046cea 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0+
-/*
- * drivers/net/phy/realtek.c
+/* drivers/net/phy/realtek.c
  *
  * Driver for Realtek PHYs
  *
@@ -32,9 +31,9 @@
 #define RTL8211F_TX_DELAY			BIT(8)
 #define RTL8211F_RX_DELAY			BIT(3)
 
-#define RTL8211E_TX_DELAY			BIT(1)
-#define RTL8211E_RX_DELAY			BIT(2)
-#define RTL8211E_MODE_MII_GMII			BIT(3)
+#define RTL8211E_CTRL_DELAY			BIT(13)
+#define RTL8211E_TX_DELAY			BIT(12)
+#define RTL8211E_RX_DELAY			BIT(11)
 
 #define RTL8201F_ISR				0x1e
 #define RTL8201F_IER				0x13
@@ -246,16 +245,16 @@ static int rtl8211e_config_init(struct phy_device *phydev)
 	/* enable TX/RX delay for rgmii-* modes, and disable them for rgmii. */
 	switch (phydev->interface) {
 	case PHY_INTERFACE_MODE_RGMII:
-		val = 0;
+		val = RTL8211E_CTRL_DELAY | 0;
 		break;
 	case PHY_INTERFACE_MODE_RGMII_ID:
-		val = RTL8211E_TX_DELAY | RTL8211E_RX_DELAY;
+		val = RTL8211E_CTRL_DELAY | RTL8211E_TX_DELAY | RTL8211E_RX_DELAY;
 		break;
 	case PHY_INTERFACE_MODE_RGMII_RXID:
-		val = RTL8211E_RX_DELAY;
+		val = RTL8211E_CTRL_DELAY | RTL8211E_RX_DELAY;
 		break;
 	case PHY_INTERFACE_MODE_RGMII_TXID:
-		val = RTL8211E_TX_DELAY;
+		val = RTL8211E_CTRL_DELAY | RTL8211E_TX_DELAY;
 		break;
 	default: /* the rest of the modes imply leaving delays as is. */
 		return 0;
@@ -263,11 +262,12 @@ static int rtl8211e_config_init(struct phy_device *phydev)
 
 	/* According to a sample driver there is a 0x1c config register on the
 	 * 0xa4 extension page (0x7) layout. It can be used to disable/enable
-	 * the RX/TX delays otherwise controlled by RXDLY/TXDLY pins. It can
-	 * also be used to customize the whole configuration register:
-	 * 8:6 = PHY Address, 5:4 = Auto-Negotiation, 3 = Interface Mode Select,
-	 * 2 = RX Delay, 1 = TX Delay, 0 = SELRGV (see original PHY datasheet
-	 * for details).
+	 * the RX/TX delays otherwise controlled by RXDLY/TXDLY pins.
+	 * The configuration register definition:
+	 * 14 = reserved
+	 * 13 = Force Tx RX Delay controlled by bit12 bit11,
+	 * 12 = RX Delay, 11 = TX Delay
+	 * 10:0 = Test && debug settings reserved by realtek
 	 */
 	oldpage = phy_select_page(phydev, 0x7);
 	if (oldpage < 0)
@@ -277,7 +277,8 @@ static int rtl8211e_config_init(struct phy_device *phydev)
 	if (ret)
 		goto err_restore_page;
 
-	ret = __phy_modify(phydev, 0x1c, RTL8211E_TX_DELAY | RTL8211E_RX_DELAY,
+	ret = __phy_modify(phydev, 0x1c, RTL8211E_CTRL_DELAY
+			   | RTL8211E_TX_DELAY | RTL8211E_RX_DELAY,
 			   val);
 
 err_restore_page:
-- 
2.25.1



