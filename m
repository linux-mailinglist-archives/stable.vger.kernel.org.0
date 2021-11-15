Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED4B9452191
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346063AbhKPBF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:05:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:44628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245539AbhKOTUn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15EA163274;
        Mon, 15 Nov 2021 18:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001387;
        bh=gZ/OdphLe12+OAp6ggMXDHN/GRtG9Rp+jXEap6KF+vA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tHlzpK+bvImkl2gIc6CT75+kTkiayEG9V6opeD8s3twpGJSOppbfVWIxeiTf0Ah8h
         sOhBPaJYTow2QwLsY25WU1yRztDd90Xn1iChCYWlwsaecetfQoEf/ydlsKWWVFGfL9
         xSsJbCemsQSn/jDaBMp6xnLNzeJ8xSW7bPfpXueA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Serge Semin <fancer.lancer@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 172/917] serial: 8250: fix racy uartclk update
Date:   Mon, 15 Nov 2021 17:54:27 +0100
Message-Id: <20211115165434.608510639@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 211cde4f5817dc88ef7f8f2fa286e57fbf14c8ee upstream.

Commit 868f3ee6e452 ("serial: 8250: Add 8250 port clock update method")
added a hack to support SoCs where the UART reference clock can
change behind the back of the driver but failed to add the proper
locking.

First, make sure to take a reference to the tty struct to avoid
dereferencing a NULL pointer if the clock change races with a hangup.

Second, the termios semaphore must be held during the update to prevent
a racing termios change.

Fixes: 868f3ee6e452 ("serial: 8250: Add 8250 port clock update method")
Fixes: c8dff3aa8241 ("serial: 8250: Skip uninitialized TTY port baud rate update")
Cc: stable@vger.kernel.org      # 5.9
Cc: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Tested-by: Serge Semin <fancer.lancer@gmail.com>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20211015111422.1027-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_port.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 66374704747e..e4dd82fd7c2a 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -2696,21 +2696,32 @@ static unsigned int serial8250_get_baud_rate(struct uart_port *port,
 void serial8250_update_uartclk(struct uart_port *port, unsigned int uartclk)
 {
 	struct uart_8250_port *up = up_to_u8250p(port);
+	struct tty_port *tport = &port->state->port;
 	unsigned int baud, quot, frac = 0;
 	struct ktermios *termios;
+	struct tty_struct *tty;
 	unsigned long flags;
 
-	mutex_lock(&port->state->port.mutex);
+	tty = tty_port_tty_get(tport);
+	if (!tty) {
+		mutex_lock(&tport->mutex);
+		port->uartclk = uartclk;
+		mutex_unlock(&tport->mutex);
+		return;
+	}
+
+	down_write(&tty->termios_rwsem);
+	mutex_lock(&tport->mutex);
 
 	if (port->uartclk == uartclk)
 		goto out_lock;
 
 	port->uartclk = uartclk;
 
-	if (!tty_port_initialized(&port->state->port))
+	if (!tty_port_initialized(tport))
 		goto out_lock;
 
-	termios = &port->state->port.tty->termios;
+	termios = &tty->termios;
 
 	baud = serial8250_get_baud_rate(port, termios, NULL);
 	quot = serial8250_get_divisor(port, baud, &frac);
@@ -2727,7 +2738,9 @@ void serial8250_update_uartclk(struct uart_port *port, unsigned int uartclk)
 	serial8250_rpm_put(up);
 
 out_lock:
-	mutex_unlock(&port->state->port.mutex);
+	mutex_unlock(&tport->mutex);
+	up_write(&tty->termios_rwsem);
+	tty_kref_put(tty);
 }
 EXPORT_SYMBOL_GPL(serial8250_update_uartclk);
 
-- 
2.33.1



