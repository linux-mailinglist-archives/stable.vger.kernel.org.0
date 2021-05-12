Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DECB837C3AC
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233669AbhELPVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:21:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:59890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234519AbhELPTo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:19:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB4E76199D;
        Wed, 12 May 2021 15:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832087;
        bh=vb9rVOJ1HtcPAzLADRmjhcbEds3cmyQX5JJ3uQjpkGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IFum2bN9Lqp6MSBo3RlCBXGGogOwvzdSbBYoUOjUH3xDc8Y0kfGhEGOoqosj3sZDj
         KdkQCsOBg0VSr2fZWm1oXOO1u45RPF74huZ3zrxpmJ5tBx86xIcDQngbrJs2aAVP6P
         Ela3wnapCwwmNm3u+AGF8SfHah5IO16Ga2KB5nwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erwan Le Ray <erwan.leray@foss.st.com>,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 135/530] serial: stm32: fix a deadlock condition with wakeup event
Date:   Wed, 12 May 2021 16:44:05 +0200
Message-Id: <20210512144824.260785269@linuxfoundation.org>
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

[ Upstream commit ad7676812437a00a4c6be155fc17926069f99084 ]

Deadlock issue is seen when enabling CONFIG_PROVE_LOCKING=Y, and uart
console as wakeup source. Deadlock occurs when resuming from low power
mode if system is waked up via usart console.
The deadlock is triggered 100% when also disabling console suspend prior
to go to suspend.

Simplified call stack, deadlock condition:
- stm32_console_write <-- spin_lock already held
- print_circular_bug
- pm_wakeup_dev_event <-- triggers lockdep as seen above
- stm32_receive_chars
- stm32_interrupt <-- wakeup via uart console, takes the lock

So, revisit spin_lock in stm32-usart driver:
- there is no need to hold the lock to access ICR (atomic clear of status
  flags)
- only hold the lock inside stm32_receive_chars() routine (no need to
  call pm_wakeup_dev_event with lock held)
- keep stm32_transmit_chars() routine called with lock held

Fixes: 48a6092fb41f ("serial: stm32-usart: Add STM32 USART Driver")
Signed-off-by: Erwan Le Ray <erwan.leray@foss.st.com>
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Link: https://lore.kernel.org/r/20210304162308.8984-6-erwan.leray@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/stm32-usart.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index 91a33ec4dbb4..5ae3841a4a08 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -213,13 +213,18 @@ static void stm32_usart_receive_chars(struct uart_port *port, bool threaded)
 	struct tty_port *tport = &port->state->port;
 	struct stm32_port *stm32_port = to_stm32_port(port);
 	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
-	unsigned long c;
+	unsigned long c, flags;
 	u32 sr;
 	char flag;
 
 	if (irqd_is_wakeup_set(irq_get_irq_data(port->irq)))
 		pm_wakeup_event(tport->tty->dev, 0);
 
+	if (threaded)
+		spin_lock_irqsave(&port->lock, flags);
+	else
+		spin_lock(&port->lock);
+
 	while (stm32_usart_pending_rx(port, &sr, &stm32_port->last_res,
 				      threaded)) {
 		sr |= USART_SR_DUMMY_RX;
@@ -275,9 +280,12 @@ static void stm32_usart_receive_chars(struct uart_port *port, bool threaded)
 		uart_insert_char(port, sr, USART_SR_ORE, c, flag);
 	}
 
-	spin_unlock(&port->lock);
+	if (threaded)
+		spin_unlock_irqrestore(&port->lock, flags);
+	else
+		spin_unlock(&port->lock);
+
 	tty_flip_buffer_push(tport);
-	spin_lock(&port->lock);
 }
 
 static void stm32_usart_tx_dma_complete(void *arg)
@@ -458,8 +466,6 @@ static irqreturn_t stm32_usart_interrupt(int irq, void *ptr)
 	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
 	u32 sr;
 
-	spin_lock(&port->lock);
-
 	sr = readl_relaxed(port->membase + ofs->isr);
 
 	if ((sr & USART_SR_RTOF) && ofs->icr != UNDEF_REG)
@@ -473,10 +479,11 @@ static irqreturn_t stm32_usart_interrupt(int irq, void *ptr)
 	if ((sr & USART_SR_RXNE) && !(stm32_port->rx_ch))
 		stm32_usart_receive_chars(port, false);
 
-	if ((sr & USART_SR_TXE) && !(stm32_port->tx_ch))
+	if ((sr & USART_SR_TXE) && !(stm32_port->tx_ch)) {
+		spin_lock(&port->lock);
 		stm32_usart_transmit_chars(port);
-
-	spin_unlock(&port->lock);
+		spin_unlock(&port->lock);
+	}
 
 	if (stm32_port->rx_ch)
 		return IRQ_WAKE_THREAD;
@@ -489,13 +496,9 @@ static irqreturn_t stm32_usart_threaded_interrupt(int irq, void *ptr)
 	struct uart_port *port = ptr;
 	struct stm32_port *stm32_port = to_stm32_port(port);
 
-	spin_lock(&port->lock);
-
 	if (stm32_port->rx_ch)
 		stm32_usart_receive_chars(port, true);
 
-	spin_unlock(&port->lock);
-
 	return IRQ_HANDLED;
 }
 
-- 
2.30.2



