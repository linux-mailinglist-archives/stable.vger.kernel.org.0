Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F6E37C7C6
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbhELQCd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:02:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:36752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238192AbhELP5a (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:57:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69B2A6193E;
        Wed, 12 May 2021 15:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833440;
        bh=4CyxnMvVLxRt5bRTu4GPSWoOUFR5aL5t4joZXO2w+PM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jy1w1TwhXVAukQ5QDzlVn9f1hTX7UAobh63b2+W3/wMlkEsnkg0/d5vUm923bcMM3
         ge6L3R69pb3PTNH0GQZJ/M+U1fWbnGHh+jFI3ibI7ojfay0q1e8daqijf3LCRPF+i3
         Y1M9I0SWIv7QPAEk/GYcmdl6FaEvouM+A6A4zmSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erwan Le Ray <erwan.leray@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 152/601] serial: stm32: fix a deadlock in set_termios
Date:   Wed, 12 May 2021 16:43:49 +0200
Message-Id: <20210512144832.819483452@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erwan Le Ray <erwan.leray@foss.st.com>

[ Upstream commit 436c97936001776f16153771ee887f125443e974 ]

CTS/RTS GPIOs support that has been added recently to STM32 UART driver has
introduced scheduled code in a set_termios part protected by a spin lock.
This generates a potential deadlock scenario:

Chain exists of:
&irq_desc_lock_class --> console_owner --> &port_lock_key

Possible unsafe locking scenario:

     CPU0                    CPU1
     ----                    ----
lock(&port_lock_key);
                           lock(console_owner);
                           lock(&port_lock_key);
lock(&irq_desc_lock_class);

*** DEADLOCK ***
4 locks held by stty/766:

Move the scheduled code after the spinlock.

Fixes: 6cf61b9bd7cc ("tty: serial: Add modem control gpio support for STM32 UART")
Signed-off-by: Erwan Le Ray <erwan.leray@foss.st.com>
Link: https://lore.kernel.org/r/20210304162308.8984-8-erwan.leray@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/stm32-usart.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index 85e9a4d4e91d..44522ddc7e6d 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -827,12 +827,6 @@ static void stm32_usart_set_termios(struct uart_port *port,
 		cr3 |= USART_CR3_CTSE | USART_CR3_RTSE;
 	}
 
-	/* Handle modem control interrupts */
-	if (UART_ENABLE_MS(port, termios->c_cflag))
-		stm32_usart_enable_ms(port);
-	else
-		stm32_usart_disable_ms(port);
-
 	usartdiv = DIV_ROUND_CLOSEST(port->uartclk, baud);
 
 	/*
@@ -914,6 +908,12 @@ static void stm32_usart_set_termios(struct uart_port *port,
 
 	stm32_usart_set_bits(port, ofs->cr1, BIT(cfg->uart_enable_bit));
 	spin_unlock_irqrestore(&port->lock, flags);
+
+	/* Handle modem control interrupts */
+	if (UART_ENABLE_MS(port, termios->c_cflag))
+		stm32_usart_enable_ms(port);
+	else
+		stm32_usart_disable_ms(port);
 }
 
 static const char *stm32_usart_type(struct uart_port *port)
-- 
2.30.2



