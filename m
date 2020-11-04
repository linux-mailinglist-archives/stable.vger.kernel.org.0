Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A23072A7061
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 23:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731997AbgKDW1A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 17:27:00 -0500
Received: from mslow2.mail.gandi.net ([217.70.178.242]:46628 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728565AbgKDW06 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 17:26:58 -0500
Received: from relay4-d.mail.gandi.net (unknown [217.70.183.196])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id 122733A0782;
        Wed,  4 Nov 2020 22:25:36 +0000 (UTC)
Received: from webmail.gandi.net (webmail15.sd4.0x35.net [10.200.201.15])
        (Authenticated sender: contact@artur-rojek.eu)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPA id D427CE0006;
        Wed,  4 Nov 2020 22:25:12 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 04 Nov 2020 23:25:12 +0100
From:   Artur Rojek <contact@artur-rojek.eu>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>, od@zcrc.me,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] iio/adc: ingenic: Fix AUX/VBAT readings when touchscreen
 is used
In-Reply-To: <20201103201238.161083-1-paul@crapouillou.net>
References: <20201103201238.161083-1-paul@crapouillou.net>
Message-ID: <bbd87ebab678e3033545fef749c3b22a@artur-rojek.eu>
X-Sender: contact@artur-rojek.eu
User-Agent: Roundcube Webmail/1.3.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Paul,

On 2020-11-03 21:12, Paul Cercueil wrote:
> When the command feature of the ADC is used, it is possible to program
> the ADC, and specify at each step what input should be processed, and 
> in
> comparison to what reference.
> 
> This broke the AUX and battery readings when the touchscreen was
> enabled, most likely because the CMD feature would change the VREF all
> the time.
> 
> Now, when AUX or battery are read, we temporarily disable the CMD
> feature, which means that we won't get touchscreen readings in that 
> time
> frame. But it now gives correct values for AUX / battery, and the
> touchscreen isn't disabled for long enough to be an actual issue.
> 
> Fixes: b96952f498db ("IIO: Ingenic JZ47xx: Add touchscreen mode.")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> ---
>  drivers/iio/adc/ingenic-adc.c | 33 +++++++++++++++++++++++++++------
>  1 file changed, 27 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/iio/adc/ingenic-adc.c 
> b/drivers/iio/adc/ingenic-adc.c
> index 92b25083e23f..ecaff6a9b716 100644
> --- a/drivers/iio/adc/ingenic-adc.c
> +++ b/drivers/iio/adc/ingenic-adc.c
> @@ -177,13 +177,12 @@ static void ingenic_adc_set_config(struct
> ingenic_adc *adc,
>  	mutex_unlock(&adc->lock);
>  }
> 
> -static void ingenic_adc_enable(struct ingenic_adc *adc,
> -			       int engine,
> -			       bool enabled)
> +static void ingenic_adc_enable_unlocked(struct ingenic_adc *adc,
> +					int engine,
> +					bool enabled)
>  {
>  	u8 val;
> 
> -	mutex_lock(&adc->lock);
>  	val = readb(adc->base + JZ_ADC_REG_ENABLE);
> 
>  	if (enabled)
> @@ -192,20 +191,42 @@ static void ingenic_adc_enable(struct ingenic_adc 
> *adc,
>  		val &= ~BIT(engine);
> 
>  	writeb(val, adc->base + JZ_ADC_REG_ENABLE);
> +}
> +
> +static void ingenic_adc_enable(struct ingenic_adc *adc,
> +			       int engine,
> +			       bool enabled)
> +{
> +	mutex_lock(&adc->lock);
> +	ingenic_adc_enable_unlocked(adc, engine, enabled);
>  	mutex_unlock(&adc->lock);
>  }
> 
>  static int ingenic_adc_capture(struct ingenic_adc *adc,
>  			       int engine)
>  {
> +	u32 cfg;
>  	u8 val;
>  	int ret;
> 
> -	ingenic_adc_enable(adc, engine, true);
> +	/*
> +	 * Disable CMD_SEL temporarily, because it causes wrong VBAT 
> readings,
> +	 * probably due to the switch of VREF. We must keep the lock here to
> +	 * avoid races with the buffer enable/disable functions.
> +	 */
> +	mutex_lock(&adc->lock);
> +	cfg = readl(adc->base + JZ_ADC_REG_CFG);
> +	writel(cfg & ~JZ_ADC_REG_CFG_CMD_SEL, adc->base + JZ_ADC_REG_CFG);
> +
> +
Redundant empty line.
> +	ingenic_adc_enable_unlocked(adc, engine, true);
>  	ret = readb_poll_timeout(adc->base + JZ_ADC_REG_ENABLE, val,
>  				 !(val & BIT(engine)), 250, 1000);
>  	if (ret)
> -		ingenic_adc_enable(adc, engine, false);
> +		ingenic_adc_enable_unlocked(adc, engine, false);
> +
> +	writel(cfg, adc->base + JZ_ADC_REG_CFG);
> +	mutex_unlock(&adc->lock);
> 
>  	return ret;
>  }

With the above nitpick corrected:
Acked-by: Artur Rojek <contact@artur-rojek.eu>


