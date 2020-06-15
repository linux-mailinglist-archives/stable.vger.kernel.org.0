Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A88431F9133
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 10:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728863AbgFOIRV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 04:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728961AbgFOIRU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 04:17:20 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316D8C061A0E
        for <stable@vger.kernel.org>; Mon, 15 Jun 2020 01:17:20 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1jkkIq-0001Tu-Rk; Mon, 15 Jun 2020 10:17:12 +0200
Received: from [IPv6:2a03:f580:87bc:d400:21d2:558:c34a:b7bf] (unknown [IPv6:2a03:f580:87bc:d400:21d2:558:c34a:b7bf])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id CD84A5163FC;
        Mon, 15 Jun 2020 08:17:10 +0000 (UTC)
Subject: Re: [PATCH v2 1/3] spi: spi-fsl-dspi: Fix external abort on interrupt
 in exit paths
To:     Krzysztof Kozlowski <krzk@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Wolfram Sang <wsa@kernel.org>, stable@vger.kernel.org,
        kernel@pengutronix.de
References: <1592208439-17594-1-git-send-email-krzk@kernel.org>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 mQINBFFVq30BEACtnSvtXHoeHJxG6nRULcvlkW6RuNwHKmrqoksispp43X8+nwqIFYgb8UaX
 zu8T6kZP2wEIpM9RjEL3jdBjZNCsjSS6x1qzpc2+2ivjdiJsqeaagIgvy2JWy7vUa4/PyGfx
 QyUeXOxdj59DvLwAx8I6hOgeHx2X/ntKAMUxwawYfPZpP3gwTNKc27dJWSomOLgp+gbmOmgc
 6U5KwhAxPTEb3CsT5RicsC+uQQFumdl5I6XS+pbeXZndXwnj5t84M+HEj7RN6bUfV2WZO/AB
 Xt5+qFkC/AVUcj/dcHvZwQJlGeZxoi4veCoOT2MYqfR0ax1MmN+LVRvKm29oSyD4Ts/97cbs
 XsZDRxnEG3z/7Winiv0ZanclA7v7CQwrzsbpCv+oj+zokGuKasofzKdpywkjAfSE1zTyF+8K
 nxBAmzwEqeQ3iKqBc3AcCseqSPX53mPqmwvNVS2GqBpnOfY7Mxr1AEmxdEcRYbhG6Xdn+ACq
 Dq0Db3A++3PhMSaOu125uIAIwMXRJIzCXYSqXo8NIeo9tobk0C/9w3fUfMTrBDtSviLHqlp8
 eQEP8+TDSmRP/CwmFHv36jd+XGmBHzW5I7qw0OORRwNFYBeEuiOIgxAfjjbLGHh9SRwEqXAL
 kw+WVTwh0MN1k7I9/CDVlGvc3yIKS0sA+wudYiselXzgLuP5cQARAQABtCZNYXJjIEtsZWlu
 ZS1CdWRkZSA8bWtsQHBlbmd1dHJvbml4LmRlPokCVAQTAQoAPgIbAwIeAQIXgAULCQgHAwUV
 CgkICwUWAgMBABYhBMFAC6CzmJ5vvH1bXCte4hHFiupUBQJcUsSbBQkM366zAAoJECte4hHF
 iupUgkAP/2RdxKPZ3GMqag33jKwKAbn/fRqAFWqUH9TCsRH3h6+/uEPnZdzhkL4a9p/6OeJn
 Z6NXqgsyRAOTZsSFcwlfxLNHVxBWm8pMwrBecdt4lzrjSt/3ws2GqxPsmza1Gs61lEdYvLST
 Ix2vPbB4FAfE0kizKAjRZzlwOyuHOr2ilujDsKTpFtd8lV1nBNNn6HBIBR5ShvJnwyUdzuby
 tOsSt7qJEvF1x3y49bHCy3uy+MmYuoEyG6zo9udUzhVsKe3hHYC2kfB16ZOBjFC3lH2U5An+
 yQYIIPZrSWXUeKjeMaKGvbg6W9Oi4XEtrwpzUGhbewxCZZCIrzAH2hz0dUhacxB201Y/faY6
 BdTS75SPs+zjTYo8yE9Y9eG7x/lB60nQjJiZVNvZ88QDfVuLl/heuIq+fyNajBbqbtBT5CWf
 mOP4Dh4xjm3Vwlz8imWW/drEVJZJrPYqv0HdPbY8jVMpqoe5jDloyVn3prfLdXSbKPexlJaW
 5tnPd4lj8rqOFShRnLFCibpeHWIumqrIqIkiRA9kFW3XMgtU6JkIrQzhJb6Tc6mZg2wuYW0d
 Wo2qvdziMgPkMFiWJpsxM9xPk9BBVwR+uojNq5LzdCsXQ2seG0dhaOTaaIDWVS8U/V8Nqjrl
 6bGG2quo5YzJuXKjtKjZ4R6k762pHJ3tnzI/jnlc1sXz
