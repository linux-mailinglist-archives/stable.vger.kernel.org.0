Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8869121FBB4
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729678AbgGNTDx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 15:03:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:54948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731029AbgGNS4t (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:56:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7884A22B45;
        Tue, 14 Jul 2020 18:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753009;
        bh=G30PLW8QpaaKptZT/j4meATNrNnYomK/4sx27ePFTe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZNKkaaef6hHARTKLd/YBbOqmZjHJSCKsONb/E5Pja24blbTw3d+Q70iUezrvU9KE+
         CgjF8aDIJl2pzXmp3TpvK3YnZqrA3lI341kRNGIM59gu08h81KMsUAlcuHT+SsAwQV
         Ie+hKLT8YlHRMPBzbIY73qfEDYYdGYz5J1ZSeLYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shannon Nelson <snelson@pensando.io>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 084/166] ionic: centralize queue reset code
Date:   Tue, 14 Jul 2020 20:44:09 +0200
Message-Id: <20200714184119.874151844@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>

[ Upstream commit 086c18f2452d0028f81e319f098bcb8e53133dbf ]

The queue reset pattern is used in a couple different places,
only slightly different from each other, and could cause
issues if one gets changed and the other didn't.  This puts
them together so that only one version is needed, yet each
can have slighty different effects by passing in a pointer
to a work function to do whatever configuration twiddling is
needed in the middle of the reset.

This specifically addresses issues seen where under loops
of changing ring size or queue count parameters we could
occasionally bump into the netdev watchdog.

v2: added more commit message commentary

Fixes: 4d03e00a2140 ("ionic: Add initial ethtool support")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/pensando/ionic/ionic_ethtool.c   | 52 ++++++-------------
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 17 ++++--
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  4 +-
 3 files changed, 32 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 6996229facfd4..22430fa911e2c 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -464,12 +464,18 @@ static void ionic_get_ringparam(struct net_device *netdev,
 	ring->rx_pending = lif->nrxq_descs;
 }
 
+static void ionic_set_ringsize(struct ionic_lif *lif, void *arg)
+{
+	struct ethtool_ringparam *ring = arg;
+
+	lif->ntxq_descs = ring->tx_pending;
+	lif->nrxq_descs = ring->rx_pending;
+}
+
 static int ionic_set_ringparam(struct net_device *netdev,
 			       struct ethtool_ringparam *ring)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
-	bool running;
-	int err;
 
 	if (ring->rx_mini_pending || ring->rx_jumbo_pending) {
 		netdev_info(netdev, "Changing jumbo or mini descriptors not supported\n");
@@ -487,22 +493,7 @@ static int ionic_set_ringparam(struct net_device *netdev,
 	    ring->rx_pending == lif->nrxq_descs)
 		return 0;
 
-	err = ionic_wait_for_bit(lif, IONIC_LIF_F_QUEUE_RESET);
-	if (err)
-		return err;
-
-	running = test_bit(IONIC_LIF_F_UP, lif->state);
-	if (running)
-		ionic_stop(netdev);
-
-	lif->ntxq_descs = ring->tx_pending;
-	lif->nrxq_descs = ring->rx_pending;
-
-	if (running)
-		ionic_open(netdev);
-	clear_bit(IONIC_LIF_F_QUEUE_RESET, lif->state);
-
-	return 0;
+	return ionic_reset_queues(lif, ionic_set_ringsize, ring);
 }
 
 static void ionic_get_channels(struct net_device *netdev,
@@ -517,12 +508,17 @@ static void ionic_get_channels(struct net_device *netdev,
 	ch->combined_count = lif->nxqs;
 }
 
+static void ionic_set_queuecount(struct ionic_lif *lif, void *arg)
+{
+	struct ethtool_channels *ch = arg;
+
+	lif->nxqs = ch->combined_count;
+}
+
 static int ionic_set_channels(struct net_device *netdev,
 			      struct ethtool_channels *ch)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
-	bool running;
-	int err;
 
 	if (!ch->combined_count || ch->other_count ||
 	    ch->rx_count || ch->tx_count)
@@ -531,21 +527,7 @@ static int ionic_set_channels(struct net_device *netdev,
 	if (ch->combined_count == lif->nxqs)
 		return 0;
 
-	err = ionic_wait_for_bit(lif, IONIC_LIF_F_QUEUE_RESET);
-	if (err)
-		return err;
-
-	running = test_bit(IONIC_LIF_F_UP, lif->state);
-	if (running)
-		ionic_stop(netdev);
-
-	lif->nxqs = ch->combined_count;
-
-	if (running)
-		ionic_open(netdev);
-	clear_bit(IONIC_LIF_F_QUEUE_RESET, lif->state);
-
-	return 0;
+	return ionic_reset_queues(lif, ionic_set_queuecount, ch);
 }
 
 static u32 ionic_get_priv_flags(struct net_device *netdev)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 790d4854b8ef5..b591bec0301cc 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1301,7 +1301,7 @@ static int ionic_change_mtu(struct net_device *netdev, int new_mtu)
 		return err;
 
 	netdev->mtu = new_mtu;
-	err = ionic_reset_queues(lif);
+	err = ionic_reset_queues(lif, NULL, NULL);
 
 	return err;
 }
