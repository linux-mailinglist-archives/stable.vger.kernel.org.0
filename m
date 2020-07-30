Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED77232E20
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729416AbgG3IRf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:17:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729332AbgG3IJb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:09:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC4892074B;
        Thu, 30 Jul 2020 08:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096570;
        bh=Mq71PoAFIqvTbSxc3PBWoFGgJMVoqwJEQTwERqubN2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pRiCP9JPUQa49C0i3PtX4xvV5j3xcUwWHvDQvrRbvBSW86LjolLIEveTgvBtdst/0
         VQvbgx/MY1K23J5TTaOPRAENoLiJDzPgmDfWFbd1xg+Srms0pKbwwGUiF/c27IPmjL
         6aUKXnL6Pgw6ZYYoZS2UfkMkLqxZyFdCwgO6OE4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Winkler <danielwinkler@google.com>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Claire Chang <tientzu@chromium.org>
Subject: [PATCH 4.9 38/61] serial: 8250_mtk: Fix high-speed baud rates clamping
Date:   Thu, 30 Jul 2020 10:04:56 +0200
Message-Id: <20200730074422.675563344@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074420.811058810@linuxfoundation.org>
References: <20200730074420.811058810@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

commit 551e553f0d4ab623e2a6f424ab5834f9c7b5229c upstream.

Commit 7b668c064ec3 ("serial: 8250: Fix max baud limit in generic 8250
port") fixed limits of a baud rate setting for a generic 8250 port.
In other words since that commit the baud rate has been permitted to be
within [uartclk / 16 / UART_DIV_MAX; uartclk / 16], which is absolutely
normal for a standard 8250 UART port. But there are custom 8250 ports,
which provide extended baud rate limits. In particular the Mediatek 8250
port can work with baud rates up to "uartclk" speed.

Normally that and any other peculiarity is supposed to be handled in a
custom set_termios() callback implemented in the vendor-specific
8250-port glue-driver. Currently that is how it's done for the most of
the vendor-specific 8250 ports, but for some reason for Mediatek a
solution has been spread out to both the glue-driver and to the generic
8250-port code. Due to that a bug has been introduced, which permitted the
extended baud rate limit for all even for standard 8250-ports. The bug
has been fixed by the commit 7b668c064ec3 ("serial: 8250: Fix max baud
limit in generic 8250 port") by narrowing the baud rates limit back down to
the normal bounds. Unfortunately by doing so we also broke the
Mediatek-specific extended bauds feature.

A fix of the problem described above is twofold. First since we can't get
back the extended baud rate limits feature to the generic set_termios()
function and that method supports only a standard baud rates range, the
requested baud rate must be locally stored before calling it and then
restored back to the new termios structure after the generic set_termios()
finished its magic business. By doing so we still use the
serial8250_do_set_termios() method to set the LCR/MCR/FCR/etc. registers,
while the extended baud rate setting procedure will be performed later in
the custom Mediatek-specific set_termios() callback. Second since a true
baud rate is now fully calculated in the custom set_termios() method we
need to locally update the port timeout by calling the
uart_update_timeout() function. After the fixes described above are
implemented in the 8250_mtk.c driver, the Mediatek 8250-port should
get back to normally working with extended baud rates.

Link: https://lore.kernel.org/linux-serial/20200701211337.3027448-1-danielwinkler@google.com

Fixes: 7b668c064ec3 ("serial: 8250: Fix max baud limit in generic 8250 port")
Reported-by: Daniel Winkler <danielwinkler@google.com>
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc: stable <stable@vger.kernel.org>
Tested-by: Claire Chang <tientzu@chromium.org>
Link: https://lore.kernel.org/r/20200714124113.20918-1-Sergey.Semin@baikalelectronics.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/8250/8250_mtk.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/tty/serial/8250/8250_mtk.c
+++ b/drivers/tty/serial/8250/8250_mtk.c
@@ -45,8 +45,21 @@ mtk8250_set_termios(struct uart_port *po
 	unsigned long flags;
 	unsigned int baud, quot;
 
+	/*
+	 * Store the requested baud rate before calling the generic 8250
+	 * set_termios method. Standard 8250 port expects bauds to be
+	 * no higher than (uartclk / 16) so the baud will be clamped if it
+	 * gets out of that bound. Mediatek 8250 port supports speed
+	 * higher than that, therefore we'll get original baud rate back
+	 * after calling the generic set_termios method and recalculate
+	 * the speed later in this method.
+	 */
+	baud = tty_termios_baud_rate(termios);
+
 	serial8250_do_set_termios(port, termios, old);
 
+	tty_termios_encode_baud_rate(termios, baud, baud);
+
 	/*
 	 * Mediatek UARTs use an extra highspeed register (UART_MTK_HIGHS)
 	 *
@@ -85,6 +98,11 @@ mtk8250_set_termios(struct uart_port *po
 	 */
 	spin_lock_irqsave(&port->lock, flags);
 
+	/*
+	 * Update the per-port timeout.
+	 */
+	uart_update_timeout(port, termios->c_cflag, baud);
+
 	/* set DLAB we have cval saved in up->lcr from the call to the core */
 	serial_port_out(port, UART_LCR, up->lcr | UART_LCR_DLAB);
 	serial_dl_write(up, quot);


