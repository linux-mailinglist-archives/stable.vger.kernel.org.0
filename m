Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB555FFEE7
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 13:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiJPLQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 07:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiJPLQu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 07:16:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2474E367B7
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 04:16:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC520B80C82
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 11:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF82C433C1;
        Sun, 16 Oct 2022 11:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665919006;
        bh=ZibG4E11x0SuxzewiB+5cz9Is62LQrMRd0pkPJSUxvA=;
        h=Subject:To:Cc:From:Date:From;
        b=S2kYrmlJol4GMUdNDhwuSjaDOmZBv2ruMRiVhp1kTPCJ+x168wfceRWMW+JuJbF2W
         s6/jUp2uhu+L/CxSKZSMFeiMPsllyRWqJYC+c0HiBTYkAWdMcCebhfLexSdLW6GW6q
         GHUekGmawUhM5QEcrjbwztOdtAXgjVSLDrpsyvZE=
Subject: FAILED: patch "[PATCH] serial: Deassert Transmit Enable on probe in driver-specific" failed to apply to 5.15-stable tree
To:     lukas@wunner.de, Henri.Roosen@ginzinger.com,
        gregkh@linuxfoundation.org, ilpo.jarvinen@linux.intel.com,
        matthias.schiffer@ew.tq-group.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 13:17:30 +0200
Message-ID: <166591905019035@kroah.com>
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

7c7f9bc986e6 ("serial: Deassert Transmit Enable on probe in driver-specific way")
60f361722ad2 ("serial: fsl_lpuart: Reset prior to registration")
44b27aec9d96 ("serial: core, 8250: set RS485 termination GPIO in serial core")
ae50bb275283 ("serial: take termios_rwsem for ->rs485_config() & pass termios as param")
84f2faa7852e ("serial: 8250: Remove serial_rs485 sanitization from em485")
7195eefb38d7 ("serial: fsl_lpuart: Call core's sanitization and remove custom one")
596a9171472b ("serial: Clear rs485 struct when non-RS485 mode is set")
be2e2cb1d281 ("serial: Sanitize rs485_struct")
59c221f8e126 ("serial: 8250_exar: Fill in rs485_supported")
2dbd0c14ebe8 ("serial: Move serial_rs485 sanitization into separate function")
8322b1f52715 ("serial: Add uart_rs485_config()")
d6da35e0c6d5 ("Merge 5.18-rc7 into usb-next")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7c7f9bc986e698873b489c371a08f206979d06b7 Mon Sep 17 00:00:00 2001
From: Lukas Wunner <lukas@wunner.de>
Date: Thu, 22 Sep 2022 18:27:33 +0200
Subject: [PATCH] serial: Deassert Transmit Enable on probe in driver-specific
 way
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When a UART port is newly registered, uart_configure_port() seeks to
deassert RS485 Transmit Enable by setting the RTS bit in port->mctrl.
However a number of UART drivers interpret a set RTS bit as *assertion*
instead of deassertion:  Affected drivers include those using
serial8250_em485_config() (except 8250_bcm2835aux.c) and some using
mctrl_gpio (e.g. imx.c).

Since the interpretation of the RTS bit is driver-specific, it is not
suitable as a means to centrally deassert Transmit Enable in the serial
core.  Instead, the serial core must call on drivers to deassert it in
their driver-specific way.  One way to achieve that is to call
->rs485_config().  It implicitly deasserts Transmit Enable.

So amend uart_configure_port() and uart_resume_port() to invoke
uart_rs485_config().  That allows removing calls to uart_rs485_config()
from drivers' ->probe() hooks and declaring the function static.

Skip any invocation of ->set_mctrl() if RS485 is enabled.  RS485 has no
hardware flow control, so the modem control lines are irrelevant and
need not be touched.  When leaving RS485 mode, reset the modem control
lines to the state stored in port->mctrl.  That way, UARTs which are
muxed between RS485 and RS232 transceivers drive the lines correctly
when switched to RS232.  (serial8250_do_startup() historically raises
the OUT1 modem signal because otherwise interrupts are not signaled on
ancient PC UARTs, but I believe that no longer applies to modern,
RS485-capable UARTs and is thus safe to be skipped.)

