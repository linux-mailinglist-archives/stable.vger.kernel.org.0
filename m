Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 261F53623FE
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 17:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235563AbhDPPdD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 11:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343766AbhDPPdB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 11:33:01 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08BDC061574
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 08:32:36 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id m13so28196670oiw.13
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 08:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cUy1g4QHZ9Uoi3JFwzdwkw5IE4YYW7bRligC7q6r/iA=;
        b=dpx7N20mLDeyyJCZ7U2QnMAenM4wdt794ArcmVI0G5iWG03wFiV7gvzebFTOqpBvZU
         w2bU+3pxxlnJyWFBLrbHKb/S/rpMt/6osAkhPmLgHRmPfA4DFdNBJWMW8VzgXMwKIP23
         wZGfZowu5n8qQGmgl6LILU6t3zd2ixJZrlit4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cUy1g4QHZ9Uoi3JFwzdwkw5IE4YYW7bRligC7q6r/iA=;
        b=JO7jlMsC5syIohR1dvGQi9h0j9oIsN5ArjShEE8+K+O6UvoTist8RmkJqY+0AGOTN6
         sgvn87DyQtzIjD6rQDeYj/lVFH9V+MEDkCcjMGHYnEwlYu0rWmK3+HqeoJq8h4LY/pzF
         e1091igVR6ZnIhAmXt2W2T57ybPqLzi70cOa8+6RvzUmXtuKE+kCW1oib/k9rjwBoKWH
         8hjt9Ypj6HLDce8bfkl/StQCpK4Zepint0Lzk83RonzQbiGui7C6SbSmKlvcECZKMvz3
         65qQQvkCKirrjM36qO6MVkt3tGbrtVBseOXT6P9nZO7Dqg0J6fHzX4AeucSM2ZHL02Fo
         VR/w==
X-Gm-Message-State: AOAM530SS7GTslmPan2DnQMkIuv+qUFLtmChvJEXVHX2FnkpWAd4liBq
        BqNGDrJRBWuiR/m/GRuyAchqSw==
X-Google-Smtp-Source: ABdhPJwwc1S8GCvwkvzp6vrQTd49tBxpyI7unFuJ/eifspM6hcm50DwjGokd3hdfSv5OhyyM50YUZw==
X-Received: by 2002:a54:4494:: with SMTP id v20mr1906955oiv.112.1618587156298;
        Fri, 16 Apr 2021 08:32:36 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id h59sm1467813otb.29.2021.04.16.08.32.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Apr 2021 08:32:35 -0700 (PDT)
Subject: Re: [PATCH] usbip: Fix incorrect double assignment to udc->ud.tcp_rx
To:     Tom Seewald <tseewald@gmail.com>, stable@vger.kernel.org
Cc:     --reply-to=20210410004930.17411-1-tseewald@gmail.com,
        Colin Ian King <colin.king@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210412185902.27755-1-tseewald@gmail.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <f3e734e4-afc2-4d7c-8d02-714935b45764@linuxfoundation.org>
Date:   Fri, 16 Apr 2021 09:32:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210412185902.27755-1-tseewald@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/12/21 12:59 PM, Tom Seewald wrote:
> commit 9858af27e69247c5d04c3b093190a93ca365f33d upstream.
> 
> Currently udc->ud.tcp_rx is being assigned twice, the second assignment
> is incorrect, it should be to udc->ud.tcp_tx instead of rx. Fix this.
> 
> Fixes: 46613c9dfa96 ("usbip: fix vudc usbip_sockfd_store races leading to gpf")
> Acked-by: Shuah Khan <skhan@linuxfoundation.org>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Cc: stable <stable@vger.kernel.org>
> Addresses-Coverity: ("Unused value")
> Link: https://lore.kernel.org/r/20210311104445.7811-1-colin.king@canonical.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Tom Seewald <tseewald@gmail.com>
> ---
>   drivers/usb/usbip/vudc_sysfs.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/usbip/vudc_sysfs.c b/drivers/usb/usbip/vudc_sysfs.c
> index f44d98eeb36a..51cc5258b63e 100644
> --- a/drivers/usb/usbip/vudc_sysfs.c
> +++ b/drivers/usb/usbip/vudc_sysfs.c
> @@ -187,7 +187,7 @@ static ssize_t store_sockfd(struct device *dev,
>   
>   		udc->ud.tcp_socket = socket;
>   		udc->ud.tcp_rx = tcp_rx;
> -		udc->ud.tcp_rx = tcp_tx;
> +		udc->ud.tcp_tx = tcp_tx;
>   		udc->ud.status = SDEV_ST_USED;
>   
>   		spin_unlock_irq(&udc->ud.lock);
> 

Greg,

Please pick this up for 4.9 and 4.14

thanks,
-- Shuah
