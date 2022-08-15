Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4A6B59415D
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243762AbiHOVJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347758AbiHOVH2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:07:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C001A3A9;
        Mon, 15 Aug 2022 12:15:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F01BB810A3;
        Mon, 15 Aug 2022 19:15:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65465C433D6;
        Mon, 15 Aug 2022 19:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590936;
        bh=BRREgrfvO9W2sHR0exN5v9EzUf1Wi7h066+OAMDloMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qTCa7R7aCzL+tUDvWXB+/nKRidRq24oK8KDK97KxLkXUGtS10EQRoZn+/ctGEmvVc
         ddw2PDWrx2ODJebHsWI7fSesbHoTNiS0VfEil6/pTFEzwHVY1rQa/4QI+KvsCjpRRz
         RhOmT5f5XSZwyjmb0j9oFP1dfYeLJcKQQzyNAFuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiao Ma <mqaio@linux.alibaba.com>,
        kernel test robot <lkp@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0418/1095] net: hinic: fix bug that ethtool get wrong stats
Date:   Mon, 15 Aug 2022 19:56:57 +0200
Message-Id: <20220815180447.001728933@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index 56a89793f47d..89dc52510fdc 100644
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
@@ -558,8 +546,6 @@ int hinic_close(struct net_device *netdev)
 	netif_carrier_off(netdev);
 	netif_tx_disable(netdev);
 
-	update_nic_stats(nic_dev);
-
 	up(&nic_dev->mgmt_lock);
 
 	if (!HINIC_IS_VF(nic_dev->hwdev->hwif))
@@ -853,26 +839,23 @@ static void hinic_get_stats64(struct net_device *netdev,
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
@@ -1171,8 +1154,6 @@ static void hinic_free_intr_coalesce(struct hinic_dev *nic_dev)
 static int nic_dev_init(struct pci_dev *pdev)
 {
 	struct hinic_rx_mode_work *rx_mode_work;
-	struct hinic_txq_stats *tx_stats;
-	struct hinic_rxq_stats *rx_stats;
 	struct hinic_dev *nic_dev;
 	struct net_device *netdev;
 	struct hinic_hwdev *hwdev;
@@ -1234,12 +1215,6 @@ static int nic_dev_init(struct pci_dev *pdev)
 
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
index b33ed4d92b71..b6bce622a6a8 100644
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
index 8d59babbf476..082eb2a5088d 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
@@ -98,7 +98,6 @@ void hinic_txq_get_stats(struct hinic_txq *txq, struct hinic_txq_stats *stats)
 	struct hinic_txq_stats *txq_stats = &txq->txq_stats;
 	unsigned int start;
 
-	u64_stats_update_begin(&stats->syncp);
 	do {
 		start = u64_stats_fetch_begin(&txq_stats->syncp);
 		stats->pkts    = txq_stats->pkts;
@@ -108,7 +107,6 @@ void hinic_txq_get_stats(struct hinic_txq *txq, struct hinic_txq_stats *stats)
 		stats->tx_dropped = txq_stats->tx_dropped;
 		stats->big_frags_pkts = txq_stats->big_frags_pkts;
 	} while (u64_stats_fetch_retry(&txq_stats->syncp, start));
-	u64_stats_update_end(&stats->syncp);
 }
 
 /**
-- 
2.35.1



