Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5D6317BDF1
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 14:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgCFNPu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 08:15:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:42124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726866AbgCFNPu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Mar 2020 08:15:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 751E8206E2;
        Fri,  6 Mar 2020 13:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583500549;
        bh=H6MUUeOh6gM3KIOMSffXctA3qIK6IyUB0I2Xa8Lw0oo=;
        h=Subject:To:From:Date:From;
        b=gggxh4K9+SqC/VXUoEbOPloSuk4v87wuwKulHfaIYFkRY1d0amcRtC9xs35ZgbLku
         F3JuNEZ1lA37ivOtEY/KEOLVEtN0y2V9RKdRZUg9oCYMuQWnXH2Vn8xuPswvWPXHRV
         R92JVAWHFdps+jdarinL5xRCI403K5RVsTht+M7Q=
Subject: patch "tty: serial: fsl_lpuart: free IDs allocated by IDA" added to tty-linus
To:     michael@walle.cc, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 06 Mar 2020 14:15:39 +0100
Message-ID: <15835005393365@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tty: serial: fsl_lpuart: free IDs allocated by IDA

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 2b2e71fe657510a6f71aa16ef0309fa6bc20ab3d Mon Sep 17 00:00:00 2001
From: Michael Walle <michael@walle.cc>
Date: Tue, 3 Mar 2020 18:42:59 +0100
Subject: tty: serial: fsl_lpuart: free IDs allocated by IDA

Since commit 3bc3206e1c0f ("serial: fsl_lpuart: Remove the alias node
dependence") the port line number can also be allocated by IDA, but in
case of an error the ID will no be removed again. More importantly, any
ID will be freed in remove(), even if it wasn't allocated but instead
fetched by of_alias_get_id(). If it was not allocated by IDA there will
be a warning:
  WARN(1, "ida_free called for id=%d which is not allocated.\n", id);

Move the ID allocation more to the end of the probe() so that we still
can use plain return in the first error cases.

Fixes: 3bc3206e1c0f ("serial: fsl_lpuart: Remove the alias node dependence")
Signed-off-by: Michael Walle <michael@walle.cc>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200303174306.6015-3-michael@walle.cc
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/fsl_lpuart.c | 39 ++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 27fdc131c352..c31b8f3db6bf 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -264,6 +264,7 @@ struct lpuart_port {
 	int			rx_dma_rng_buf_len;
 	unsigned int		dma_tx_nents;
 	wait_queue_head_t	dma_wait;
+	bool			id_allocated;
 };
 
 struct lpuart_soc_data {
@@ -2422,19 +2423,6 @@ static int lpuart_probe(struct platform_device *pdev)
 	if (!sport)
 		return -ENOMEM;
 
-	ret = of_alias_get_id(np, "serial");
-	if (ret < 0) {
-		ret = ida_simple_get(&fsl_lpuart_ida, 0, UART_NR, GFP_KERNEL);
-		if (ret < 0) {
-			dev_err(&pdev->dev, "port line is full, add device failed\n");
-			return ret;
-		}
-	}
-	if (ret >= ARRAY_SIZE(lpuart_ports)) {
-		dev_err(&pdev->dev, "serial%d out of range\n", ret);
-		return -EINVAL;
-	}
-	sport->port.line = ret;
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	sport->port.membase = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(sport->port.membase))
@@ -2479,9 +2467,25 @@ static int lpuart_probe(struct platform_device *pdev)
 		}
 	}
 
+	ret = of_alias_get_id(np, "serial");
+	if (ret < 0) {
+		ret = ida_simple_get(&fsl_lpuart_ida, 0, UART_NR, GFP_KERNEL);
+		if (ret < 0) {
+			dev_err(&pdev->dev, "port line is full, add device failed\n");
+			return ret;
+		}
+		sport->id_allocated = true;
+	}
+	if (ret >= ARRAY_SIZE(lpuart_ports)) {
+		dev_err(&pdev->dev, "serial%d out of range\n", ret);
+		ret = -EINVAL;
+		goto failed_out_of_range;
+	}
+	sport->port.line = ret;
+
 	ret = lpuart_enable_clks(sport);
 	if (ret)
-		return ret;
+		goto failed_clock_enable;
 	sport->port.uartclk = lpuart_get_baud_clk_rate(sport);
 
 	lpuart_ports[sport->port.line] = sport;
@@ -2531,6 +2535,10 @@ static int lpuart_probe(struct platform_device *pdev)
 failed_attach_port:
 failed_irq_request:
 	lpuart_disable_clks(sport);
+failed_clock_enable:
+failed_out_of_range:
+	if (sport->id_allocated)
+		ida_simple_remove(&fsl_lpuart_ida, sport->port.line);
 	return ret;
 }
 
@@ -2540,7 +2548,8 @@ static int lpuart_remove(struct platform_device *pdev)
 
 	uart_remove_one_port(&lpuart_reg, &sport->port);
 
-	ida_simple_remove(&fsl_lpuart_ida, sport->port.line);
+	if (sport->id_allocated)
+		ida_simple_remove(&fsl_lpuart_ida, sport->port.line);
 
 	lpuart_disable_clks(sport);
 
-- 
2.25.1


