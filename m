Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 748F4447C66
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 09:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238258AbhKHJAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 04:00:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:46594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238257AbhKHJAc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 04:00:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F09F261029;
        Mon,  8 Nov 2021 08:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636361868;
        bh=4wX+AII9Jyg6qEH+gRo7jIvJFABgSTjwEbhe7sn+sAA=;
        h=From:To:Cc:Subject:Date:From;
        b=i1MGeUtUKVpbNlY0JBiAfnYuiX/FAlw/CfpbJ7ClhJTWXW/QaO6Cpl8dHS0npTjys
         r9ZkRwTJRmJsh5Up0j1U4WXMT5Vhe4arYzH/jWPAVGqhnK5bM4s2Y6jX7eG00B4kjz
         n9lL8yCxDNeTqwGzMxxABjYtWLuEzUVtvT1wrpvGgrEvf1G2i8Q39uVg19nvmqCVYp
         xTdBbmpkXn70Dzl63LFjg2TIXXMpComAh3VJ35AXDl/EiKBB/eiGorFmIcyKsY4uI+
         0rH5bqLYQed03vsRsro+wNQUgP5T7C2IO8XTVAWEdgiTliTTST+aKP+db1dPjoiTeG
         hEQtMtFpoOGuA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mk0TI-0003JJ-53; Mon, 08 Nov 2021 09:57:44 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jiri Slaby <jirislaby@kernel.org>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Baruch Siach <baruch@tkos.co.il>, stable@vger.kernel.org,
        Rob Herring <robh@kernel.org>
Subject: [PATCH] serial: core: fix transmit-buffer reset and memleak
Date:   Mon,  8 Nov 2021 09:54:31 +0100
Message-Id: <20211108085431.12637-1-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 761ed4a94582 ("tty: serial_core: convert uart_close to use
tty_port_close") converted serial core to use tty_port_close() but
failed to notice that the transmit buffer still needs to be freed on
final close.

Not freeing the transmit buffer means that the buffer is no longer
cleared on next open so that any ioctl() waiting for the buffer to drain
might wait indefinitely (e.g. on termios changes) or that stale data can
end up being transmitted in case tx is restarted.

Furthermore, the buffer of any port that has been opened would leak on
driver unbind.

Note that the port lock is held when clearing the buffer pointer due to
the ldisc race worked around by commit a5ba1d95e46e ("uart: fix race
between uart_put_char() and uart_shutdown()").

Also note that the tty-port shutdown() callback is not called for
console ports so it is not strictly necessary to free the buffer page
after releasing the lock (cf. d72402145ace ("tty/serial: do not free
trasnmit buffer page under port lock")).

Reported-by: Baruch Siach <baruch@tkos.co.il>
Link: https://lore.kernel.org/r/319321886d97c456203d5c6a576a5480d07c3478.1635781688.git.baruch@tkos.co.il
Fixes: 761ed4a94582 ("tty: serial_core: convert uart_close to use tty_port_close")
Cc: stable@vger.kernel.org      # 4.9
Cc: Rob Herring <robh@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/tty/serial/serial_core.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 0e2e35ab64c7..58834698739c 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1542,6 +1542,7 @@ static void uart_tty_port_shutdown(struct tty_port *port)
 {
 	struct uart_state *state = container_of(port, struct uart_state, port);
 	struct uart_port *uport = uart_port_check(state);
+	char *buf;
 
 	/*
 	 * At this point, we stop accepting input.  To do this, we
@@ -1563,8 +1564,18 @@ static void uart_tty_port_shutdown(struct tty_port *port)
 	 */
 	tty_port_set_suspended(port, 0);
 
-	uart_change_pm(state, UART_PM_STATE_OFF);
+	/*
+	 * Free the transmit buffer.
+	 */
+	spin_lock_irq(&uport->lock);
+	buf = state->xmit.buf;
+	state->xmit.buf = NULL;
+	spin_unlock_irq(&uport->lock);
 
+	if (buf)
+		free_page((unsigned long)buf);
+
+	uart_change_pm(state, UART_PM_STATE_OFF);
 }
 
 static void uart_wait_until_sent(struct tty_struct *tty, int timeout)
-- 
2.32.0

