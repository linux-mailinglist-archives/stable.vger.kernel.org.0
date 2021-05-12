Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D6E37C7E4
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235788AbhELQDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:03:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:37100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238234AbhELP5e (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:57:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9F8761C2A;
        Wed, 12 May 2021 15:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833465;
        bh=xown9SXbHlSPmMt/iHf7woIvxTsWNhoEfCYupqV7184=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dBs1MoQdQS7eKpt3QBLT+Yq3R8eMeASQQd6Z1WdiWKB4ONlVrYUnX1uOBMC0xwa0d
         YHxzzBCQF7laCPKohVdmXV/c0MZySAnh1lYnvJjssK0heRru7CkKDB7I6Yey8YrrDH
         aBd5ixt09dwy56q22nf+0DwUiBT5kouZBr2qCs+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erwan Le Ray <erwan.leray@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 143/601] serial: stm32: fix code cleaning warnings and checks
Date:   Wed, 12 May 2021 16:43:40 +0200
Message-Id: <20210512144832.533128408@linuxfoundation.org>
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

From: Erwan Le Ray <erwan.leray@foss.st.com>

[ Upstream commit 92fc00238675a15cc48f09694949f0c0012e0ff4 ]

Fixes checkpatch --strict warnings and checks:
- checkpatch --strict "Unnecessary parentheses"
- checkpatch --strict "Blank lines aren't necessary before a close brace
- checkpatch --strict "Alignment should match open parenthesis"
- checkpatch --strict "Please don't use multiple blank lines"
- checkpatch --strict "Comparison to NULL could be written ..."
- visual check code ordering warning

Signed-off-by: Erwan Le Ray <erwan.leray@foss.st.com>
Link: https://lore.kernel.org/r/20210106162203.28854-3-erwan.leray@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/stm32-usart.c | 33 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index 6248304a001f..a0ef86d71317 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -176,8 +176,7 @@ static int stm32_pending_rx(struct uart_port *port, u32 *sr, int *last_res,
 		status = dmaengine_tx_status(stm32_port->rx_ch,
 					     stm32_port->rx_ch->cookie,
 					     &state);
-		if ((status == DMA_IN_PROGRESS) &&
-		    (*last_res != state.residue))
+		if (status == DMA_IN_PROGRESS && (*last_res != state.residue))
 			return 1;
 		else
 			return 0;
@@ -464,7 +463,7 @@ static irqreturn_t stm32_interrupt(int irq, void *ptr)
 		writel_relaxed(USART_ICR_RTOCF,
 			       port->membase + ofs->icr);
 
-	if ((sr & USART_SR_WUF) && (ofs->icr != UNDEF_REG))
+	if ((sr & USART_SR_WUF) && ofs->icr != UNDEF_REG)
 		writel_relaxed(USART_ICR_WUCF,
 			       port->membase + ofs->icr);
 
@@ -620,7 +619,6 @@ static void stm32_stop_rx(struct uart_port *port)
 	stm32_clr_bits(port, ofs->cr1, stm32_port->cr1_irq);
 	if (stm32_port->cr3_irq)
 		stm32_clr_bits(port, ofs->cr3, stm32_port->cr3_irq);
-
 }
 
 /* Handle breaks - ignored by us */
@@ -724,7 +722,7 @@ static unsigned int stm32_get_databits(struct ktermios *termios)
 }
 
 static void stm32_set_termios(struct uart_port *port, struct ktermios *termios,
-			    struct ktermios *old)
+			      struct ktermios *old)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
 	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
@@ -923,7 +921,7 @@ stm32_verify_port(struct uart_port *port, struct serial_struct *ser)
 }
 
 static void stm32_pm(struct uart_port *port, unsigned int state,
-		unsigned int oldstate)
+		     unsigned int oldstate)
 {
 	struct stm32_port *stm32port = container_of(port,
 			struct stm32_port, port);
@@ -973,18 +971,17 @@ static int stm32_init_port(struct stm32_port *stm32port,
 	struct resource *res;
 	int ret;
 
+	ret = platform_get_irq(pdev, 0);
+	if (ret <= 0)
+		return ret ? : -ENODEV;
+
 	port->iotype	= UPIO_MEM;
 	port->flags	= UPF_BOOT_AUTOCONF;
 	port->ops	= &stm32_uart_ops;
 	port->dev	= &pdev->dev;
 	port->fifosize	= stm32port->info->cfg.fifosize;
 	port->has_sysrq = IS_ENABLED(CONFIG_SERIAL_STM32_CONSOLE);
-
-	ret = platform_get_irq(pdev, 0);
-	if (ret <= 0)
-		return ret ? : -ENODEV;
 	port->irq = ret;
-
 	port->rs485_config = stm32_config_rs485;
 
 	ret = stm32_init_rs485(port, pdev);
@@ -1101,8 +1098,8 @@ static int stm32_of_dma_rx_probe(struct stm32_port *stm32port,
 		return -ENODEV;
 	}
 	stm32port->rx_buf = dma_alloc_coherent(&pdev->dev, RX_BUF_L,
-						 &stm32port->rx_dma_buf,
-						 GFP_KERNEL);
+					       &stm32port->rx_dma_buf,
+					       GFP_KERNEL);
 	if (!stm32port->rx_buf) {
 		ret = -ENOMEM;
 		goto alloc_err;
@@ -1177,8 +1174,8 @@ static int stm32_of_dma_tx_probe(struct stm32_port *stm32port,
 		return -ENODEV;
 	}
 	stm32port->tx_buf = dma_alloc_coherent(&pdev->dev, TX_BUF_L,
-						 &stm32port->tx_dma_buf,
-						 GFP_KERNEL);
+					       &stm32port->tx_dma_buf,
+					       GFP_KERNEL);
 	if (!stm32port->tx_buf) {
 		ret = -ENOMEM;
 		goto alloc_err;
@@ -1322,7 +1319,6 @@ static int stm32_serial_remove(struct platform_device *pdev)
 	return err;
 }
 
-
 #ifdef CONFIG_SERIAL_STM32_CONSOLE
 static void stm32_console_putchar(struct uart_port *port, int ch)
 {
@@ -1335,7 +1331,8 @@ static void stm32_console_putchar(struct uart_port *port, int ch)
 	writel_relaxed(ch, port->membase + ofs->tdr);
 }
 
-static void stm32_console_write(struct console *co, const char *s, unsigned cnt)
+static void stm32_console_write(struct console *co, const char *s,
+				unsigned int cnt)
 {
 	struct uart_port *port = &stm32_ports[co->index].port;
 	struct stm32_port *stm32_port = to_stm32_port(port);
@@ -1388,7 +1385,7 @@ static int stm32_console_setup(struct console *co, char *options)
 	 * this to be called during the uart port registration when the
 	 * driver gets probed and the port should be mapped at that point.
 	 */
-	if (stm32port->port.mapbase == 0 || stm32port->port.membase == NULL)
+	if (stm32port->port.mapbase == 0 || !stm32port->port.membase)
 		return -ENXIO;
 
 	if (options)
-- 
2.30.2