imx.c modifies port->mctrl whenever Transmit Enable is asserted and
deasserted.  Stop it from doing that so port->mctrl reflects the RS232
line state.

8250_omap.c deasserts Transmit Enable on ->runtime_resume() by calling
->set_mctrl().  Because that is now a no-op in RS485 mode, amend the
function to call serial8250_em485_stop_tx().

fsl_lpuart.c retrieves and applies the RS485 device tree properties
after registering the UART port.  Because applying now happens on
registration in uart_configure_port(), move retrieval of the properties
ahead of uart_add_one_port().

Link: https://lore.kernel.org/all/20220329085050.311408-1-matthias.schiffer@ew.tq-group.com/
Link: https://lore.kernel.org/all/8f538a8903795f22f9acc94a9a31b03c9c4ccacb.camel@ginzinger.com/
Fixes: d3b3404df318 ("serial: Fix incorrect rs485 polarity on uart open")
Cc: stable@vger.kernel.org # v4.14+
Reported-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Reported-by: Roosen Henri <Henri.Roosen@ginzinger.com>
Tested-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Link: https://lore.kernel.org/r/2de36eba3fbe11278d5002e4e501afe0ceaca039.1663863805.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 871f8a050513..41b8c6b27136 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -342,6 +342,9 @@ static void omap8250_restore_regs(struct uart_8250_port *up)
 	omap8250_update_mdr1(up, priv);
 
 	up->port.ops->set_mctrl(&up->port, up->port.mctrl);
