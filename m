Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFDB41BC974
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730872AbgD1Slt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:41:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731025AbgD1Slq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:41:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BE272085B;
        Tue, 28 Apr 2020 18:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099305;
        bh=tmh35UJvyYHRPIWPl8OnlJ6fR0bdJxantC3ZCA4S3iY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=meGPoORY2YzzcIoOEp8DtXBrDmtOvw97BLZEfekmUJfzD6VU/LNDwDwDQ2XvO9yEz
         o3+qxy+I/TNH+SjHjA/H0pjGnIDQGjMt6aEvkmMjy8gwZ/icmsrCpdUd/RCEvGMhtb
         UhrYM0qDjIokBhN9ZY0cGbKi78v6mT1I5mwkdjZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>
Subject: [PATCH 5.6 162/167] Revert "serial: uartps: Move Port ID to device data structure"
Date:   Tue, 28 Apr 2020 20:25:38 +0200
Message-Id: <20200428182246.085906563@linuxfoundation.org>
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

commit 492cc08bc16c44e2e587362ada3f6269dee2be22 upstream.

This reverts commit bed25ac0e2b6ab8f9aed2d20bc9c3a2037311800.

As Johan says, this driver needs a lot more work and these changes are
only going in the wrong direction:
  https://lkml.kernel.org/r/20190523091839.GC568@localhost

Reported-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/eb0ec98fecdca9b79c1a3ac0c30c668b6973b193.1585905873.git.michal.simek@xilinx.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/xilinx_uartps.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -189,7 +189,6 @@ MODULE_PARM_DESC(rx_timeout, "Rx timeout
  * @pclk:		APB clock
  * @cdns_uart_driver:	Pointer to UART driver
  * @baud:		Current baud rate
- * @id:			Port ID
  * @clk_rate_change_nb:	Notifier block for clock changes
  * @quirks:		Flags for RXBS support.
  */
@@ -199,7 +198,6 @@ struct cdns_uart {
 	struct clk		*pclk;
 	struct uart_driver	*cdns_uart_driver;
 	unsigned int		baud;
-	int			id;
 	struct notifier_block	clk_rate_change_nb;
 	u32			quirks;
 	bool cts_override;
@@ -1424,7 +1422,7 @@ MODULE_DEVICE_TABLE(of, cdns_uart_of_mat
  */
 static int cdns_uart_probe(struct platform_device *pdev)
 {
-	int rc, irq;
+	int rc, id, irq;
 	struct uart_port *port;
 	struct resource *res;
 	struct cdns_uart *cdns_uart_data;
@@ -1450,18 +1448,18 @@ static int cdns_uart_probe(struct platfo
 		return -ENOMEM;
 
 	/* Look for a serialN alias */
-	cdns_uart_data->id = of_alias_get_id(pdev->dev.of_node, "serial");
-	if (cdns_uart_data->id < 0)
-		cdns_uart_data->id = 0;
+	id = of_alias_get_id(pdev->dev.of_node, "serial");
+	if (id < 0)
+		id = 0;
 
-	if (cdns_uart_data->id >= CDNS_UART_NR_PORTS) {
+	if (id >= CDNS_UART_NR_PORTS) {
 		dev_err(&pdev->dev, "Cannot get uart_port structure\n");
 		return -ENODEV;
 	}
 
 	/* There is a need to use unique driver name */
 	driver_name = devm_kasprintf(&pdev->dev, GFP_KERNEL, "%s%d",
-				     CDNS_UART_NAME, cdns_uart_data->id);
+				     CDNS_UART_NAME, id);
 	if (!driver_name)
 		return -ENOMEM;
 
@@ -1469,7 +1467,7 @@ static int cdns_uart_probe(struct platfo
 	cdns_uart_uart_driver->driver_name = driver_name;
 	cdns_uart_uart_driver->dev_name	= CDNS_UART_TTY_NAME;
 	cdns_uart_uart_driver->major = CDNS_UART_MAJOR;
-	cdns_uart_uart_driver->minor = cdns_uart_data->id;
+	cdns_uart_uart_driver->minor = id;
 	cdns_uart_uart_driver->nr = 1;
 
 #ifdef CONFIG_SERIAL_XILINX_PS_UART_CONSOLE
@@ -1480,7 +1478,7 @@ static int cdns_uart_probe(struct platfo
 
 	strncpy(cdns_uart_console->name, CDNS_UART_TTY_NAME,
 		sizeof(cdns_uart_console->name));
-	cdns_uart_console->index = cdns_uart_data->id;
+	cdns_uart_console->index = id;
 	cdns_uart_console->write = cdns_uart_console_write;
 	cdns_uart_console->device = uart_console_device;
 	cdns_uart_console->setup = cdns_uart_console_setup;
@@ -1502,7 +1500,7 @@ static int cdns_uart_probe(struct platfo
 	 * registration because tty_driver structure is not filled.
 	 * name_base is 0 by default.
 	 */
-	cdns_uart_uart_driver->tty_driver->name_base = cdns_uart_data->id;
+	cdns_uart_uart_driver->tty_driver->name_base = id;
 
 	match = of_match_node(cdns_uart_of_match, pdev->dev.of_node);
 	if (match && match->data) {


