Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA130469E2D
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379267AbhLFPgw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:36:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388473AbhLFPde (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:33:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82422C09B124;
        Mon,  6 Dec 2021 07:20:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 203AA6132B;
        Mon,  6 Dec 2021 15:20:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0351DC341C1;
        Mon,  6 Dec 2021 15:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804004;
        bh=qUzsnzy+oz9t2S204ZLYjKHP1qBqmDgse3m99+KdMdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1AkEJKGbgb7mHOjPUoM1D8StUL/zDV8IHhr+J+q0lX5qhYjBJG95rgIF0k79xmdsp
         jqbKDljpkbjuHQUT5OKkpJzOqIC1BiWD66BnvQGxtvHDFV41ROYKApj0rUmkb5wrFj
         XhUgGC3Fis2Z4G452nbcFICxaW9QgKaFYJ4YaQXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Baruch Siach <baruch@tkos.co.il>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 123/130] serial: core: fix transmit-buffer reset and memleak
Date:   Mon,  6 Dec 2021 15:57:20 +0100
Message-Id: <20211206145603.907649613@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 00de977f9e0aa9760d9a79d1e41ff780f74e3424 upstream.

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

Link: https://lore.kernel.org/r/319321886d97c456203d5c6a576a5480d07c3478.1635781688.git.baruch@tkos.co.il
Fixes: 761ed4a94582 ("tty: serial_core: convert uart_close to use tty_port_close")
Cc: stable@vger.kernel.org      # 4.9
Cc: Rob Herring <robh@kernel.org>
Reported-by: Baruch Siach <baruch@tkos.co.il>
Tested-by: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20211108085431.12637-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_core.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1576,6 +1576,7 @@ static void uart_tty_port_shutdown(struc
 {
 	struct uart_state *state = container_of(port, struct uart_state, port);
 	struct uart_port *uport = uart_port_check(state);
+	char *buf;
 
 	/*
 	 * At this point, we stop accepting input.  To do this, we
@@ -1597,8 +1598,18 @@ static void uart_tty_port_shutdown(struc
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
+
+	if (buf)
+		free_page((unsigned long)buf);
 
+	uart_change_pm(state, UART_PM_STATE_OFF);
 }
 
 static void uart_wait_until_sent(struct tty_struct *tty, int timeout)


