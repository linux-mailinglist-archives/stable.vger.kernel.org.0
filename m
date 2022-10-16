Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9A35FFEE5
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 13:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiJPLQT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 07:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiJPLQS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 07:16:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9378357E8
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 04:16:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8DA2CB80B91
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 11:16:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAFF0C433C1;
        Sun, 16 Oct 2022 11:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665918974;
        bh=CO7hO20a4iAm8xljGBKsyuUE0aN9m6wUdAs8I2i4GZg=;
        h=Subject:To:Cc:From:Date:From;
        b=0RKDqQUeW9vy4oET8HhEKZedGfqSCQrEK/FCs57EcZ/ihIu9ZCGpV2GUg9KF86JB8
         Q+qVf4iU+6Svc8RIhDveBYo2xbvCfPc4wM+KKTfaLTnj5Ew5VnMa0b7X5rIqQhIn5M
         oj4L8f8kOzJqSvoATMLhtuC8NlmmPgbx4KiGZ31E=
Subject: FAILED: patch "[PATCH] serial: stm32: Deassert Transmit Enable on ->rs485_config()" failed to apply to 5.10-stable tree
To:     lukas@wunner.de, gregkh@linuxfoundation.org,
        ilpo.jarvinen@linux.intel.com, marex@denx.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 13:16:52 +0200
Message-ID: <16659190125234@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

adafbbf6895e ("serial: stm32: Deassert Transmit Enable on ->rs485_config()")
d7c76716169d ("serial: stm32: Use TC interrupt to deassert GPIO RTS in RS485 mode")
3bcea529b295 ("serial: stm32: Factor out GPIO RTS toggling into separate function")
037b91ec7729 ("serial: stm32: fix software flow control transfer")
2a3bcfe03725 ("serial: stm32: fix flow control transfer in DMA mode")
33bb2f6ac308 ("serial: stm32: rework RX over DMA")
cc58d0a3f0a4 ("serial: stm32: re-introduce an irq flag condition in usart_receive_chars")
2aa1bbb21f26 ("serial: stm32: add FIFO threshold configuration")
cea37afd28f1 ("serial: stm32: defer sysrq processing")
e359b4411c28 ("serial: stm32: fix threaded interrupt handling")
3d530017bef1 ("serial: stm32: update wakeup IRQ management")
3db1d52466dc ("serial: stm32: fix tx_empty condition")
12761869f0ef ("serial: stm32: fix wake-up flag handling")
ad7676812437 ("serial: stm32: fix a deadlock condition with wakeup event")
25a8e7611da5 ("serial: stm32: fix TX and RX FIFO thresholds")
f4518a8a75f5 ("serial: stm32: fix startup by enabling usart for reception")
87fd0741d6dc ("serial: stm32: fix probe and remove order for dma")
a99163e9e708 ("Merge tag 'devicetree-for-5.12' of git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From adafbbf6895eb0ce41a313c6ee68870ab9aa93cd Mon Sep 17 00:00:00 2001
From: Lukas Wunner <lukas@wunner.de>
Date: Sun, 11 Sep 2022 11:02:03 +0200
Subject: [PATCH] serial: stm32: Deassert Transmit Enable on ->rs485_config()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The STM32 USART can control RS-485 Transmit Enable in hardware.  Since
commit 7df5081cbf5e ("serial: stm32: Add RS485 RTS GPIO control"),
it can alternatively be controlled in software.  That was done to allow
RS-485 even if the RTS pin is unavailable because it's pinmuxed to a
different function.

However the commit neglected to deassert Transmit Enable upon invocation
of the ->rs485_config() callback.  Fix it.

Avoid forward declarations by moving stm32_usart_tx_empty(),
stm32_usart_rs485_rts_enable() and stm32_usart_rs485_rts_disable()
further up in the driver.

Fixes: 7df5081cbf5e ("serial: stm32: Add RS485 RTS GPIO control")
Cc: stable@vger.kernel.org # v5.9+
Cc: Marek Vasut <marex@denx.de>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Link: https://lore.kernel.org/r/6059eab35dba394468335ef640df8b0050fd9dbd.1662886616.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index 0b18615b2ca4..c48f225eba86 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -131,6 +131,53 @@ static void stm32_usart_clr_bits(struct uart_port *port, u32 reg, u32 bits)
 	writel_relaxed(val, port->membase + reg);
 }
 