+
+	if (up->port.rs485.flags & SER_RS485_ENABLED)
+		serial8250_em485_stop_tx(up);
 }
 
 /*
diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 0052cf899e29..8e9f247590bd 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1632,7 +1632,6 @@ static int pci_fintek_init(struct pci_dev *dev)
 	resource_size_t bar_data[3];
 	u8 config_base;
 	struct serial_private *priv = pci_get_drvdata(dev);
-	struct uart_8250_port *port;
 
 	if (!(pci_resource_flags(dev, 5) & IORESOURCE_IO) ||
 			!(pci_resource_flags(dev, 4) & IORESOURCE_IO) ||
@@ -1679,13 +1678,7 @@ static int pci_fintek_init(struct pci_dev *dev)
 
 		pci_write_config_byte(dev, config_base + 0x06, dev->irq);
 
-		if (priv) {
-			/* re-apply RS232/485 mode when
-			 * pciserial_resume_ports()
-			 */
-			port = serial8250_get_port(priv->line[i]);
-			uart_rs485_config(&port->port);
-		} else {
+		if (!priv) {
 			/* First init without port data
 			 * force init to RS232 Mode
 			 */
diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 6a3c2ead0f17..dfdd2db95cb3 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -600,7 +600,7 @@ EXPORT_SYMBOL_GPL(serial8250_rpm_put);
 static int serial8250_em485_init(struct uart_8250_port *p)
 {
 	if (p->em485)
-		return 0;
+		goto deassert_rts;
 
 	p->em485 = kmalloc(sizeof(struct uart_8250_em485), GFP_ATOMIC);
 	if (!p->em485)
@@ -616,7 +616,9 @@ static int serial8250_em485_init(struct uart_8250_port *p)
 	p->em485->active_timer = NULL;
 	p->em485->tx_stopped = true;
 
-	p->rs485_stop_tx(p);
+deassert_rts:
+	if (p->em485->tx_stopped)
+		p->rs485_stop_tx(p);
 
 	return 0;
 }
@@ -2048,6 +2050,9 @@ EXPORT_SYMBOL_GPL(serial8250_do_set_mctrl);
 
 static void serial8250_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
+	if (port->rs485.flags & SER_RS485_ENABLED)
+		return;
+
 	if (port->set_mctrl)
 		port->set_mctrl(port, mctrl);
 	else
@@ -3192,9 +3197,6 @@ static void serial8250_config_port(struct uart_port *port, int flags)
 	if (flags & UART_CONFIG_TYPE)
 		autoconfig(up);
 
-	if (port->rs485.flags & SER_RS485_ENABLED)
-		uart_rs485_config(port);
-
 	/* if access method is AU, it is a 16550 with a quirk */
 	if (port->type == PORT_16550A && port->iotype == UPIO_AU)
 		up->bugs |= UART_BUG_NOMSR;
diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index fadb49086102..67fa113f77d4 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2726,15 +2726,13 @@ static int lpuart_probe(struct platform_device *pdev)
 	if (ret)
 		goto failed_reset;
 
-	ret = uart_add_one_port(&lpuart_reg, &sport->port);
-	if (ret)
-		goto failed_attach_port;
-
 	ret = uart_get_rs485_mode(&sport->port);
 	if (ret)
 		goto failed_get_rs485;
 
-	uart_rs485_config(&sport->port);
+	ret = uart_add_one_port(&lpuart_reg, &sport->port);
+	if (ret)
+		goto failed_attach_port;
 
 	ret = devm_request_irq(&pdev->dev, sport->port.irq, handler, 0,
 				DRIVER_NAME, sport);
@@ -2744,9 +2742,9 @@ static int lpuart_probe(struct platform_device *pdev)
 	return 0;
 
 failed_irq_request:
-failed_get_rs485:
 	uart_remove_one_port(&lpuart_reg, &sport->port);
 failed_attach_port:
+failed_get_rs485:
 failed_reset:
 	lpuart_disable_clks(sport);
 	return ret;
diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 5875ee66492b..05b432dc7a85 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -380,8 +380,7 @@ static void imx_uart_rts_active(struct imx_port *sport, u32 *ucr2)
 {
 	*ucr2 &= ~(UCR2_CTSC | UCR2_CTS);
 
-	sport->port.mctrl |= TIOCM_RTS;
-	mctrl_gpio_set(sport->gpios, sport->port.mctrl);
+	mctrl_gpio_set(sport->gpios, sport->port.mctrl | TIOCM_RTS);
 }
 
 /* called with port.lock taken and irqs caller dependent */
@@ -390,8 +389,7 @@ static void imx_uart_rts_inactive(struct imx_port *sport, u32 *ucr2)
 	*ucr2 &= ~UCR2_CTSC;
 	*ucr2 |= UCR2_CTS;
 
-	sport->port.mctrl &= ~TIOCM_RTS;
-	mctrl_gpio_set(sport->gpios, sport->port.mctrl);
+	mctrl_gpio_set(sport->gpios, sport->port.mctrl & ~TIOCM_RTS);
 }
 
 static void start_hrtimer_ms(struct hrtimer *hrt, unsigned long msec)
@@ -2347,8 +2345,6 @@ static int imx_uart_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev,
 			"low-active RTS not possible when receiver is off, enabling receiver\n");
 
-	uart_rs485_config(&sport->port);
-
 	/* Disable interrupts before requesting them */
 	ucr1 = imx_uart_readl(sport, UCR1);
 	ucr1 &= ~(UCR1_ADEN | UCR1_TRDYEN | UCR1_IDEN | UCR1_RRDYEN | UCR1_RTSDEN);
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index c7113182275a..179ee199df34 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -158,15 +158,10 @@ uart_update_mctrl(struct uart_port *port, unsigned int set, unsigned int clear)
 	unsigned long flags;
 	unsigned int old;
 
-	if (port->rs485.flags & SER_RS485_ENABLED) {
-		set &= ~TIOCM_RTS;
-		clear &= ~TIOCM_RTS;
-	}
-
 	spin_lock_irqsave(&port->lock, flags);
 	old = port->mctrl;
 	port->mctrl = (old & ~clear) | set;
-	if (old != port->mctrl)
+	if (old != port->mctrl && !(port->rs485.flags & SER_RS485_ENABLED))
 		port->ops->set_mctrl(port, port->mctrl);
 	spin_unlock_irqrestore(&port->lock, flags);
 }
