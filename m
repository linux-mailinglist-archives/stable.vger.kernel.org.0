Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3CD129BA4A
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369003AbgJ0P7d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:59:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:56284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1804285AbgJ0PyX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:54:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4EFB20657;
        Tue, 27 Oct 2020 15:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603814062;
        bh=9CFA3euX9rYEbJKVYSLghDfyXSWascRda3Kd8WXBc0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DpbMgSMhQ/Qb+WGm8e4159mozuIAblRo0vsNhflC5oYtByzCXLZ/PHNwM/qfYBHUP
         xvtVXumXXWSG0/gOt8K86pLwra9oY1Xn/wrxAtvY8Ur8748dKjzV0Byn4M53XLYGIn
         TqTRhBYkbxMJXI4WZZG5WdSNCz3BB8hXCqGIiCJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>
Subject: [PATCH 5.9 750/757] tty: serial: lpuart: fix lpuart32_write usage
Date:   Tue, 27 Oct 2020 14:56:40 +0100
Message-Id: <20201027135525.695712810@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

commit 9ea40db477c024dcb87321b7f32bd6ea12130ac2 upstream.

The 2nd and 3rd parameter were wrongly used, and cause kernel abort when
doing kgdb debug.

Fixes: 1da17d7cf8e2 ("tty: serial: fsl_lpuart: Use appropriate lpuart32_* I/O funcs")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/r/20200929091920.22612-1-peng.fan@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/fsl_lpuart.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -649,26 +649,24 @@ static int lpuart32_poll_init(struct uar
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
@@ -677,7 +675,7 @@ static int lpuart32_poll_init(struct uar
 static void lpuart32_poll_put_char(struct uart_port *port, unsigned char c)
 {
 	lpuart32_wait_bit_set(port, UARTSTAT, UARTSTAT_TDRE);
-	lpuart32_write(port, UARTDATA, c);
+	lpuart32_write(port, c, UARTDATA);
 }
 
 static int lpuart32_poll_get_char(struct uart_port *port)


