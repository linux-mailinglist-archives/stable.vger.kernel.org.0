Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D14E237CBCA
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237079AbhELQiA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:38:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:43696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236017AbhELQ22 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:28:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1349B613EB;
        Wed, 12 May 2021 15:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834986;
        bh=wpF9bj4uyWGgJtJyiv2VNMZQEBepVIvaGB5J8NY830M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e9iuLnSXyuEF69mychGR7GLpOXU4Tot0QcsxrOzrMXrTDU4MAyfJOzZe2EVzupQs+
         3EXT/uAfk5yv2VfhispnyMpKMHht/fA/n7BOU8nNLZbO++HtkEJyIzpi8ZsikkaT/J
         Zx7OwB+uNJ1lcuJoNHg7QsaVBsgJRo5htbqmlS3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erwan Le Ray <erwan.leray@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 164/677] serial: stm32: fix wake-up flag handling
Date:   Wed, 12 May 2021 16:43:30 +0200
Message-Id: <20210512144842.695159149@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erwan Le Ray <erwan.leray@foss.st.com>

[ Upstream commit 12761869f0efa524348e2ae31827fd52eebf3f0d ]

This patch fixes several issue with wake-up handling:
- the WUF irq is handled several times at wake-up
- the USART is disabled / enabled at suspend to set wake-up flag.
It can cause glitches during RX.

This patch fix those issues:
- clear wake-up flag and disable wake-up irq in WUF irq handling
- enable wake-up from low power on start bit detection at port
configuration
- Unmask the wake-up flag irq at suspend and mask it at resume

In addition, pm_wakeup_event handling is moved from receice_chars to WUF
irq handling.

Fixes: 270e5a74fe4c ("serial: stm32: add wakeup mechanism")
Signed-off-by: Erwan Le Ray <erwan.leray@foss.st.com>
Link: https://lore.kernel.org/r/20210304162308.8984-7-erwan.leray@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/stm32-usart.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index 370141445780..326f300dd410 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -218,9 +218,6 @@ static void stm32_usart_receive_chars(struct uart_port *port, bool threaded)
 	u32 sr;
 	char flag;
 
-	if (irqd_is_wakeup_set(irq_get_irq_data(port->irq)))
-		pm_wakeup_event(tport->tty->dev, 0);
-
 	if (threaded)
 		spin_lock_irqsave(&port->lock, flags);
 	else
@@ -463,6 +460,7 @@ static void stm32_usart_transmit_chars(struct uart_port *port)
 static irqreturn_t stm32_usart_interrupt(int irq, void *ptr)
 {
 	struct uart_port *port = ptr;
+	struct tty_port *tport = &port->state->port;
 	struct stm32_port *stm32_port = to_stm32_port(port);
 	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
 	u32 sr;
@@ -473,9 +471,14 @@ static irqreturn_t stm32_usart_interrupt(int irq, void *ptr)
 		writel_relaxed(USART_ICR_RTOCF,
 			       port->membase + ofs->icr);
 
-	if ((sr & USART_SR_WUF) && ofs->icr != UNDEF_REG)
+	if ((sr & USART_SR_WUF) && ofs->icr != UNDEF_REG) {
+		/* Clear wake up flag and disable wake up interrupt */
 		writel_relaxed(USART_ICR_WUCF,
 			       port->membase + ofs->icr);
+		stm32_usart_clr_bits(port, ofs->cr3, USART_CR3_WUFIE);
+		if (irqd_is_wakeup_set(irq_get_irq_data(port->irq)))
+			pm_wakeup_event(tport->tty->dev, 0);
+	}
 
 	if ((sr & USART_SR_RXNE) && !(stm32_port->rx_ch))
 		stm32_usart_receive_chars(port, false);
@@ -901,6 +904,12 @@ static void stm32_usart_set_termios(struct uart_port *port,
 		cr1 &= ~(USART_CR1_DEDT_MASK | USART_CR1_DEAT_MASK);
 	}
 
+	/* Configure wake up from low power on start bit detection */
+	if (stm32_port->wakeirq > 0) {
+		cr3 &= ~USART_CR3_WUS_MASK;
+		cr3 |= USART_CR3_WUS_START_BIT;
+	}
+
 	writel_relaxed(cr3, port->membase + ofs->cr3);
 	writel_relaxed(cr2, port->membase + ofs->cr2);
 	writel_relaxed(cr1, port->membase + ofs->cr1);
@@ -1476,23 +1485,20 @@ static void __maybe_unused stm32_usart_serial_en_wakeup(struct uart_port *port,
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
 	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
-	const struct stm32_usart_config *cfg = &stm32_port->info->cfg;
-	u32 val;
 
 	if (stm32_port->wakeirq <= 0)
 		return;
 
+	/*
+	 * Enable low-power wake-up and wake-up irq if argument is set to
+	 * "enable", disable low-power wake-up and wake-up irq otherwise
+	 */
 	if (enable) {
-		stm32_usart_clr_bits(port, ofs->cr1, BIT(cfg->uart_enable_bit));
 		stm32_usart_set_bits(port, ofs->cr1, USART_CR1_UESM);
-		val = readl_relaxed(port->membase + ofs->cr3);
-		val &= ~USART_CR3_WUS_MASK;
-		/* Enable Wake up interrupt from low power on start bit */
-		val |= USART_CR3_WUS_START_BIT | USART_CR3_WUFIE;
-		writel_relaxed(val, port->membase + ofs->cr3);
-		stm32_usart_set_bits(port, ofs->cr1, BIT(cfg->uart_enable_bit));
+		stm32_usart_set_bits(port, ofs->cr3, USART_CR3_WUFIE);
 	} else {
 		stm32_usart_clr_bits(port, ofs->cr1, USART_CR1_UESM);
+		stm32_usart_clr_bits(port, ofs->cr3, USART_CR3_WUFIE);
 	}
 }
 
-- 
2.30.2



