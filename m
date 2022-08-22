Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2691859BB98
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 10:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232953AbiHVI3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 04:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233429AbiHVI26 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 04:28:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 101DE101D4
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 01:28:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37EE1B80EA1
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 08:28:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8E3C433C1;
        Mon, 22 Aug 2022 08:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661156932;
        bh=2DTw7OLgWydlI7U/LHbQkU4LBhTEpj09ilA3Rgj9LK0=;
        h=Subject:To:Cc:From:Date:From;
        b=WqGRNTNNNpg0a8FFgaCysFbyaJjJAHfX0j/M5K1I//nyIami7YCn3zaRViaPeAcOk
         zcnxjcyqYUM8ICQnaTLnS1M/7LuKCLVb5B05z8Zxa+cvBdX9hrjjUxcJvpQVKSbU1U
         PwNULcFxz4G3YdE3NyCbjj1i1jNfqPHw/WE5pBbE=
Subject: FAILED: patch "[PATCH] can: mcp251x: Fix race condition on receive interrupt" failed to apply to 4.9-stable tree
To:     sebastian.wuerl@ororatech.com, mkl@pengutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 10:28:39 +0200
Message-ID: <1661156919203119@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d80d60b0db6ff3dd2e29247cc2a5166d7e9ae37e Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Sebastian=20W=C3=BCrl?= <sebastian.wuerl@ororatech.com>
Date: Thu, 4 Aug 2022 10:14:11 +0200
Subject: [PATCH] can: mcp251x: Fix race condition on receive interrupt
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The mcp251x driver uses both receiving mailboxes of the CAN controller
chips. For retrieving the CAN frames from the controller via SPI, it checks
once per interrupt which mailboxes have been filled and will retrieve the
messages accordingly.

This introduces a race condition, as another CAN frame can enter mailbox 1
while mailbox 0 is emptied. If now another CAN frame enters mailbox 0 until
the interrupt handler is called next, mailbox 0 is emptied before
mailbox 1, leading to out-of-order CAN frames in the network device.

This is fixed by checking the interrupt flags once again after freeing
mailbox 0, to correctly also empty mailbox 1 before leaving the handler.

For reproducing the bug I created the following setup:
 - Two CAN devices, one Raspberry Pi with MCP2515, the other can be any.
 - Setup CAN to 1 MHz
 - Spam bursts of 5 CAN-messages with increasing CAN-ids
 - Continue sending the bursts while sleeping a second between the bursts
 - Check on the RPi whether the received messages have increasing CAN-ids
 - Without this patch, every burst of messages will contain a flipped pair

v3: https://lore.kernel.org/all/20220804075914.67569-1-sebastian.wuerl@ororatech.com
v2: https://lore.kernel.org/all/20220804064803.63157-1-sebastian.wuerl@ororatech.com
v1: https://lore.kernel.org/all/20220803153300.58732-1-sebastian.wuerl@ororatech.com

Fixes: bf66f3736a94 ("can: mcp251x: Move to threaded interrupts instead of workqueues.")
Signed-off-by: Sebastian Würl <sebastian.wuerl@ororatech.com>
Link: https://lore.kernel.org/all/20220804081411.68567-1-sebastian.wuerl@ororatech.com
[mkl: reduce scope of intf1, eflag1]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index e750d13c8841..c320de474f40 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -1070,9 +1070,6 @@ static irqreturn_t mcp251x_can_ist(int irq, void *dev_id)
 
 		mcp251x_read_2regs(spi, CANINTF, &intf, &eflag);
 
-		/* mask out flags we don't care about */
-		intf &= CANINTF_RX | CANINTF_TX | CANINTF_ERR;
-
 		/* receive buffer 0 */
 		if (intf & CANINTF_RX0IF) {
 			mcp251x_hw_rx(spi, 0);
@@ -1082,6 +1079,18 @@ static irqreturn_t mcp251x_can_ist(int irq, void *dev_id)
 			if (mcp251x_is_2510(spi))
 				mcp251x_write_bits(spi, CANINTF,
 						   CANINTF_RX0IF, 0x00);
+
+			/* check if buffer 1 is already known to be full, no need to re-read */
+			if (!(intf & CANINTF_RX1IF)) {
+				u8 intf1, eflag1;
+
+				/* intf needs to be read again to avoid a race condition */
+				mcp251x_read_2regs(spi, CANINTF, &intf1, &eflag1);
+
+				/* combine flags from both operations for error handling */
+				intf |= intf1;
+				eflag |= eflag1;
+			}
 		}
 
 		/* receive buffer 1 */
@@ -1092,6 +1101,9 @@ static irqreturn_t mcp251x_can_ist(int irq, void *dev_id)
 				clear_intf |= CANINTF_RX1IF;
 		}
 
+		/* mask out flags we don't care about */
+		intf &= CANINTF_RX | CANINTF_TX | CANINTF_ERR;
+
 		/* any error or tx interrupt we need to clear? */
 		if (intf & (CANINTF_ERR | CANINTF_TX))
 			clear_intf |= intf & (CANINTF_ERR | CANINTF_TX);

