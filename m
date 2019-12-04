Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A60C611345D
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730033AbfLDSDX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:03:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:47000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729513AbfLDSDW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:03:22 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C25721770;
        Wed,  4 Dec 2019 18:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482602;
        bh=yswybrNRsWsvoHS/VoCxngFKHac2PIA2wYGZakRfmRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gZsdFgHOr3ynu4pA740j/L7LLXyNUqdKLgRiZj+vJHxawu50XjxOAYk9kDc6bPKFh
         ZvpZIEgW5d0XmWau27Eo1AHcFn7GR3bHEheatvadI2aLqY2gKXWIb6M1LidhJmosA7
         4z3byBuxgktn/kuZTYtO/6pznro7u5Ffbd8QV6Qk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Darwin Dingel <darwin.dingel@alliedtelesis.co.nz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 062/209] serial: 8250: Rate limit serial port rx interrupts during input overruns
Date:   Wed,  4 Dec 2019 18:54:34 +0100
Message-Id: <20191204175325.583676109@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darwin Dingel <darwin.dingel@alliedtelesis.co.nz>

[ Upstream commit 6d7f677a2afa1c82d7fc7af7f9159cbffd5dc010 ]

When a serial port gets faulty or gets flooded with inputs, its interrupt
handler starts to work double time to get the characters to the workqueue
for the tty layer to handle them. When this busy time on the serial/tty
subsystem happens during boot, where it is also busy on the userspace
trying to initialise, some processes can continuously get preempted
and will be on hold until the interrupts subside.

The fix is to backoff on processing received characters for a specified
amount of time when an input overrun is seen (received a new character
before the previous one is processed). This only stops receive and will
continue to transmit characters to serial port. After the backoff period
is done, it receive will be re-enabled. This is optional and will only
be enabled by setting 'overrun-throttle-ms' in the dts.

Signed-off-by: Darwin Dingel <darwin.dingel@alliedtelesis.co.nz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_core.c | 25 +++++++++++++++++++++++++
 drivers/tty/serial/8250/8250_fsl.c  | 23 ++++++++++++++++++++++-
 drivers/tty/serial/8250/8250_of.c   |  5 +++++
 include/linux/serial_8250.h         |  4 ++++
 4 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index d29b512a7d9fa..ceeea4b159c4b 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -953,6 +953,21 @@ static struct uart_8250_port *serial8250_find_match_or_unused(struct uart_port *
 	return NULL;
 }
 
+static void serial_8250_overrun_backoff_work(struct work_struct *work)
+{
+	struct uart_8250_port *up =
+	    container_of(to_delayed_work(work), struct uart_8250_port,
+			 overrun_backoff);
+	struct uart_port *port = &up->port;
+	unsigned long flags;
+
+	spin_lock_irqsave(&port->lock, flags);
+	up->ier |= UART_IER_RLSI | UART_IER_RDI;
+	up->port.read_status_mask |= UART_LSR_DR;
+	serial_out(up, UART_IER, up->ier);
+	spin_unlock_irqrestore(&port->lock, flags);
+}
+
 /**
  *	serial8250_register_8250_port - register a serial port
  *	@up: serial port template
@@ -1063,6 +1078,16 @@ int serial8250_register_8250_port(struct uart_8250_port *up)
 			ret = 0;
 		}
 	}
+
+	/* Initialise interrupt backoff work if required */
+	if (up->overrun_backoff_time_ms > 0) {
+		uart->overrun_backoff_time_ms = up->overrun_backoff_time_ms;
+		INIT_DELAYED_WORK(&uart->overrun_backoff,
+				  serial_8250_overrun_backoff_work);
+	} else {
+		uart->overrun_backoff_time_ms = 0;
+	}
+
 	mutex_unlock(&serial_mutex);
 
 	return ret;
diff --git a/drivers/tty/serial/8250/8250_fsl.c b/drivers/tty/serial/8250/8250_fsl.c
index 910bfee5a88b7..cc138c24ae889 100644
--- a/drivers/tty/serial/8250/8250_fsl.c
+++ b/drivers/tty/serial/8250/8250_fsl.c
@@ -48,8 +48,29 @@ int fsl8250_handle_irq(struct uart_port *port)
 
 	lsr = orig_lsr = up->port.serial_in(&up->port, UART_LSR);
 
-	if (lsr & (UART_LSR_DR | UART_LSR_BI))
+	/* Process incoming characters first */
+	if ((lsr & (UART_LSR_DR | UART_LSR_BI)) &&
+	    (up->ier & (UART_IER_RLSI | UART_IER_RDI))) {
 		lsr = serial8250_rx_chars(up, lsr);
+	}
+
+	/* Stop processing interrupts on input overrun */
+	if ((orig_lsr & UART_LSR_OE) && (up->overrun_backoff_time_ms > 0)) {
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
 
 	serial8250_modem_status(up);
 
diff --git a/drivers/tty/serial/8250/8250_of.c b/drivers/tty/serial/8250/8250_of.c
index ec510e342e06c..c51044ba503c3 100644
--- a/drivers/tty/serial/8250/8250_of.c
+++ b/drivers/tty/serial/8250/8250_of.c
@@ -232,6 +232,11 @@ static int of_platform_serial_probe(struct platform_device *ofdev)
 	if (of_property_read_bool(ofdev->dev.of_node, "auto-flow-control"))
 		port8250.capabilities |= UART_CAP_AFE;
 
+	if (of_property_read_u32(ofdev->dev.of_node,
+			"overrun-throttle-ms",
+			&port8250.overrun_backoff_time_ms) != 0)
+		port8250.overrun_backoff_time_ms = 0;
+
 	ret = serial8250_register_8250_port(&port8250);
 	if (ret < 0)
 		goto err_dispose;
diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
index a27ef5f564317..791a6be0e3949 100644
--- a/include/linux/serial_8250.h
+++ b/include/linux/serial_8250.h
@@ -134,6 +134,10 @@ struct uart_8250_port {
 	void			(*dl_write)(struct uart_8250_port *, int);
 
 	struct uart_8250_em485 *em485;
+
+	/* Serial port overrun backoff */
+	struct delayed_work overrun_backoff;
+	u32 overrun_backoff_time_ms;
 };
 
 static inline struct uart_8250_port *up_to_u8250p(struct uart_port *up)
-- 
2.20.1



