Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B718B4636C7
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242226AbhK3OhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:37:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242223AbhK3OhY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:37:24 -0500
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B16BC061748;
        Tue, 30 Nov 2021 06:34:02 -0800 (PST)
Received: by mail-oo1-xc30.google.com with SMTP id v30-20020a4a315e000000b002c52d555875so6750382oog.12;
        Tue, 30 Nov 2021 06:34:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VzXaRiL/I8pc8Mlqw7AKcPRe1BRMY9UINIalpZhNbfw=;
        b=YTnEaa6u6j3wVnl4Cdg+jMNe/ODuZhL1Ses7vhU2tjfxJfu1zZxzQBCHhIx9qfXG4o
         eK+C11BeDdZhTS66um0KJkq//wWUHtZ5gyRnFOrWjmYXa761YHpMCqVgx7j0koA4+lKB
         U8qOVjBgBqbxoH1r8Sdg5kAip7/xr28yn9nBAkgbM15u/rzDIJ9LJCfdLrr1O/eJTouX
         ZIJA5op9Zm0tfNDKVabTfdDc4qyR0BDUltUngs1oeheDq314Hhw3V7HafZX1GIb5EC5X
         RStIsIE7SZnMtnjs1220CKspmZun3/XtxMgK7BC8WKj0CywPCmfYX688gbpwrkaTLhfD
         Wb0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VzXaRiL/I8pc8Mlqw7AKcPRe1BRMY9UINIalpZhNbfw=;
        b=TJkj6yDE6DRwptvq0VnO6F3IHa90a3Ewn7H9zllqOOL+K8Zx6h4WqZk6QdHTkxcLdv
         4JCZbBaZzn5h0Fkr/qqQTktPxYyqZ6ZhSUdi0QzxtlDMxou9vDB1wXeKB9ouipnf7yCT
         VQh9z8lselmZwuEjZEElTHwiQFJ+BzVD0nBOxH2lnFthBVsVMrJiS/Q5CqTKRbpPt9jW
         BdbdiCK34Q3rljm++RUFmMyyj6bPYn9kqZuaenRgm9doMdGPB3vzOiISYV38gFmsJPKk
         DlS7pfXgptv9DZCM0RI+1WZKOB5LR1aZel+2sf2n+16p4GYeEEbqi9+/4gVdDFkDYtcY
         0/3g==
X-Gm-Message-State: AOAM532SvvzymAw1rHfzYm9+AmdvaHX4v4pVswJHccbfv2X64/njGWmk
        qtTEy9NUuvOd75jPsjifE7c5IzZRLCI=
X-Google-Smtp-Source: ABdhPJxLV2vvhMd3qNDm9vAirWDFACsobvcg/sJ2rxtYXd6Tr5bBpod0yxH7Q+16n+p4UyEAko0VNA==
X-Received: by 2002:a4a:a44b:: with SMTP id w11mr17324454ool.66.1638282841352;
        Tue, 30 Nov 2021 06:34:01 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i3sm2759642ooq.39.2021.11.30.06.33.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 06:34:00 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH] hwmon: (pwm-fan) Ensure the fan going on in .probe()
To:     Billy Tsai <billy_tsai@aspeedtech.com>, b.zolnierkie@samsung.com,
        jdelvare@suse.com, u.kleine-koenig@pengutronix.de,
        linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     BMC-SW@aspeedtech.com, stable@vger.kernel.org
References: <20211130092212.17783-1-billy_tsai@aspeedtech.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <175a4963-62dd-9213-1e92-74e8cd9829fc@roeck-us.net>
Date:   Tue, 30 Nov 2021 06:33:59 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211130092212.17783-1-billy_tsai@aspeedtech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/30/21 1:22 AM, Billy Tsai wrote:
> Before commit 86585c61972f ("hwmon: (pwm-fan) stop using legacy
> PWM functions and some cleanups") pwm_apply_state() was called
> unconditionally in pwm_fan_probe(). In this commit this direct
> call was replaced by a call to __set_pwm(ct, MAX_PWM) which
> however is a noop if ctx->pwm_value already matches the value to
> set.
> After probe the fan is supposed to run at full speed, and the
> internal driver state suggests it does, but this isn't asserted
> and depending on bootloader and pwm low-level driver, the fan
> might just be off.
> So drop setting pwm_value to MAX_PWM to ensure the check in
> __set_pwm doesn't make it exit early and the fan goes on as
> intended.
> 
> Cc: stable@vger.kernel.org
> Fixes: 86585c61972f ("hwmon: (pwm-fan) stop using legacy PWM functions and some cleanups")
> Signed-off-by: Billy Tsai <billy_tsai@aspeedtech.com>

I'll apply this patch, but _please_ version your patches in the future
and provide a change log.

Guenter

> ---
>   drivers/hwmon/pwm-fan.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/hwmon/pwm-fan.c b/drivers/hwmon/pwm-fan.c
> index 17518b4cab1b..f12b9a28a232 100644
> --- a/drivers/hwmon/pwm-fan.c
> +++ b/drivers/hwmon/pwm-fan.c
> @@ -336,8 +336,6 @@ static int pwm_fan_probe(struct platform_device *pdev)
>   			return ret;
>   	}
>   
> -	ctx->pwm_value = MAX_PWM;
> -
>   	pwm_init_state(ctx->pwm, &ctx->pwm_state);
>   
>   	/*
> 

