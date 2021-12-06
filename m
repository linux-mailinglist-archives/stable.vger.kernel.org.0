Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75FD5469A9B
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345433AbhLFPJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:09:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40296 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345569AbhLFPHI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:07:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C766B8111E;
        Mon,  6 Dec 2021 15:03:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7276EC341C1;
        Mon,  6 Dec 2021 15:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803017;
        bh=j3PJDrd0Ud2GSI7IDy2tnjRp8lzBXwljHPtV48Tm5Ig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0KMr8DKQi7vZxpl7sD2i030ccrrMlBSLdEwRFTOxbsfbCjPZaAGaMELUT7xKOFzNo
         Naqx91OtCyGeaErocTgZ/5y8+FIyR5Uqhf32b9oskbJV3S8AXoHBy7R5ufO0uzxObZ
         yJFMvzE1dNEUDP/yUHd/F9+634ip3ru/mhpjIBRk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Baruch Siach <baruch@tkos.co.il>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.9 62/62] serial: core: fix transmit-buffer reset and memleak
Date:   Mon,  6 Dec 2021 15:56:45 +0100
Message-Id: <20211206145551.351576576@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145549.155163074@linuxfoundation.org>
References: <20211206145549.155163074@linuxfoundation.org>
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
@@ -1522,6 +1522,7 @@ static void uart_tty_port_shutdown(struc
 {
 	struct uart_state *state = container_of(port, struct uart_state, port);
 	struct uart_port *uport = uart_port_check(state);
+	char *buf;
 
 	/*
 	 * At this point, we stop accepting input.  To do this, we
@@ -1543,8 +1544,18 @@ static void uart_tty_port_shutdown(struc
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


