Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7672AABF4
	for <lists+stable@lfdr.de>; Sun,  8 Nov 2020 16:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbgKHPhV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Nov 2020 10:37:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:51930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727844AbgKHPhU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Nov 2020 10:37:20 -0500
Received: from archlinux (cpc149474-cmbg20-2-0-cust94.5-4.cable.virginm.net [82.4.196.95])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6252208B6;
        Sun,  8 Nov 2020 15:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604849840;
        bh=4xK2+N7SORguqSalVsYutFIB/McfZ2ALvWZwLhmL5Lo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=yqsR+OQmU5w5ZsE1S2JW82JTxIqhNJsAVmtfeTVFFIOX0AB8bNDMFdS290r2vIQvH
         1FjyfcAIwUFxw7igvqF05xft7p2IFMyp7chkifaEUk2BjGEgOizEOnVz218sQPbCKo
         W6b6zxSCjMpC+b4BUgSfHxuzV41trhCg2Vl3YNDg=
Date:   Sun, 8 Nov 2020 15:37:15 +0000
From:   Jonathan Cameron <jic23@kernel.org>
To:     Artur Rojek <contact@artur-rojek.eu>
Cc:     Paul Cercueil <paul@crapouillou.net>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>, od@zcrc.me,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] iio/adc: ingenic: Fix AUX/VBAT readings when
 touchscreen is used
Message-ID: <20201108153715.334bd5e1@archlinux>
In-Reply-To: <bbd87ebab678e3033545fef749c3b22a@artur-rojek.eu>
References: <20201103201238.161083-1-paul@crapouillou.net>
        <bbd87ebab678e3033545fef749c3b22a@artur-rojek.eu>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 04 Nov 2020 23:25:12 +0100
Artur Rojek <contact@artur-rojek.eu> wrote:

> Hi Paul,
> 
> On 2020-11-03 21:12, Paul Cercueil wrote:
> > When the command feature of the ADC is used, it is possible to program
> > the ADC, and specify at each step what input should be processed, and 
> > in
> > comparison to what reference.
> > 
> > This broke the AUX and battery readings when the touchscreen was
> > enabled, most likely because the CMD feature would change the VREF all
> > the time.
> > 
> > Now, when AUX or battery are read, we temporarily disable the CMD
> > feature, which means that we won't get touchscreen readings in that 
> > time
> > frame. But it now gives correct values for AUX / battery, and the
> > touchscreen isn't disabled for long enough to be an actual issue.
> > 
> > Fixes: b96952f498db ("IIO: Ingenic JZ47xx: Add touchscreen mode.")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> > ---
> >  drivers/iio/adc/ingenic-adc.c | 33 +++++++++++++++++++++++++++------
> >  1 file changed, 27 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/iio/adc/ingenic-adc.c 
> > b/drivers/iio/adc/ingenic-adc.c
> > index 92b25083e23f..ecaff6a9b716 100644
> > --- a/drivers/iio/adc/ingenic-adc.c
> > +++ b/drivers/iio/adc/ingenic-adc.c
> > @@ -177,13 +177,12 @@ static void ingenic_adc_set_config(struct
> > ingenic_adc *adc,
> >  	mutex_unlock(&adc->lock);
> >  }
> > 
> > -static void ingenic_adc_enable(struct ingenic_adc *adc,
> > -			       int engine,
> > -			       bool enabled)
> > +static void ingenic_adc_enable_unlocked(struct ingenic_adc *adc,
> > +					int engine,
> > +					bool enabled)
> >  {
> >  	u8 val;
> > 
> > -	mutex_lock(&adc->lock);
> >  	val = readb(adc->base + JZ_ADC_REG_ENABLE);
> > 
> >  	if (enabled)
> > @@ -192,20 +191,42 @@ static void ingenic_adc_enable(struct ingenic_adc 
> > *adc,
> >  		val &= ~BIT(engine);
> > 
> >  	writeb(val, adc->base + JZ_ADC_REG_ENABLE);
> > +}
> > +
> > +static void ingenic_adc_enable(struct ingenic_adc *adc,
> > +			       int engine,
> > +			       bool enabled)
> > +{
> > +	mutex_lock(&adc->lock);
> > +	ingenic_adc_enable_unlocked(adc, engine, enabled);
> >  	mutex_unlock(&adc->lock);
> >  }
> > 
> >  static int ingenic_adc_capture(struct ingenic_adc *adc,
> >  			       int engine)
> >  {
> > +	u32 cfg;
> >  	u8 val;
> >  	int ret;
> > 
> > -	ingenic_adc_enable(adc, engine, true);
> > +	/*
> > +	 * Disable CMD_SEL temporarily, because it causes wrong VBAT 
> > readings,
> > +	 * probably due to the switch of VREF. We must keep the lock here to
> > +	 * avoid races with the buffer enable/disable functions.
> > +	 */
> > +	mutex_lock(&adc->lock);
> > +	cfg = readl(adc->base + JZ_ADC_REG_CFG);
> > +	writel(cfg & ~JZ_ADC_REG_CFG_CMD_SEL, adc->base + JZ_ADC_REG_CFG);
> > +
> > +  
> Redundant empty line.
> > +	ingenic_adc_enable_unlocked(adc, engine, true);
> >  	ret = readb_poll_timeout(adc->base + JZ_ADC_REG_ENABLE, val,
> >  				 !(val & BIT(engine)), 250, 1000);
> >  	if (ret)
> > -		ingenic_adc_enable(adc, engine, false);
> > +		ingenic_adc_enable_unlocked(adc, engine, false);
> > +
> > +	writel(cfg, adc->base + JZ_ADC_REG_CFG);
> > +	mutex_unlock(&adc->lock);
> > 
> >  	return ret;
> >  }  
> 
> With the above nitpick corrected:
> Acked-by: Artur Rojek <contact@artur-rojek.eu>
> 
fixed up whilst applying.

Applied to the fixes-togreg branch of iio.git.  Thanks,

Jonathan

> 

