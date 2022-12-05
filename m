Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85CEA6433EB
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234694AbiLETkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:40:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234611AbiLETk0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:40:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F88F5B4;
        Mon,  5 Dec 2022 11:37:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A901661321;
        Mon,  5 Dec 2022 19:37:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2CDC433B5;
        Mon,  5 Dec 2022 19:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269064;
        bh=CjqNs4n+v77KlAeOp2MB+XgdRy8QykPCntYTDV0+TBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=epi7IUGwHs5bwG6qzppAxMsu3q//ZO6ydbVeg5T4ksrXBSDHmTCxd5oEFF0AMb7jp
         3n6YDFOLpWIiD2wdNekbKsJYJkYIO9eCbveBlxnbqQZW7JvPjx3u+WPnRLnYVyapsh
         RZlGjiSubv5He3ovCMbrNf1E+r5MvCOO+4CSWm4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org, linux-serial@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marek Vasut <marex@denx.de>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Erwan Le Ray <erwan.leray@foss.st.com>,
        Jean Philippe Romain <jean-philippe.romain@foss.st.com>,
        Valentin Caron <valentin.caron@foss.st.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 112/120] serial: stm32: Use TC interrupt to deassert GPIO RTS in RS485 mode
Date:   Mon,  5 Dec 2022 20:10:52 +0100
Message-Id: <20221205190809.893879992@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Marek Vasut <marex@denx.de>

[ Upstream commit d7c76716169ddc37cf6316ff381d34ea807fbfd7 ]

In case the RS485 mode is emulated using GPIO RTS, use the TC interrupt
to deassert the GPIO RTS, otherwise the GPIO RTS stays asserted after a
transmission ended and the RS485 cannot work.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Erwan Le Ray <erwan.leray@foss.st.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jean Philippe Romain <jean-philippe.romain@foss.st.com>
Cc: Valentin Caron <valentin.caron@foss.st.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-stm32@st-md-mailman.stormreply.com
To: linux-serial@vger.kernel.org
Link: https://lore.kernel.org/r/20220430162845.244655-2-marex@denx.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/stm32-usart.c | 42 ++++++++++++++++++++++++++++++--
 drivers/tty/serial/stm32-usart.h |  1 +
 2 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index f2cef5f7ae5a..86f044a96de1 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -314,6 +314,14 @@ static void stm32_usart_tx_interrupt_enable(struct uart_port *port)
 		stm32_usart_set_bits(port, ofs->cr1, USART_CR1_TXEIE);
 }
 
+static void stm32_usart_tc_interrupt_enable(struct uart_port *port)
+{
+	struct stm32_port *stm32_port = to_stm32_port(port);
+	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
+
+	stm32_usart_set_bits(port, ofs->cr1, USART_CR1_TCIE);
+}
+
 static void stm32_usart_tx_interrupt_disable(struct uart_port *port)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
@@ -325,6 +333,14 @@ static void stm32_usart_tx_interrupt_disable(struct uart_port *port)
 		stm32_usart_clr_bits(port, ofs->cr1, USART_CR1_TXEIE);
 }
 
+static void stm32_usart_tc_interrupt_disable(struct uart_port *port)
+{
+	struct stm32_port *stm32_port = to_stm32_port(port);
+	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
+
+	stm32_usart_clr_bits(port, ofs->cr1, USART_CR1_TCIE);
+}
+
 static void stm32_usart_rs485_rts_enable(struct uart_port *port)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
@@ -462,6 +478,13 @@ static void stm32_usart_transmit_chars(struct uart_port *port)
 	u32 isr;
 	int ret;
 
+	if (!stm32_port->hw_flow_control &&
+	    port->rs485.flags & SER_RS485_ENABLED) {
+		stm32_port->txdone = false;
+		stm32_usart_tc_interrupt_disable(port);
+		stm32_usart_rs485_rts_enable(port);
+	}
+
 	if (port->x_char) {
 		if (stm32_port->tx_dma_busy)
 			stm32_usart_clr_bits(port, ofs->cr3, USART_CR3_DMAT);
@@ -501,8 +524,14 @@ static void stm32_usart_transmit_chars(struct uart_port *port)
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 		uart_write_wakeup(port);
 
-	if (uart_circ_empty(xmit))
+	if (uart_circ_empty(xmit)) {
 		stm32_usart_tx_interrupt_disable(port);
+		if (!stm32_port->hw_flow_control &&
+		    port->rs485.flags & SER_RS485_ENABLED) {
+			stm32_port->txdone = true;
+			stm32_usart_tc_interrupt_enable(port);
+		}
+	}
 }
 
 static irqreturn_t stm32_usart_interrupt(int irq, void *ptr)
@@ -515,6 +544,13 @@ static irqreturn_t stm32_usart_interrupt(int irq, void *ptr)
 
 	sr = readl_relaxed(port->membase + ofs->isr);
 
+	if (!stm32_port->hw_flow_control &&
+	    port->rs485.flags & SER_RS485_ENABLED &&
+	    (sr & USART_SR_TC)) {
+		stm32_usart_tc_interrupt_disable(port);
+		stm32_usart_rs485_rts_disable(port);
+	}
+
 	if ((sr & USART_SR_RTOF) && ofs->icr != UNDEF_REG)
 		writel_relaxed(USART_ICR_RTOCF,
 			       port->membase + ofs->icr);
@@ -612,8 +648,10 @@ static void stm32_usart_start_tx(struct uart_port *port)
 {
 	struct circ_buf *xmit = &port->state->xmit;
 
-	if (uart_circ_empty(xmit) && !port->x_char)
+	if (uart_circ_empty(xmit) && !port->x_char) {
+		stm32_usart_rs485_rts_disable(port);
 		return;
+	}
 
 	stm32_usart_rs485_rts_enable(port);
 
diff --git a/drivers/tty/serial/stm32-usart.h b/drivers/tty/serial/stm32-usart.h
index 07ac291328cd..ad6335155de2 100644
--- a/drivers/tty/serial/stm32-usart.h
+++ b/drivers/tty/serial/stm32-usart.h
@@ -267,6 +267,7 @@ struct stm32_port {
 	bool hw_flow_control;
 	bool swap;		 /* swap RX & TX pins */
 	bool fifoen;
+	bool txdone;
 	int rxftcfg;		/* RX FIFO threshold CFG      */
 	int txftcfg;		/* TX FIFO threshold CFG      */
 	bool wakeup_src;
-- 
2.35.1



