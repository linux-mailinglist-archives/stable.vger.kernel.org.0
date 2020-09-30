Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2976927E88E
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 14:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729666AbgI3M3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Sep 2020 08:29:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbgI3M3u (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Sep 2020 08:29:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 573332071E;
        Wed, 30 Sep 2020 12:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601468987;
        bh=r2vKV/IzObxeLgTeLfEAWEhgqG911t/wfAcsylPXryE=;
        h=Subject:To:From:Date:From;
        b=FQjBYTMuSncPe6hoimQJmAB/dcOfbQNF8nUnxQr6hJyMLZQ8hL8qlvhBuNHqgTD71
         3m1ny8D5+NAGu7WUReKiaLP/QMt8a/xtlszFb9c3T4KvO17GgPaIvc9wQqdMxLBAGy
         9dGj3/gDNtxf7HOV1ZIWEJzC9qoCRYv7dTfkHA5M=
Subject: patch "tty: serial: lpuart: fix lpuart32_write usage" added to tty-testing
To:     peng.fan@nxp.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 30 Sep 2020 14:29:51 +0200
Message-ID: <1601468991123104@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tty: serial: lpuart: fix lpuart32_write usage

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the tty-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 9ea40db477c024dcb87321b7f32bd6ea12130ac2 Mon Sep 17 00:00:00 2001
From: Peng Fan <peng.fan@nxp.com>
Date: Tue, 29 Sep 2020 17:19:20 +0800
Subject: tty: serial: lpuart: fix lpuart32_write usage

The 2nd and 3rd parameter were wrongly used, and cause kernel abort when
doing kgdb debug.

Fixes: 1da17d7cf8e2 ("tty: serial: fsl_lpuart: Use appropriate lpuart32_* I/O funcs")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/r/20200929091920.22612-1-peng.fan@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/fsl_lpuart.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 5a5a22d77841..645bbb24b433 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -649,26 +649,24 @@ static int lpuart32_poll_init(struct uart_port *port)
 	spin_lock_irqsave(&sport->port.lock, flags);
 
 	/* Disable Rx & Tx */
-	lpuart32_write(&sport->port, UARTCTRL, 0);
+	lpuart32_write(&sport->port, 0, UARTCTRL);
 
 	temp = lpuart32_read(&sport->port, UARTFIFO);
 
 	/* Enable Rx and Tx FIFO */
-	lpuart32_write(&sport->port, UARTFIFO,
-		       temp | UARTFIFO_RXFE | UARTFIFO_TXFE);
+	lpuart32_write(&sport->port, temp | UARTFIFO_RXFE | UARTFIFO_TXFE, UARTFIFO);
 
 	/* flush Tx and Rx FIFO */
-	lpuart32_write(&sport->port, UARTFIFO,
-		       UARTFIFO_TXFLUSH | UARTFIFO_RXFLUSH);
+	lpuart32_write(&sport->port, UARTFIFO_TXFLUSH | UARTFIFO_RXFLUSH, UARTFIFO);
 
 	/* explicitly clear RDRF */
 	if (lpuart32_read(&sport->port, UARTSTAT) & UARTSTAT_RDRF) {
 		lpuart32_read(&sport->port, UARTDATA);
-		lpuart32_write(&sport->port, UARTFIFO, UARTFIFO_RXUF);
+		lpuart32_write(&sport->port, UARTFIFO_RXUF, UARTFIFO);
 	}
 
 	/* Enable Rx and Tx */
-	lpuart32_write(&sport->port, UARTCTRL, UARTCTRL_RE | UARTCTRL_TE);
+	lpuart32_write(&sport->port, UARTCTRL_RE | UARTCTRL_TE, UARTCTRL);
 	spin_unlock_irqrestore(&sport->port.lock, flags);
 
 	return 0;
@@ -677,7 +675,7 @@ static int lpuart32_poll_init(struct uart_port *port)
 static void lpuart32_poll_put_char(struct uart_port *port, unsigned char c)
 {
 	lpuart32_wait_bit_set(port, UARTSTAT, UARTSTAT_TDRE);
-	lpuart32_write(port, UARTDATA, c);
+	lpuart32_write(port, c, UARTDATA);
 }
 
 static int lpuart32_poll_get_char(struct uart_port *port)
-- 
2.28.0


