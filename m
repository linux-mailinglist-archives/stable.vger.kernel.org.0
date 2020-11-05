Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F07C2A73A1
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 01:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728966AbgKEAJb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 4 Nov 2020 19:09:31 -0500
Received: from aposti.net ([89.234.176.197]:50840 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728323AbgKEAJb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Nov 2020 19:09:31 -0500
Date:   Thu, 05 Nov 2020 00:09:15 +0000
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [PATCH] iio/adc: ingenic: Fix battery VREF for JZ4770 SoC
To:     Artur Rojek <contact@artur-rojek.eu>
Cc:     Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>, od@zcrc.me,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Message-Id: <F3RAJQ.DZODDTV09KM21@crapouillou.net>
In-Reply-To: <cb8b8ff426500db61c61b51413f3746c@artur-rojek.eu>
References: <20201104192843.67187-1-paul@crapouillou.net>
        <cb8b8ff426500db61c61b51413f3746c@artur-rojek.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Artur,

Le mer. 4 nov. 2020 à 23:29, Artur Rojek <contact@artur-rojek.eu> a 
écrit :
> Hi Paul,
> 
> On 2020-11-04 20:28, Paul Cercueil wrote:
>> The reference voltage for the battery is clearly marked as 1.2V in 
>> the
>> programming manual. With this fixed, the battery channel now returns
>> correct values.
>> 
>> Fixes: a515d6488505 ("IIO: Ingenic JZ47xx: Add support for JZ4770 
>> SoC ADC.")
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
>> ---
>>  drivers/iio/adc/ingenic-adc.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/drivers/iio/adc/ingenic-adc.c 
>> b/drivers/iio/adc/ingenic-adc.c
>> index ecaff6a9b716..19b95905a45c 100644
>> --- a/drivers/iio/adc/ingenic-adc.c
>> +++ b/drivers/iio/adc/ingenic-adc.c
>> @@ -71,7 +71,7 @@
>>  #define JZ4725B_ADC_BATTERY_HIGH_VREF_BITS	10
>>  #define JZ4740_ADC_BATTERY_HIGH_VREF		(7500 * 0.986)
>>  #define JZ4740_ADC_BATTERY_HIGH_VREF_BITS	12
>> -#define JZ4770_ADC_BATTERY_VREF			6600
>> +#define JZ4770_ADC_BATTERY_VREF			1200
>>  #define JZ4770_ADC_BATTERY_VREF_BITS		12
>> 
>>  #define JZ_ADC_IRQ_AUX			BIT(0)
> 
> I thought we set it to 6600 because GCW Zero was not showing correct 
> battery values at 1200.
> But if you verified that 1200 works with JZ4770, then:
> Acked-by: Artur Rojek <contact@artur-rojek.eu>

Yes, IIRC we were trying to figure out the range and settled with 
[-3.3V,+3.3V] since it would give "plausible" values but which were 
never quite right. The doc does say that the voltage is (hw_val / 4096) 
* 1.2V, but also says that the ADC operated with 3.3V power supply, I 
guess we got confused. We never considered the battery could not be 
connected directly to the ADC's VBAT pin, so a 1.2V reference didn't 
make sense at that time. I guess we need to learn about electronics :)

It turns out the battery is connected to the VBAT pin with a 1 MOhm 
resistor, and the VBAT pin is also pulled low with a 332 kOhm resistor. 
So a fully charged battery with 4.2V reads as (4.2V * 332000) / 
(1332000) = 1.05V, which totally fits in a [0V,+1.2V] range.

With that same 4.2V battery I get a hardware value of about 3584, and 
(3584 / 4096) * 1.2V == 1.05V, which matches the value computed above. 
So the battery reading looks accurate this time.

Cheers,
-Paul


