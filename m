Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35BCF37C3A8
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233713AbhELPVf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:21:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:59522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234451AbhELPTX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:19:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFFC761997;
        Wed, 12 May 2021 15:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832082;
        bh=fB2ymC7lOVdckjRTUKLZpr28i4cAT/4LZHa3MvLFjqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NQ4a6pcfOTRsFpN0Z/rJJ7QcdgADYYBHHqX7wP5n/Dz1az5LbxL9eMQ8mV8/77tRK
         7vanV5oy995OUP15j2crxZbBhHaJtqOvJJ4Z8GreyVTdYfpHaz+ZQ/CxNhJLDLiewz
         OM4ENNVcGiBelnwnTRvyQ/Xfo/KGcVate/TPOW6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erwan Le Ray <erwan.leray@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 134/530] serial: stm32: fix TX and RX FIFO thresholds
Date:   Wed, 12 May 2021 16:44:04 +0200
Message-Id: <20210512144824.226900638@linuxfoundation.org>
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

[ Upstream commit 25a8e7611da5513b388165661b17173c26e12c04 ]

TX and RX FIFO thresholds may be cleared after suspend/resume, depending
on the low power mode.

Those configurations (done in startup) are not effective for UART console,
as:
- the reference manual indicates that FIFOEN bit can only be written when
  the USART is disabled (UE=0)
- a set_termios (where UE is set) is requested firstly for console
  enabling, before the startup.

Fixes: 84872dc448fe ("serial: stm32: add RX and TX FIFO flush")
Signed-off-by: Erwan Le Ray <erwan.leray@foss.st.com>
Link: https://lore.kernel.org/r/20210304162308.8984-5-erwan.leray@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/stm32-usart.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index 70155e0c3b02..91a33ec4dbb4 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -648,19 +648,8 @@ static int stm32_usart_startup(struct uart_port *port)
 	if (ofs->rqr != UNDEF_REG)
 		stm32_usart_set_bits(port, ofs->rqr, USART_RQR_RXFRQ);
 
-	/* Tx and RX FIFO configuration */
-	if (stm32_port->fifoen) {
-		val = readl_relaxed(port->membase + ofs->cr3);
-		val &= ~(USART_CR3_TXFTCFG_MASK | USART_CR3_RXFTCFG_MASK);
-		val |= USART_CR3_TXFTCFG_HALF << USART_CR3_TXFTCFG_SHIFT;
-		val |= USART_CR3_RXFTCFG_HALF << USART_CR3_RXFTCFG_SHIFT;
-		writel_relaxed(val, port->membase + ofs->cr3);
-	}
-
-	/* RX FIFO enabling */
+	/* RX enabling */
 	val = stm32_port->cr1_irq | USART_CR1_RE | BIT(cfg->uart_enable_bit);
-	if (stm32_port->fifoen)
-		val |= USART_CR1_FIFOEN;
 	stm32_usart_set_bits(port, ofs->cr1, val);
 
 	return 0;
@@ -768,9 +757,15 @@ static void stm32_usart_set_termios(struct uart_port *port,
 	if (stm32_port->fifoen)
 		cr1 |= USART_CR1_FIFOEN;
 	cr2 = 0;
+
+	/* Tx and RX FIFO configuration */
 	cr3 = readl_relaxed(port->membase + ofs->cr3);
-	cr3 &= USART_CR3_TXFTIE | USART_CR3_RXFTCFG_MASK | USART_CR3_RXFTIE
-		| USART_CR3_TXFTCFG_MASK;
+	cr3 &= USART_CR3_TXFTIE | USART_CR3_RXFTIE;
+	if (stm32_port->fifoen) {
+		cr3 &= ~(USART_CR3_TXFTCFG_MASK | USART_CR3_RXFTCFG_MASK);
+		cr3 |= USART_CR3_TXFTCFG_HALF << USART_CR3_TXFTCFG_SHIFT;
+		cr3 |= USART_CR3_RXFTCFG_HALF << USART_CR3_RXFTCFG_SHIFT;
+	}
 
 	if (cflag & CSTOPB)
 		cr2 |= USART_CR2_STOP_2B;
-- 
2.30.2



