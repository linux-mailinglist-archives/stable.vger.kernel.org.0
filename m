Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A98A117F8D6
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbgCJMvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:51:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728903AbgCJMv3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:51:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F22772468E;
        Tue, 10 Mar 2020 12:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844688;
        bh=l4RFUPXPw3XERjAZoBxTDw4cHLH4bUhQehVVwAMxNJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GVlRKl99bq1bx/gQERWdy0OhVSd8SfFYetqOYIdX9Qqa5AmMX3AcAyLUXErZGMofP
         I4pMuIJCiolLNqKGcFjVvjTd0E372OjRjNyujmITDxdRIOMyaBHLQitFBHO5HBcAfn
         erfPiSm86oNgi3ZXXTPw61XNC1OiiThr1z+7Enqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>
Subject: [PATCH 5.4 083/168] tty: serial: fsl_lpuart: free IDs allocated by IDA
Date:   Tue, 10 Mar 2020 13:38:49 +0100
Message-Id: <20200310123643.681777502@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

commit 2b2e71fe657510a6f71aa16ef0309fa6bc20ab3d upstream.

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
 drivers/tty/serial/fsl_lpuart.c |   39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -268,6 +268,7 @@ struct lpuart_port {
 	int			rx_dma_rng_buf_len;
 	unsigned int		dma_tx_nents;
 	wait_queue_head_t	dma_wait;
+	bool			id_allocated;
 };
 
 struct lpuart_soc_data {
@@ -2382,19 +2383,6 @@ static int lpuart_probe(struct platform_
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
@@ -2435,9 +2423,25 @@ static int lpuart_probe(struct platform_
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
@@ -2487,6 +2491,10 @@ static int lpuart_probe(struct platform_
 failed_attach_port:
 failed_irq_request:
 	lpuart_disable_clks(sport);
+failed_clock_enable:
+failed_out_of_range:
+	if (sport->id_allocated)
+		ida_simple_remove(&fsl_lpuart_ida, sport->port.line);
 	return ret;
 }
 
@@ -2496,7 +2504,8 @@ static int lpuart_remove(struct platform
 
 	uart_remove_one_port(&lpuart_reg, &sport->port);
 
-	ida_simple_remove(&fsl_lpuart_ida, sport->port.line);
+	if (sport->id_allocated)
+		ida_simple_remove(&fsl_lpuart_ida, sport->port.line);
 
 	lpuart_disable_clks(sport);
 


