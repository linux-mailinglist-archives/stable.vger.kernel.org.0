Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7AD030A3F6
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 10:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232629AbhBAJFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 04:05:41 -0500
Received: from www.linuxtv.org ([130.149.80.248]:41078 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232681AbhBAJFU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Feb 2021 04:05:20 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1l6V8C-005hj8-DZ; Mon, 01 Feb 2021 09:04:24 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Mon, 11 Jan 2021 11:58:44 +0000
Subject: [git:media_tree/master] media: rc: fix timeout handling after switch to microsecond durations
To:     linuxtv-commits@linuxtv.org
Cc:     Sean Young <sean@mess.org>, stable@vger.kernel.org,
        Matthias Reichl <hias@horus.com>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1l6V8C-005hj8-DZ@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: rc: fix timeout handling after switch to microsecond durations
Author:  Matthias Reichl <hias@horus.com>
Date:    Tue Jan 5 10:30:23 2021 +0100

Commit 528222d853f92 ("media: rc: harmonize infrared durations to
microseconds") missed to switch some timeout calculations from
nanoseconds to microseconds. This resulted in spurious key_up+key_down
events at the last scancode if the rc device uses a long timeout
(eg 100ms on nuvoton-cir) as the device timeout wasn't properly
accounted for in the keyup timeout calculation.

Fix this by applying the proper conversion functions.

Cc: stable@vger.kernel.org
Fixes: 528222d853f92 ("media: rc: harmonize infrared durations to microseconds")
Signed-off-by: Matthias Reichl <hias@horus.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/rc/ir-mce_kbd-decoder.c | 2 +-
 drivers/media/rc/rc-main.c            | 4 ++--
 drivers/media/rc/serial_ir.c          | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

---

diff --git a/drivers/media/rc/ir-mce_kbd-decoder.c b/drivers/media/rc/ir-mce_kbd-decoder.c
index be8f2756a444..1524dc0fc566 100644
--- a/drivers/media/rc/ir-mce_kbd-decoder.c
+++ b/drivers/media/rc/ir-mce_kbd-decoder.c
@@ -320,7 +320,7 @@ again:
 				data->body);
 			spin_lock(&data->keylock);
 			if (scancode) {
-				delay = nsecs_to_jiffies(dev->timeout) +
+				delay = usecs_to_jiffies(dev->timeout) +
 					msecs_to_jiffies(100);
 				mod_timer(&data->rx_timeout, jiffies + delay);
 			} else {
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 29d4d01896ff..1fd62c1dac76 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -737,7 +737,7 @@ static unsigned int repeat_period(int protocol)
 void rc_repeat(struct rc_dev *dev)
 {
 	unsigned long flags;
-	unsigned int timeout = nsecs_to_jiffies(dev->timeout) +
+	unsigned int timeout = usecs_to_jiffies(dev->timeout) +
 		msecs_to_jiffies(repeat_period(dev->last_protocol));
 	struct lirc_scancode sc = {
 		.scancode = dev->last_scancode, .rc_proto = dev->last_protocol,
@@ -855,7 +855,7 @@ void rc_keydown(struct rc_dev *dev, enum rc_proto protocol, u64 scancode,
 	ir_do_keydown(dev, protocol, scancode, keycode, toggle);
 
 	if (dev->keypressed) {
-		dev->keyup_jiffies = jiffies + nsecs_to_jiffies(dev->timeout) +
+		dev->keyup_jiffies = jiffies + usecs_to_jiffies(dev->timeout) +
 			msecs_to_jiffies(repeat_period(protocol));
 		mod_timer(&dev->timer_keyup, dev->keyup_jiffies);
 	}
diff --git a/drivers/media/rc/serial_ir.c b/drivers/media/rc/serial_ir.c
index 8cc28c92d05d..96ae0294ac10 100644
--- a/drivers/media/rc/serial_ir.c
+++ b/drivers/media/rc/serial_ir.c
@@ -385,7 +385,7 @@ static irqreturn_t serial_ir_irq_handler(int i, void *blah)
 	} while (!(sinp(UART_IIR) & UART_IIR_NO_INT)); /* still pending ? */
 
 	mod_timer(&serial_ir.timeout_timer,
-		  jiffies + nsecs_to_jiffies(serial_ir.rcdev->timeout));
+		  jiffies + usecs_to_jiffies(serial_ir.rcdev->timeout));
 
 	ir_raw_event_handle(serial_ir.rcdev);
 
