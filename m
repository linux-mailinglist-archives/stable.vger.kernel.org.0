Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3E4C404B38
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239196AbhIILvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:51:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:55122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239687AbhIILs6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:48:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2828D61268;
        Thu,  9 Sep 2021 11:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187815;
        bh=Bssx5ZbEaCre/TweHxP/RvtlxoCykNbf0SQAZ4MT+ac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JCNC2O1NSFx6j+eXraVBFqsPerFI3zbuol6RR3bFqfIIUyJaj7PWsCW60U6wBAZQs
         +Sd7m0AzHqN67H/DXL4DsicLecvTrbGHkMdj3q7UN70oq83g7X8gluqSq8ayt638tO
         32iKLckEzWXHzi3HODGl+Wy/JT14JOzX4jiuTy+I/SbF4lQ3uV1zwHW2+E9YJWLM94
         LxMVRnK7Jbz5eciDH+BaYy7MYdRWsuSiLe81vbJDUD96SaX+870Bls/dFinHHThISs
         ZEw4gYfBSbS+vh1cd9TEQ4N6OCZJgau+K+76ZDfy0VVbCZ9DJWBkiQ+j5mK13XYQDY
         S5j09aG6c5aCA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>,
        Carl Philipp Klemm <philipp@uvos.xyz>,
        Merlijn Wajer <merlijn@wizzup.org>,
        Pavel Machek <pavel@ucw.cz>,
        Sebastian Reichel <sre@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 115/252] serial: 8250_omap: Handle optional overrun-throttle-ms property
Date:   Thu,  9 Sep 2021 07:38:49 -0400
Message-Id: <20210909114106.141462-115-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 79418d4beb48..b6c731a267d2 100644
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

