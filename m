Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFEB37C39E
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233933AbhELPVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:21:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233540AbhELPS2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:18:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E73FF61993;
        Wed, 12 May 2021 15:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832069;
        bh=DPr4VYmwNAR06tZp4yKzu+Svf4rcmFHQRgU4STb2xi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DhHVhOANar8NMFR6EGGKXYCqQAwkPoFHaHu/2Vs9ga9G3n36Dg1hXFTzlT7Y3Fqov
         ykVdsczYTOQyblAQ9z1W9VYTg/dCuPeeX3zbSlhkIfa4F0GUsu3Sq0fb3rGxi8oWE2
         qBgEV7U9G7lzgvJCNgeWqsBQ+ei4LZ9CP0JGveK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erwan Le Ray <erwan.leray@foss.st.com>,
        Valentin Caron <valentin.caron@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 129/530] serial: stm32: add "_usart" prefix in functions name
Date:   Wed, 12 May 2021 16:43:59 +0200
Message-Id: <20210512144824.055831420@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erwan Le Ray <erwan.leray@foss.st.com>

[ Upstream commit 56f9a76c27b51bc8e9bb938734e3de03819569ae ]

Adds the prefix "_usart" in the name of stm32 usart functions in order to
ease the usage of kernel trace and tools, such as f-trace.
Allows to trace "stm32_usart_*" functions with f-trace. Without this patch,
all the driver functions needs to be added manually in f-trace filter.

Signed-off-by: Erwan Le Ray <erwan.leray@foss.st.com>
Signed-off-by: Valentin Caron <valentin.caron@foss.st.com>
Link: https://lore.kernel.org/r/20210106162203.28854-4-erwan.leray@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/stm32-usart.c | 348 ++++++++++++++++---------------
 1 file changed, 177 insertions(+), 171 deletions(-)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index a0ef86d71317..717a97759928 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -34,15 +34,15 @@
 #include "serial_mctrl_gpio.h"
 #include "stm32-usart.h"
 
-static void stm32_stop_tx(struct uart_port *port);
-static void stm32_transmit_chars(struct uart_port *port);
+static void stm32_usart_stop_tx(struct uart_port *port);
+static void stm32_usart_transmit_chars(struct uart_port *port);
 
 static inline struct stm32_port *to_stm32_port(struct uart_port *port)
 {
 	return container_of(port, struct stm32_port, port);
 }
 
-static void stm32_set_bits(struct uart_port *port, u32 reg, u32 bits)
+static void stm32_usart_set_bits(struct uart_port *port, u32 reg, u32 bits)
 {
 	u32 val;
 
@@ -51,7 +51,7 @@ static void stm32_set_bits(struct uart_port *port, u32 reg, u32 bits)
 	writel_relaxed(val, port->membase + reg);
 }
 
-static void stm32_clr_bits(struct uart_port *port, u32 reg, u32 bits)
+static void stm32_usart_clr_bits(struct uart_port *port, u32 reg, u32 bits)
 {
 	u32 val;
 
@@ -60,8 +60,8 @@ static void stm32_clr_bits(struct uart_port *port, u32 reg, u32 bits)
 	writel_relaxed(val, port->membase + reg);
 }
 
