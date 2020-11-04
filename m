Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6212A2A70AA
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 23:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732243AbgKDWjI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 17:39:08 -0500
Received: from mslow2.mail.gandi.net ([217.70.178.242]:33450 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728085AbgKDWjI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 17:39:08 -0500
Received: from relay4-d.mail.gandi.net (unknown [217.70.183.196])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id EE4E53A6964;
        Wed,  4 Nov 2020 22:30:20 +0000 (UTC)
Received: from webmail.gandi.net (webmail15.sd4.0x35.net [10.200.201.15])
        (Authenticated sender: contact@artur-rojek.eu)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPA id 983E1E0006;
        Wed,  4 Nov 2020 22:29:58 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 04 Nov 2020 23:29:58 +0100
From:   Artur Rojek <contact@artur-rojek.eu>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>, od@zcrc.me,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] iio/adc: ingenic: Fix battery VREF for JZ4770 SoC
In-Reply-To: <20201104192843.67187-1-paul@crapouillou.net>
References: <20201104192843.67187-1-paul@crapouillou.net>
Message-ID: <cb8b8ff426500db61c61b51413f3746c@artur-rojek.eu>
X-Sender: contact@artur-rojek.eu
User-Agent: Roundcube Webmail/1.3.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Paul,

On 2020-11-04 20:28, Paul Cercueil wrote:
> The reference voltage for the battery is clearly marked as 1.2V in the
> programming manual. With this fixed, the battery channel now returns
> correct values.
> 
> Fixes: a515d6488505 ("IIO: Ingenic JZ47xx: Add support for JZ4770 SoC 
> ADC.")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> ---
>  drivers/iio/adc/ingenic-adc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iio/adc/ingenic-adc.c 
> b/drivers/iio/adc/ingenic-adc.c
> index ecaff6a9b716..19b95905a45c 100644
> --- a/drivers/iio/adc/ingenic-adc.c
> +++ b/drivers/iio/adc/ingenic-adc.c
> @@ -71,7 +71,7 @@
>  #define JZ4725B_ADC_BATTERY_HIGH_VREF_BITS	10
>  #define JZ4740_ADC_BATTERY_HIGH_VREF		(7500 * 0.986)
>  #define JZ4740_ADC_BATTERY_HIGH_VREF_BITS	12
> -#define JZ4770_ADC_BATTERY_VREF			6600
> +#define JZ4770_ADC_BATTERY_VREF			1200
>  #define JZ4770_ADC_BATTERY_VREF_BITS		12
> 
>  #define JZ_ADC_IRQ_AUX			BIT(0)

I thought we set it to 6600 because GCW Zero was not showing correct 
battery values at 1200.
But if you verified that 1200 works with JZ4770, then:
Acked-by: Artur Rojek <contact@artur-rojek.eu>
