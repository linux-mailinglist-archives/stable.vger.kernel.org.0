Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7654B157698
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730098AbgBJMlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:41:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:45252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729281AbgBJMlz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:55 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E024221569;
        Mon, 10 Feb 2020 12:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338515;
        bh=mOSzqxDz+tG+hYHXsNf0YALzMyOPfatCMyLsctEUt80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gmtrZixK32jt4fkx0qZ/mvlz0HNPVVagnRkEqfTT3TkWmVTsO4SBelViFjiCiETZB
         i3Y4mUrIe/QbsYHoN4e95WEUtKAz/HabVij6end6LycE3CNMqA5I05ehwtOKqe3110
         Ny2vinWJQwtvB2VbiK6rovWKwcTexb4cpGs8ykjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 322/367] net: mvneta: move rx_dropped and rx_errors in per-cpu stats
Date:   Mon, 10 Feb 2020 04:33:55 -0800
Message-Id: <20200210122452.741813885@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit c35947b8ff8acca33134ee39c31708233765c31a ]

Move rx_dropped and rx_errors counters in mvneta_pcpu_stats in order to
avoid possible races updating statistics

Fixes: 562e2f467e71 ("net: mvneta: Improve the buffer allocation method for SWBM")
Fixes: dc35a10f68d3 ("net: mvneta: bm: add support for hardware buffer management")
Fixes: c5aff18204da ("net: mvneta: driver for Marvell Armada 370/XP network unit")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mvneta.c |   31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -401,6 +401,8 @@ struct mvneta_pcpu_stats {
 	struct	u64_stats_sync syncp;
 	u64	rx_packets;
 	u64	rx_bytes;
+	u64	rx_dropped;
+	u64	rx_errors;
 	u64	tx_packets;
 	u64	tx_bytes;
 };
@@ -738,6 +740,8 @@ mvneta_get_stats64(struct net_device *de
 		struct mvneta_pcpu_stats *cpu_stats;
 		u64 rx_packets;
 		u64 rx_bytes;
+		u64 rx_dropped;
+		u64 rx_errors;
 		u64 tx_packets;
 		u64 tx_bytes;
 
@@ -746,19 +750,20 @@ mvneta_get_stats64(struct net_device *de
 			start = u64_stats_fetch_begin_irq(&cpu_stats->syncp);
 			rx_packets = cpu_stats->rx_packets;
 			rx_bytes   = cpu_stats->rx_bytes;
+			rx_dropped = cpu_stats->rx_dropped;
+			rx_errors  = cpu_stats->rx_errors;
 			tx_packets = cpu_stats->tx_packets;
 			tx_bytes   = cpu_stats->tx_bytes;
 		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
 
 		stats->rx_packets += rx_packets;
 		stats->rx_bytes   += rx_bytes;
+		stats->rx_dropped += rx_dropped;
+		stats->rx_errors  += rx_errors;
 		stats->tx_packets += tx_packets;
 		stats->tx_bytes   += tx_bytes;
 	}
 
-	stats->rx_errors	= dev->stats.rx_errors;
-	stats->rx_dropped	= dev->stats.rx_dropped;
-
 	stats->tx_dropped	= dev->stats.tx_dropped;
 }
 
@@ -1736,8 +1741,14 @@ static u32 mvneta_txq_desc_csum(int l3_o
 static void mvneta_rx_error(struct mvneta_port *pp,
 			    struct mvneta_rx_desc *rx_desc)
 {
+	struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
 	u32 status = rx_desc->status;
 
+	/* update per-cpu counter */
+	u64_stats_update_begin(&stats->syncp);
+	stats->rx_errors++;
+	u64_stats_update_end(&stats->syncp);
+
 	switch (status & MVNETA_RXD_ERR_CODE_MASK) {
 	case MVNETA_RXD_ERR_CRC:
 		netdev_err(pp->dev, "bad rx status %08x (crc error), size=%d\n",
@@ -2179,11 +2190,15 @@ mvneta_swbm_rx_frame(struct mvneta_port
 
 	rxq->skb = build_skb(xdp->data_hard_start, PAGE_SIZE);
 	if (unlikely(!rxq->skb)) {
-		netdev_err(dev,
-			   "Can't allocate skb on queue %d\n",
-			   rxq->id);
-		dev->stats.rx_dropped++;
+		struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
+
+		netdev_err(dev, "Can't allocate skb on queue %d\n", rxq->id);
 		rxq->skb_alloc_err++;
+
+		u64_stats_update_begin(&stats->syncp);
+		stats->rx_dropped++;
+		u64_stats_update_end(&stats->syncp);
+
 		return -ENOMEM;
 	}
 	page_pool_release_page(rxq->page_pool, page);
@@ -2270,7 +2285,6 @@ static int mvneta_rx_swbm(struct napi_st
 			/* Check errors only for FIRST descriptor */
 			if (rx_status & MVNETA_RXD_ERR_SUMMARY) {
 				mvneta_rx_error(pp, rx_desc);
-				dev->stats.rx_errors++;
 				/* leave the descriptor untouched */
 				continue;
 			}
@@ -2372,7 +2386,6 @@ err_drop_frame_ret_pool:
 			mvneta_bm_pool_put_bp(pp->bm_priv, bm_pool,
 					      rx_desc->buf_phys_addr);
 err_drop_frame:
-			dev->stats.rx_errors++;
 			mvneta_rx_error(pp, rx_desc);
 			/* leave the descriptor untouched */
 			continue;