@@ -1391,7 +1386,7 @@ static void uart_set_rs485_termination(struct uart_port *port,
 				 !!(rs485->flags & SER_RS485_TERMINATE_BUS));
 }
 
-int uart_rs485_config(struct uart_port *port)
+static int uart_rs485_config(struct uart_port *port)
 {
 	struct serial_rs485 *rs485 = &port->rs485;
 	int ret;
@@ -1405,7 +1400,6 @@ int uart_rs485_config(struct uart_port *port)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(uart_rs485_config);
 
 static int uart_get_rs485_config(struct uart_port *port,
 			 struct serial_rs485 __user *rs485)
@@ -1444,8 +1438,13 @@ static int uart_set_rs485_config(struct tty_struct *tty, struct uart_port *port,
 
 	spin_lock_irqsave(&port->lock, flags);
 	ret = port->rs485_config(port, &tty->termios, &rs485);
-	if (!ret)
+	if (!ret) {
 		port->rs485 = rs485;
+
+		/* Reset RTS and other mctrl lines when disabling RS485 */
+		if (!(rs485.flags & SER_RS485_ENABLED))
+			port->ops->set_mctrl(port, port->mctrl);
+	}
 	spin_unlock_irqrestore(&port->lock, flags);
 	if (ret)
 		return ret;
@@ -2352,7 +2351,8 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *uport)
 
 		spin_lock_irq(&uport->lock);
 		ops->stop_tx(uport);
-		ops->set_mctrl(uport, 0);
+		if (!(uport->rs485.flags & SER_RS485_ENABLED))
+			ops->set_mctrl(uport, 0);
 		/* save mctrl so it can be restored on resume */
 		mctrl = uport->mctrl;
 		uport->mctrl = 0;
@@ -2440,7 +2440,8 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *uport)
 
 		uart_change_pm(state, UART_PM_STATE_ON);
 		spin_lock_irq(&uport->lock);
-		ops->set_mctrl(uport, 0);
+		if (!(uport->rs485.flags & SER_RS485_ENABLED))
+			ops->set_mctrl(uport, 0);
 		spin_unlock_irq(&uport->lock);
 		if (console_suspend_enabled || !uart_console(uport)) {
 			/* Protected by port mutex for now */
@@ -2451,7 +2452,10 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *uport)
 				if (tty)
 					uart_change_speed(tty, state, NULL);
 				spin_lock_irq(&uport->lock);
-				ops->set_mctrl(uport, uport->mctrl);
+				if (!(uport->rs485.flags & SER_RS485_ENABLED))
+					ops->set_mctrl(uport, uport->mctrl);
+				else
+					uart_rs485_config(uport);
 				ops->start_tx(uport);
 				spin_unlock_irq(&uport->lock);
 				tty_port_set_initialized(port, 1);
@@ -2558,10 +2562,10 @@ uart_configure_port(struct uart_driver *drv, struct uart_state *state,
 		 */
 		spin_lock_irqsave(&port->lock, flags);
 		port->mctrl &= TIOCM_DTR;
-		if (port->rs485.flags & SER_RS485_ENABLED &&
-		    !(port->rs485.flags & SER_RS485_RTS_AFTER_SEND))
-			port->mctrl |= TIOCM_RTS;
-		port->ops->set_mctrl(port, port->mctrl);
+		if (!(port->rs485.flags & SER_RS485_ENABLED))
+			port->ops->set_mctrl(port, port->mctrl);
+		else
+			uart_rs485_config(port);
 		spin_unlock_irqrestore(&port->lock, flags);
 
 		/*
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index b4c21f84ad79..d657f2a42a7b 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -951,5 +951,4 @@ static inline int uart_handle_break(struct uart_port *port)
 					 !((cflag) & CLOCAL))
 
 int uart_get_rs485_mode(struct uart_port *port);
-int uart_rs485_config(struct uart_port *port);
 #endif /* LINUX_SERIAL_CORE_H */

