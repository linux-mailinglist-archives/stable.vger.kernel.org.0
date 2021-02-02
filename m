Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB3930BFFA
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232719AbhBBNrO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:47:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:36544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232810AbhBBNp3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:45:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C81A064F86;
        Tue,  2 Feb 2021 13:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273272;
        bh=mSVsqdCkWr5ExGN9jPmKgK/wKRDTDcHHJBhNXktIXSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=inmbKcr22NxJbI9Kmh/dmwClLAYNTmAzIY2OmRlEYyyvEYYN94PXBOjfNHbFUy+ox
         BHrnbsHHcofacn4u4HPJQ0vZtcPK1r0UhxoG3GBlE86hbXkVWkB9RWkf/QK89GpKFE
         WQc4M834RyvH86AlVCDqiMpVG5xcVtUvLgdw4jr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthias Reichl <hias@horus.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 013/142] media: rc: fix timeout handling after switch to microsecond durations
Date:   Tue,  2 Feb 2021 14:36:16 +0100
Message-Id: <20210202132958.250020266@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Reichl <hias@horus.com>

commit 06b831588b639ad9d94e4789b0250562228722c2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/rc/ir-mce_kbd-decoder.c |    2 +-
 drivers/media/rc/rc-main.c            |    4 ++--
 drivers/media/rc/serial_ir.c          |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

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
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -737,7 +737,7 @@ static unsigned int repeat_period(int pr
 void rc_repeat(struct rc_dev *dev)
 {
 	unsigned long flags;
-	unsigned int timeout = nsecs_to_jiffies(dev->timeout) +
+	unsigned int timeout = usecs_to_jiffies(dev->timeout) +
 		msecs_to_jiffies(repeat_period(dev->last_protocol));
 	struct lirc_scancode sc = {
 		.scancode = dev->last_scancode, .rc_proto = dev->last_protocol,
@@ -855,7 +855,7 @@ void rc_keydown(struct rc_dev *dev, enum
 	ir_do_keydown(dev, protocol, scancode, keycode, toggle);
 
 	if (dev->keypressed) {
-		dev->keyup_jiffies = jiffies + nsecs_to_jiffies(dev->timeout) +
+		dev->keyup_jiffies = jiffies + usecs_to_jiffies(dev->timeout) +
 			msecs_to_jiffies(repeat_period(protocol));
 		mod_timer(&dev->timer_keyup, dev->keyup_jiffies);
 	}
--- a/drivers/media/rc/serial_ir.c
+++ b/drivers/media/rc/serial_ir.c
@@ -385,7 +385,7 @@ static irqreturn_t serial_ir_irq_handler
 	} while (!(sinp(UART_IIR) & UART_IIR_NO_INT)); /* still pending ? */
 
 	mod_timer(&serial_ir.timeout_timer,
-		  jiffies + nsecs_to_jiffies(serial_ir.rcdev->timeout));
+		  jiffies + usecs_to_jiffies(serial_ir.rcdev->timeout));
 
 	ir_raw_event_handle(serial_ir.rcdev);
 


