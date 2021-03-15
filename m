Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 767F233B6A2
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232336AbhCON6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:58:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232100AbhCON5q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBC9264F2A;
        Mon, 15 Mar 2021 13:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816666;
        bh=pny48JMF8EItcEvxYPHnHgRxgT1cLNtVlxNuIxCiRVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QqsRCCsLGvdCQsOvVcXUJpEFfGGMuahwUcABckrMqYcEOl0B2uGY9lH7nDcVrdx9H
         43CSLxnVIVFEzc2q+JsS9x+qFaZgtbzYN4Cza1taYnwIAd/rJNJhAT2QMNC5aKvBWi
         hsRVxDUotYIEImG8M2/0bKqujeZ6dl/VnMC9ulN4=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 051/306] net: enetc: force the RGMII speed and duplex instead of operating in inband mode
Date:   Mon, 15 Mar 2021 14:51:54 +0100
Message-Id: <20210315135509.373702471@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit c76a97218dcbb2cb7cec1404ace43ef96c87d874 upstream.

The ENETC port 0 MAC supports in-band status signaling coming from a PHY
when operating in RGMII mode, and this feature is enabled by default.

It has been reported that RGMII is broken in fixed-link, and that is not
surprising considering the fact that no PHY is attached to the MAC in
that case, but a switch.

This brings us to the topic of the patch: the enetc driver should have
not enabled the optional in-band status signaling for RGMII unconditionally,
but should have forced the speed and duplex to what was resolved by
phylink.

Note that phylink does not accept the RGMII modes as valid for in-band
signaling, and these operate a bit differently than 1000base-x and SGMII
(notably there is no clause 37 state machine so no ACK required from the
MAC, instead the PHY sends extra code words on RXD[3:0] whenever it is
not transmitting something else, so it should be safe to leave a PHY
with this option unconditionally enabled even if we ignore it). The spec
talks about this here:
https://e2e.ti.com/cfs-file/__key/communityserver-discussions-components-files/138/RGMIIv1_5F00_3.pdf

Fixes: 71b77a7a27a3 ("enetc: Migrate to PHYLINK and PCS_LYNX")
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_hw.h |   13 ++++-
 drivers/net/ethernet/freescale/enetc/enetc_pf.c |   53 ++++++++++++++++++++----
 2 files changed, 56 insertions(+), 10 deletions(-)

--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -238,10 +238,17 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_PM_IMDIO_BASE	0x8030
 
 #define ENETC_PM0_IF_MODE	0x8300
-#define ENETC_PMO_IFM_RG	BIT(2)
+#define ENETC_PM0_IFM_RG	BIT(2)
 #define ENETC_PM0_IFM_RLP	(BIT(5) | BIT(11))
