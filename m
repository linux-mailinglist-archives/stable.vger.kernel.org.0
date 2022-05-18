Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A15E52C4C4
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 22:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242783AbiERUw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 16:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242788AbiERUw6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 16:52:58 -0400
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859D3205F03;
        Wed, 18 May 2022 13:52:56 -0700 (PDT)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 8AC62839FD;
        Wed, 18 May 2022 22:52:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1652907174;
        bh=3NosABIFpcT602pIJktuxICfO8UVkC7uLjjF3wACISc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=G3IQLi+/fAsvviW/Go6wfEUeaD1d3b11eF325qsQHSW14QOpz4B59UONwIEW1SPWe
         PXFgYWWUe+RJuXnTkpWIYyrjk9NfLywVNHpFaTFykMg9eYm5n3SyOHrrHHJ6FfOG2s
         tlEP/gHgkithqLnTMUQ8E8UHEwmV77cp9oS5Lizp7546M5EEIHGlC3In/INIpXK92n
         450lCiRHPH6COae1N4oOSTUAVew1es13rt8o4LnFWuKHJGWhxXHQBK4oHMVorXsei/
         rkJnKTQoUH/lW6j4BFNWONVG4vjqxPSE5g8ObyoChLUTyJjns8Aps1PpQ8kxBmY/wC
         BRH8fQHy/kAUQ==
Message-ID: <f0556115-e51e-ca87-c3f1-64e0d33c4f0f@denx.de>
Date:   Wed, 18 May 2022 22:52:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] Input: ili210x - Fix reset timing
Content-Language: en-US
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     linux-input@vger.kernel.org, stable@vger.kernel.org
References: <20220518163430.41192-1-marex@denx.de>
 <YoVEftKRoTndAn9R@google.com>
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <YoVEftKRoTndAn9R@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.5 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/18/22 21:09, Dmitry Torokhov wrote:
> On Wed, May 18, 2022 at 06:34:30PM +0200, Marek Vasut wrote:
>> According to Ilitek "231x & ILI251x Programming Guide" Version: 2.30
>> "2.1. Power Sequence", "T4 Chip Reset and discharge time" is minimum
>> 10ms and "T2 Chip initial time" is maximum 150ms. Adjust the reset
>> timings such that T4 is 15ms and T2 is 160ms to fit those figures.
>>
>> This prevents sporadic touch controller start up failures when some
>> systems with at least ILI251x controller boot, without this patch
>> the systems sometimes fail to communicate with the touch controller.
>>
>> Fixes: 201f3c803544c ("Input: ili210x - add reset GPIO support")
>> Signed-off-by: Marek Vasut <marex@denx.de>
>> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>> ---
>>   drivers/input/touchscreen/ili210x.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/input/touchscreen/ili210x.c b/drivers/input/touchscreen/ili210x.c
>> index 2bd407d86bae5..131cb648a82ae 100644
>> --- a/drivers/input/touchscreen/ili210x.c
>> +++ b/drivers/input/touchscreen/ili210x.c
>> @@ -951,9 +951,9 @@ static int ili210x_i2c_probe(struct i2c_client *client,
>>   		if (error)
>>   			return error;
>>   
>> -		usleep_range(50, 100);
>> +		msleep(15);
> 
> WARNING: msleep < 20ms can sleep for up to 20ms; see
> Documentation/timers/timers-howto.rst
> #38: FILE: drivers/input/touchscreen/ili210x.c:954:
> +               msleep(15);

Sigh, yes, fixed in V2 to be 12..15ms .

> Should this be usleep_range(10000, 15000) like in
> ili251x_hardware_reset()? Actually, should we adopt
> ili251x_hardware_reset() to be used there?

I'll send a separate patch for that, it is indeed a good idea, but I 
think we should keep the fix as simple as possible for backporting ?