-static void stm32_config_reg_rs485(u32 *cr1, u32 *cr3, u32 delay_ADE,
-				   u32 delay_DDE, u32 baud)
+static void stm32_usart_config_reg_rs485(u32 *cr1, u32 *cr3, u32 delay_ADE,
+					 u32 delay_DDE, u32 baud)
 {
 	u32 rs485_deat_dedt;
 	u32 rs485_deat_dedt_max = (USART_CR1_DEAT_MASK >> USART_CR1_DEAT_SHIFT);
@@ -95,8 +95,8 @@ static void stm32_config_reg_rs485(u32 *cr1, u32 *cr3, u32 delay_ADE,
 	*cr1 |= rs485_deat_dedt;
 }
 
-static int stm32_config_rs485(struct uart_port *port,
-			      struct serial_rs485 *rs485conf)
+static int stm32_usart_config_rs485(struct uart_port *port,
+				    struct serial_rs485 *rs485conf)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
 	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
@@ -104,7 +104,7 @@ static int stm32_config_rs485(struct uart_port *port,
 	u32 usartdiv, baud, cr1, cr3;
 	bool over8;
 
-	stm32_clr_bits(port, ofs->cr1, BIT(cfg->uart_enable_bit));
+	stm32_usart_clr_bits(port, ofs->cr1, BIT(cfg->uart_enable_bit));
 
 	port->rs485 = *rs485conf;
 
@@ -122,9 +122,10 @@ static int stm32_config_rs485(struct uart_port *port,
 				   << USART_BRR_04_R_SHIFT;
 
 		baud = DIV_ROUND_CLOSEST(port->uartclk, usartdiv);
-		stm32_config_reg_rs485(&cr1, &cr3,
-				       rs485conf->delay_rts_before_send,
-				       rs485conf->delay_rts_after_send, baud);
+		stm32_usart_config_reg_rs485(&cr1, &cr3,
+					     rs485conf->delay_rts_before_send,
+					     rs485conf->delay_rts_after_send,
+					     baud);
 
 		if (rs485conf->flags & SER_RS485_RTS_ON_SEND) {
 			cr3 &= ~USART_CR3_DEP;
@@ -137,18 +138,19 @@ static int stm32_config_rs485(struct uart_port *port,
 		writel_relaxed(cr3, port->membase + ofs->cr3);
 		writel_relaxed(cr1, port->membase + ofs->cr1);
 	} else {
-		stm32_clr_bits(port, ofs->cr3, USART_CR3_DEM | USART_CR3_DEP);
-		stm32_clr_bits(port, ofs->cr1,
-			       USART_CR1_DEDT_MASK | USART_CR1_DEAT_MASK);
+		stm32_usart_clr_bits(port, ofs->cr3,
+				     USART_CR3_DEM | USART_CR3_DEP);
+		stm32_usart_clr_bits(port, ofs->cr1,
+				     USART_CR1_DEDT_MASK | USART_CR1_DEAT_MASK);
 	}
 
-	stm32_set_bits(port, ofs->cr1, BIT(cfg->uart_enable_bit));
+	stm32_usart_set_bits(port, ofs->cr1, BIT(cfg->uart_enable_bit));
 
 	return 0;
 }
 
-static int stm32_init_rs485(struct uart_port *port,
-			    struct platform_device *pdev)
+static int stm32_usart_init_rs485(struct uart_port *port,
+				  struct platform_device *pdev)
 {
 	struct serial_rs485 *rs485conf = &port->rs485;
 
@@ -162,8 +164,8 @@ static int stm32_init_rs485(struct uart_port *port,
 	return uart_get_rs485_mode(port);
 }
 
-static int stm32_pending_rx(struct uart_port *port, u32 *sr, int *last_res,
-			    bool threaded)
+static int stm32_usart_pending_rx(struct uart_port *port, u32 *sr,
+				  int *last_res, bool threaded)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
 	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
@@ -186,8 +188,8 @@ static int stm32_pending_rx(struct uart_port *port, u32 *sr, int *last_res,
 	return 0;
 }
 
-static unsigned long stm32_get_char(struct uart_port *port, u32 *sr,
-				    int *last_res)
+static unsigned long stm32_usart_get_char(struct uart_port *port, u32 *sr,
+					  int *last_res)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
 	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
@@ -206,7 +208,7 @@ static unsigned long stm32_get_char(struct uart_port *port, u32 *sr,
 	return c;
 }
 
-static void stm32_receive_chars(struct uart_port *port, bool threaded)
+static void stm32_usart_receive_chars(struct uart_port *port, bool threaded)
 {
 	struct tty_port *tport = &port->state->port;
 	struct stm32_port *stm32_port = to_stm32_port(port);
@@ -218,7 +220,8 @@ static void stm32_receive_chars(struct uart_port *port, bool threaded)
 	if (irqd_is_wakeup_set(irq_get_irq_data(port->irq)))
 		pm_wakeup_event(tport->tty->dev, 0);
 
-	while (stm32_pending_rx(port, &sr, &stm32_port->last_res, threaded)) {
+	while (stm32_usart_pending_rx(port, &sr, &stm32_port->last_res,
+				      threaded)) {
 		sr |= USART_SR_DUMMY_RX;
 		flag = TTY_NORMAL;
 
@@ -237,7 +240,7 @@ static void stm32_receive_chars(struct uart_port *port, bool threaded)
 			writel_relaxed(sr & USART_SR_ERR_MASK,
 				       port->membase + ofs->icr);
 
-		c = stm32_get_char(port, &sr, &stm32_port->last_res);
+		c = stm32_usart_get_char(port, &sr, &stm32_port->last_res);
 		port->icount.rx++;
 		if (sr & USART_SR_ERR_MASK) {
 			if (sr & USART_SR_ORE) {
@@ -277,20 +280,20 @@ static void stm32_receive_chars(struct uart_port *port, bool threaded)
 	spin_lock(&port->lock);
 }
 
-static void stm32_tx_dma_complete(void *arg)
+static void stm32_usart_tx_dma_complete(void *arg)
 {
 	struct uart_port *port = arg;
 	struct stm32_port *stm32port = to_stm32_port(port);
 	struct stm32_usart_offsets *ofs = &stm32port->info->ofs;
 
-	stm32_clr_bits(port, ofs->cr3, USART_CR3_DMAT);
+	stm32_usart_clr_bits(port, ofs->cr3, USART_CR3_DMAT);
 	stm32port->tx_dma_busy = false;
 
 	/* Let's see if we have pending data to send */
-	stm32_transmit_chars(port);
+	stm32_usart_transmit_chars(port);
 }
 
-static void stm32_tx_interrupt_enable(struct uart_port *port)
+static void stm32_usart_tx_interrupt_enable(struct uart_port *port)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
 	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
@@ -300,30 +303,30 @@ static void stm32_tx_interrupt_enable(struct uart_port *port)
 	 * or TX empty irq when FIFO is disabled
 	 */
 	if (stm32_port->fifoen)
-		stm32_set_bits(port, ofs->cr3, USART_CR3_TXFTIE);
+		stm32_usart_set_bits(port, ofs->cr3, USART_CR3_TXFTIE);
 	else
-		stm32_set_bits(port, ofs->cr1, USART_CR1_TXEIE);
+		stm32_usart_set_bits(port, ofs->cr1, USART_CR1_TXEIE);
 }
 
-static void stm32_tx_interrupt_disable(struct uart_port *port)
+static void stm32_usart_tx_interrupt_disable(struct uart_port *port)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
 	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
 
 	if (stm32_port->fifoen)
-		stm32_clr_bits(port, ofs->cr3, USART_CR3_TXFTIE);
+		stm32_usart_clr_bits(port, ofs->cr3, USART_CR3_TXFTIE);
 	else
-		stm32_clr_bits(port, ofs->cr1, USART_CR1_TXEIE);
+		stm32_usart_clr_bits(port, ofs->cr1, USART_CR1_TXEIE);
 }
 
-static void stm32_transmit_chars_pio(struct uart_port *port)
+static void stm32_usart_transmit_chars_pio(struct uart_port *port)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
 	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
 	struct circ_buf *xmit = &port->state->xmit;
 
 	if (stm32_port->tx_dma_busy) {
-		stm32_clr_bits(port, ofs->cr3, USART_CR3_DMAT);
+		stm32_usart_clr_bits(port, ofs->cr3, USART_CR3_DMAT);
 		stm32_port->tx_dma_busy = false;
 	}
 
@@ -338,12 +341,12 @@ static void stm32_transmit_chars_pio(struct uart_port *port)
 
 	/* rely on TXE irq (mask or unmask) for sending remaining data */
 	if (uart_circ_empty(xmit))
-		stm32_tx_interrupt_disable(port);
+		stm32_usart_tx_interrupt_disable(port);
 	else
-		stm32_tx_interrupt_enable(port);
+		stm32_usart_tx_interrupt_enable(port);
 }
 
-static void stm32_transmit_chars_dma(struct uart_port *port)
+static void stm32_usart_transmit_chars_dma(struct uart_port *port)
 {
 	struct stm32_port *stm32port = to_stm32_port(port);
 	struct stm32_usart_offsets *ofs = &stm32port->info->ofs;
@@ -385,7 +388,7 @@ static void stm32_transmit_chars_dma(struct uart_port *port)
 	if (!desc)
 		goto fallback_err;
 
-	desc->callback = stm32_tx_dma_complete;
+	desc->callback = stm32_usart_tx_dma_complete;
 	desc->callback_param = port;
 
 	/* Push current DMA TX transaction in the pending queue */
@@ -398,7 +401,7 @@ static void stm32_transmit_chars_dma(struct uart_port *port)
 	/* Issue pending DMA TX requests */
 	dma_async_issue_pending(stm32port->tx_ch);
 
-	stm32_set_bits(port, ofs->cr3, USART_CR3_DMAT);
+	stm32_usart_set_bits(port, ofs->cr3, USART_CR3_DMAT);
 
 	xmit->tail = (xmit->tail + count) & (UART_XMIT_SIZE - 1);
 	port->icount.tx += count;
@@ -406,10 +409,10 @@ static void stm32_transmit_chars_dma(struct uart_port *port)
 
 fallback_err:
 	for (i = count; i > 0; i--)
-		stm32_transmit_chars_pio(port);
+		stm32_usart_transmit_chars_pio(port);
 }
 
-static void stm32_transmit_chars(struct uart_port *port)
+static void stm32_usart_transmit_chars(struct uart_port *port)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
 	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
@@ -417,38 +420,38 @@ static void stm32_transmit_chars(struct uart_port *port)
 
 	if (port->x_char) {
 		if (stm32_port->tx_dma_busy)
-			stm32_clr_bits(port, ofs->cr3, USART_CR3_DMAT);
+			stm32_usart_clr_bits(port, ofs->cr3, USART_CR3_DMAT);
 		writel_relaxed(port->x_char, port->membase + ofs->tdr);
 		port->x_char = 0;
 		port->icount.tx++;
 		if (stm32_port->tx_dma_busy)
-			stm32_set_bits(port, ofs->cr3, USART_CR3_DMAT);
+			stm32_usart_set_bits(port, ofs->cr3, USART_CR3_DMAT);
 		return;
 	}
 
 	if (uart_circ_empty(xmit) || uart_tx_stopped(port)) {
-		stm32_tx_interrupt_disable(port);
+		stm32_usart_tx_interrupt_disable(port);
 		return;
 	}
 
 	if (ofs->icr == UNDEF_REG)
-		stm32_clr_bits(port, ofs->isr, USART_SR_TC);
+		stm32_usart_clr_bits(port, ofs->isr, USART_SR_TC);
 	else
 		writel_relaxed(USART_ICR_TCCF, port->membase + ofs->icr);
 
 	if (stm32_port->tx_ch)
-		stm32_transmit_chars_dma(port);
+		stm32_usart_transmit_chars_dma(port);
 	else
-		stm32_transmit_chars_pio(port);
+		stm32_usart_transmit_chars_pio(port);
 
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 		uart_write_wakeup(port);
 
 	if (uart_circ_empty(xmit))
-		stm32_tx_interrupt_disable(port);
+		stm32_usart_tx_interrupt_disable(port);
 }
 
-static irqreturn_t stm32_interrupt(int irq, void *ptr)
+static irqreturn_t stm32_usart_interrupt(int irq, void *ptr)
 {
 	struct uart_port *port = ptr;
 	struct stm32_port *stm32_port = to_stm32_port(port);
@@ -468,10 +471,10 @@ static irqreturn_t stm32_interrupt(int irq, void *ptr)
 			       port->membase + ofs->icr);
 
 	if ((sr & USART_SR_RXNE) && !(stm32_port->rx_ch))
-		stm32_receive_chars(port, false);
+		stm32_usart_receive_chars(port, false);
 
 	if ((sr & USART_SR_TXE) && !(stm32_port->tx_ch))
-		stm32_transmit_chars(port);
+		stm32_usart_transmit_chars(port);
 
 	spin_unlock(&port->lock);
 
@@ -481,7 +484,7 @@ static irqreturn_t stm32_interrupt(int irq, void *ptr)
 		return IRQ_HANDLED;
 }
 
-static irqreturn_t stm32_threaded_interrupt(int irq, void *ptr)
+static irqreturn_t stm32_usart_threaded_interrupt(int irq, void *ptr)
 {
 	struct uart_port *port = ptr;
 	struct stm32_port *stm32_port = to_stm32_port(port);
@@ -489,14 +492,14 @@ static irqreturn_t stm32_threaded_interrupt(int irq, void *ptr)
 	spin_lock(&port->lock);
 
 	if (stm32_port->rx_ch)
-		stm32_receive_chars(port, true);
+		stm32_usart_receive_chars(port, true);
 
 	spin_unlock(&port->lock);
 
 	return IRQ_HANDLED;
 }
 
-static unsigned int stm32_tx_empty(struct uart_port *port)
+static unsigned int stm32_usart_tx_empty(struct uart_port *port)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
 	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
@@ -504,20 +507,20 @@ static unsigned int stm32_tx_empty(struct uart_port *port)
 	return readl_relaxed(port->membase + ofs->isr) & USART_SR_TXE;
 }
 
-static void stm32_set_mctrl(struct uart_port *port, unsigned int mctrl)
+static void stm32_usart_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
 	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
 
 	if ((mctrl & TIOCM_RTS) && (port->status & UPSTAT_AUTORTS))
-		stm32_set_bits(port, ofs->cr3, USART_CR3_RTSE);
+		stm32_usart_set_bits(port, ofs->cr3, USART_CR3_RTSE);
 	else
-		stm32_clr_bits(port, ofs->cr3, USART_CR3_RTSE);
+		stm32_usart_clr_bits(port, ofs->cr3, USART_CR3_RTSE);
 
 	mctrl_gpio_set(stm32_port->gpios, mctrl);
 }
 
-static unsigned int stm32_get_mctrl(struct uart_port *port)
+static unsigned int stm32_usart_get_mctrl(struct uart_port *port)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
 	unsigned int ret;
@@ -528,23 +531,23 @@ static unsigned int stm32_get_mctrl(struct uart_port *port)
 	return mctrl_gpio_get(stm32_port->gpios, &ret);
 }
 
