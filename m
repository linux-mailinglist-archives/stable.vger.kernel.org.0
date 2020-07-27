Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A003622F01B
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731243AbgG0OVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:21:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731790AbgG0OVu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:21:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D7D62070A;
        Mon, 27 Jul 2020 14:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859709;
        bh=FI+sbogFNEeca7fXfLrP/eMnp5o9nNsu4aTIyS4qXTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pnoJqLOyAzRI9SNSZsQPgwEdczhB7ZMXhlnCEv+4w5bTZfXNl35m+YDXDrUZSwqiz
         wJC1lDL3tO1SVSgElAv3M6wrMpRfgpNmetNH93JNUYQtvApyogla8j/fIXsczCrsxJ
         GBPxRf5ka9tG6bAcFblzhqwptJX2fJfXdt71DtcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shannon Nelson <snelson@pensando.io>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 074/179] ionic: use mutex to protect queue operations
Date:   Mon, 27 Jul 2020 16:04:09 +0200
Message-Id: <20200727134936.285534494@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>

[ Upstream commit 0925e9db4dc86daf666d9a3d53c7db14ac6d5d00 ]

The ionic_wait_on_bit_lock() was a open-coded mutex knock-off
used only for protecting the queue reset operations, and there
was no reason not to use the real thing.  We can use the lock
more correctly and to better protect the queue stop and start
operations from cross threading.  We can also remove a useless
and expensive bit operation from the Rx path.

This fixes a case found where the link_status_check from a link
flap could run into an MTU change and cause a crash.

Fixes: beead698b173 ("ionic: Add the basic NDO callbacks for netdev support")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 28 +++++++++++--------
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  8 +-----
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  6 ----
 3 files changed, 17 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 08ab6dafc66c5..2c3e9ef22129c 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -85,8 +85,7 @@ static void ionic_link_status_check(struct ionic_lif *lif)
 	u16 link_status;
 	bool link_up;
 
-	if (!test_bit(IONIC_LIF_F_LINK_CHECK_REQUESTED, lif->state) ||
-	    test_bit(IONIC_LIF_F_QUEUE_RESET, lif->state))
+	if (!test_bit(IONIC_LIF_F_LINK_CHECK_REQUESTED, lif->state))
 		return;
 
 	if (lif->ionic->is_mgmt_nic)
@@ -106,16 +105,22 @@ static void ionic_link_status_check(struct ionic_lif *lif)
 			netif_carrier_on(netdev);
 		}
 
-		if (lif->netdev->flags & IFF_UP && netif_running(lif->netdev))
+		if (lif->netdev->flags & IFF_UP && netif_running(lif->netdev)) {
+			mutex_lock(&lif->queue_lock);
 			ionic_start_queues(lif);
+			mutex_unlock(&lif->queue_lock);
+		}
 	} else {
 		if (netif_carrier_ok(netdev)) {
 			netdev_info(netdev, "Link down\n");
 			netif_carrier_off(netdev);
 		}
 
-		if (lif->netdev->flags & IFF_UP && netif_running(lif->netdev))
+		if (lif->netdev->flags & IFF_UP && netif_running(lif->netdev)) {
+			mutex_lock(&lif->queue_lock);
 			ionic_stop_queues(lif);
+			mutex_unlock(&lif->queue_lock);
+		}
 	}
 
 	clear_bit(IONIC_LIF_F_LINK_CHECK_REQUESTED, lif->state);
@@ -1948,16 +1953,13 @@ int ionic_reset_queues(struct ionic_lif *lif, ionic_reset_cb cb, void *arg)
 	bool running;
 	int err = 0;
 
-	err = ionic_wait_for_bit(lif, IONIC_LIF_F_QUEUE_RESET);
-	if (err)
-		return err;
-
+	mutex_lock(&lif->queue_lock);
 	running = netif_running(lif->netdev);
 	if (running) {
 		netif_device_detach(lif->netdev);
 		err = ionic_stop(lif->netdev);
 		if (err)
-			goto reset_out;
+			return err;
 	}
 
 	if (cb)
