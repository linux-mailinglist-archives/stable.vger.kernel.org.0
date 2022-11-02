Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1DBA6159E1
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbiKBDUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbiKBDUC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:20:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF431AF36
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:19:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30E0B6177E
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:19:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFCA7C433C1;
        Wed,  2 Nov 2022 03:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667359196;
        bh=E+C4N58Mda80xy1pqYw/XdJLO/umrJ2D6/24Dnmy3Nw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iXvFxmEZ8ysVlj0wZILxrDTNHzg6XnXAc8kW/D4EXdvDmTzL2ODxdSKdDZbO2U/ry
         HjbmvkmkI8FJJHqg7sS/MuzO6y3l+8mScBK2buGWvEoYLAJc20KY8SLPh149NKqPxa
         dbnk5gguJlz1GHHaA8dXyJh1QvvS1LPFYYSo8RqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Roosen Henri <Henri.Roosen@ginzinger.com>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        Daisuke Mizobuchi <mizo@atmark-techno.com>,
        Dominique Martinet <dominique.martinet@atmark-techno.com>
Subject: [PATCH 5.10 91/91] serial: Deassert Transmit Enable on probe in driver-specific way
Date:   Wed,  2 Nov 2022 03:34:14 +0100
Message-Id: <20221102022057.631493976@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 7c7f9bc986e698873b489c371a08f206979d06b7 upstream.

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
Signed-off-by: Daisuke Mizobuchi <mizo@atmark-techno.com>
Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_omap.c |    3 +++
 drivers/tty/serial/8250/8250_pci.c  |    9 +--------
 drivers/tty/serial/8250/8250_port.c |   12 +++++++-----
 drivers/tty/serial/fsl_lpuart.c     |    8 +++-----
 drivers/tty/serial/imx.c            |    8 ++------
 drivers/tty/serial/serial_core.c    |   30 +++++++++++++++++-------------
 6 files changed, 33 insertions(+), 37 deletions(-)

