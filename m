Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96DD213F52E
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389238AbgAPSyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:54:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:40524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389232AbgAPRHx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:07:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA41F21582;
        Thu, 16 Jan 2020 17:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194472;
        bh=UdImy3XGbb6aCS0QH1nljG7T3sP7qCMYcI6nIQMmEeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e/psCt5JXj9N7Pmyczt3NWfSuaFqzzlvEk6v/L8RhP1SG8jj+FS9DMqMZhpmFzk9B
         +UW7TjGvrqzFM0hZ6mA4LGpfejUtqbBYsDSPGTsroNXpY10Vf74fMiGGvshWMvshJ1
         G4GE9j71ETPqEkJmWQnHepQe6cNg2YvtguKasmEc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Erwan Le Ray <erwan.leray@st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 377/671] serial: stm32: Add support of TC bit status check
Date:   Thu, 16 Jan 2020 12:00:15 -0500
Message-Id: <20200116170509.12787-114-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erwan Le Ray <erwan.leray@st.com>

[ Upstream commit 64c32eab660386f9904bb295a104c9c425e9f8b2 ]

Adds a check on the Transmission Complete bit status before closing the
com port. Prevents the port closure before the end of the transmission.
TC poll loop is moved from stm32_tx_dma_complete to stm32_shutdown
routine, in order to check TC before shutdown in both dma and
PIO tx modes.
TC clear is added in stm32_transmit_char routine, in order to be cleared
before transmitting in both dma and PIO tx modes.

Fixes: 3489187204eb ("serial: stm32: adding dma support")
Signed-off-by: Erwan Le Ray <erwan.leray@st.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/stm32-usart.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index 2e7757d5e5d8..d603be9669a9 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -290,21 +290,6 @@ static void stm32_tx_dma_complete(void *arg)
 	struct uart_port *port = arg;
 	struct stm32_port *stm32port = to_stm32_port(port);
 	struct stm32_usart_offsets *ofs = &stm32port->info->ofs;
-	unsigned int isr;
-	int ret;
-
-	ret = readl_relaxed_poll_timeout_atomic(port->membase + ofs->isr,
-						isr,
-						(isr & USART_SR_TC),
-						10, 100000);
-
-	if (ret)
-		dev_err(port->dev, "terminal count not set\n");
-
-	if (ofs->icr == UNDEF_REG)
-		stm32_clr_bits(port, ofs->isr, USART_SR_TC);
-	else
-		stm32_set_bits(port, ofs->icr, USART_CR_TC);
 
 	stm32_clr_bits(port, ofs->cr3, USART_CR3_DMAT);
 	stm32port->tx_dma_busy = false;
@@ -396,7 +381,6 @@ static void stm32_transmit_chars_dma(struct uart_port *port)
 	/* Issue pending DMA TX requests */
 	dma_async_issue_pending(stm32port->tx_ch);
 
-	stm32_clr_bits(port, ofs->isr, USART_SR_TC);
 	stm32_set_bits(port, ofs->cr3, USART_CR3_DMAT);
 
 	xmit->tail = (xmit->tail + count) & (UART_XMIT_SIZE - 1);
@@ -425,6 +409,11 @@ static void stm32_transmit_chars(struct uart_port *port)
 		return;
 	}
 
+	if (ofs->icr == UNDEF_REG)
+		stm32_clr_bits(port, ofs->isr, USART_SR_TC);
+	else
+		stm32_set_bits(port, ofs->icr, USART_ICR_TCCF);
+
 	if (stm32_port->tx_ch)
 		stm32_transmit_chars_dma(port);
 	else
@@ -601,12 +590,21 @@ static void stm32_shutdown(struct uart_port *port)
 	struct stm32_port *stm32_port = to_stm32_port(port);
 	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
 	struct stm32_usart_config *cfg = &stm32_port->info->cfg;
-	u32 val;
+	u32 val, isr;
+	int ret;
 
 	val = USART_CR1_TXEIE | USART_CR1_RXNEIE | USART_CR1_TE | USART_CR1_RE;
 	val |= BIT(cfg->uart_enable_bit);
 	if (stm32_port->fifoen)
 		val |= USART_CR1_FIFOEN;
+
+	ret = readl_relaxed_poll_timeout(port->membase + ofs->isr,
+					 isr, (isr & USART_SR_TC),
+					 10, 100000);
+
+	if (ret)
+		dev_err(port->dev, "transmission complete not set\n");
+
 	stm32_clr_bits(port, ofs->cr1, val);
 
 	dev_pm_clear_wake_irq(port->dev);
-- 
2.20.1

