Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F397A528E71
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 21:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345841AbiEPTnb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346107AbiEPTmv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:42:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E573F33C;
        Mon, 16 May 2022 12:41:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76608B8160F;
        Mon, 16 May 2022 19:41:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4452C385AA;
        Mon, 16 May 2022 19:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730101;
        bh=BTB41/R4kJKDuRFtO1AJT/GmcZ1Qb1obV1+MMcxmR6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w6PIbCaiOtq8n+3445NzxGdmGS9hWADa8OrVBpdpbULYOEi53T1ib77+++k3oA8qh
         cebAxGwwT81x0ggxwPdVpz/qyF3cQQU4ar2qstoL6CLrhPV2R1P95LJRA6RZGGWjTh
         jhp+v97+uEH0DvQ5jKxO1sm/DBCW7ZacM+Hc/owU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH 4.19 32/32] tty/serial: digicolor: fix possible null-ptr-deref in digicolor_uart_probe()
Date:   Mon, 16 May 2022 21:36:46 +0200
Message-Id: <20220516193615.726528551@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193614.773450018@linuxfoundation.org>
References: <20220516193614.773450018@linuxfoundation.org>
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
 drivers/tty/serial/digicolor-usart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/digicolor-usart.c
+++ b/drivers/tty/serial/digicolor-usart.c
@@ -472,10 +472,10 @@ static int digicolor_uart_probe(struct p
 		return PTR_ERR(uart_clk);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	dp->port.mapbase = res->start;
 	dp->port.membase = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(dp->port.membase))
 		return PTR_ERR(dp->port.membase);
+	dp->port.mapbase = res->start;
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)


