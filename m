Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852AB2E3CCD
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438301AbgL1OHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:07:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:40940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438004AbgL1OGW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:06:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4F6A206D4;
        Mon, 28 Dec 2020 14:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164342;
        bh=Q1udS4u73Fkk3mqa+I7gbDChOJIpcdjSf9iZ4Cb/ae4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fiFdlx8vNX4R1dznE6YA30WTChUNflqeNuLbzJrwYkEy6r59DCsmT4kkiQ7uP1TH0
         7EMNt60RVH0MLUrfIXwS0rWdo228RCjdg7zaNaYxpPJ8H56cV8NYF5L2klrBp/Nmd/
         Y4J0k+PYGUOvokuf55Yn+QMDyuCLKtEys6SydGgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shannon Nelson <snelson@pensando.io>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 115/717] ionic: use mc sync for multicast filters
Date:   Mon, 28 Dec 2020 13:41:53 +0100
Message-Id: <20201228125026.472180288@linuxfoundation.org>
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

[ Upstream commit e0243e1966592859da4c6ffe6d43e1576ec3c457 ]

We should be using the multicast sync routines for the multicast
filters.  Also, let's just flatten the logic a bit and pull
the small unicast routine back into ionic_set_rx_mode().

Fixes: 1800eee16676 ("net: ionic: Replace in_interrupt() usage.")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index a12df3946a07c..724df18400165 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1149,15 +1149,6 @@ static void _ionic_lif_rx_mode(struct ionic_lif *lif, unsigned int rx_mode,
 	}
 }
 
-static void ionic_dev_uc_sync(struct net_device *netdev, bool from_ndo)
-{
-	if (from_ndo)
-		__dev_uc_sync(netdev, ionic_ndo_addr_add, ionic_ndo_addr_del);
-	else
-		__dev_uc_sync(netdev, ionic_addr_add, ionic_addr_del);
-
-}
-
 static void ionic_set_rx_mode(struct net_device *netdev, bool from_ndo)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
@@ -1177,7 +1168,10 @@ static void ionic_set_rx_mode(struct net_device *netdev, bool from_ndo)
 	 *       we remove our overflow flag and check the netdev flags
 	 *       to see if we can disable NIC PROMISC
 	 */
-	ionic_dev_uc_sync(netdev, from_ndo);
+	if (from_ndo)
+		__dev_uc_sync(netdev, ionic_ndo_addr_add, ionic_ndo_addr_del);
+	else
+		__dev_uc_sync(netdev, ionic_addr_add, ionic_addr_del);
 	nfilters = le32_to_cpu(lif->identity->eth.max_ucast_filters);
 	if (netdev_uc_count(netdev) + 1 > nfilters) {
 		rx_mode |= IONIC_RX_MODE_F_PROMISC;
@@ -1189,7 +1183,10 @@ static void ionic_set_rx_mode(struct net_device *netdev, bool from_ndo)
 	}
 
 	/* same for multicast */
-	ionic_dev_uc_sync(netdev, from_ndo);
+	if (from_ndo)
+		__dev_mc_sync(netdev, ionic_ndo_addr_add, ionic_ndo_addr_del);
+	else
+		__dev_mc_sync(netdev, ionic_addr_add, ionic_addr_del);
 	nfilters = le32_to_cpu(lif->identity->eth.max_mcast_filters);
 	if (netdev_mc_count(netdev) > nfilters) {
 		rx_mode |= IONIC_RX_MODE_F_ALLMULTI;
-- 
2.27.0



