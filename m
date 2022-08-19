Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9D9059A0CB
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351677AbiHSQLv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352036AbiHSQLT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:11:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33C5113689;
        Fri, 19 Aug 2022 08:57:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4A1E61789;
        Fri, 19 Aug 2022 15:57:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB24CC43470;
        Fri, 19 Aug 2022 15:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924632;
        bh=mDrhfmzPS+9YHKE8YId8Y9KLz05kxtWRxYvu1OEe90Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C+F84ZbpwO/l2vwpCnoC0vcu/4ZCPqv7Kwkn/esU80DIUPrRjbpjNYzdNmoODvOc/
         DLBhSN/UWuBOelMsq3t0FxLlHl9H+rdZzetmvOvMBQFWLNsLqBj74Qr/B+Cns7upQL
         vheCEXgnOKszW1Vb0oGIOOUZnDgyW7DHA0BMbKhA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiao Ma <mqaio@linux.alibaba.com>,
        kernel test robot <lkp@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 215/545] net: hinic: fix bug that ethtool get wrong stats
Date:   Fri, 19 Aug 2022 17:39:45 +0200
Message-Id: <20220819153838.976295672@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiao Ma <mqaio@linux.alibaba.com>

[ Upstream commit 67dffd3db98570af8ff54c934f7d14664c0d182a ]

Function hinic_get_stats64() will do two operations:
1. reads stats from every hinic_rxq/txq and accumulates them
2. calls hinic_rxq/txq_clean_stats() to clean every rxq/txq's stats

For hinic_get_stats64(), it could get right data, because it sums all
data to nic_dev->rx_stats/tx_stats.
But it is wrong for get_drv_queue_stats(), this function will read
hinic_rxq's stats, which have been cleared to zero by hinic_get_stats64().

I have observed hinic's cleanup operation by using such command:
> watch -n 1 "cat ethtool -S eth4 | tail -40"

Result before:
     ...
     rxq7_pkts: 1
     rxq7_bytes: 90
     rxq7_errors: 0
     rxq7_csum_errors: 0
     rxq7_other_errors: 0
     ...
     rxq9_pkts: 11
     rxq9_bytes: 726
     rxq9_errors: 0
     rxq9_csum_errors: 0
     rxq9_other_errors: 0
     ...
     rxq11_pkts: 0
     rxq11_bytes: 0
     rxq11_errors: 0
     rxq11_csum_errors: 0
     rxq11_other_errors: 0

Result after a few seconds:
     ...
     rxq7_pkts: 0
     rxq7_bytes: 0
     rxq7_errors: 0
     rxq7_csum_errors: 0
     rxq7_other_errors: 0
     ...
     rxq9_pkts: 2
     rxq9_bytes: 132
     rxq9_errors: 0
     rxq9_csum_errors: 0
     rxq9_other_errors: 0
     ...
     rxq11_pkts: 1
     rxq11_bytes: 170
     rxq11_errors: 0
     rxq11_csum_errors: 0
     rxq11_other_errors: 0

To solve this problem, we just keep every queue's total stats in their own
queue (aka hinic_{rxq|txq}), and simply sum all per-queue stats every time
calling hinic_get_stats64().
With that solution, there is no need to clean per-queue stats now,
and there is no need to maintain global hinic_dev.{tx|rx}_stats, too.

Fixes: edd384f682cc ("net-next/hinic: Add ethtool and stats")
Signed-off-by: Qiao Ma <mqaio@linux.alibaba.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/huawei/hinic/hinic_dev.h |  3 -
 .../net/ethernet/huawei/hinic/hinic_main.c    | 57 ++++++-------------
 drivers/net/ethernet/huawei/hinic/hinic_rx.c  |  2 -
 drivers/net/ethernet/huawei/hinic/hinic_tx.c  |  2 -
 4 files changed, 16 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
