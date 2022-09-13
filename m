Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 104A55B785C
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 19:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233484AbiIMRmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 13:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233448AbiIMRl6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 13:41:58 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392186AA1E
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 09:35:20 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1oY8sR-0000Ue-O1; Tue, 13 Sep 2022 18:35:11 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1oY8sQ-0005qY-Nl; Tue, 13 Sep 2022 18:35:10 +0200
Date:   Tue, 13 Sep 2022 18:35:10 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org, linux-amarula@amarulasolutions.com,
        Michael Trimarchi <michael@amarulasolutions.com>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RESEND PATCH v5 1/2] dmaengine: mxs: use
 platform_driver_register
Message-ID: <20220913163510.GR6477@pengutronix.de>
References: <20220904141020.2947725-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220904141020.2947725-1-dario.binacchi@amarulasolutions.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Dario,

On Sun, Sep 04, 2022 at 04:10:19PM +0200, Dario Binacchi wrote:
> Driver registration fails on SOC imx8mn as its supplier, the clock
> control module, is probed later than subsys initcall level. This driver
> uses platform_driver_probe which is not compatible with deferred probing
> and won't be probed again later if probe function fails due to clock not
> being available at that time.
> 
> This patch replaces the use of platform_driver_probe with
> platform_driver_register which will allow probing the driver later again
> when the clock control module will be available.
> 
> Fixes: a580b8c5429a ("dmaengine: mxs-dma: add dma support for i.MX23/28")
> Co-developed-by: Michael Trimarchi <michael@amarulasolutions.com>
> Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> Cc: stable@vger.kernel.org

How I see it v3 of this patch is perfectly fine and should be taken
instead of this one. I just commented that to v3.

Not sure if Vinod would take v3, or if you should resend v3 as v6
instead. If you do, you can add my Acked-by.

Vinod, please let us know what you prefer.

Sascha

> 
> ---
> 
> Changes in v5:
> - Update the commit message.
> - Add the patch "dmaengine: mxs: fix section mismatch" to remove the
>   warning raised by this patch.
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
>  drivers/dma/mxs-dma.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
> index 994fc4d2aca4..18f8154b859b 100644
> --- a/drivers/dma/mxs-dma.c
> +++ b/drivers/dma/mxs-dma.c
> @@ -839,10 +839,6 @@ static struct platform_driver mxs_dma_driver = {
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
> +builtin_platform_driver(mxs_dma_driver);
> -- 
> 2.32.0
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
