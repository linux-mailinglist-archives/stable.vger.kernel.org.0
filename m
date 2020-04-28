Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D781BC948
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730430AbgD1SkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:40:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730262AbgD1SjO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:39:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D13A120730;
        Tue, 28 Apr 2020 18:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099153;
        bh=RnPKc0SdEG8Si+1C69T0KswytITC9KksuBC2LYRxA1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G1WweFJEK8H0r38962yhAf1WfByilEtenXlpkF6B68rU0wZxgZjShihEw8lqAphCQ
         LXuVVlZ2u58LluPhuVvaBUkRhZW8x+Gbh0/Z3QFT+fj9HkUrfyckF2PlnMGl2EC9pB
         4RHVpMuQjKVQLJ1qg3uSn3FqDfiUETZEAw/WlyLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>
Subject: [PATCH 5.6 163/167] Revert "serial: uartps: Register own uart console and driver structures"
Date:   Tue, 28 Apr 2020 20:25:39 +0200
Message-Id: <20200428182246.220843811@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
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
@@ -27,6 +27,7 @@
 #define CDNS_UART_TTY_NAME	"ttyPS"
 #define CDNS_UART_NAME		"xuartps"
 #define CDNS_UART_MAJOR		0	/* use dynamic node allocation */
+#define CDNS_UART_MINOR		0	/* works best with devtmpfs */
 #define CDNS_UART_NR_PORTS	16
 #define CDNS_UART_FIFO_SIZE	64	/* FIFO size */
 #define CDNS_UART_REGISTER_SPACE	0x1000
@@ -1144,6 +1145,8 @@ static const struct uart_ops cdns_uart_o
 #endif
 };
 
+static struct uart_driver cdns_uart_uart_driver;
+
 #ifdef CONFIG_SERIAL_XILINX_PS_UART_CONSOLE
 /**
  * cdns_uart_console_putchar - write the character to the FIFO buffer
@@ -1283,6 +1286,16 @@ static int cdns_uart_console_setup(struc
 
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
@@ -1414,6 +1427,9 @@ static const struct of_device_id cdns_ua
 };
 MODULE_DEVICE_TABLE(of, cdns_uart_of_match);
 
+/* Temporary variable for storing number of instances */
+static int instances;
+
 /**
  * cdns_uart_probe - Platform driver probe
  * @pdev: Pointer to the platform device structure
@@ -1427,11 +1443,6 @@ static int cdns_uart_probe(struct platfo
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
@@ -1441,12 +1452,6 @@ static int cdns_uart_probe(struct platfo
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
@@ -1457,50 +1462,25 @@ static int cdns_uart_probe(struct platfo
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
@@ -1578,6 +1558,7 @@ static int cdns_uart_probe(struct platfo
 	port->ops	= &cdns_uart_ops;
 	port->fifosize	= CDNS_UART_FIFO_SIZE;
 	port->has_sysrq = IS_ENABLED(CONFIG_SERIAL_XILINX_PS_UART_CONSOLE);
+	port->line	= id;
 
 	/*
 	 * Register the port.
@@ -1609,7 +1590,7 @@ static int cdns_uart_probe(struct platfo
 		console_port = port;
 #endif
 
-	rc = uart_add_one_port(cdns_uart_uart_driver, port);
+	rc = uart_add_one_port(&cdns_uart_uart_driver, port);
 	if (rc) {
 		dev_err(&pdev->dev,
 			"uart_add_one_port() failed; err=%i\n", rc);
@@ -1619,12 +1600,15 @@ static int cdns_uart_probe(struct platfo
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
@@ -1640,8 +1624,8 @@ err_out_clk_disable:
 err_out_clk_dis_pclk:
 	clk_disable_unprepare(cdns_uart_data->pclk);
 err_out_unregister_driver:
-	uart_unregister_driver(cdns_uart_data->cdns_uart_driver);
-
+	if (!instances)
+		uart_unregister_driver(cdns_uart_data->cdns_uart_driver);
 	return rc;
 }
 
@@ -1676,7 +1660,8 @@ static int cdns_uart_remove(struct platf
 		console_port = NULL;
 #endif
 
-	uart_unregister_driver(cdns_uart_data->cdns_uart_driver);
+	if (!--instances)
+		uart_unregister_driver(cdns_uart_data->cdns_uart_driver);
 	return rc;
 }
 


