Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2FA198F6B
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729950AbgCaJDO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:03:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730437AbgCaJDN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:03:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABC06208E0;
        Tue, 31 Mar 2020 09:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645393;
        bh=qx1EzHDl9zZsR19UzEe5WF95rNKTfjaKgs1WrRiJfcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cNPtC70HfxAGdxzQcwvzFYqwnad+LN/KmO2N6C/iZV5evXT99KzhLGMXWazi08KGm
         hKybgBZNXCkY5/wXE/0RwsAzrwUsHxQW+p3Imt+SelF4VXVsgKRte/mzCEgBSxKFd3
         H+9pl1NRKJnM/RW55ja3BMCmVumqYJgDEZMe3zig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 040/170] Revert "net: bcmgenet: use RGMII loopback for MAC reset"
Date:   Tue, 31 Mar 2020 10:57:34 +0200
Message-Id: <20200331085428.328345541@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>

[ Upstream commit 612eb1c3b9e504de24136c947ed7c07bc342f3aa ]

This reverts commit 3a55402c93877d291b0a612d25edb03d1b4b93ac.

This is not a good solution when connecting to an external switch
that may not support the isolation of the TXC signal resulting in
output driver contention on the pin.

A different solution is necessary.

Signed-off-by: Doug Berger <opendmb@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c |    2 +
 drivers/net/ethernet/broadcom/genet/bcmmii.c   |   34 -------------------------
 2 files changed, 2 insertions(+), 34 deletions(-)

--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1996,6 +1996,8 @@ static void reset_umac(struct bcmgenet_p
 
 	/* issue soft reset with (rg)mii loopback to ensure a stable rxclk */
 	bcmgenet_umac_writel(priv, CMD_SW_RESET | CMD_LCL_LOOP_EN, UMAC_CMD);
+	udelay(2);
+	bcmgenet_umac_writel(priv, 0, UMAC_CMD);
 }
 
 static void bcmgenet_intr_disable(struct bcmgenet_priv *priv)
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -181,38 +181,8 @@ int bcmgenet_mii_config(struct net_devic
 	const char *phy_name = NULL;
 	u32 id_mode_dis = 0;
 	u32 port_ctrl;
-	int bmcr = -1;
-	int ret;
 	u32 reg;
 
-	/* MAC clocking workaround during reset of umac state machines */
-	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
-	if (reg & CMD_SW_RESET) {
-		/* An MII PHY must be isolated to prevent TXC contention */
-		if (priv->phy_interface == PHY_INTERFACE_MODE_MII) {
-			ret = phy_read(phydev, MII_BMCR);
-			if (ret >= 0) {
-				bmcr = ret;
-				ret = phy_write(phydev, MII_BMCR,
-						bmcr | BMCR_ISOLATE);
-			}
-			if (ret) {
-				netdev_err(dev, "failed to isolate PHY\n");
-				return ret;
-			}
-		}
-		/* Switch MAC clocking to RGMII generated clock */
-		bcmgenet_sys_writel(priv, PORT_MODE_EXT_GPHY, SYS_PORT_CTRL);
-		/* Ensure 5 clks with Rx disabled
-		 * followed by 5 clks with Reset asserted
-		 */
-		udelay(4);
-		reg &= ~(CMD_SW_RESET | CMD_LCL_LOOP_EN);
-		bcmgenet_umac_writel(priv, reg, UMAC_CMD);
-		/* Ensure 5 more clocks before Rx is enabled */
-		udelay(2);
-	}
-
 	switch (priv->phy_interface) {
 	case PHY_INTERFACE_MODE_INTERNAL:
 		phy_name = "internal PHY";
@@ -282,10 +252,6 @@ int bcmgenet_mii_config(struct net_devic
 
 	bcmgenet_sys_writel(priv, port_ctrl, SYS_PORT_CTRL);
 
-	/* Restore the MII PHY after isolation */
-	if (bmcr >= 0)
-		phy_write(phydev, MII_BMCR, bmcr);
-
 	priv->ext_phy = !priv->internal_phy &&
 			(priv->phy_interface != PHY_INTERFACE_MODE_MOCA);
 


