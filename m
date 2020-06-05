Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 479BE1EFB7A
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgFEOdy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:33:54 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:60843 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728013AbgFEOdy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 10:33:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591367632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UnXpqpJmhsoGN5vwHlR9MCzTruzIUpnFGVXn1tVsFuM=;
        b=Mxnr9w42gdtZZTOYLApVKTrKQb2nOmPpSPYPD0KDhV+7WqLnghdoRHpgvMlloEj8GnRNqj
        yVS1JlGtZ/enEJsMmgLRMS20JLqOFO1FwS4CDHDZ3OOmjJPMgwY7TAHkdNGkEs+eOS6aTN
        KRB9572/hD9ZhikSVB4Nr6Og+u2lHdw=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-Cr0RIS5WNYywzNOouhCKGg-1; Fri, 05 Jun 2020 10:33:50 -0400
X-MC-Unique: Cr0RIS5WNYywzNOouhCKGg-1
Received: by mail-ej1-f71.google.com with SMTP id r11so3698411ejd.1
        for <stable@vger.kernel.org>; Fri, 05 Jun 2020 07:33:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UnXpqpJmhsoGN5vwHlR9MCzTruzIUpnFGVXn1tVsFuM=;
        b=U9KzX7PryOUyohW5sMrebEoAT/+VCM8sKTS0JxmOszapixrdSkolFp6ZfMcDrvk8E/
         7kRNlVeKaihFJmD8dDaic2uKddw4ZK9ayxptc2Xg744qiaz1LaM/xXu8oPtDsvjRVuk/
         HaiJ+ggpMjyWt8RaqlLsmJFGObyc1NZvn2/1mTvYgkLZCEqYdChTzvrYEq/+Tajdu5IX
         AugsbTBHvwhrAbu649tQlkPQx08IC3BGr6V+YXCr36HPDdWyey4JvJDa37nPClBKlUQC
         Hm8uP771jPCx9nN5+TAdWIhAmYII2FWLqyvprkBld1am9gOJ3XZBp1nMCyQTeCtOc8xl
         XxYw==
X-Gm-Message-State: AOAM531nRs23FK1ejbhCoL9Z2DH87O5OkRMEAxIxNknSsz5T0Dx9dHfv
        EGvPU14yXbp6LBSuY5eg3dJsM+i+xUKCFZ4vSbsq+l/jimNy7jOVeHHf5gTdl1w16Uo1LqA6nw3
        D0nhM+jmBhqkMVLkC
X-Received: by 2002:a17:906:4554:: with SMTP id s20mr8783717ejq.241.1591367629239;
        Fri, 05 Jun 2020 07:33:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxPmTQAV1XuXHtuL/qMSpWO2BScpZajU1f7rMoqZ9XHo3qWMvt1jv1U5k9HlA8ZVtwsZNScZA==
X-Received: by 2002:a17:906:4554:: with SMTP id s20mr8783698ejq.241.1591367628950;
        Fri, 05 Jun 2020 07:33:48 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-d2ea-f29d-118b-24dc.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:d2ea:f29d:118b:24dc])
        by smtp.gmail.com with ESMTPSA id o7sm230792edj.52.2020.06.05.07.33.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2020 07:33:48 -0700 (PDT)
Subject: Re: [PATCH] pinctrl: baytrail: Fix pin being driven low for a while
 on gpiod_get(..., GPIOD_OUT_HIGH)
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        linux-gpio@vger.kernel.org, stable@vger.kernel.org
References: <20200602122130.45630-1-hdegoede@redhat.com>
 <20200602152317.GI2428291@smile.fi.intel.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <ba931618-9259-aca0-142c-c1dfb67e737e@redhat.com>
