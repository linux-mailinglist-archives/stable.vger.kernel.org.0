Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F4437CDAA
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238942AbhELQ5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:57:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244047AbhELQm3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E2B461D0F;
        Wed, 12 May 2021 16:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835804;
        bh=OtC9/zlz9fQ+rauJIXWscWS4duqHmygIT6JDX2TTHNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wn+pyK3dPGa+Fhr4kZM5UYsDC0bi9/PlFOiVkm5NfoYon7rpisjoyNLAunzT4LeH0
         RPYJWF7Hawfj3emq+cKDearEO4xY0sV54MS3NSPQqf4/FOd1rdawuXGGEboXdPoNbd
         Z/FsQo1JjmSPrNMPH8XBejLtl2XZfKUfX1KR2jaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 456/677] net: dsa: bcm_sf2: add function finding RGMII register
Date:   Wed, 12 May 2021 16:48:22 +0200
Message-Id: <20210512144852.506806343@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 55cfeb396965c3906a84d09a9c487d065e37773b ]

Simple macro like REG_RGMII_CNTRL_P() is insufficient as:
1. It doesn't validate port argument
2. It doesn't support chipsets with non-lineral RGMII regs layout

Missing port validation could result in getting register offset from out
of array. Random memory -> random offset -> random reads/writes. It
affected e.g. BCM4908 for REG_RGMII_CNTRL_P(7).

Fixes: a78e86ed586d ("net: dsa: bcm_sf2: Prepare for different register layouts")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/bcm_sf2.c      | 49 +++++++++++++++++++++++++++++-----
 drivers/net/dsa/bcm_sf2_regs.h |  2 --
 2 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index ba5d546d06aa..cd64b7f471b5 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -32,6 +32,31 @@
 #include "b53/b53_priv.h"
 #include "b53/b53_regs.h"
 
