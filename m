Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 263DC2023E5
	for <lists+stable@lfdr.de>; Sat, 20 Jun 2020 15:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbgFTNJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Jun 2020 09:09:28 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:21574 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728064AbgFTNJ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Jun 2020 09:09:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592658565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+ypfIEqXxI1rZS8xHo7HMDMiiKRVrKIkJdE8+KOsLcw=;
        b=PZ/XLvxgsqVv2Pl5JWb/3DknTKCYpiqASAAGt4kpWfePu1dLF9sJBCnK0hhcuDpFiBNAbd
        eE6TZRm2DviwdXNKS5E040QTFOf/dUOuaK0Dkkg/trDxqRncPT5BtQM+2euu1x7j8VhPhn
        Znibo0Vw1W/BTWX+W4fG99n/qlFahbY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-hI_w0zEcOq2GlTeWac5b3w-1; Sat, 20 Jun 2020 09:09:23 -0400
X-MC-Unique: hI_w0zEcOq2GlTeWac5b3w-1
Received: by mail-wr1-f72.google.com with SMTP id w4so6444004wrl.13
        for <stable@vger.kernel.org>; Sat, 20 Jun 2020 06:09:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+ypfIEqXxI1rZS8xHo7HMDMiiKRVrKIkJdE8+KOsLcw=;
        b=NUvXeigAb8qupNCKylVG7VSPav7w3zCZ8lYMaV6S3YxjPcRSJdIwd+cI5Pp8ZcOv1Z
         fdKN+Qkdih/hXv/l4sDVJlciF8i3CV2MELKYooAPaQhGB32tShrxfIwHXb3kyyxxcgFg
         z+mSABFXYUi7lKnQZlHW06DX8rD7a/uzu0sxH3rqyc7Vg0YaxzVngY0rCU2p0qi7FFD/
         /hwq2Pph93b60gGFHqklAc/78YH1M1YqL2j3+LM82CJtcZXroqHXlCbQrgwkXoxsA/Kg
         3Fa9v2eSea/pTXzz3OCjC9As2EiXRQEOIDOTO3S0hbLUnSgAcqfc4K0CvUWe/CzGm+4v
         dprA==
X-Gm-Message-State: AOAM533CSdRfSioICP3WGxQI3fgznh9yhL4psiAaXeHlZuDwvegb5WYk
        RQGL8iyaWIPB/DkOeaoVK6P3LzIrudkt3sa5QLQplBr9bBX5t0U2QxL3nglhMru9NJeoZA3ia+q
        r3RmGx+ccM9AZCZtg
X-Received: by 2002:a5d:4710:: with SMTP id y16mr9415203wrq.189.1592658562260;
        Sat, 20 Jun 2020 06:09:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwq+btKWtdDTjyPLMo90lzn0ZVOTGxbfEq8AiITy2GCUELOFoHZ7fVrfLR8ewF4Pkf98z0RBg==
X-Received: by 2002:a5d:4710:: with SMTP id y16mr9415187wrq.189.1592658562002;
        Sat, 20 Jun 2020 06:09:22 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-d2ea-f29d-118b-24dc.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:d2ea:f29d:118b:24dc])
        by smtp.gmail.com with ESMTPSA id y17sm10918444wrd.58.2020.06.20.06.09.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Jun 2020 06:09:21 -0700 (PDT)
Subject: Re: [PATCH v2] pinctrl: baytrail: Fix pin being driven low for a
 while on gpiod_get(..., GPIOD_OUT_HIGH)
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org, stable@vger.kernel.org
References: <20200606093150.32882-1-hdegoede@redhat.com>
 <20200608105953.GC247495@lahna.fi.intel.com>
 <20200615100345.GV2428291@smile.fi.intel.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <3c7d2097-6ade-0568-4170-94805589cf46@redhat.com>
Date:   Sat, 20 Jun 2020 15:09:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200615100345.GV2428291@smile.fi.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 6/15/20 12:03 PM, Andy Shevchenko wrote:
> On Mon, Jun 08, 2020 at 01:59:53PM +0300, Mika Westerberg wrote:
>> On Sat, Jun 06, 2020 at 11:31:50AM +0200, Hans de Goede wrote:
>>> The pins on the Bay Trail SoC have separate input-buffer and output-buffer
>>> enable bits and a read of the level bit of the value register will always
>>> return the value from the input-buffer.
>>>
>>> The BIOS of a device may configure a pin in output-only mode, only enabling
>>> the output buffer, and write 1 to the level bit to drive the pin high.
>>> This 1 written to the level bit will be stored inside the data-latch of the
>>> output buffer.
>>>
>>> But a subsequent read of the value register will return 0 for the level bit
>>> because the input-buffer is disabled. This causes a read-modify-write as
>>> done by byt_gpio_set_direction() to write 0 to the level bit, driving the
>>> pin low!
>>>
>>> Before this commit byt_gpio_direction_output() relied on
>>> pinctrl_gpio_direction_output() to set the direction, followed by a call
>>> to byt_gpio_set() to apply the selected value. This causes the pin to
>>> go low between the pinctrl_gpio_direction_output() and byt_gpio_set()
>>> calls.
>>>
>>> Change byt_gpio_direction_output() to directly make the register
>>> modifications itself instead. Replacing the 2 subsequent writes to the
>>> value register with a single write.
>>>
>>> Note that the pinctrl code does not keep track internally of the direction,
>>> so not going through pinctrl_gpio_direction_output() is not an issue.
>>>
>>> This issue was noticed on a Trekstor SurfTab Twin 10.1. When the panel is
>>> already on at boot (no external monitor connected), then the i915 driver
>>> does a gpiod_get(..., GPIOD_OUT_HIGH) for the panel-enable GPIO. The
>>> temporarily going low of that GPIO was causing the panel to reset itself
>>> after which it would not show an image until it was turned off and back on
>>> again (until a full modeset was done on it). This commit fixes this.
>>>
>>> This commit also updates the byt_gpio_direction_input() to use direct
>>> register accesses instead of going through pinctrl_gpio_direction_input(),
>>> to keep it consistent with byt_gpio_direction_output().
>>>
>>> Note for backporting, this commit depends on:
>>> commit e2b74419e5cc ("pinctrl: baytrail: Replace WARN with dev_info_once
>>> when setting direct-irq pin to output")
>>>
>>> Cc: stable@vger.kernel.org
>>> Fixes: 86e3ef812fe3 ("pinctrl: baytrail: Update gpio chip operations")
>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>
>> Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> Pushed to my review and testing queue, thanks!

I'm not seeing it here:

https://git.kernel.org/pub/scm/linux/kernel/git/pinctrl/intel.git/log/?h=review-andy

Did you perhaps forgot to push it ?

Regards,

Hans

