Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF466382C10
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 14:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236990AbhEQM3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 08:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbhEQM3A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 08:29:00 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EBA2C061573;
        Mon, 17 May 2021 05:27:43 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id w9so2930092qvi.13;
        Mon, 17 May 2021 05:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RrMgSrZtTqdB/wlv0id/9NlOUPd01Z7kAGWKqnT2c2M=;
        b=CctOlq+UkKn18QqKAOdc7VqJDwwJKN9HU/A5tTPZ0EUkYGQMbFanD0RNwVHW2f6R4E
         7fGATCP3I/aegDtzmOBa5y7HYnBAOTRIl+10jhJuS7FOhQbBKJ3dZOOA6X3ITygKqzls
         GYKmF56nNhO+08TdkpRANu9VXaTwgiFhOUXy8+b44TjtqJNCthTAiLbF/r709SBk+TTr
         JFfUCWgDEX967xOAuQfbJGZ4in3xZj/3kE8Mf/9i0HFQ65dEhwLg/3wrcJKdfUh8FmVT
         hxlDPhEvB3cXIZu0UWRwRNkFRYiWjfn70i3oucULeBS2i2/4Qn1sRdt3WfdmU+uTZ/f+
         PWNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RrMgSrZtTqdB/wlv0id/9NlOUPd01Z7kAGWKqnT2c2M=;
        b=o0mOKwYepWVVpxPVVWFgoPaBZbfTrIsGxkrg/g/y8NEukfd3Sm3jGA8VJzzbc6BGXc
         DYTumsMOoVyJSPRDVZvNZdluPAxmeUhbmqlK6g9pxDY15LbtCS0hqTYT5tWMN39Tu6nJ
         BYUrkcagLw6weSS33nn7OKNnvBNq87qwrQti34z+LV6zqA5d45Yq5lzFrFjGluSXrkkk
         CN+WNfro4jJMRgyUGtbLuj2omndjJWFNfK8DSAhsoo8q3A1CdJmq8pZPKF2ibuBJwYFG
         N14jhdmq4u1qfh+XVAdPvWu9WDygAAgXa0cyhJYCunxYx3suvhyfd0XpnEuJIg8iNUqs
         wxMQ==
X-Gm-Message-State: AOAM530ciHkAjoKLfSTKclWUICNuAVLZx7SmAT7uS9qPJSoK8bcg04hf
        VtHrez+i2bnO3WAg/URPHt44nRWh7r3NABm3
X-Google-Smtp-Source: ABdhPJzM+6xSTMZ2jK4banMxGU90aLBTrZTJZYJp2Lr/pLBs4nDcAdGVJO5Aq8VNiSxT+2/N1fJnug==
X-Received: by 2002:a05:6214:87:: with SMTP id n7mr16082560qvr.1.1621254462149;
        Mon, 17 May 2021 05:27:42 -0700 (PDT)
Received: from ?IPv6:2804:14c:125:811b::1003? ([2804:14c:125:811b::1003])
        by smtp.gmail.com with ESMTPSA id 10sm10377983qka.23.2021.05.17.05.27.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 05:27:41 -0700 (PDT)
Subject: Re: [PATCH] video: hgafb: correctly handle card detect failure during
 probe
To:     Anirudh Rayabharam <mail@anirudhrb.com>,
        Ferenc Bakonyi <fero@drama.obuda.kando.hu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        kernel test robot <oliver.sang@intel.com>,
        stable <stable@vger.kernel.org>,
        linux-nvidia@lists.surfsouth.com, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210516192714.25823-1-mail@anirudhrb.com>
From:   Igor Torrente <igormtorrente@gmail.com>
Message-ID: <2b945eaa-4288-1601-3f1a-60f2ceaa1ea7@gmail.com>
Date:   Mon, 17 May 2021 09:27:38 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210516192714.25823-1-mail@anirudhrb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 5/16/21 4:27 PM, Anirudh Rayabharam wrote:
> The return value of hga_card_detect() is not properly handled causing
> the probe to succeed even though hga_card_detect() failed. Since probe
> succeeds, hgafb_open() can be called which will end up operating on an
> unmapped hga_vram. This results in an out-of-bounds access as reported
> by kernel test robot [1].
> 
> To fix this, correctly detect failure of hga_card_detect() by checking
> for a non-zero error code.
> 
> [1]: https://lore.kernel.org/lkml/20210516150019.GB25903@xsang-OptiPlex-9020/
> 
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Fixes: dc13cac4862c ("video: hgafb: fix potential NULL pointer dereference")
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
> ---
>   drivers/video/fbdev/hgafb.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/video/fbdev/hgafb.c b/drivers/video/fbdev/hgafb.c
> index cc8e62ae93f6..bd3d07aa4f0e 100644
> --- a/drivers/video/fbdev/hgafb.c
> +++ b/drivers/video/fbdev/hgafb.c
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

In fact, this return isn't being properly handled. Thanks for fix it!

Reviewed-by: Igor Matheus Andrade Torrente <igormtorrente@gmail.com>
