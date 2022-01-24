Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E542498D80
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353098AbiAXTco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:32:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352436AbiAXTa1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:30:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E77C02982E;
        Mon, 24 Jan 2022 11:13:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F52FB81223;
        Mon, 24 Jan 2022 19:13:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590DFC340E5;
        Mon, 24 Jan 2022 19:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051630;
        bh=MOM5gMZz79kna8oNQJ7UrBfangfUqQQv7yzRdLAipa0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OFDqsX10xXkD8/5yTkjQXSyX4XTi//8APmcAVnIQVrwm1+3kGQ9736iWMiyJt4o4y
         tMk2Uz+UebLuseEck9aUiH89ebOK/I3TA2mPLPnBqxWJwHnKm7xFsEEgD7HuSJYx8Z
         33BI+aeMDAEs2Wq/vERWmqAztaOwpOWfiSU9TKr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Ziyang Xuan <william.xuanziyang@huawei.com>
Subject: [PATCH 4.19 004/239] can: bcm: switch timer to HRTIMER_MODE_SOFT and remove hrtimer_tasklet
Date:   Mon, 24 Jan 2022 19:40:42 +0100
Message-Id: <20220124183943.254127396@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit bf74aa86e111aa3b2fbb25db37e3a3fab71b5b68 upstream.

This patch switches the timer to HRTIMER_MODE_SOFT, which executed the
timer callback in softirq context and removes the hrtimer_tasklet.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Anna-Maria Gleixner <anna-maria@linutronix.de>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/bcm.c |  156 +++++++++++++++++++---------------------------------------
 1 file changed, 52 insertions(+), 104 deletions(-)

--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -105,7 +105,6 @@ struct bcm_op {
 	unsigned long frames_abs, frames_filtered;
 	struct bcm_timeval ival1, ival2;
 	struct hrtimer timer, thrtimer;
-	struct tasklet_struct tsklet, thrtsklet;
 	ktime_t rx_stamp, kt_ival1, kt_ival2, kt_lastmsg;
 	int rx_ifindex;
 	int cfsiz;
@@ -374,25 +373,34 @@ static void bcm_send_to_user(struct bcm_
 	}
 }
 
-static void bcm_tx_start_timer(struct bcm_op *op)
+static bool bcm_tx_set_expiry(struct bcm_op *op, struct hrtimer *hrt)
 {
+	ktime_t ival;
+
 	if (op->kt_ival1 && op->count)
-		hrtimer_start(&op->timer,
-			      ktime_add(ktime_get(), op->kt_ival1),
-			      HRTIMER_MODE_ABS);
+		ival = op->kt_ival1;
 	else if (op->kt_ival2)
-		hrtimer_start(&op->timer,
-			      ktime_add(ktime_get(), op->kt_ival2),
-			      HRTIMER_MODE_ABS);
+		ival = op->kt_ival2;
+	else
+		return false;
+
+	hrtimer_set_expires(hrt, ktime_add(ktime_get(), ival));
+	return true;
 }
 
-static void bcm_tx_timeout_tsklet(unsigned long data)
+static void bcm_tx_start_timer(struct bcm_op *op)
 {
-	struct bcm_op *op = (struct bcm_op *)data;
+	if (bcm_tx_set_expiry(op, &op->timer))
+		hrtimer_start_expires(&op->timer, HRTIMER_MODE_ABS_SOFT);
+}
+
+/* bcm_tx_timeout_handler - performs cyclic CAN frame transmissions */
+static enum hrtimer_restart bcm_tx_timeout_handler(struct hrtimer *hrtimer)
+{
+	struct bcm_op *op = container_of(hrtimer, struct bcm_op, timer);
 	struct bcm_msg_head msg_head;
 
 	if (op->kt_ival1 && (op->count > 0)) {
-
 		op->count--;
 		if (!op->count && (op->flags & TX_COUNTEVT)) {
 
@@ -410,22 +418,12 @@ static void bcm_tx_timeout_tsklet(unsign
 		}
 		bcm_can_tx(op);
 
-	} else if (op->kt_ival2)
+	} else if (op->kt_ival2) {
 		bcm_can_tx(op);
+	}
 
-	bcm_tx_start_timer(op);
-}
-
-/*
- * bcm_tx_timeout_handler - performs cyclic CAN frame transmissions
- */
-static enum hrtimer_restart bcm_tx_timeout_handler(struct hrtimer *hrtimer)
-{
-	struct bcm_op *op = container_of(hrtimer, struct bcm_op, timer);
-
-	tasklet_schedule(&op->tsklet);
-
-	return HRTIMER_NORESTART;
+	return bcm_tx_set_expiry(op, &op->timer) ?
+		HRTIMER_RESTART : HRTIMER_NORESTART;
 }
 
 /*
@@ -492,7 +490,7 @@ static void bcm_rx_update_and_send(struc
 		/* do not send the saved data - only start throttle timer */
 		hrtimer_start(&op->thrtimer,
 			      ktime_add(op->kt_lastmsg, op->kt_ival2),
-			      HRTIMER_MODE_ABS);
+			      HRTIMER_MODE_ABS_SOFT);
 		return;
 	}
 
