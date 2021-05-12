Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5286037C800
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235076AbhELQEF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:04:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234758AbhELP6v (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:58:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B393761956;
        Wed, 12 May 2021 15:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833516;
        bh=EI4hj7BMe7Ny1aWDKXOrI4rWPyzcscGJ2qGH6U8F6Qs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eAlkomUgIPY2bllK6z/yFUnvq2m5pGSmEL85xg5+xqaE6LpbGqh5gESBbH4ujVTuF
         u7s9TmGMXQlNDVNMDiFuwA2G0jIWQS/xdg5rNfLXzZkyQtQ0ZF/xFUhei0aTpNxiuO
         /+iW5/87d72gmRVNKDkvtR2omL2Z7WWxjI666lvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jiri Slaby <jslaby@suse.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        linux-serial@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 146/601] serial: stm32: Use of_device_get_match_data()
Date:   Wed, 12 May 2021 16:43:43 +0200
Message-Id: <20210512144832.627798600@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit d825f0bea20f49a8f413a6acd7c4100ea55edf6d ]

This driver casts away the constness of struct stm32_usart_info that is
pointed to by the of match table. Use of_device_get_match_data() instead
of of_match_device() here and push the const throughout the code so that
we don't cast away const. This nicely avoids referencing the match table
when it is undefined with configurations where CONFIG_OF=n and fixes the
const issues.

Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.com>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Frank Rowand <frowand.list@gmail.com>
Cc: <linux-serial@vger.kernel.org>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20210123034428.2841052-4-swboyd@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/stm32-usart.c | 71 +++++++++++++++-----------------
 drivers/tty/serial/stm32-usart.h |  2 +-
 2 files changed, 35 insertions(+), 38 deletions(-)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index dd029696893a..1f7fe285bb1f 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -99,8 +99,8 @@ static int stm32_usart_config_rs485(struct uart_port *port,
 				    struct serial_rs485 *rs485conf)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
-	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
-	struct stm32_usart_config *cfg = &stm32_port->info->cfg;
+	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
+	const struct stm32_usart_config *cfg = &stm32_port->info->cfg;
 	u32 usartdiv, baud, cr1, cr3;
 	bool over8;
 
@@ -168,7 +168,7 @@ static int stm32_usart_pending_rx(struct uart_port *port, u32 *sr,
 				  int *last_res, bool threaded)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
-	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
+	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
 	enum dma_status status;
 	struct dma_tx_state state;
 
@@ -192,7 +192,7 @@ static unsigned long stm32_usart_get_char(struct uart_port *port, u32 *sr,
 					  int *last_res)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
