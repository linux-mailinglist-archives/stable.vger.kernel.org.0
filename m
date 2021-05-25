Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1947390B04
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 23:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbhEYVHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 17:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbhEYVHu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 17:07:50 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564F7C061574;
        Tue, 25 May 2021 14:06:19 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id e8so13534825qvp.7;
        Tue, 25 May 2021 14:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KKltMnhFLrCpY/eDQfioHpnr9z2wjAsB6wew67y1N2k=;
        b=AaBMnHHhqf5Lh2anB4fUBCt1p6FelhrtNzNeUcn1T2Yg9YFlWJ8ayjDVfHzmwD6uLd
         6gnDNHwgB2PRiZ6vvlz1vEYWf/DVzQj0pd3ZUhNEhe/owtlp9qiSHNIuigL2u9hh7XRy
         0R5q5zGKv5w8GgE++laxrQAvyKuu08fORGWZZZrOUWmHJOtPtPpw306CHduocoC+n2Hy
         4LiBn0spP0dgLP7rFKfrxZp0kgOLLFxZe2Cg1r+Yo5D7KZL9OaYIJk5l3wOkGw5X40OU
         z6x7ve/cFRvRjCjwqF03rP398gOo+XrgJeIh/zt3hAbniE/ipT9otlH4BGiBVL07OOai
         lAmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KKltMnhFLrCpY/eDQfioHpnr9z2wjAsB6wew67y1N2k=;
        b=bol3NkXjupVYo6ZKUrwBaTF4bpVuJRTH9ls/pqkAYMZoIOmmYRgmELzskA82KKd4+m
         nQ1tgM8o4ouaTRsEvwNmtwh+XyNclhx4dwoBTcjisaj2k36UjRQ1qK/aRjXUj4icqnp8
         CT6orAn295yS9loqcCWEsAU+wJ0+jRXrlZXj5Bl28+50LYgdkYJwXKJ3rj6V/iN9vuYh
         63XsqzZfhlsf6RKHAXb6rirFRlqx2Ov1zbawSQtpX6EUaCF409JLEJ8pQYCvF80uDrRh
         7wx2OH+VVKdWKI3Nk+SKIG1UksXKpsXtchK/9zhvlDqgNCx7M3H5R/P9orL3mvNa4bPG
         icuw==
X-Gm-Message-State: AOAM532vGf+EfwGojglNyttQIMaaelRT8kohK5kAXgkDyCX2w+VUycOr
        8eUO0ZTu1YgRbwor5L/fBQU=
X-Google-Smtp-Source: ABdhPJyQQ23HsfwTABAbHgMxHk4Y39ECTDTvAE8b2k+nZ6tRtejdNmA2JQIJ9buk+2rimmSn45WsjQ==
X-Received: by 2002:ad4:478b:: with SMTP id z11mr34302371qvy.1.1621976778526;
        Tue, 25 May 2021 14:06:18 -0700 (PDT)
Received: from ?IPv6:2804:14c:125:811b:fbbc:3360:40c4:fb64? ([2804:14c:125:811b:fbbc:3360:40c4:fb64])
        by smtp.gmail.com with ESMTPSA id j16sm234796qtr.27.2021.05.25.14.06.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 May 2021 14:06:18 -0700 (PDT)
Subject: Re: [PATCH 4.4 28/31] video: hgafb: fix potential NULL pointer
 dereference
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ferenc Bakonyi <fero@drama.obuda.kando.hu>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
References: <20210524152322.919918360@linuxfoundation.org>
 <20210524152323.833888129@linuxfoundation.org>
 <20210525204704.GA12631@duo.ucw.cz>
From:   Igor Torrente <igormtorrente@gmail.com>
Message-ID: <2a22a7ec-3a47-92dc-5052-c9e7bb2d604b@gmail.com>
Date:   Tue, 25 May 2021 18:06:15 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210525204704.GA12631@duo.ucw.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Pavel,

On 5/25/21 5:47 PM, Pavel Machek wrote:
> Hi!
> 
>> From: Igor Matheus Andrade Torrente <igormtorrente@gmail.com>
>>
>> commit dc13cac4862cc68ec74348a80b6942532b7735fa upstream.
>>
>> The return of ioremap if not checked, and can lead to a NULL to be
>> assigned to hga_vram. Potentially leading to a NULL pointer
>> dereference.
>>
>> The fix adds code to deal with this case in the error label and
>> changes how the hgafb_probe handles the return of hga_card_detect.
> 
> This will break hgafb completely, right? And crash system without hga
> card as a bonus.
> 
>> +++ b/drivers/video/fbdev/hgafb.c
>> @@ -285,6 +285,8 @@ static int hga_card_detect(void)
>>   	hga_vram_len  = 0x08000;
>>   
>>   	hga_vram = ioremap(0xb0000, hga_vram_len);
>> +	if (!hga_vram)
>> +		return -ENOMEM;
>>   
>>   	if (request_region(0x3b0, 12, "hgafb"))
>>   		release_io_ports = 1;
>> @@ -344,13 +346,18 @@ static int hga_card_detect(void)
>>   			hga_type_name = "Hercules";
>>   			break;
>>   	}
>> -	return 1;
>> +	return 0;
> 
> Ok, so calling convention is now "0 means detected".
> 
> 
>> @@ -548,13 +555,11 @@ static struct fb_ops hgafb_ops = {
>>   static int hgafb_probe(struct platform_device *pdev)
>>   {
>>   	struct fb_info *info;
>> +	int ret;
> ...
>> +	ret = hga_card_detect();
>> +	if (!ret)
>> +		return ret;
>>   
>>   	printk(KERN_INFO "hgafb: %s with %ldK of memory detected.\n",
>>   		hga_type_name, hga_vram_len/1024);
>>
> 
> If the card is detected, 0 is returned, !0 is true, and we abort
> detection....

Yes, you are right! There's a patch that fixes it:

https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/commit/?h=char-misc-linus&id=02625c965239b71869326dd0461615f27307ecb3

As far as I know, this patch should be queue up soon to all stable branches.

Greg should have more details about it.

> 
> 								Pavel
> 								
> Signed-off-by: Pavel Machek <pavel@denx.de>
> 
> diff --git a/drivers/video/fbdev/hgafb.c b/drivers/video/fbdev/hgafb.c
> index c35f217db53f..d6a95ea49c64 100644
> --- a/drivers/video/fbdev/hgafb.c
> +++ b/drivers/video/fbdev/hgafb.c
> @@ -282,7 +282,7 @@ static int hga_card_detect(void)
>   	void __iomem *p, *q;
>   	unsigned short p_save, q_save;
>   
> -	hga_vram_len  = 0x08000;
> +	hga_vram_len = 0x08000;
>   
>   	hga_vram = ioremap(0xb0000, hga_vram_len);
>   	if (!hga_vram)
> @@ -558,7 +558,7 @@ static int hgafb_probe(struct platform_device *pdev)
>   	int ret;
>   
>   	ret = hga_card_detect();
> -	if (!ret)
> +	if (ret)
>   		return ret;
>   
>   	printk(KERN_INFO "hgafb: %s with %ldK of memory detected.\n",
> 
> 

Thanks,
---
Igor M. A. Torrente
