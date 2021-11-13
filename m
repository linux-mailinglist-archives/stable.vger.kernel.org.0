Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7FEB44F390
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 15:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235861AbhKMOSQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 09:18:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:41576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235743AbhKMOSQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Nov 2021 09:18:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87D3160EC0;
        Sat, 13 Nov 2021 14:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636812924;
        bh=uDxTYIy0mW6LzK0l1WutOGUrcmYatT634LShc5UGfOg=;
        h=Subject:To:Cc:From:Date:From;
        b=YEmSZt/bNShIQDe4GM/bJ/kZz8hRGfmesSU9C4CtX0UU7ZLRo6kVG1guTqdKmAp1c
         AhXEjPNMEiAtFFuMt3WPRM/s2WWUpfsJroneCvgl1lW3sy/elsX4JiT30kFwVN0A49
         ji2RdMzRKtSxxXphxhHJwxgdFNGEBb+sdB0sxKY0=
Subject: FAILED: patch "[PATCH] media: ir_toy: prevent device from hanging during transmit" failed to apply to 5.15-stable tree
To:     sean@mess.org, mchehab+huawei@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Nov 2021 15:15:21 +0100
Message-ID: <163681292110191@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4114978dcd24e72415276bba60ff4ff355970bbc Mon Sep 17 00:00:00 2001
From: Sean Young <sean@mess.org>
Date: Tue, 14 Sep 2021 16:57:46 +0200
Subject: [PATCH] media: ir_toy: prevent device from hanging during transmit

If the IR Toy is receiving IR while a transmit is done, it may end up
hanging. We can prevent this from happening by re-entering sample mode
just before issuing the transmit command.

Link: https://github.com/bengtmartensson/HarcHardware/discussions/25

Cc: stable@vger.kernel.org
[mchehab: renamed: s/STATE_RESET/STATE_COMMAND_NO_RESP/ ]
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

diff --git a/drivers/media/rc/ir_toy.c b/drivers/media/rc/ir_toy.c
index d2d9346eb8f5..71aced52248f 100644
--- a/drivers/media/rc/ir_toy.c
+++ b/drivers/media/rc/ir_toy.c
@@ -26,6 +26,7 @@ static const u8 COMMAND_VERSION[] = { 'v' };
 // End transmit and repeat reset command so we exit sump mode
 static const u8 COMMAND_RESET[] = { 0xff, 0xff, 0, 0, 0, 0, 0 };
 static const u8 COMMAND_SMODE_ENTER[] = { 's' };
+static const u8 COMMAND_SMODE_EXIT[] = { 0 };
 static const u8 COMMAND_TXSTART[] = { 0x26, 0x24, 0x25, 0x03 };
 
 #define REPLY_XMITCOUNT 't'
@@ -317,12 +318,30 @@ static int irtoy_tx(struct rc_dev *rc, uint *txbuf, uint count)
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
+			    sizeof(COMMAND_SMODE_EXIT), STATE_COMMAND_NO_RESP);
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

