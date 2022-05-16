Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A70AF528FE2
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346388AbiEPULX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351116AbiEPUCC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:02:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535C72BE;
        Mon, 16 May 2022 12:59:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0088BB81613;
        Mon, 16 May 2022 19:59:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6310DC385AA;
        Mon, 16 May 2022 19:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652731151;
        bh=f2hGEdwI5KESCq279unJLIm61lGflU5bE9/b18+OZzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S/89c5PhfSpOQrFsyL6GqaeYi3EH5BOEobIP6SQTZvclPlXbC7qS1ZCDpKrUOwpmI
         l4n4u1/GcDFi4iB6NtjqTObBVVKEiQK1Jfki8IhNFXqzoyPqiARuOo1V6RjWThbaHi
         0MRn868D6XqjAmOEpl9JIxtZ7BbJnZjR+jz2b6BQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Indan Zupancic <Indan.Zupancic@mep-info.com>
Subject: [PATCH 5.17 088/114] fsl_lpuart: Dont enable interrupts too early
Date:   Mon, 16 May 2022 21:37:02 +0200
Message-Id: <20220516193628.005676316@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Indan Zupancic <Indan.Zupancic@mep-info.com>

commit 401fb66a355eb0f22096cf26864324f8e63c7d78 upstream.

If an irq is pending when devm_request_irq() is called, the irq
handler will cause a NULL pointer access because initialisation
is not done yet.

Fixes: 9d7ee0e28da59 ("tty: serial: lpuart: avoid report NULL interrupt")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Indan Zupancic <Indan.Zupancic@mep-info.com>
Link: https://lore.kernel.org/r/20220505114750.45423-1-Indan.Zupancic@mep-info.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/fsl_lpuart.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2658,6 +2658,7 @@ static int lpuart_probe(struct platform_
 	struct device_node *np = pdev->dev.of_node;
 	struct lpuart_port *sport;
 	struct resource *res;
+	irq_handler_t handler;
 	int ret;
 
 	sport = devm_kzalloc(&pdev->dev, sizeof(*sport), GFP_KERNEL);
@@ -2735,17 +2736,11 @@ static int lpuart_probe(struct platform_
 
 	if (lpuart_is_32(sport)) {
 		lpuart_reg.cons = LPUART32_CONSOLE;
-		ret = devm_request_irq(&pdev->dev, sport->port.irq, lpuart32_int, 0,
-					DRIVER_NAME, sport);
+		handler = lpuart32_int;
 	} else {
 		lpuart_reg.cons = LPUART_CONSOLE;
-		ret = devm_request_irq(&pdev->dev, sport->port.irq, lpuart_int, 0,
-					DRIVER_NAME, sport);
+		handler = lpuart_int;
 	}
-
-	if (ret)
-		goto failed_irq_request;
-
 	ret = uart_add_one_port(&lpuart_reg, &sport->port);
 	if (ret)
 		goto failed_attach_port;
@@ -2767,13 +2762,18 @@ static int lpuart_probe(struct platform_
 
 	sport->port.rs485_config(&sport->port, &sport->port.rs485);
 
+	ret = devm_request_irq(&pdev->dev, sport->port.irq, handler, 0,
+				DRIVER_NAME, sport);
+	if (ret)
+		goto failed_irq_request;
+
 	return 0;
 
+failed_irq_request:
 failed_get_rs485:
 failed_reset:
 	uart_remove_one_port(&lpuart_reg, &sport->port);
 failed_attach_port:
-failed_irq_request:
 	lpuart_disable_clks(sport);
 failed_clock_enable:
 failed_out_of_range:


