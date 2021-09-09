Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 814264051B1
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343857AbhIIMiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:38:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349892AbhIIMb5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:31:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD90F61B26;
        Thu,  9 Sep 2021 11:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188382;
        bh=jSJqcUvCFXY0TSGL+J9ywJwvrgzomddM6ITW1FZSD/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pl4UNFSoOvHeEZAn5DrcaoExFc1/XF+Okd2Nx/l2qehY+gKJWffc3WzispvmVco7u
         EXYRv66Txc2I4YlTH9mAm8GVgi8t0gALeJOLJLETr1qC5nnjAhzot6V7bPC2I5pSkp
         XyrumU5EyAzHoowMM4loF7zCDE+umCBUlL5MfpjW4ZwFPEExRBqT7wfQNxaZAu5EJz
         Acs7S7Ehad6NLHd8WaN9PBeJBeQAQYaNYpFIxaBWTB3tp1Ef4SMyVqkFzEVc0E8lf4
         B16o4n2EX0JPIn1noUrMHmuz3fMwyIntXgkIaIqrmyeijojjCG1msnn3tOPStt1uOM
         6EKgtgn6nCNwQ==
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
Subject: [PATCH AUTOSEL 5.10 081/176] serial: 8250_omap: Handle optional overrun-throttle-ms property
Date:   Thu,  9 Sep 2021 07:49:43 -0400
Message-Id: <20210909115118.146181-81-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
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
index 95e2d6de4f21..cd85491a52f9 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -604,7 +604,7 @@ static irqreturn_t omap8250_irq(int irq, void *dev_id)
 	struct uart_port *port = dev_id;
 	struct omap8250_priv *priv = port->private_data;
 	struct uart_8250_port *up = up_to_u8250p(port);
-	unsigned int iir;
+	unsigned int iir, lsr;
 	int ret;
 
 #ifdef CONFIG_SERIAL_8250_DMA
@@ -615,6 +615,7 @@ static irqreturn_t omap8250_irq(int irq, void *dev_id)
 #endif
 
 	serial8250_rpm_get(up);
+	lsr = serial_port_in(port, UART_LSR);
 	iir = serial_port_in(port, UART_IIR);
 	ret = serial8250_handle_irq(port, iir);
 
@@ -629,6 +630,24 @@ static irqreturn_t omap8250_irq(int irq, void *dev_id)
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
@@ -1345,6 +1364,10 @@ static int omap8250_probe(struct platform_device *pdev)
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

