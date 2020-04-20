Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 402EE1B0B8A
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729248AbgDTM4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:56:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728032AbgDTMpA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:45:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDAAA206E9;
        Mon, 20 Apr 2020 12:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386699;
        bh=AH65koec8WOBWM1zeVHm8Pgxvc83jMWH+nwpbn/0BBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qfYSxgYw8xkL6h8+08qapXX2BzDQvdT3cx+CcCogdMyRf2mcFWVro18Vws6rgNDu/
         wArA0eA1VlGyY3vnayR4xZGzHv/HB+lVPueiyTsCX1j2M4tSQO39lefd1pv+FUjvSI
         xnpf1a0fC2TrFwyfFVatwqjvT9mbLgFBZB2somdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 12/71] net: dsa: mt7530: move mt7623 settings out off the mt7530
Date:   Mon, 20 Apr 2020 14:38:26 +0200
Message-Id: <20200420121510.892710212@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121508.491252919@linuxfoundation.org>
References: <20200420121508.491252919@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "René van Dorst" <opensource@vdorst.com>

[ Upstream commit 84d2f7b708c374a15a2abe092a74e0e47d018286 ]

Moving mt7623 logic out off mt7530, is required to make hardware setting
consistent after we introduce phylink to mtk driver.

Fixes: ca366d6c889b ("net: dsa: mt7530: Convert to PHYLINK API")
Reviewed-by: Sean Wang <sean.wang@mediatek.com>
Tested-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: RenÃ© van Dorst <opensource@vdorst.com>
Tested-by: Frank Wunderlich <frank-w@public-files.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mt7530.c |   85 -----------------------------------------------
 drivers/net/dsa/mt7530.h |   10 -----
 2 files changed, 95 deletions(-)

--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -67,58 +67,6 @@ static const struct mt7530_mib_desc mt75
 };
 
 static int
