Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29B2465C30A
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 16:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237884AbjACPdl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 10:33:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237892AbjACPdk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 10:33:40 -0500
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1471011C0A;
        Tue,  3 Jan 2023 07:33:39 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 47E7641DF4;
        Tue,  3 Jan 2023 15:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1672760017; bh=Cfjad1f4bMHiStflEproBmzMrnqAIcpfSbdhxfxcGFw=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To;
        b=iuX9XmiIXyPtwb1i6zlDMi9aiAfYcZByMkS78kNY1+hWkP3WqiFHgRhvHhaOImFeW
         toMfl29Qcz1XmFPuRUKeHcq8ewI4JBmpnw32ODfXyhcq3IaDkY8zusTywUaaTxUoyt
         moWuw9afzWcVouz8TuQ1KPMj6GOZpxF3IEkH8nw8oGtKeh2lByexuvDm0br4wnKK+r
         ghDchTFu3IHqk6Hu9BHRlESoL8ty2avW6NVBfjsKTjkHLYEoF8RbJ6065D2tgP5iRg
         eHTSOnUAQlkFGD+9ddemxhevEo/XyrI4XIEAcrHXk6eFEuVsyKatZKql7UTRnaNj98
         DqE3WwQ2Hu+yg==
Message-ID: <03514845-dfd6-a117-83c8-ab3abc402229@marcan.st>
Date:   Wed, 4 Jan 2023 00:33:33 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        asahi@lists.linux.dev, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Eric Curtin <ecurtin@redhat.com>
References: <20230103114427.1825-1-marcan@marcan.st>
 <ff77ba1c-8b67-4697-d713-0392d3b1d77a@linaro.org>
 <95a4cfde-490f-d26d-163e-7ab1400e7380@marcan.st>
 <b118af4c-e4cc-c50b-59aa-d768f1ec69ff@linaro.org>
 <b98e313d-8875-056b-4b64-bb7528f2670a@marcan.st>
 <Y7RHTXZ60zuExeMA@shell.armlinux.org.uk>
From:   Hector Martin <marcan@marcan.st>
Subject: Re: [PATCH v2] nvmem: core: Fix race in nvmem_register()
In-Reply-To: <Y7RHTXZ60zuExeMA@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04/01/2023 00.18, Russell King (Oracle) wrote:
> On Tue, Jan 03, 2023 at 11:56:21PM +0900, Hector Martin wrote:
>> On 03/01/2023 23.22, Srinivas Kandagatla wrote:
>>>>>>    drivers/nvmem/core.c | 32 +++++++++++++++++---------------
>>>>>>    1 file changed, 17 insertions(+), 15 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
>>>>>> index 321d7d63e068..606f428d6292 100644
>>>>>> --- a/drivers/nvmem/core.c
>>>>>> +++ b/drivers/nvmem/core.c
>>>>>> @@ -822,11 +822,8 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
>>>>>>    		break;
>>>>>>    	}
>>>>>>
>>>>>> -	if (rval) {
>>>>>> -		ida_free(&nvmem_ida, nvmem->id);
>>>>>> -		kfree(nvmem);
>>>>>> -		return ERR_PTR(rval);
>>>>>> -	}
>>>>>> +	if (rval)
>>>>>> +		goto err_gpiod_put;
>>>>>
>>>>> Why was gpiod changes added to this patch, that should be a separate
>>>>> patch/discussion, as this is not relevant to the issue that you are
>>>>> reporting.
>>>>
>>>> Because freeing the device also does a gpiod_put in the destructor, so
>>> This are clearly untested, And I dont want this to be in the middle to 
>>> fix to the issue you are hitting.
>>
>> I somehow doubt you tested any of these error paths either. Nobody tests
>> initialization error paths. That's why there was a gpio leak here to
>> begin with.
> 
> Sadly, this is one of the biggest problems with error paths, they get
> very little proper testing - and in most cases we're reliant on
> reviewers spotting errors. That's why we much prefer the devm_* stuff,
> but even that can be error-prone.
> 
>>> We should always be careful about untested changes, in this case gpiod 
>>> has some conditions to check before doing a put. So the patch is 
>>> incorrect as it is.
>>
>> Then the existing code is also incorrect as it is, because the device
>> release callback is doing the same gpiod_put() already. I just moved it
>> out since we are now registering the device later.
> 
> At the point where this change is being made (checking rval after
> dev_set_name()) the struct device has not been initialised, so the
> release callback will not be called. nvmem->wp_gpio will be leaked.

But later in the code where device_put() was being called would will be,
and that callback is calling gpiod_put() unconditionally, which is why I
am doing the same after moving the device registration later.

Is this wrong? Well,

> However, there may be bigger problems with wp_gpio - related to where
> it can come from and what we do with it.
> 
> nvmem->wp_gpio has two sources - one of them is gpiod_get_optional(),
> and we need to call gpiod_put() on that to drop the reference that
> _this_ code acquired. The other is config->wp_gpio - we don't own
> that reference, yet we call gpiod_put() on it. I'm not sure whether
> config->wp_gpio is actually used anywhere - my grepping so far has
> not found any users, but maybe Srivinas knows better.

... then yes, it's wrong, and the original code is already broken too. I
merely moved functionality around in the other cases *except* the one
case after dev_set_name(), where I swapped one bug out for calling other
buggy code derived from existing buggy code. ¯\_(ツ)_/¯

> Hence, sorting out the leak of wp_gpio needs more discussion, and it
> would not be right to delay merging the fix for the very real race
> that people hit today resulting in stuff not working while we try
> to work out how wp_gpio should be handled.

> So... always fix one problem in one patch. Sometimes a fix is not as
> obvious as one may first think.

Sure, but you do realize the issue here, right? This, coupled with the
kernel development model (and *especially* the impolite discourse that
often goes along with it from maintainers) incentivizes doing the
minimum amount of work to fix the minimum amount of bugs that actually
affect people. I couldn't care less about the gpiod leak fix, it doesn't
affect me, but I noticed and thought I could fix it. Turns out it's more
complicated than that because the existing code is even more broken than
I thought, sure - but I have no incentive to start that conversation nor
fix all this now. Now I just know next time I touch nvmem code I won't
bother pointing out any bugs I notice by accident, because clearly the
discussion likely to follow is more mental overhead than I'm willing to
spend on something that doesn't affect me. When bugs don't noticeably
break people and fixing them is too much effort, nobody will.

While if my change had been merged as-is, we'd have at least fixed one
common case bug and reduced two related bugs to one class of bug (the
unconditional gpiod_put()) which is still a strict improvement. And then
someone can point out the incorrect puts when the GPIO isn't owned and
fix that later if they want.

- Hector
