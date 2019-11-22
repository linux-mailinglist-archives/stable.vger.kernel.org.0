Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F24A51065CB
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727832AbfKVFum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:50:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:55320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727816AbfKVFuk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:50:40 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F06ED20726;
        Fri, 22 Nov 2019 05:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401838;
        bh=VvhhZrywDZUEE5Wva2ZTjgLplEjrDFba8pD+RLwlyD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uDzMLXff+yTD9nYTmCCiJaPq9AG3Kllr4ZG9jKAKr0o+k28K95lkVHN1lEolvmRtU
         ZTI5NCW+zkkFbYAlZt7sS7ck7P5Ai530H4Z0/m+NWctLO0z5InMDnvUXsQjc/b/ZeM
         0P46AxkBOa7BnreN9xQibZXXGe2tlqvalxexUE8s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Darwin Dingel <darwin.dingel@alliedtelesis.co.nz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 079/219] serial: 8250: Rate limit serial port rx interrupts during input overruns
Date:   Fri, 22 Nov 2019 00:46:51 -0500
Message-Id: <20191122054911.1750-72-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 8fe3d0ed229ed..0e65d4261f94c 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -946,6 +946,21 @@ static struct uart_8250_port *serial8250_find_match_or_unused(struct uart_port *
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
@@ -1060,6 +1075,16 @@ int serial8250_register_8250_port(struct uart_8250_port *up)
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
index 6640a4c7ddd1d..bb9571eed275d 100644
--- a/drivers/tty/serial/8250/8250_fsl.c
+++ b/drivers/tty/serial/8250/8250_fsl.c
@@ -45,8 +45,29 @@ int fsl8250_handle_irq(struct uart_port *port)
 
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
index 98125de2f0a6c..2488de1c4bc4b 100644
--- a/drivers/tty/serial/8250/8250_of.c
+++ b/drivers/tty/serial/8250/8250_of.c
@@ -244,6 +244,11 @@ static int of_platform_serial_probe(struct platform_device *ofdev)
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
index 18e21427bce43..5a655ba8d2730 100644
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

