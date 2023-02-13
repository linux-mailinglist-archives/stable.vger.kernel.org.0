Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1818D6948D8
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbjBMOxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:53:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbjBMOxv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:53:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 955F0975D
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:53:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B5B8B8125D
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:53:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4B1C4339C;
        Mon, 13 Feb 2023 14:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300015;
        bh=3lsRCz/IEbKn9KwjY1K48SwQbCvOFIJn5H+dV8Do0Sc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ntsq74UzJTWm1SM6lN946/P3DvsNcMgWb5OtGjxfFvYjW49JlcbOk/u94dTVrRHa+
         VpAYsliTfEFkwz4IN9x2jNbDXVwtegnWvs2op+tbsyHzb+Lu9FLoqmCHKALAfiTjc5
         Umv6w6qMVIFeOW5JZhN19ZeBO3Z3NJpbhXhLhNnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Allen Hubbe <allen.hubbe@amd.com>,
        Shannon Nelson <shannon.nelson@amd.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 031/114] ionic: missed doorbell workaround
Date:   Mon, 13 Feb 2023 15:47:46 +0100
Message-Id: <20230213144743.767070253@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Allen Hubbe <allen.hubbe@amd.com>

[ Upstream commit b69585bfceceeffda940906cabfdaee4b47bde92 ]

In one version of the HW there is a remote possibility that it
will miss the doorbell ring.  This adds a bit of protection to
be sure we don't stall a queue from a missed doorbell.

Fixes: 0f3154e6bcb3 ("ionic: Add Tx and Rx handling")
Signed-off-by: Allen Hubbe <allen.hubbe@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  9 +-
 .../net/ethernet/pensando/ionic/ionic_dev.h   | 12 +++
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 41 ++++++++-
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  2 +
 .../net/ethernet/pensando/ionic/ionic_main.c  | 29 +++++++
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 87 ++++++++++++++++++-
 6 files changed, 176 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 9d0514cfeb5c2..344a3924627d4 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -694,9 +694,16 @@ void ionic_q_post(struct ionic_queue *q, bool ring_doorbell, ionic_desc_cb cb,
 		q->lif->index, q->name, q->hw_type, q->hw_index,
 		q->head_idx, ring_doorbell);
 
-	if (ring_doorbell)
+	if (ring_doorbell) {
 		ionic_dbell_ring(lif->kern_dbpage, q->hw_type,
 				 q->dbval | q->head_idx);
+
+		q->dbell_jiffies = jiffies;
+
+		if (q_to_qcq(q)->napi_qcq)
+			mod_timer(&q_to_qcq(q)->napi_qcq->napi_deadline,
+				  jiffies + IONIC_NAPI_DEADLINE);
+	}
 }
 
 static bool ionic_q_is_posted(struct ionic_queue *q, unsigned int pos)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 563c302eb033d..ad8a2a4453b76 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -25,6 +25,12 @@
 #define IONIC_DEV_INFO_REG_COUNT	32
 #define IONIC_DEV_CMD_REG_COUNT		32
 
