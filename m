Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 825B6452675
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347773AbhKPCFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:05:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:48396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239678AbhKOSEe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:04:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EFB063356;
        Mon, 15 Nov 2021 17:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997896;
        bh=KgUQQKseX+NyJG7owAdKylMtj5uR/FlPIw2je2cXmus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sfzsTo/4v4vuKc7SxPU/KS0tzDpGe7T2CFBX5eA8ryEyHDLqsPSxUvIH2dEDvNN5L
         eJvR5KrcLmZgvsA/7a+tvrTWtPe2+0hxMYhaE1VbuRp+R5+Rk1Wt1QupBUhgzQBKgr
         OPLq2OrrQkcSMqaiGVTUIuae5RF6qVwxilHDy9bg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fraker <jfraker@google.com>,
        David Awogbemila <awogbemila@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 314/575] gve: Recover from queue stall due to missed IRQ
Date:   Mon, 15 Nov 2021 18:00:39 +0100
Message-Id: <20211115165354.652555834@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fraker <jfraker@google.com>

[ Upstream commit 87a7f321bb6a45e54b7d6c90d032ee5636a6ad97 ]

Don't always reset the driver on a TX timeout. Attempt to
recover by kicking the queue in case an IRQ was missed.

Fixes: 9e5f7d26a4c08 ("gve: Add workqueue and reset support")
Signed-off-by: John Fraker <jfraker@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve.h        |  4 +-
 drivers/net/ethernet/google/gve/gve_adminq.h |  1 +
 drivers/net/ethernet/google/gve/gve_main.c   | 48 +++++++++++++++++++-
 3 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index cfb174624d4ee..5c9a4d4362c7b 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -28,7 +28,7 @@
 #define GVE_MIN_MSIX 3
 
 /* Numbers of gve tx/rx stats in stats report. */
-#define GVE_TX_STATS_REPORT_NUM	5
+#define GVE_TX_STATS_REPORT_NUM	6
 #define GVE_RX_STATS_REPORT_NUM	2
 
 /* Interval to schedule a stats report update, 20000ms. */
@@ -147,7 +147,9 @@ struct gve_tx_ring {
 	u32 q_num ____cacheline_aligned; /* queue idx */
 	u32 stop_queue; /* count of queue stops */
 	u32 wake_queue; /* count of queue wakes */
+	u32 queue_timeout; /* count of queue timeouts */
 	u32 ntfy_id; /* notification block index */
+	u32 last_kick_msec; /* Last time the queue was kicked */
 	dma_addr_t bus; /* dma address of the descr ring */
 	dma_addr_t q_resources_bus; /* dma address of the queue resources */
 	struct u64_stats_sync statss; /* sync stats for 32bit archs */
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.h b/drivers/net/ethernet/google/gve/gve_adminq.h
index 015796a20118b..8dbc2c03fbbdd 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.h
+++ b/drivers/net/ethernet/google/gve/gve_adminq.h
@@ -212,6 +212,7 @@ enum gve_stat_names {
 	TX_LAST_COMPLETION_PROCESSED	= 5,
 	RX_NEXT_EXPECTED_SEQUENCE	= 6,
 	RX_BUFFERS_POSTED		= 7,
+	TX_TIMEOUT_CNT			= 8,
 	// stats from NIC
 	RX_QUEUE_DROP_CNT		= 65,
 	RX_NO_BUFFERS_POSTED		= 66,
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index fd52218f48846..3e96b2a11c5bf 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -23,6 +23,9 @@
 #define GVE_VERSION		"1.0.0"
 #define GVE_VERSION_PREFIX	"GVE-"
 
+// Minimum amount of time between queue kicks in msec (10 seconds)
+#define MIN_TX_TIMEOUT_GAP (1000 * 10)
+
 const char gve_version_str[] = GVE_VERSION;
 static const char gve_version_prefix[] = GVE_VERSION_PREFIX;
 
@@ -943,9 +946,47 @@ static void gve_turnup(struct gve_priv *priv)
 
 static void gve_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
-	struct gve_priv *priv = netdev_priv(dev);
+	struct gve_notify_block *block;
+	struct gve_tx_ring *tx = NULL;
+	struct gve_priv *priv;
+	u32 last_nic_done;
+	u32 current_time;
+	u32 ntfy_idx;
+
+	netdev_info(dev, "Timeout on tx queue, %d", txqueue);
+	priv = netdev_priv(dev);
+	if (txqueue > priv->tx_cfg.num_queues)
+		goto reset;
+
+	ntfy_idx = gve_tx_idx_to_ntfy(priv, txqueue);
+	if (ntfy_idx > priv->num_ntfy_blks)
+		goto reset;
+
+	block = &priv->ntfy_blocks[ntfy_idx];
+	tx = block->tx;
 
+	current_time = jiffies_to_msecs(jiffies);
+	if (tx->last_kick_msec + MIN_TX_TIMEOUT_GAP > current_time)
+		goto reset;
+
+	/* Check to see if there are missed completions, which will allow us to
+	 * kick the queue.
+	 */
+	last_nic_done = gve_tx_load_event_counter(priv, tx);
+	if (last_nic_done - tx->done) {
+		netdev_info(dev, "Kicking queue %d", txqueue);
+		iowrite32be(GVE_IRQ_MASK, gve_irq_doorbell(priv, block));
+		napi_schedule(&block->napi);
+		tx->last_kick_msec = current_time;
+		goto out;
+	} // Else reset.
+
+reset:
 	gve_schedule_reset(priv);
+
+out:
+	if (tx)
+		tx->queue_timeout++;
 	priv->tx_timeo_cnt++;
 }
 
@@ -1028,6 +1069,11 @@ void gve_handle_report_stats(struct gve_priv *priv)
 				.value = cpu_to_be64(priv->tx[idx].done),
 				.queue_id = cpu_to_be32(idx),
 			};
+			stats[stats_idx++] = (struct stats) {
+				.stat_name = cpu_to_be32(TX_TIMEOUT_CNT),
+				.value = cpu_to_be64(priv->tx[idx].queue_timeout),
+				.queue_id = cpu_to_be32(idx),
+			};
 		}
 	}
 	/* rx stats */
-- 
2.33.0



