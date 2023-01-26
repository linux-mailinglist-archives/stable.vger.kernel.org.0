Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAA4267C6A2
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 10:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236237AbjAZJIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 04:08:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbjAZJIM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 04:08:12 -0500
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2443EC40;
        Thu, 26 Jan 2023 01:08:11 -0800 (PST)
Received: by mail-ed1-f53.google.com with SMTP id y19so1272499edc.2;
        Thu, 26 Jan 2023 01:08:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hMr0xC0YhrqgD1viBDPP26FWvFPbPdmQWji8YbWNKZM=;
        b=0X8L9XYz/Rmg2XuT+4nhIcHlumh9Tktx6U7JNIpS4wwqm/KeFNC1jX30GKxeEmWXYy
         /C66Nc7/+kNypk1zDQJqEbidgd6FmCzFns3ctM7ZNMqDxRNOSeMFdg/BDwV+okwfrnz0
         xSYT6M2oS9S0q4KSP39H5+id18BMLpl8aNyzDYXsMyuWMbHlZNz2PfVXiyG00FNS15Rc
         qTwan3+LoROfMzqALPvfRJJF6OJc92zpA02i6W3iUXd/HX6x/zqyI63NIIYf4i+xYaAk
         K+Z5larS6SWLLLOIXxkiLJRiuDlfAnXZqFwUQyXwi6SdlP7V00QfKYN4c0vpLP2/FwOl
         VNSw==
X-Gm-Message-State: AFqh2kr6wPP9B6K1mCd1MIiWWeSfpXZNUTnyWdP4FmXBGhjFp7DtrXv+
        C6ccmfndrmzNcCs9LVkbSQ0DSoW0Xkg=
X-Google-Smtp-Source: AMrXdXs7LccmnB0bZcinEZc6Pyw0tuNtDY8p4RYr8ArU3wqk/0+yiT/jtfRNjdsb9EbsAtxehuiZ3g==
X-Received: by 2002:a05:6402:524f:b0:49e:498c:5e16 with SMTP id t15-20020a056402524f00b0049e498c5e16mr43666895edd.30.1674724089094;
        Thu, 26 Jan 2023 01:08:09 -0800 (PST)
Received: from ?IPV6:2a0b:e7c0:0:107::aaaa:49? ([2a0b:e7c0:0:107::aaaa:49])
        by smtp.gmail.com with ESMTPSA id y11-20020a50eb0b000000b00467481df198sm434295edp.48.2023.01.26.01.08.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Jan 2023 01:08:08 -0800 (PST)
Message-ID: <edcf26d4-64a0-04ea-435c-17d9efde7dd9@kernel.org>
Date:   Thu, 26 Jan 2023 10:08:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] fbcon: Check font dimension limits
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc:     Daniel Vetter <daniel@ffwll.ch>, Helge Deller <deller@gmx.de>,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sanan Hasanov <sanan.hasanov@knights.ucf.edu>
References: <20230126004911.869923511@ens-lyon.org>
 <20230126004921.616264824@ens-lyon.org> <Y9IvBoAbmh27xl4B@kroah.com>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <Y9IvBoAbmh27xl4B@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26. 01. 23, 8:43, Greg KH wrote:
>> --- linux-6.0.orig/drivers/video/fbdev/core/fbcon.c
>> +++ linux-6.0/drivers/video/fbdev/core/fbcon.c
>> @@ -2489,9 +2489,12 @@ static int fbcon_set_font(struct vc_data
>>   	    h > FBCON_SWAP(info->var.rotate, info->var.yres, info->var.xres))
>>   		return -EINVAL;
>>   
>> +	if (font->width > 32 || font->height > 32)
>> +		return -EINVAL;
>> +
>>   	/* Make sure drawing engine can handle the font */
>> -	if (!(info->pixmap.blit_x & (1 << (font->width - 1))) ||
>> -	    !(info->pixmap.blit_y & (1 << (font->height - 1))))
>> +	if (!(info->pixmap.blit_x & (1U << (font->width - 1))) ||
>> +	    !(info->pixmap.blit_y & (1U << (font->height - 1))))
> 
> Are you sure this is still needed with the above check added?  If so,
> why?  What is the difference in the compiled code?

For font->{width,height} == 32, definitely. IMO, 1 << 31 is undefined as 
1 << 31 cannot be represented by an (signed) int.

-- 
js
suse labs

