Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3283E1EFED7
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 19:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgFERbm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 13:31:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34601 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726939AbgFERbm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 13:31:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591378300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NDh36KsGy/n8+RUJGlENiRtyw0blPx3Iy3dLE7o2mag=;
        b=f76UGEi9JBlk3ATIj9tQ1pChlrE7gU/gX8IJ5CawyS/s/t8odSupAtv4tClXVt24PyqFPS
        Lag3pMqsTHv9S3VQ4ufNtOGolC8sYUSFZPi3/JKBsHZPI4LT3IhYmNI7TBBnUmYifDaWBq
        lUbaCYi55UO4bgY3dKjkTXKO7eB3FjM=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-_RI6LPDpPT-fYB5qL41B2g-1; Fri, 05 Jun 2020 13:31:38 -0400
X-MC-Unique: _RI6LPDpPT-fYB5qL41B2g-1
Received: by mail-ej1-f72.google.com with SMTP id i17so3882992ejb.9
        for <stable@vger.kernel.org>; Fri, 05 Jun 2020 10:31:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NDh36KsGy/n8+RUJGlENiRtyw0blPx3Iy3dLE7o2mag=;
        b=bPdw7XXoSYiJuf8hGTWa2ZZ1mUr5wKJb3RzQlrLoIRV55rh2WvgMJQTVj1fmPpTBRd
         VLdNxJ2QEOfqIHrOz1eHivWxFkbRlSfCPBv5bSQE80cLuaxCttYYQCP95XjVl/qCi/a9
         KQU9C2oG8UuGak5Ou1XeO+VZ/4GtyEPVxi2S2FwFaZQ6ko3aAiZEii36c+nI9c3p11Fp
         wvLgea0HESX1m7jxtqUN/0U7VYYHfm7gyIw+rf2qy9RxyGik+hVdlha2TyOWblW2z+51
         reWI0CCSwY8jtLN42/OKOXTOQCeLASn/jdS2RCvqDld0is/61iHiJe4NOfv/GYtJnUVl
         Af2g==
X-Gm-Message-State: AOAM531AyQLovzArLo9U68MiBBwMyvWMNfLXlO1RyjrvWvFGzDOqkB/7
        4ZolnA7bRqAD0jhtn8C0ux87sV/HjeU0XF6e0z3Rm5Vd+OzcF6qSYkGSMsE3iCKm+z4IK1eyou7
        8x4gg/1VsxEHV31ob
X-Received: by 2002:a17:906:5283:: with SMTP id c3mr9233324ejm.22.1591378296799;
        Fri, 05 Jun 2020 10:31:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhlxndd7xEis97TBi15HPHCZz4BdLIGz3wZuHYWl4WXF37PA7+fjifsNi5VnjKGTp4v/wWjA==
X-Received: by 2002:a17:906:5283:: with SMTP id c3mr9233301ejm.22.1591378296568;
        Fri, 05 Jun 2020 10:31:36 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-d2ea-f29d-118b-24dc.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:d2ea:f29d:118b:24dc])
        by smtp.gmail.com with ESMTPSA id bo26sm5480637edb.67.2020.06.05.10.31.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2020 10:31:35 -0700 (PDT)
Subject: Re: [PATCH] pinctrl: baytrail: Fix pin being driven low for a while
 on gpiod_get(..., GPIOD_OUT_HIGH)
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        linux-gpio@vger.kernel.org, stable@vger.kernel.org
References: <20200602122130.45630-1-hdegoede@redhat.com>
 <20200602152317.GI2428291@smile.fi.intel.com>
 <ba931618-9259-aca0-142c-c1dfb67e737e@redhat.com>
 <20200605170931.GR2428291@smile.fi.intel.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <1cf9b188-1e59-b321-6909-bf6afa93685d@redhat.com>
