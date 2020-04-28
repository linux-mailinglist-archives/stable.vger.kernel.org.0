Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6781BC9BB
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731515AbgD1So2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:44:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731510AbgD1So2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:44:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 700BA20575;
        Tue, 28 Apr 2020 18:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099466;
        bh=7M2egqOpzwZBZnVa5gk84ESrgvK37xCyxbhFHMCqQuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cBNYRH9/MuuXzRX2G9cBl31uFYjbmAWcs3emjo5inxWs1LsIOnEQHdyXFrdLGWkup
         kaOdTi2teECq8p3f2V5TlW9Ql/U1C2LXGVywA8Dp7amfMzHxqeEBSq3IR898xm6sIw
         oPpwiPFqtkYbPvq4KMklGoBCAG3r80FXR+9EdSx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>
Subject: [PATCH 5.4 162/168] Revert "serial: uartps: Change uart ID port allocation"
Date:   Tue, 28 Apr 2020 20:25:36 +0200
Message-Id: <20200428182251.386594465@linuxfoundation.org>
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

commit 72d68197281e2ad313960504d10b0c41ff87fd55 upstream.

This reverts commit ae1cca3fa3478be92948dbbcd722390272032ade.

With setting up NR_PORTS to 16 to be able to use serial2 and higher
aliases and don't loose functionality which was intended by these changes.

As Johan says, this driver needs a lot more work and these changes are
only going in the wrong direction:
  https://lkml.kernel.org/r/20190523091839.GC568@localhost

Reported-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/a94931b65ce0089f76fb1fe6b446a08731bff754.1585905873.git.michal.simek@xilinx.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/xilinx_uartps.c |  111 ++++---------------------------------
 1 file changed, 13 insertions(+), 98 deletions(-)

--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -31,6 +31,7 @@
 #define CDNS_UART_TTY_NAME	"ttyPS"
 #define CDNS_UART_NAME		"xuartps"
 #define CDNS_UART_MAJOR		0	/* use dynamic node allocation */
+#define CDNS_UART_NR_PORTS	16
 #define CDNS_UART_FIFO_SIZE	64	/* FIFO size */
 #define CDNS_UART_REGISTER_SPACE	0x1000
 #define TX_TIMEOUT		500000
@@ -1389,90 +1390,6 @@ static const struct of_device_id cdns_ua
 };
 MODULE_DEVICE_TABLE(of, cdns_uart_of_match);
 
