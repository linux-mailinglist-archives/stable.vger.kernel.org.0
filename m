Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 642F398C84
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 09:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731632AbfHVHnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 03:43:53 -0400
Received: from mail.heine.tech ([195.201.24.99]:38346 "EHLO mail.heine.tech"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731487AbfHVHnx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 03:43:53 -0400
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: michael@nosthoff.rocks)
        by mail.heine.tech (Postcow) with ESMTPSA id A125C181B72;
        Thu, 22 Aug 2019 09:43:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heine.so; s=dkim;
        t=1566459828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LBF24kxs2y5CPdaTB3ix8su3zSYdd7TmiR9uR2m89lU=;
        b=nWHBaNObjJCf1C5QBo10CKMwIy6dLozT15lmiQuI58lUUfc/WJNJqFyjEUPMNfDxOEEhVE
        VpN0MO3sfPRE7+ypaTBp1ysrMoMZ1TxufLzZvANSRPuq+JO25fiGAL4DM4Ou/wFI4xNdXV
        Y7w8iu853U8h5h1Kv0wkwuIpIIyL3lM=
Message-ID: <5D5E47B1.70604@heine.so>
Date:   Thu, 22 Aug 2019 09:43:45 +0200
From:   Michael Nosthoff <committed@heine.so>
User-Agent: Postbox 5.0.25 (Macintosh/20180328)
MIME-Version: 1.0
To:     Brian Norris <briannorris@chromium.org>
CC:     linux-pm@vger.kernel.org, stable@vger.kernel.org, sre@kernel.org
Subject: Re: [PATCH] power: supply: sbs-battery: only return health when battery
 present
References: <20190816075842.27333-1-committed@heine.so> <20190822014655.GA165945@google.com>
In-Reply-To: <20190822014655.GA165945@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Brian Norris wrote:
> On Fri, Aug 16, 2019 at 09:58:42AM +0200, Michael Nosthoff wrote:
>> when the battery is set to sbs-mode and  no gpio detection is enabled
>> "health" is always returning a value even when the battery is not present.
>> All other fields return "not present".
>> This leads to a scenario where the driver is constantly switching between
>> "present" and "not present" state. This generates a lot of constant
>> traffic on the i2c.
>
> That depends on how often you're checking the "health" attribute,
> doesn't it? But anyway, the bug is real.
At least on my Hardware I had constant traffic from the moment the 
device was probed.
I have no userland process accessing the device.
I'm guessing that it has something todo with the call to 
'power_supply_changed'.
This done at the end of 'sbs_get_property' if the presence state changed and
no gpio is used. I suspect it triggers a readout of all the properties 
and leads to this
endless loop?
>> This commit changes the response of "health" to an error when the battery
>> is not responding leading to a consistent "not present" state.
>
> Ack, and thanks for the fix.
>
>> Fixes: 76b16f4cdfb8 ("power: supply: sbs-battery: don't assume
>> MANUFACTURER_DATA formats")
>>
>> Signed-off-by: Michael Nosthoff<committed@heine.so>
>> Cc: Brian Norris<briannorris@chromium.org>
>> Cc:<stable@vger.kernel.org>
>
> Reviewed-by: Brian Norris<briannorris@chromium.org>
> Tested-by: Brian Norris<briannorris@chromium.org>
thanks for review!
>
>> ---
>>   drivers/power/supply/sbs-battery.c | 25 ++++++++++++++++---------
>>   1 file changed, 16 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/power/supply/sbs-battery.c b/drivers/power/supply/sbs-battery.c
>> index 2e86cc1e0e35..f8d74e9f7931 100644
>> --- a/drivers/power/supply/sbs-battery.c
>> +++ b/drivers/power/supply/sbs-battery.c
>> @@ -314,17 +314,22 @@ static int sbs_get_battery_presence_and_health(
>>   {
>>   	int ret;
>>
>> -	if (psp == POWER_SUPPLY_PROP_PRESENT) {
>> -		/* Dummy command; if it succeeds, battery is present. */
>> -		ret = sbs_read_word_data(client, sbs_data[REG_STATUS].addr);
>> -		if (ret<  0)
>> -			val->intval = 0; /* battery disconnected */
>> -		else
>> -			val->intval = 1; /* battery present */
>> -	} else { /* POWER_SUPPLY_PROP_HEALTH */
>> +	/* Dummy command; if it succeeds, battery is present. */
>> +	ret = sbs_read_word_data(client, sbs_data[REG_STATUS].addr);
>> +
>> +	if (ret<  0) { /* battery not present*/
>> +		if (psp == POWER_SUPPLY_PROP_PRESENT) {
>> +			val->intval = 0;
>> +			return 0;
>
> Technically, you don't need the 'return 0' (and if we care about
> symmetry: the TI version doesn't), since the caller knows that "not
> present" will yield errors. I'm not sure which version makes more sense.
>
>> +		}
>> +		return ret;
>> +	}
>> +
>> +	if (psp == POWER_SUPPLY_PROP_PRESENT)
>> +		val->intval = 1; /* battery present */
>> +	else /* POWER_SUPPLY_PROP_HEALTH */
>>   		/* SBS spec doesn't have a general health command. */
>>   		val->intval = POWER_SUPPLY_HEALTH_UNKNOWN;
>> -	}
>>
>>   	return 0;
>>   }
>> @@ -626,6 +631,8 @@ static int sbs_get_property(struct power_supply *psy,
>>   		else
>>   			ret = sbs_get_battery_presence_and_health(client, psp,
>>   								  val);
>> +
>> +		/* this can only be true if no gpio is used */
>>   		if (psp == POWER_SUPPLY_PROP_PRESENT)
>>   			return 0;
>>   		break;
>> -- 
>> 2.20.1
>>

