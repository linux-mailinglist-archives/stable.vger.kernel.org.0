Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 391D553099A
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 08:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiEWGmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 02:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiEWGmC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 02:42:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0734D61B;
        Sun, 22 May 2022 23:41:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A45A9B80F00;
        Mon, 23 May 2022 06:26:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B428C385A9;
        Mon, 23 May 2022 06:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653287179;
        bh=yJL8uVkYFpCvvkQePY+koScMornVS7Wnyustin7mw/g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ynj3tOGCvNqo72OBHX0D0hj+3UxSSIvV8VNH9O3Xf2U6A7vX/Vn0Otn7qof6go3Bb
         2kGKsZ4IlTf3/qOVa2/Ehao5ArR+cTFAyVEma1RvVjTTNhfnwra1LCkDAjNrW+2GqY
         MwJq8/+a2KIIdf3iFpb/h9IHmSIbI5qtctZlDxes=
Date:   Mon, 23 May 2022 08:26:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Michael Trimarchi <michael@amarulasolutions.com>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] dmaengine: mxs: fix driver registering
Message-ID: <YospB9JZdwVfkIhj@kroah.com>
References: <20220522202223.1343109-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220522202223.1343109-1-dario.binacchi@amarulasolutions.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 22, 2022 at 10:22:23PM +0200, Dario Binacchi wrote:
> Driver registration fails on SOC imx8mn as its supplier, the clock
> control module, is not ready. Since platform_driver_probe(), as
> reported by its description, is incompatible with deferred probing,
> we have to use platform_driver_register().
> 
> Fixes: a580b8c5429a ("dmaengine: mxs-dma: add dma support for i.MX23/28")
> Co-developed-by: Michael Trimarchi <michael@amarulasolutions.com>
> Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> 
> ---
> 
>  drivers/dma/mxs-dma.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
> index 994fc4d2aca4..b8a3e692330d 100644
> --- a/drivers/dma/mxs-dma.c
> +++ b/drivers/dma/mxs-dma.c
> @@ -670,7 +670,7 @@ static enum dma_status mxs_dma_tx_status(struct dma_chan *chan,
>  	return mxs_chan->status;
>  }
>  
> -static int __init mxs_dma_init(struct mxs_dma_engine *mxs_dma)
> +static int mxs_dma_init(struct mxs_dma_engine *mxs_dma)
>  {
>  	int ret;
>  
> @@ -741,7 +741,7 @@ static struct dma_chan *mxs_dma_xlate(struct of_phandle_args *dma_spec,
>  				     ofdma->of_node);
>  }
>  
> -static int __init mxs_dma_probe(struct platform_device *pdev)
> +static int mxs_dma_probe(struct platform_device *pdev)
>  {
>  	struct device_node *np = pdev->dev.of_node;
>  	const struct mxs_dma_type *dma_type;
> @@ -839,10 +839,7 @@ static struct platform_driver mxs_dma_driver = {
>  		.name	= "mxs-dma",
>  		.of_match_table = mxs_dma_dt_ids,
>  	},
> +	.probe = mxs_dma_probe,
>  };
>  
> -static int __init mxs_dma_module_init(void)
> -{
> -	return platform_driver_probe(&mxs_dma_driver, mxs_dma_probe);
> -}
> -subsys_initcall(mxs_dma_module_init);
> +module_platform_driver(mxs_dma_driver);
> -- 
> 2.32.0
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
