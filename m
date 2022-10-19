Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7F5B603EFE
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233514AbiJSJ0C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233764AbiJSJYp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:24:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7441E09BE;
        Wed, 19 Oct 2022 02:11:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AFD961874;
        Wed, 19 Oct 2022 09:09:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E7AC433D6;
        Wed, 19 Oct 2022 09:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170542;
        bh=R9mXsIyShsVWJOH9MSgqLniCVDqACxw0AMWjzPQJhRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LxVmLgTiKxL7WZvXqywOMilAus+0/BX3YrPVrAwSVtKvqTRp5Yh7rEOLeHcU7gHYS
         H8YTkJpj4tqxuxgfdxQoLwFDlz/oxiUVqazfdQJ8sMwKgpGV7/HGXBlgNv0wcatAJB
         jK5EjaMWWtXzQaHxVeU9zDFpqyjPWs9JPZ3/O9/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 694/862] net: axienet: Switch to 64-bit RX/TX statistics
Date:   Wed, 19 Oct 2022 10:33:01 +0200
Message-Id: <20221019083320.639353868@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Hancock <robert.hancock@calian.com>

[ Upstream commit cb45a8bf4693965e89d115cd2c510f12bc127c37 ]

The RX and TX byte/packet statistics in this driver could be overflowed
relatively quickly on a 32-bit platform. Switch these stats to use the
u64_stats infrastructure to avoid this.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Link: https://lore.kernel.org/r/20220829233901.3429419-1-robert.hancock@calian.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h  | 12 ++++++
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 37 +++++++++++++++++--
 2 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index f2e2261b4b7d..8ff4333de2ad 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -402,6 +402,9 @@ struct axidma_bd {
  * @rx_bd_num:	Size of RX buffer descriptor ring
  * @rx_bd_ci:	Stores the index of the Rx buffer descriptor in the ring being
  *		accessed currently.
+ * @rx_packets: RX packet count for statistics
+ * @rx_bytes:	RX byte count for statistics
+ * @rx_stat_sync: Synchronization object for RX stats
  * @napi_tx:	NAPI TX control structure
  * @tx_dma_cr:  Nominal content of TX DMA control register
  * @tx_bd_v:	Virtual address of the TX buffer descriptor ring
@@ -411,6 +414,9 @@ struct axidma_bd {
  *		complete. Only updated at runtime by TX NAPI poll.
  * @tx_bd_tail:	Stores the index of the next Tx buffer descriptor in the ring
  *              to be populated.
+ * @tx_packets: TX packet count for statistics
+ * @tx_bytes:	TX byte count for statistics
+ * @tx_stat_sync: Synchronization object for TX stats
  * @dma_err_task: Work structure to process Axi DMA errors
  * @tx_irq:	Axidma TX IRQ number
  * @rx_irq:	Axidma RX IRQ number
@@ -458,6 +464,9 @@ struct axienet_local {
 	dma_addr_t rx_bd_p;
 	u32 rx_bd_num;
 	u32 rx_bd_ci;
+	u64_stats_t rx_packets;
+	u64_stats_t rx_bytes;
+	struct u64_stats_sync rx_stat_sync;
 
 	struct napi_struct napi_tx;
 	u32 tx_dma_cr;
@@ -466,6 +475,9 @@ struct axienet_local {
 	u32 tx_bd_num;
 	u32 tx_bd_ci;
 	u32 tx_bd_tail;
+	u64_stats_t tx_packets;
+	u64_stats_t tx_bytes;
+	struct u64_stats_sync tx_stat_sync;
 
 	struct work_struct dma_err_task;
 
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 1760930ec0c4..9262988d26a3 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -752,8 +752,10 @@ static int axienet_tx_poll(struct napi_struct *napi, int budget)
 		if (lp->tx_bd_ci >= lp->tx_bd_num)
 			lp->tx_bd_ci %= lp->tx_bd_num;
 
-		ndev->stats.tx_packets += packets;
-		ndev->stats.tx_bytes += size;
+		u64_stats_update_begin(&lp->tx_stat_sync);
+		u64_stats_add(&lp->tx_packets, packets);
+		u64_stats_add(&lp->tx_bytes, size);
+		u64_stats_update_end(&lp->tx_stat_sync);
 
 		/* Matches barrier in axienet_start_xmit */
 		smp_mb();
@@ -984,8 +986,10 @@ static int axienet_rx_poll(struct napi_struct *napi, int budget)
 		cur_p = &lp->rx_bd_v[lp->rx_bd_ci];
 	}
 
-	lp->ndev->stats.rx_packets += packets;
-	lp->ndev->stats.rx_bytes += size;
+	u64_stats_update_begin(&lp->rx_stat_sync);
+	u64_stats_add(&lp->rx_packets, packets);
+	u64_stats_add(&lp->rx_bytes, size);
+	u64_stats_update_end(&lp->rx_stat_sync);
 
 	if (tail_p)
 		axienet_dma_out_addr(lp, XAXIDMA_RX_TDESC_OFFSET, tail_p);
@@ -1292,10 +1296,32 @@ static int axienet_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	return phylink_mii_ioctl(lp->phylink, rq, cmd);
 }
 
+static void
+axienet_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
+{
+	struct axienet_local *lp = netdev_priv(dev);
+	unsigned int start;
+
+	netdev_stats_to_stats64(stats, &dev->stats);
+
+	do {
+		start = u64_stats_fetch_begin_irq(&lp->rx_stat_sync);
+		stats->rx_packets = u64_stats_read(&lp->rx_packets);
+		stats->rx_bytes = u64_stats_read(&lp->rx_bytes);
+	} while (u64_stats_fetch_retry_irq(&lp->rx_stat_sync, start));
+
+	do {
+		start = u64_stats_fetch_begin_irq(&lp->tx_stat_sync);
+		stats->tx_packets = u64_stats_read(&lp->tx_packets);
+		stats->tx_bytes = u64_stats_read(&lp->tx_bytes);
+	} while (u64_stats_fetch_retry_irq(&lp->tx_stat_sync, start));
+}
+
 static const struct net_device_ops axienet_netdev_ops = {
 	.ndo_open = axienet_open,
 	.ndo_stop = axienet_stop,
 	.ndo_start_xmit = axienet_start_xmit,
+	.ndo_get_stats64 = axienet_get_stats64,
 	.ndo_change_mtu	= axienet_change_mtu,
 	.ndo_set_mac_address = netdev_set_mac_address,
 	.ndo_validate_addr = eth_validate_addr,
@@ -1850,6 +1876,9 @@ static int axienet_probe(struct platform_device *pdev)
 	lp->rx_bd_num = RX_BD_NUM_DEFAULT;
 	lp->tx_bd_num = TX_BD_NUM_DEFAULT;
 
+	u64_stats_init(&lp->rx_stat_sync);
+	u64_stats_init(&lp->tx_stat_sync);
+
 	netif_napi_add(ndev, &lp->napi_rx, axienet_rx_poll, NAPI_POLL_WEIGHT);
 	netif_napi_add(ndev, &lp->napi_tx, axienet_tx_poll, NAPI_POLL_WEIGHT);
 
-- 
2.35.1



