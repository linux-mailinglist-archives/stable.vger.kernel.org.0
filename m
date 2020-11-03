Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 594182A4B28
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 17:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbgKCQWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 11:22:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:58830 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728387AbgKCQWm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 11:22:42 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604420560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PEYmdv8NrPK0Ui4sA4/Dkx4reVCRO9PB14QmMt7WDLE=;
        b=SFaUwwyE3ZPkkuyYCx/1MK0L0oaE1B5MTPeZgqQgfA/724rk1dLQsKX4O4G6dPjzoXsqBJ
        0SpjzVl2rqoTYndbcP37hN1myWVPTYui16ZdYF3dn5kchdMthE8+D87HL+YDsGsQQAtDVv
        d/KYSdw/1WDVF1PplO8IRptc/sXOgE0=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F2758AD80
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 16:22:39 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     stable@vger.kernel.org
Subject: [PATCH 07/13] xen/netback: use lateeoi irq binding
Date:   Tue,  3 Nov 2020 17:22:32 +0100
Message-Id: <20201103162238.30264-8-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103162238.30264-1-jgross@suse.com>
References: <20201103162238.30264-1-jgross@suse.com>
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
 drivers/net/xen-netback/common.h    | 39 +++++++++++++++++++
 drivers/net/xen-netback/interface.c | 59 +++++++++++++++++++++++++----
 drivers/net/xen-netback/netback.c   | 17 +++++++--
 3 files changed, 103 insertions(+), 12 deletions(-)

diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
index 34173b5e886f..53c2fa244c64 100644
--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -137,6 +137,20 @@ struct xenvif_queue { /* Per-queue data for xenvif */
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
@@ -317,6 +331,7 @@ void xenvif_kick_thread(struct xenvif_queue *queue);
 
 int xenvif_dealloc_kthread(void *data);
 
+bool xenvif_have_rx_work(struct xenvif_queue *queue, bool test_kthread);
 void xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb);
 
 void xenvif_carrier_on(struct xenvif *vif);
@@ -353,4 +368,28 @@ void xenvif_skb_zerocopy_complete(struct xenvif_queue *queue);
 bool xenvif_mcast_match(struct xenvif *vif, const u8 *addr);
 void xenvif_mcast_addr_list_free(struct xenvif *vif);
 
+#include <linux/atomic.h>
+
+static inline int xenvif_atomic_fetch_or(int i, atomic_t *v)
+{
+	int c, old;
+
+	c = v->counter;
+	while ((old = cmpxchg(&v->counter, c, c | i)) != c)
+		c = old;
+
+	return c;
+}
+
+static inline int xenvif_atomic_fetch_andnot(int i, atomic_t *v)
+{
+	int c, old;
+
+	c = v->counter;
+	while ((old = cmpxchg(&v->counter, c, c & ~i)) != c)
+		c = old;
+
+	return c;
+}
+
 #endif /* __XEN_NETBACK__COMMON_H__ */
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index 2008c6a02b8a..66260ea74d7d 100644
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
+	old = xenvif_atomic_fetch_or(NETBK_TX_EOI, &queue->eoi_pending);
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
+	old = xenvif_atomic_fetch_or(NETBK_RX_EOI, &queue->eoi_pending);
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
+	old = xenvif_atomic_fetch_or(NETBK_COMMON_EOI, &queue->eoi_pending);
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
@@ -555,7 +598,7 @@ int xenvif_connect(struct xenvif_queue *queue, unsigned long tx_ring_ref,
 
 	if (tx_evtchn == rx_evtchn) {
 		/* feature-split-event-channels == 0 */
-		err = bind_interdomain_evtchn_to_irqhandler(
+		err = bind_interdomain_evtchn_to_irqhandler_lateeoi(
 			queue->vif->domid, tx_evtchn, xenvif_interrupt, 0,
 			queue->name, queue);
 		if (err < 0)
@@ -566,7 +609,7 @@ int xenvif_connect(struct xenvif_queue *queue, unsigned long tx_ring_ref,
 		/* feature-split-event-channels == 1 */
 		snprintf(queue->tx_irq_name, sizeof(queue->tx_irq_name),
 			 "%s-tx", queue->name);
-		err = bind_interdomain_evtchn_to_irqhandler(
+		err = bind_interdomain_evtchn_to_irqhandler_lateeoi(
 			queue->vif->domid, tx_evtchn, xenvif_tx_interrupt, 0,
 			queue->tx_irq_name, queue);
 		if (err < 0)
@@ -576,7 +619,7 @@ int xenvif_connect(struct xenvif_queue *queue, unsigned long tx_ring_ref,
 
 		snprintf(queue->rx_irq_name, sizeof(queue->rx_irq_name),
 			 "%s-rx", queue->name);
-		err = bind_interdomain_evtchn_to_irqhandler(
+		err = bind_interdomain_evtchn_to_irqhandler_lateeoi(
 			queue->vif->domid, rx_evtchn, xenvif_rx_interrupt, 0,
 			queue->rx_irq_name, queue);
 		if (err < 0)
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 65d37257e033..ee7a800c16d5 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -670,6 +670,10 @@ void xenvif_napi_schedule_or_enable_events(struct xenvif_queue *queue)
 
 	if (more_to_do)
 		napi_schedule(&queue->napi);
+	else if (xenvif_atomic_fetch_andnot(NETBK_TX_EOI | NETBK_COMMON_EOI,
+				     &queue->eoi_pending) &
+		 (NETBK_TX_EOI | NETBK_COMMON_EOI))
+		xen_irq_lateeoi(queue->tx_irq, 0);
 }
 
 static void tx_add_credit(struct xenvif_queue *queue)
@@ -2010,14 +2014,14 @@ static bool xenvif_rx_queue_ready(struct xenvif_queue *queue)
 	return queue->stalled && prod - cons >= 1;
 }
 
-static bool xenvif_have_rx_work(struct xenvif_queue *queue)
+bool xenvif_have_rx_work(struct xenvif_queue *queue, bool test_kthread)
 {
 	return (!skb_queue_empty(&queue->rx_queue)
 		&& xenvif_rx_ring_slots_available(queue))
 		|| (queue->vif->stall_timeout &&
 		    (xenvif_rx_queue_stalled(queue)
 		     || xenvif_rx_queue_ready(queue)))
-		|| kthread_should_stop()
+		|| (test_kthread && kthread_should_stop())
 		|| queue->vif->disabled;
 }
 
@@ -2048,15 +2052,20 @@ static void xenvif_wait_for_rx_work(struct xenvif_queue *queue)
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
+		if (xenvif_atomic_fetch_andnot(NETBK_RX_EOI | NETBK_COMMON_EOI,
+					&queue->eoi_pending) &
+		    (NETBK_RX_EOI | NETBK_COMMON_EOI))
+			xen_irq_lateeoi(queue->rx_irq, 0);
+
 		ret = schedule_timeout(xenvif_rx_queue_timeout(queue));
 		if (!ret)
 			break;
-- 
2.26.2