+static unsigned int stm32_usart_tx_empty(struct uart_port *port)
+{
+	struct stm32_port *stm32_port = to_stm32_port(port);
+	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
+
+	if (readl_relaxed(port->membase + ofs->isr) & USART_SR_TC)
+		return TIOCSER_TEMT;
+
+	return 0;
+}
+
+static void stm32_usart_rs485_rts_enable(struct uart_port *port)
+{
+	struct stm32_port *stm32_port = to_stm32_port(port);
+	struct serial_rs485 *rs485conf = &port->rs485;
+
+	if (stm32_port->hw_flow_control ||
+	    !(rs485conf->flags & SER_RS485_ENABLED))
+		return;
+
+	if (rs485conf->flags & SER_RS485_RTS_ON_SEND) {
+		mctrl_gpio_set(stm32_port->gpios,
+			       stm32_port->port.mctrl | TIOCM_RTS);
+	} else {
+		mctrl_gpio_set(stm32_port->gpios,
+			       stm32_port->port.mctrl & ~TIOCM_RTS);
+	}
+}
+
+static void stm32_usart_rs485_rts_disable(struct uart_port *port)
+{
+	struct stm32_port *stm32_port = to_stm32_port(port);
+	struct serial_rs485 *rs485conf = &port->rs485;
+
+	if (stm32_port->hw_flow_control ||
+	    !(rs485conf->flags & SER_RS485_ENABLED))
+		return;
+
+	if (rs485conf->flags & SER_RS485_RTS_ON_SEND) {
+		mctrl_gpio_set(stm32_port->gpios,
+			       stm32_port->port.mctrl & ~TIOCM_RTS);
+	} else {
+		mctrl_gpio_set(stm32_port->gpios,
+			       stm32_port->port.mctrl | TIOCM_RTS);
+	}
+}
+
 static void stm32_usart_config_reg_rs485(u32 *cr1, u32 *cr3, u32 delay_ADE,
 					 u32 delay_DDE, u32 baud)
 {
@@ -214,6 +261,12 @@ static int stm32_usart_config_rs485(struct uart_port *port, struct ktermios *ter
 
 	stm32_usart_set_bits(port, ofs->cr1, BIT(cfg->uart_enable_bit));
 
+	/* Adjust RTS polarity in case it's driven in software */
+	if (stm32_usart_tx_empty(port))
+		stm32_usart_rs485_rts_disable(port);
+	else
+		stm32_usart_rs485_rts_enable(port);
+
 	return 0;
 }
 
@@ -529,42 +582,6 @@ static void stm32_usart_tc_interrupt_disable(struct uart_port *port)
 	stm32_usart_clr_bits(port, ofs->cr1, USART_CR1_TCIE);
 }
 
-static void stm32_usart_rs485_rts_enable(struct uart_port *port)
-{
-	struct stm32_port *stm32_port = to_stm32_port(port);
-	struct serial_rs485 *rs485conf = &port->rs485;
-
-	if (stm32_port->hw_flow_control ||
-	    !(rs485conf->flags & SER_RS485_ENABLED))
-		return;
-
-	if (rs485conf->flags & SER_RS485_RTS_ON_SEND) {
-		mctrl_gpio_set(stm32_port->gpios,
-			       stm32_port->port.mctrl | TIOCM_RTS);
-	} else {
-		mctrl_gpio_set(stm32_port->gpios,
-			       stm32_port->port.mctrl & ~TIOCM_RTS);
-	}
-}
-
-static void stm32_usart_rs485_rts_disable(struct uart_port *port)
-{
-	struct stm32_port *stm32_port = to_stm32_port(port);
-	struct serial_rs485 *rs485conf = &port->rs485;
-
-	if (stm32_port->hw_flow_control ||
-	    !(rs485conf->flags & SER_RS485_ENABLED))
-		return;
-
-	if (rs485conf->flags & SER_RS485_RTS_ON_SEND) {
-		mctrl_gpio_set(stm32_port->gpios,
-			       stm32_port->port.mctrl & ~TIOCM_RTS);
-	} else {
-		mctrl_gpio_set(stm32_port->gpios,
-			       stm32_port->port.mctrl | TIOCM_RTS);
-	}
-}
-
 static void stm32_usart_transmit_chars_pio(struct uart_port *port)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
@@ -807,17 +824,6 @@ static irqreturn_t stm32_usart_threaded_interrupt(int irq, void *ptr)
 	return IRQ_HANDLED;
 }
 
-static unsigned int stm32_usart_tx_empty(struct uart_port *port)
-{
-	struct stm32_port *stm32_port = to_stm32_port(port);
-	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
-
-	if (readl_relaxed(port->membase + ofs->isr) & USART_SR_TC)
-		return TIOCSER_TEMT;
-
-	return 0;
-}
-
 static void stm32_usart_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);

