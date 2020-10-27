Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDCF29B379
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751685AbgJ0OwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:52:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:49760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1767839AbgJ0Otj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:49:39 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6106A21556;
        Tue, 27 Oct 2020 14:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810178;
        bh=/5GQWw4D3rmI8Jl9NL7ePNH4PhUrnkEXubXjxBQkMXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tdpMCYEmfn3EPuyyDY6knK9+sXDO7wbP2Cq7NCDUDmAjUe/jIjwnP9DRludYGS6mq
         VI9m7qKa/uV2YLrXk6T8M/EAMYQ6SD5CjJ82JcCkKbl+GbRH78t9oaAHwgzKGBveRx
         0fPSY06n+byFrs8zy9LHWWISn3tOihIvBBuPqDWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        "David S. Miller" <davem@davemloft.net>,
        NXP Linux Team <linux-imx@nxp.com>,
        Richard Leitner <richard.leitner@skidata.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.8 007/633] net: fec: Fix phy_device lookup for phy_reset_after_clk_enable()
Date:   Tue, 27 Oct 2020 14:45:50 +0100
Message-Id: <20201027135523.026579559@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 64a632da538a6827fad0ea461925cedb9899ebe2 ]

The phy_reset_after_clk_enable() is always called with ndev->phydev,
however that pointer may be NULL even though the PHY device instance
already exists and is sufficient to perform the PHY reset.

This condition happens in fec_open(), where the clock must be enabled
first, then the PHY must be reset, and then the PHY IDs can be read
out of the PHY.

If the PHY still is not bound to the MAC, but there is OF PHY node
and a matching PHY device instance already, use the OF PHY node to
obtain the PHY device instance, and then use that PHY device instance
when triggering the PHY reset.

Fixes: 1b0a83ac04e3 ("net: fec: add phy_reset_after_clk_enable() support")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Christoph Niedermaier <cniedermaier@dh-electronics.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: NXP Linux Team <linux-imx@nxp.com>
Cc: Richard Leitner <richard.leitner@skidata.com>
Cc: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/fec_main.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1913,6 +1913,27 @@ out:
 	return ret;
 }
 
+static void fec_enet_phy_reset_after_clk_enable(struct net_device *ndev)
+{
+	struct fec_enet_private *fep = netdev_priv(ndev);
+	struct phy_device *phy_dev = ndev->phydev;
+
+	if (phy_dev) {
+		phy_reset_after_clk_enable(phy_dev);
+	} else if (fep->phy_node) {
+		/*
+		 * If the PHY still is not bound to the MAC, but there is
+		 * OF PHY node and a matching PHY device instance already,
+		 * use the OF PHY node to obtain the PHY device instance,
+		 * and then use that PHY device instance when triggering
+		 * the PHY reset.
+		 */
+		phy_dev = of_phy_find_device(fep->phy_node);
+		phy_reset_after_clk_enable(phy_dev);
+		put_device(&phy_dev->mdio.dev);
+	}
+}
+
 static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
@@ -1939,7 +1960,7 @@ static int fec_enet_clk_enable(struct ne
 		if (ret)
 			goto failed_clk_ref;
 
-		phy_reset_after_clk_enable(ndev->phydev);
+		fec_enet_phy_reset_after_clk_enable(ndev);
 	} else {
 		clk_disable_unprepare(fep->clk_enet_out);
 		if (fep->clk_ptp) {
@@ -2994,7 +3015,7 @@ fec_enet_open(struct net_device *ndev)
 	 * phy_reset_after_clk_enable() before because the PHY wasn't probed.
 	 */
 	if (reset_again)
-		phy_reset_after_clk_enable(ndev->phydev);
+		fec_enet_phy_reset_after_clk_enable(ndev);
 
 	if (fep->quirks & FEC_QUIRK_ERR006687)
 		imx6q_cpuidle_fec_irqs_used();


