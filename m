Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4489D2B6059
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729262AbgKQNIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:08:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:36822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728412AbgKQNIU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:08:20 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F182C238E6;
        Tue, 17 Nov 2020 13:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618499;
        bh=5Q0M5ZDOWNA8OsriL905lRiV/6x7BGtnqP9SjN6UtBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WSnNlx74iKrgpwm0RPAuDYOnBTnjbNwTyslywWao3w1P2nx4PsePFOditXieOCVaT
         nYTlSib/WFX7STSjnc7PkBvTiTuNgCyxlY/wQkifR7n+WQyHelSJqqIvbcVpazvcJ5
         4DjdN2E1PdzpYkASJfqBu3iPbq+WUG55rN62vFU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Julien Grall <julien@xen.org>, Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>, Wei Liu <wl@xen.org>
Subject: [PATCH 4.4 53/64] xen/netback: use lateeoi irq binding
Date:   Tue, 17 Nov 2020 14:05:16 +0100
Message-Id: <20201117122108.779628325@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122106.144800239@linuxfoundation.org>
References: <20201117122106.144800239@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit 23025393dbeb3b8b3b60ebfa724cdae384992e27 upstream.

In order to reduce the chance for the system becoming unresponsive due
to event storms triggered by a misbehaving netfront use the lateeoi
irq binding for netback and unmask the event channel only just before
going to sleep waiting for new events.

Make sure not to issue an EOI when none is pending by introducing an
eoi_pending element to struct xenvif_queue.

When no request has been consumed set the spurious flag when sending
the EOI for an interrupt.

This is part of XSA-332.

Cc: stable@vger.kernel.org
Reported-by: Julien Grall <julien@xen.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Wei Liu <wl@xen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netback/common.h    |   39 +++++++++++++++++++++++
 drivers/net/xen-netback/interface.c |   59 +++++++++++++++++++++++++++++++-----
 drivers/net/xen-netback/netback.c   |   17 +++++++---
 3 files changed, 103 insertions(+), 12 deletions(-)

--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -137,6 +137,20 @@ struct xenvif_queue { /* Per-queue data
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
@@ -317,6 +331,7 @@ void xenvif_kick_thread(struct xenvif_qu
 
 int xenvif_dealloc_kthread(void *data);
 
+bool xenvif_have_rx_work(struct xenvif_queue *queue, bool test_kthread);
 void xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb);
 
 void xenvif_carrier_on(struct xenvif *vif);
@@ -353,4 +368,28 @@ void xenvif_skb_zerocopy_complete(struct
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
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -76,12 +76,28 @@ int xenvif_schedulable(struct xenvif *vi
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
@@ -115,19 +131,46 @@ static int xenvif_poll(struct napi_struc
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
@@ -555,7 +598,7 @@ int xenvif_connect(struct xenvif_queue *
 
 	if (tx_evtchn == rx_evtchn) {
 		/* feature-split-event-channels == 0 */
-		err = bind_interdomain_evtchn_to_irqhandler(
+		err = bind_interdomain_evtchn_to_irqhandler_lateeoi(
 			queue->vif->domid, tx_evtchn, xenvif_interrupt, 0,
 			queue->name, queue);
 		if (err < 0)
@@ -566,7 +609,7 @@ int xenvif_connect(struct xenvif_queue *
 		/* feature-split-event-channels == 1 */
 		snprintf(queue->tx_irq_name, sizeof(queue->tx_irq_name),
 			 "%s-tx", queue->name);
-		err = bind_interdomain_evtchn_to_irqhandler(
+		err = bind_interdomain_evtchn_to_irqhandler_lateeoi(
 			queue->vif->domid, tx_evtchn, xenvif_tx_interrupt, 0,
 			queue->tx_irq_name, queue);
 		if (err < 0)
@@ -576,7 +619,7 @@ int xenvif_connect(struct xenvif_queue *
 
 		snprintf(queue->rx_irq_name, sizeof(queue->rx_irq_name),
 			 "%s-rx", queue->name);
-		err = bind_interdomain_evtchn_to_irqhandler(
+		err = bind_interdomain_evtchn_to_irqhandler_lateeoi(
 			queue->vif->domid, rx_evtchn, xenvif_rx_interrupt, 0,
 			queue->rx_irq_name, queue);
 		if (err < 0)
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -670,6 +670,10 @@ void xenvif_napi_schedule_or_enable_even
 
 	if (more_to_do)
 		napi_schedule(&queue->napi);
+	else if (xenvif_atomic_fetch_andnot(NETBK_TX_EOI | NETBK_COMMON_EOI,
+				     &queue->eoi_pending) &
+		 (NETBK_TX_EOI | NETBK_COMMON_EOI))
+		xen_irq_lateeoi(queue->tx_irq, 0);
 }
 
 static void tx_add_credit(struct xenvif_queue *queue)
@@ -2010,14 +2014,14 @@ static bool xenvif_rx_queue_ready(struct
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
 
@@ -2048,15 +2052,20 @@ static void xenvif_wait_for_rx_work(stru
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


