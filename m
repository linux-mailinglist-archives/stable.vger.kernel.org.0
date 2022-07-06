Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD722567E17
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 07:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbiGFF60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 01:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbiGFF6X (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 01:58:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0FAA2E5;
        Tue,  5 Jul 2022 22:58:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57F8B61CEE;
        Wed,  6 Jul 2022 05:58:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D38C341C0;
        Wed,  6 Jul 2022 05:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657087101;
        bh=x5rdNaA7jxDXFflwQxwmKDOgRnnU8SdteU9MiDOP+mU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GONWvW/bUf+5bM/x3TOItlAGDjJl/YXD0eLmvYki8dcUsPtkZoQNa+ipnArq3v4l/
         XJRGDjrU1FlEk/sHspRfADeLSEs3C4sLK9Il612wZQ9/YXY2eiEupFfepElS2Ud5eU
         iT4qwIKKvZgBjETDft+CcNwo7plf1nKwoDcn8RGYN5nWCkB/60KnlFH9axFNnznsQO
         xan8uKsDz9kkXu4n1WmM2Z6b+5c86K/2TL4RxedrTrxpV5E0SPo10iV18BPVuobT/q
         io0DSgoq1+lBnIwPt1Re+avRaCVMST2FSN7mKy2tPaxsO9vTznzis/qmtLw3ISo/k/
         aM+2//10G/iXQ==
Date:   Wed, 6 Jul 2022 11:28:17 +0530
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
Subject: Re: [PATCH v4] dmaengine: mxs: fix driver registering
Message-ID: <YsUkeWXkZhrOrc8h@matsya>
References: <20220621123659.1329854-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220621123659.1329854-1-dario.binacchi@amarulasolutions.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21-06-22, 14:36, Dario Binacchi wrote:
> Driver registration fails on SOC imx8mn as its supplier, the clock
> control module, is not ready. Since platform_driver_probe(), as
> reported by its description, is incompatible with deferred probing,
> we have to use platform_driver_register().

Pls revise title to reflect the changes added and not the effect

Btw lots of driver work like this, they use platform_driver_probe() but
make the clk and other resources do earlier init levels. This change is
fine too...

> The addition of the `_probe' suffix to the `mxs_dma_driver' variable was
> suggested by the following modpost warning:
> 
> WARNING: modpost: vmlinux.o(.data+0xa3900): Section mismatch in reference from the variable mxs_dma_driver to the function .init.text:mxs_dma_probe()
> The variable mxs_dma_driver references
> the function __init mxs_dma_probe()
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the variable:
> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

that should be always a separate patch

> 
> Fixes: a580b8c5429a ("dmaengine: mxs-dma: add dma support for i.MX23/28")
> Co-developed-by: Michael Trimarchi <michael@amarulasolutions.com>
> Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> Cc: stable@vger.kernel.org
> 
> ---
> 
> Changes in v4:
> - Restore __init in front of mxs_dma_probe() definition.
> - Rename the mxs_dma_driver variable to mxs_dma_driver_probe.
> - Update the commit message.
> - Use builtin_platform_driver() instead of module_platform_driver().
> 
> Changes in v3:
> - Restore __init in front of mxs_dma_init() definition.
> 
> Changes in v2:
> - Add the tag "Cc: stable@vger.kernel.org" in the sign-off area.
> 
>  drivers/dma/mxs-dma.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
> index 994fc4d2aca4..4c878bf1e092 100644
> --- a/drivers/dma/mxs-dma.c
> +++ b/drivers/dma/mxs-dma.c
> @@ -834,15 +834,11 @@ static int __init mxs_dma_probe(struct platform_device *pdev)
>  	return 0;
>  }
>  
> -static struct platform_driver mxs_dma_driver = {
> +static struct platform_driver mxs_dma_driver_probe = {
>  	.driver		= {
>  		.name	= "mxs-dma",
>  		.of_match_table = mxs_dma_dt_ids,
>  	},
> +	.probe = mxs_dma_probe,
>  };
> -
> -static int __init mxs_dma_module_init(void)
> -{
> -	return platform_driver_probe(&mxs_dma_driver, mxs_dma_probe);
> -}
> -subsys_initcall(mxs_dma_module_init);
> +builtin_platform_driver(mxs_dma_driver_probe);
> -- 
> 2.32.0

-- 
~Vinod
