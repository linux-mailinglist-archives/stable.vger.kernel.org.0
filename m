Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 846AA3A030A
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237059AbhFHTMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:12:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:59566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237519AbhFHTJy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:09:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5623861941;
        Tue,  8 Jun 2021 18:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178115;
        bh=mpooxyqvfrAzMhHxntMDVhFerXLYMjxumW4cPBYV+RU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hMniwmm1p+CN91QyU3nSojwXR07nw7LIA7WfcgN4FyG26ruCIMlkfRUA5Qyx8MzsV
         /vUM6r1qE8gbYMRSmRkfUTZuhEp+9dBbvk1s6pOelmK9Au2gCRRd3Bz1k07NSldO9K
         lUyowDpaTJvuIpDAVd+g/TnhzWZW50mISk+SibuU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexandre TORGUE <alexandre.torgue@st.com>,
        Gerald Baeza <gerald.baeza@st.com>,
        Valentin Caron <valentin.caron@foss.st.com>,
        Johan Hovold <johan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 081/161] serial: stm32: fix threaded interrupt handling
Date:   Tue,  8 Jun 2021 20:26:51 +0200
Message-Id: <20210608175948.180271741@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

[ Upstream commit e359b4411c2836cf87c8776682d1b594635570de ]

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
Reviewed-by: Valentin Caron<valentin.caron@foss.st.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210416140557.25177-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/stm32-usart.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index 99dfa884cbef..68c6535bbf7f 100644
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
@@ -654,7 +648,8 @@ static int stm32_usart_startup(struct uart_port *port)
 
 	ret = request_threaded_irq(port->irq, stm32_usart_interrupt,
 				   stm32_usart_threaded_interrupt,
-				   IRQF_NO_SUSPEND, name, port);
+				   IRQF_ONESHOT | IRQF_NO_SUSPEND,
+				   name, port);
 	if (ret)
 		return ret;
 
@@ -1136,6 +1131,13 @@ static int stm32_usart_of_dma_rx_probe(struct stm32_port *stm32port,
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
2.30.2