@@ -1967,9 +1969,7 @@ int ionic_reset_queues(struct ionic_lif *lif, ionic_reset_cb cb, void *arg)
 		err = ionic_open(lif->netdev);
 		netif_device_attach(lif->netdev);
 	}
-
-reset_out:
-	clear_bit(IONIC_LIF_F_QUEUE_RESET, lif->state);
+	mutex_unlock(&lif->queue_lock);
 
 	return err;
 }
@@ -2108,7 +2108,9 @@ static void ionic_lif_handle_fw_down(struct ionic_lif *lif)
 
 	if (test_bit(IONIC_LIF_F_UP, lif->state)) {
 		dev_info(ionic->dev, "Surprise FW stop, stopping queues\n");
+		mutex_lock(&lif->queue_lock);
 		ionic_stop_queues(lif);
+		mutex_unlock(&lif->queue_lock);
 	}
 
 	if (netif_running(lif->netdev)) {
@@ -2235,6 +2237,7 @@ static void ionic_lif_deinit(struct ionic_lif *lif)
 	ionic_lif_qcq_deinit(lif, lif->notifyqcq);
 	ionic_lif_qcq_deinit(lif, lif->adminqcq);
 
+	mutex_destroy(&lif->queue_lock);
 	ionic_lif_reset(lif);
 }
 
@@ -2410,6 +2413,7 @@ static int ionic_lif_init(struct ionic_lif *lif)
 		return err;
 
 	lif->hw_index = le16_to_cpu(comp.hw_index);
+	mutex_init(&lif->queue_lock);
 
 	/* now that we have the hw_index we can figure out our doorbell page */
 	lif->dbid_count = le32_to_cpu(lif->ionic->ident.dev.ndbpgs_per_lif);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 2c65cf6300dbd..90992614f136e 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -126,7 +126,6 @@ enum ionic_lif_state_flags {
 	IONIC_LIF_F_SW_DEBUG_STATS,
 	IONIC_LIF_F_UP,
 	IONIC_LIF_F_LINK_CHECK_REQUESTED,
-	IONIC_LIF_F_QUEUE_RESET,
 	IONIC_LIF_F_FW_RESET,
 
 	/* leave this as last */
@@ -145,6 +144,7 @@ struct ionic_lif {
 	unsigned int hw_index;
 	unsigned int kern_pid;
 	u64 __iomem *kern_dbpage;
+	struct mutex queue_lock;	/* lock for queue structures */
 	spinlock_t adminq_lock;		/* lock for AdminQ operations */
 	struct ionic_qcq *adminqcq;
 	struct ionic_qcq *notifyqcq;
@@ -191,12 +191,6 @@ struct ionic_lif {
 #define lif_to_txq(lif, i)	(&lif_to_txqcq((lif), i)->q)
 #define lif_to_rxq(lif, i)	(&lif_to_txqcq((lif), i)->q)
 
-/* return 0 if successfully set the bit, else non-zero */
-static inline int ionic_wait_for_bit(struct ionic_lif *lif, int bitname)
-{
-	return wait_on_bit_lock(lif->state, bitname, TASK_INTERRUPTIBLE);
-}
-
 static inline u32 ionic_coal_usec_to_hw(struct ionic *ionic, u32 usecs)
 {
 	u32 mult = le32_to_cpu(ionic->ident.dev.intr_coal_mult);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index d233b6e77b1ee..ce8e246cda07d 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -157,12 +157,6 @@ static void ionic_rx_clean(struct ionic_queue *q, struct ionic_desc_info *desc_i
 		return;
 	}
 
-	/* no packet processing while resetting */
-	if (unlikely(test_bit(IONIC_LIF_F_QUEUE_RESET, q->lif->state))) {
-		stats->dropped++;
-		return;
-	}
-
 	stats->pkts++;
 	stats->bytes += le16_to_cpu(comp->len);
 
-- 
2.25.1



