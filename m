Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32FFE5BFB16
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 11:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbiIUJfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 05:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiIUJfr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 05:35:47 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3985582D04;
        Wed, 21 Sep 2022 02:35:46 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 79DE3139F;
        Wed, 21 Sep 2022 02:35:52 -0700 (PDT)
Received: from [10.57.18.118] (unknown [10.57.18.118])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A0C373F73D;
        Wed, 21 Sep 2022 02:35:43 -0700 (PDT)
Message-ID: <2ce32413-d338-5032-71f1-7da183b2c561@arm.com>
Date:   Wed, 21 Sep 2022 10:35:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [RESEND PATCH v5 2/2] dmaengine: mxs: fix section mismatch
Content-Language: en-GB
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        linux-kernel@vger.kernel.org
Cc:     linux-amarula@amarulasolutions.com,
        Michael Trimarchi <michael@amarulasolutions.com>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20220904141020.2947725-1-dario.binacchi@amarulasolutions.com>
 <20220904141020.2947725-2-dario.binacchi@amarulasolutions.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20220904141020.2947725-2-dario.binacchi@amarulasolutions.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-09-04 15:10, Dario Binacchi wrote:
> The patch was suggested by the following modpost warning:
> 
> WARNING: modpost: vmlinux.o(.data+0xa3900): Section mismatch in reference from the variable mxs_dma_driver to the function .init.text:mxs_dma_probe()
> The variable mxs_dma_driver references
> the function __init mxs_dma_probe()
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the variable:
> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

This is very wrong - even *with* platform_driver_probe(), the driver may 
remain registered beyond init, so when the driver core walks the list 
trying to match a driver for some other device later it can access freed 
data and crash. Which is absolutely no fun to debug...

The correct fix is to remove the __init annotation from the probe 
routine. If you want to support deferred probe, consider that even your 
own probe call might potentially be delayed until after initdata is freed.

Thanks,
Robin.

> Co-developed-by: Michael Trimarchi <michael@amarulasolutions.com>
> Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> Cc: stable@vger.kernel.org
> ---
> 
> (no changes since v1)
> 
>   drivers/dma/mxs-dma.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
> index 18f8154b859b..a01953e06048 100644
> --- a/drivers/dma/mxs-dma.c
> +++ b/drivers/dma/mxs-dma.c
> @@ -834,7 +834,7 @@ static int __init mxs_dma_probe(struct platform_device *pdev)
>   	return 0;
>   }
>   
> -static struct platform_driver mxs_dma_driver = {
> +static struct platform_driver mxs_dma_driver __initdata = {
>   	.driver		= {
>   		.name	= "mxs-dma",
>   		.of_match_table = mxs_dma_dt_ids,
