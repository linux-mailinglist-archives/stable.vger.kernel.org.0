Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45DA837C3CF
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbhELPWQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:22:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:60504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234655AbhELPUQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:20:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65FFF6147E;
        Wed, 12 May 2021 15:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832096;
        bh=7vFJxsts7R8HfZ9uk8tJK0xDqj5AYJbPncbd5hQb1ig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tMQ3cnUFvlO1Hg8hUqffDoiZ87mbMI1SRuEY4iG15dthe8VS3GNfRyI63kHp/VxhC
         nOo/2x7rNr9f2FKT/bc7Y5eib+uYkWpanNj0h66P1MXZxnv0kkaLL4MgSEzGEMRs7P
         TqP977AQWK3SQuRR8lxLTvoGaBRc+lW1SNuh6NEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erwan Le Ray <erwan.leray@foss.st.com>,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 139/530] serial: stm32: call stm32_transmit_chars locked
Date:   Wed, 12 May 2021 16:44:09 +0200
Message-Id: <20210512144824.384193444@linuxfoundation.org>
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

[ Upstream commit f16b90c2d9db3e6ac719d1946b9d335ca4ab33f3 ]

stm32_transmit_chars should be called under lock also in tx DMA callback.

Fixes: 3489187204eb ("serial: stm32: adding dma support")
Signed-off-by: Erwan Le Ray <erwan.leray@foss.st.com>
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Link: https://lore.kernel.org/r/20210304162308.8984-10-erwan.leray@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/stm32-usart.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index c2d87a8a8fe5..a6295897c537 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -290,13 +290,16 @@ static void stm32_usart_tx_dma_complete(void *arg)
 	struct uart_port *port = arg;
 	struct stm32_port *stm32port = to_stm32_port(port);
 	const struct stm32_usart_offsets *ofs = &stm32port->info->ofs;
+	unsigned long flags;
 
 	dmaengine_terminate_async(stm32port->tx_ch);
 	stm32_usart_clr_bits(port, ofs->cr3, USART_CR3_DMAT);
 	stm32port->tx_dma_busy = false;
 
 	/* Let's see if we have pending data to send */
+	spin_lock_irqsave(&port->lock, flags);
 	stm32_usart_transmit_chars(port);
+	spin_unlock_irqrestore(&port->lock, flags);
 }
 
 static void stm32_usart_tx_interrupt_enable(struct uart_port *port)
-- 
2.30.2



