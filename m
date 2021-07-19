Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEF83CE4C4
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235904AbhGSPqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:46:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348360AbhGSPmp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:42:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BC4660E0C;
        Mon, 19 Jul 2021 16:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711722;
        bh=l7HpfyGaASe1EXqssYiTB8W6w7CPgRkUmS+BAL1qRFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xfSR1x219IloCC541eUrfsvt8boPC3RyoXvkimGTmXSztO8oN88x2ZK1YzIDcDHhi
         2/IDsgNjBCsh39Dgkn5fIj5rdw790/qAXakyL0x+kv9lo0CNk+0rBfnspQK+D15pPx
         OZocLTuLIoGLLL/+rtKRsv486TbiykO47q7VfqP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Mack <daniel@zonque.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 081/292] serial: tty: uartlite: fix console setup
Date:   Mon, 19 Jul 2021 16:52:23 +0200
Message-Id: <20210719144945.179891420@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