-static void stm32_enable_ms(struct uart_port *port)
+static void stm32_usart_enable_ms(struct uart_port *port)
 {
 	mctrl_gpio_enable_ms(to_stm32_port(port)->gpios);
 }
 
-static void stm32_disable_ms(struct uart_port *port)
+static void stm32_usart_disable_ms(struct uart_port *port)
 {
 	mctrl_gpio_disable_ms(to_stm32_port(port)->gpios);
 }
 
 /* Transmit stop */
-static void stm32_stop_tx(struct uart_port *port)
+static void stm32_usart_stop_tx(struct uart_port *port)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
 	struct serial_rs485 *rs485conf = &port->rs485;
 
-	stm32_tx_interrupt_disable(port);
+	stm32_usart_tx_interrupt_disable(port);
 
 	if (rs485conf->flags & SER_RS485_ENABLED) {
 		if (rs485conf->flags & SER_RS485_RTS_ON_SEND) {
@@ -558,7 +561,7 @@ static void stm32_stop_tx(struct uart_port *port)
 }
 
 /* There are probably characters waiting to be transmitted. */
-static void stm32_start_tx(struct uart_port *port)
+static void stm32_usart_start_tx(struct uart_port *port)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
 	struct serial_rs485 *rs485conf = &port->rs485;
@@ -577,56 +580,56 @@ static void stm32_start_tx(struct uart_port *port)
 		}
 	}
 
