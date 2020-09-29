Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20BE327BD08
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 08:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgI2GWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 02:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727350AbgI2GWW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 02:22:22 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA56C0613D0
        for <stable@vger.kernel.org>; Mon, 28 Sep 2020 23:22:21 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1kN91k-0005Qj-Js; Tue, 29 Sep 2020 08:22:16 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1kN91k-0006OL-AN; Tue, 29 Sep 2020 08:22:16 +0200
Date:   Tue, 29 Sep 2020 08:22:16 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.8 28/29] spi: fsl-dspi: fix use-after-free in
 remove path
Message-ID: <20200929062216.GL11648@pengutronix.de>
References: <20200929013027.2406344-1-sashal@kernel.org>
 <20200929013027.2406344-28-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929013027.2406344-28-sashal@kernel.org>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:20:02 up 222 days, 13:50, 130 users,  load average: 0.00, 0.10,
 0.15
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Mon, Sep 28, 2020 at 09:30:25PM -0400, Sasha Levin wrote:
> From: Sascha Hauer <s.hauer@pengutronix.de>
> 
> [ Upstream commit 530b5affc675ade5db4a03f04ed7cd66806c8a1a ]
> 
> spi_unregister_controller() not only unregisters the controller, but
> also frees the controller. This will free the driver data with it, so
> we must not access it later dspi_remove().
> 
> Solve this by allocating the driver data separately from the SPI
> controller.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Link: https://lore.kernel.org/r/20200923131026.20707-1-s.hauer@pengutronix.de
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/spi/spi-fsl-dspi.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)

This patch causes a regression and shouldn't be applied without the fix
in https://lkml.org/lkml/2020/9/28/300.

Sascha

> index 91c6affe139c9..aae9f9a7aea6c 100644
> --- a/drivers/spi/spi-fsl-dspi.c
> +++ b/drivers/spi/spi-fsl-dspi.c
> @@ -1273,11 +1273,14 @@ static int dspi_probe(struct platform_device *pdev)
>  	void __iomem *base;
>  	bool big_endian;
>  
> -	ctlr = spi_alloc_master(&pdev->dev, sizeof(struct fsl_dspi));
> +	dspi = devm_kzalloc(&pdev->dev, sizeof(*dspi), GFP_KERNEL);
> +	if (!dspi)
> +		return -ENOMEM;
> +
> +	ctlr = spi_alloc_master(&pdev->dev, 0);
>  	if (!ctlr)
>  		return -ENOMEM;
>  
> -	dspi = spi_controller_get_devdata(ctlr);
>  	dspi->pdev = pdev;
>  	dspi->ctlr = ctlr;
>  
> @@ -1414,7 +1417,7 @@ static int dspi_probe(struct platform_device *pdev)
>  	if (dspi->devtype_data->trans_mode != DSPI_DMA_MODE)
>  		ctlr->ptp_sts_supported = true;
>  
> -	platform_set_drvdata(pdev, ctlr);
> +	platform_set_drvdata(pdev, dspi);
>  
>  	ret = spi_register_controller(ctlr);
>  	if (ret != 0) {
> @@ -1437,8 +1440,7 @@ static int dspi_probe(struct platform_device *pdev)
>  
>  static int dspi_remove(struct platform_device *pdev)
>  {
> -	struct spi_controller *ctlr = platform_get_drvdata(pdev);
> -	struct fsl_dspi *dspi = spi_controller_get_devdata(ctlr);
> +	struct fsl_dspi *dspi = platform_get_drvdata(pdev);
>  
>  	/* Disconnect from the SPI framework */
>  	spi_unregister_controller(dspi->ctlr);
> -- 
> 2.25.1
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
