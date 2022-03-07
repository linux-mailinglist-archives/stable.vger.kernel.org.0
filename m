Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4364D02E5
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 16:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236369AbiCGPa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 10:30:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232666AbiCGPaz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 10:30:55 -0500
Received: from www.linuxtv.org (www.linuxtv.org [130.149.80.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B1758822
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 07:30:01 -0800 (PST)
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1nRFJ9-00CHp9-81; Mon, 07 Mar 2022 15:29:59 +0000
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
Date:   Mon, 07 Mar 2022 15:29:33 +0000
Subject: [git:media_stage/master] media: gpio-ir-tx: fix transmit with long spaces on Orange Pi PC
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To:     linuxtv-commits@linuxtv.org
Cc:     stable@vger.kernel.org, Sean Young <sean@mess.org>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1nRFJ9-00CHp9-81@www.linuxtv.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: gpio-ir-tx: fix transmit with long spaces on Orange Pi PC
Author:  Sean Young <sean@mess.org>
Date:    Sun Feb 20 15:28:24 2022 +0100

Calling udelay for than 1000us does not always yield the correct
results.

Cc: stable@vger.kernel.org
Reported-by: Михаил <vrserver1@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>

 drivers/media/rc/gpio-ir-tx.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

---

diff --git a/drivers/media/rc/gpio-ir-tx.c b/drivers/media/rc/gpio-ir-tx.c
index c6cd2e6d8e65..a50701cfbbd7 100644
--- a/drivers/media/rc/gpio-ir-tx.c
+++ b/drivers/media/rc/gpio-ir-tx.c
@@ -48,11 +48,29 @@ static int gpio_ir_tx_set_carrier(struct rc_dev *dev, u32 carrier)
 	return 0;
 }
 
+static void delay_until(ktime_t until)
+{
+	/*
+	 * delta should never exceed 0.5 seconds (IR_MAX_DURATION) and on
+	 * m68k ndelay(s64) does not compile; so use s32 rather than s64.
+	 */
+	s32 delta;
+
+	while (true) {
+		delta = ktime_us_delta(until, ktime_get());
+		if (delta <= 0)
+			return;
+
+		/* udelay more than 1ms may not work */
+		delta = min(delta, 1000);
+		udelay(delta);
+	}
+}
+
 static void gpio_ir_tx_unmodulated(struct gpio_ir *gpio_ir, uint *txbuf,
 				   uint count)
 {
 	ktime_t edge;
-	s32 delta;
 	int i;
 
 	local_irq_disable();
@@ -63,9 +81,7 @@ static void gpio_ir_tx_unmodulated(struct gpio_ir *gpio_ir, uint *txbuf,
 		gpiod_set_value(gpio_ir->gpio, !(i % 2));
 
 		edge = ktime_add_us(edge, txbuf[i]);
-		delta = ktime_us_delta(edge, ktime_get());
-		if (delta > 0)
-			udelay(delta);
+		delay_until(edge);
 	}
 
 	gpiod_set_value(gpio_ir->gpio, 0);
@@ -97,9 +113,7 @@ static void gpio_ir_tx_modulated(struct gpio_ir *gpio_ir, uint *txbuf,
 		if (i % 2) {
 			// space
 			edge = ktime_add_us(edge, txbuf[i]);
-			delta = ktime_us_delta(edge, ktime_get());
-			if (delta > 0)
-				udelay(delta);
+			delay_until(edge);
 		} else {
 			// pulse
 			ktime_t last = ktime_add_us(edge, txbuf[i]);