-	stm32_transmit_chars(port);
+	stm32_usart_transmit_chars(port);
 }
 
 /* Throttle the remote when input buffer is about to overflow. */
-static void stm32_throttle(struct uart_port *port)
+static void stm32_usart_throttle(struct uart_port *port)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
 	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
 	unsigned long flags;
 
 	spin_lock_irqsave(&port->lock, flags);
-	stm32_clr_bits(port, ofs->cr1, stm32_port->cr1_irq);
+	stm32_usart_clr_bits(port, ofs->cr1, stm32_port->cr1_irq);
 	if (stm32_port->cr3_irq)
-		stm32_clr_bits(port, ofs->cr3, stm32_port->cr3_irq);
+		stm32_usart_clr_bits(port, ofs->cr3, stm32_port->cr3_irq);
 
 	spin_unlock_irqrestore(&port->lock, flags);
 }
 
 /* Unthrottle the remote, the input buffer can now accept data. */
-static void stm32_unthrottle(struct uart_port *port)
+static void stm32_usart_unthrottle(struct uart_port *port)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
 	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
 	unsigned long flags;
 
 	spin_lock_irqsave(&port->lock, flags);
-	stm32_set_bits(port, ofs->cr1, stm32_port->cr1_irq);
+	stm32_usart_set_bits(port, ofs->cr1, stm32_port->cr1_irq);
 	if (stm32_port->cr3_irq)
-		stm32_set_bits(port, ofs->cr3, stm32_port->cr3_irq);
+		stm32_usart_set_bits(port, ofs->cr3, stm32_port->cr3_irq);
 
 	spin_unlock_irqrestore(&port->lock, flags);
 }
 
 /* Receive stop */
-static void stm32_stop_rx(struct uart_port *port)
+static void stm32_usart_stop_rx(struct uart_port *port)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
 	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
 
-	stm32_clr_bits(port, ofs->cr1, stm32_port->cr1_irq);
+	stm32_usart_clr_bits(port, ofs->cr1, stm32_port->cr1_irq);
 	if (stm32_port->cr3_irq)
-		stm32_clr_bits(port, ofs->cr3, stm32_port->cr3_irq);
+		stm32_usart_clr_bits(port, ofs->cr3, stm32_port->cr3_irq);
 }
 
 /* Handle breaks - ignored by us */
-static void stm32_break_ctl(struct uart_port *port, int break_state)
+static void stm32_usart_break_ctl(struct uart_port *port, int break_state)
 {
 }
 
-static int stm32_startup(struct uart_port *port)
+static int stm32_usart_startup(struct uart_port *port)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
 	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
@@ -634,15 +637,15 @@ static int stm32_startup(struct uart_port *port)
 	u32 val;
 	int ret;
 
