Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF9211F51
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbfEBPXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:23:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726992AbfEBPXT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:23:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA09A20675;
        Thu,  2 May 2019 15:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810598;
        bh=UbCM0lRWWo97Xhd/yDpuNG3fldPAC64idAcudYXbxrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RZ8uZmWXczbqE453FbsuJLeqOj189LretIHrCn3g1lyjsW5xEWbZ7jeaxJlcyFiSi
         JD1KQgCfN5INLnIng7X1uSicOjZY9WS1YU/kw2si8AqN7vVdH7gtnnwfi8WcpO4ZQu
         Bwqf76Pe0+B2JB6EFfXI9h4LgekRTMNRvtz+up/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.com>,
        Andrey Batyiev <batyiev@gmail.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 4.9 10/32] serial: ar933x_uart: Fix build failure with disabled console
Date:   Thu,  2 May 2019 17:20:56 +0200
Message-Id: <20190502143318.626319198@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143314.649935114@linuxfoundation.org>
References: <20190502143314.649935114@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 72ff51d8dd262d1fef25baedc2ac35116435be47 ]

Andrey has reported on OpenWrt's bug tracking system[1], that he
currently can't use ar93xx_uart as pure serial UART without console
(CONFIG_SERIAL_8250_CONSOLE and CONFIG_SERIAL_AR933X_CONSOLE undefined),
because compilation ends with following error:

 ar933x_uart.c: In function 'ar933x_uart_console_write':
 ar933x_uart.c:550:14: error: 'struct uart_port' has no
                               member named 'sysrq'

So this patch moves all the code related to console handling behind
series of CONFIG_SERIAL_AR933X_CONSOLE ifdefs.

1. https://bugs.openwrt.org/index.php?do=details&task_id=2152

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.com>
Cc: Andrey Batyiev <batyiev@gmail.com>
Reported-by: Andrey Batyiev <batyiev@gmail.com>
Tested-by: Andrey Batyiev <batyiev@gmail.com>
Signed-off-by: Petr Štetiar <ynezz@true.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/tty/serial/ar933x_uart.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/tty/serial/ar933x_uart.c b/drivers/tty/serial/ar933x_uart.c
index 73137f4aac20..d4462512605b 100644
--- a/drivers/tty/serial/ar933x_uart.c
+++ b/drivers/tty/serial/ar933x_uart.c
@@ -52,11 +52,6 @@ struct ar933x_uart_port {
 	struct clk		*clk;
 };
 
-static inline bool ar933x_uart_console_enabled(void)
-{
-	return IS_ENABLED(CONFIG_SERIAL_AR933X_CONSOLE);
-}
-
 static inline unsigned int ar933x_uart_read(struct ar933x_uart_port *up,
 					    int offset)
 {
@@ -511,6 +506,7 @@ static struct uart_ops ar933x_uart_ops = {
 	.verify_port	= ar933x_uart_verify_port,
 };
 
+#ifdef CONFIG_SERIAL_AR933X_CONSOLE
 static struct ar933x_uart_port *
 ar933x_console_ports[CONFIG_SERIAL_AR933X_NR_UARTS];
 
@@ -607,14 +603,7 @@ static struct console ar933x_uart_console = {
 	.index		= -1,
 	.data		= &ar933x_uart_driver,
 };
-
-static void ar933x_uart_add_console_port(struct ar933x_uart_port *up)
-{
-	if (!ar933x_uart_console_enabled())
-		return;
-
-	ar933x_console_ports[up->port.line] = up;
-}
+#endif /* CONFIG_SERIAL_AR933X_CONSOLE */
 
 static struct uart_driver ar933x_uart_driver = {
 	.owner		= THIS_MODULE,
@@ -703,7 +692,9 @@ static int ar933x_uart_probe(struct platform_device *pdev)
 	baud = ar933x_uart_get_baud(port->uartclk, 0, AR933X_UART_MAX_STEP);
 	up->max_baud = min_t(unsigned int, baud, AR933X_UART_MAX_BAUD);
 
-	ar933x_uart_add_console_port(up);
+#ifdef CONFIG_SERIAL_AR933X_CONSOLE
+	ar933x_console_ports[up->port.line] = up;
+#endif
 
 	ret = uart_add_one_port(&ar933x_uart_driver, &up->port);
 	if (ret)
@@ -752,8 +743,9 @@ static int __init ar933x_uart_init(void)
 {
 	int ret;
 
-	if (ar933x_uart_console_enabled())
-		ar933x_uart_driver.cons = &ar933x_uart_console;
+#ifdef CONFIG_SERIAL_AR933X_CONSOLE
+	ar933x_uart_driver.cons = &ar933x_uart_console;
+#endif
 
 	ret = uart_register_driver(&ar933x_uart_driver);
 	if (ret)
-- 
2.19.1