@@ -1313,7 +1313,7 @@ static void ionic_tx_timeout_work(struct work_struct *ws)
 	netdev_info(lif->netdev, "Tx Timeout recovery\n");
 
 	rtnl_lock();
-	ionic_reset_queues(lif);
+	ionic_reset_queues(lif, NULL, NULL);
 	rtnl_unlock();
 }
 
@@ -1944,7 +1944,7 @@ static const struct net_device_ops ionic_netdev_ops = {
 	.ndo_get_vf_stats       = ionic_get_vf_stats,
 };
 
-int ionic_reset_queues(struct ionic_lif *lif)
+int ionic_reset_queues(struct ionic_lif *lif, ionic_reset_cb cb, void *arg)
 {
 	bool running;
 	int err = 0;
@@ -1957,12 +1957,19 @@ int ionic_reset_queues(struct ionic_lif *lif)
 	if (running) {
 		netif_device_detach(lif->netdev);
 		err = ionic_stop(lif->netdev);
+		if (err)
+			goto reset_out;
 	}
-	if (!err && running) {
-		ionic_open(lif->netdev);
+
+	if (cb)
+		cb(lif, arg);
+
+	if (running) {
+		err = ionic_open(lif->netdev);
 		netif_device_attach(lif->netdev);
 	}
 
+reset_out:
 	clear_bit(IONIC_LIF_F_QUEUE_RESET, lif->state);
 
 	return err;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 5d4ffda5c05f2..2c65cf6300dbd 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -226,6 +226,8 @@ static inline u32 ionic_coal_hw_to_usec(struct ionic *ionic, u32 units)
 	return (units * div) / mult;
 }
 
+typedef void (*ionic_reset_cb)(struct ionic_lif *lif, void *arg);
+
 void ionic_link_status_check_request(struct ionic_lif *lif);
 void ionic_lif_deferred_enqueue(struct ionic_deferred *def,
 				struct ionic_deferred_work *work);
@@ -243,7 +245,7 @@ int ionic_lif_rss_config(struct ionic_lif *lif, u16 types,
 
 int ionic_open(struct net_device *netdev);
 int ionic_stop(struct net_device *netdev);
-int ionic_reset_queues(struct ionic_lif *lif);
+int ionic_reset_queues(struct ionic_lif *lif, ionic_reset_cb cb, void *arg);
 
 static inline void debug_stats_txq_post(struct ionic_qcq *qcq,
 					struct ionic_txq_desc *desc, bool dbell)
-- 
2.25.1



