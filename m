Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733D4410ADE
	for <lists+stable@lfdr.de>; Sun, 19 Sep 2021 11:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbhISJWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Sep 2021 05:22:47 -0400
Received: from www.linuxtv.org ([130.149.80.248]:44284 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237226AbhISJWr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 19 Sep 2021 05:22:47 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1mRt0i-00GaAO-GY; Sun, 19 Sep 2021 09:21:20 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Sun, 19 Sep 2021 09:19:37 +0000
Subject: [git:media_tree/fixes] media: ir_toy: prevent device from hanging during transmit
To:     linuxtv-commits@linuxtv.org
Cc:     stable@vger.kernel.org, Sean Young <sean@mess.org>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1mRt0i-00GaAO-GY@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: ir_toy: prevent device from hanging during transmit
Author:  Sean Young <sean@mess.org>
Date:    Tue Sep 14 16:57:46 2021 +0200

If the IR Toy is receiving IR while a transmit is done, it may end up
hanging. We can prevent this from happening by re-entering sample mode
just before issuing the transmit command.

Link: https://github.com/bengtmartensson/HarcHardware/discussions/25

Cc: stable@vger.kernel.org
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/rc/ir_toy.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

---

diff --git a/drivers/media/rc/ir_toy.c b/drivers/media/rc/ir_toy.c
index 3e729a17b35f..48d52baec1a1 100644
--- a/drivers/media/rc/ir_toy.c
+++ b/drivers/media/rc/ir_toy.c
@@ -24,6 +24,7 @@ static const u8 COMMAND_VERSION[] = { 'v' };
 // End transmit and repeat reset command so we exit sump mode
 static const u8 COMMAND_RESET[] = { 0xff, 0xff, 0, 0, 0, 0, 0 };
 static const u8 COMMAND_SMODE_ENTER[] = { 's' };
+static const u8 COMMAND_SMODE_EXIT[] = { 0 };
 static const u8 COMMAND_TXSTART[] = { 0x26, 0x24, 0x25, 0x03 };
 
 #define REPLY_XMITCOUNT 't'
@@ -309,12 +310,30 @@ static int irtoy_tx(struct rc_dev *rc, uint *txbuf, uint count)
 		buf[i] = cpu_to_be16(v);
 	}
 
-	buf[count] = cpu_to_be16(0xffff);
+	buf[count] = 0xffff;
 
 	irtoy->tx_buf = buf;
 	irtoy->tx_len = size;
 	irtoy->emitted = 0;
 
+	// There is an issue where if the unit is receiving IR while the
+	// first TXSTART command is sent, the device might end up hanging
+	// with its led on. It does not respond to any command when this
+	// happens. To work around this, re-enter sample mode.
+	err = irtoy_command(irtoy, COMMAND_SMODE_EXIT,
+			    sizeof(COMMAND_SMODE_EXIT), STATE_RESET);
+	if (err) {
+		dev_err(irtoy->dev, "exit sample mode: %d\n", err);
+		return err;
+	}
+
+	err = irtoy_command(irtoy, COMMAND_SMODE_ENTER,
+			    sizeof(COMMAND_SMODE_ENTER), STATE_COMMAND);
+	if (err) {
+		dev_err(irtoy->dev, "enter sample mode: %d\n", err);
+		return err;
+	}
+
 	err = irtoy_command(irtoy, COMMAND_TXSTART, sizeof(COMMAND_TXSTART),
 			    STATE_TX);
 	kfree(buf);