Date:   Fri, 5 Jun 2020 19:31:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200605170931.GR2428291@smile.fi.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 6/5/20 7:09 PM, Andy Shevchenko wrote:
> On Fri, Jun 05, 2020 at 04:33:47PM +0200, Hans de Goede wrote:
>> On 6/2/20 5:23 PM, Andy Shevchenko wrote:
>>> On Tue, Jun 02, 2020 at 02:21:30PM +0200, Hans de Goede wrote:
>>>> The pins on the Bay Trail SoC have separate input-buffer and output-buffer
>>>> enable bits and a read of the level bit of the value register will always
>>>> return the value from the input-buffer.
>>>>
>>>> The BIOS of a device may configure a pin in output-only mode, only enabling
>>>> the output buffer, and write 1 to the level bit to drive the pin high.
>>>> This 1 written to the level bit will be stored inside the data-latch of the
>>>> output buffer.
>>>>
>>>> But a subsequent read of the value register will return 0 for the level bit
>>>> because the input-buffer is disabled. This causes a read-modify-write as
>>>> done by byt_gpio_set_direction() to write 0 to the level bit, driving the
>>>> pin low!
>>>>
>>>> Before this commit byt_gpio_direction_output() relied on
>>>> pinctrl_gpio_direction_output() to set the direction, followed by a call
>>>> to byt_gpio_set() to apply the selected value. This causes the pin to
>>>> go low between the pinctrl_gpio_direction_output() and byt_gpio_set()
>>>> calls.
>>>>
>>>> Change byt_gpio_direction_output() to directly make the register
>>>> modifications itself instead. Replacing the 2 subsequent writes to the
>>>> value register with a single write.
>>>>
>>>> Note that the pinctrl code does not keep track internally of the direction,
>>>> so not going through pinctrl_gpio_direction_output() is not an issue.
>>>>
>>>> This issue was noticed on a Trekstor SurfTab Twin 10.1. When the panel is
>>>> already on at boot (no external monitor connected), then the i915 driver
>>>> does a gpiod_get(..., GPIOD_OUT_HIGH) for the panel-enable GPIO. The
>>>> temporarily going low of that GPIO was causing the panel to reset itself
>>>> after which it would not show an image until it was turned off and back on
>>>> again (until a full modeset was done on it). This commit fixes this.
>>>
>>> No Fixes tag?
>>
>> It is sort of hard to pin the introduction of this down to a single
>> commit. If I were to guess, I guess the commit introducing the driver?
> 
> Why not? Good guess to me (but I think rather the one which converts GPIO
> driver to pin control).

I will check and add a fixes tag for v2.

> ...
> 
>>>> +	/*
>>>> +	 * Before making any direction modifications, do a check if gpio is set
>>>
>>>> +	 * for direct IRQ.  On baytrail, setting GPIO to output does not make
>>>
>>> Since we change this, perhaps
>>>
>>> 'IRQ.  On baytrail' -> 'IRQ. On Baytrail' (one space and capital 'B').
>>
>> Sure, not sure if that is worth respinning the patch for though,
>> either way let me know.
> 
> I think makes sense to respin. We still have time.

I wasn't talking about timing, more just that it creates extra
work (for me) and if that was just for the capital 'B' thingie it
would not be worth the extra work IMHO, but since we need a v2 for
the fixes tag anyways I'll fix this as well.

>>>> +	 * sense, so let's at least inform the caller before they shoot
>>>> +	 * themselves in the foot.
>>>> +	 */
> 
> ...
> 
>>> Wouldn't be simple below fix the issue?
> 
>> No that will not help the pin is already high, but any reads
>> of the register will return the BYT_LEVEL bit as being low, so
>> the read-write-modify done when setting the direction reads BYT_LEVEL
>> as 0 and writes it back as such.
> 
> So, if I read documentation correctly, there is no means to read back current
> output value if input is disabled. Alas, quite a bad design of hardware.
> And on top of that likely nobody has tested that on non-Windows platform.
> 
>> So your proposal would actually make the problem much worse (and more
>> obvious) if we do the byt_gpio_set() first then for pins which have
>> there input-buffer initially disabled, the value passed to
>> byt_gpio_direction_output will be completely ignored and they will
>> always end up as being driven low.
> 
> What I proposed is not gonna work AFAIU documentation.
> 
> Btw, can we for sake of consistency update direction_input() as well?

Sure, the change for that will be quite small, so shall I out it
in this patch, or do you want a second patch for that?

Regards,

Hans

