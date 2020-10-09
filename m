Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158D42883F5
	for <lists+stable@lfdr.de>; Fri,  9 Oct 2020 09:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732386AbgJIHwq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 9 Oct 2020 03:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732325AbgJIHwn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Oct 2020 03:52:43 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E669DC0613D2
        for <stable@vger.kernel.org>; Fri,  9 Oct 2020 00:52:42 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kQnCY-0002Xm-HD; Fri, 09 Oct 2020 09:52:30 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kQnCW-0000CR-LS; Fri, 09 Oct 2020 09:52:28 +0200
Date:   Fri, 9 Oct 2020 09:52:28 +0200
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
Subject: Re: [PATCH v5 1/3] i2c: imx: Fix reset of I2SR_IAL flag
Message-ID: <20201009075228.GB817@pengutronix.de>
References: <20201007084524.10835-1-ceggers@arri.de>
 <20201007084524.10835-2-ceggers@arri.de>
 <20201009071132.GA817@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20201009071132.GA817@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:48:09 up 35 days, 21:55, 230 users,  load average: 2.27, 1.77,
 5.72
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 09, 2020 at 09:11:32AM +0200, Oleksij Rempel wrote:
> Hi Christian,
> 
> On Wed, Oct 07, 2020 at 10:45:22AM +0200, Christian Eggers wrote:
> > According to the "VFxxx Controller Reference Manual" (and the comment
> > block starting at line 97), Vybrid requires writing a one for clearing
> > an interrupt flag. Syncing the method for clearing I2SR_IIF in
> > i2c_imx_isr().
> > 
> > Signed-off-by: Christian Eggers <ceggers@arri.de>
> > Fixes: 4b775022f6fd ("i2c: imx: add struct to hold more configurable quirks")
> > Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > Cc: stable@vger.kernel.org
> > ---
> >  drivers/i2c/busses/i2c-imx.c | 20 +++++++++++++++-----
> >  1 file changed, 15 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
> > index 0ab5381aa012..cbdcab73a055 100644
> > --- a/drivers/i2c/busses/i2c-imx.c
> > +++ b/drivers/i2c/busses/i2c-imx.c
> > @@ -412,6 +412,19 @@ static void i2c_imx_dma_free(struct imx_i2c_struct *i2c_imx)
> >  	dma->chan_using = NULL;
> >  }
> >  
> > +static void i2c_imx_clear_irq(struct imx_i2c_struct *i2c_imx, unsigned int bits)
> > +{
> > +	unsigned int temp;
> > +
> > +	/*
> > +	 * i2sr_clr_opcode is the value to clear all interrupts. Here we want to
> > +	 * clear only <bits>, so we write ~i2sr_clr_opcode with just <bits>
> > +	 * toggled. This is required because i.MX needs W1C and Vybrid uses W0C.
> > +	 */
> 
> This comment need correction. The i.MX needs W0C and Vybrid uses W1C 
> 
> > +	temp = ~i2c_imx->hwdata->i2sr_clr_opcode ^ bits;
> > +	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2SR);
> > +}
> > +
> >  static int i2c_imx_bus_busy(struct imx_i2c_struct *i2c_imx, int for_busy, bool atomic)
> >  {
> >  	unsigned long orig_jiffies = jiffies;
> > @@ -424,8 +437,7 @@ static int i2c_imx_bus_busy(struct imx_i2c_struct *i2c_imx, int for_busy, bool a
> >  
> >  		/* check for arbitration lost */
> >  		if (temp & I2SR_IAL) {
> > -			temp &= ~I2SR_IAL;
> > -			imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2SR);
> > +			i2c_imx_clear_irq(i2c_imx, I2SR_IAL);
> >  			return -EAGAIN;
> >  		}
> >  
> > @@ -623,9 +635,7 @@ static irqreturn_t i2c_imx_isr(int irq, void *dev_id)
> >  	if (temp & I2SR_IIF) {
> >  		/* save status register */
> >  		i2c_imx->i2csr = temp;
> > -		temp &= ~I2SR_IIF;
> > -		temp |= (i2c_imx->hwdata->i2sr_clr_opcode & I2SR_IIF);
> > -		imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2SR);
> > +		i2c_imx_clear_irq(i2c_imx, I2SR_IIF);
> >  		wake_up(&i2c_imx->queue);
> >  		return IRQ_HANDLED;
> >  	}
> > -- 
> 
> Otherwise
> 
> Acked-by: Oleksij Rempel <o.rempel@pengutronix.de> 

By reviewing the second patch we found at least one more missing Vybrid
related case in the i2c_imx_trx_complete() function:
	imx_i2c_write_reg(0, i2c_imx, IMX_I2C_I2SR);

	this is OK for iMX by broken on Vybrid.

Since you already fixing it in this patch for some of IMX_I2C_I2SR
writes, please do it here as well. This is the last unhandled case...:)

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
