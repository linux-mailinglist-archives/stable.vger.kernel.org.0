Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFD8511B552
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731996AbfLKPTj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:19:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:48526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732087AbfLKPTi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:19:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2F522073D;
        Wed, 11 Dec 2019 15:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077577;
        bh=Ui/vXWTPW+ep9CSKePB8ueYs5BQUXpMH5nPod2Pmr5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1FGKLVNTPot5g3sMBQ+RQa0KfvIRoVSqmkvkWM2LaWxepvmL7LGaG9Bc/JTU3gMCh
         +lC9JBTiHyztiGEzQvS0XAx0BGRMANrMwNjrCXn6JbgK1rN0qGOFUZrK3zwpNLE5Og
         54YtqCiRTFU9h/wHU7dQkDwDQSaxoH+02ZM5ZoLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Magnus Damm <damm+renesas@opensource.se>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 091/243] ravb: Clean up duplex handling
Date:   Wed, 11 Dec 2019 16:04:13 +0100
Message-Id: <20191211150345.259412083@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Magnus Damm <damm+renesas@opensource.se>

[ Upstream commit 08b43857804dd0eca48f5c5a84885cf0079586e0 ]

Since only full-duplex operation is supported by the
hardware, remove duplex handling code and keep the
register setting of ECMR.DM fixed at 1.

This updates the driver implementation to follow the
data sheet text "This bit should always be set to 1."

Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
Signed-off-by: Magnus Damm <damm+renesas@opensource.se>
Reviewed-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb.h      |  1 -
 drivers/net/ethernet/renesas/ravb_main.c | 19 +------------------
 2 files changed, 1 insertion(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 9b6bf557a2f5f..e04af9546e526 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -1029,7 +1029,6 @@ struct ravb_private {
 	phy_interface_t phy_interface;
 	int msg_enable;
 	int speed;
-	int duplex;
 	int emac_irq;
 	enum ravb_chip_id chip_id;
 	int rx_irqs[NUM_RX_QUEUE];
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 5462d2e8a1b71..faaf74073a120 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -82,13 +82,6 @@ static int ravb_config(struct net_device *ndev)
 	return error;
 }
 
-static void ravb_set_duplex(struct net_device *ndev)
-{
-	struct ravb_private *priv = netdev_priv(ndev);
-
-	ravb_modify(ndev, ECMR, ECMR_DM, priv->duplex ? ECMR_DM : 0);
-}
-
 static void ravb_set_rate(struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
@@ -398,13 +391,11 @@ error:
 /* E-MAC init function */
 static void ravb_emac_init(struct net_device *ndev)
 {
-	struct ravb_private *priv = netdev_priv(ndev);
-
 	/* Receive frame limit set register */
 	ravb_write(ndev, ndev->mtu + ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN, RFLR);
 
 	/* EMAC Mode: PAUSE prohibition; Duplex; RX Checksum; TX; RX */
-	ravb_write(ndev, ECMR_ZPF | (priv->duplex ? ECMR_DM : 0) |
+	ravb_write(ndev, ECMR_ZPF | ECMR_DM |
 		   (ndev->features & NETIF_F_RXCSUM ? ECMR_RCSC : 0) |
 		   ECMR_TE | ECMR_RE, ECMR);
 
@@ -992,12 +983,6 @@ static void ravb_adjust_link(struct net_device *ndev)
 		ravb_rcv_snd_disable(ndev);
 
 	if (phydev->link) {
-		if (phydev->duplex != priv->duplex) {
-			new_state = true;
-			priv->duplex = phydev->duplex;
-			ravb_set_duplex(ndev);
-		}
-
 		if (phydev->speed != priv->speed) {
 			new_state = true;
 			priv->speed = phydev->speed;
@@ -1012,7 +997,6 @@ static void ravb_adjust_link(struct net_device *ndev)
 		new_state = true;
 		priv->link = 0;
 		priv->speed = 0;
-		priv->duplex = -1;
 	}
 
 	/* Enable TX and RX right over here, if E-MAC change is ignored */
@@ -1042,7 +1026,6 @@ static int ravb_phy_init(struct net_device *ndev)
 
 	priv->link = 0;
 	priv->speed = 0;
-	priv->duplex = -1;
 
 	/* Try connecting to PHY */
 	pn = of_parse_phandle(np, "phy-handle", 0);
-- 
2.20.1



