Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBCC528F3E
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 21:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242962AbiEPTxX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346867AbiEPTv2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:51:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4FE444A1E;
        Mon, 16 May 2022 12:45:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6D5361596;
        Mon, 16 May 2022 19:45:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0354BC34100;
        Mon, 16 May 2022 19:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730356;
        bh=4bf/UsuSgVW7vJNOHxwczts9LNMMkWBw0O6Z5qy8XRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=otu145GOJM6twhz8/Z1zeEPoDwos9H5zQyi3DEvirtqMFm4uzX+C7udy/87GjWyTN
         JNEUGmeJdEZZK8IXwc4Ycjj2GcIE/v8W08Y+4nRUgg/533hrEW0UTjDYnbVR1fuIi6
         mXsW/oZiRQU3NxmnR6FJ6/7JMw61nwbcstwgYHoY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH 5.10 40/66] tty/serial: digicolor: fix possible null-ptr-deref in digicolor_uart_probe()
Date:   Mon, 16 May 2022 21:36:40 +0200
Message-Id: <20220516193620.574237944@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193619.400083785@linuxfoundation.org>
References: <20220516193619.400083785@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

commit 447ee1516f19f534a228dda237eddb202f23e163 upstream.

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
 drivers/tty/serial/digicolor-usart.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/tty/serial/digicolor-usart.c
+++ b/drivers/tty/serial/digicolor-usart.c
@@ -471,11 +471,10 @@ static int digicolor_uart_probe(struct p
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


