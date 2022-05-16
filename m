Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9E5C527F1C
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 10:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239388AbiEPICC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 04:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241428AbiEPICA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 04:02:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29CAB2C65C
        for <stable@vger.kernel.org>; Mon, 16 May 2022 01:02:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBD4A6117F
        for <stable@vger.kernel.org>; Mon, 16 May 2022 08:01:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D12EDC385AA;
        Mon, 16 May 2022 08:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652688119;
        bh=/pRIy/ts7J+Fo5r3qYM2980D2BxeLQ4JpET+y7QhnZA=;
        h=Subject:To:Cc:From:Date:From;
        b=eurIoQ8RCX/sZuSFxHtCbyzhD83QwG6Rdoi9OljtzPdlbB8lt2X3mkoXkdf3bH42U
         SjG8k1yNrFG1ryrgowOPVRkBpPwLN/gD/omvcuX8FY/eZwKlxwZgsoAEB1SqGxwbFf
         o1Z+Ypa9of9gxYq+j21na/iZMgy9qZx923e/F2UY=
Subject: FAILED: patch "[PATCH] tty/serial: digicolor: fix possible null-ptr-deref in" failed to apply to 5.4-stable tree
To:     yangyingliang@huawei.com, baruch@tkos.co.il,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 May 2022 10:01:48 +0200
Message-ID: <165268810820728@kroah.com>
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 447ee1516f19f534a228dda237eddb202f23e163 Mon Sep 17 00:00:00 2001
From: Yang Yingliang <yangyingliang@huawei.com>
Date: Thu, 5 May 2022 20:46:21 +0800
Subject: [PATCH] tty/serial: digicolor: fix possible null-ptr-deref in
 digicolor_uart_probe()

It will cause null-ptr-deref when using 'res', if platform_get_resource()
returns NULL, so move using 'res' after devm_ioremap_resource() that
will check it to avoid null-ptr-deref.
And use devm_platform_get_and_ioremap_resource() to simplify code.

Fixes: 5930cb3511df ("serial: driver for Conexant Digicolor USART")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Baruch Siach <baruch@tkos.co.il>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220505124621.1592697-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/serial/digicolor-usart.c b/drivers/tty/serial/digicolor-usart.c
index 6d70fea76bb3..e37a917b9dbb 100644
--- a/drivers/tty/serial/digicolor-usart.c
+++ b/drivers/tty/serial/digicolor-usart.c
@@ -471,11 +471,10 @@ static int digicolor_uart_probe(struct platform_device *pdev)
 	if (IS_ERR(uart_clk))
 		return PTR_ERR(uart_clk);
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	dp->port.mapbase = res->start;
-	dp->port.membase = devm_ioremap_resource(&pdev->dev, res);
+	dp->port.membase = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
 	if (IS_ERR(dp->port.membase))
 		return PTR_ERR(dp->port.membase);
+	dp->port.mapbase = res->start;
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)