-mt7623_trgmii_write(struct mt7530_priv *priv,  u32 reg, u32 val)
-{
-	int ret;
-
-	ret =  regmap_write(priv->ethernet, TRGMII_BASE(reg), val);
-	if (ret < 0)
-		dev_err(priv->dev,
-			"failed to priv write register\n");
-	return ret;
-}
-
-static u32
-mt7623_trgmii_read(struct mt7530_priv *priv, u32 reg)
-{
-	int ret;
-	u32 val;
-
-	ret = regmap_read(priv->ethernet, TRGMII_BASE(reg), &val);
-	if (ret < 0) {
-		dev_err(priv->dev,
-			"failed to priv read register\n");
-		return ret;
-	}
-
-	return val;
-}
-
-static void
-mt7623_trgmii_rmw(struct mt7530_priv *priv, u32 reg,
-		  u32 mask, u32 set)
-{
-	u32 val;
-
-	val = mt7623_trgmii_read(priv, reg);
-	val &= ~mask;
-	val |= set;
-	mt7623_trgmii_write(priv, reg, val);
-}
-
-static void
-mt7623_trgmii_set(struct mt7530_priv *priv, u32 reg, u32 val)
-{
-	mt7623_trgmii_rmw(priv, reg, 0, val);
-}
-
-static void
-mt7623_trgmii_clear(struct mt7530_priv *priv, u32 reg, u32 val)
-{
-	mt7623_trgmii_rmw(priv, reg, val, 0);
-}
-
-static int
 core_read_mmd_indirect(struct mt7530_priv *priv, int prtad, int devad)
 {
 	struct mii_bus *bus = priv->bus;
@@ -530,27 +478,6 @@ mt7530_pad_clk_setup(struct dsa_switch *
 		for (i = 0 ; i < NUM_TRGMII_CTRL; i++)
 			mt7530_rmw(priv, MT7530_TRGMII_RD(i),
 				   RD_TAP_MASK, RD_TAP(16));
-	else
-		if (priv->id != ID_MT7621)
-			mt7623_trgmii_set(priv, GSW_INTF_MODE,
-					  INTF_MODE_TRGMII);
-
-	return 0;
-}
-
-static int
-mt7623_pad_clk_setup(struct dsa_switch *ds)
-{
-	struct mt7530_priv *priv = ds->priv;
-	int i;
-
-	for (i = 0 ; i < NUM_TRGMII_CTRL; i++)
-		mt7623_trgmii_write(priv, GSW_TRGMII_TD_ODT(i),
-				    TD_DM_DRVP(8) | TD_DM_DRVN(8));
-
-	mt7623_trgmii_set(priv, GSW_TRGMII_RCK_CTRL, RX_RST | RXC_DQSISEL);
-	mt7623_trgmii_clear(priv, GSW_TRGMII_RCK_CTRL, RX_RST);
-
 	return 0;
 }
 
@@ -1258,10 +1185,6 @@ mt7530_setup(struct dsa_switch *ds)
 	dn = dsa_to_port(ds, MT7530_CPU_PORT)->master->dev.of_node->parent;
 
 	if (priv->id == ID_MT7530) {
-		priv->ethernet = syscon_node_to_regmap(dn);
-		if (IS_ERR(priv->ethernet))
-			return PTR_ERR(priv->ethernet);
-
 		regulator_set_voltage(priv->core_pwr, 1000000, 1000000);
 		ret = regulator_enable(priv->core_pwr);
 		if (ret < 0) {
@@ -1427,14 +1350,6 @@ static void mt7530_phylink_mac_config(st
 		/* Setup TX circuit incluing relevant PAD and driving */
 		mt7530_pad_clk_setup(ds, state->interface);
 
-		if (priv->id == ID_MT7530) {
-			/* Setup RX circuit, relevant PAD and driving on the
-			 * host which must be placed after the setup on the
-			 * device side is all finished.
-			 */
-			mt7623_pad_clk_setup(ds);
-		}
-
 		priv->p6_interface = state->interface;
 		break;
 	default:
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -275,7 +275,6 @@ enum mt7530_vlan_port_attr {
 
 /* Registers for TRGMII on the both side */
 #define MT7530_TRGMII_RCK_CTRL		0x7a00
-#define GSW_TRGMII_RCK_CTRL		0x300
 #define  RX_RST				BIT(31)
 #define  RXC_DQSISEL			BIT(30)
 #define  DQSI1_TAP_MASK			(0x7f << 8)
@@ -284,31 +283,24 @@ enum mt7530_vlan_port_attr {
 #define  DQSI0_TAP(x)			((x) & 0x7f)
 
 #define MT7530_TRGMII_RCK_RTT		0x7a04
-#define GSW_TRGMII_RCK_RTT		0x304
 #define  DQS1_GATE			BIT(31)
 #define  DQS0_GATE			BIT(30)
 
 #define MT7530_TRGMII_RD(x)		(0x7a10 + (x) * 8)
-#define GSW_TRGMII_RD(x)		(0x310 + (x) * 8)
 #define  BSLIP_EN			BIT(31)
 #define  EDGE_CHK			BIT(30)
 #define  RD_TAP_MASK			0x7f
 #define  RD_TAP(x)			((x) & 0x7f)
 
-#define GSW_TRGMII_TXCTRL		0x340
 #define MT7530_TRGMII_TXCTRL		0x7a40
 #define  TRAIN_TXEN			BIT(31)
 #define  TXC_INV			BIT(30)
 #define  TX_RST				BIT(28)
 
 #define MT7530_TRGMII_TD_ODT(i)		(0x7a54 + 8 * (i))
-#define GSW_TRGMII_TD_ODT(i)		(0x354 + 8 * (i))
 #define  TD_DM_DRVP(x)			((x) & 0xf)
 #define  TD_DM_DRVN(x)			(((x) & 0xf) << 4)
 
-#define GSW_INTF_MODE			0x390
-#define  INTF_MODE_TRGMII		BIT(1)
-
 #define MT7530_TRGMII_TCK_CTRL		0x7a78
 #define  TCK_TAP(x)			(((x) & 0xf) << 8)
 
@@ -441,7 +433,6 @@ static const char *p5_intf_modes(unsigne
  * @ds:			The pointer to the dsa core structure
  * @bus:		The bus used for the device and built-in PHY
  * @rstc:		The pointer to reset control used by MCM
- * @ethernet:		The regmap used for access TRGMII-based registers
  * @core_pwr:		The power supplied into the core
  * @io_pwr:		The power supplied into the I/O
  * @reset:		The descriptor for GPIO line tied to its reset pin
@@ -458,7 +449,6 @@ struct mt7530_priv {
 	struct dsa_switch	*ds;
 	struct mii_bus		*bus;
 	struct reset_control	*rstc;
-	struct regmap		*ethernet;
 	struct regulator	*core_pwr;
 	struct regulator	*io_pwr;
 	struct gpio_desc	*reset;