-#define ENETC_PM0_IFM_RGAUTO	(BIT(15) | ENETC_PMO_IFM_RG | BIT(1))
-#define ENETC_PM0_IFM_XGMII	BIT(12)
+#define ENETC_PM0_IFM_EN_AUTO	BIT(15)
+#define ENETC_PM0_IFM_SSP_MASK	GENMASK(14, 13)
+#define ENETC_PM0_IFM_SSP_1000	(2 << 13)
+#define ENETC_PM0_IFM_SSP_100	(0 << 13)
+#define ENETC_PM0_IFM_SSP_10	(1 << 13)
+#define ENETC_PM0_IFM_FULL_DPX	BIT(12)
+#define ENETC_PM0_IFM_IFMODE_MASK GENMASK(1, 0)
+#define ENETC_PM0_IFM_IFMODE_XGMII 0
+#define ENETC_PM0_IFM_IFMODE_GMII 2
 #define ENETC_PSIDCAPR		0x1b08
 #define ENETC_PSIDCAPR_MSK	GENMASK(15, 0)
 #define ENETC_PSFCAPR		0x1b18
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -315,7 +315,7 @@ static void enetc_set_loopback(struct ne
 	u32 reg;
 
 	reg = enetc_port_rd(hw, ENETC_PM0_IF_MODE);
-	if (reg & ENETC_PMO_IFM_RG) {
+	if (reg & ENETC_PM0_IFM_RG) {
 		/* RGMII mode */
 		reg = (reg & ~ENETC_PM0_IFM_RLP) |
 		      (en ? ENETC_PM0_IFM_RLP : 0);
@@ -494,13 +494,20 @@ static void enetc_configure_port_mac(str
 
 static void enetc_mac_config(struct enetc_hw *hw, phy_interface_t phy_mode)
 {
-	/* set auto-speed for RGMII */
-	if (enetc_port_rd(hw, ENETC_PM0_IF_MODE) & ENETC_PMO_IFM_RG ||
-	    phy_interface_mode_is_rgmii(phy_mode))
-		enetc_port_wr(hw, ENETC_PM0_IF_MODE, ENETC_PM0_IFM_RGAUTO);
+	u32 val;
+
+	if (phy_interface_mode_is_rgmii(phy_mode)) {
+		val = enetc_port_rd(hw, ENETC_PM0_IF_MODE);
+		val &= ~ENETC_PM0_IFM_EN_AUTO;
+		val &= ENETC_PM0_IFM_IFMODE_MASK;
+		val |= ENETC_PM0_IFM_IFMODE_GMII | ENETC_PM0_IFM_RG;
+		enetc_port_wr(hw, ENETC_PM0_IF_MODE, val);
+	}
 
-	if (phy_mode == PHY_INTERFACE_MODE_USXGMII)
-		enetc_port_wr(hw, ENETC_PM0_IF_MODE, ENETC_PM0_IFM_XGMII);
+	if (phy_mode == PHY_INTERFACE_MODE_USXGMII) {
+		val = ENETC_PM0_IFM_FULL_DPX | ENETC_PM0_IFM_IFMODE_XGMII;
+		enetc_port_wr(hw, ENETC_PM0_IF_MODE, val);
+	}
 }
 
 static void enetc_mac_enable(struct enetc_hw *hw, bool en)
@@ -932,6 +939,34 @@ static void enetc_pl_mac_config(struct p
 		phylink_set_pcs(priv->phylink, &pf->pcs->pcs);
 }
 
+static void enetc_force_rgmii_mac(struct enetc_hw *hw, int speed, int duplex)
+{
+	u32 old_val, val;
+
+	old_val = val = enetc_port_rd(hw, ENETC_PM0_IF_MODE);
+
+	if (speed == SPEED_1000) {
+		val &= ~ENETC_PM0_IFM_SSP_MASK;
+		val |= ENETC_PM0_IFM_SSP_1000;
+	} else if (speed == SPEED_100) {
+		val &= ~ENETC_PM0_IFM_SSP_MASK;
+		val |= ENETC_PM0_IFM_SSP_100;
+	} else if (speed == SPEED_10) {
+		val &= ~ENETC_PM0_IFM_SSP_MASK;
+		val |= ENETC_PM0_IFM_SSP_10;
+	}
+
+	if (duplex == DUPLEX_FULL)
+		val |= ENETC_PM0_IFM_FULL_DPX;
+	else
+		val &= ~ENETC_PM0_IFM_FULL_DPX;
+
+	if (val == old_val)
+		return;
+
+	enetc_port_wr(hw, ENETC_PM0_IF_MODE, val);
+}
+
 static void enetc_pl_mac_link_up(struct phylink_config *config,
 				 struct phy_device *phy, unsigned int mode,
 				 phy_interface_t interface, int speed,
@@ -944,6 +979,10 @@ static void enetc_pl_mac_link_up(struct
 	if (priv->active_offloads & ENETC_F_QBV)
 		enetc_sched_speed_set(priv, speed);
 
+	if (!phylink_autoneg_inband(mode) &&
+	    phy_interface_mode_is_rgmii(interface))
+		enetc_force_rgmii_mac(&pf->si->hw, speed, duplex);
+
 	enetc_mac_enable(&pf->si->hw, true);
 }
 


