Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA8ED20127B
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392958AbgFSPWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:22:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392956AbgFSPWJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:22:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3328B21841;
        Fri, 19 Jun 2020 15:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580127;
        bh=HrQ0JH3fWf2Xyn1OUWcR/S2dJr+n45S5WHwcAjxQsoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R9NGghHVxoPijtyhRqboqA4ExqVHTjLJWTCaJBKe+0qP3HKbaF/6EHh7cWOUdYWPp
         az0f5iUUwmjRR/hvkqlePiyTSj0XthJqD8q6Yfq6mIKASCmnscdZqG+ohNo+S1kI2L
         9k57e+wDlmwix4WTvW0SXBIyYZhOzEKKyZnbLKYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 132/376] net: bcmgenet: Fix WoL with password after deep sleep
Date:   Fri, 19 Jun 2020 16:30:50 +0200
Message-Id: <20200619141716.584557441@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>

[ Upstream commit 6f7689057a0f10a6c967b9f2759d7a3dc948b930 ]

Broadcom STB chips support a deep sleep mode where all register contents
are lost. Because we were stashing the MagicPacket password into some of
these registers a suspend into that deep sleep then a resumption would
not lead to being able to wake-up from MagicPacket with password again.

Fix this by keeping a software copy of the password and program it
during suspend.

Fixes: c51de7f3976b ("net: bcmgenet: add Wake-on-LAN support code")
Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Doug Berger <opendmb@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/broadcom/genet/bcmgenet.h    |  2 +
 .../ethernet/broadcom/genet/bcmgenet_wol.c    | 39 +++++++++----------
 2 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.h b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
index daf8fb2c39b6..c3bfe97f2e5c 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
@@ -14,6 +14,7 @@
 #include <linux/if_vlan.h>
 #include <linux/phy.h>
 #include <linux/dim.h>
+#include <linux/ethtool.h>
 
 /* total number of Buffer Descriptors, same for Rx/Tx */
 #define TOTAL_DESC				256
@@ -676,6 +677,7 @@ struct bcmgenet_priv {
 	/* WOL */
 	struct clk *clk_wol;
 	u32 wolopts;
+	u8 sopass[SOPASS_MAX];
 
 	struct bcmgenet_mib_counters mib;
 
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
index c9a43695b182..597c0498689a 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -41,18 +41,13 @@
 void bcmgenet_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
-	u32 reg;
 
 	wol->supported = WAKE_MAGIC | WAKE_MAGICSECURE;
 	wol->wolopts = priv->wolopts;
 	memset(wol->sopass, 0, sizeof(wol->sopass));
 
-	if (wol->wolopts & WAKE_MAGICSECURE) {
-		reg = bcmgenet_umac_readl(priv, UMAC_MPD_PW_MS);
-		put_unaligned_be16(reg, &wol->sopass[0]);
-		reg = bcmgenet_umac_readl(priv, UMAC_MPD_PW_LS);
-		put_unaligned_be32(reg, &wol->sopass[2]);
-	}
+	if (wol->wolopts & WAKE_MAGICSECURE)
+		memcpy(wol->sopass, priv->sopass, sizeof(priv->sopass));
 }
 
 /* ethtool function - set WOL (Wake on LAN) settings.
@@ -62,7 +57,6 @@ int bcmgenet_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	struct device *kdev = &priv->pdev->dev;
-	u32 reg;
 
 	if (!device_can_wakeup(kdev))
 		return -ENOTSUPP;
@@ -70,17 +64,8 @@ int bcmgenet_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 	if (wol->wolopts & ~(WAKE_MAGIC | WAKE_MAGICSECURE))
 		return -EINVAL;
 
-	reg = bcmgenet_umac_readl(priv, UMAC_MPD_CTRL);
-	if (wol->wolopts & WAKE_MAGICSECURE) {
-		bcmgenet_umac_writel(priv, get_unaligned_be16(&wol->sopass[0]),
-				     UMAC_MPD_PW_MS);
-		bcmgenet_umac_writel(priv, get_unaligned_be32(&wol->sopass[2]),
-				     UMAC_MPD_PW_LS);
-		reg |= MPD_PW_EN;
-	} else {
-		reg &= ~MPD_PW_EN;
-	}
-	bcmgenet_umac_writel(priv, reg, UMAC_MPD_CTRL);
+	if (wol->wolopts & WAKE_MAGICSECURE)
+		memcpy(priv->sopass, wol->sopass, sizeof(priv->sopass));
 
 	/* Flag the device and relevant IRQ as wakeup capable */
 	if (wol->wolopts) {
@@ -120,6 +105,14 @@ static int bcmgenet_poll_wol_status(struct bcmgenet_priv *priv)
 	return retries;
 }
 
+static void bcmgenet_set_mpd_password(struct bcmgenet_priv *priv)
+{
+	bcmgenet_umac_writel(priv, get_unaligned_be16(&priv->sopass[0]),
+			     UMAC_MPD_PW_MS);
+	bcmgenet_umac_writel(priv, get_unaligned_be32(&priv->sopass[2]),
+			     UMAC_MPD_PW_LS);
+}
+
 int bcmgenet_wol_power_down_cfg(struct bcmgenet_priv *priv,
 				enum bcmgenet_power_mode mode)
 {
@@ -144,13 +137,17 @@ int bcmgenet_wol_power_down_cfg(struct bcmgenet_priv *priv,
 
 	reg = bcmgenet_umac_readl(priv, UMAC_MPD_CTRL);
 	reg |= MPD_EN;
+	if (priv->wolopts & WAKE_MAGICSECURE) {
+		bcmgenet_set_mpd_password(priv);
+		reg |= MPD_PW_EN;
+	}
 	bcmgenet_umac_writel(priv, reg, UMAC_MPD_CTRL);
 
 	/* Do not leave UniMAC in MPD mode only */
 	retries = bcmgenet_poll_wol_status(priv);
 	if (retries < 0) {
 		reg = bcmgenet_umac_readl(priv, UMAC_MPD_CTRL);
-		reg &= ~MPD_EN;
+		reg &= ~(MPD_EN | MPD_PW_EN);
 		bcmgenet_umac_writel(priv, reg, UMAC_MPD_CTRL);
 		return retries;
 	}
@@ -189,7 +186,7 @@ void bcmgenet_wol_power_up_cfg(struct bcmgenet_priv *priv,
 	reg = bcmgenet_umac_readl(priv, UMAC_MPD_CTRL);
 	if (!(reg & MPD_EN))
 		return;	/* already powered up so skip the rest */
-	reg &= ~MPD_EN;
+	reg &= ~(MPD_EN | MPD_PW_EN);
 	bcmgenet_umac_writel(priv, reg, UMAC_MPD_CTRL);
 
 	/* Disable CRC Forward */
-- 
2.25.1



