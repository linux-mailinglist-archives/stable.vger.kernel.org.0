Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30411AC4EA
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgDPOHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:07:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:53238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409719AbgDPOG5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 10:06:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18647217D8;
        Thu, 16 Apr 2020 14:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587046016;
        bh=NaewBO6Aei5XHHQBcnYmJL99fHEPNoXssYznEx4oPug=;
        h=Subject:To:From:Date:From;
        b=S3gDTafmwKL7tXi57CQaNA168Ms3YHjiAJE3HlKgkTsnwvXYDm1MaskqItEw2xTxg
         oeDbFRNWgNujaTToQwG+Vws5CAhb2KvAc5yWxgF2/oKFiQ23vicXqiFrdZXu5SMaFF
         BZbsz2V6fGBK9buogU1PtZbmnCl1uYiXNraPj8lY=
Subject: patch "Revert "serial: uartps: Move Port ID to device data structure"" added to tty-linus
To:     michal.simek@xilinx.com, gregkh@linuxfoundation.org,
        johan@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 16 Apr 2020 16:06:40 +0200
Message-ID: <1587046000228165@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Revert "serial: uartps: Move Port ID to device data structure"

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 492cc08bc16c44e2e587362ada3f6269dee2be22 Mon Sep 17 00:00:00 2001
From: Michal Simek <michal.simek@xilinx.com>
Date: Fri, 3 Apr 2020 11:24:35 +0200
Subject: Revert "serial: uartps: Move Port ID to device data structure"

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
 drivers/tty/serial/xilinx_uartps.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index 58f0fa07ecdb..41d9c2f188f0 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -189,7 +189,6 @@ MODULE_PARM_DESC(rx_timeout, "Rx timeout, 1-255");
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
@@ -1412,7 +1410,7 @@ MODULE_DEVICE_TABLE(of, cdns_uart_of_match);
  */
 static int cdns_uart_probe(struct platform_device *pdev)
 {
-	int rc, irq;
+	int rc, id, irq;
 	struct uart_port *port;
 	struct resource *res;
 	struct cdns_uart *cdns_uart_data;
@@ -1438,18 +1436,18 @@ static int cdns_uart_probe(struct platform_device *pdev)
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
 
@@ -1457,7 +1455,7 @@ static int cdns_uart_probe(struct platform_device *pdev)
 	cdns_uart_uart_driver->driver_name = driver_name;
 	cdns_uart_uart_driver->dev_name	= CDNS_UART_TTY_NAME;
 	cdns_uart_uart_driver->major = CDNS_UART_MAJOR;
-	cdns_uart_uart_driver->minor = cdns_uart_data->id;
+	cdns_uart_uart_driver->minor = id;
 	cdns_uart_uart_driver->nr = 1;
 
 #ifdef CONFIG_SERIAL_XILINX_PS_UART_CONSOLE
@@ -1468,7 +1466,7 @@ static int cdns_uart_probe(struct platform_device *pdev)
 
 	strncpy(cdns_uart_console->name, CDNS_UART_TTY_NAME,
 		sizeof(cdns_uart_console->name));
-	cdns_uart_console->index = cdns_uart_data->id;
+	cdns_uart_console->index = id;
 	cdns_uart_console->write = cdns_uart_console_write;
 	cdns_uart_console->device = uart_console_device;
 	cdns_uart_console->setup = cdns_uart_console_setup;
@@ -1490,7 +1488,7 @@ static int cdns_uart_probe(struct platform_device *pdev)
 	 * registration because tty_driver structure is not filled.
 	 * name_base is 0 by default.
 	 */
-	cdns_uart_uart_driver->tty_driver->name_base = cdns_uart_data->id;
+	cdns_uart_uart_driver->tty_driver->name_base = id;
 
 	match = of_match_node(cdns_uart_of_match, pdev->dev.of_node);
 	if (match && match->data) {
-- 
2.26.1


