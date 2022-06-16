Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE00954E2B0
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 15:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233665AbiFPN6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 09:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377367AbiFPN6q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 09:58:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1524CF4;
        Thu, 16 Jun 2022 06:58:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C14A61D4F;
        Thu, 16 Jun 2022 13:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 660E7C34114;
        Thu, 16 Jun 2022 13:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655387924;
        bh=GtFu1yL7NBd00sE3MZWv/Se2J2i0SxpzD43fBfzA+sE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=myEfOqwXVIWO0A5Ij7Qyf0VDfFGPNxUM865ziyMoXJBCCmgQn3EqqmHj2Z/BibH9f
         RV3lbanRVPg9U4xxxGj2nwbDTelT528XU07AAejifGhiWyQA7GssJzDUZvDDpH1Uiw
         gkOT3pJsx8gkiUZzkyIStW2vESo6yZRBG7r5ZcRwSbbhi1SuzU0lnFE7fLzD/TDz3+
         nQUEHMFCDC4BWTZRKrg0/TeUvYgmBiH86G6yMMZBd97uYyo2QN6Qz0VZ1WfbSWbVTK
         Jy5du4pHCvAliAJStdyVXVv3qnB0yikwoZ8gCNm1H0QUZxfcSPgyFaCStjyMSbG8TD
         IWor6n8XUCN3w==
Date:   Thu, 16 Jun 2022 06:58:43 -0700
From:   Vinod Koul <vkoul@kernel.org>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org, linux-amarula@amarulasolutions.com,
        Michael Trimarchi <michael@amarulasolutions.com>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3] dmaengine: mxs: fix driver registering
Message-ID: <Yqs3E0ipEpsCT2T2@matsya>
References: <20220614101751.3636028-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614101751.3636028-1-dario.binacchi@amarulasolutions.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 14-06-22, 12:17, Dario Binacchi wrote:
> Driver registration fails on SOC imx8mn as its supplier, the clock
> control module, is not ready. Since platform_driver_probe(), as
> reported by its description, is incompatible with deferred probing,
> we have to use platform_driver_register().
> 
> Fixes: a580b8c5429a ("dmaengine: mxs-dma: add dma support for i.MX23/28")
> Co-developed-by: Michael Trimarchi <michael@amarulasolutions.com>
> Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> Cc: stable@vger.kernel.org
> 
> ---
> 
> Changes in v3:
> - Restore __init in front of mxs_dma_init() definition.
> 
> Changes in v2:
> - Add the tag "Cc: stable@vger.kernel.org" in the sign-off area.
> 
>  drivers/dma/mxs-dma.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
> index 994fc4d2aca4..6e90540fedc4 100644
> --- a/drivers/dma/mxs-dma.c
> +++ b/drivers/dma/mxs-dma.c
> @@ -741,7 +741,7 @@ static struct dma_chan *mxs_dma_xlate(struct of_phandle_args *dma_spec,
>  				     ofdma->of_node);
>  }
>  
> -static int __init mxs_dma_probe(struct platform_device *pdev)
> +static int mxs_dma_probe(struct platform_device *pdev)

why drop __init here, if there is a reason for that please split this
change and document such reason...

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

-- 
~Vinod
