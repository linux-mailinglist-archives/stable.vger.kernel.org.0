Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE9CC2884FE
	for <lists+stable@lfdr.de>; Fri,  9 Oct 2020 10:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732522AbgJIIOp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 04:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732477AbgJIIOn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Oct 2020 04:14:43 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01CD6C0613D2
        for <stable@vger.kernel.org>; Fri,  9 Oct 2020 01:14:43 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kQnXn-0006kZ-A8; Fri, 09 Oct 2020 10:14:27 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kQnXl-00053q-Gt; Fri, 09 Oct 2020 10:14:25 +0200
Date:   Fri, 9 Oct 2020 10:14:25 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Oleksij Rempel <linux@rempel-privat.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v5 3/3] i2c: imx: Don't generate STOP condition if
 arbitration has been lost
Message-ID: <20201009081425.GD817@pengutronix.de>
References: <20201007084524.10835-1-ceggers@arri.de>
 <20201007084524.10835-4-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201007084524.10835-4-ceggers@arri.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:13:39 up 35 days, 22:21, 227 users,  load average: 10.92, 14.39,
 9.84
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 07, 2020 at 10:45:24AM +0200, Christian Eggers wrote:
> If arbitration is lost, the master automatically changes to slave mode.
> I2SR_IBB may or may not be reset by hardware. Raising a STOP condition
> by resetting I2CR_MSTA has no effect and will not clear I2SR_IBB.
> 
> So calling i2c_imx_bus_busy() is not required and would busy-wait until
> timeout.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Tested (not extensively) on Vybrid VF500 (Toradex VF50):
> Tested-by: Krzysztof Kozlowski <krzk@kernel.org>
> Cc: stable@vger.kernel.org # Requires trivial backporting, simple remove
>                            # the 3rd argument from the calls to
>                            # i2c_imx_bus_busy().

Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Thank you!


> ---
>  drivers/i2c/busses/i2c-imx.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
> index 63575af41c09..5d8a79319b2b 100644
> --- a/drivers/i2c/busses/i2c-imx.c
> +++ b/drivers/i2c/busses/i2c-imx.c
> @@ -615,6 +615,8 @@ static void i2c_imx_stop(struct imx_i2c_struct *i2c_imx, bool atomic)
>  		/* Stop I2C transaction */
>  		dev_dbg(&i2c_imx->adapter.dev, "<%s>\n", __func__);
>  		temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
> +		if (!(temp & I2CR_MSTA))
> +			i2c_imx->stopped = 1;
>  		temp &= ~(I2CR_MSTA | I2CR_MTX);
>  		if (i2c_imx->dma)
>  			temp &= ~I2CR_DMAEN;
> @@ -778,9 +780,12 @@ static int i2c_imx_dma_read(struct imx_i2c_struct *i2c_imx,
>  		 */
>  		dev_dbg(dev, "<%s> clear MSTA\n", __func__);
>  		temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
> +		if (!(temp & I2CR_MSTA))
> +			i2c_imx->stopped = 1;
>  		temp &= ~(I2CR_MSTA | I2CR_MTX);
>  		imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
> -		i2c_imx_bus_busy(i2c_imx, 0, false);
> +		if (!i2c_imx->stopped)
> +			i2c_imx_bus_busy(i2c_imx, 0, false);
>  	} else {
>  		/*
>  		 * For i2c master receiver repeat restart operation like:
> @@ -905,9 +910,12 @@ static int i2c_imx_read(struct imx_i2c_struct *i2c_imx, struct i2c_msg *msgs,
>  				dev_dbg(&i2c_imx->adapter.dev,
>  					"<%s> clear MSTA\n", __func__);
>  				temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
> +				if (!(temp & I2CR_MSTA))
> +					i2c_imx->stopped =  1;
>  				temp &= ~(I2CR_MSTA | I2CR_MTX);
>  				imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
> -				i2c_imx_bus_busy(i2c_imx, 0, atomic);
> +				if (!i2c_imx->stopped)
> +					i2c_imx_bus_busy(i2c_imx, 0, atomic);
>  			} else {
>  				/*
>  				 * For i2c master receiver repeat restart operation like:
> -- 
> Christian Eggers
> Embedded software developer
> 
> Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
> Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
> Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
> Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
> Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