--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -342,6 +342,9 @@ static void omap8250_restore_regs(struct
 	omap8250_update_mdr1(up, priv);
 
 	up->port.ops->set_mctrl(&up->port, up->port.mctrl);
+
+	if (up->port.rs485.flags & SER_RS485_ENABLED)
+		serial8250_em485_stop_tx(up);
 }
 
 /*
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1531,7 +1531,6 @@ static int pci_fintek_init(struct pci_de
 	resource_size_t bar_data[3];
 	u8 config_base;
 	struct serial_private *priv = pci_get_drvdata(dev);
-	struct uart_8250_port *port;
 
 	if (!(pci_resource_flags(dev, 5) & IORESOURCE_IO) ||
 			!(pci_resource_flags(dev, 4) & IORESOURCE_IO) ||
@@ -1578,13 +1577,7 @@ static int pci_fintek_init(struct pci_de
 
 		pci_write_config_byte(dev, config_base + 0x06, dev->irq);
 
-		if (priv) {
-			/* re-apply RS232/485 mode when
-			 * pciserial_resume_ports()
-			 */
-			port = serial8250_get_port(priv->line[i]);
-			pci_fintek_rs485_config(&port->port, NULL);
-		} else {
+		if (!priv) {
 			/* First init without port data
 			 * force init to RS232 Mode
 			 */
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -592,7 +592,7 @@ EXPORT_SYMBOL_GPL(serial8250_rpm_put);
 static int serial8250_em485_init(struct uart_8250_port *p)
 {
 	if (p->em485)
-		return 0;
+		goto deassert_rts;
 
 	p->em485 = kmalloc(sizeof(struct uart_8250_em485), GFP_ATOMIC);
 	if (!p->em485)
@@ -608,7 +608,9 @@ static int serial8250_em485_init(struct
 	p->em485->active_timer = NULL;
 	p->em485->tx_stopped = true;
 
-	p->rs485_stop_tx(p);
+deassert_rts:
+	if (p->em485->tx_stopped)
+		p->rs485_stop_tx(p);
 
 	return 0;
 }
@@ -2030,6 +2032,9 @@ EXPORT_SYMBOL_GPL(serial8250_do_set_mctr
 
 static void serial8250_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
+	if (port->rs485.flags & SER_RS485_ENABLED)
+		return;
+
 	if (port->set_mctrl)
 		port->set_mctrl(port, mctrl);
 	else
@@ -3161,9 +3166,6 @@ static void serial8250_config_port(struc
 	if (flags & UART_CONFIG_TYPE)
 		autoconfig(up);
 
-	if (port->rs485.flags & SER_RS485_ENABLED)
-		port->rs485_config(port, &port->rs485);
-
 	/* if access method is AU, it is a 16550 with a quirk */
 	if (port->type == PORT_16550A && port->iotype == UPIO_AU)
 		up->bugs |= UART_BUG_NOMSR;
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2669,10 +2669,6 @@ static int lpuart_probe(struct platform_
 	if (ret)
 		goto failed_irq_request;
 
-	ret = uart_add_one_port(&lpuart_reg, &sport->port);
-	if (ret)
-		goto failed_attach_port;
-
 	ret = uart_get_rs485_mode(&sport->port);
 	if (ret)
 		goto failed_get_rs485;
@@ -2684,7 +2680,9 @@ static int lpuart_probe(struct platform_
 	    sport->port.rs485.delay_rts_after_send)
 		dev_err(&pdev->dev, "driver doesn't support RTS delays\n");
 
-	sport->port.rs485_config(&sport->port, &sport->port.rs485);
+	ret = uart_add_one_port(&lpuart_reg, &sport->port);
+	if (ret)
+		goto failed_attach_port;
 
 	return 0;
 
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -398,8 +398,7 @@ static void imx_uart_rts_active(struct i
 {
 	*ucr2 &= ~(UCR2_CTSC | UCR2_CTS);
 
-	sport->port.mctrl |= TIOCM_RTS;
-	mctrl_gpio_set(sport->gpios, sport->port.mctrl);
+	mctrl_gpio_set(sport->gpios, sport->port.mctrl | TIOCM_RTS);
 }
 
 /* called with port.lock taken and irqs caller dependent */
@@ -408,8 +407,7 @@ static void imx_uart_rts_inactive(struct
 	*ucr2 &= ~UCR2_CTSC;
 	*ucr2 |= UCR2_CTS;
 
-	sport->port.mctrl &= ~TIOCM_RTS;
-	mctrl_gpio_set(sport->gpios, sport->port.mctrl);
+	mctrl_gpio_set(sport->gpios, sport->port.mctrl & ~TIOCM_RTS);
 }
 
 static void start_hrtimer_ms(struct hrtimer *hrt, unsigned long msec)
@@ -2381,8 +2379,6 @@ static int imx_uart_probe(struct platfor
 		dev_err(&pdev->dev,
 			"low-active RTS not possible when receiver is off, enabling receiver\n");
 
-	imx_uart_rs485_config(&sport->port, &sport->port.rs485);
-
 	/* Disable interrupts before requesting them */
 	ucr1 = imx_uart_readl(sport, UCR1);
 	ucr1 &= ~(UCR1_ADEN | UCR1_TRDYEN | UCR1_IDEN | UCR1_RRDYEN | UCR1_RTSDEN);
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -149,15 +149,10 @@ uart_update_mctrl(struct uart_port *port
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
@@ -1359,8 +1354,13 @@ static int uart_set_rs485_config(struct
 
 	spin_lock_irqsave(&port->lock, flags);
 	ret = port->rs485_config(port, &rs485);
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
@@ -2335,7 +2335,8 @@ int uart_resume_port(struct uart_driver
 
 		uart_change_pm(state, UART_PM_STATE_ON);
 		spin_lock_irq(&uport->lock);
-		ops->set_mctrl(uport, 0);
+		if (!(uport->rs485.flags & SER_RS485_ENABLED))
+			ops->set_mctrl(uport, 0);
 		spin_unlock_irq(&uport->lock);
 		if (console_suspend_enabled || !uart_console(uport)) {
 			/* Protected by port mutex for now */
@@ -2346,7 +2347,10 @@ int uart_resume_port(struct uart_driver
 				if (tty)
 					uart_change_speed(tty, state, NULL);
 				spin_lock_irq(&uport->lock);
-				ops->set_mctrl(uport, uport->mctrl);
+				if (!(uport->rs485.flags & SER_RS485_ENABLED))
+					ops->set_mctrl(uport, uport->mctrl);
+				else
+					uport->rs485_config(uport, &uport->rs485);
 				ops->start_tx(uport);
 				spin_unlock_irq(&uport->lock);
 				tty_port_set_initialized(port, 1);
@@ -2444,10 +2448,10 @@ uart_configure_port(struct uart_driver *
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
+			port->rs485_config(port, &port->rs485);
 		spin_unlock_irqrestore(&port->lock, flags);
 
 		/*