-/*
- * Maximum number of instances without alias IDs but if there is alias
- * which target "< MAX_UART_INSTANCES" range this ID can't be used.
- */
-#define MAX_UART_INSTANCES	32
-
-/* Stores static aliases list */
-static DECLARE_BITMAP(alias_bitmap, MAX_UART_INSTANCES);
-static int alias_bitmap_initialized;
-
-/* Stores actual bitmap of allocated IDs with alias IDs together */
-static DECLARE_BITMAP(bitmap, MAX_UART_INSTANCES);
-/* Protect bitmap operations to have unique IDs */
-static DEFINE_MUTEX(bitmap_lock);
-
-static int cdns_get_id(struct platform_device *pdev)
-{
-	int id, ret;
-
-	mutex_lock(&bitmap_lock);
-
-	/* Alias list is stable that's why get alias bitmap only once */
-	if (!alias_bitmap_initialized) {
-		ret = of_alias_get_alias_list(cdns_uart_of_match, "serial",
-					      alias_bitmap, MAX_UART_INSTANCES);
-		if (ret && ret != -EOVERFLOW) {
-			mutex_unlock(&bitmap_lock);
-			return ret;
-		}
-
-		alias_bitmap_initialized++;
-	}
-
-	/* Make sure that alias ID is not taken by instance without alias */
-	bitmap_or(bitmap, bitmap, alias_bitmap, MAX_UART_INSTANCES);
-
-	dev_dbg(&pdev->dev, "Alias bitmap: %*pb\n",
-		MAX_UART_INSTANCES, bitmap);
-
-	/* Look for a serialN alias */
-	id = of_alias_get_id(pdev->dev.of_node, "serial");
-	if (id < 0) {
-		dev_warn(&pdev->dev,
-			 "No serial alias passed. Using the first free id\n");
-
-		/*
-		 * Start with id 0 and check if there is no serial0 alias
-		 * which points to device which is compatible with this driver.
-		 * If alias exists then try next free position.
-		 */
-		id = 0;
-
-		for (;;) {
-			dev_info(&pdev->dev, "Checking id %d\n", id);
-			id = find_next_zero_bit(bitmap, MAX_UART_INSTANCES, id);
-
-			/* No free empty instance */
-			if (id == MAX_UART_INSTANCES) {
-				dev_err(&pdev->dev, "No free ID\n");
-				mutex_unlock(&bitmap_lock);
-				return -EINVAL;
-			}
-
-			dev_dbg(&pdev->dev, "The empty id is %d\n", id);
-			/* Check if ID is empty */
-			if (!test_and_set_bit(id, bitmap)) {
-				/* Break the loop if bit is taken */
-				dev_dbg(&pdev->dev,
-					"Selected ID %d allocation passed\n",
-					id);
-				break;
-			}
-			dev_dbg(&pdev->dev,
-				"Selected ID %d allocation failed\n", id);
-			/* if taking bit fails then try next one */
-			id++;
-		}
-	}
-
-	mutex_unlock(&bitmap_lock);
-
-	return id;
-}
-
 /**
  * cdns_uart_probe - Platform driver probe
  * @pdev: Pointer to the platform device structure
@@ -1506,17 +1423,21 @@ static int cdns_uart_probe(struct platfo
 	if (!cdns_uart_uart_driver)
 		return -ENOMEM;
 
-	cdns_uart_data->id = cdns_get_id(pdev);
+	/* Look for a serialN alias */
+	cdns_uart_data->id = of_alias_get_id(pdev->dev.of_node, "serial");
 	if (cdns_uart_data->id < 0)
-		return cdns_uart_data->id;
+		cdns_uart_data->id = 0;
+
+	if (cdns_uart_data->id >= CDNS_UART_NR_PORTS) {
+		dev_err(&pdev->dev, "Cannot get uart_port structure\n");
+		return -ENODEV;
+	}
 
 	/* There is a need to use unique driver name */
 	driver_name = devm_kasprintf(&pdev->dev, GFP_KERNEL, "%s%d",
 				     CDNS_UART_NAME, cdns_uart_data->id);
-	if (!driver_name) {
-		rc = -ENOMEM;
-		goto err_out_id;
-	}
+	if (!driver_name)
+		return -ENOMEM;
 
 	cdns_uart_uart_driver->owner = THIS_MODULE;
 	cdns_uart_uart_driver->driver_name = driver_name;
@@ -1545,7 +1466,7 @@ static int cdns_uart_probe(struct platfo
 	rc = uart_register_driver(cdns_uart_uart_driver);
 	if (rc < 0) {
 		dev_err(&pdev->dev, "Failed to register driver\n");
-		goto err_out_id;
+		return rc;
 	}
 
 	cdns_uart_data->cdns_uart_driver = cdns_uart_uart_driver;
@@ -1695,10 +1616,7 @@ err_out_clk_dis_pclk:
 	clk_disable_unprepare(cdns_uart_data->pclk);
 err_out_unregister_driver:
 	uart_unregister_driver(cdns_uart_data->cdns_uart_driver);
-err_out_id:
-	mutex_lock(&bitmap_lock);
-	clear_bit(cdns_uart_data->id, bitmap);
-	mutex_unlock(&bitmap_lock);
+
 	return rc;
 }
 
@@ -1721,9 +1639,6 @@ static int cdns_uart_remove(struct platf
 #endif
 	rc = uart_remove_one_port(cdns_uart_data->cdns_uart_driver, port);
 	port->mapbase = 0;
-	mutex_lock(&bitmap_lock);
-	clear_bit(cdns_uart_data->id, bitmap);
-	mutex_unlock(&bitmap_lock);
 	clk_disable_unprepare(cdns_uart_data->uartclk);
 	clk_disable_unprepare(cdns_uart_data->pclk);
 	pm_runtime_disable(&pdev->dev);


