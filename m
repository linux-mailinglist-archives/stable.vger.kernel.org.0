Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB33A37C3D2
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbhELPWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:22:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234673AbhELPUV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:20:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D17E36157F;
        Wed, 12 May 2021 15:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832099;
        bh=z9QGBy61X1phM4yeWZEWvHLvKj6abIseK7g1QICcySQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IgUbRA0B6NPXGlPHE8q4sim7JkqpeqnHWsfbRY7+REiNEQbIbHwgtxOL8E46VKY51
         qtXdCf50uE4KKaUUXv1+Q/q8v4JF7XNgLxRj1p1Y50OmTLB0hgbquAujWVfzqN8J9Y
         jppM4+nUqqPLJdisDUNucZKIrqjTtQGRVjVPRrCA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erwan Le Ray <erwan.leray@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 140/530] serial: stm32: fix FIFO flush in startup and set_termios
Date:   Wed, 12 May 2021 16:44:10 +0200
Message-Id: <20210512144824.422264659@linuxfoundation.org>
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
index a6295897c537..6788fb3af6cb 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -656,7 +656,7 @@ static int stm32_usart_startup(struct uart_port *port)
 
 	/* RX FIFO Flush */
 	if (ofs->rqr != UNDEF_REG)
-		stm32_usart_set_bits(port, ofs->rqr, USART_RQR_RXFRQ);
+		writel_relaxed(USART_RQR_RXFRQ, port->membase + ofs->rqr);
 
 	/* RX enabling */
 	val = stm32_port->cr1_irq | USART_CR1_RE | BIT(cfg->uart_enable_bit);
@@ -760,8 +760,8 @@ static void stm32_usart_set_termios(struct uart_port *port,
 
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