index fb3e89141a0d..a4fbf44f944c 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
@@ -95,9 +95,6 @@ struct hinic_dev {
 	u16				sq_depth;
 	u16				rq_depth;
 
-	struct hinic_txq_stats          tx_stats;
-	struct hinic_rxq_stats          rx_stats;
-
 	u8				rss_tmpl_idx;
 	u8				rss_hash_engine;
 	u16				num_rss;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 2376edf6c263..5edc96b7cc8a 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -80,56 +80,44 @@ static int set_features(struct hinic_dev *nic_dev,
 			netdev_features_t pre_features,
 			netdev_features_t features, bool force_change);
 
-static void update_rx_stats(struct hinic_dev *nic_dev, struct hinic_rxq *rxq)
+static void gather_rx_stats(struct hinic_rxq_stats *nic_rx_stats, struct hinic_rxq *rxq)
 {
-	struct hinic_rxq_stats *nic_rx_stats = &nic_dev->rx_stats;
 	struct hinic_rxq_stats rx_stats;
 
-	u64_stats_init(&rx_stats.syncp);
-
 	hinic_rxq_get_stats(rxq, &rx_stats);
 
-	u64_stats_update_begin(&nic_rx_stats->syncp);
 	nic_rx_stats->bytes += rx_stats.bytes;
 	nic_rx_stats->pkts  += rx_stats.pkts;
 	nic_rx_stats->errors += rx_stats.errors;
 	nic_rx_stats->csum_errors += rx_stats.csum_errors;
 	nic_rx_stats->other_errors += rx_stats.other_errors;
-	u64_stats_update_end(&nic_rx_stats->syncp);
-
-	hinic_rxq_clean_stats(rxq);
 }
 
-static void update_tx_stats(struct hinic_dev *nic_dev, struct hinic_txq *txq)
+static void gather_tx_stats(struct hinic_txq_stats *nic_tx_stats, struct hinic_txq *txq)
 {
-	struct hinic_txq_stats *nic_tx_stats = &nic_dev->tx_stats;
 	struct hinic_txq_stats tx_stats;
 
-	u64_stats_init(&tx_stats.syncp);
-
 	hinic_txq_get_stats(txq, &tx_stats);
 
-	u64_stats_update_begin(&nic_tx_stats->syncp);
 	nic_tx_stats->bytes += tx_stats.bytes;
 	nic_tx_stats->pkts += tx_stats.pkts;
 	nic_tx_stats->tx_busy += tx_stats.tx_busy;
 	nic_tx_stats->tx_wake += tx_stats.tx_wake;
 	nic_tx_stats->tx_dropped += tx_stats.tx_dropped;
 	nic_tx_stats->big_frags_pkts += tx_stats.big_frags_pkts;
-	u64_stats_update_end(&nic_tx_stats->syncp);
-
-	hinic_txq_clean_stats(txq);
 }
 
-static void update_nic_stats(struct hinic_dev *nic_dev)
+static void gather_nic_stats(struct hinic_dev *nic_dev,
+			     struct hinic_rxq_stats *nic_rx_stats,
+			     struct hinic_txq_stats *nic_tx_stats)
 {
 	int i, num_qps = hinic_hwdev_num_qps(nic_dev->hwdev);
 
 	for (i = 0; i < num_qps; i++)
-		update_rx_stats(nic_dev, &nic_dev->rxqs[i]);
+		gather_rx_stats(nic_rx_stats, &nic_dev->rxqs[i]);
 
 	for (i = 0; i < num_qps; i++)
-		update_tx_stats(nic_dev, &nic_dev->txqs[i]);
+		gather_tx_stats(nic_tx_stats, &nic_dev->txqs[i]);
 }
 
 /**
@@ -565,8 +553,6 @@ int hinic_close(struct net_device *netdev)
 	netif_carrier_off(netdev);
 	netif_tx_disable(netdev);
 
-	update_nic_stats(nic_dev);
-
 	up(&nic_dev->mgmt_lock);
 
 	if (!HINIC_IS_VF(nic_dev->hwdev->hwif))
@@ -860,26 +846,23 @@ static void hinic_get_stats64(struct net_device *netdev,
 			      struct rtnl_link_stats64 *stats)
 {
 	struct hinic_dev *nic_dev = netdev_priv(netdev);
-	struct hinic_rxq_stats *nic_rx_stats;
-	struct hinic_txq_stats *nic_tx_stats;
-
-	nic_rx_stats = &nic_dev->rx_stats;
-	nic_tx_stats = &nic_dev->tx_stats;
+	struct hinic_rxq_stats nic_rx_stats = {};
+	struct hinic_txq_stats nic_tx_stats = {};
 
 	down(&nic_dev->mgmt_lock);
 
 	if (nic_dev->flags & HINIC_INTF_UP)
-		update_nic_stats(nic_dev);
+		gather_nic_stats(nic_dev, &nic_rx_stats, &nic_tx_stats);
 
 	up(&nic_dev->mgmt_lock);
 
-	stats->rx_bytes   = nic_rx_stats->bytes;
-	stats->rx_packets = nic_rx_stats->pkts;
-	stats->rx_errors  = nic_rx_stats->errors;
+	stats->rx_bytes   = nic_rx_stats.bytes;
+	stats->rx_packets = nic_rx_stats.pkts;
+	stats->rx_errors  = nic_rx_stats.errors;
 
-	stats->tx_bytes   = nic_tx_stats->bytes;
-	stats->tx_packets = nic_tx_stats->pkts;
-	stats->tx_errors  = nic_tx_stats->tx_dropped;
+	stats->tx_bytes   = nic_tx_stats.bytes;
+	stats->tx_packets = nic_tx_stats.pkts;
+	stats->tx_errors  = nic_tx_stats.tx_dropped;
 }
 
 static int hinic_set_features(struct net_device *netdev,
@@ -1178,8 +1161,6 @@ static void hinic_free_intr_coalesce(struct hinic_dev *nic_dev)
 static int nic_dev_init(struct pci_dev *pdev)
 {
 	struct hinic_rx_mode_work *rx_mode_work;
-	struct hinic_txq_stats *tx_stats;
-	struct hinic_rxq_stats *rx_stats;
 	struct hinic_dev *nic_dev;
 	struct net_device *netdev;
 	struct hinic_hwdev *hwdev;
@@ -1240,12 +1221,6 @@ static int nic_dev_init(struct pci_dev *pdev)
 
 	sema_init(&nic_dev->mgmt_lock, 1);
 
-	tx_stats = &nic_dev->tx_stats;
-	rx_stats = &nic_dev->rx_stats;
-
-	u64_stats_init(&tx_stats->syncp);
-	u64_stats_init(&rx_stats->syncp);
-
 	nic_dev->vlan_bitmap = devm_bitmap_zalloc(&pdev->dev, VLAN_N_VID,
 						  GFP_KERNEL);
 	if (!nic_dev->vlan_bitmap) {
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_rx.c b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
index 070a7cc6392e..04b19af63fd6 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_rx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
@@ -73,7 +73,6 @@ void hinic_rxq_get_stats(struct hinic_rxq *rxq, struct hinic_rxq_stats *stats)
 	struct hinic_rxq_stats *rxq_stats = &rxq->rxq_stats;
 	unsigned int start;
 
-	u64_stats_update_begin(&stats->syncp);
 	do {
 		start = u64_stats_fetch_begin(&rxq_stats->syncp);
 		stats->pkts = rxq_stats->pkts;
@@ -83,7 +82,6 @@ void hinic_rxq_get_stats(struct hinic_rxq *rxq, struct hinic_rxq_stats *stats)
 		stats->csum_errors = rxq_stats->csum_errors;
 		stats->other_errors = rxq_stats->other_errors;
 	} while (u64_stats_fetch_retry(&rxq_stats->syncp, start));
-	u64_stats_update_end(&stats->syncp);
 }
 
 /**
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_tx.c b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
index 3828b09bfea3..d13514a8160e 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
@@ -97,7 +97,6 @@ void hinic_txq_get_stats(struct hinic_txq *txq, struct hinic_txq_stats *stats)
 	struct hinic_txq_stats *txq_stats = &txq->txq_stats;
 	unsigned int start;
 
-	u64_stats_update_begin(&stats->syncp);
 	do {
 		start = u64_stats_fetch_begin(&txq_stats->syncp);
 		stats->pkts    = txq_stats->pkts;
@@ -107,7 +106,6 @@ void hinic_txq_get_stats(struct hinic_txq *txq, struct hinic_txq_stats *stats)
 		stats->tx_dropped = txq_stats->tx_dropped;
 		stats->big_frags_pkts = txq_stats->big_frags_pkts;
 	} while (u64_stats_fetch_retry(&txq_stats->syncp, start));
-	u64_stats_update_end(&stats->syncp);
 }
 
 /**
-- 
2.35.1



