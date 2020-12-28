Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F302A2E3CCE
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438308AbgL1OHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:07:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:41002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438076AbgL1OG2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:06:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2ED62207AB;
        Mon, 28 Dec 2020 14:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164347;
        bh=0HljBkdmGUiGlvx6pH+LJX5mNOiVb1MxeSjR+OzNY2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RzRa3RGs7P8RTzj5QefS9IdN3JWtHLnaQODMhRAfQO7S+yIEI+AG4ieVlt0KT1/NQ
         cCJlbV+gBpkXWyveqhdygWQknIEErGEqvctq4Z/44Ad7itznaQtT3iLLONn5lHXCL+
         M2k6khDNBQLt3qwmh3+/WoVijfYNlEyFRXBgTJ6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shannon Nelson <snelson@pensando.io>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 117/717] ionic: change set_rx_mode from_ndo to can_sleep
Date:   Mon, 28 Dec 2020 13:41:55 +0100
Message-Id: <20201228125026.567160474@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>

[ Upstream commit 81dbc24147f9250c186ae5875b3ed3136e9e293b ]

Instead of having two different ways of expressing the same
sleepability concept, using opposite logic, we can rework the
from_ndo to can_sleep for a more consistent usage.

Fixes: 1800eee16676 ("net: ionic: Replace in_interrupt() usage.")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 7ad9f0cc1af66..c968c5c5a60a0 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1129,7 +1129,7 @@ static void ionic_lif_rx_mode(struct ionic_lif *lif, unsigned int rx_mode)
 		lif->rx_mode = rx_mode;
 }
 
-static void ionic_set_rx_mode(struct net_device *netdev, bool from_ndo)
+static void ionic_set_rx_mode(struct net_device *netdev, bool can_sleep)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
 	struct ionic_deferred_work *work;
@@ -1149,10 +1149,10 @@ static void ionic_set_rx_mode(struct net_device *netdev, bool from_ndo)
 	 *       we remove our overflow flag and check the netdev flags
 	 *       to see if we can disable NIC PROMISC
 	 */
-	if (from_ndo)
-		__dev_uc_sync(netdev, ionic_ndo_addr_add, ionic_ndo_addr_del);
-	else
+	if (can_sleep)
 		__dev_uc_sync(netdev, ionic_addr_add, ionic_addr_del);
+	else
+		__dev_uc_sync(netdev, ionic_ndo_addr_add, ionic_ndo_addr_del);
 	nfilters = le32_to_cpu(lif->identity->eth.max_ucast_filters);
 	if (netdev_uc_count(netdev) + 1 > nfilters) {
 		rx_mode |= IONIC_RX_MODE_F_PROMISC;
@@ -1164,10 +1164,10 @@ static void ionic_set_rx_mode(struct net_device *netdev, bool from_ndo)
 	}
 
 	/* same for multicast */
-	if (from_ndo)
-		__dev_mc_sync(netdev, ionic_ndo_addr_add, ionic_ndo_addr_del);
-	else
+	if (can_sleep)
 		__dev_mc_sync(netdev, ionic_addr_add, ionic_addr_del);
+	else
+		__dev_mc_sync(netdev, ionic_ndo_addr_add, ionic_ndo_addr_del);
 	nfilters = le32_to_cpu(lif->identity->eth.max_mcast_filters);
 	if (netdev_mc_count(netdev) > nfilters) {
 		rx_mode |= IONIC_RX_MODE_F_ALLMULTI;
@@ -1179,7 +1179,7 @@ static void ionic_set_rx_mode(struct net_device *netdev, bool from_ndo)
 	}
 
 	if (lif->rx_mode != rx_mode) {
-		if (from_ndo) {
+		if (!can_sleep) {
 			work = kzalloc(sizeof(*work), GFP_ATOMIC);
 			if (!work) {
 				netdev_err(lif->netdev, "%s OOM\n", __func__);
@@ -1197,7 +1197,7 @@ static void ionic_set_rx_mode(struct net_device *netdev, bool from_ndo)
 
 static void ionic_ndo_set_rx_mode(struct net_device *netdev)
 {
-	ionic_set_rx_mode(netdev, true);
+	ionic_set_rx_mode(netdev, false);
 }
 
 static __le64 ionic_netdev_features_to_nic(netdev_features_t features)
@@ -1764,7 +1764,7 @@ static int ionic_txrx_init(struct ionic_lif *lif)
 	if (lif->netdev->features & NETIF_F_RXHASH)
 		ionic_lif_rss_init(lif);
 
-	ionic_set_rx_mode(lif->netdev, false);
+	ionic_set_rx_mode(lif->netdev, true);
 
 	return 0;
 
-- 
2.27.0