+static u16 bcm_sf2_reg_rgmii_cntrl(struct bcm_sf2_priv *priv, int port)
+{
+	switch (priv->type) {
+	case BCM4908_DEVICE_ID:
+		/* TODO */
+		break;
+	default:
+		switch (port) {
+		case 0:
+			return REG_RGMII_0_CNTRL;
+		case 1:
+			return REG_RGMII_1_CNTRL;
+		case 2:
+			return REG_RGMII_2_CNTRL;
+		default:
+			break;
+		}
+	}
+
+	WARN_ONCE(1, "Unsupported port %d\n", port);
+
+	/* RO fallback reg */
+	return REG_SWITCH_STATUS;
+}
+
 /* Return the number of active ports, not counting the IMP (CPU) port */
 static unsigned int bcm_sf2_num_active_ports(struct dsa_switch *ds)
 {
@@ -647,6 +672,7 @@ static void bcm_sf2_sw_mac_config(struct dsa_switch *ds, int port,
 {
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	u32 id_mode_dis = 0, port_mode;
+	u32 reg_rgmii_ctrl;
 	u32 reg;
 
 	if (port == core_readl(priv, CORE_IMP0_PRT_ID))
@@ -670,10 +696,12 @@ static void bcm_sf2_sw_mac_config(struct dsa_switch *ds, int port,
 		return;
 	}
 
+	reg_rgmii_ctrl = bcm_sf2_reg_rgmii_cntrl(priv, port);
+
 	/* Clear id_mode_dis bit, and the existing port mode, let
 	 * RGMII_MODE_EN bet set by mac_link_{up,down}
 	 */
-	reg = reg_readl(priv, REG_RGMII_CNTRL_P(port));
+	reg = reg_readl(priv, reg_rgmii_ctrl);
 	reg &= ~ID_MODE_DIS;
 	reg &= ~(PORT_MODE_MASK << PORT_MODE_SHIFT);
 
@@ -681,13 +709,14 @@ static void bcm_sf2_sw_mac_config(struct dsa_switch *ds, int port,
 	if (id_mode_dis)
 		reg |= ID_MODE_DIS;
 
-	reg_writel(priv, reg, REG_RGMII_CNTRL_P(port));
+	reg_writel(priv, reg, reg_rgmii_ctrl);
 }
 
 static void bcm_sf2_sw_mac_link_set(struct dsa_switch *ds, int port,
 				    phy_interface_t interface, bool link)
 {
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
+	u32 reg_rgmii_ctrl;
 	u32 reg;
 
 	if (!phy_interface_mode_is_rgmii(interface) &&
@@ -695,13 +724,15 @@ static void bcm_sf2_sw_mac_link_set(struct dsa_switch *ds, int port,
 	    interface != PHY_INTERFACE_MODE_REVMII)
 		return;
 
+	reg_rgmii_ctrl = bcm_sf2_reg_rgmii_cntrl(priv, port);
+
 	/* If the link is down, just disable the interface to conserve power */
-	reg = reg_readl(priv, REG_RGMII_CNTRL_P(port));
+	reg = reg_readl(priv, reg_rgmii_ctrl);
 	if (link)
 		reg |= RGMII_MODE_EN;
 	else
 		reg &= ~RGMII_MODE_EN;
-	reg_writel(priv, reg, REG_RGMII_CNTRL_P(port));
+	reg_writel(priv, reg, reg_rgmii_ctrl);
 }
 
 static void bcm_sf2_sw_mac_link_down(struct dsa_switch *ds, int port,
@@ -735,11 +766,15 @@ static void bcm_sf2_sw_mac_link_up(struct dsa_switch *ds, int port,
 {
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	struct ethtool_eee *p = &priv->dev->ports[port].eee;
-	u32 reg, offset;
 
 	bcm_sf2_sw_mac_link_set(ds, port, interface, true);
 
 	if (port != core_readl(priv, CORE_IMP0_PRT_ID)) {
+		u32 reg_rgmii_ctrl;
+		u32 reg, offset;
+
+		reg_rgmii_ctrl = bcm_sf2_reg_rgmii_cntrl(priv, port);
+
 		if (priv->type == BCM4908_DEVICE_ID ||
 		    priv->type == BCM7445_DEVICE_ID)
 			offset = CORE_STS_OVERRIDE_GMIIP_PORT(port);
@@ -750,7 +785,7 @@ static void bcm_sf2_sw_mac_link_up(struct dsa_switch *ds, int port,
 		    interface == PHY_INTERFACE_MODE_RGMII_TXID ||
 		    interface == PHY_INTERFACE_MODE_MII ||
 		    interface == PHY_INTERFACE_MODE_REVMII) {
-			reg = reg_readl(priv, REG_RGMII_CNTRL_P(port));
+			reg = reg_readl(priv, reg_rgmii_ctrl);
 			reg &= ~(RX_PAUSE_EN | TX_PAUSE_EN);
 
 			if (tx_pause)
@@ -758,7 +793,7 @@ static void bcm_sf2_sw_mac_link_up(struct dsa_switch *ds, int port,
 			if (rx_pause)
 				reg |= RX_PAUSE_EN;
 
-			reg_writel(priv, reg, REG_RGMII_CNTRL_P(port));
+			reg_writel(priv, reg, reg_rgmii_ctrl);
 		}
 
 		reg = SW_OVERRIDE | LINK_STS;
diff --git a/drivers/net/dsa/bcm_sf2_regs.h b/drivers/net/dsa/bcm_sf2_regs.h
index 1d2d55c9f8aa..c7783cb45845 100644
--- a/drivers/net/dsa/bcm_sf2_regs.h
+++ b/drivers/net/dsa/bcm_sf2_regs.h
@@ -48,8 +48,6 @@ enum bcm_sf2_reg_offs {
 #define  PHY_PHYAD_SHIFT		8
 #define  PHY_PHYAD_MASK			0x1F
 
-#define REG_RGMII_CNTRL_P(x)		(REG_RGMII_0_CNTRL + (x))
-
 /* Relative to REG_RGMII_CNTRL */
 #define  RGMII_MODE_EN			(1 << 0)
 #define  ID_MODE_DIS			(1 << 1)
-- 
2.30.2



