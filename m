Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCF192B6388
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732706AbgKQNi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:38:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:50370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732705AbgKQNiy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:38:54 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC2BD207BC;
        Tue, 17 Nov 2020 13:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620333;
        bh=l+wsoJgfUfgvzlDek9engkXVQN+ljoEi2Iw75rjm3PA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CZ46/ayTbbY1DCg0MLFn2FvBIYTbMZiClX9b2WApCg2Ix3DS6tUopPZxWduYjGZ2l
         KBvjow+SzbLO1NWdR1ve7mDIgBmGaIaU4vK+gABp2wsw/dGrjdHPhVEarJ41v2Q0gz
         oGq/X3/0u/44Z0XqrZiDL1C4Y2pP57vv+VYy3OUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Sven Van Asbroeck <thesven73@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 156/255] lan743x: correctly handle chips with internal PHY
Date:   Tue, 17 Nov 2020 14:04:56 +0100
Message-Id: <20201117122146.541160651@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

[ Upstream commit 902a66e08ceaadb9a7a1ab3a4f3af611cd1d8cba ]

Commit 6f197fb63850 ("lan743x: Added fixed link and RGMII support")
assumes that chips with an internal PHY will never have a devicetree
entry. This is incorrect: even for these chips, a devicetree entry
can be useful e.g. to pass the mac address from bootloader to chip:

    &pcie {
            status = "okay";

            host@0 {
                    reg = <0 0 0 0 0>;

                    #address-cells = <3>;
                    #size-cells = <2>;

                    lan7430: ethernet@0 {
                            /* LAN7430 with internal PHY */
                            compatible = "microchip,lan743x";
                            status = "okay";
                            reg = <0 0 0 0 0>;
                            /* filled in by bootloader */
                            local-mac-address = [00 00 00 00 00 00];
                    };
            };
    };

If a devicetree entry is present, the driver will not attach the chip
to its internal phy, and the chip will be non-operational.

Fix by tweaking the phy connection algorithm:
- first try to connect to a phy specified in the devicetree
  (could be 'real' phy, or just a 'fixed-link')
- if that doesn't succeed, try to connect to an internal phy, even
  if the chip has a devnode

Tested on a LAN7430 with internal PHY. I cannot test a device using
fixed-link, as I do not have access to one.

Fixes: 6f197fb63850 ("lan743x: Added fixed link and RGMII support")
Tested-by: Sven Van Asbroeck <thesven73@gmail.com> # lan7430
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
Link: https://lore.kernel.org/r/20201108171224.23829-1-TheSven73@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index de93cc6ebc1ac..be58a941965b1 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1027,9 +1027,9 @@ static int lan743x_phy_open(struct lan743x_adapter *adapter)
 
 	netdev = adapter->netdev;
 	phynode = of_node_get(adapter->pdev->dev.of_node);
-	adapter->phy_mode = PHY_INTERFACE_MODE_GMII;
 
 	if (phynode) {
+		/* try devicetree phy, or fixed link */
 		of_get_phy_mode(phynode, &adapter->phy_mode);
 
 		if (of_phy_is_fixed_link(phynode)) {
@@ -1045,13 +1045,15 @@ static int lan743x_phy_open(struct lan743x_adapter *adapter)
 					lan743x_phy_link_status_change, 0,
 					adapter->phy_mode);
 		of_node_put(phynode);
-		if (!phydev)
-			goto return_error;
-	} else {
+	}
+
+	if (!phydev) {
+		/* try internal phy */
 		phydev = phy_find_first(adapter->mdiobus);
 		if (!phydev)
 			goto return_error;
 
+		adapter->phy_mode = PHY_INTERFACE_MODE_GMII;
 		ret = phy_connect_direct(netdev, phydev,
 					 lan743x_phy_link_status_change,
 					 adapter->phy_mode);
-- 
2.27.0



