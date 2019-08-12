Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3DF989FA7
	for <lists+stable@lfdr.de>; Mon, 12 Aug 2019 15:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728768AbfHLN2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Aug 2019 09:28:09 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41560 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbfHLN2J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Aug 2019 09:28:09 -0400
Received: by mail-pf1-f194.google.com with SMTP id 196so2527599pfz.8;
        Mon, 12 Aug 2019 06:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dInIMy+S8GZhLa1bLLBVLdCdAhs9RNizZZYijhr+GRA=;
        b=C9wMnkLeMSuBKlE6YwI8xKAQmyaPpoK/Jcvs3F8L+QhsHKfUNGw9Iropg5Zltpy72S
         y2uEJtNgj5H3JlGfrbD4JtexgAI+kvxR+v0yR8BIV0uj0KgwNmCgMCe0Qz19Y3FfUZ7G
         J4+qnAyoWzjzNW5OcioBCIQQyn7dBO+fuXw/kW9Z+FW5jq3wqOL4kTx1FiM9FEt8WW4h
         GwSogQcAHUKFSYCotUxsgEzww7pX6K2pohGQ5rYMIlsy5rxCuvOeAE32M9wVQLZPqYcx
         KCr4nYu1d1k2kMVMkPXfVJ6ehOb4oywNG1Z1ZVzvxi/WxmvBTOXxWEcxUE40ZPGIWHhR
         gfcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dInIMy+S8GZhLa1bLLBVLdCdAhs9RNizZZYijhr+GRA=;
        b=oKLOEyRd1iF+PvGm27n3mqFXabZdqdMmTQ9+fiB8befXGBec/vnagKPJJ+FEh2UN/M
         9mgCpRI5DIX8PFrwvT9PbyJC85VfRUaW1cVMs+TsYNw+EVDl1mm2XPkCYwgnpVTv1dQC
         XGFVRYQW7yhJtKF5DrTszma3LT8NrVjwHnPCjXiGfhMJJT0dzlwBXdGV6yCcme76A8OS
         9mGVkwzpegEl2AVoFy7GYpu7DdVtXeegUfzU+fu5ICRyYOxuulNj8+aK/Y+0Jz/MEJ0e
         aee5yMkE9SVIflvxs5oT8+9jTNMtvc7VVajNfSnjPEyti98DtGwZUGVEPHdndwaXOafw
         hm1g==
X-Gm-Message-State: APjAAAU4OYU/V/XUPw4gBdMd0MOLCgs6GgkEAXRXQ/f1DP5cfB5PyvxL
        sPLR4USEr5Ewr2Z1R6DlCoixmalW
X-Google-Smtp-Source: APXvYqwiLiMUMbHYUN2Yl0rZPsaMKuD0yT0eQaPd33ELXbr8lQ4kRo93KDnNsNltKKsVNkhKRKPR/Q==
X-Received: by 2002:a63:29c4:: with SMTP id p187mr30803952pgp.330.1565616488103;
        Mon, 12 Aug 2019 06:28:08 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e2sm2643783pff.49.2019.08.12.06.28.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 06:28:06 -0700 (PDT)
Subject: Re: [PATCH] watchdog: imx2_wdt: fix min() calculation in
 imx2_wdt_set_timeout
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Wim Van Sebroeck <wim@linux-watchdog.org>
Cc:     Georg Hofmann <georg@hofmannsweb.com>,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20190812131356.23039-1-linux@rasmusvillemoes.dk>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <77faf1bd-14cc-831f-e65e-4f2aa74e1843@roeck-us.net>
Date:   Mon, 12 Aug 2019 06:28:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812131356.23039-1-linux@rasmusvillemoes.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/12/19 6:13 AM, Rasmus Villemoes wrote:
> Converting from ms to s requires dividing by 1000, not multiplying. So
> this is currently taking the smaller of new_timeout and 1.28e8,
> i.e. effectively new_timeout.
> 
> The driver knows what it set max_hw_heartbeat_ms to, so use that
> value instead of doing a division at run-time.
> 
> FWIW, this can easily be tested by booting into a busybox shell and
> doing "watchdog -t 5 -T 130 /dev/watchdog" - without this patch, the
> watchdog fires after 130&127 == 2 seconds.
> 
> Fixes: b07e228eee69 "watchdog: imx2_wdt: Fix set_timeout for big timeout values"
> Cc: stable@vger.kernel.org # 5.2 plus anything the above got backported to
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
> This should really be handled in the watchdog core for any driver that
> reports max_hw_heartbeat_ms.
> 
Good point. I'll see if I can write a patch.

Guenter

> The same pattern appears in aspeed_wdt.c. I don't have the hardware, but
> s#wdd->max_hw_heartbeat_ms * 1000#WDT_MAX_TIMEOUT_MS/1000U# should fix that one.
> 
> 
>   drivers/watchdog/imx2_wdt.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
> index 32af3974e6bb..8d019a961ccc 100644
> --- a/drivers/watchdog/imx2_wdt.c
> +++ b/drivers/watchdog/imx2_wdt.c
> @@ -55,7 +55,7 @@
>   
>   #define IMX2_WDT_WMCR		0x08		/* Misc Register */
>   
> -#define IMX2_WDT_MAX_TIME	128
> +#define IMX2_WDT_MAX_TIME	128U
>   #define IMX2_WDT_DEFAULT_TIME	60		/* in seconds */
>   
>   #define WDOG_SEC_TO_COUNT(s)	((s * 2 - 1) << 8)
> @@ -180,7 +180,7 @@ static int imx2_wdt_set_timeout(struct watchdog_device *wdog,
>   {
>   	unsigned int actual;
>   
> -	actual = min(new_timeout, wdog->max_hw_heartbeat_ms * 1000);
> +	actual = min(new_timeout, IMX2_WDT_MAX_TIME);
>   	__imx2_wdt_set_timeout(wdog, actual);
>   	wdog->timeout = new_timeout;
>   	return 0;
> 

