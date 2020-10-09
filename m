Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0DF12883FA
	for <lists+stable@lfdr.de>; Fri,  9 Oct 2020 09:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732406AbgJIHxq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 03:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729278AbgJIHxq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Oct 2020 03:53:46 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2D9C0613D4
        for <stable@vger.kernel.org>; Fri,  9 Oct 2020 00:53:46 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kQnDc-0002nC-33; Fri, 09 Oct 2020 09:53:36 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kQnDb-0000D2-KW; Fri, 09 Oct 2020 09:53:35 +0200
Date:   Fri, 9 Oct 2020 09:53:35 +0200
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
Subject: Re: [PATCH v5 2/3] i2c: imx: Check for I2SR_IAL after every byte
Message-ID: <20201009075335.GC817@pengutronix.de>
References: <20201007084524.10835-1-ceggers@arri.de>
 <20201007084524.10835-3-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201007084524.10835-3-ceggers@arri.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:53:03 up 35 days, 22:00, 231 users,  load average: 0.34, 1.03,
 4.32
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 07, 2020 at 10:45:23AM +0200, Christian Eggers wrote:
> Arbitration Lost (IAL) can happen after every single byte transfer. If
> arbitration is lost, the I2C hardware will autonomously switch from
> master mode to slave. If a transfer is not aborted in this state,
> consecutive transfers will not be executed by the hardware and will
> timeout.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Tested (not extensively) on Vybrid VF500 (Toradex VF50):
> Tested-by: Krzysztof Kozlowski <krzk@kernel.org>
> Cc: stable@vger.kernel.org

Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>

Thank you!

> ---
>  drivers/i2c/busses/i2c-imx.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
> index cbdcab73a055..63575af41c09 100644
> --- a/drivers/i2c/busses/i2c-imx.c
> +++ b/drivers/i2c/busses/i2c-imx.c
> @@ -490,6 +490,16 @@ static int i2c_imx_trx_complete(struct imx_i2c_struct *i2c_imx, bool atomic)
>  		dev_dbg(&i2c_imx->adapter.dev, "<%s> Timeout\n", __func__);
>  		return -ETIMEDOUT;
>  	}
> +
> +	/* check for arbitration lost */
> +	if (i2c_imx->i2csr & I2SR_IAL) {
> +		dev_dbg(&i2c_imx->adapter.dev, "<%s> Arbitration lost\n", __func__);
> +		i2c_imx_clear_irq(i2c_imx, I2SR_IAL);
> +
> +		i2c_imx->i2csr = 0;
> +		return -EAGAIN;
> +	}
> +
>  	dev_dbg(&i2c_imx->adapter.dev, "<%s> TRX complete\n", __func__);
>  	i2c_imx->i2csr = 0;
>  	return 0;
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
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