Date:   Fri, 5 Jun 2020 16:33:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200602152317.GI2428291@smile.fi.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 6/2/20 5:23 PM, Andy Shevchenko wrote:
> On Tue, Jun 02, 2020 at 02:21:30PM +0200, Hans de Goede wrote:
>> The pins on the Bay Trail SoC have separate input-buffer and output-buffer
>> enable bits and a read of the level bit of the value register will always
>> return the value from the input-buffer.
>>
>> The BIOS of a device may configure a pin in output-only mode, only enabling
>> the output buffer, and write 1 to the level bit to drive the pin high.
>> This 1 written to the level bit will be stored inside the data-latch of the
>> output buffer.
>>
>> But a subsequent read of the value register will return 0 for the level bit
>> because the input-buffer is disabled. This causes a read-modify-write as
>> done by byt_gpio_set_direction() to write 0 to the level bit, driving the
>> pin low!
>>
>> Before this commit byt_gpio_direction_output() relied on
>> pinctrl_gpio_direction_output() to set the direction, followed by a call
>> to byt_gpio_set() to apply the selected value. This causes the pin to
>> go low between the pinctrl_gpio_direction_output() and byt_gpio_set()
>> calls.
>>
>> Change byt_gpio_direction_output() to directly make the register
>> modifications itself instead. Replacing the 2 subsequent writes to the
>> value register with a single write.
>>
>> Note that the pinctrl code does not keep track internally of the direction,
>> so not going through pinctrl_gpio_direction_output() is not an issue.
>>
>> This issue was noticed on a Trekstor SurfTab Twin 10.1. When the panel is
>> already on at boot (no external monitor connected), then the i915 driver
>> does a gpiod_get(..., GPIOD_OUT_HIGH) for the panel-enable GPIO. The
>> temporarily going low of that GPIO was causing the panel to reset itself
>> after which it would not show an image until it was turned off and back on
>> again (until a full modeset was done on it). This commit fixes this.
> 
> No Fixes tag?

It is sort of hard to pin the introduction of this down to a single
commit. If I were to guess, I guess the commit introducing the driver?

>> Cc: stable@vger.kernel.org
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> 
> ...
> 
>> +static void byt_gpio_direct_irq_check(struct intel_pinctrl *vg,
>> +				      unsigned int offset)
>> +{
>> +	void __iomem *conf_reg = byt_gpio_reg(vg, offset, BYT_CONF0_REG);
>> +
>> +	/*
>> +	 * Before making any direction modifications, do a check if gpio is set
> 
>> +	 * for direct IRQ.  On baytrail, setting GPIO to output does not make
> 
> Since we change this, perhaps
> 
> 'IRQ.  On baytrail' -> 'IRQ. On Baytrail' (one space and capital 'B').

Sure, not sure if that is worth respinning the patch for though,
either way let me know.

>> +	 * sense, so let's at least inform the caller before they shoot
>> +	 * themselves in the foot.
>> +	 */
>> +	if (readl(conf_reg) & BYT_DIRECT_IRQ_EN)
>> +		dev_info_once(vg->dev, "Potential Error: Setting GPIO with direct_irq_en to output");
>> +}
> 
> ...
> 
>>   static int byt_gpio_direction_output(struct gpio_chip *chip,
>>   				     unsigned int offset, int value)
>>   {
>> -	int ret = pinctrl_gpio_direction_output(chip->base + offset);
>> +	struct intel_pinctrl *vg = gpiochip_get_data(chip);
>> +	void __iomem *val_reg = byt_gpio_reg(vg, offset, BYT_VAL_REG);
>> +	unsigned long flags;
>> +	u32 reg;
>>   
>> -	if (ret)
>> -		return ret;
>> +	raw_spin_lock_irqsave(&byt_lock, flags);
>>   
>> -	byt_gpio_set(chip, offset, value);
>> +	byt_gpio_direct_irq_check(vg, offset);
>>   
>> +	reg = readl(val_reg);
>> +	reg &= ~BYT_DIR_MASK;
>> +	if (value)
>> +		reg |= BYT_LEVEL;
>> +	else
>> +		reg &= ~BYT_LEVEL;
>> +
>> +	writel(reg, val_reg);
>> +
>> +	raw_spin_unlock_irqrestore(&byt_lock, flags);
>>   	return 0;
>>   }
> 
> Wouldn't be simple below fix the issue?
> 
> @@ -1171,14 +1171,10 @@ static int byt_gpio_direction_input(struct gpio_chip *chip, unsigned int offset)
>   static int byt_gpio_direction_output(struct gpio_chip *chip,
>                                       unsigned int offset, int value)
>   {
> -       int ret = pinctrl_gpio_direction_output(chip->base + offset);
> -
> -       if (ret)
> -               return ret;
> -
> +       /* Set value first to avoid a glitch */
>          byt_gpio_set(chip, offset, value);
>   
> -       return 0;
> +       return pinctrl_gpio_direction_output(chip->base + offset);
>   }

No that will not help the pin is already high, but any reads
of the register will return the BYT_LEVEL bit as being low, so
the read-write-modify done when setting the direction reads BYT_LEVEL
as 0 and writes it back as such.

So your proposal would actually make the problem much worse (and more
obvious) if we do the byt_gpio_set() first then for pins which have
there input-buffer initially disabled, the value passed to
byt_gpio_direction_output will be completely ignored and they will
always end up as being driven low.

Regards,

Hans

