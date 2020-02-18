Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F488162403
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 10:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbgBRJ4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 04:56:19 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39638 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbgBRJ4S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 04:56:18 -0500
Received: by mail-wm1-f65.google.com with SMTP id c84so2128838wme.4
        for <stable@vger.kernel.org>; Tue, 18 Feb 2020 01:56:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UdH2WwRjeP0392FSfzUeJpWFNKo0z7G6MGSSmZM+wnw=;
        b=JkGobR7ne7hE4lO8Y9G7F0mwGgXu/l74bR/V2dOzMUri9Jndvty2pi+NIGotqZmZ8N
         HBo97sQj1xBSQSYgD6BbGL3uQe26Q/j1SOWQOxIzG+pfQb8vH1l4UFQ3JnWANsCss2xp
         l03JegdpvjVjSqzYW43xqrtJgsoFn1uRaRzCabyggFPT8pt6oNXGbn1i6/SKE0/2BDPT
         BDmIp2NIjiUUtLycIG38oQH0Nv+X0gIASUrKcMtn3hsU7X/ZabQiQ8nEbYxHMFbJ734V
         FyTj1fNiudVfEVUUGcEfCu6zsPo6BFhbzrQLV8eTj5iXyrei+J1uxqEyJ7aS8tteAG5c
         3HhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UdH2WwRjeP0392FSfzUeJpWFNKo0z7G6MGSSmZM+wnw=;
        b=q6ghNTDGRTXS2UYHdB6qrAXatjBECz4z7yK5YTtFpUreJkkmrpr1sht1UwAytfzdJu
         p/u7mMw2vpslHj/lnVaPGBIq0dc7xcZumdJo6j9hg5hNpiJmvtCedfErR4z1VgRZenEl
         8K1B78Ze38OB6/wLye7MsemMlMgkMTu8Kwwb0dIg9GL3aug4e/NnjOec7kc8BwzdQoYH
         1desDm40zomZnPEzbd4PbFf+eDATNrqZx6ssBF/OVJklP5w8HEloghImUCpBErShomK5
         j3ND81OvxrZj/R6921vgMs9r/ctPvs2bl0E2yuPsQzASkLQSMvIYCJOKTdkCcYEK5LEv
         8O+A==
X-Gm-Message-State: APjAAAWOXva+UZF/ER5+a61w+WpGSv/zHrXXBisLw5DykkBecM4iF7d9
        rD2DrGpt8f9d7eDksxZd79plpX5FN64=
X-Google-Smtp-Source: APXvYqytGhJ61N7kXx+F6MuGoEGrfZFJgE1ENO08u102dUmJ85nq1PD/yvS6IXqIQnbuVfUdbBqsWQ==
X-Received: by 2002:a1c:38c7:: with SMTP id f190mr2161681wma.94.1582019774942;
        Tue, 18 Feb 2020 01:56:14 -0800 (PST)
Received: from [192.168.86.34] (cpc89974-aztw32-2-0-cust43.18-1.cable.virginm.net. [86.30.250.44])
        by smtp.googlemail.com with ESMTPSA id g21sm2835191wmh.17.2020.02.18.01.56.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Feb 2020 01:56:14 -0800 (PST)
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
Message-ID: <6e7a5df7-6ded-7777-5552-879934c185ad@linaro.org>
Date:   Tue, 18 Feb 2020 09:56:13 +0000
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

This is not correct fix to start with, if the device has already been 
intialized before jumping here then nvmem would be freed as part of 
nvmem_release().

So the bug was actually introduced by adding err_ida_remove label.

You can free nvmem at that point but not at any point after that as 
device core would be holding a reference to it.

--srini



>   
>   	return ERR_PTR(rval);
>   }
> 
