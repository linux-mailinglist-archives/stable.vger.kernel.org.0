Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08E1F51A8A1
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355486AbiEDRNB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356821AbiEDRJp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9783222A9;
        Wed,  4 May 2022 09:55:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98CF7B82795;
        Wed,  4 May 2022 16:55:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A4BC385A4;
        Wed,  4 May 2022 16:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683348;
        bh=G71WT7nFX4UN9eB8Tn1SQhYCaU4g34pC/vPb7hR0lQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UQ6QW0aXF5QZWfbMg8EaqbcJsUyXVmkndiycEuPubu5cHld0/x1lIvg74XPaNvtZ6
         U6lGoLiTWGrCcZcuEpVPW7gF/1qLpKL1p1SAi+r642vTN6vCCf/ELmYu/5K1eWgPj3
         o2nZWinhkbO5Zm1NLXWCTtmFGC45IieQUZdqCrNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH 5.17 035/225] serial: amba-pl011: do not time out prematurely when draining tx fifo
Date:   Wed,  4 May 2022 18:44:33 +0200
Message-Id: <20220504153113.350828662@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lino Sanfilippo <LinoSanfilippo@gmx.de>

commit 0e4deb56b0c625efdb70c94f150429e2f2a16fa1 upstream.

The current timeout for draining the tx fifo in RS485 mode is calculated by
multiplying the time it takes to transmit one character (with the given
baud rate) with the maximal number of characters in the tx queue.

This timeout is too short for two reasons:
First when calculating the time to transmit one character integer division
is used which may round down the result in case of a remainder of the
division.

Fix this by rounding up the division result.

Second the hardware may need additional time (e.g for first putting the
characters from the fifo into the shift register) before the characters are
actually put onto the wire.

To be on the safe side double the current maximum number of iterations
that are used to wait for the queue draining.

Fixes: 8d479237727c ("serial: amba-pl011: add RS485 support")
Cc: stable@vger.kernel.org
Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Link: https://lore.kernel.org/r/20220408233503.7251-1-LinoSanfilippo@gmx.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/amba-pl011.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1255,13 +1255,18 @@ static inline bool pl011_dma_rx_running(
 
 static void pl011_rs485_tx_stop(struct uart_amba_port *uap)
 {
+	/*
+	 * To be on the safe side only time out after twice as many iterations
+	 * as fifo size.
+	 */
+	const int MAX_TX_DRAIN_ITERS = uap->port.fifosize * 2;
 	struct uart_port *port = &uap->port;
 	int i = 0;
 	u32 cr;
 
 	/* Wait until hardware tx queue is empty */
 	while (!pl011_tx_empty(port)) {
-		if (i == port->fifosize) {
+		if (i > MAX_TX_DRAIN_ITERS) {
 			dev_warn(port->dev,
 				 "timeout while draining hardware tx queue\n");
 			break;
@@ -2052,7 +2057,7 @@ pl011_set_termios(struct uart_port *port
 	 * with the given baud rate. We use this as the poll interval when we
 	 * wait for the tx queue to empty.
 	 */
-	uap->rs485_tx_drain_interval = (bits * 1000 * 1000) / baud;
+	uap->rs485_tx_drain_interval = DIV_ROUND_UP(bits * 1000 * 1000, baud);
 
 	pl011_setup_status_masks(port, termios);
 


