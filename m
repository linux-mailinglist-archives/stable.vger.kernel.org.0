Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23C3E52863C
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 16:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244018AbiEPOBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 10:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244177AbiEPOBp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 10:01:45 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E553A3A18D;
        Mon, 16 May 2022 07:01:44 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4L219z6HLMzhZV3;
        Mon, 16 May 2022 22:00:55 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 16 May 2022 22:01:42 +0800
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 16 May 2022 22:01:42 +0800
Subject: Re: [PATCH 4.9/4.14/4.19/5.4] tty/serial: digicolor: fix possible
 null-ptr-deref in digicolor_uart_probe()
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
CC:     <baruch@tkos.co.il>, <gregkh@linuxfoundation.org>
References: <20220516141053.1549344-1-yangyingliang@huawei.com>
Message-ID: <3580ada7-3ad8-2caa-8af2-32896b752f2f@huawei.com>
Date:   Mon, 16 May 2022 22:01:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20220516141053.1549344-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I use a wrong commit id, please ignore this patch.

On 2022/5/16 22:10, Yang Yingliang wrote:
> commit 7c25a0b89a487878b0691e6524fb5a8827322194 upstream.
>
> It will cause null-ptr-deref when using 'res', if platform_get_resource()
> returns NULL, so move using 'res' after devm_ioremap_resource() that
> will check it to avoid null-ptr-deref.
> And use devm_platform_get_and_ioremap_resource() to simplify code.
>
> Fixes: 5930cb3511df ("serial: driver for Conexant Digicolor USART")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> Reviewed-by: Baruch Siach <baruch@tkos.co.il>
> Cc: stable <stable@vger.kernel.org>
> Link: https://lore.kernel.org/r/20220505124621.1592697-1-yangyingliang@huawei.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> v1:
>    These stable versions don't have devm_platform_get_and_ioremap_resource(),
>    so just move using 'res' after devm_ioremap_resource().
> ---
>   drivers/tty/serial/digicolor-usart.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/tty/serial/digicolor-usart.c b/drivers/tty/serial/digicolor-usart.c
> index 50ec5f1ac77f4..794864fac6250 100644
> --- a/drivers/tty/serial/digicolor-usart.c
> +++ b/drivers/tty/serial/digicolor-usart.c
> @@ -476,10 +476,10 @@ static int digicolor_uart_probe(struct platform_device *pdev)
>   		return PTR_ERR(uart_clk);
>   
>   	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	dp->port.mapbase = res->start;
>   	dp->port.membase = devm_ioremap_resource(&pdev->dev, res);
>   	if (IS_ERR(dp->port.membase))
>   		return PTR_ERR(dp->port.membase);
> +	dp->port.mapbase = res->start;
>   
>   	irq = platform_get_irq(pdev, 0);
>   	if (irq < 0)