@@ -551,14 +549,21 @@ static void bcm_rx_starttimer(struct bcm
 		return;
 
 	if (op->kt_ival1)
-		hrtimer_start(&op->timer, op->kt_ival1, HRTIMER_MODE_REL);
+		hrtimer_start(&op->timer, op->kt_ival1, HRTIMER_MODE_REL_SOFT);
 }
 
-static void bcm_rx_timeout_tsklet(unsigned long data)
+/* bcm_rx_timeout_handler - when the (cyclic) CAN frame reception timed out */
+static enum hrtimer_restart bcm_rx_timeout_handler(struct hrtimer *hrtimer)
 {
-	struct bcm_op *op = (struct bcm_op *)data;
+	struct bcm_op *op = container_of(hrtimer, struct bcm_op, timer);
 	struct bcm_msg_head msg_head;
 
+	/* if user wants to be informed, when cyclic CAN-Messages come back */
+	if ((op->flags & RX_ANNOUNCE_RESUME) && op->last_frames) {
+		/* clear received CAN frames to indicate 'nothing received' */
+		memset(op->last_frames, 0, op->nframes * op->cfsiz);
+	}
+
 	/* create notification to user */
 	memset(&msg_head, 0, sizeof(msg_head));
 	msg_head.opcode  = RX_TIMEOUT;
@@ -570,25 +575,6 @@ static void bcm_rx_timeout_tsklet(unsign
 	msg_head.nframes = 0;
 
 	bcm_send_to_user(op, &msg_head, NULL, 0);
-}
-
-/*
- * bcm_rx_timeout_handler - when the (cyclic) CAN frame reception timed out
- */
-static enum hrtimer_restart bcm_rx_timeout_handler(struct hrtimer *hrtimer)
-{
-	struct bcm_op *op = container_of(hrtimer, struct bcm_op, timer);
-
-	/* schedule before NET_RX_SOFTIRQ */
-	tasklet_hi_schedule(&op->tsklet);
-
-	/* no restart of the timer is done here! */
-
-	/* if user wants to be informed, when cyclic CAN-Messages come back */
-	if ((op->flags & RX_ANNOUNCE_RESUME) && op->last_frames) {
-		/* clear received CAN frames to indicate 'nothing received' */
-		memset(op->last_frames, 0, op->nframes * op->cfsiz);
-	}
 
 	return HRTIMER_NORESTART;
 }
@@ -596,14 +582,12 @@ static enum hrtimer_restart bcm_rx_timeo
 /*
  * bcm_rx_do_flush - helper for bcm_rx_thr_flush
  */
-static inline int bcm_rx_do_flush(struct bcm_op *op, int update,
-				  unsigned int index)
+static inline int bcm_rx_do_flush(struct bcm_op *op, unsigned int index)
 {
 	struct canfd_frame *lcf = op->last_frames + op->cfsiz * index;
 
 	if ((op->last_frames) && (lcf->flags & RX_THR)) {
-		if (update)
-			bcm_rx_changed(op, lcf);
+		bcm_rx_changed(op, lcf);
 		return 1;
 	}
 	return 0;
@@ -611,11 +595,8 @@ static inline int bcm_rx_do_flush(struct
 
 /*
  * bcm_rx_thr_flush - Check for throttled data and send it to the userspace
- *
- * update == 0 : just check if throttled data is available  (any irq context)
- * update == 1 : check and send throttled data to userspace (soft_irq context)
  */
-static int bcm_rx_thr_flush(struct bcm_op *op, int update)
+static int bcm_rx_thr_flush(struct bcm_op *op)
 {
 	int updated = 0;
 
@@ -624,24 +605,16 @@ static int bcm_rx_thr_flush(struct bcm_o
 
 		/* for MUX filter we start at index 1 */
 		for (i = 1; i < op->nframes; i++)
-			updated += bcm_rx_do_flush(op, update, i);
+			updated += bcm_rx_do_flush(op, i);
 
 	} else {
 		/* for RX_FILTER_ID and simple filter */
-		updated += bcm_rx_do_flush(op, update, 0);
+		updated += bcm_rx_do_flush(op, 0);
 	}
 
 	return updated;
 }
 
-static void bcm_rx_thr_tsklet(unsigned long data)
-{
-	struct bcm_op *op = (struct bcm_op *)data;
-
-	/* push the changed data to the userspace */
-	bcm_rx_thr_flush(op, 1);
-}
-
 /*
  * bcm_rx_thr_handler - the time for blocked content updates is over now:
  *                      Check for throttled data and send it to the userspace
@@ -650,9 +623,7 @@ static enum hrtimer_restart bcm_rx_thr_h
 {
 	struct bcm_op *op = container_of(hrtimer, struct bcm_op, thrtimer);
 
-	tasklet_schedule(&op->thrtsklet);
-
-	if (bcm_rx_thr_flush(op, 0)) {
+	if (bcm_rx_thr_flush(op)) {
 		hrtimer_forward(hrtimer, ktime_get(), op->kt_ival2);
 		return HRTIMER_RESTART;
 	} else {
@@ -748,23 +719,8 @@ static struct bcm_op *bcm_find_op(struct
 
 static void bcm_remove_op(struct bcm_op *op)
 {
-	if (op->tsklet.func) {
-		while (test_bit(TASKLET_STATE_SCHED, &op->tsklet.state) ||
-		       test_bit(TASKLET_STATE_RUN, &op->tsklet.state) ||
-		       hrtimer_active(&op->timer)) {
-			hrtimer_cancel(&op->timer);
-			tasklet_kill(&op->tsklet);
-		}
-	}
-
-	if (op->thrtsklet.func) {
-		while (test_bit(TASKLET_STATE_SCHED, &op->thrtsklet.state) ||
-		       test_bit(TASKLET_STATE_RUN, &op->thrtsklet.state) ||
-		       hrtimer_active(&op->thrtimer)) {
-			hrtimer_cancel(&op->thrtimer);
-			tasklet_kill(&op->thrtsklet);
-		}
-	}
+	hrtimer_cancel(&op->timer);
+	hrtimer_cancel(&op->thrtimer);
 
 	if ((op->frames) && (op->frames != &op->sframe))
 		kfree(op->frames);
@@ -998,15 +954,13 @@ static int bcm_tx_setup(struct bcm_msg_h
 		op->ifindex = ifindex;
 
 		/* initialize uninitialized (kzalloc) structure */
-		hrtimer_init(&op->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+		hrtimer_init(&op->timer, CLOCK_MONOTONIC,
+			     HRTIMER_MODE_REL_SOFT);
 		op->timer.function = bcm_tx_timeout_handler;
 
-		/* initialize tasklet for tx countevent notification */
-		tasklet_init(&op->tsklet, bcm_tx_timeout_tsklet,
-			     (unsigned long) op);
-
 		/* currently unused in tx_ops */
-		hrtimer_init(&op->thrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+		hrtimer_init(&op->thrtimer, CLOCK_MONOTONIC,
+			     HRTIMER_MODE_REL_SOFT);
 
 		/* add this bcm_op to the list of the tx_ops */
 		list_add(&op->list, &bo->tx_ops);
@@ -1175,20 +1129,14 @@ static int bcm_rx_setup(struct bcm_msg_h
 		op->rx_ifindex = ifindex;
 
 		/* initialize uninitialized (kzalloc) structure */
-		hrtimer_init(&op->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+		hrtimer_init(&op->timer, CLOCK_MONOTONIC,
+			     HRTIMER_MODE_REL_SOFT);
 		op->timer.function = bcm_rx_timeout_handler;
 
-		/* initialize tasklet for rx timeout notification */
-		tasklet_init(&op->tsklet, bcm_rx_timeout_tsklet,
-			     (unsigned long) op);
-
-		hrtimer_init(&op->thrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+		hrtimer_init(&op->thrtimer, CLOCK_MONOTONIC,
+			     HRTIMER_MODE_REL_SOFT);
 		op->thrtimer.function = bcm_rx_thr_handler;
 
-		/* initialize tasklet for rx throttle handling */
-		tasklet_init(&op->thrtsklet, bcm_rx_thr_tsklet,
-			     (unsigned long) op);
-
 		/* add this bcm_op to the list of the rx_ops */
 		list_add(&op->list, &bo->rx_ops);
 
@@ -1234,12 +1182,12 @@ static int bcm_rx_setup(struct bcm_msg_h
 			 */
 			op->kt_lastmsg = 0;
 			hrtimer_cancel(&op->thrtimer);
-			bcm_rx_thr_flush(op, 1);
+			bcm_rx_thr_flush(op);
 		}
 
 		if ((op->flags & STARTTIMER) && op->kt_ival1)
 			hrtimer_start(&op->timer, op->kt_ival1,
-				      HRTIMER_MODE_REL);
+				      HRTIMER_MODE_REL_SOFT);
 	}
 
 	/* now we can register for can_ids, if we added a new bcm_op */


