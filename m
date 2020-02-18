Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B65B1623D2
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 10:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbgBRJrQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 04:47:16 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40035 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbgBRJrP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 04:47:15 -0500
Received: by mail-wm1-f68.google.com with SMTP id t14so2096339wmi.5
        for <stable@vger.kernel.org>; Tue, 18 Feb 2020 01:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ydn3tpF/5sekW0oL7HEhNkbesQlKmDV2VoZVATXRwQA=;
        b=csq1ijOOOrkOpcqKzzqoejdFHqOlzGTL6zjclfMgc7v6TLTn+FjeUbcAy4hzVGVQdM
         No89MiCF68wOqKXq6vC6NuuIbs8jZzMTlJJjCQuUM1jxihMqxcR3DR93Cpb89AvfmX+M
         DGEo66cqLRROLC1kKEgznp1KdL/CJXDctGU0JfXZImdHPaNCj69F8KKerH+8yo/wS4CA
         K6EIT+XVP8dB9MkW1QNs3uNF6+H5DVEPH/FNnMquV8I1OgfVeSq7puOtj7N9l3zm2DLu
         T6R5auM2Jd4mLo4/Ve7suSSS15HRT2l19qJCwe90X13UfBk+Jx42kX3uSJdPchsbGHyJ
         LPZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ydn3tpF/5sekW0oL7HEhNkbesQlKmDV2VoZVATXRwQA=;
        b=cmLN66a8t0Y5Mz5Ap5/CrFMNKOE9DHeIS+/CouuENceAgLhwEJjhNxRoTH403Rhqph
         Z2fDwNPy0zrJj15nEdInacveNqTkUMnhVe8ZfO0s0Tr0oGeVbJvXikQYBMNujFDmHH3l
         PpzP+JLXRUo/PtvF7oGB1iLdNsm6TB0oaRObSB/uYVj1dhW0GKp+XNbZ4ph+KNglERRX
         mFhST2ZAgO0V0ZCtNozDtLZ5qu1cDs26iBGvXB8CwjMQq2z1rDVGW4EFpRXKe7QOLKrr
         YOagKfIHztmn0LHNruE4byWTay5/EYU1G7zmfeA2G420L2dUvqLK7FFUwT27B8kP+EPM
         5Fpg==
X-Gm-Message-State: APjAAAWpzyADf9o4DPejP7itU6z2b3NXvL8V1M57c1uNU4bkN30655zh
        yP+tmg7H3kmGD+ode3oivhYbao8QeOU=
X-Google-Smtp-Source: APXvYqyJPqysFP65KVz1252bDAB7IzrmoAWm6l0PJM4IbO2W44ySAuzmL+jwOUyYzs+yJSLYzpkeTg==
X-Received: by 2002:a05:600c:22c8:: with SMTP id 8mr2172517wmg.178.1582019232488;
        Tue, 18 Feb 2020 01:47:12 -0800 (PST)
Received: from [192.168.86.34] (cpc89974-aztw32-2-0-cust43.18-1.cable.virginm.net. [86.30.250.44])
        by smtp.googlemail.com with ESMTPSA id x10sm4956307wrv.60.2020.02.18.01.47.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Feb 2020 01:47:10 -0800 (PST)
Subject: Re: [PATCH v2 2/7] nvmem: fix another memory leak in error path
To:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Linus Walleij <linus.walleij@linaro.org>,
        Khouloud Touil <ktouil@baylibre.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        stable@vger.kernel.org
References: <20200218094234.23896-1-brgl@bgdev.pl>
 <20200218094234.23896-3-brgl@bgdev.pl>
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Message-ID: <9519ba1b-17fe-7121-ce00-d940b3de2777@linaro.org>
Date:   Tue, 18 Feb 2020 09:47:09 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200218094234.23896-3-brgl@bgdev.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 18/02/2020 09:42, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> The nvmem struct is only freed on the first error check after its
> allocation and leaked after that. Fix it with a new label.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

looks like 1/7 introduced the bug and 2/7 fixes it.
IMO, you should 1/7 and 2/7 should be single patch.

--srini

> ---
>   drivers/nvmem/core.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
> index b0be03d5f240..c9b3f4047154 100644
> --- a/drivers/nvmem/core.c
> +++ b/drivers/nvmem/core.c
> @@ -343,10 +343,8 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
>   		return ERR_PTR(-ENOMEM);
>   
>   	rval  = ida_simple_get(&nvmem_ida, 0, 0, GFP_KERNEL);
> -	if (rval < 0) {
> -		kfree(nvmem);
> -		return ERR_PTR(rval);
> -	}
> +	if (rval < 0)
> +		goto err_free_nvmem;
>   	if (config->wp_gpio)
>   		nvmem->wp_gpio = config->wp_gpio;
>   	else
> @@ -432,6 +430,8 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
>   	put_device(&nvmem->dev);
>   err_ida_remove:
>   	ida_simple_remove(&nvmem_ida, nvmem->id);
> +err_free_nvmem:
> +	kfree(nvmem);
>   
>   	return ERR_PTR(rval);
>   }
> 
