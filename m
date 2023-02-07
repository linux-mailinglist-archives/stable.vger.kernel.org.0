Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C20DD68D85F
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbjBGNJG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:09:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232294AbjBGNJF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:09:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F703B0E2
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:08:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4729661403
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:08:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A44FC433D2;
        Tue,  7 Feb 2023 13:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775306;
        bh=SfqGsNZnSaoRf/CpzCthsIqLBl4D4AqPediq7uT4wRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wb4LWgK0KOZDYdoCE8DwOHWKUD0FFe23Is0eSqGJLbuKzj8MQ2U3VxuESCgNi4EYq
         m7i7e0LvThMArX7oZDScak6BGyeEFJ7QbqbquldIHjvOYvMHkBBTTNY2XIWjPqvMZq
         D/k7li4CrKzxwXvIDH6zJ4+/x+Fpvzan2hrY6AUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Marek Vasut <marex@denx.de>,
        Valentin Caron <valentin.caron@foss.st.com>
Subject: [PATCH 6.1 178/208] serial: stm32: Merge hard IRQ and threaded IRQ handling into single IRQ handler
Date:   Tue,  7 Feb 2023 13:57:12 +0100
Message-Id: <20230207125642.511701214@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

commit 3f6c02fa712bd453871877fe1d1969625617471e upstream.

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
---
 drivers/tty/serial/stm32-usart.c |   33 +++++----------------------------
 1 file changed, 5 insertions(+), 28 deletions(-)

--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -798,25 +798,11 @@ static irqreturn_t stm32_usart_interrupt
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
@@ -1016,10 +1002,8 @@ static int stm32_usart_startup(struct ua
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
 
@@ -1602,13 +1586,6 @@ static int stm32_usart_of_dma_rx_probe(s
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


