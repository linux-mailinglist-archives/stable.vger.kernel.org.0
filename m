Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B758937CBC8
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236394AbhELQhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:37:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:44582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233893AbhELQ2F (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:28:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 281D2613D3;
        Wed, 12 May 2021 15:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834981;
        bh=lk9tu94Lwm8/riKxHRlcd/USiVXjtwmDE+xZTkh7tkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EPsKu8yHhAf2gv8RPMadIDsU7xz4KCZxofbEbaXYPyiCe8noEREySPwTqtzbntd08
         RjC4BdyBcLzvogMVdo1abDUz3dj1fax47SNKp16C4D7kNfn/Jx1YfXThxBr2i8z/eS
         rE9SaiJLnL4Y2NwwF53StkZ/SN66yETt2TRWnTF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erwan Le Ray <erwan.leray@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 162/677] serial: stm32: fix TX and RX FIFO thresholds
Date:   Wed, 12 May 2021 16:43:28 +0200
Message-Id: <20210512144842.631267364@linuxfoundation.org>
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
index eae54b8cf5e2..223cec70c57c 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -649,19 +649,8 @@ static int stm32_usart_startup(struct uart_port *port)
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
@@ -770,9 +759,15 @@ static void stm32_usart_set_termios(struct uart_port *port,
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



