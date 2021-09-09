Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC99405B12
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 18:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238519AbhIIQnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 12:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238605AbhIIQnQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 12:43:16 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6154C061757
        for <stable@vger.kernel.org>; Thu,  9 Sep 2021 09:42:06 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=[IPv6:::1])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <l.stach@pengutronix.de>)
        id 1mON7j-0002Ju-Ae; Thu, 09 Sep 2021 18:42:03 +0200
Message-ID: <500c68753cac86d9b3021ddf1e8580779e685332.camel@pengutronix.de>
Subject: Re: [PATCH AUTOSEL 5.14 058/252] spi: imx: fix ERR009165
From:   Lucas Stach <l.stach@pengutronix.de>
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Robin Gong <yibin.gong@nxp.com>, Mark Brown <broonie@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date:   Thu, 09 Sep 2021 18:42:01 +0200
In-Reply-To: <20210909114106.141462-58-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
         <20210909114106.141462-58-sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

Am Donnerstag, dem 09.09.2021 um 07:37 -0400 schrieb Sasha Levin:
> From: Robin Gong <yibin.gong@nxp.com>
> 
> [ Upstream commit 980f884866eed4dda2a18de888c5a67dde67d640 ]
> 
> Change to XCH  mode even in dma mode, please refer to the below
> errata:
> https://www.nxp.com/docs/en/errata/IMX6DQCE.pdf
> 

This patch is part of a quite extensive series touching multiple
drivers and devicetree descriptions and will do more harm than good if
backported without the rest of the series. The options here are:
a) backport the entire series (this will most likely not match the
stable criteria)
b) drop the patch from the stable queue

Regards,
Lucas

> Signed-off-by: Robin Gong <yibin.gong@nxp.com>
> Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
> Acked-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Shawn Guo <shawnguo@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/spi/spi-imx.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
> index fa68e9817929..d89b11205815 100644
> --- a/drivers/spi/spi-imx.c
> +++ b/drivers/spi/spi-imx.c
> @@ -622,8 +622,8 @@ static int mx51_ecspi_prepare_transfer(struct spi_imx_data *spi_imx,
>  	ctrl |= mx51_ecspi_clkdiv(spi_imx, spi_imx->spi_bus_clk, &clk);
>  	spi_imx->spi_bus_clk = clk;
>  
> -	if (spi_imx->usedma)
> -		ctrl |= MX51_ECSPI_CTRL_SMC;
> +	/* ERR009165: work in XHC mode as PIO */
> +	ctrl &= ~MX51_ECSPI_CTRL_SMC;
>  
>  	writel(ctrl, spi_imx->base + MX51_ECSPI_CTRL);
>  
> @@ -637,7 +637,7 @@ static void mx51_setup_wml(struct spi_imx_data *spi_imx)
>  	 * and enable DMA request.
>  	 */
>  	writel(MX51_ECSPI_DMA_RX_WML(spi_imx->wml - 1) |
> -		MX51_ECSPI_DMA_TX_WML(spi_imx->wml) |
> +		MX51_ECSPI_DMA_TX_WML(0) |
>  		MX51_ECSPI_DMA_RXT_WML(spi_imx->wml) |
>  		MX51_ECSPI_DMA_TEDEN | MX51_ECSPI_DMA_RXDEN |
>  		MX51_ECSPI_DMA_RXTDEN, spi_imx->base + MX51_ECSPI_DMA);
> @@ -1253,10 +1253,6 @@ static int spi_imx_sdma_init(struct device *dev, struct spi_imx_data *spi_imx,
>  {
>  	int ret;
>  
> -	/* use pio mode for i.mx6dl chip TKT238285 */
> -	if (of_machine_is_compatible("fsl,imx6dl"))
> -		return 0;
> -
>  	spi_imx->wml = spi_imx->devtype_data->fifo_size / 2;
>  
>  	/* Prepare for TX DMA: */


