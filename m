Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D65154986D
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377062AbiFMNZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377190AbiFMNYl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:24:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C616B7E7;
        Mon, 13 Jun 2022 04:23:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCDD9B80E59;
        Mon, 13 Jun 2022 11:23:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F393C34114;
        Mon, 13 Jun 2022 11:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119432;
        bh=vRM2dlIwjQSrogb4P0RAs0ZyRLIbezsLTuCM6WnjExU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wRpxQgo/fOFIW3g0p9QYQRODZcb5hr4Ntuj5Ddqmic3jJMN7s8NJroCNlC/+SaPvv
         qXHqYmJ+RyP1teNcm0dzBLyf0wUR+LpWGrJbtdJDT+/rQ9+L5yXUZ8lUlwWiuHVIQm
         mWHJP5i50jCgHGk8p3oTlRS6Z/EO9GJcvDPLW4Dc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sherry Sun <sherry.sun@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 013/339] tty: serial: fsl_lpuart: fix potential bug when using both of_alias_get_id and ida_simple_get
Date:   Mon, 13 Jun 2022 12:07:18 +0200
Message-Id: <20220613094926.911327425@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sherry Sun <sherry.sun@nxp.com>

[ Upstream commit f398e0aa325c61fa20903833a5b534ecb8e6e418 ]

Now fsl_lpuart driver use both of_alias_get_id() and ida_simple_get() in
.probe(), which has the potential bug. For example, when remove the
lpuart7 alias in dts, of_alias_get_id() will return error, then call
ida_simple_get() to allocate the id 0 for lpuart7, this may confilct
with the lpuart4 which has alias 0.

    aliases {
	...
        serial0 = &lpuart4;
        serial1 = &lpuart5;
        serial2 = &lpuart6;
        serial3 = &lpuart7;
    }

So remove the ida_simple_get() in .probe(), return an error directly
when calling of_alias_get_id() fails, which is consistent with other
uart drivers behavior.

Fixes: 3bc3206e1c0f ("serial: fsl_lpuart: Remove the alias node dependence")
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Link: https://lore.kernel.org/r/20220321112211.8895-1-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/fsl_lpuart.c | 24 ++++--------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index be12fee94db5..2cb89491dd09 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -239,8 +239,6 @@
 /* IMX lpuart has four extra unused regs located at the beginning */
 #define IMX_REG_OFF	0x10
 
-static DEFINE_IDA(fsl_lpuart_ida);
-
 enum lpuart_type {
 	VF610_LPUART,
 	LS1021A_LPUART,
@@ -276,7 +274,6 @@ struct lpuart_port {
 	int			rx_dma_rng_buf_len;
 	unsigned int		dma_tx_nents;
 	wait_queue_head_t	dma_wait;
-	bool			id_allocated;
 };
 
 struct lpuart_soc_data {
@@ -2717,23 +2714,18 @@ static int lpuart_probe(struct platform_device *pdev)
 
 	ret = of_alias_get_id(np, "serial");
 	if (ret < 0) {
-		ret = ida_simple_get(&fsl_lpuart_ida, 0, UART_NR, GFP_KERNEL);
-		if (ret < 0) {
-			dev_err(&pdev->dev, "port line is full, add device failed\n");
-			return ret;
-		}
-		sport->id_allocated = true;
+		dev_err(&pdev->dev, "failed to get alias id, errno %d\n", ret);
+		return ret;
 	}
 	if (ret >= ARRAY_SIZE(lpuart_ports)) {
 		dev_err(&pdev->dev, "serial%d out of range\n", ret);
-		ret = -EINVAL;
-		goto failed_out_of_range;
+		return -EINVAL;
 	}
 	sport->port.line = ret;
 
 	ret = lpuart_enable_clks(sport);
 	if (ret)
-		goto failed_clock_enable;
+		return ret;
 	sport->port.uartclk = lpuart_get_baud_clk_rate(sport);
 
 	lpuart_ports[sport->port.line] = sport;
@@ -2781,10 +2773,6 @@ static int lpuart_probe(struct platform_device *pdev)
 	uart_remove_one_port(&lpuart_reg, &sport->port);
 failed_attach_port:
 	lpuart_disable_clks(sport);
-failed_clock_enable:
-failed_out_of_range:
-	if (sport->id_allocated)
-		ida_simple_remove(&fsl_lpuart_ida, sport->port.line);
 	return ret;
 }
 
@@ -2794,9 +2782,6 @@ static int lpuart_remove(struct platform_device *pdev)
 
 	uart_remove_one_port(&lpuart_reg, &sport->port);
 
-	if (sport->id_allocated)
-		ida_simple_remove(&fsl_lpuart_ida, sport->port.line);
-
 	lpuart_disable_clks(sport);
 
 	if (sport->dma_tx_chan)
@@ -2926,7 +2911,6 @@ static int __init lpuart_serial_init(void)
 
 static void __exit lpuart_serial_exit(void)
 {
-	ida_destroy(&fsl_lpuart_ida);
 	platform_driver_unregister(&lpuart_driver);
 	uart_unregister_driver(&lpuart_reg);
 }
-- 
2.35.1