-	ret = request_threaded_irq(port->irq, stm32_interrupt,
-				   stm32_threaded_interrupt,
+	ret = request_threaded_irq(port->irq, stm32_usart_interrupt,
+				   stm32_usart_threaded_interrupt,
 				   IRQF_NO_SUSPEND, name, port);
 	if (ret)
 		return ret;
 
 	/* RX FIFO Flush */
 	if (ofs->rqr != UNDEF_REG)
-		stm32_set_bits(port, ofs->rqr, USART_RQR_RXFRQ);
+		stm32_usart_set_bits(port, ofs->rqr, USART_RQR_RXFRQ);
 
 	/* Tx and RX FIFO configuration */
 	if (stm32_port->fifoen) {
@@ -657,12 +660,12 @@ static int stm32_startup(struct uart_port *port)
 	val = stm32_port->cr1_irq | USART_CR1_RE;
 	if (stm32_port->fifoen)
 		val |= USART_CR1_FIFOEN;
-	stm32_set_bits(port, ofs->cr1, val);
+	stm32_usart_set_bits(port, ofs->cr1, val);
 
 	return 0;
 }
 
-static void stm32_shutdown(struct uart_port *port)
+static void stm32_usart_shutdown(struct uart_port *port)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
 	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
@@ -671,7 +674,7 @@ static void stm32_shutdown(struct uart_port *port)
 	int ret;
 
 	/* Disable modem control interrupts */
-	stm32_disable_ms(port);
+	stm32_usart_disable_ms(port);
 
 	val = USART_CR1_TXEIE | USART_CR1_TE;
 	val |= stm32_port->cr1_irq | USART_CR1_RE;
@@ -686,12 +689,12 @@ static void stm32_shutdown(struct uart_port *port)
 	if (ret)
 		dev_err(port->dev, "transmission complete not set\n");
 
-	stm32_clr_bits(port, ofs->cr1, val);
+	stm32_usart_clr_bits(port, ofs->cr1, val);
 
 	free_irq(port->irq, port);
 }
 
-static unsigned int stm32_get_databits(struct ktermios *termios)
+static unsigned int stm32_usart_get_databits(struct ktermios *termios)
 {
 	unsigned int bits;
 
@@ -721,8 +724,9 @@ static unsigned int stm32_get_databits(struct ktermios *termios)
 	return bits;
 }
 
-static void stm32_set_termios(struct uart_port *port, struct ktermios *termios,
-			      struct ktermios *old)
+static void stm32_usart_set_termios(struct uart_port *port,
+				    struct ktermios *termios,
+				    struct ktermios *old)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
 	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
