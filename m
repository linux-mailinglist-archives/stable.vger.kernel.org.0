Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC1CFEEC1F
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 22:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387867AbfKDVyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:54:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:48586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387840AbfKDVyI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:54:08 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2097321D7D;
        Mon,  4 Nov 2019 21:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904447;
        bh=uVUEaIgtXkaktg71hvaC0xNXR8j2WaCarC4cO9SaM/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w6q7xat92oqbX9DFLJGIkrMZ/Ue9bvgsRvod0IVk5JQFItLKJODJhdbcdMsqUOCLB
         4UO49bVFhIwIFdq6AE/3ZWH9KYhe2orY6NeYWm1vabRB5eVqfrXnuzBJ/rDR/iJ9Bw
         Bsx8+8z3VHN+CWARdVw+z+0epN1uL55kQhs8PPTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Elwell <phil@raspberrypi.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 08/95] sc16is7xx: Fix for "Unexpected interrupt: 8"
Date:   Mon,  4 Nov 2019 22:44:06 +0100
Message-Id: <20191104212042.457694965@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212038.056365853@linuxfoundation.org>
References: <20191104212038.056365853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phil Elwell <phil@raspberrypi.org>

[ Upstream commit 30ec514d440cf2c472c8e4b0079af2c731f71a3e ]

The SC16IS752 has an Enhanced Feature Register which is aliased at the
same address as the Interrupt Identification Register; accessing it
requires that a magic value is written to the Line Configuration
Register. If an interrupt is raised while the EFR is mapped in then
the ISR won't be able to access the IIR, leading to the "Unexpected
interrupt" error messages.

Avoid the problem by claiming a mutex around accesses to the EFR
register, also claiming the mutex in the interrupt handler work
item (this is equivalent to disabling interrupts to interlock against
a non-threaded interrupt handler).

See: https://github.com/raspberrypi/linux/issues/2529

Signed-off-by: Phil Elwell <phil@raspberrypi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sc16is7xx.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index e48523da47ac9..c1655aba131f6 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -333,6 +333,7 @@ struct sc16is7xx_port {
 	struct kthread_worker		kworker;
 	struct task_struct		*kworker_task;
 	struct kthread_work		irq_work;
+	struct mutex			efr_lock;
 	struct sc16is7xx_one		p[0];
 };
 
@@ -504,6 +505,21 @@ static int sc16is7xx_set_baud(struct uart_port *port, int baud)
 		div /= 4;
 	}
 
+	/* In an amazing feat of design, the Enhanced Features Register shares
+	 * the address of the Interrupt Identification Register, and is
+	 * switched in by writing a magic value (0xbf) to the Line Control
+	 * Register. Any interrupt firing during this time will see the EFR
+	 * where it expects the IIR to be, leading to "Unexpected interrupt"
+	 * messages.
+	 *
+	 * Prevent this possibility by claiming a mutex while accessing the
+	 * EFR, and claiming the same mutex from within the interrupt handler.
+	 * This is similar to disabling the interrupt, but that doesn't work
+	 * because the bulk of the interrupt processing is run as a workqueue
+	 * job in thread context.
+	 */
+	mutex_lock(&s->efr_lock);
+
 	lcr = sc16is7xx_port_read(port, SC16IS7XX_LCR_REG);
 
 	/* Open the LCR divisors for configuration */
@@ -519,6 +535,8 @@ static int sc16is7xx_set_baud(struct uart_port *port, int baud)
 	/* Put LCR back to the normal mode */
 	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG, lcr);
 
+	mutex_unlock(&s->efr_lock);
+
 	sc16is7xx_port_update(port, SC16IS7XX_MCR_REG,
 			      SC16IS7XX_MCR_CLKSEL_BIT,
 			      prescaler);
@@ -701,6 +719,8 @@ static void sc16is7xx_ist(struct kthread_work *ws)
 {
 	struct sc16is7xx_port *s = to_sc16is7xx_port(ws, irq_work);
 
+	mutex_lock(&s->efr_lock);
+
 	while (1) {
 		bool keep_polling = false;
 		int i;
@@ -710,6 +730,8 @@ static void sc16is7xx_ist(struct kthread_work *ws)
 		if (!keep_polling)
 			break;
 	}
+
+	mutex_unlock(&s->efr_lock);
 }
 
 static irqreturn_t sc16is7xx_irq(int irq, void *dev_id)
@@ -904,6 +926,9 @@ static void sc16is7xx_set_termios(struct uart_port *port,
 	if (!(termios->c_cflag & CREAD))
 		port->ignore_status_mask |= SC16IS7XX_LSR_BRK_ERROR_MASK;
 
+	/* As above, claim the mutex while accessing the EFR. */
+	mutex_lock(&s->efr_lock);
+
 	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG,
 			     SC16IS7XX_LCR_CONF_MODE_B);
 
@@ -925,6 +950,8 @@ static void sc16is7xx_set_termios(struct uart_port *port,
 	/* Update LCR register */
 	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG, lcr);
 
+	mutex_unlock(&s->efr_lock);
+
 	/* Get baud rate generator configuration */
 	baud = uart_get_baud_rate(port, termios, old,
 				  port->uartclk / 16 / 4 / 0xffff,
@@ -1187,6 +1214,7 @@ static int sc16is7xx_probe(struct device *dev,
 	s->regmap = regmap;
 	s->devtype = devtype;
 	dev_set_drvdata(dev, s);
+	mutex_init(&s->efr_lock);
 
 	kthread_init_worker(&s->kworker);
 	kthread_init_work(&s->irq_work, sc16is7xx_ist);
-- 
2.20.1