+#define IONIC_NAPI_DEADLINE		(HZ / 200)	/* 5ms */
+#define IONIC_ADMIN_DOORBELL_DEADLINE	(HZ / 2)	/* 500ms */
+#define IONIC_TX_DOORBELL_DEADLINE	(HZ / 100)	/* 10ms */
+#define IONIC_RX_MIN_DOORBELL_DEADLINE	(HZ / 100)	/* 10ms */
+#define IONIC_RX_MAX_DOORBELL_DEADLINE	(HZ * 5)	/* 5s */
+
 struct ionic_dev_bar {
 	void __iomem *vaddr;
 	phys_addr_t bus_addr;
@@ -214,6 +220,8 @@ struct ionic_queue {
 	struct ionic_lif *lif;
 	struct ionic_desc_info *info;
 	u64 dbval;
+	unsigned long dbell_deadline;
+	unsigned long dbell_jiffies;
 	u16 head_idx;
 	u16 tail_idx;
 	unsigned int index;
@@ -358,4 +366,8 @@ void ionic_q_service(struct ionic_queue *q, struct ionic_cq_info *cq_info,
 int ionic_heartbeat_check(struct ionic *ionic);
 bool ionic_is_fw_running(struct ionic_dev *idev);
 
+bool ionic_adminq_poke_doorbell(struct ionic_queue *q);
+bool ionic_txq_poke_doorbell(struct ionic_queue *q);
+bool ionic_rxq_poke_doorbell(struct ionic_queue *q);
+
 #endif /* _IONIC_DEV_H_ */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 147e23435c3d1..159bfcc76498c 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -16,6 +16,7 @@
 
 #include "ionic.h"
 #include "ionic_bus.h"
+#include "ionic_dev.h"
 #include "ionic_lif.h"
 #include "ionic_txrx.h"
 #include "ionic_ethtool.h"
@@ -200,6 +201,13 @@ void ionic_link_status_check_request(struct ionic_lif *lif, bool can_sleep)
 	}
 }
 
+static void ionic_napi_deadline(struct timer_list *timer)
+{
+	struct ionic_qcq *qcq = container_of(timer, struct ionic_qcq, napi_deadline);
+
+	napi_schedule(&qcq->napi);
+}
+
 static irqreturn_t ionic_isr(int irq, void *data)
 {
 	struct napi_struct *napi = data;
@@ -325,6 +333,7 @@ static int ionic_qcq_disable(struct ionic_lif *lif, struct ionic_qcq *qcq, int f
 		synchronize_irq(qcq->intr.vector);
 		irq_set_affinity_hint(qcq->intr.vector, NULL);
 		napi_disable(&qcq->napi);
+		del_timer_sync(&qcq->napi_deadline);
 	}
 
 	/* If there was a previous fw communcation error, don't bother with
@@ -460,6 +469,7 @@ static void ionic_link_qcq_interrupts(struct ionic_qcq *src_qcq,
 
 	n_qcq->intr.vector = src_qcq->intr.vector;
 	n_qcq->intr.index = src_qcq->intr.index;
+	n_qcq->napi_qcq = src_qcq->napi_qcq;
 }
 
 static int ionic_alloc_qcq_interrupt(struct ionic_lif *lif, struct ionic_qcq *qcq)
@@ -782,8 +792,14 @@ static int ionic_lif_txq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	dev_dbg(dev, "txq->hw_type %d\n", q->hw_type);
 	dev_dbg(dev, "txq->hw_index %d\n", q->hw_index);
 
-	if (test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state))
+	q->dbell_deadline = IONIC_TX_DOORBELL_DEADLINE;
+	q->dbell_jiffies = jiffies;
+
+	if (test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state)) {
 		netif_napi_add(lif->netdev, &qcq->napi, ionic_tx_napi);
+		qcq->napi_qcq = qcq;
+		timer_setup(&qcq->napi_deadline, ionic_napi_deadline, 0);
+	}
 
 	qcq->flags |= IONIC_QCQ_F_INITED;
 
@@ -837,11 +853,17 @@ static int ionic_lif_rxq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	dev_dbg(dev, "rxq->hw_type %d\n", q->hw_type);
 	dev_dbg(dev, "rxq->hw_index %d\n", q->hw_index);
 
+	q->dbell_deadline = IONIC_RX_MIN_DOORBELL_DEADLINE;
+	q->dbell_jiffies = jiffies;
+
 	if (test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state))
 		netif_napi_add(lif->netdev, &qcq->napi, ionic_rx_napi);
 	else
 		netif_napi_add(lif->netdev, &qcq->napi, ionic_txrx_napi);
 
+	qcq->napi_qcq = qcq;
+	timer_setup(&qcq->napi_deadline, ionic_napi_deadline, 0);
+
 	qcq->flags |= IONIC_QCQ_F_INITED;
 
 	return 0;
@@ -1159,6 +1181,7 @@ static int ionic_adminq_napi(struct napi_struct *napi, int budget)
 	struct ionic_dev *idev = &lif->ionic->idev;
 	unsigned long irqflags;
 	unsigned int flags = 0;
+	bool resched = false;
 	int rx_work = 0;
 	int tx_work = 0;
 	int n_work = 0;
@@ -1196,6 +1219,16 @@ static int ionic_adminq_napi(struct napi_struct *napi, int budget)
 		ionic_intr_credits(idev->intr_ctrl, intr->index, credits, flags);
 	}
 
+	if (!a_work && ionic_adminq_poke_doorbell(&lif->adminqcq->q))
+		resched = true;
+	if (lif->hwstamp_rxq && !rx_work && ionic_rxq_poke_doorbell(&lif->hwstamp_rxq->q))
+		resched = true;
+	if (lif->hwstamp_txq && !tx_work && ionic_txq_poke_doorbell(&lif->hwstamp_txq->q))
+		resched = true;
+	if (resched)
+		mod_timer(&lif->adminqcq->napi_deadline,
+			  jiffies + IONIC_NAPI_DEADLINE);
+
 	return work_done;
 }
 
@@ -3175,8 +3208,14 @@ static int ionic_lif_adminq_init(struct ionic_lif *lif)
 	dev_dbg(dev, "adminq->hw_type %d\n", q->hw_type);
 	dev_dbg(dev, "adminq->hw_index %d\n", q->hw_index);
 
+	q->dbell_deadline = IONIC_ADMIN_DOORBELL_DEADLINE;
+	q->dbell_jiffies = jiffies;
+
 	netif_napi_add(lif->netdev, &qcq->napi, ionic_adminq_napi);
 
+	qcq->napi_qcq = qcq;
+	timer_setup(&qcq->napi_deadline, ionic_napi_deadline, 0);
+
 	napi_enable(&qcq->napi);
 
 	if (qcq->flags & IONIC_QCQ_F_INTR)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index a53984bf35448..734519895614f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -74,8 +74,10 @@ struct ionic_qcq {
 	struct ionic_queue q;
 	struct ionic_cq cq;
 	struct ionic_intr_info intr;
+	struct timer_list napi_deadline;
 	struct napi_struct napi;
 	unsigned int flags;
+	struct ionic_qcq *napi_qcq;
 	struct dentry *dentry;
 };
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 5456c2b15d9bd..79272f5f380c6 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -289,6 +289,35 @@ static void ionic_adminq_cb(struct ionic_queue *q,
 	complete_all(&ctx->work);
 }
 
+bool ionic_adminq_poke_doorbell(struct ionic_queue *q)
+{
+	struct ionic_lif *lif = q->lif;
+	unsigned long now, then, dif;
+	unsigned long irqflags;
+
+	spin_lock_irqsave(&lif->adminq_lock, irqflags);
+
+	if (q->tail_idx == q->head_idx) {
+		spin_unlock_irqrestore(&lif->adminq_lock, irqflags);
+		return false;
+	}
+
+	now = READ_ONCE(jiffies);
+	then = q->dbell_jiffies;
+	dif = now - then;
+
+	if (dif > q->dbell_deadline) {
+		ionic_dbell_ring(q->lif->kern_dbpage, q->hw_type,
+				 q->dbval | q->head_idx);
+
+		q->dbell_jiffies = now;
+	}
+
+	spin_unlock_irqrestore(&lif->adminq_lock, irqflags);
+
+	return true;
+}
+
 int ionic_adminq_post(struct ionic_lif *lif, struct ionic_admin_ctx *ctx)
 {
 	struct ionic_desc_info *desc_info;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 7977de4d67b76..f8f5eb1307681 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -22,6 +22,67 @@ static inline void ionic_rxq_post(struct ionic_queue *q, bool ring_dbell,
 	ionic_q_post(q, ring_dbell, cb_func, cb_arg);
 }
 
+bool ionic_txq_poke_doorbell(struct ionic_queue *q)
+{
+	unsigned long now, then, dif;
+	struct netdev_queue *netdev_txq;
+	struct net_device *netdev;
+
+	netdev = q->lif->netdev;
+	netdev_txq = netdev_get_tx_queue(netdev, q->index);
+
+	HARD_TX_LOCK(netdev, netdev_txq, smp_processor_id());
+
+	if (q->tail_idx == q->head_idx) {
+		HARD_TX_UNLOCK(netdev, netdev_txq);
+		return false;
+	}
+
+	now = READ_ONCE(jiffies);
+	then = q->dbell_jiffies;
+	dif = now - then;
+
+	if (dif > q->dbell_deadline) {
+		ionic_dbell_ring(q->lif->kern_dbpage, q->hw_type,
+				 q->dbval | q->head_idx);
+
+		q->dbell_jiffies = now;
+	}
+
+	HARD_TX_UNLOCK(netdev, netdev_txq);
+
+	return true;
+}
+
+bool ionic_rxq_poke_doorbell(struct ionic_queue *q)
+{
+	unsigned long now, then, dif;
+
+	/* no lock, called from rx napi or txrx napi, nothing else can fill */
+
+	if (q->tail_idx == q->head_idx)
+		return false;
+
+	now = READ_ONCE(jiffies);
+	then = q->dbell_jiffies;
+	dif = now - then;
+
+	if (dif > q->dbell_deadline) {
+		ionic_dbell_ring(q->lif->kern_dbpage, q->hw_type,
+				 q->dbval | q->head_idx);
+
+		q->dbell_jiffies = now;
+
+		dif = 2 * q->dbell_deadline;
+		if (dif > IONIC_RX_MAX_DOORBELL_DEADLINE)
+			dif = IONIC_RX_MAX_DOORBELL_DEADLINE;
+
+		q->dbell_deadline = dif;
+	}
+
+	return true;
+}
+
 static inline struct netdev_queue *q_to_ndq(struct ionic_queue *q)
 {
 	return netdev_get_tx_queue(q->lif->netdev, q->index);
@@ -424,6 +485,12 @@ void ionic_rx_fill(struct ionic_queue *q)
 
 	ionic_dbell_ring(q->lif->kern_dbpage, q->hw_type,
 			 q->dbval | q->head_idx);
+
+	q->dbell_deadline = IONIC_RX_MIN_DOORBELL_DEADLINE;
+	q->dbell_jiffies = jiffies;
+
+	mod_timer(&q_to_qcq(q)->napi_qcq->napi_deadline,
+		  jiffies + IONIC_NAPI_DEADLINE);
 }
 
 void ionic_rx_empty(struct ionic_queue *q)
@@ -511,6 +578,9 @@ int ionic_tx_napi(struct napi_struct *napi, int budget)
 				   work_done, flags);
 	}
 