@@ -746,8 +750,8 @@ static void stm32_set_termios(struct uart_port *port, struct ktermios *termios,
 
 	/* flush RX & TX FIFO */
 	if (ofs->rqr != UNDEF_REG)
-		stm32_set_bits(port, ofs->rqr,
-			       USART_RQR_TXFRQ | USART_RQR_RXFRQ);
+		stm32_usart_set_bits(port, ofs->rqr,
+				     USART_RQR_TXFRQ | USART_RQR_RXFRQ);
 
 	cr1 = USART_CR1_TE | USART_CR1_RE;
 	if (stm32_port->fifoen)
@@ -760,7 +764,7 @@ static void stm32_set_termios(struct uart_port *port, struct ktermios *termios,
 	if (cflag & CSTOPB)
 		cr2 |= USART_CR2_STOP_2B;
 
-	bits = stm32_get_databits(termios);
+	bits = stm32_usart_get_databits(termios);
 	stm32_port->rdr_mask = (BIT(bits) - 1);
 
 	if (cflag & PARENB) {
@@ -813,9 +817,9 @@ static void stm32_set_termios(struct uart_port *port, struct ktermios *termios,
 
 	/* Handle modem control interrupts */
 	if (UART_ENABLE_MS(port, termios->c_cflag))
-		stm32_enable_ms(port);
+		stm32_usart_enable_ms(port);
 	else
-		stm32_disable_ms(port);
+		stm32_usart_disable_ms(port);
 
 	usartdiv = DIV_ROUND_CLOSEST(port->uartclk, baud);
 
@@ -828,11 +832,11 @@ static void stm32_set_termios(struct uart_port *port, struct ktermios *termios,
 	if (usartdiv < 16) {
 		oversampling = 8;
 		cr1 |= USART_CR1_OVER8;
-		stm32_set_bits(port, ofs->cr1, USART_CR1_OVER8);
+		stm32_usart_set_bits(port, ofs->cr1, USART_CR1_OVER8);
 	} else {
 		oversampling = 16;
 		cr1 &= ~USART_CR1_OVER8;
-		stm32_clr_bits(port, ofs->cr1, USART_CR1_OVER8);
+		stm32_usart_clr_bits(port, ofs->cr1, USART_CR1_OVER8);
 	}
 
 	mantissa = (usartdiv / oversampling) << USART_BRR_DIV_M_SHIFT;
@@ -869,9 +873,10 @@ static void stm32_set_termios(struct uart_port *port, struct ktermios *termios,
 		cr3 |= USART_CR3_DMAR;
 
 	if (rs485conf->flags & SER_RS485_ENABLED) {
-		stm32_config_reg_rs485(&cr1, &cr3,
-				       rs485conf->delay_rts_before_send,
-				       rs485conf->delay_rts_after_send, baud);
+		stm32_usart_config_reg_rs485(&cr1, &cr3,
+					     rs485conf->delay_rts_before_send,
+					     rs485conf->delay_rts_after_send,
+					     baud);
 		if (rs485conf->flags & SER_RS485_RTS_ON_SEND) {
 			cr3 &= ~USART_CR3_DEP;
 			rs485conf->flags &= ~SER_RS485_RTS_AFTER_SEND;
@@ -889,39 +894,39 @@ static void stm32_set_termios(struct uart_port *port, struct ktermios *termios,
 	writel_relaxed(cr2, port->membase + ofs->cr2);
 	writel_relaxed(cr1, port->membase + ofs->cr1);
 
-	stm32_set_bits(port, ofs->cr1, BIT(cfg->uart_enable_bit));
+	stm32_usart_set_bits(port, ofs->cr1, BIT(cfg->uart_enable_bit));
 	spin_unlock_irqrestore(&port->lock, flags);
 }
 
-static const char *stm32_type(struct uart_port *port)
+static const char *stm32_usart_type(struct uart_port *port)
 {
 	return (port->type == PORT_STM32) ? DRIVER_NAME : NULL;
 }
 
-static void stm32_release_port(struct uart_port *port)
+static void stm32_usart_release_port(struct uart_port *port)
 {
 }
 
-static int stm32_request_port(struct uart_port *port)
+static int stm32_usart_request_port(struct uart_port *port)
 {
 	return 0;
 }
 
-static void stm32_config_port(struct uart_port *port, int flags)
+static void stm32_usart_config_port(struct uart_port *port, int flags)
 {
 	if (flags & UART_CONFIG_TYPE)
 		port->type = PORT_STM32;
 }
 
 static int
-stm32_verify_port(struct uart_port *port, struct serial_struct *ser)
+stm32_usart_verify_port(struct uart_port *port, struct serial_struct *ser)
 {
 	/* No user changeable parameters */
 	return -EINVAL;
 }
 
-static void stm32_pm(struct uart_port *port, unsigned int state,
-		     unsigned int oldstate)
+static void stm32_usart_pm(struct uart_port *port, unsigned int state,
+			   unsigned int oldstate)
 {
 	struct stm32_port *stm32port = container_of(port,
 			struct stm32_port, port);
@@ -935,7 +940,7 @@ static void stm32_pm(struct uart_port *port, unsigned int state,
 		break;
 	case UART_PM_STATE_OFF:
 		spin_lock_irqsave(&port->lock, flags);
-		stm32_clr_bits(port, ofs->cr1, BIT(cfg->uart_enable_bit));
+		stm32_usart_clr_bits(port, ofs->cr1, BIT(cfg->uart_enable_bit));
 		spin_unlock_irqrestore(&port->lock, flags);
 		pm_runtime_put_sync(port->dev);
 		break;
@@ -943,29 +948,29 @@ static void stm32_pm(struct uart_port *port, unsigned int state,
 }
 
 static const struct uart_ops stm32_uart_ops = {
-	.tx_empty	= stm32_tx_empty,
-	.set_mctrl	= stm32_set_mctrl,
-	.get_mctrl	= stm32_get_mctrl,
-	.stop_tx	= stm32_stop_tx,
-	.start_tx	= stm32_start_tx,
-	.throttle	= stm32_throttle,
-	.unthrottle	= stm32_unthrottle,
-	.stop_rx	= stm32_stop_rx,
-	.enable_ms	= stm32_enable_ms,
-	.break_ctl	= stm32_break_ctl,
-	.startup	= stm32_startup,
-	.shutdown	= stm32_shutdown,
-	.set_termios	= stm32_set_termios,
-	.pm		= stm32_pm,
-	.type		= stm32_type,
-	.release_port	= stm32_release_port,
-	.request_port	= stm32_request_port,
-	.config_port	= stm32_config_port,
-	.verify_port	= stm32_verify_port,
+	.tx_empty	= stm32_usart_tx_empty,
+	.set_mctrl	= stm32_usart_set_mctrl,
+	.get_mctrl	= stm32_usart_get_mctrl,
+	.stop_tx	= stm32_usart_stop_tx,
+	.start_tx	= stm32_usart_start_tx,
+	.throttle	= stm32_usart_throttle,
+	.unthrottle	= stm32_usart_unthrottle,
+	.stop_rx	= stm32_usart_stop_rx,
+	.enable_ms	= stm32_usart_enable_ms,
+	.break_ctl	= stm32_usart_break_ctl,
+	.startup	= stm32_usart_startup,
+	.shutdown	= stm32_usart_shutdown,
+	.set_termios	= stm32_usart_set_termios,
+	.pm		= stm32_usart_pm,
+	.type		= stm32_usart_type,
+	.release_port	= stm32_usart_release_port,
+	.request_port	= stm32_usart_request_port,
+	.config_port	= stm32_usart_config_port,
+	.verify_port	= stm32_usart_verify_port,
 };
 
-static int stm32_init_port(struct stm32_port *stm32port,
-			  struct platform_device *pdev)
+static int stm32_usart_init_port(struct stm32_port *stm32port,
+				 struct platform_device *pdev)
 {
 	struct uart_port *port = &stm32port->port;
 	struct resource *res;
@@ -982,9 +987,9 @@ static int stm32_init_port(struct stm32_port *stm32port,
 	port->fifosize	= stm32port->info->cfg.fifosize;
 	port->has_sysrq = IS_ENABLED(CONFIG_SERIAL_STM32_CONSOLE);
 	port->irq = ret;
-	port->rs485_config = stm32_config_rs485;
+	port->rs485_config = stm32_usart_config_rs485;
 
-	ret = stm32_init_rs485(port, pdev);
+	ret = stm32_usart_init_rs485(port, pdev);
 	if (ret)
 		return ret;
 
@@ -1043,7 +1048,7 @@ err_clk:
 	return ret;
 }
 
-static struct stm32_port *stm32_of_get_stm32_port(struct platform_device *pdev)
+static struct stm32_port *stm32_usart_of_get_port(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
 	int id;
@@ -1081,8 +1086,8 @@ static const struct of_device_id stm32_match[] = {
 MODULE_DEVICE_TABLE(of, stm32_match);
 #endif
 
-static int stm32_of_dma_rx_probe(struct stm32_port *stm32port,
-				 struct platform_device *pdev)
+static int stm32_usart_of_dma_rx_probe(struct stm32_port *stm32port,
+				       struct platform_device *pdev)
 {
 	struct stm32_usart_offsets *ofs = &stm32port->info->ofs;
 	struct uart_port *port = &stm32port->port;
@@ -1156,8 +1161,8 @@ alloc_err:
 	return ret;
 }
 
-static int stm32_of_dma_tx_probe(struct stm32_port *stm32port,
-				 struct platform_device *pdev)
+static int stm32_usart_of_dma_tx_probe(struct stm32_port *stm32port,
+				       struct platform_device *pdev)
 {
 	struct stm32_usart_offsets *ofs = &stm32port->info->ofs;
 	struct uart_port *port = &stm32port->port;
@@ -1207,13 +1212,13 @@ alloc_err:
 	return ret;
 }
 
-static int stm32_serial_probe(struct platform_device *pdev)
+static int stm32_usart_serial_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *match;
 	struct stm32_port *stm32port;
 	int ret;
 
-	stm32port = stm32_of_get_stm32_port(pdev);
+	stm32port = stm32_usart_of_get_port(pdev);
 	if (!stm32port)
 		return -ENODEV;
 
@@ -1223,7 +1228,7 @@ static int stm32_serial_probe(struct platform_device *pdev)
 	else
 		return -EINVAL;
 
-	ret = stm32_init_port(stm32port, pdev);
+	ret = stm32_usart_init_port(stm32port, pdev);
 	if (ret)
 		return ret;
 
@@ -1244,11 +1249,11 @@ static int stm32_serial_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_wirq;
 
-	ret = stm32_of_dma_rx_probe(stm32port, pdev);
+	ret = stm32_usart_of_dma_rx_probe(stm32port, pdev);
 	if (ret)
 		dev_info(&pdev->dev, "interrupt mode used for rx (no dma)\n");
 
-	ret = stm32_of_dma_tx_probe(stm32port, pdev);
+	ret = stm32_usart_of_dma_tx_probe(stm32port, pdev);
 	if (ret)
 		dev_info(&pdev->dev, "interrupt mode used for tx (no dma)\n");
 
@@ -1275,7 +1280,7 @@ err_uninit:
 	return ret;
 }
 
-static int stm32_serial_remove(struct platform_device *pdev)
+static int stm32_usart_serial_remove(struct platform_device *pdev)
 {
 	struct uart_port *port = platform_get_drvdata(pdev);
 	struct stm32_port *stm32_port = to_stm32_port(port);
@@ -1284,7 +1289,7 @@ static int stm32_serial_remove(struct platform_device *pdev)
 
 	pm_runtime_get_sync(&pdev->dev);
 
-	stm32_clr_bits(port, ofs->cr3, USART_CR3_DMAR);
+	stm32_usart_clr_bits(port, ofs->cr3, USART_CR3_DMAR);
 
 	if (stm32_port->rx_ch)
 		dma_release_channel(stm32_port->rx_ch);
@@ -1294,7 +1299,7 @@ static int stm32_serial_remove(struct platform_device *pdev)
 				  RX_BUF_L, stm32_port->rx_buf,
 				  stm32_port->rx_dma_buf);
 
-	stm32_clr_bits(port, ofs->cr3, USART_CR3_DMAT);
+	stm32_usart_clr_bits(port, ofs->cr3, USART_CR3_DMAT);
 
 	if (stm32_port->tx_ch)
 		dma_release_channel(stm32_port->tx_ch);
@@ -1320,7 +1325,7 @@ static int stm32_serial_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_SERIAL_STM32_CONSOLE
-static void stm32_console_putchar(struct uart_port *port, int ch)
+static void stm32_usart_console_putchar(struct uart_port *port, int ch)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
 	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
@@ -1331,8 +1336,8 @@ static void stm32_console_putchar(struct uart_port *port, int ch)
 	writel_relaxed(ch, port->membase + ofs->tdr);
 }
 
-static void stm32_console_write(struct console *co, const char *s,
-				unsigned int cnt)
+static void stm32_usart_console_write(struct console *co, const char *s,
+				      unsigned int cnt)
 {
 	struct uart_port *port = &stm32_ports[co->index].port;
 	struct stm32_port *stm32_port = to_stm32_port(port);
@@ -1356,7 +1361,7 @@ static void stm32_console_write(struct console *co, const char *s,
 	new_cr1 |=  USART_CR1_TE | BIT(cfg->uart_enable_bit);
 	writel_relaxed(new_cr1, port->membase + ofs->cr1);
 
-	uart_console_write(port, s, cnt, stm32_console_putchar);
+	uart_console_write(port, s, cnt, stm32_usart_console_putchar);
 
 	/* Restore interrupt state */
 	writel_relaxed(old_cr1, port->membase + ofs->cr1);
@@ -1366,7 +1371,7 @@ static void stm32_console_write(struct console *co, const char *s,
 	local_irq_restore(flags);
 }
 
-static int stm32_console_setup(struct console *co, char *options)
+static int stm32_usart_console_setup(struct console *co, char *options)
 {
 	struct stm32_port *stm32port;
 	int baud = 9600;
@@ -1397,8 +1402,8 @@ static int stm32_console_setup(struct console *co, char *options)
 static struct console stm32_console = {
 	.name		= STM32_SERIAL_NAME,
 	.device		= uart_console_device,
-	.write		= stm32_console_write,
-	.setup		= stm32_console_setup,
+	.write		= stm32_usart_console_write,
+	.setup		= stm32_usart_console_setup,
 	.flags		= CON_PRINTBUFFER,
 	.index		= -1,
 	.data		= &stm32_usart_driver,
@@ -1419,8 +1424,8 @@ static struct uart_driver stm32_usart_driver = {
 	.cons		= STM32_SERIAL_CONSOLE,
 };
 
-static void __maybe_unused stm32_serial_enable_wakeup(struct uart_port *port,
-						      bool enable)
+static void __maybe_unused stm32_usart_serial_en_wakeup(struct uart_port *port,
+							bool enable)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
 	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
@@ -1431,29 +1436,29 @@ static void __maybe_unused stm32_serial_enable_wakeup(struct uart_port *port,
 		return;
 
 	if (enable) {
-		stm32_clr_bits(port, ofs->cr1, BIT(cfg->uart_enable_bit));
-		stm32_set_bits(port, ofs->cr1, USART_CR1_UESM);
+		stm32_usart_clr_bits(port, ofs->cr1, BIT(cfg->uart_enable_bit));
+		stm32_usart_set_bits(port, ofs->cr1, USART_CR1_UESM);
 		val = readl_relaxed(port->membase + ofs->cr3);
 		val &= ~USART_CR3_WUS_MASK;
 		/* Enable Wake up interrupt from low power on start bit */
 		val |= USART_CR3_WUS_START_BIT | USART_CR3_WUFIE;
 		writel_relaxed(val, port->membase + ofs->cr3);
-		stm32_set_bits(port, ofs->cr1, BIT(cfg->uart_enable_bit));
+		stm32_usart_set_bits(port, ofs->cr1, BIT(cfg->uart_enable_bit));
 	} else {
-		stm32_clr_bits(port, ofs->cr1, USART_CR1_UESM);
+		stm32_usart_clr_bits(port, ofs->cr1, USART_CR1_UESM);
 	}
 }
 
-static int __maybe_unused stm32_serial_suspend(struct device *dev)
+static int __maybe_unused stm32_usart_serial_suspend(struct device *dev)
 {
 	struct uart_port *port = dev_get_drvdata(dev);
 
 	uart_suspend_port(&stm32_usart_driver, port);
 
 	if (device_may_wakeup(dev))
-		stm32_serial_enable_wakeup(port, true);
+		stm32_usart_serial_en_wakeup(port, true);
 	else
-		stm32_serial_enable_wakeup(port, false);
+		stm32_usart_serial_en_wakeup(port, false);
 
 	/*
 	 * When "no_console_suspend" is enabled, keep the pinctrl default state
@@ -1471,19 +1476,19 @@ static int __maybe_unused stm32_serial_suspend(struct device *dev)
 	return 0;
 }
 
-static int __maybe_unused stm32_serial_resume(struct device *dev)
+static int __maybe_unused stm32_usart_serial_resume(struct device *dev)
 {
 	struct uart_port *port = dev_get_drvdata(dev);
 
 	pinctrl_pm_select_default_state(dev);
 
 	if (device_may_wakeup(dev))
-		stm32_serial_enable_wakeup(port, false);
+		stm32_usart_serial_en_wakeup(port, false);
 
 	return uart_resume_port(&stm32_usart_driver, port);
 }
 
-static int __maybe_unused stm32_serial_runtime_suspend(struct device *dev)
+static int __maybe_unused stm32_usart_runtime_suspend(struct device *dev)
 {
 	struct uart_port *port = dev_get_drvdata(dev);
 	struct stm32_port *stm32port = container_of(port,
@@ -1494,7 +1499,7 @@ static int __maybe_unused stm32_serial_runtime_suspend(struct device *dev)
 	return 0;
 }
 
-static int __maybe_unused stm32_serial_runtime_resume(struct device *dev)
+static int __maybe_unused stm32_usart_runtime_resume(struct device *dev)
 {
 	struct uart_port *port = dev_get_drvdata(dev);
 	struct stm32_port *stm32port = container_of(port,
@@ -1504,14 +1509,15 @@ static int __maybe_unused stm32_serial_runtime_resume(struct device *dev)
 }
 
 static const struct dev_pm_ops stm32_serial_pm_ops = {
-	SET_RUNTIME_PM_OPS(stm32_serial_runtime_suspend,
-			   stm32_serial_runtime_resume, NULL)
-	SET_SYSTEM_SLEEP_PM_OPS(stm32_serial_suspend, stm32_serial_resume)
+	SET_RUNTIME_PM_OPS(stm32_usart_runtime_suspend,
+			   stm32_usart_runtime_resume, NULL)
+	SET_SYSTEM_SLEEP_PM_OPS(stm32_usart_serial_suspend,
+				stm32_usart_serial_resume)
 };
 
 static struct platform_driver stm32_serial_driver = {
-	.probe		= stm32_serial_probe,
-	.remove		= stm32_serial_remove,
+	.probe		= stm32_usart_serial_probe,
+	.remove		= stm32_usart_serial_remove,
 	.driver	= {
 		.name	= DRIVER_NAME,
 		.pm	= &stm32_serial_pm_ops,
@@ -1519,7 +1525,7 @@ static struct platform_driver stm32_serial_driver = {
 	},
 };
 
-static int __init usart_init(void)
+static int __init stm32_usart_init(void)
 {
 	static char banner[] __initdata = "STM32 USART driver initialized";
 	int ret;
@@ -1537,14 +1543,14 @@ static int __init usart_init(void)
 	return ret;
 }
 
-static void __exit usart_exit(void)
+static void __exit stm32_usart_exit(void)
 {
 	platform_driver_unregister(&stm32_serial_driver);
 	uart_unregister_driver(&stm32_usart_driver);
 }
 
-module_init(usart_init);
-module_exit(usart_exit);
+module_init(stm32_usart_init);
+module_exit(stm32_usart_exit);
 
 MODULE_ALIAS("platform:" DRIVER_NAME);
 MODULE_DESCRIPTION("STMicroelectronics STM32 serial port driver");
-- 
2.30.2



