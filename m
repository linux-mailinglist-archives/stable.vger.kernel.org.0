Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70FAD37C80D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238176AbhELQEY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:04:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:38790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235212AbhELP7S (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:59:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F41861C34;
        Wed, 12 May 2021 15:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833521;
        bh=cD7bC3DzVTH0Lq3cBh5vjAOyt2ka2dk3/JE/h8oWKic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tdkz13dn0PwvBXpFzhPSi4kqgSHDEQuVuVygwyl99oGmh4B8tcawcqlYA5chCeB3q
         TkDfPATYFN/Q18X/9Amw33fiFB4SaqNh3dYS1mwjnGK0BH8B0Rh6s5rCxDkGX5gGBJ
         sDOU/uRukfqDzApUaMc/i23qw0K2Ob6Aac+pjfoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erwan Le Ray <erwan.leray@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 148/601] serial: stm32: fix incorrect characters on console
Date:   Wed, 12 May 2021 16:43:45 +0200
Message-Id: <20210512144832.690446534@linuxfoundation.org>
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
index 909a0d991ba1..70155e0c3b02 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -736,8 +736,9 @@ static void stm32_usart_set_termios(struct uart_port *port,
 	unsigned int baud, bits;
 	u32 usartdiv, mantissa, fraction, oversampling;
 	tcflag_t cflag = termios->c_cflag;
-	u32 cr1, cr2, cr3;
+	u32 cr1, cr2, cr3, isr;
 	unsigned long flags;
+	int ret;
 
 	if (!stm32_port->hw_flow_control)
 		cflag &= ~CRTSCTS;
@@ -746,6 +747,15 @@ static void stm32_usart_set_termios(struct uart_port *port,
 
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



