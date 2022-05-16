Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85838527F34
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 10:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241495AbiEPIHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 04:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241375AbiEPIHO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 04:07:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE17929C9C
        for <stable@vger.kernel.org>; Mon, 16 May 2022 01:07:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3DC8B80AFB
        for <stable@vger.kernel.org>; Mon, 16 May 2022 08:07:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D30BC385AA;
        Mon, 16 May 2022 08:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652688431;
        bh=sXQASlUDIrq3hirh6PVWT+z999rL02ClWMwCSr8lC/g=;
        h=Subject:To:Cc:From:Date:From;
        b=2qa4sVAVB3lzGDOcTSrAx8kcmiqKhoVOIfMMWIGwWut7fy4x/yZuBn+/bsZqk2xjZ
         VV0qz1EAshmhZcLySKiaDUlTnFLsLbuGpjiqShnaZaV2VESwL02q3JJsX6cl52gJmh
         4yIyLrnWMY7ZXk2Fb8YGO6mL5U5SyPJCluBrI8FE=
Subject: FAILED: patch "[PATCH] fsl_lpuart: Don't enable interrupts too early" failed to apply to 4.14-stable tree
To:     Indan.Zupancic@mep-info.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 May 2022 10:07:08 +0200
Message-ID: <16526884283953@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 401fb66a355eb0f22096cf26864324f8e63c7d78 Mon Sep 17 00:00:00 2001
From: Indan Zupancic <Indan.Zupancic@mep-info.com>
Date: Thu, 5 May 2022 13:47:50 +0200
Subject: [PATCH] fsl_lpuart: Don't enable interrupts too early

If an irq is pending when devm_request_irq() is called, the irq
handler will cause a NULL pointer access because initialisation
is not done yet.

Fixes: 9d7ee0e28da59 ("tty: serial: lpuart: avoid report NULL interrupt")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Indan Zupancic <Indan.Zupancic@mep-info.com>
Link: https://lore.kernel.org/r/20220505114750.45423-1-Indan.Zupancic@mep-info.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 87789872f400..be12fee94db5 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2664,6 +2664,7 @@ static int lpuart_probe(struct platform_device *pdev)
 	struct device_node *np = pdev->dev.of_node;
 	struct lpuart_port *sport;
 	struct resource *res;
+	irq_handler_t handler;
 	int ret;
 
 	sport = devm_kzalloc(&pdev->dev, sizeof(*sport), GFP_KERNEL);
@@ -2741,17 +2742,11 @@ static int lpuart_probe(struct platform_device *pdev)
 
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
@@ -2773,13 +2768,18 @@ static int lpuart_probe(struct platform_device *pdev)
 
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

