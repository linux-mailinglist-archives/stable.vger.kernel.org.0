Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B99B1BCA10
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730692AbgD1Sp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:45:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731521AbgD1Soc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:44:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B19B20575;
        Tue, 28 Apr 2020 18:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099471;
        bh=GZCUr1DiTO8ok3Bs2Dz8w/FTwe/YWSIfDU7O/NrKYPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M8NLuY3mPNxIkpaFO7nWmZZQp4dO9xz4b6HbqxnrzmMSnknfsseYH0rSuiuGudfyR
         xRNxQZAAYthDd3ztbUGF18BivOrKXpXyfemvjy+PSoifTKmhFQIhDTJ48HoupKivzR
         eB7mDWqJfgkFfXOWY59luzlU8z+CJCjKEXXDU4ys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>
Subject: [PATCH 5.4 164/168] Revert "serial: uartps: Register own uart console and driver structures"
Date:   Tue, 28 Apr 2020 20:25:38 +0200
Message-Id: <20200428182251.526713889@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Simek <michal.simek@xilinx.com>

commit 18cc7ac8a28e28cd005c2475f52576cfe10cabfb upstream.

This reverts commit 024ca329bfb9a948f76eaff3243e21b7e70182f2.

As Johan says, this driver needs a lot more work and these changes are
only going in the wrong direction:
  https://lkml.kernel.org/r/20190523091839.GC568@localhost

Reported-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1ee35667e36a8efddee381df5fe495ad65f4d15c.1585905873.git.michal.simek@xilinx.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/xilinx_uartps.c |   95 +++++++++++++++----------------------
 1 file changed, 40 insertions(+), 55 deletions(-)

--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -31,6 +31,7 @@
 #define CDNS_UART_TTY_NAME	"ttyPS"
 #define CDNS_UART_NAME		"xuartps"
 #define CDNS_UART_MAJOR		0	/* use dynamic node allocation */
+#define CDNS_UART_MINOR		0	/* works best with devtmpfs */
 #define CDNS_UART_NR_PORTS	16
 #define CDNS_UART_FIFO_SIZE	64	/* FIFO size */
 #define CDNS_UART_REGISTER_SPACE	0x1000
@@ -1118,6 +1119,8 @@ static const struct uart_ops cdns_uart_o
 #endif
 };
 
+static struct uart_driver cdns_uart_uart_driver;
+
 #ifdef CONFIG_SERIAL_XILINX_PS_UART_CONSOLE
 /**
  * cdns_uart_console_putchar - write the character to the FIFO buffer
@@ -1257,6 +1260,16 @@ static int cdns_uart_console_setup(struc
 
 	return uart_set_options(port, co, baud, parity, bits, flow);
 }
+
+static struct console cdns_uart_console = {
+	.name	= CDNS_UART_TTY_NAME,
+	.write	= cdns_uart_console_write,
+	.device	= uart_console_device,
+	.setup	= cdns_uart_console_setup,
+	.flags	= CON_PRINTBUFFER,
+	.index	= -1, /* Specified on the cmdline (e.g. console=ttyPS ) */
+	.data	= &cdns_uart_uart_driver,
+};
 #endif /* CONFIG_SERIAL_XILINX_PS_UART_CONSOLE */
 
 #ifdef CONFIG_PM_SLEEP
@@ -1388,6 +1401,9 @@ static const struct of_device_id cdns_ua
 };
 MODULE_DEVICE_TABLE(of, cdns_uart_of_match);
 
+/* Temporary variable for storing number of instances */
+static int instances;
+
 /**
  * cdns_uart_probe - Platform driver probe
  * @pdev: Pointer to the platform device structure
@@ -1401,11 +1417,6 @@ static int cdns_uart_probe(struct platfo
 	struct resource *res;
 	struct cdns_uart *cdns_uart_data;
 	const struct of_device_id *match;
-	struct uart_driver *cdns_uart_uart_driver;
-	char *driver_name;
-#ifdef CONFIG_SERIAL_XILINX_PS_UART_CONSOLE
-	struct console *cdns_uart_console;
-#endif
 
 	cdns_uart_data = devm_kzalloc(&pdev->dev, sizeof(*cdns_uart_data),
 			GFP_KERNEL);
@@ -1415,12 +1426,6 @@ static int cdns_uart_probe(struct platfo
 	if (!port)
 		return -ENOMEM;
 
-	cdns_uart_uart_driver = devm_kzalloc(&pdev->dev,
-					     sizeof(*cdns_uart_uart_driver),
-					     GFP_KERNEL);
-	if (!cdns_uart_uart_driver)
-		return -ENOMEM;
-
 	/* Look for a serialN alias */
 	id = of_alias_get_id(pdev->dev.of_node, "serial");
 	if (id < 0)
@@ -1431,50 +1436,25 @@ static int cdns_uart_probe(struct platfo
 		return -ENODEV;
 	}
 
-	/* There is a need to use unique driver name */
-	driver_name = devm_kasprintf(&pdev->dev, GFP_KERNEL, "%s%d",
-				     CDNS_UART_NAME, id);
-	if (!driver_name)
-		return -ENOMEM;
-
-	cdns_uart_uart_driver->owner = THIS_MODULE;
-	cdns_uart_uart_driver->driver_name = driver_name;
-	cdns_uart_uart_driver->dev_name	= CDNS_UART_TTY_NAME;
-	cdns_uart_uart_driver->major = CDNS_UART_MAJOR;
-	cdns_uart_uart_driver->minor = id;
-	cdns_uart_uart_driver->nr = 1;
-
+	if (!cdns_uart_uart_driver.state) {
+		cdns_uart_uart_driver.owner = THIS_MODULE;
+		cdns_uart_uart_driver.driver_name = CDNS_UART_NAME;
+		cdns_uart_uart_driver.dev_name = CDNS_UART_TTY_NAME;
+		cdns_uart_uart_driver.major = CDNS_UART_MAJOR;
+		cdns_uart_uart_driver.minor = CDNS_UART_MINOR;
+		cdns_uart_uart_driver.nr = CDNS_UART_NR_PORTS;
 #ifdef CONFIG_SERIAL_XILINX_PS_UART_CONSOLE
-	cdns_uart_console = devm_kzalloc(&pdev->dev, sizeof(*cdns_uart_console),
-					 GFP_KERNEL);
-	if (!cdns_uart_console)
-		return -ENOMEM;
-
-	strncpy(cdns_uart_console->name, CDNS_UART_TTY_NAME,
-		sizeof(cdns_uart_console->name));
-	cdns_uart_console->index = id;
-	cdns_uart_console->write = cdns_uart_console_write;
-	cdns_uart_console->device = uart_console_device;
-	cdns_uart_console->setup = cdns_uart_console_setup;
-	cdns_uart_console->flags = CON_PRINTBUFFER;
-	cdns_uart_console->data = cdns_uart_uart_driver;
-	cdns_uart_uart_driver->cons = cdns_uart_console;
+		cdns_uart_uart_driver.cons = &cdns_uart_console;
 #endif
 
-	rc = uart_register_driver(cdns_uart_uart_driver);
-	if (rc < 0) {
-		dev_err(&pdev->dev, "Failed to register driver\n");
-		return rc;
+		rc = uart_register_driver(&cdns_uart_uart_driver);
+		if (rc < 0) {
+			dev_err(&pdev->dev, "Failed to register driver\n");
+			return rc;
+		}
 	}
 
-	cdns_uart_data->cdns_uart_driver = cdns_uart_uart_driver;
-
-	/*
-	 * Setting up proper name_base needs to be done after uart
-	 * registration because tty_driver structure is not filled.
-	 * name_base is 0 by default.
-	 */
-	cdns_uart_uart_driver->tty_driver->name_base = id;
+	cdns_uart_data->cdns_uart_driver = &cdns_uart_uart_driver;
 
 	match = of_match_node(cdns_uart_of_match, pdev->dev.of_node);
 	if (match && match->data) {
@@ -1551,6 +1531,7 @@ static int cdns_uart_probe(struct platfo
 	port->flags	= UPF_BOOT_AUTOCONF;
 	port->ops	= &cdns_uart_ops;
 	port->fifosize	= CDNS_UART_FIFO_SIZE;
+	port->line	= id;
 
 	/*
 	 * Register the port.
@@ -1582,7 +1563,7 @@ static int cdns_uart_probe(struct platfo
 		console_port = port;
 #endif
 
-	rc = uart_add_one_port(cdns_uart_uart_driver, port);
+	rc = uart_add_one_port(&cdns_uart_uart_driver, port);
 	if (rc) {
 		dev_err(&pdev->dev,
 			"uart_add_one_port() failed; err=%i\n", rc);
@@ -1592,12 +1573,15 @@ static int cdns_uart_probe(struct platfo
 #ifdef CONFIG_SERIAL_XILINX_PS_UART_CONSOLE
 	/* This is not port which is used for console that's why clean it up */
 	if (console_port == port &&
-	    !(cdns_uart_uart_driver->cons->flags & CON_ENABLED))
+	    !(cdns_uart_uart_driver.cons->flags & CON_ENABLED))
 		console_port = NULL;
 #endif
 
 	cdns_uart_data->cts_override = of_property_read_bool(pdev->dev.of_node,
 							     "cts-override");
+
+	instances++;
+
 	return 0;
 
 err_out_pm_disable:
@@ -1613,8 +1597,8 @@ err_out_clk_disable:
 err_out_clk_dis_pclk:
 	clk_disable_unprepare(cdns_uart_data->pclk);
 err_out_unregister_driver:
-	uart_unregister_driver(cdns_uart_data->cdns_uart_driver);
-
+	if (!instances)
+		uart_unregister_driver(cdns_uart_data->cdns_uart_driver);
 	return rc;
 }
 
@@ -1649,7 +1633,8 @@ static int cdns_uart_remove(struct platf
 		console_port = NULL;
 #endif
 
-	uart_unregister_driver(cdns_uart_data->cdns_uart_driver);
+	if (!--instances)
+		uart_unregister_driver(cdns_uart_data->cdns_uart_driver);
 	return rc;
 }
 


