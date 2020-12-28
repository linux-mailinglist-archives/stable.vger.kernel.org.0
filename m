Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5FF2E648D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391308AbgL1PwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:52:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:38690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391193AbgL1Nig (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:38:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D873622583;
        Mon, 28 Dec 2020 13:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162701;
        bh=9adWWqt3tW+taqVNYCXSuPXMzcIItnPQnGwhEveXDMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=giQKYr4m4ETnHM5Top1mVLraGiuISAc00ByiJRGt4b5oNpMar8EffI+G+FOTJ1DMx
         LbRiUAuLLJHZpe0am7KZVJYlrSWq19E5Y8gcnZbPugUmN7a8ZCAk6zieqgaUqGgFck
         vtAMb+lY8gKwZ5hMWjpxnzqc9W/5mV4sysUwC2os=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 036/453] net: mvpp2: add mvpp2_phylink_to_port() helper
Date:   Mon, 28 Dec 2020 13:44:32 +0100
Message-Id: <20201228124939.001827493@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit 6c2b49eb96716e91f202756bfbd3f5fea3b2b172 ]

Add a helper to convert the struct phylink_config pointer passed in
from phylink to the drivers internal struct mvpp2_port.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 29 +++++++++----------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 63c0334430134..931d1a56b79ca 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -4745,12 +4745,16 @@ static void mvpp2_port_copy_mac_addr(struct net_device *dev, struct mvpp2 *priv,
 	eth_hw_addr_random(dev);
 }
 
+static struct mvpp2_port *mvpp2_phylink_to_port(struct phylink_config *config)
+{
+	return container_of(config, struct mvpp2_port, phylink_config);
+}
+
 static void mvpp2_phylink_validate(struct phylink_config *config,
 				   unsigned long *supported,
 				   struct phylink_link_state *state)
 {
-	struct mvpp2_port *port = container_of(config, struct mvpp2_port,
-					       phylink_config);
+	struct mvpp2_port *port = mvpp2_phylink_to_port(config);
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 
 	/* Invalid combinations */
@@ -4877,8 +4881,7 @@ static void mvpp2_gmac_link_state(struct mvpp2_port *port,
 static int mvpp2_phylink_mac_link_state(struct phylink_config *config,
 					struct phylink_link_state *state)
 {
-	struct mvpp2_port *port = container_of(config, struct mvpp2_port,
-					       phylink_config);
+	struct mvpp2_port *port = mvpp2_phylink_to_port(config);
 
 	if (port->priv->hw_version == MVPP22 && port->gop_id == 0) {
 		u32 mode = readl(port->base + MVPP22_XLG_CTRL3_REG);
@@ -4896,8 +4899,7 @@ static int mvpp2_phylink_mac_link_state(struct phylink_config *config,
 
 static void mvpp2_mac_an_restart(struct phylink_config *config)
 {
-	struct mvpp2_port *port = container_of(config, struct mvpp2_port,
-					       phylink_config);
+	struct mvpp2_port *port = mvpp2_phylink_to_port(config);
 	u32 val = readl(port->base + MVPP2_GMAC_AUTONEG_CONFIG);
 
 	writel(val | MVPP2_GMAC_IN_BAND_RESTART_AN,
@@ -5085,13 +5087,12 @@ static void mvpp2_gmac_config(struct mvpp2_port *port, unsigned int mode,
 static void mvpp2_mac_config(struct phylink_config *config, unsigned int mode,
 			     const struct phylink_link_state *state)
 {
-	struct net_device *dev = to_net_dev(config->dev);
-	struct mvpp2_port *port = netdev_priv(dev);
+	struct mvpp2_port *port = mvpp2_phylink_to_port(config);
 	bool change_interface = port->phy_interface != state->interface;
 
 	/* Check for invalid configuration */
 	if (mvpp2_is_xlg(state->interface) && port->gop_id != 0) {
-		netdev_err(dev, "Invalid mode on %s\n", dev->name);
+		netdev_err(port->dev, "Invalid mode on %s\n", port->dev->name);
 		return;
 	}
 
@@ -5128,8 +5129,7 @@ static void mvpp2_mac_config(struct phylink_config *config, unsigned int mode,
 static void mvpp2_mac_link_up(struct phylink_config *config, unsigned int mode,
 			      phy_interface_t interface, struct phy_device *phy)
 {
-	struct net_device *dev = to_net_dev(config->dev);
-	struct mvpp2_port *port = netdev_priv(dev);
+	struct mvpp2_port *port = mvpp2_phylink_to_port(config);
 	u32 val;
 
 	if (!phylink_autoneg_inband(mode)) {
@@ -5150,14 +5150,13 @@ static void mvpp2_mac_link_up(struct phylink_config *config, unsigned int mode,
 
 	mvpp2_egress_enable(port);
 	mvpp2_ingress_enable(port);
-	netif_tx_wake_all_queues(dev);
+	netif_tx_wake_all_queues(port->dev);
 }
 
 static void mvpp2_mac_link_down(struct phylink_config *config,
 				unsigned int mode, phy_interface_t interface)
 {
-	struct net_device *dev = to_net_dev(config->dev);
-	struct mvpp2_port *port = netdev_priv(dev);
+	struct mvpp2_port *port = mvpp2_phylink_to_port(config);
 	u32 val;
 
 	if (!phylink_autoneg_inband(mode)) {
@@ -5174,7 +5173,7 @@ static void mvpp2_mac_link_down(struct phylink_config *config,
 		}
 	}
 
-	netif_tx_stop_all_queues(dev);
+	netif_tx_stop_all_queues(port->dev);
 	mvpp2_egress_disable(port);
 	mvpp2_ingress_disable(port);
 
-- 
2.27.0



