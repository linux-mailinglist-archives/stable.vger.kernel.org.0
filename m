Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45DB213F38E
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436791AbgAPSml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:42:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:51894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390227AbgAPRLX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:11:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80E1624686;
        Thu, 16 Jan 2020 17:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194682;
        bh=GMM7s8r0SOFZuVicWlQG6rZpTYZwNbPbSQsr0FJlWT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r9I0q5EBWt9+De2zCMwXbb8vT+qppFTQ8eQUKpKoBzGrw9/4Y3wGrA510I2lJl78I
         tMwvYz6dkwielt2mZIMUR7EwEOEXRV6lg2Q14u9ItyjC5EzfROhqIuu8lPL5a61T0o
         WCEg83gXKIj+NYHCKQpFiHbVM1IMOC0wX2rbpiow=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Stefan Agner <stefan@agner.ch>,
        Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>,
        Chris Healy <cphealy@gmail.com>,
        Cory Tusar <cory.tusar@zii.aero>,
        Lucas Stach <l.stach@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>, linux-imx@nxp.com,
        linux-serial@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 527/671] tty: serial: fsl_lpuart: Use appropriate lpuart32_* I/O funcs
Date:   Thu, 16 Jan 2020 12:02:45 -0500
Message-Id: <20200116170509.12787-264-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Smirnov <andrew.smirnov@gmail.com>

[ Upstream commit 1da17d7cf8e2c4b60163d54300f72c02f510327c ]

When dealing with 32-bit variant of LPUART IP block appropriate I/O
helpers have to be used to properly deal with endianness
differences. Change all of the offending code to do that.

Fixes: a5fa2660d787 ("tty/serial/fsl_lpuart: Add CONSOLE_POLL support
for lpuart32.")
Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Stefan Agner <stefan@agner.ch>
Cc: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Cory Tusar <cory.tusar@zii.aero>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.com>
Cc: linux-imx@nxp.com
Cc: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Link: https://lore.kernel.org/r/20190729195226.8862-14-andrew.smirnov@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/fsl_lpuart.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index ee8a5cb61a5f..2daccb10ae2f 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -528,26 +528,26 @@ static int lpuart32_poll_init(struct uart_port *port)
 	spin_lock_irqsave(&sport->port.lock, flags);
 
 	/* Disable Rx & Tx */
-	writel(0, sport->port.membase + UARTCTRL);
+	lpuart32_write(&sport->port, UARTCTRL, 0);
 
-	temp = readl(sport->port.membase + UARTFIFO);
+	temp = lpuart32_read(&sport->port, UARTFIFO);
 
 	/* Enable Rx and Tx FIFO */
-	writel(temp | UARTFIFO_RXFE | UARTFIFO_TXFE,
-		   sport->port.membase + UARTFIFO);
+	lpuart32_write(&sport->port, UARTFIFO,
+		       temp | UARTFIFO_RXFE | UARTFIFO_TXFE);
 
 	/* flush Tx and Rx FIFO */
-	writel(UARTFIFO_TXFLUSH | UARTFIFO_RXFLUSH,
-			sport->port.membase + UARTFIFO);
+	lpuart32_write(&sport->port, UARTFIFO,
+		       UARTFIFO_TXFLUSH | UARTFIFO_RXFLUSH);
 
 	/* explicitly clear RDRF */
-	if (readl(sport->port.membase + UARTSTAT) & UARTSTAT_RDRF) {
-		readl(sport->port.membase + UARTDATA);
-		writel(UARTFIFO_RXUF, sport->port.membase + UARTFIFO);
+	if (lpuart32_read(&sport->port, UARTSTAT) & UARTSTAT_RDRF) {
+		lpuart32_read(&sport->port, UARTDATA);
+		lpuart32_write(&sport->port, UARTFIFO, UARTFIFO_RXUF);
 	}
 
 	/* Enable Rx and Tx */
-	writel(UARTCTRL_RE | UARTCTRL_TE, sport->port.membase + UARTCTRL);
+	lpuart32_write(&sport->port, UARTCTRL, UARTCTRL_RE | UARTCTRL_TE);
 	spin_unlock_irqrestore(&sport->port.lock, flags);
 
 	return 0;
@@ -555,18 +555,18 @@ static int lpuart32_poll_init(struct uart_port *port)
 
 static void lpuart32_poll_put_char(struct uart_port *port, unsigned char c)
 {
-	while (!(readl(port->membase + UARTSTAT) & UARTSTAT_TDRE))
+	while (!(lpuart32_read(port, UARTSTAT) & UARTSTAT_TDRE))
 		barrier();
 
-	writel(c, port->membase + UARTDATA);
+	lpuart32_write(port, UARTDATA, c);
 }
 
 static int lpuart32_poll_get_char(struct uart_port *port)
 {
-	if (!(readl(port->membase + UARTSTAT) & UARTSTAT_RDRF))
+	if (!(lpuart32_read(port, UARTSTAT) & UARTSTAT_RDRF))
 		return NO_POLL_CHAR;
 
-	return readl(port->membase + UARTDATA);
+	return lpuart32_read(port, UARTDATA);
 }
 #endif
 
-- 
2.20.1

