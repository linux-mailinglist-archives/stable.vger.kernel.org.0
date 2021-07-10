Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D09AC3C2D45
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbhGJCWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:22:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232643AbhGJCVv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:21:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19A6D613C5;
        Sat, 10 Jul 2021 02:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883546;
        bh=l7HpfyGaASe1EXqssYiTB8W6w7CPgRkUmS+BAL1qRFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S3cfWKr7b1csjDI0tRBC74dNpbDe+jJe5aIr3U2GNZRcw0tIW5g+idfT9HPcoVTLc
         TeAxvfBvh+00a239+qeDCJGTPgQRJ+4ho57c/IirsBxwd62mRLgdqnOge8vwEUipc+
         m6RxSF9TyupUDP6+ls11XZm2ieXNyyJkkPCOEYQyy51/HJdHPvp1J/VOPBCwS5Pexu
         56ALtFcx+Ha7IIEJHQaNs14xxs0l+a/wua1IFqE/cFEfCofNGyhejQn5+oBFLqa4uh
         vGfcsRcLeE+JfefE3pgxp/RPiYzj8Cqx23qTsuop8JbrQlXxXWi3hZsY0mB/F9rwhD
         TBlqbx3b5FdBQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Mack <daniel@zonque.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 057/114] serial: tty: uartlite: fix console setup
Date:   Fri,  9 Jul 2021 22:16:51 -0400
Message-Id: <20210710021748.3167666-57-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710021748.3167666-1-sashal@kernel.org>
References: <20210710021748.3167666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Mack <daniel@zonque.org>

[ Upstream commit d157fca711ad42e75efef3444c83d2e1a17be27a ]

Remove the hack to assign the global console_port variable at probe time.
This assumption that cons->index is -1 is wrong for systems that specify
'console=' in the cmdline (or 'stdout-path' in dts). Hence, on such system
the actual console assignment is ignored, and the first UART that happens
to be probed is used as console instead.

Move the logic to console_setup() and map the console to the correct port
through the array of available ports instead.

Signed-off-by: Daniel Mack <daniel@zonque.org>
Link: https://lore.kernel.org/r/20210528133321.1859346-1-daniel@zonque.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/uartlite.c | 27 ++++++---------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

diff --git a/drivers/tty/serial/uartlite.c b/drivers/tty/serial/uartlite.c
index f42ccc40ffa6..a5f15f22d9ef 100644
--- a/drivers/tty/serial/uartlite.c
+++ b/drivers/tty/serial/uartlite.c
@@ -505,21 +505,23 @@ static void ulite_console_write(struct console *co, const char *s,
 
 static int ulite_console_setup(struct console *co, char *options)
 {
-	struct uart_port *port;
+	struct uart_port *port = NULL;
 	int baud = 9600;
 	int bits = 8;
 	int parity = 'n';
 	int flow = 'n';
 
-
-	port = console_port;
+	if (co->index >= 0 && co->index < ULITE_NR_UARTS)
+		port = ulite_ports + co->index;
 
 	/* Has the device been initialized yet? */
-	if (!port->mapbase) {
+	if (!port || !port->mapbase) {
 		pr_debug("console on ttyUL%i not present\n", co->index);
 		return -ENODEV;
 	}
 
+	console_port = port;
+
 	/* not initialized yet? */
 	if (!port->membase) {
 		if (ulite_request_port(port))
@@ -655,17 +657,6 @@ static int ulite_assign(struct device *dev, int id, u32 base, int irq,
 
 	dev_set_drvdata(dev, port);
 
-#ifdef CONFIG_SERIAL_UARTLITE_CONSOLE
-	/*
-	 * If console hasn't been found yet try to assign this port
-	 * because it is required to be assigned for console setup function.
-	 * If register_console() don't assign value, then console_port pointer
-	 * is cleanup.
-	 */
-	if (ulite_uart_driver.cons->index == -1)
-		console_port = port;
-#endif
-
 	/* Register the port */
 	rc = uart_add_one_port(&ulite_uart_driver, port);
 	if (rc) {
@@ -675,12 +666,6 @@ static int ulite_assign(struct device *dev, int id, u32 base, int irq,
 		return rc;
 	}
 
-#ifdef CONFIG_SERIAL_UARTLITE_CONSOLE
-	/* This is not port which is used for console that's why clean it up */
-	if (ulite_uart_driver.cons->index == -1)
-		console_port = NULL;
-#endif
-
 	return 0;
 }
 
-- 
2.30.2

