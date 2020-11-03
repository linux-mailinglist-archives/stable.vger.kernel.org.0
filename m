Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA412A4842
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 15:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbgKCOfx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 09:35:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:47284 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728199AbgKCOfd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 09:35:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604414129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LxbAfCJEI3uTWLzbBAtEO6QWYOJCDsfJ30Ersr2IcUk=;
        b=L5mPlAil1AaLC/vAIRBnTZiOP6zRZkjBuM2eRQ9zIsMU8rwnKS6O6+8Mc0YEZ+TtDJAKPE
        X+UG/IEuiRSJYrGGw6Y84znThus2W7RVe6Z3Dvml6Jni2us5sz8tQOR0ZeHklrB6mi4Byu
        Ry/yJuzVQ8sCUhgx6CrPpEcg6pR3cFY=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6D88CB2A8
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 14:35:29 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     stable@vger.kernel.org
Subject: [PATCH v2 07/13] xen/netback: use lateeoi irq binding
Date:   Tue,  3 Nov 2020 15:35:22 +0100
Message-Id: <20201103143528.22780-8-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103143528.22780-1-jgross@suse.com>
References: <20201103143528.22780-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In order to reduce the chance for the system becoming unresponsive due
to event storms triggered by a misbehaving netfront use the lateeoi
irq binding for netback and unmask the event channel only just before
going to sleep waiting for new events.

Make sure not to issue an EOI when none is pending by introducing an
eoi_pending element to struct xenvif_queue.

When no request has been consumed set the spurious flag when sending
the EOI for an interrupt.

This is part of XSA-332.

This is upstream commit 23025393dbeb3b8b3b60ebfa724cdae384992e27

Cc: stable@vger.kernel.org
Reported-by: Julien Grall <julien@xen.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Wei Liu <wl@xen.org>
---
 drivers/net/xen-netback/common.h    | 15 +++++++
 drivers/net/xen-netback/interface.c | 61 ++++++++++++++++++++++++-----
 drivers/net/xen-netback/netback.c   | 11 +++++-
 drivers/net/xen-netback/rx.c        | 13 ++++--
 4 files changed, 86 insertions(+), 14 deletions(-)

diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
index 5b1d2e8402d9..347c796afd4e 100644
--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -140,6 +140,20 @@ struct xenvif_queue { /* Per-queue data for xenvif */
 	char name[QUEUE_NAME_SIZE]; /* DEVNAME-qN */
 	struct xenvif *vif; /* Parent VIF */
 
+	/*
+	 * TX/RX common EOI handling.
+	 * When feature-split-event-channels = 0, interrupt handler sets
+	 * NETBK_COMMON_EOI, otherwise NETBK_RX_EOI and NETBK_TX_EOI are set
+	 * by the RX and TX interrupt handlers.
+	 * RX and TX handler threads will issue an EOI when either
+	 * NETBK_COMMON_EOI or their specific bits (NETBK_RX_EOI or
+	 * NETBK_TX_EOI) are set and they will reset those bits.
+	 */
+	atomic_t eoi_pending;
+#define NETBK_RX_EOI		0x01
+#define NETBK_TX_EOI		0x02
+#define NETBK_COMMON_EOI	0x04
+
 	/* Use NAPI for guest TX */
 	struct napi_struct napi;
 	/* When feature-split-event-channels = 0, tx_irq = rx_irq. */
@@ -356,6 +370,7 @@ int xenvif_dealloc_kthread(void *data);
 
 irqreturn_t xenvif_ctrl_irq_fn(int irq, void *data);
 
+bool xenvif_have_rx_work(struct xenvif_queue *queue, bool test_kthread);
 void xenvif_rx_action(struct xenvif_queue *queue);
 void xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb);
 
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index 46008f284550..e61073c75142 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -76,12 +76,28 @@ int xenvif_schedulable(struct xenvif *vif)
 		!vif->disabled;
 }
 
