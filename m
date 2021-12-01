Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66700464E18
	for <lists+stable@lfdr.de>; Wed,  1 Dec 2021 13:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245116AbhLAMov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Dec 2021 07:44:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244866AbhLAMou (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Dec 2021 07:44:50 -0500
Received: from lb2-smtp-cloud7.xs4all.net (lb2-smtp-cloud7.xs4all.net [IPv6:2001:888:0:108::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6263EC06174A;
        Wed,  1 Dec 2021 04:41:29 -0800 (PST)
Received: from cust-b5b5937f ([IPv6:fc0c:c16d:66b8:757f:c639:739b:9d66:799d])
        by smtp-cloud7.xs4all.net with ESMTPA
        id sOvPmchRzf6qjsOvPmEfO1; Wed, 01 Dec 2021 13:41:27 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xs4all.nl; s=s2;
        t=1638362487; bh=a11sS4WpSfVnw4IcIYPqoHsqlUksW9hjmhW7WaX+HNM=;
        h=From:To:Subject:Date:Message-Id:MIME-Version:From:Subject;
        b=STj5zszTX3eqFyDoZrZoObmZfyJ6La5n/b7MXRxFeqvxFnRCCozkGjmBDO6gKcXVl
         B+HN4xIw7ux0cI9DIBoXc8V6iOYACjNZOYwskZybQBOLOBtu8S8KaNyf6L2LDzEaQw
         IqHLWeeJNFEw189jnSVpWioESrhB4qW9dfNX84iODp0PMOP15YT4GKVmwbh/kP91Kh
         Rlfvz6rDZY0K6T2PMJYpx4G6lfi3XbJdbo63D9Rk+MneO5sJNodP8uOq5WS/sfKgj8
         tH6RG6HjZRdfGMW1INhfW8MzGKmGnqdhVuZgyXEEsMemt3nB3stQjYFYH8qnEqHhtb
         iz/GEzUA3ipng==
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
To:     linux-media@vger.kernel.org
Cc:     Johan Fjeldtvedt <johfjeld@cisco.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>, stable@vger.kernel.org
Subject: [PATCH 1/2] cec-pin: fix interrupt en/disable handling
Date:   Wed,  1 Dec 2021 13:41:25 +0100
Message-Id: <20211201124126.3948360-2-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211201124126.3948360-1-hverkuil-cisco@xs4all.nl>
References: <20211201124126.3948360-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The en/disable_irq() functions keep track of the 'depth': i.e. if
interrupts are disabled twice, then it needs to enable_irq() calls to
enable them again. The cec-pin framework didn't take this into accound
and could disable irqs multiple times, and it expected that a single
enable_irq() would enable them again.

Move all calls to en/disable_irq() to the kthread where it is easy
to keep track of the current irq state and ensure that multiple
en/disable_irq calls never happen.

If interrupts where disabled twice, then they would never turn on
again, leaving the CEC adapter in a dead state.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: 865463fc03ed (media: cec-pin: add error injection support)
Cc: <stable@vger.kernel.org>
---
 drivers/media/cec/core/cec-pin.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/media/cec/core/cec-pin.c b/drivers/media/cec/core/cec-pin.c
index a60b6f03a6a1..178edc85dc92 100644
--- a/drivers/media/cec/core/cec-pin.c
+++ b/drivers/media/cec/core/cec-pin.c
@@ -1033,6 +1033,7 @@ static int cec_pin_thread_func(void *_adap)
 {
 	struct cec_adapter *adap = _adap;
 	struct cec_pin *pin = adap->pin;
+	bool irq_enabled = false;
 
 	for (;;) {
 		wait_event_interruptible(pin->kthread_waitq,
@@ -1060,6 +1061,7 @@ static int cec_pin_thread_func(void *_adap)
 				ns_to_ktime(pin->work_rx_msg.rx_ts));
 			msg->len = 0;
 		}
+
 		if (pin->work_tx_status) {
 			unsigned int tx_status = pin->work_tx_status;
 
@@ -1083,27 +1085,39 @@ static int cec_pin_thread_func(void *_adap)
 		switch (atomic_xchg(&pin->work_irq_change,
 				    CEC_PIN_IRQ_UNCHANGED)) {
 		case CEC_PIN_IRQ_DISABLE:
-			pin->ops->disable_irq(adap);
+			if (irq_enabled) {
+				pin->ops->disable_irq(adap);
+				irq_enabled = false;
+			}
 			cec_pin_high(pin);
 			cec_pin_to_idle(pin);
 			hrtimer_start(&pin->timer, ns_to_ktime(0),
 				      HRTIMER_MODE_REL);
 			break;
 		case CEC_PIN_IRQ_ENABLE:
+			if (irq_enabled)
+				break;
 			pin->enable_irq_failed = !pin->ops->enable_irq(adap);
 			if (pin->enable_irq_failed) {
 				cec_pin_to_idle(pin);
 				hrtimer_start(&pin->timer, ns_to_ktime(0),
 					      HRTIMER_MODE_REL);
+			} else {
+				irq_enabled = true;
 			}
 			break;
 		default:
 			break;
 		}
-
 		if (kthread_should_stop())
 			break;
 	}
+	if (pin->ops->disable_irq && irq_enabled)
+		pin->ops->disable_irq(adap);
+	hrtimer_cancel(&pin->timer);
+	cec_pin_read(pin);
+	cec_pin_to_idle(pin);
+	pin->state = CEC_ST_OFF;
 	return 0;
 }
 
@@ -1130,13 +1144,7 @@ static int cec_pin_adap_enable(struct cec_adapter *adap, bool enable)
 		hrtimer_start(&pin->timer, ns_to_ktime(0),
 			      HRTIMER_MODE_REL);
 	} else {
-		if (pin->ops->disable_irq)
-			pin->ops->disable_irq(adap);
-		hrtimer_cancel(&pin->timer);
 		kthread_stop(pin->kthread);
-		cec_pin_read(pin);
-		cec_pin_to_idle(pin);
-		pin->state = CEC_ST_OFF;
 	}
 	return 0;
 }
@@ -1157,11 +1165,8 @@ void cec_pin_start_timer(struct cec_pin *pin)
 	if (pin->state != CEC_ST_RX_IRQ)
 		return;
 
-	atomic_set(&pin->work_irq_change, CEC_PIN_IRQ_UNCHANGED);
-	pin->ops->disable_irq(pin->adap);
-	cec_pin_high(pin);
-	cec_pin_to_idle(pin);
-	hrtimer_start(&pin->timer, ns_to_ktime(0), HRTIMER_MODE_REL);
+	atomic_set(&pin->work_irq_change, CEC_PIN_IRQ_DISABLE);
+	wake_up_interruptible(&pin->kthread_waitq);
 }
 
 static int cec_pin_adap_transmit(struct cec_adapter *adap, u8 attempts,
-- 
2.33.0

