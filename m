Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83C164A3060
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 16:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345961AbiA2P5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 10:57:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347844AbiA2P5A (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 10:57:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3A90C061714
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 07:56:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EBB9B827C5
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 15:56:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F92C340E5;
        Sat, 29 Jan 2022 15:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643471817;
        bh=XhyBmLH2vK6QOS23m31R/1b88ilWT1ZLworRxnF2YfI=;
        h=Subject:To:Cc:From:Date:From;
        b=ebwliTST5DljWaLESsMMWRmoL9rxDL2nOvLwpZyUSErWT6BmnGOTFgZmleFTToYJT
         sbG5w15xFyqQlhB9xhBsFNmdHTA80lgjoSWShkddFBPI1oJT2ZwswIjHHb6LpyrtkH
         o2rNvGv/k451gntcqx6hJSIO8c2n+/BQ1P6ugoeE=
Subject: FAILED: patch "[PATCH] serial: stm32: prevent TDR register overwrite when sending" failed to apply to 5.16-stable tree
To:     valentin.caron@foss.st.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 Jan 2022 16:56:49 +0100
Message-ID: <164347180913821@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.16-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d3d079bde07e1b7deaeb57506dc0b86010121d17 Mon Sep 17 00:00:00 2001
From: Valentin Caron <valentin.caron@foss.st.com>
Date: Tue, 11 Jan 2022 17:44:40 +0100
Subject: [PATCH] serial: stm32: prevent TDR register overwrite when sending
 x_char

When sending x_char in stm32_usart_transmit_chars(), driver can overwrite
the value of TDR register by the value of x_char. If this happens, the
previous value that was present in TDR register will not be sent through
uart.

This code checks if the previous value in TDR register is sent before
writing the x_char value into register.

Fixes: 48a6092fb41f ("serial: stm32-usart: Add STM32 USART Driver")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Valentin Caron <valentin.caron@foss.st.com>
Link: https://lore.kernel.org/r/20220111164441.6178-2-valentin.caron@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index 1f89ab0e49ac..c1b8828451c8 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -550,11 +550,23 @@ static void stm32_usart_transmit_chars(struct uart_port *port)
 	struct stm32_port *stm32_port = to_stm32_port(port);
 	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
 	struct circ_buf *xmit = &port->state->xmit;
+	u32 isr;
+	int ret;
 
 	if (port->x_char) {
 		if (stm32_usart_tx_dma_started(stm32_port) &&
 		    stm32_usart_tx_dma_enabled(stm32_port))
 			stm32_usart_clr_bits(port, ofs->cr3, USART_CR3_DMAT);
+
+		/* Check that TDR is empty before filling FIFO */
+		ret =
+		readl_relaxed_poll_timeout_atomic(port->membase + ofs->isr,
+						  isr,
+						  (isr & USART_SR_TXE),
+						  10, 1000);
+		if (ret)
+			dev_warn(port->dev, "1 character may be erased\n");
+
 		writel_relaxed(port->x_char, port->membase + ofs->tdr);
 		port->x_char = 0;
 		port->icount.tx++;