+static bool xenvif_handle_tx_interrupt(struct xenvif_queue *queue)
+{
+	bool rc;
+
+	rc = RING_HAS_UNCONSUMED_REQUESTS(&queue->tx);
+	if (rc)
+		napi_schedule(&queue->napi);
+	return rc;
+}
+
 static irqreturn_t xenvif_tx_interrupt(int irq, void *dev_id)
 {
 	struct xenvif_queue *queue = dev_id;
+	int old;
 
-	if (RING_HAS_UNCONSUMED_REQUESTS(&queue->tx))
-		napi_schedule(&queue->napi);
+	old = atomic_fetch_or(NETBK_TX_EOI, &queue->eoi_pending);
+	WARN(old & NETBK_TX_EOI, "Interrupt while EOI pending\n");
+
+	if (!xenvif_handle_tx_interrupt(queue)) {
+		atomic_andnot(NETBK_TX_EOI, &queue->eoi_pending);
+		xen_irq_lateeoi(irq, XEN_EOI_FLAG_SPURIOUS);
+	}
 
 	return IRQ_HANDLED;
 }
@@ -115,19 +131,46 @@ static int xenvif_poll(struct napi_struct *napi, int budget)
 	return work_done;
 }
 
+static bool xenvif_handle_rx_interrupt(struct xenvif_queue *queue)
+{
+	bool rc;
+
+	rc = xenvif_have_rx_work(queue, false);
+	if (rc)
+		xenvif_kick_thread(queue);
+	return rc;
+}
+
 static irqreturn_t xenvif_rx_interrupt(int irq, void *dev_id)
 {
 	struct xenvif_queue *queue = dev_id;
+	int old;
 
-	xenvif_kick_thread(queue);
+	old = atomic_fetch_or(NETBK_RX_EOI, &queue->eoi_pending);
+	WARN(old & NETBK_RX_EOI, "Interrupt while EOI pending\n");
+
+	if (!xenvif_handle_rx_interrupt(queue)) {
+		atomic_andnot(NETBK_RX_EOI, &queue->eoi_pending);
+		xen_irq_lateeoi(irq, XEN_EOI_FLAG_SPURIOUS);
+	}
 
 	return IRQ_HANDLED;
 }
 
 irqreturn_t xenvif_interrupt(int irq, void *dev_id)
 {
-	xenvif_tx_interrupt(irq, dev_id);
-	xenvif_rx_interrupt(irq, dev_id);
+	struct xenvif_queue *queue = dev_id;
+	int old;
+
+	old = atomic_fetch_or(NETBK_COMMON_EOI, &queue->eoi_pending);
+	WARN(old, "Interrupt while EOI pending\n");
+
+	/* Use bitwise or as we need to call both functions. */
+	if ((!xenvif_handle_tx_interrupt(queue) |
+	     !xenvif_handle_rx_interrupt(queue))) {
+		atomic_andnot(NETBK_COMMON_EOI, &queue->eoi_pending);
+		xen_irq_lateeoi(irq, XEN_EOI_FLAG_SPURIOUS);
+	}
 
 	return IRQ_HANDLED;
 }
