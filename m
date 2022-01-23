Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37332497208
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 15:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233494AbiAWOWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 09:22:40 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36762 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbiAWOWj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 09:22:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A20D960C7F
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 14:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73BA3C340E2;
        Sun, 23 Jan 2022 14:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642947759;
        bh=hQJxjRi5JcJFws5lkI8WwRWOyfkRxmWS1EgrBij6h1k=;
        h=Subject:To:Cc:From:Date:From;
        b=vRyLYGHrYLnTVgnLNULqSRv02SHI6Z05FfwHfRuaOiOCJn76uBzk24ickQsjjjKew
         c0QcKn61kiZt9ggh5m02AnO3luP/wDBKuxQpFzbKMtcChI23ON1emt22iExF9dG5lC
         r+4+Vr8XbS8zXvDJExg7K1h3k83ZehV/Gj7zrSYs=
Subject: FAILED: patch "[PATCH] media: cec-pin: fix interrupt en/disable handling" failed to apply to 4.19-stable tree
To:     hverkuil-cisco@xs4all.nl, mchehab+huawei@kernel.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 15:22:36 +0100
Message-ID: <1642947756113132@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 713bdfa10b5957053811470d298def9537d9ff13 Mon Sep 17 00:00:00 2001
From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Date: Wed, 1 Dec 2021 13:41:25 +0100
Subject: [PATCH] media: cec-pin: fix interrupt en/disable handling

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
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

diff --git a/drivers/media/cec/core/cec-pin.c b/drivers/media/cec/core/cec-pin.c
index 2b6459df1e94..21f0f749713e 100644
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
 
@@ -1129,13 +1143,7 @@ static int cec_pin_adap_enable(struct cec_adapter *adap, bool enable)
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
@@ -1156,11 +1164,8 @@ void cec_pin_start_timer(struct cec_pin *pin)
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

