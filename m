Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3D2420E60
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236638AbhJDNYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:24:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:36558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236776AbhJDNXD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:23:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 288C360F9C;
        Mon,  4 Oct 2021 13:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352996;
        bh=32F6x39IuP+xV2Coi3AfhZCg5iYWqEXEbn+cTJ3EV5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bCYqBjqAAOqac86qZtkTL9uplmIUtjB3v4X2CX7ncVcouAeK+jfVshzOwMJlq/ioA
         erUP+1/T9ItaQEuXX7CNdTbjcIQioEelXC5hVxQ60jaPjyUPvabZ4nZkZt7ZNUJpDG
         XyAjYoyLuMQ41oozUE/T+j4JPSCPqTwosxII6+TM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 21/93] media: ir_toy: prevent device from hanging during transmit
Date:   Mon,  4 Oct 2021 14:52:19 +0200
Message-Id: <20211004125035.277224706@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Young <sean@mess.org>

commit f0c15b360fb65ee39849afe987c16eb3d0175d0d upstream.

If the IR Toy is receiving IR while a transmit is done, it may end up
hanging. We can prevent this from happening by re-entering sample mode
just before issuing the transmit command.

Link: https://github.com/bengtmartensson/HarcHardware/discussions/25

Cc: stable@vger.kernel.org
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/ir_toy.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

--- a/drivers/media/rc/ir_toy.c
+++ b/drivers/media/rc/ir_toy.c
@@ -24,6 +24,7 @@ static const u8 COMMAND_VERSION[] = { 'v
 // End transmit and repeat reset command so we exit sump mode
 static const u8 COMMAND_RESET[] = { 0xff, 0xff, 0, 0, 0, 0, 0 };
 static const u8 COMMAND_SMODE_ENTER[] = { 's' };
+static const u8 COMMAND_SMODE_EXIT[] = { 0 };
 static const u8 COMMAND_TXSTART[] = { 0x26, 0x24, 0x25, 0x03 };
 
 #define REPLY_XMITCOUNT 't'
@@ -309,12 +310,30 @@ static int irtoy_tx(struct rc_dev *rc, u
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


