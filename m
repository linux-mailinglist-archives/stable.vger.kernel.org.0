Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53C7F68D280
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 10:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbjBGJS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 04:18:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbjBGJSQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 04:18:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3E729422
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 01:18:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0861261202
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 09:18:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00D9C4339C;
        Tue,  7 Feb 2023 09:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675761479;
        bh=JeJ6+q6fujHr4WtQtUQ9zB1dtk8LWF5Az2vCv2u4uLc=;
        h=Subject:To:Cc:From:Date:From;
        b=r5qqOqx0I3A4fCMmk9a4aOq4iFTcXmDv5qjcE4HGjxOWTXgR57uhZ37FEik/+bS3L
         6SlMvXwWW2+IVop/SV0b83tJFl0emwC41Or9mtEzamEwO4uUeNE6OotB5ENodyJYPw
         OM6Kwa5kw93Zc/jQHm1ayetqxKLqqRz1wDuHxGA8=
Subject: FAILED: patch "[PATCH] serial: stm32: Merge hard IRQ and threaded IRQ handling into" failed to apply to 5.15-stable tree
To:     marex@denx.de, bigeasy@linutronix.de, gregkh@linuxfoundation.org,
        valentin.caron@foss.st.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Feb 2023 10:17:50 +0100
Message-ID: <167576147049124@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

3f6c02fa712b ("serial: stm32: Merge hard IRQ and threaded IRQ handling into single IRQ handler")
6333a4850621 ("serial: stm32: push DMA RX data before suspending")
6eeb348c8482 ("serial: stm32: terminate / restart DMA transfer at suspend / resume")
e0abc903deea ("serial: stm32: rework RX dma initialization and release")
d1ec8a2eabe9 ("serial: stm32: update throttle and unthrottle ops for dma mode")
33bb2f6ac308 ("serial: stm32: rework RX over DMA")
cc58d0a3f0a4 ("serial: stm32: re-introduce an irq flag condition in usart_receive_chars")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3f6c02fa712bd453871877fe1d1969625617471e Mon Sep 17 00:00:00 2001
From: Marek Vasut <marex@denx.de>
Date: Fri, 20 Jan 2023 17:03:32 +0100
Subject: [PATCH] serial: stm32: Merge hard IRQ and threaded IRQ handling into
 single IRQ handler

Requesting an interrupt with IRQF_ONESHOT will run the primary handler
in the hard-IRQ context even in the force-threaded mode. The
force-threaded mode is used by PREEMPT_RT in order to avoid acquiring
sleeping locks (spinlock_t) in hard-IRQ context. This combination
makes it impossible and leads to "sleeping while atomic" warnings.

Use one interrupt handler for both handlers (primary and secondary)
and drop the IRQF_ONESHOT flag which is not needed.

Fixes: e359b4411c283 ("serial: stm32: fix threaded interrupt handling")
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-by: Valentin Caron <valentin.caron@foss.st.com> # V3
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230120160332.57930-1-marex@denx.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index a1490033aa16..409e91d6829a 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -797,25 +797,11 @@ static irqreturn_t stm32_usart_interrupt(int irq, void *ptr)
 		spin_unlock(&port->lock);
 	}
 
-	if (stm32_usart_rx_dma_enabled(port))
-		return IRQ_WAKE_THREAD;
-	else
-		return IRQ_HANDLED;
-}
-
-static irqreturn_t stm32_usart_threaded_interrupt(int irq, void *ptr)
-{
-	struct uart_port *port = ptr;
-	struct tty_port *tport = &port->state->port;
-	struct stm32_port *stm32_port = to_stm32_port(port);
-	unsigned int size;
-	unsigned long flags;
-
 	/* Receiver timeout irq for DMA RX */
-	if (!stm32_port->throttled) {
-		spin_lock_irqsave(&port->lock, flags);
+	if (stm32_usart_rx_dma_enabled(port) && !stm32_port->throttled) {
+		spin_lock(&port->lock);
 		size = stm32_usart_receive_chars(port, false);
-		uart_unlock_and_check_sysrq_irqrestore(port, flags);
+		uart_unlock_and_check_sysrq(port);
 		if (size)
 			tty_flip_buffer_push(tport);
 	}
@@ -1015,10 +1001,8 @@ static int stm32_usart_startup(struct uart_port *port)
 	u32 val;
 	int ret;
 
-	ret = request_threaded_irq(port->irq, stm32_usart_interrupt,
-				   stm32_usart_threaded_interrupt,
-				   IRQF_ONESHOT | IRQF_NO_SUSPEND,
-				   name, port);
+	ret = request_irq(port->irq, stm32_usart_interrupt,
+			  IRQF_NO_SUSPEND, name, port);
 	if (ret)
 		return ret;
 
@@ -1601,13 +1585,6 @@ static int stm32_usart_of_dma_rx_probe(struct stm32_port *stm32port,
 	struct dma_slave_config config;
 	int ret;
 
-	/*
-	 * Using DMA and threaded handler for the console could lead to
-	 * deadlocks.
-	 */
-	if (uart_console(port))
-		return -ENODEV;
-
 	stm32port->rx_buf = dma_alloc_coherent(dev, RX_BUF_L,
 					       &stm32port->rx_dma_buf,
 					       GFP_KERNEL);