@@ -583,7 +626,7 @@ int xenvif_connect_ctrl(struct xenvif *vif, grant_ref_t ring_ref,
 	shared = (struct xen_netif_ctrl_sring *)addr;
 	BACK_RING_INIT(&vif->ctrl, shared, XEN_PAGE_SIZE);
 
-	err = bind_interdomain_evtchn_to_irq(vif->domid, evtchn);
+	err = bind_interdomain_evtchn_to_irq_lateeoi(vif->domid, evtchn);
 	if (err < 0)
 		goto err_unmap;
 
@@ -641,7 +684,7 @@ int xenvif_connect_data(struct xenvif_queue *queue,
 
 	if (tx_evtchn == rx_evtchn) {
 		/* feature-split-event-channels == 0 */
-		err = bind_interdomain_evtchn_to_irqhandler(
+		err = bind_interdomain_evtchn_to_irqhandler_lateeoi(
 			queue->vif->domid, tx_evtchn, xenvif_interrupt, 0,
 			queue->name, queue);
 		if (err < 0)
@@ -652,7 +695,7 @@ int xenvif_connect_data(struct xenvif_queue *queue,
 		/* feature-split-event-channels == 1 */
 		snprintf(queue->tx_irq_name, sizeof(queue->tx_irq_name),
 			 "%s-tx", queue->name);
-		err = bind_interdomain_evtchn_to_irqhandler(
+		err = bind_interdomain_evtchn_to_irqhandler_lateeoi(
 			queue->vif->domid, tx_evtchn, xenvif_tx_interrupt, 0,
 			queue->tx_irq_name, queue);
 		if (err < 0)
@@ -662,7 +705,7 @@ int xenvif_connect_data(struct xenvif_queue *queue,
 
 		snprintf(queue->rx_irq_name, sizeof(queue->rx_irq_name),
 			 "%s-rx", queue->name);
-		err = bind_interdomain_evtchn_to_irqhandler(
+		err = bind_interdomain_evtchn_to_irqhandler_lateeoi(
 			queue->vif->domid, rx_evtchn, xenvif_rx_interrupt, 0,
 			queue->rx_irq_name, queue);
 		if (err < 0)
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index a469fbe1abaf..fd2ac6cd0c69 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -162,6 +162,10 @@ void xenvif_napi_schedule_or_enable_events(struct xenvif_queue *queue)
 
 	if (more_to_do)
 		napi_schedule(&queue->napi);
+	else if (atomic_fetch_andnot(NETBK_TX_EOI | NETBK_COMMON_EOI,
+				     &queue->eoi_pending) &
+		 (NETBK_TX_EOI | NETBK_COMMON_EOI))
+		xen_irq_lateeoi(queue->tx_irq, 0);
 }
 
 static void tx_add_credit(struct xenvif_queue *queue)
@@ -1615,9 +1619,14 @@ static bool xenvif_ctrl_work_todo(struct xenvif *vif)
 irqreturn_t xenvif_ctrl_irq_fn(int irq, void *data)
 {
 	struct xenvif *vif = data;
+	unsigned int eoi_flag = XEN_EOI_FLAG_SPURIOUS;
 
-	while (xenvif_ctrl_work_todo(vif))
+	while (xenvif_ctrl_work_todo(vif)) {
 		xenvif_ctrl_action(vif);
+		eoi_flag = 0;
+	}
+
+	xen_irq_lateeoi(irq, eoi_flag);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/net/xen-netback/rx.c b/drivers/net/xen-netback/rx.c
index b1cf7c6f407a..f152246c7dfb 100644
--- a/drivers/net/xen-netback/rx.c
+++ b/drivers/net/xen-netback/rx.c
@@ -490,13 +490,13 @@ static bool xenvif_rx_queue_ready(struct xenvif_queue *queue)
 	return queue->stalled && prod - cons >= 1;
 }
 
-static bool xenvif_have_rx_work(struct xenvif_queue *queue)
+bool xenvif_have_rx_work(struct xenvif_queue *queue, bool test_kthread)
 {
 	return xenvif_rx_ring_slots_available(queue) ||
 		(queue->vif->stall_timeout &&
 		 (xenvif_rx_queue_stalled(queue) ||
 		  xenvif_rx_queue_ready(queue))) ||
-		kthread_should_stop() ||
+		(test_kthread && kthread_should_stop()) ||
 		queue->vif->disabled;
 }
 
@@ -527,15 +527,20 @@ static void xenvif_wait_for_rx_work(struct xenvif_queue *queue)
 {
 	DEFINE_WAIT(wait);
 
-	if (xenvif_have_rx_work(queue))
+	if (xenvif_have_rx_work(queue, true))
 		return;
 
 	for (;;) {
 		long ret;
 
 		prepare_to_wait(&queue->wq, &wait, TASK_INTERRUPTIBLE);
-		if (xenvif_have_rx_work(queue))
+		if (xenvif_have_rx_work(queue, true))
 			break;
+		if (atomic_fetch_andnot(NETBK_RX_EOI | NETBK_COMMON_EOI,
+					&queue->eoi_pending) &
+		    (NETBK_RX_EOI | NETBK_COMMON_EOI))
+			xen_irq_lateeoi(queue->rx_irq, 0);
+
 		ret = schedule_timeout(xenvif_rx_queue_timeout(queue));
 		if (!ret)
 			break;
-- 
2.26.2

