Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C53B537CBCC
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234750AbhELQiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:38:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:43950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234629AbhELQ2a (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:28:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 914A6613BD;
        Wed, 12 May 2021 15:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835003;
        bh=PLTfKQw5caY+K+Rp6UJM0SZ9Aq8X6/mhXXIH7X1cZWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bSicpLb1wEd7YraZpDTUSZT+In+1aiNADGlYeEqTuN/8z3O7vdn3Lo3VKlspPo3LR
         PA5L9waKKoDtbW7ZAaFPYplrO+X0rO/8L1ii05/Ygy+geR3zhau3XvfneCntfXA4dG
         FTw042+dCF7WqV1f4EzIXQ27AHxiGEcLIVKw4lmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erwan Le Ray <erwan.leray@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 169/677] serial: stm32: fix FIFO flush in startup and set_termios
Date:   Wed, 12 May 2021 16:43:35 +0200
Message-Id: <20210512144842.856817557@linuxfoundation.org>
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

[ Upstream commit 315e2d8a125ad77a1bc28f621162713f3e7aef48 ]

Fifo flush set USART_RQR register by calling stm32_usart_set_bits
routine (Read/Modify/Write). USART_RQR register is a write only
register. So, read before write isn't correct / relevant to flush
the FIFOs.
Replace stm32_usart_set_bits call by writel_relaxed.

Fixes: 84872dc448fe ("serial: stm32: add RX and TX FIFO flush")
Signed-off-by: Erwan Le Ray <erwan.leray@foss.st.com>
Link: https://lore.kernel.org/r/20210304162308.8984-11-erwan.leray@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/stm32-usart.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index 2bdd04a47f91..183c76ddb165 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -657,7 +657,7 @@ static int stm32_usart_startup(struct uart_port *port)
 
 	/* RX FIFO Flush */
 	if (ofs->rqr != UNDEF_REG)
-		stm32_usart_set_bits(port, ofs->rqr, USART_RQR_RXFRQ);
+		writel_relaxed(USART_RQR_RXFRQ, port->membase + ofs->rqr);
 
 	/* RX enabling */
 	val = stm32_port->cr1_irq | USART_CR1_RE | BIT(cfg->uart_enable_bit);
@@ -762,8 +762,8 @@ static void stm32_usart_set_termios(struct uart_port *port,
 
 	/* flush RX & TX FIFO */
 	if (ofs->rqr != UNDEF_REG)
-		stm32_usart_set_bits(port, ofs->rqr,
-				     USART_RQR_TXFRQ | USART_RQR_RXFRQ);
+		writel_relaxed(USART_RQR_TXFRQ | USART_RQR_RXFRQ,
+			       port->membase + ofs->rqr);
 
 	cr1 = USART_CR1_TE | USART_CR1_RE;
 	if (stm32_port->fifoen)
-- 
2.30.2