-	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
+	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
 	unsigned long c;
 
 	if (stm32_port->rx_ch) {
@@ -212,7 +212,7 @@ static void stm32_usart_receive_chars(struct uart_port *port, bool threaded)
 {
 	struct tty_port *tport = &port->state->port;
 	struct stm32_port *stm32_port = to_stm32_port(port);
-	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
+	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
 	unsigned long c;
 	u32 sr;
 	char flag;
@@ -284,7 +284,7 @@ static void stm32_usart_tx_dma_complete(void *arg)
 {
 	struct uart_port *port = arg;
 	struct stm32_port *stm32port = to_stm32_port(port);
-	struct stm32_usart_offsets *ofs = &stm32port->info->ofs;
+	const struct stm32_usart_offsets *ofs = &stm32port->info->ofs;
 
 	stm32_usart_clr_bits(port, ofs->cr3, USART_CR3_DMAT);
 	stm32port->tx_dma_busy = false;
@@ -296,7 +296,7 @@ static void stm32_usart_tx_dma_complete(void *arg)
 static void stm32_usart_tx_interrupt_enable(struct uart_port *port)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
-	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
+	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
 
 	/*
 	 * Enables TX FIFO threashold irq when FIFO is enabled,
@@ -311,7 +311,7 @@ static void stm32_usart_tx_interrupt_enable(struct uart_port *port)
 static void stm32_usart_tx_interrupt_disable(struct uart_port *port)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
-	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
+	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
 
 	if (stm32_port->fifoen)
 		stm32_usart_clr_bits(port, ofs->cr3, USART_CR3_TXFTIE);
@@ -322,7 +322,7 @@ static void stm32_usart_tx_interrupt_disable(struct uart_port *port)
 static void stm32_usart_transmit_chars_pio(struct uart_port *port)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
-	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
+	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
 	struct circ_buf *xmit = &port->state->xmit;
 
 	if (stm32_port->tx_dma_busy) {
@@ -349,7 +349,7 @@ static void stm32_usart_transmit_chars_pio(struct uart_port *port)
 static void stm32_usart_transmit_chars_dma(struct uart_port *port)
 {
 	struct stm32_port *stm32port = to_stm32_port(port);
-	struct stm32_usart_offsets *ofs = &stm32port->info->ofs;
+	const struct stm32_usart_offsets *ofs = &stm32port->info->ofs;
 	struct circ_buf *xmit = &port->state->xmit;
 	struct dma_async_tx_descriptor *desc = NULL;
 	unsigned int count, i;
@@ -415,7 +415,7 @@ fallback_err:
 static void stm32_usart_transmit_chars(struct uart_port *port)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
-	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
+	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
 	struct circ_buf *xmit = &port->state->xmit;
 
 	if (port->x_char) {
@@ -455,7 +455,7 @@ static irqreturn_t stm32_usart_interrupt(int irq, void *ptr)
 {
 	struct uart_port *port = ptr;
 	struct stm32_port *stm32_port = to_stm32_port(port);
-	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
+	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
 	u32 sr;
 
 	spin_lock(&port->lock);
@@ -502,7 +502,7 @@ static irqreturn_t stm32_usart_threaded_interrupt(int irq, void *ptr)
 static unsigned int stm32_usart_tx_empty(struct uart_port *port)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
-	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
+	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
 
 	return readl_relaxed(port->membase + ofs->isr) & USART_SR_TXE;
 }
@@ -510,7 +510,7 @@ static unsigned int stm32_usart_tx_empty(struct uart_port *port)
 static void stm32_usart_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
-	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
+	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
 
 	if ((mctrl & TIOCM_RTS) && (port->status & UPSTAT_AUTORTS))
 		stm32_usart_set_bits(port, ofs->cr3, USART_CR3_RTSE);
@@ -587,7 +587,7 @@ static void stm32_usart_start_tx(struct uart_port *port)
 static void stm32_usart_throttle(struct uart_port *port)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
-	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
+	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
 	unsigned long flags;
 
 	spin_lock_irqsave(&port->lock, flags);
@@ -602,7 +602,7 @@ static void stm32_usart_throttle(struct uart_port *port)
 static void stm32_usart_unthrottle(struct uart_port *port)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
-	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
+	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
 	unsigned long flags;
 
 	spin_lock_irqsave(&port->lock, flags);
@@ -617,7 +617,7 @@ static void stm32_usart_unthrottle(struct uart_port *port)
 static void stm32_usart_stop_rx(struct uart_port *port)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
-	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
+	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
 
 	stm32_usart_clr_bits(port, ofs->cr1, stm32_port->cr1_irq);
 	if (stm32_port->cr3_irq)
@@ -632,7 +632,7 @@ static void stm32_usart_break_ctl(struct uart_port *port, int break_state)
 static int stm32_usart_startup(struct uart_port *port)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
-	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
+	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
 	const char *name = to_platform_device(port->dev)->name;
 	u32 val;
 	int ret;
@@ -668,8 +668,8 @@ static int stm32_usart_startup(struct uart_port *port)
 static void stm32_usart_shutdown(struct uart_port *port)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
-	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
-	struct stm32_usart_config *cfg = &stm32_port->info->cfg;
+	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
+	const struct stm32_usart_config *cfg = &stm32_port->info->cfg;
 	u32 val, isr;
 	int ret;
 
@@ -729,8 +729,8 @@ static void stm32_usart_set_termios(struct uart_port *port,
 				    struct ktermios *old)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
-	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
-	struct stm32_usart_config *cfg = &stm32_port->info->cfg;
+	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
+	const struct stm32_usart_config *cfg = &stm32_port->info->cfg;
 	struct serial_rs485 *rs485conf = &port->rs485;
 	unsigned int baud, bits;
 	u32 usartdiv, mantissa, fraction, oversampling;
@@ -930,8 +930,8 @@ static void stm32_usart_pm(struct uart_port *port, unsigned int state,
 {
 	struct stm32_port *stm32port = container_of(port,
 			struct stm32_port, port);
-	struct stm32_usart_offsets *ofs = &stm32port->info->ofs;
-	struct stm32_usart_config *cfg = &stm32port->info->cfg;
+	const struct stm32_usart_offsets *ofs = &stm32port->info->ofs;
+	const struct stm32_usart_config *cfg = &stm32port->info->cfg;
 	unsigned long flags = 0;
 
 	switch (state) {
@@ -1089,7 +1089,7 @@ MODULE_DEVICE_TABLE(of, stm32_match);
 static int stm32_usart_of_dma_rx_probe(struct stm32_port *stm32port,
 				       struct platform_device *pdev)
 {
-	struct stm32_usart_offsets *ofs = &stm32port->info->ofs;
+	const struct stm32_usart_offsets *ofs = &stm32port->info->ofs;
 	struct uart_port *port = &stm32port->port;
 	struct device *dev = &pdev->dev;
 	struct dma_slave_config config;
@@ -1164,7 +1164,7 @@ alloc_err:
 static int stm32_usart_of_dma_tx_probe(struct stm32_port *stm32port,
 				       struct platform_device *pdev)
 {
-	struct stm32_usart_offsets *ofs = &stm32port->info->ofs;
+	const struct stm32_usart_offsets *ofs = &stm32port->info->ofs;
 	struct uart_port *port = &stm32port->port;
 	struct device *dev = &pdev->dev;
 	struct dma_slave_config config;
@@ -1214,7 +1214,6 @@ alloc_err:
 
 static int stm32_usart_serial_probe(struct platform_device *pdev)
 {
-	const struct of_device_id *match;
 	struct stm32_port *stm32port;
 	int ret;
 
@@ -1222,10 +1221,8 @@ static int stm32_usart_serial_probe(struct platform_device *pdev)
 	if (!stm32port)
 		return -ENODEV;
 
-	match = of_match_device(stm32_match, &pdev->dev);
-	if (match && match->data)
-		stm32port->info = (struct stm32_usart_info *)match->data;
-	else
+	stm32port->info = of_device_get_match_data(&pdev->dev);
+	if (!stm32port->info)
 		return -EINVAL;
 
 	ret = stm32_usart_init_port(stm32port, pdev);
@@ -1309,7 +1306,7 @@ static int stm32_usart_serial_remove(struct platform_device *pdev)
 {
 	struct uart_port *port = platform_get_drvdata(pdev);
 	struct stm32_port *stm32_port = to_stm32_port(port);
-	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
+	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
 	int err;
 
 	pm_runtime_get_sync(&pdev->dev);
@@ -1359,7 +1356,7 @@ static int stm32_usart_serial_remove(struct platform_device *pdev)
 static void stm32_usart_console_putchar(struct uart_port *port, int ch)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
-	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
+	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
 
 	while (!(readl_relaxed(port->membase + ofs->isr) & USART_SR_TXE))
 		cpu_relax();
@@ -1372,8 +1369,8 @@ static void stm32_usart_console_write(struct console *co, const char *s,
 {
 	struct uart_port *port = &stm32_ports[co->index].port;
 	struct stm32_port *stm32_port = to_stm32_port(port);
-	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
-	struct stm32_usart_config *cfg = &stm32_port->info->cfg;
+	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
+	const struct stm32_usart_config *cfg = &stm32_port->info->cfg;
 	unsigned long flags;
 	u32 old_cr1, new_cr1;
 	int locked = 1;
@@ -1459,8 +1456,8 @@ static void __maybe_unused stm32_usart_serial_en_wakeup(struct uart_port *port,
 							bool enable)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
-	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
-	struct stm32_usart_config *cfg = &stm32_port->info->cfg;
+	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
+	const struct stm32_usart_config *cfg = &stm32_port->info->cfg;
 	u32 val;
 
 	if (stm32_port->wakeirq <= 0)
diff --git a/drivers/tty/serial/stm32-usart.h b/drivers/tty/serial/stm32-usart.h
index d4c916e78d40..cb4f327c46db 100644
--- a/drivers/tty/serial/stm32-usart.h
+++ b/drivers/tty/serial/stm32-usart.h
@@ -259,7 +259,7 @@ struct stm32_usart_info stm32h7_info = {
 struct stm32_port {
 	struct uart_port port;
 	struct clk *clk;
-	struct stm32_usart_info *info;
+	const struct stm32_usart_info *info;
 	struct dma_chan *rx_ch;  /* dma rx channel            */
 	dma_addr_t rx_dma_buf;   /* dma rx buffer bus address */
 	unsigned char *rx_buf;   /* dma rx buffer cpu address */
-- 
2.30.2