Message-ID: <e1f0326c-8ae8-ffb3-aace-10433b0c78a6@pengutronix.de>
Date:   Mon, 15 Jun 2020 10:17:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1592208439-17594-1-git-send-email-krzk@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/15/20 10:07 AM, Krzysztof Kozlowski wrote:
> If interrupt comes late, during probe error path or device remove (could
> be triggered with CONFIG_DEBUG_SHIRQ), the interrupt handler
> dspi_interrupt() will access registers with the clock being disabled.  This
> leads to external abort on non-linefetch on Toradex Colibri VF50 module
> (with Vybrid VF5xx):
> 
>     $ echo 4002d000.spi > /sys/devices/platform/soc/40000000.bus/4002d000.spi/driver/unbind
> 
>     Unhandled fault: external abort on non-linefetch (0x1008) at 0x8887f02c
>     Internal error: : 1008 [#1] ARM
>     CPU: 0 PID: 136 Comm: sh Not tainted 5.7.0-next-20200610-00009-g5c913fa0f9c5-dirty #74
>     Hardware name: Freescale Vybrid VF5xx/VF6xx (Device Tree)
>       (regmap_mmio_read32le) from [<8061885c>] (regmap_mmio_read+0x48/0x68)
>       (regmap_mmio_read) from [<8060e3b8>] (_regmap_bus_reg_read+0x24/0x28)
>       (_regmap_bus_reg_read) from [<80611c50>] (_regmap_read+0x70/0x1c0)
>       (_regmap_read) from [<80611dec>] (regmap_read+0x4c/0x6c)
>       (regmap_read) from [<80678ca0>] (dspi_interrupt+0x3c/0xa8)
>       (dspi_interrupt) from [<8017acec>] (free_irq+0x26c/0x3cc)
>       (free_irq) from [<8017dcec>] (devm_irq_release+0x1c/0x20)
>       (devm_irq_release) from [<805f98ec>] (release_nodes+0x1e4/0x298)
>       (release_nodes) from [<805f9ac8>] (devres_release_all+0x40/0x60)
>       (devres_release_all) from [<805f5134>] (device_release_driver_internal+0x108/0x1ac)
>       (device_release_driver_internal) from [<805f521c>] (device_driver_detach+0x20/0x24)
> 
> Fixes: 349ad66c0ab0 ("spi:Add Freescale DSPI driver for Vybrid VF610 platform")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> 
> ---
> 
> This is an follow up of my other patch for I2C IMX driver [1]. Let's fix the
> issues consistently.
> 
> [1] https://lore.kernel.org/lkml/1592130544-19759-2-git-send-email-krzk@kernel.org/T/#u
> 
> Changes since v1:
> 1. Disable the IRQ instead of using non-devm interface.
> ---
>  drivers/spi/spi-fsl-dspi.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
> index 58190c94561f..023e05c53b85 100644
> --- a/drivers/spi/spi-fsl-dspi.c
> +++ b/drivers/spi/spi-fsl-dspi.c
> @@ -1400,7 +1400,7 @@ static int dspi_probe(struct platform_device *pdev)
>  		ret = dspi_request_dma(dspi, res->start);
>  		if (ret < 0) {
>  			dev_err(&pdev->dev, "can't get dma channels\n");
> -			goto out_clk_put;
> +			goto disable_irq;
>  		}
>  	}
>  
> @@ -1415,11 +1415,14 @@ static int dspi_probe(struct platform_device *pdev)
>  	ret = spi_register_controller(ctlr);
>  	if (ret != 0) {
>  		dev_err(&pdev->dev, "Problem registering DSPI ctlr\n");
> -		goto out_clk_put;
> +		goto disable_irq;
>  	}
>  
>  	return ret;
>  
> +disable_irq:
> +	if (dspi->irq > 0)
> +		disable_irq(dspi->irq);
>  out_clk_put:
>  	clk_disable_unprepare(dspi->clk);
>  out_ctlr_put:
> @@ -1435,6 +1438,8 @@ static int dspi_remove(struct platform_device *pdev)
>  
>  	/* Disconnect from the SPI framework */
>  	dspi_release_dma(dspi);
> +	if (dspi->irq > 0)
> +		disable_irq(dspi->irq);

What happens, if you re-bind the driver?
Is the IRQ still working?
Who is taking care of calling the enable_irq() again?
What happens, if you really have a shared IRQ line?
Is the IRQ disabled for all other devices on the same IRQ line?

>  	clk_disable_unprepare(dspi->clk);
>  	spi_unregister_controller(dspi->ctlr);
>  
> 
Marc

-- 
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
