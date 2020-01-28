Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC0E814B85A
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731591AbgA1OWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:22:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:48556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731667AbgA1OWl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:22:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82CA124686;
        Tue, 28 Jan 2020 14:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221361;
        bh=W7xtTQ/Seu3GcN/vKIk0ij30T6WGNN3v6s4L10ALXG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zaBjQ0TgjnS/DwB0gdZ+zKvJQunwsCZBsXlMCpA3tA87Z2l/6f6FgR88YLF1Yg6tr
         6+DLHUjyGx4V+UQO7TL9gzvK+SfKcXJ07TMl+UYbpC0iISk2i9Z6VXpR+O9daoHQj9
         9inJO09e8unmFeB87OQhKgU7NhJGRR7fzCyFofJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erwan Le Ray <erwan.leray@st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 147/271] serial: stm32: fix transmit_chars when tx is stopped
Date:   Tue, 28 Jan 2020 15:04:56 +0100
Message-Id: <20200128135903.499231268@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erwan Le Ray <erwan.leray@st.com>

[ Upstream commit b83b957c91f68e53f0dc596e129e8305761f2a32 ]

Disables the tx irq  when the transmission is ended and updates stop_tx
conditions for code cleanup.

Fixes: 48a6092fb41f ("serial: stm32-usart: Add STM32 USART Driver")
Signed-off-by: Erwan Le Ray <erwan.leray@st.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/stm32-usart.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index 033856287ca21..ea8b591dd46f4 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -293,13 +293,8 @@ static void stm32_transmit_chars(struct uart_port *port)
 		return;
 	}
 
-	if (uart_tx_stopped(port)) {
-		stm32_stop_tx(port);
-		return;
-	}
-
-	if (uart_circ_empty(xmit)) {
-		stm32_stop_tx(port);
+	if (uart_circ_empty(xmit) || uart_tx_stopped(port)) {
+		stm32_clr_bits(port, ofs->cr1, USART_CR1_TXEIE);
 		return;
 	}
 
@@ -312,7 +307,7 @@ static void stm32_transmit_chars(struct uart_port *port)
 		uart_write_wakeup(port);
 
 	if (uart_circ_empty(xmit))
-		stm32_stop_tx(port);
+		stm32_clr_bits(port, ofs->cr1, USART_CR1_TXEIE);
 }
 
 static irqreturn_t stm32_interrupt(int irq, void *ptr)
-- 
2.20.1



