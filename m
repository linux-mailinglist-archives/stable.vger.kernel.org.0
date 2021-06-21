Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8C03AE94E
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 14:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbhFUMp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 08:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbhFUMp2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 08:45:28 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9BE4C061756
        for <stable@vger.kernel.org>; Mon, 21 Jun 2021 05:43:13 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id h11so2025962wrx.5
        for <stable@vger.kernel.org>; Mon, 21 Jun 2021 05:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BGQx0SlCEO8KOWIV41DLzBBvaAXma1P0pan6QH77Lgk=;
        b=iQAQiQSYpFZ7xJ4hALpvjz8bQe5ReZdq5b1RG9bbke3+tyRvj00axHfAks8DlNunAm
         lXs7qN1wYgaXZqjKvzGqkcimSmVXxjrTNQAddfhUFU1cRConSfQv7Id5ShO8RcIqENxb
         H9flYaSdWdjGZMGbi07jRMn3JPnG3O1ioeeURD4qLum739wUweb5ZzKdIPQRhXUYM82M
         UJD0e9cjL7+idfdRdTFCW0b1ADODz2uEsPDmvP/Td+EHIC00dXZajLuYbrikFy79CPTw
         MUUlL6OseLIjSPgfyD0yLVLjeqxKD6RFw4oqsoJkybdmdZ2ahZhxc434Xr45mHs3Qdhy
         wegw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BGQx0SlCEO8KOWIV41DLzBBvaAXma1P0pan6QH77Lgk=;
        b=SbPKzxOABlWb98m6YrPvxh4/Y01t24rZYt4zLyETYahqtJSdR0PEl2hoCkwRLqhRyR
         GzjGJ4faIQHJD09OkR7ZH/6EQbbEbnDcQWTH5p3cQzt69iUd8IwLPpEgFbRfhc1d+YSU
         G1EFqO4xw3rRqr7NriLeeIPix5FYhCU0ME4T1bhvZ/OgPePB6Gn3kNB1WtbnvPvOpZOr
         ql5CN3MhpQfspcSt1545rFzNTgTsUi8vA+yz6zpNlk5IybVczbFpNt7unJhXxxOVYD/Y
         TKGR9WbyCy+4xah/RZeu1ijLszj9wDfsdPkeziwN9DNZeshA6f7pZIh/3fQhML0lbll7
         AHyw==
X-Gm-Message-State: AOAM5309X2S7kdzTj77Lpjeof9SxZF66QCUSUdFOgNsetkifA2hWFEZI
        eaJzk5fhSa2Kw/xGlsLoxY4MJA==
X-Google-Smtp-Source: ABdhPJxq9ws3Sp946eyu5bClvAQp6yYu8afY7h80vgh0o8WA6vFCPpu2LbbbNiLeFyGbeOtbRKEJPg==
X-Received: by 2002:adf:b354:: with SMTP id k20mr27354295wrd.136.1624279392380;
        Mon, 21 Jun 2021 05:43:12 -0700 (PDT)
Received: from [192.168.86.34] (cpc86377-aztw32-2-0-cust226.18-1.cable.virginm.net. [92.233.226.227])
        by smtp.googlemail.com with ESMTPSA id f5sm20222755wrf.22.2021.06.21.05.43.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Jun 2021 05:43:11 -0700 (PDT)
Subject: Re: [PATCH] regmap: move readable check before accessing regcache.
To:     Mark Brown <broonie@kernel.org>
Cc:     srivasam@codeaurora.org, rafael@kernel.org,
        dp@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>
References: <20210618113558.10046-1-srinivas.kandagatla@linaro.org>
 <20210618115104.GB4920@sirena.org.uk>
 <666da41f-173e-152d-84e5-e9b32baa60da@linaro.org>
 <20210618154836.GC4920@sirena.org.uk>
 <6eca27bf-5696-3ffc-24a5-5a58407f6e93@linaro.org>
 <20210621112747.GC4094@sirena.org.uk>
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Message-ID: <01e3c429-62b8-378e-9977-7d3a11df6bc4@linaro.org>
Date:   Mon, 21 Jun 2021 13:43:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20210621112747.GC4094@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 21/06/2021 12:27, Mark Brown wrote:
> On Mon, Jun 21, 2021 at 11:30:00AM +0100, Srinivas Kandagatla wrote:
>> On 18/06/2021 16:48, Mark Brown wrote:
>>> On Fri, Jun 18, 2021 at 01:29:50PM +0100, Srinivas Kandagatla wrote:
> 
>>>> _regmap_update_bits() checks _regmap_read() return value before bailing out.
>>>> In non cache path we have this regmap_readable() check however in cached
>>>> patch we do not have this check, so _regmap_read() will return success in
>>>> this case so regmap_update_bits() never reports any error.
>>>
>>>> driver in question does check the return value.
> 
>>> OK, so everything is working fine then - what's the problem?  The value
> 
>> How can this be working fine?
> 
>> In this particular setup the register is marked as write only and is not
>> readable. Should it really store value in cache at the first instance?
> 
> Yes, we know exactly what the value in the register is since we wrote it
> so there's no problem with us remembering and using that.
> 
>> Also on the other note, if we mark the same regmap as uncached this usecase
>> will fail straightaway with -EIO, so why is the behavior different in
>> regcache path?
> 
> If the register is marked as uncachable then obviously the cache
> behaviour is going to be different to that for a register which we can
> cache for whatever reason the register was marked volatile.
> 
>> Shouldn't the regcache path check if the register is readable before trying
>> to cache the value?
> 
> Why?  If we know what the value is we can cache it and then use it,
> meaning things like restoring the value in a cache sync and update_bits()
> work, this is useful especially on devices which have no read support at

Thanks for the insight,
Yes that makes more sense to have cache for write-only too.

> all.  What would the benefit it not caching it be? >
>>  From "APQ8016E Technical Reference Manual" https://developer.qualcomm.com/qfile/28813/lm80-p0436-7_f_410e_proc_apq8016e_device_spec.pdf
> 
>> Section: 4.5.9.6.19
>> this register LPASS_LPAIF_IRQ_CLEARa is clearly marked with Type: W
> 
>> with this description:
>> "Writing a 1 to a bit in this register clears the latched interrupt event
> 
>> So am not 100% sure if we read this we will get anything real from the
>> register. I always get zeros if I do that.
> 
>> Should this behavior treated as volatile?
> 
> Yes.  This is indistingusihable from a register that is volatile because
> it doesn't latch written values, given that you're saying readback
> actually works there's an argument here that the documentation isn't
> accurate here.  My guess is that this device doesn't have any write only
> registers as far as anything outside the device is concerned since the
> I/O hardware won't fault or anything on reads, it just has addresses
> where the read side isn't wired up to anything.
> 
>> If we mark this register as volatile and make it readable then it would work
>> but that just sounds like a hack to avoid cache.
> 
>> Am sure other hardware platforms have similar write-only registers, how do
>> they handle regmap_update_bits case if they have regcache enabled?
> 
> They either mark the registers as volatile or just don't do any
> operations that involve reading the value so it's a non-issue.
I agree,
qcom lpass driver is already doing the second one here, so we should 
mark the register as volatile and readable to avoid the reported issue.

--srini

> 
