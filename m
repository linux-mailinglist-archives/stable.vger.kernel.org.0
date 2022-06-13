Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB4B548B52
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351417AbiFMMY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355213AbiFMMXz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:23:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3103152C;
        Mon, 13 Jun 2022 04:04:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DF0BB80E42;
        Mon, 13 Jun 2022 11:04:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 650EFC34114;
        Mon, 13 Jun 2022 11:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118272;
        bh=TzlHtR3LNAMSh2GvVDP3oC07worqPWNyvIT9pg2lMoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VOeXmjCw+CJcj5yxrBB+KBGcpU5cEZLAVas9E1IWKPdo0+vFf4/82s1ers/YFUo2C
         gM0S5nTLXwg8Ri/K4q1unfUe2MD+WloVNELdee1poT/QVT9aoE8ypxfTJ/He385V+v
         TsgCoMRA1811QWiIm7ihVawN4/3yYsR9dt26Lw7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sherry Sun <sherry.sun@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 008/172] tty: serial: fsl_lpuart: fix potential bug when using both of_alias_get_id and ida_simple_get
Date:   Mon, 13 Jun 2022 12:09:28 +0200
Message-Id: <20220613094852.374038844@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094850.166931805@linuxfoundation.org>
References: <20220613094850.166931805@linuxfoundation.org>
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
index b9f8add284e3..52a603a6f9b8 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -229,8 +229,6 @@
 /* IMX lpuart has four extra unused regs located at the beginning */
 #define IMX_REG_OFF	0x10
 
-static DEFINE_IDA(fsl_lpuart_ida);
-
 enum lpuart_type {
 	VF610_LPUART,
 	LS1021A_LPUART,
@@ -265,7 +263,6 @@ struct lpuart_port {
 	int			rx_dma_rng_buf_len;
 	unsigned int		dma_tx_nents;
 	wait_queue_head_t	dma_wait;
-	bool			id_allocated;
 };
 
 struct lpuart_soc_data {
@@ -2638,23 +2635,18 @@ static int lpuart_probe(struct platform_device *pdev)
 
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
@@ -2697,10 +2689,6 @@ static int lpuart_probe(struct platform_device *pdev)
 failed_attach_port:
 failed_irq_request:
 	lpuart_disable_clks(sport);
-failed_clock_enable:
-failed_out_of_range:
-	if (sport->id_allocated)
-		ida_simple_remove(&fsl_lpuart_ida, sport->port.line);
 	return ret;
 }
 
@@ -2710,9 +2698,6 @@ static int lpuart_remove(struct platform_device *pdev)
 
 	uart_remove_one_port(&lpuart_reg, &sport->port);
 
-	if (sport->id_allocated)
-		ida_simple_remove(&fsl_lpuart_ida, sport->port.line);
-
 	lpuart_disable_clks(sport);
 
 	if (sport->dma_tx_chan)
@@ -2842,7 +2827,6 @@ static int __init lpuart_serial_init(void)
 
 static void __exit lpuart_serial_exit(void)
 {
-	ida_destroy(&fsl_lpuart_ida);
 	platform_driver_unregister(&lpuart_driver);
 	uart_unregister_driver(&lpuart_reg);
 }
-- 
2.35.1



