Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2F868D264
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 10:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbjBGJR0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 04:17:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbjBGJRY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 04:17:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A323324484
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 01:17:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DD6D6123A
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 09:17:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ACB5C433D2;
        Tue,  7 Feb 2023 09:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675761440;
        bh=CK0aQMUdZfL6jE794AIMLFgLNn/qE0FG5PsfN2CmafI=;
        h=Subject:To:Cc:From:Date:From;
        b=uFBZMvQizpx/RUoXoNhIbu5SyhwTLHcWkY2idtBovO/gelM/jSbyITaThGS+YAW2o
         bRaAKSall5ISnUo3W2tSYuT/LZYpf75SJKkCTQXBgb4/YkZmqPD4/Q1AIJJNrkB8cJ
         lO0JAMjfG52gy5LKDHorgGYmtR1uq0ERgldxYyDk=
Subject: FAILED: patch "[PATCH] serial: 8250_dma: Fix DMA Rx rearm race" failed to apply to 6.1-stable tree
To:     ilpo.jarvinen@linux.intel.com, gilles.buloz@kontron.com,
        gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Feb 2023 10:17:17 +0100
Message-ID: <1675761437139210@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

57e9af7831dc ("serial: 8250_dma: Fix DMA Rx rearm race")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 57e9af7831dcf211c5c689c2a6f209f4abdf0bce Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Mon, 30 Jan 2023 13:48:41 +0200
Subject: [PATCH] serial: 8250_dma: Fix DMA Rx rearm race
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

As DMA Rx can be completed from two places, it is possible that DMA Rx
completes before DMA completion callback had a chance to complete it.
Once the previous DMA Rx has been completed, a new one can be started
on the next UART interrupt. The following race is possible
(uart_unlock_and_check_sysrq_irqrestore() replaced with
spin_unlock_irqrestore() for simplicity/clarity):

CPU0					CPU1
					dma_rx_complete()
serial8250_handle_irq()
  spin_lock_irqsave(&port->lock)
  handle_rx_dma()
    serial8250_rx_dma_flush()
      __dma_rx_complete()
        dma->rx_running = 0
        // Complete DMA Rx
  spin_unlock_irqrestore(&port->lock)

serial8250_handle_irq()
  spin_lock_irqsave(&port->lock)
  handle_rx_dma()
    serial8250_rx_dma()
      dma->rx_running = 1
      // Setup a new DMA Rx
  spin_unlock_irqrestore(&port->lock)

					  spin_lock_irqsave(&port->lock)
					  // sees dma->rx_running = 1
					  __dma_rx_complete()
					    dma->rx_running = 0
					    // Incorrectly complete
					    // running DMA Rx

This race seems somewhat theoretical to occur for real but handle it
correctly regardless. Check what is the DMA status before complething
anything in __dma_rx_complete().

Reported-by: Gilles BULOZ <gilles.buloz@kontron.com>
Tested-by: Gilles BULOZ <gilles.buloz@kontron.com>
Fixes: 9ee4b83e51f7 ("serial: 8250: Add support for dmaengine")
Cc: stable@vger.kernel.org
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20230130114841.25749-3-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/serial/8250/8250_dma.c b/drivers/tty/serial/8250/8250_dma.c
index 5594883a96f8..7fa66501792d 100644
--- a/drivers/tty/serial/8250/8250_dma.c
+++ b/drivers/tty/serial/8250/8250_dma.c
@@ -43,15 +43,23 @@ static void __dma_rx_complete(struct uart_8250_port *p)
 	struct uart_8250_dma	*dma = p->dma;
 	struct tty_port		*tty_port = &p->port.state->port;
 	struct dma_tx_state	state;
+	enum dma_status		dma_status;
 	int			count;
 
-	dma->rx_running = 0;
-	dmaengine_tx_status(dma->rxchan, dma->rx_cookie, &state);
+	/*
+	 * New DMA Rx can be started during the completion handler before it
+	 * could acquire port's lock and it might still be ongoing. Don't to
+	 * anything in such case.
+	 */
+	dma_status = dmaengine_tx_status(dma->rxchan, dma->rx_cookie, &state);
+	if (dma_status == DMA_IN_PROGRESS)
+		return;
 
 	count = dma->rx_size - state.residue;
 
 	tty_insert_flip_string(tty_port, dma->rx_buf, count);
 	p->port.icount.rx += count;
+	dma->rx_running = 0;
 
 	tty_flip_buffer_push(tty_port);
 }

