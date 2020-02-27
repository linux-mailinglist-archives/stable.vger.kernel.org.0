Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 638CF171B47
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732652AbgB0OBB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:01:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:34704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732840AbgB0OBB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:01:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E96362073D;
        Thu, 27 Feb 2020 14:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812059;
        bh=yFgaM4qwrsNX7+GxOtKUYF7S97q6P22UNf9riz4tXng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vX58YR1YIjJ/Wbfi4FdrG4n0r9nwW6TyE0YsNLV580VvlT0N520Fy8BDNM+KN64mI
         PSV4VHVmdn9Xh04PH6JyMxGkKYJv1ksXMiYtpTbVUK6TWaFlh/8LbLkzR+2kS6JwQX
         W0cTvixwubVvXNhM013bDcWlosff+m26lZv6yD8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li RongQing <lirongqing@baidu.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vikram Pandita <vikram.pandita@ti.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 207/237] serial: 8250: Check UPF_IRQ_SHARED in advance
Date:   Thu, 27 Feb 2020 14:37:01 +0100
Message-Id: <20200227132311.465973412@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 7febbcbc48fc92e3f33863b32ed715ba4aff18c4 ]

The commit 54e53b2e8081
  ("tty: serial: 8250: pass IRQ shared flag to UART ports")
nicely explained the problem:

---8<---8<---

On some systems IRQ lines between multiple UARTs might be shared. If so, the
irqflags have to be configured accordingly. The reason is: The 8250 port startup
code performs IRQ tests *before* the IRQ handler for that particular port is
registered. This is performed in serial8250_do_startup(). This function checks
whether IRQF_SHARED is configured and only then disables the IRQ line while
testing.

This test is performed upon each open() of the UART device. Imagine two UARTs
share the same IRQ line: On is already opened and the IRQ is active. When the
second UART is opened, the IRQ line has to be disabled while performing IRQ
tests. Otherwise an IRQ might handler might be invoked, but the IRQ itself
cannot be handled, because the corresponding handler isn't registered,
yet. That's because the 8250 code uses a chain-handler and invokes the
corresponding port's IRQ handling routines himself.

Unfortunately this IRQF_SHARED flag isn't configured for UARTs probed via device
tree even if the IRQs are shared. This way, the actual and shared IRQ line isn't
disabled while performing tests and the kernel correctly detects a spurious
IRQ. So, adding this flag to the DT probe solves the issue.

Note: The UPF_SHARE_IRQ flag is configured unconditionally. Therefore, the
IRQF_SHARED flag can be set unconditionally as well.

Example stack trace by performing `echo 1 > /dev/ttyS2` on a non-patched system:

|irq 85: nobody cared (try booting with the "irqpoll" option)
| [...]
|handlers:
|[<ffff0000080fc628>] irq_default_primary_handler threaded [<ffff00000855fbb8>] serial8250_interrupt
|Disabling IRQ #85

---8<---8<---

But unfortunately didn't fix the root cause. Let's try again here by moving
IRQ flag assignment from serial_link_irq_chain() to serial8250_do_startup().

This should fix the similar issue reported for 8250_pnp case.

Since this change we don't need to have custom solutions in 8250_aspeed_vuart
and 8250_of drivers, thus, drop them.

Fixes: 1c2f04937b3e ("serial: 8250: add IRQ trigger support")
Reported-by: Li RongQing <lirongqing@baidu.com>
Cc: Kurt Kanzenbach <kurt@linutronix.de>
Cc: Vikram Pandita <vikram.pandita@ti.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable <stable@vger.kernel.org>
Acked-by: Kurt Kanzenbach <kurt@linutronix.de>
Link: https://lore.kernel.org/r/20200211135559.85960-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_aspeed_vuart.c | 1 -
 drivers/tty/serial/8250/8250_core.c         | 5 ++---
 drivers/tty/serial/8250/8250_port.c         | 4 ++++
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_aspeed_vuart.c b/drivers/tty/serial/8250/8250_aspeed_vuart.c
index 33a801353114c..0a89df390f248 100644
--- a/drivers/tty/serial/8250/8250_aspeed_vuart.c
+++ b/drivers/tty/serial/8250/8250_aspeed_vuart.c
@@ -256,7 +256,6 @@ static int aspeed_vuart_probe(struct platform_device *pdev)
 		port.port.line = rc;
 
 	port.port.irq = irq_of_parse_and_map(np, 0);
-	port.port.irqflags = IRQF_SHARED;
 	port.port.iotype = UPIO_MEM;
 	port.port.type = PORT_16550A;
 	port.port.uartclk = clk;
diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index c698ebab6d3bd..5017a0f46b826 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -181,7 +181,7 @@ static int serial_link_irq_chain(struct uart_8250_port *up)
 	struct hlist_head *h;
 	struct hlist_node *n;
 	struct irq_info *i;
-	int ret, irq_flags = up->port.flags & UPF_SHARE_IRQ ? IRQF_SHARED : 0;
+	int ret;
 
 	mutex_lock(&hash_mutex);
 
@@ -216,9 +216,8 @@ static int serial_link_irq_chain(struct uart_8250_port *up)
 		INIT_LIST_HEAD(&up->list);
 		i->head = &up->list;
 		spin_unlock_irq(&i->lock);
-		irq_flags |= up->port.irqflags;
 		ret = request_irq(up->port.irq, serial8250_interrupt,
-				  irq_flags, up->port.name, i);
+				  up->port.irqflags, up->port.name, i);
 		if (ret < 0)
 			serial_do_unlink(i, up);
 	}
diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index a73d2bc4b6852..90a93c001e169 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -2258,6 +2258,10 @@ int serial8250_do_startup(struct uart_port *port)
 		}
 	}
 
+	/* Check if we need to have shared IRQs */
+	if (port->irq && (up->port.flags & UPF_SHARE_IRQ))
+		up->port.irqflags |= IRQF_SHARED;
+
 	if (port->irq && !(up->port.flags & UPF_NO_THRE_TEST)) {
 		unsigned char iir1;
 		/*
-- 
2.20.1