+	if (!work_done && ionic_txq_poke_doorbell(&qcq->q))
+		mod_timer(&qcq->napi_deadline, jiffies + IONIC_NAPI_DEADLINE);
+
 	return work_done;
 }
 
@@ -544,23 +614,29 @@ int ionic_rx_napi(struct napi_struct *napi, int budget)
 				   work_done, flags);
 	}
 
+	if (!work_done && ionic_rxq_poke_doorbell(&qcq->q))
+		mod_timer(&qcq->napi_deadline, jiffies + IONIC_NAPI_DEADLINE);
+
 	return work_done;
 }
 
 int ionic_txrx_napi(struct napi_struct *napi, int budget)
 {
-	struct ionic_qcq *qcq = napi_to_qcq(napi);
+	struct ionic_qcq *rxqcq = napi_to_qcq(napi);
 	struct ionic_cq *rxcq = napi_to_cq(napi);
 	unsigned int qi = rxcq->bound_q->index;
+	struct ionic_qcq *txqcq;
 	struct ionic_dev *idev;
 	struct ionic_lif *lif;
 	struct ionic_cq *txcq;
+	bool resched = false;
 	u32 rx_work_done = 0;
 	u32 tx_work_done = 0;
 	u32 flags = 0;
 
 	lif = rxcq->bound_q->lif;
 	idev = &lif->ionic->idev;
+	txqcq = lif->txqcqs[qi];
 	txcq = &lif->txqcqs[qi]->cq;
 
 	tx_work_done = ionic_cq_service(txcq, IONIC_TX_BUDGET_DEFAULT,
@@ -572,7 +648,7 @@ int ionic_txrx_napi(struct napi_struct *napi, int budget)
 	ionic_rx_fill(rxcq->bound_q);
 
 	if (rx_work_done < budget && napi_complete_done(napi, rx_work_done)) {
-		ionic_dim_update(qcq, 0);
+		ionic_dim_update(rxqcq, 0);
 		flags |= IONIC_INTR_CRED_UNMASK;
 		rxcq->bound_intr->rearm_count++;
 	}
@@ -583,6 +659,13 @@ int ionic_txrx_napi(struct napi_struct *napi, int budget)
 				   tx_work_done + rx_work_done, flags);
 	}
 
+	if (!rx_work_done && ionic_rxq_poke_doorbell(&rxqcq->q))
+		resched = true;
+	if (!tx_work_done && ionic_txq_poke_doorbell(&txqcq->q))
+		resched = true;
+	if (resched)
+		mod_timer(&rxqcq->napi_deadline, jiffies + IONIC_NAPI_DEADLINE);
+
 	return rx_work_done;
 }
 
-- 
2.39.0



