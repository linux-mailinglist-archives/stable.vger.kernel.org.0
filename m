Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45D940E076
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241439AbhIPQVe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:21:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:53832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241275AbhIPQPZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:15:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E211B6127B;
        Thu, 16 Sep 2021 16:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808691;
        bh=/0JtWiTJOi4JRW8g7IDSKPFVPSInRC6zR4wkgle/4Ro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fi3pVomqbQLMGgKMGCvOi4mT9YmQgCPCPOCh+ji0KUlR3UJWdYAqdUroI7oUEPxkD
         L9f+GqG4XS7HCa4Xr/6HQRWZX1VceLYEVCRO5LmjKaT56qS66eYC5FQZ/WmhKci7nA
         xgsO4FUAfsWNQ41x1axMRSkdRQlYTRUIM2OfC6Z0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carl Philipp Klemm <philipp@uvos.xyz>,
        Merlijn Wajer <merlijn@wizzup.org>,
        Pavel Machek <pavel@ucw.cz>,
        Sebastian Reichel <sre@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 187/306] serial: 8250_omap: Handle optional overrun-throttle-ms property
Date:   Thu, 16 Sep 2021 17:58:52 +0200
Message-Id: <20210916155800.457449753@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 1fe0e1fa3209ad8e9124147775bd27b1d9f04bd4 ]

Handle optional overrun-throttle-ms property as done for 8250_fsl in commit
6d7f677a2afa ("serial: 8250: Rate limit serial port rx interrupts during
input overruns"). This can be used to rate limit the UART interrupts on
noisy lines that end up producing messages like the following:

ttyS ttyS2: 4 input overrun(s)

At least on droid4, the multiplexed USB and UART port is left to UART mode
by the bootloader for a debug console, and if a USB charger is connected
on boot, we get noise on the UART until the PMIC related drivers for PHY
and charger are loaded.

With this patch and overrun-throttle-ms = <500> we avoid the extra rx
interrupts.

Cc: Carl Philipp Klemm <philipp@uvos.xyz>
Cc: Merlijn Wajer <merlijn@wizzup.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20210727103533.51547-2-tony@atomide.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_omap.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index c37468887fd2..efe4cf32add2 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -617,7 +617,7 @@ static irqreturn_t omap8250_irq(int irq, void *dev_id)
 	struct uart_port *port = dev_id;
 	struct omap8250_priv *priv = port->private_data;
 	struct uart_8250_port *up = up_to_u8250p(port);
-	unsigned int iir;
+	unsigned int iir, lsr;
 	int ret;
 
 #ifdef CONFIG_SERIAL_8250_DMA
@@ -628,6 +628,7 @@ static irqreturn_t omap8250_irq(int irq, void *dev_id)
 #endif
 
 	serial8250_rpm_get(up);
+	lsr = serial_port_in(port, UART_LSR);
 	iir = serial_port_in(port, UART_IIR);
 	ret = serial8250_handle_irq(port, iir);
 
@@ -642,6 +643,24 @@ static irqreturn_t omap8250_irq(int irq, void *dev_id)
 		serial_port_in(port, UART_RX);
 	}
 
+	/* Stop processing interrupts on input overrun */
+	if ((lsr & UART_LSR_OE) && up->overrun_backoff_time_ms > 0) {
+		unsigned long delay;
+
+		up->ier = port->serial_in(port, UART_IER);
+		if (up->ier & (UART_IER_RLSI | UART_IER_RDI)) {
+			port->ops->stop_rx(port);
+		} else {
+			/* Keep restarting the timer until
+			 * the input overrun subsides.
+			 */
+			cancel_delayed_work(&up->overrun_backoff);
+		}
+
+		delay = msecs_to_jiffies(up->overrun_backoff_time_ms);
+		schedule_delayed_work(&up->overrun_backoff, delay);
+	}
+
 	serial8250_rpm_put(up);
 
 	return IRQ_RETVAL(ret);
@@ -1353,6 +1372,10 @@ static int omap8250_probe(struct platform_device *pdev)
 		}
 	}
 
+	if (of_property_read_u32(np, "overrun-throttle-ms",
+				 &up.overrun_backoff_time_ms) != 0)
+		up.overrun_backoff_time_ms = 0;
+
 	priv->wakeirq = irq_of_parse_and_map(np, 1);
 
 	pdata = of_device_get_match_data(&pdev->dev);
-- 
2.30.2



