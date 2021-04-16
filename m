Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5DA33621E4
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 16:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243658AbhDPOMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 10:12:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244150AbhDPOLx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Apr 2021 10:11:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC27F610FC;
        Fri, 16 Apr 2021 14:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618582288;
        bh=sCFrgohLIfm8pELW6QsrCxvsgUhRMPjg/ZK7BxCTQQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cYo7+Us2pq2cbiKNwLiTp6fHKrOg2bU3kWgYhxNN5vd1hgosIzRUAKNnhj+MWSRVh
         6Ifx+TzCgKvhpE9UCQ+x7JvPzZv3s+o+PySSs9dMJPWubwtZ5o1bwUN8gvBuhwHdRC
         FbXdR3NWY+OOjFUsSb1bGnNrOupNloDC3okntwTFafB74WlWYwzffDbDfHEzhaccL/
         5wrBZgk9ibMgOAeACNcZm2CAC5E1heC3aPbaxIFYNtpY9xJ32Iz95kb17iuWkSd/Mf
         NLtYBms6uw7drrHdGtbmNLxy2kAgJ6a56E5dPzQtiBvlcA3zxgEYaBrSlPccuiF9/b
         Y6tD8MoyzjxCg==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1lXPBx-0006aC-Gh; Fri, 16 Apr 2021 16:11:29 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        dillon.minfei@gmail.com, Erwan Le Ray <erwan.leray@foss.st.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        Gerald Baeza <gerald.baeza@st.com>
Subject: [PATCH 2/3] serial: stm32: fix threaded interrupt handling
Date:   Fri, 16 Apr 2021 16:05:56 +0200
Message-Id: <20210416140557.25177-3-johan@kernel.org>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210416140557.25177-1-johan@kernel.org>
References: <20210416140557.25177-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When DMA is enabled the receive handler runs in a threaded handler, but
the primary handler up until very recently neither disabled interrupts
in the device or used IRQF_ONESHOT. This would lead to a deadlock if an
interrupt comes in while the threaded receive handler is running under
the port lock.

Commit ad7676812437 ("serial: stm32: fix a deadlock condition with
wakeup event") claimed to fix an unrelated deadlock, but unfortunately
also disabled interrupts in the threaded handler. While this prevents
the deadlock mentioned in the previous paragraph it also defeats the
purpose of using a threaded handler in the first place.

Fix this by making the interrupt one-shot and not disabling interrupts
in the threaded handler.

Note that (receive) DMA must not be used for a console port as the
threaded handler could be interrupted while holding the port lock,
something which could lead to a deadlock in case an interrupt handler
ends up calling printk.

Fixes: ad7676812437 ("serial: stm32: fix a deadlock condition with wakeup event")
Fixes: 3489187204eb ("serial: stm32: adding dma support")
Cc: stable@vger.kernel.org      # 4.9
Cc: Alexandre TORGUE <alexandre.torgue@st.com>
Cc: Gerald Baeza <gerald.baeza@st.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/tty/serial/stm32-usart.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index 4d277804c63e..3524ed2c0c73 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -214,14 +214,11 @@ static void stm32_usart_receive_chars(struct uart_port *port, bool threaded)
 	struct tty_port *tport = &port->state->port;
 	struct stm32_port *stm32_port = to_stm32_port(port);
 	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
-	unsigned long c, flags;
+	unsigned long c;
 	u32 sr;
 	char flag;
 
-	if (threaded)
-		spin_lock_irqsave(&port->lock, flags);
-	else
-		spin_lock(&port->lock);
+	spin_lock(&port->lock);
 
 	while (stm32_usart_pending_rx(port, &sr, &stm32_port->last_res,
 				      threaded)) {
@@ -278,10 +275,7 @@ static void stm32_usart_receive_chars(struct uart_port *port, bool threaded)
 		uart_insert_char(port, sr, USART_SR_ORE, c, flag);
 	}
 
-	if (threaded)
-		spin_unlock_irqrestore(&port->lock, flags);
-	else
-		spin_unlock(&port->lock);
+	spin_unlock(&port->lock);
 
 	tty_flip_buffer_push(tport);
 }
@@ -667,7 +661,8 @@ static int stm32_usart_startup(struct uart_port *port)
 
 	ret = request_threaded_irq(port->irq, stm32_usart_interrupt,
 				   stm32_usart_threaded_interrupt,
-				   IRQF_NO_SUSPEND, name, port);
+				   IRQF_ONESHOT | IRQF_NO_SUSPEND,
+				   name, port);
 	if (ret)
 		return ret;
 
@@ -1156,6 +1151,13 @@ static int stm32_usart_of_dma_rx_probe(struct stm32_port *stm32port,
 	struct dma_async_tx_descriptor *desc = NULL;
 	int ret;
 
+	/*
+	 * Using DMA and threaded handler for the console could lead to
+	 * deadlocks.
+	 */
+	if (uart_console(port))
+		return -ENODEV;
+
 	/* Request DMA RX channel */
 	stm32port->rx_ch = dma_request_slave_channel(dev, "rx");
 	if (!stm32port->rx_ch) {
-- 
2.26.3

