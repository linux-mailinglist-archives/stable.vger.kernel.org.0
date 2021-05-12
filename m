Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B24D837C152
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 16:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbhELO6g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 10:58:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:46734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231792AbhELO5A (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 10:57:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55C6F61422;
        Wed, 12 May 2021 14:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831321;
        bh=v7Fkv0DlTgNMv+406GpTTINlKashN54rcDclvb4spRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qOrJR6o5o+93z1TsLBnOxBTWlCYOkmongo2BHINwAsbc8ARyMotJZaNaAGbBml30f
         QGu58MBWtkrZ++xe6uPIMuwdOO1FJubef8rDJ87NA+KQvWqf2DVqwPHg6qz0sgrTQZ
         AUjxcxZp5g2nfz+H+AZxWIcEWOJW0+fhas+oShw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erwan Le Ray <erwan.leray@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 072/244] serial: stm32: fix incorrect characters on console
Date:   Wed, 12 May 2021 16:47:23 +0200
Message-Id: <20210512144745.343939775@linuxfoundation.org>
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

[ Upstream commit f264c6f6aece81a9f8fbdf912b20bd3feb476a7a ]

Incorrect characters are observed on console during boot. This issue occurs
when init/main.c is modifying termios settings to open /dev/console on the
rootfs.

This patch adds a waiting loop in set_termios to wait for TX shift register
empty (and TX FIFO if any) before stopping serial port.

Fixes: 48a6092fb41f ("serial: stm32-usart: Add STM32 USART Driver")
Signed-off-by: Erwan Le Ray <erwan.leray@foss.st.com>
Link: https://lore.kernel.org/r/20210304162308.8984-4-erwan.leray@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/stm32-usart.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index bf83e6c212f5..6756f73fb220 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -688,8 +688,9 @@ static void stm32_set_termios(struct uart_port *port, struct ktermios *termios,
 	unsigned int baud, bits;
 	u32 usartdiv, mantissa, fraction, oversampling;
 	tcflag_t cflag = termios->c_cflag;
-	u32 cr1, cr2, cr3;
+	u32 cr1, cr2, cr3, isr;
 	unsigned long flags;
+	int ret;
 
 	if (!stm32_port->hw_flow_control)
 		cflag &= ~CRTSCTS;
@@ -698,6 +699,15 @@ static void stm32_set_termios(struct uart_port *port, struct ktermios *termios,
 
 	spin_lock_irqsave(&port->lock, flags);
 
+	ret = readl_relaxed_poll_timeout_atomic(port->membase + ofs->isr,
+						isr,
+						(isr & USART_SR_TC),
+						10, 100000);
+
+	/* Send the TC error message only when ISR_TC is not set. */
+	if (ret)
+		dev_err(port->dev, "Transmission is not complete\n");
+
 	/* Stop serial port and reset value */
 	writel_relaxed(0, port->membase + ofs->cr1);
 
-- 
2.30.2



