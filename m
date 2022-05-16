Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF4AC5288C5
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 17:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241783AbiEPP0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 11:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245280AbiEPP0p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 11:26:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6AA912090;
        Mon, 16 May 2022 08:26:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76535B8121B;
        Mon, 16 May 2022 15:26:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3B1C385AA;
        Mon, 16 May 2022 15:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652714802;
        bh=JztI8HRn1WRJ0KxdPoT2HzVWj4E6+JPXuz5amPg/sf8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P8t6JwlzIdGgNbztG/ue5BkgiDwqsqhHKcBgDxwX2inVugHgGBFrUpWTydW50qGGB
         1J4+moExBK7TjrSuoT9c/L3oa9lD46L4mhCsqoqqZ2RrLSP1Vbw6t44dOIXaiwiUCA
         yDDWEft0lvuUK2fOwsmoE9WJGhQ9BXcH4q7HjEWI=
Date:   Mon, 16 May 2022 17:26:34 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        baruch@tkos.co.il
Subject: Re: [PATCH 4.9/4.14/4.19/5.4] tty/serial: digicolor: fix possible
 null-ptr-deref in digicolor_uart_probe()
Message-ID: <YoJtKiRuoWE+oAzG@kroah.com>
References: <20220516141152.1549756-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516141152.1549756-1-yangyingliang@huawei.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 16, 2022 at 10:11:52PM +0800, Yang Yingliang wrote:
> commit 447ee1516f19f534a228dda237eddb202f23e163 upstream.
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
>   These stable versions don't have devm_platform_get_and_ioremap_resource(),
>   so just move using 'res' after devm_ioremap_resource().
> ---
>  drivers/tty/serial/digicolor-usart.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/serial/digicolor-usart.c b/drivers/tty/serial/digicolor-usart.c
> index 50ec5f1ac77f4..794864fac6250 100644
> --- a/drivers/tty/serial/digicolor-usart.c
> +++ b/drivers/tty/serial/digicolor-usart.c
> @@ -476,10 +476,10 @@ static int digicolor_uart_probe(struct platform_device *pdev)
>  		return PTR_ERR(uart_clk);
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	dp->port.mapbase = res->start;
>  	dp->port.membase = devm_ioremap_resource(&pdev->dev, res);
>  	if (IS_ERR(dp->port.membase))
>  		return PTR_ERR(dp->port.membase);
> +	dp->port.mapbase = res->start;
>  
>  	irq = platform_get_irq(pdev, 0);
>  	if (irq < 0)
> -- 
> 2.25.1
> 

Now queued up, thanks.

greg k-h
