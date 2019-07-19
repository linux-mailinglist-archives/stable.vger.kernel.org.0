Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB37E6E196
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 09:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbfGSHTS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 03:19:18 -0400
Received: from mga12.intel.com ([192.55.52.136]:9129 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726135AbfGSHTS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 03:19:18 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jul 2019 00:19:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,281,1559545200"; 
   d="scan'208";a="343617583"
Received: from crojewsk-mobl1.ger.corp.intel.com (HELO [10.251.81.172]) ([10.251.81.172])
  by orsmga005.jf.intel.com with ESMTP; 19 Jul 2019 00:19:12 -0700
Subject: Re: [PATCH v5 2/6] ASoC: sgtl5000: Improve VAG power and mute control
To:     Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
Cc:     Fabio Estevam <festevam@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Igor Opaniuk <igor.opaniuk@toradex.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Sasha Levin <sashal@kernel.org>,
        Mark Brown <broonie@kernel.org>, Takashi Iwai <tiwai@suse.com>,
        Liam Girdwood <lgirdwood@gmail.com>
References: <20190718090240.18432-1-oleksandr.suvorov@toradex.com>
 <20190718090240.18432-3-oleksandr.suvorov@toradex.com>
 <9c9ee47c-48bd-7109-9870-8f73be1f1cfa@intel.com>
 <a86e4d6b-ed2c-d2f2-2974-6f00dc6ef68a@intel.com>
 <CAGgjyvGboMPx5wKJ_1DaeYZazSHmQUGwDZHoCBt5vhpVq3Q_bA@mail.gmail.com>
From:   Cezary Rojewski <cezary.rojewski@intel.com>
Message-ID: <3c153dcc-e656-2959-6281-15cc895660e0@intel.com>
Date:   Fri, 19 Jul 2019 09:19:10 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAGgjyvGboMPx5wKJ_1DaeYZazSHmQUGwDZHoCBt5vhpVq3Q_bA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019-07-19 09:09, Oleksandr Suvorov wrote:
> On Thu, 18 Jul 2019 at 21:49, Cezary Rojewski <cezary.rojewski@intel.com> wrote:
>>
>> On 2019-07-18 20:42, Cezary Rojewski wrote:
>>> On 2019-07-18 11:02, Oleksandr Suvorov wrote:
>>>> +enum {
>>>> +    HP_POWER_EVENT,
>>>> +    DAC_POWER_EVENT,
>>>> +    ADC_POWER_EVENT,
>>>> +    LAST_POWER_EVENT
>>>> +};
>>>> +
>>>> +static u16 mute_mask[] = {
>>>> +    SGTL5000_HP_MUTE,
>>>> +    SGTL5000_OUTPUTS_MUTE,
>>>> +    SGTL5000_OUTPUTS_MUTE
>>>> +};
>>>
>>> If mute_mask[] is only used within common handler, you may consider
>>> declaring const array within said handler instead (did not check that
>>> myself).
>>> Otherwise, simple comment for the second _OUTPUTS_MUTE should suffice -
>>> its not self explanatory why you doubled that mask.
> 
> Ok, I'll add a comment to explain doubled mask.
> 
>>>
>>>> +
>>>>    /* sgtl5000 private structure in codec */
>>>>    struct sgtl5000_priv {
>>>>        int sysclk;    /* sysclk rate */
>>>> @@ -137,8 +157,109 @@ struct sgtl5000_priv {
>>>>        u8 micbias_voltage;
>>>>        u8 lrclk_strength;
>>>>        u8 sclk_strength;
>>>> +    u16 mute_state[LAST_POWER_EVENT];
>>>>    };
>>>
>>> When I spoke of LAST enum constant, I did not really had this specific
>>> usage in mind.
>>>
>>>   From design perspective, _LAST_ does not exist and should never be
>>> referred to as "the next option" i.e.: new enum constant.
> 
> By its nature, LAST_POWER_EVENT is actually a size of the array, but I
> couldn't come up with a better name.
> 
>>> That is way preferred usage is:
>>> u16 mute_state[ADC_POWER_EVENT+1;
>>> -or-
>>> u16 mute_state[LAST_POWER_EVENT+1];
>>>
>>> Maybe I'm just being radical here :)
> 
> Maybe :)  I don't like first variant (ADC_POWER_EVENT+1): somewhen in
> future, someone can add a new event to this enum and we've got a
> possible situation with "out of array indexing".
> 
>>>
>>> Czarek
>>
>> Forgive me for double posting. Comment above is targeted towards:
>>
>>   >> +enum {
>>   >> +    HP_POWER_EVENT,
>>   >> +    DAC_POWER_EVENT,
>>   >> +    ADC_POWER_EVENT,
>>   >> +    LAST_POWER_EVENT
>>   >> +};
>>
>> as LAST_POWER_EVENT is not assigned explicitly to ADC_POWER_EVENT and
>> thus generates implicit "new option" of value 3.
> 
> So will you be happy with the following variant?
> ...
>      ADC_POWER_EVENT,
>      LAST_POWER_EVENT =  ADC_POWER_EVENT,
> ...
>     u16 mute_state[LAST_POWER_EVENT+1];
> ...
> 

It's not about being happy - I'm a happy man in general ;p

As stated already, declaring _LAST_ as the "new option" is misleading 
and not advised.
And yeah, [_LAST_ + 1] is usually the one you should go with.

Czarek
