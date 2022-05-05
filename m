Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D01E151CC32
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 00:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386425AbiEEWie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 May 2022 18:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386404AbiEEWiS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 May 2022 18:38:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBEBD5F25E
        for <stable@vger.kernel.org>; Thu,  5 May 2022 15:34:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8AA4561F4F
        for <stable@vger.kernel.org>; Thu,  5 May 2022 22:34:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D660CC385AE;
        Thu,  5 May 2022 22:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651790074;
        bh=em5+Eupom86A20GDjRTHcim9DYJ00Nwot/DwX3KMB5I=;
        h=Subject:To:From:Date:From;
        b=W4LGAX4H4J6qUxWeNGZvcZzCrr1bNDUOK8MrPTbHLrV8iayrUSfKTfWHa/S7L16Mm
         IEpnZFCyakdXYe/yDXDiis553F4AHtjZyrSbNjBTRdqlqqb/+riTi599Oz+tR8SzMP
         vVGfwbQ5+Nu23cFVl5jyKQ/XOGVjnBZs49ndSlpk=
Subject: patch "tty/serial: digicolor: fix possible null-ptr-deref in" added to tty-linus
To:     yangyingliang@huawei.com, baruch@tkos.co.il,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 05 May 2022 22:58:50 +0200
Message-ID: <165178433056130@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tty/serial: digicolor: fix possible null-ptr-deref in

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 447ee1516f19f534a228dda237eddb202f23e163 Mon Sep 17 00:00:00 2001
From: Yang Yingliang <yangyingliang@huawei.com>
Date: Thu, 5 May 2022 20:46:21 +0800
Subject: tty/serial: digicolor: fix possible null-ptr-deref in
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
---
 drivers/tty/serial/digicolor-usart.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

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
-- 
2.36.0


