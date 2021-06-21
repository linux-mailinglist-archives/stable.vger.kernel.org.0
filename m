Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC373AE726
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 12:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbhFUKcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 06:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbhFUKcT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 06:32:19 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA840C061756
        for <stable@vger.kernel.org>; Mon, 21 Jun 2021 03:30:03 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id j2so8482926wrs.12
        for <stable@vger.kernel.org>; Mon, 21 Jun 2021 03:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/Fq+dWhO9SHsHsMwwaVEqert5MWEft+vHWC2Ak/+Drc=;
        b=aUDW2XxVWADlHQ2ZicvYAcn3d76aaNxkdus6VXFkzQAvCba90Z+MU+L7e2L/2xPNW3
         d1oY2qaG0V0swBkIIWjxbqbT3JcHZsFAgso0qcfNO15ozJjy2OsBo2Ka6rVoSEd6Nk3z
         JCt+xzF2QuypB3pqznBDmA7yEL4jMe2dO0GG65o8N857HhcW1oZGoQiJ3CdG40xYqNwI
         PA11Jo3lPAKu2vd6U5Vw1aoY4tgipmsaptT2if/tKGs586e+dXZKi9oA/mHFnzgnoZee
         oQaxX/KN51qb8qzxSy1nxH+Ol8zcWaJ+3+d1vS+6wr6N26Iife37OKQBxW2yuAaiP06y
         npfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/Fq+dWhO9SHsHsMwwaVEqert5MWEft+vHWC2Ak/+Drc=;
        b=F8UVyiI6LdHZIdltPAUIiaR3Ox8fT7IkM8roAdu392le4DOMVTUsMQ5RJv+iYQipT4
         3+EItlecdw+fgAONC1r/Q4SAfm22lJ4hTLe+0I9gFhTcWtVH/EWcfiVK2g5OIdxNFeRU
         ZzxH+pqP3xMAQu9Vp5CVFaeXmEBbrjocSyJfQMQfaFQLTPJvyMkzy5xGAzmdCe575Zkd
         L15UvIzIXmUsUiVYCP1Xadowz9FEHO7Ey/3FU++F+4RHh1bClj1m0KARGhQg5ni1t4tO
         k3OxXZ8vB+2ZGwujmzmghs62T9L5BHKe2gL694N5D4mJLhVOOdquxu4d3kyUp+aj6Vd6
         wJlQ==
X-Gm-Message-State: AOAM533YAlveV+urCMpwls7MEqifrLxAqY+7EwdwCmyDPk2vNbC5AyTX
        mHtDHJcwwjutpCgvqimT509R7Q==
X-Google-Smtp-Source: ABdhPJzgIlGmFfDtfd0f6edNI3fVVXZ96zvuMdiQmFgSQaputhlMltjoUpGsdFln9a58bYBqEzeX1A==
X-Received: by 2002:adf:e551:: with SMTP id z17mr27282825wrm.320.1624271402245;
        Mon, 21 Jun 2021 03:30:02 -0700 (PDT)
Received: from [192.168.86.34] (cpc86377-aztw32-2-0-cust226.18-1.cable.virginm.net. [92.233.226.227])
        by smtp.googlemail.com with ESMTPSA id i9sm14127381wrn.13.2021.06.21.03.30.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Jun 2021 03:30:01 -0700 (PDT)
Subject: Re: [PATCH] regmap: move readable check before accessing regcache.
To:     Mark Brown <broonie@kernel.org>
Cc:     srivasam@codeaurora.org, rafael@kernel.org,
        dp@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>
References: <20210618113558.10046-1-srinivas.kandagatla@linaro.org>
 <20210618115104.GB4920@sirena.org.uk>
 <666da41f-173e-152d-84e5-e9b32baa60da@linaro.org>
 <20210618154836.GC4920@sirena.org.uk>
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Message-ID: <6eca27bf-5696-3ffc-24a5-5a58407f6e93@linaro.org>
Date:   Mon, 21 Jun 2021 11:30:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20210618154836.GC4920@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks Mark for your inputs,

On 18/06/2021 16:48, Mark Brown wrote:
> On Fri, Jun 18, 2021 at 01:29:50PM +0100, Srinivas Kandagatla wrote:
>> On 18/06/2021 12:51, Mark Brown wrote:
> 
>>> Why will use of regmap_update_bits() mean that a driver will never
>>> notice a write failure?  Shouldn't remgap_update_bits() be fixed to
>>> report any errors it isn't reporting, or the driver fixed to check
> 
>> usecase is performing regmap_update_bits() on a *write-only* registers.
> 
>> _regmap_update_bits() checks _regmap_read() return value before bailing out.
>> In non cache path we have this regmap_readable() check however in cached
>> patch we do not have this check, so _regmap_read() will return success in
>> this case so regmap_update_bits() never reports any error.
> 
>> driver in question does check the return value.
> 
> OK, so everything is working fine then - what's the problem?  The value

How can this be working fine?

In this particular setup the register is marked as write only and is not 
readable. Should it really store value in cache at the first instance?

Also on the other note, if we mark the same regmap as uncached this 
usecase will fail straightaway with -EIO, so why is the behavior 
different in regcache path?

Shouldn't the regcache path check if the register is readable before 
trying to cache the value?

> in the register is cached, the read returns that cached value and then
> the relevant bits are updated and the new value written out to both the
> cache and the hardware.  No part of that sounds like a problem to me.
> 
>>> error codes?  I really don't understand the issue you're trying to
>>> report - what is "the right thing" and what makes you believe that a
>>> driver can't do an _update_bits() on a write only but cached register?
>>> Can you specify in concrete terms what the problem is.
> 
>> So one of recent patch ("ASoC: qcom: Fix for DMA interrupt clear reg
>> overwriting) https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?h=next-20210618&id=da0363f7bfd3c32f8d5918e40bfddb9905c86ee1
>>
>> broke audio on DragonBoard 410c.
> 
>> This patch simply converts writes to regmap_update_bits for that particular
>> dma channel. The register that its updating is IRQ_CLEAR register which is
>> software "WRITE-ONLY" and Hardware read-only register.
> 
> So the driver is buggy then, the register is clearly volatile and can't
> be cached, and it sounds like it's unsafe to use _update_bits() on it.
> The register is clearly not write only since it can be read and it's
> volatile since the readback value does not reflect what was written (and
> presumably can change),.  Even without that it's buggy to use
> _update_bits() here since the device needs the write to happen
> regardless of the value that is read back, with the register marked as
> volatile that will still potentially fail if the readback value happens
> to be the same as whatever bits the driver is trying to set.

 From "APQ8016E Technical Reference Manual" 
https://developer.qualcomm.com/qfile/28813/lm80-p0436-7_f_410e_proc_apq8016e_device_spec.pdf

Section: 4.5.9.6.19
this register LPASS_LPAIF_IRQ_CLEARa is clearly marked with Type: W

with this description:
"Writing a 1 to a bit in this register clears the latched interrupt event

So am not 100% sure if we read this we will get anything real from the 
register. I always get zeros if I do that.

Should this behavior treated as volatile?

If we mark this register as volatile and make it readable then it would 
work but that just sounds like a hack to avoid cache.

Am sure other hardware platforms have similar write-only registers, how 
do they handle regmap_update_bits case if they have regcache enabled?

thanks,
srini
