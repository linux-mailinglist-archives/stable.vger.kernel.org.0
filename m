Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC86242EF75
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 13:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238362AbhJOLQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 07:16:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238308AbhJOLQu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Oct 2021 07:16:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D75B60E97;
        Fri, 15 Oct 2021 11:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634296484;
        bh=BRXjcM2VkgHIdACN6Uci21RjfNkoi17b5AgPlMBmUc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ncSVVf1UshToceJueyF+XUupy1eqkwv4DF335ZK6LAUXilS4w4bIInpiFnvrOJ7/q
         0qi/psdsnA/Ev1ygyuEGu/2tV+vdUyS0DN6c4W+zB48juOY/PvWOFccYpd+77sViC7
         MRtTerAwAFHHEzxe1jcCbdvYtPxCE6eKGkKjS/yr5dnYMBS2EL22lmTEUI6IQlr4OA
         Yw+cPjFmBEFQiYQ4Q73zPAs8rhFF/h6XuBV51pRwBheSFCZAp/zNX67dN9Q5Uywc+J
         PdNUjCwQ8SPCQS/DUtLjUwNen6h4SV4gikl67NRw9ZKBok5uym6DAwB/ZjHjXLYYE1
         WoaBnumEWjzFA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mbLAc-0000HU-2k; Fri, 15 Oct 2021 13:14:38 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 1/3] serial: 8250: fix racy uartclk update
Date:   Fri, 15 Oct 2021 13:14:20 +0200
Message-Id: <20211015111422.1027-2-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211015111422.1027-1-johan@kernel.org>
References: <20211015111422.1027-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Johan Hovold <johan@kernel.org>
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
2.32.0

