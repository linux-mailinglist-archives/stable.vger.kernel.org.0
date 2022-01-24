Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D15A4998A2
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358257AbiAXV2a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:28:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449778AbiAXVQ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:16:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 269C6C067A44;
        Mon, 24 Jan 2022 12:12:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1B84B8122C;
        Mon, 24 Jan 2022 20:12:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC4EC340E5;
        Mon, 24 Jan 2022 20:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055132;
        bh=bd/N2cLIIyZKGPaNuTPqhxCMHdyWjib1d+RJWqvsz/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zmihZBRgcW7Tb/Y854jNKwCMqVkaEcZ6t9FLXpTNbt9HYhWYH0Ep24E75jMEttPer
         MUpWPIQHozcB/cpqHnRiBwjR2lVbZcrKrufXH17CPw5lh5+UxcPXJXz+61539u1ZD3
         Y/pbEAFSBKBQisjOTm+1AkFlvP1nmhAUZTH+f3t4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.15 052/846] media: cec-pin: fix interrupt en/disable handling
Date:   Mon, 24 Jan 2022 19:32:49 +0100
Message-Id: <20220124184102.754469521@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

commit 713bdfa10b5957053811470d298def9537d9ff13 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/cec/core/cec-pin.c |   31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

--- a/drivers/media/cec/core/cec-pin.c
+++ b/drivers/media/cec/core/cec-pin.c
@@ -1033,6 +1033,7 @@ static int cec_pin_thread_func(void *_ad
 {
 	struct cec_adapter *adap = _adap;
 	struct cec_pin *pin = adap->pin;
+	bool irq_enabled = false;
 
 	for (;;) {
 		wait_event_interruptible(pin->kthread_waitq,
@@ -1060,6 +1061,7 @@ static int cec_pin_thread_func(void *_ad
 				ns_to_ktime(pin->work_rx_msg.rx_ts));
 			msg->len = 0;
 		}
+
 		if (pin->work_tx_status) {
 			unsigned int tx_status = pin->work_tx_status;
 
@@ -1083,27 +1085,39 @@ static int cec_pin_thread_func(void *_ad
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
 
@@ -1130,13 +1144,7 @@ static int cec_pin_adap_enable(struct ce
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
@@ -1157,11 +1165,8 @@ void cec_pin_start_timer(struct cec_pin
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


