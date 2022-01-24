Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71F1549AA1A
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344411AbiAYDc4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:32:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1321306AbiAYDR7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 22:17:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF45C0C686C;
        Mon, 24 Jan 2022 12:42:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C3B7615AE;
        Mon, 24 Jan 2022 20:42:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54CCBC340E5;
        Mon, 24 Jan 2022 20:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056947;
        bh=6Ffjc0j4oN3pwbGlaO8ipe1+bWqrc3kZfYLkp7fJqtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u7FTWunHHjYrSAQpQvFVcosLfrgpOLhnCsqyDcU3Ct6Khix9pBiapqnyIzoGTFgfs
         m2MGUREs5ba4G035jEjBD+1vwv7znGIxg8xRCh3OPZpCl9mlSNNsi6haZ+8Kx/hXWm
         LwuLdXRGhLziogg39sriQu+ngg5cC8kso9ZYYC2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 609/846] net: gemini: allow any RGMII interface mode
Date:   Mon, 24 Jan 2022 19:42:06 +0100
Message-Id: <20220124184122.033141045@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit 4e4f325a0a55907b14f579e6b1a38c53755e3de2 ]

The four RGMII interface modes take care of the required RGMII delay
configuration at the PHY and should not be limited by the network MAC
driver. Sadly, gemini was only permitting RGMII mode with no delays,
which would require the required delay to be inserted via PCB tracking
or by the MAC.

However, there are designs that require the PHY to add the delay, which
is impossible without Gemini permitting the other three PHY interface
modes. Fix the driver to allow these.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Link: https://lore.kernel.org/r/E1n4mpT-002PLd-Ha@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cortina/gemini.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 6e745ca4c4333..012ca11a38cc1 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -305,21 +305,21 @@ static void gmac_speed_set(struct net_device *netdev)
 	switch (phydev->speed) {
 	case 1000:
 		status.bits.speed = GMAC_SPEED_1000;
-		if (phydev->interface == PHY_INTERFACE_MODE_RGMII)
+		if (phy_interface_mode_is_rgmii(phydev->interface))
 			status.bits.mii_rmii = GMAC_PHY_RGMII_1000;
 		netdev_dbg(netdev, "connect %s to RGMII @ 1Gbit\n",
 			   phydev_name(phydev));
 		break;
 	case 100:
 		status.bits.speed = GMAC_SPEED_100;
-		if (phydev->interface == PHY_INTERFACE_MODE_RGMII)
+		if (phy_interface_mode_is_rgmii(phydev->interface))
 			status.bits.mii_rmii = GMAC_PHY_RGMII_100_10;
 		netdev_dbg(netdev, "connect %s to RGMII @ 100 Mbit\n",
 			   phydev_name(phydev));
 		break;
 	case 10:
 		status.bits.speed = GMAC_SPEED_10;
-		if (phydev->interface == PHY_INTERFACE_MODE_RGMII)
+		if (phy_interface_mode_is_rgmii(phydev->interface))
 			status.bits.mii_rmii = GMAC_PHY_RGMII_100_10;
 		netdev_dbg(netdev, "connect %s to RGMII @ 10 Mbit\n",
 			   phydev_name(phydev));
@@ -389,6 +389,9 @@ static int gmac_setup_phy(struct net_device *netdev)
 		status.bits.mii_rmii = GMAC_PHY_GMII;
 		break;
 	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
 		netdev_dbg(netdev,
 			   "RGMII: set GMAC0 and GMAC1 to MII/RGMII mode\n");
 		status.bits.mii_rmii = GMAC_PHY_RGMII_100_10;
-- 
2.34.1



