Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6233E3ACAF3
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 14:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234103AbhFRMcR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 08:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234423AbhFRMcD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Jun 2021 08:32:03 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA982C06124C
        for <stable@vger.kernel.org>; Fri, 18 Jun 2021 05:29:53 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id n23so5566028wms.2
        for <stable@vger.kernel.org>; Fri, 18 Jun 2021 05:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AF/9ugvcaR0qWAq1+q07h3mZXYOA6TNaXRCBlnFD4wA=;
        b=ETITULQfqpXRKA20QYUFH+yqebqfOtw0Q5cVBoAyLI9vux0Ej7iTJKARS+Kimvm0/V
         F8O9f0zTJvGG4mR64agMq7v/bRilDFvhxphA4qbIgBkg+Zt8gOw513A7pQZgi8UevDXz
         6VZSYkwm8e3nc5OBGqYvxCie0SxjgsqTpBYRU219gPiaQ+kQc5K166mMSqApSJG3fbyh
         gUiE1AqoCEZh3i0T/C+agGwzkFo9ZkgaBhjYuz/YBntY4ao8tc5lli66OGRItw0aTq3k
         Ix6Fttp7si2mL0NUJzwhyB5bu01BVn4dVHPpRlAQZ+JsI65CwH02MhCaGcICU5a+bVUz
         uB4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AF/9ugvcaR0qWAq1+q07h3mZXYOA6TNaXRCBlnFD4wA=;
        b=Xpqjm4ULjAmW5pJcekAOltXQQngGf5DKRTLPhCdvWphkXOw1CrAlDRabYX4gNYV0gG
         BIkFjXcaNobQH2u4T6tlP3JXgxOHwSYyWJ24KH0P7PB85T2Jj9iAdVo7QC/10rOeAIxy
         TcR9MlBZC4TyGkN/rUa73lBvLkxw9aCSQyn/4fb2VFo2RBBS0sw8vupD5XTb28HhmpBz
         XebGQR987mcp6zl7KL+HmgSrgcKkogpSIJp0TWH1c7dlaGWWgsJp9YFT6RrwnvGFn/Ss
         ZFdgiLzBKJutT3FC3swWXPu2k3hTlfeNKQfTgm7ZVB+3xn44Ude4I49YSK/yF2gMV9bZ
         qppA==
X-Gm-Message-State: AOAM5307xw27Pp8eSOBP93ShJIyi+jR+U0DkyrCACeqzNE731i5f+XsP
        KtolRulvwZ56ZroCrHtb8HYOig==
X-Google-Smtp-Source: ABdhPJy42dnPo0rChhHEcXwymBX0iZovSkFs3aYubP1cLQ9EUkEwfrWSzFijT3ic5xPBP/2udHcHCg==
X-Received: by 2002:a05:600c:3ba8:: with SMTP id n40mr11371890wms.175.1624019392268;
        Fri, 18 Jun 2021 05:29:52 -0700 (PDT)
Received: from [192.168.86.34] (cpc86377-aztw32-2-0-cust226.18-1.cable.virginm.net. [92.233.226.227])
        by smtp.googlemail.com with ESMTPSA id 3sm10095480wmv.6.2021.06.18.05.29.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Jun 2021 05:29:51 -0700 (PDT)
Subject: Re: [PATCH] regmap: move readable check before accessing regcache.
To:     Mark Brown <broonie@kernel.org>
Cc:     srivasam@codeaurora.org, rafael@kernel.org,
        dp@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>
References: <20210618113558.10046-1-srinivas.kandagatla@linaro.org>
 <20210618115104.GB4920@sirena.org.uk>
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Message-ID: <666da41f-173e-152d-84e5-e9b32baa60da@linaro.org>
Date:   Fri, 18 Jun 2021 13:29:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20210618115104.GB4920@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks Mark for review,

On 18/06/2021 12:51, Mark Brown wrote:
> On Fri, Jun 18, 2021 at 12:35:58PM +0100, Srinivas Kandagatla wrote:
> 
>> The issue that I encountered is when doing regmap_update_bits on
>> a write only register. In regcache path this will not do the right
>> thing as the register is not readable and driver which is using
>> regmap_update_bits will never notice that it can not do a update
>> bits on write only register leading to inconsistent writes and
>> random hardware behavior.
> 
> Why will use of regmap_update_bits() mean that a driver will never
> notice a write failure?  Shouldn't remgap_update_bits() be fixed to
> report any errors it isn't reporting, or the driver fixed to check

usecase is performing regmap_update_bits() on a *write-only* registers.

_regmap_update_bits() checks _regmap_read() return value before bailing 
out. In non cache path we have this regmap_readable() check however in 
cached patch we do not have this check, so _regmap_read() will return 
success in this case so regmap_update_bits() never reports any error.

driver in question does check the return value.

> error codes?  I really don't understand the issue you're trying to
> report - what is "the right thing" and what makes you believe that a
> driver can't do an _update_bits() on a write only but cached register?
> Can you specify in concrete terms what the problem is.

So one of recent patch ("ASoC: qcom: Fix for DMA interrupt clear reg 
overwriting) 
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?h=next-20210618&id=da0363f7bfd3c32f8d5918e40bfddb9905c86ee1

broke audio on DragonBoard 410c.

This patch simply converts writes to regmap_update_bits for that 
particular dma channel. The register that its updating is IRQ_CLEAR 
register which is software "WRITE-ONLY" and Hardware read-only register.

The bits in particular case is updating is a period interrupt clear bit.

Because we are using regmap cache in this driver,

first regmap_update_bits(map, 0x1, 0x1) on first period interrupt will 
update the cache and write to IRQ_CLEAR hardware register which then 
clears the interrupt latch.
On second period interrupt we do regmap_update_bits(map, 0x1, 0x1) with 
the same bits, Because we are using cache for this regmap caches sees no 
change in the cache value vs the new value so it will never write/update 
  IRQ_CLEAR hardware register, so hardware is stuck here waiting for 
IRQ_CLEAR write from driver and audio keeps repeating the last period.

> 
>> There seems to be missing checks in regcache_read() which is
>> now added by moving the orignal check in _regmap_read() before
>> accessing regcache.
> 
>> Cc: stable@vger.kernel.org
>> Fixes: 5d1729e7f02f ("regmap: Incorporate the regcache core into regmap")
> 
> Are you *sure* you've identified the actual issue here - nobody has seen

I think so, my above triage does summarizes the problem in detail.

> any problems with this in the past decade?  Please don't just pick a
> random commit for the sake of adding a Fixes tag.

I did git blame and picked up this changeset which is when the cache was 
integrated.

> 
>> @@ -2677,6 +2677,9 @@ static int _regmap_read(struct regmap *map, unsigned int reg,
>>   	int ret;
>>   	void *context = _regmap_map_get_context(map);
>>   
>> +	if (!regmap_readable(map, reg))
>> +		return -EIO;
>> +
>>   	if (!map->cache_bypass) {
>>   		ret = regcache_read(map, reg, val);
>>   		if (ret == 0)
>> @@ -2686,9 +2689,6 @@ static int _regmap_read(struct regmap *map, unsigned int reg,
>>   	if (map->cache_only)
>>   		return -EBUSY;
>>   
>> -	if (!regmap_readable(map, reg))
>> -		return -EIO;
>> -
> 
> This puts the readability check before the cache check which will break
> all drivers using the cache on write only registers.
Initially I added check in regcache_read(), later I moved it to 
_regmap_read. do you think check in regcache_read() is the correct place?

--srini
> 
