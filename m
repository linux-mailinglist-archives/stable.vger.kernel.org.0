Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C74C337C14B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 16:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbhELO6d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 10:58:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:42902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232388AbhELO44 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 10:56:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC17561442;
        Wed, 12 May 2021 14:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831324;
        bh=LE4/1XnMc3SLI3N4ZLnZ7RPt6CtwHqOH1PVIe5JWzeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=006xOZyzSecHOyUdgedvHJC2UJ2BUPPNSWxw0SVh4nDiaPSS013fL/hs8rY8SOoF6
         QC3CKkvC7gCJ6WrQw8bN15s4NGlUF/vq/xqfBCV/jXBu6ZdB+GSSsqp+sojnGhhn24
         6JZjxo0kAZQ+k+HrPRBoMktKkZSlbVwHv2NCjZ24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erwan Le Ray <erwan.leray@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 073/244] serial: stm32: fix tx_empty condition
Date:   Wed, 12 May 2021 16:47:24 +0200
Message-Id: <20210512144745.377457199@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erwan Le Ray <erwan.leray@foss.st.com>

[ Upstream commit 3db1d52466dc11dca4e47ef12a6e6e97f846af62 ]

In "tx_empty", we should poll TC bit in both DMA and PIO modes (instead of
TXE) to check transmission data register has been transmitted independently
of the FIFO mode. TC indicates that both transmit register and shift
register are empty. When shift register is empty, tx_empty should return
TIOCSER_TEMT instead of TC value.

Cleans the USART_CR_TC TCCF register define (transmission complete clear
flag) as it is duplicate of USART_ICR_TCCF.

Fixes: 48a6092fb41f ("serial: stm32-usart: Add STM32 USART Driver")
Signed-off-by: Erwan Le Ray <erwan.leray@foss.st.com>
Link: https://lore.kernel.org/r/20210304162308.8984-13-erwan.leray@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/stm32-usart.c | 5 ++++-
 drivers/tty/serial/stm32-usart.h | 3 ---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index 6756f73fb220..23b7bdae173c 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -502,7 +502,10 @@ static unsigned int stm32_tx_empty(struct uart_port *port)
 	struct stm32_port *stm32_port = to_stm32_port(port);
 	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
 
-	return readl_relaxed(port->membase + ofs->isr) & USART_SR_TXE;
+	if (readl_relaxed(port->membase + ofs->isr) & USART_SR_TC)
+		return TIOCSER_TEMT;
+
+	return 0;
 }
 
 static void stm32_set_mctrl(struct uart_port *port, unsigned int mctrl)
diff --git a/drivers/tty/serial/stm32-usart.h b/drivers/tty/serial/stm32-usart.h
index a175c1094dc8..a0b816e0e89b 100644
--- a/drivers/tty/serial/stm32-usart.h
+++ b/drivers/tty/serial/stm32-usart.h
@@ -127,9 +127,6 @@ struct stm32_usart_info stm32h7_info = {
 /* Dummy bits */
 #define USART_SR_DUMMY_RX	BIT(16)
 
-/* USART_ICR (F7) */
-#define USART_CR_TC		BIT(6)
-
 /* USART_DR */
 #define USART_DR_MASK		GENMASK(8, 0)
 
-- 
2.30.2



