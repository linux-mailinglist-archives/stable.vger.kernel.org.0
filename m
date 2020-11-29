Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7E72C7750
	for <lists+stable@lfdr.de>; Sun, 29 Nov 2020 03:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgK2CyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Nov 2020 21:54:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgK2CyS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Nov 2020 21:54:18 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB19C0613D2;
        Sat, 28 Nov 2020 18:53:32 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id m9so7524978pgb.4;
        Sat, 28 Nov 2020 18:53:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ELNBa7ITkr6S7/2L6cdZr5s+CM8yFyj2snsrlnL2y84=;
        b=YNng1+dvbuL6goiCBWbUDAVEl9yzcKN0gJuFSMvZEko+vrrqKrZ5RmRx7Uu3FTJAqE
         3zmN1dRHeSEJU7ylEyJ3M1LmMQS1+dcjQKfG9YC675RgiaBhnqd44vLi/aH2cPzPrCtW
         dq3BFKufmgLQ8scZBNifpK2e9ZDPe62g7Usk/pZQkTp93zGbcIjbmaQg4d4pA6KfukE/
         Skd40tAkxoxmisYHkXmHDIQEmzvvYXL2usmbRg4sAM8qcKKVuVQWKrtUfB2lU1iLIWeM
         gd6r5VAPtPvrjAnQd2fm+A51ESqk/Y4gnHSPMepnMNlujkZ50nqyNyMl5HFhTavM6rOQ
         H2Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ELNBa7ITkr6S7/2L6cdZr5s+CM8yFyj2snsrlnL2y84=;
        b=jAgcvvooIEm7z92VLBQYqwruC1grmjMmmnFUKWJnPnP685JmMsq6NFuqcquvfKamlh
         pEI3u1zxjH/rllJz2Qj9g7hdzT/PA88vE13HQmpyvpUo/mFIgWNF9Cv9Y1icKIGCG90q
         0elRjyAQAeWZq2RiZfVrO80JUPx5EDayyxwPLYPWvWbJB2x55wnI93qjKWp3j0vpvhYa
         fKiKmIiqXTGi0yQg9B/Adpw/JlN7q+KFvnVoXpdjftpX2HxULOL+kaQmUxzu4pK27ivi
         /4+Bl7N46qAgaejt77TaRFqkb8ezaD/QsX7+Lt5BpMitlVz34A4N+M3Kgx44if0Wb6sX
         OtwA==
X-Gm-Message-State: AOAM533AMafrpnz2KVERxt5KOrb7GKWTpmXMqNoCVvW83cGxdTSqSNCn
        j2r5fvtpMeMUfppdwbderv8=
X-Google-Smtp-Source: ABdhPJxdg62VO+37fbEsG2/QrIi84fxL2IcbNz5UHh41GcEKH7bDXd2FIkGyApHZZjlbFeXf7zhXnw==
X-Received: by 2002:a17:90a:2941:: with SMTP id x1mr18488150pjf.25.1606618411534;
        Sat, 28 Nov 2020 18:53:31 -0800 (PST)
Received: from dtor-ws ([2620:15c:202:201:a6ae:11ff:fe11:fcc3])
        by smtp.gmail.com with ESMTPSA id f18sm12024151pfa.167.2020.11.28.18.53.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2020 18:53:30 -0800 (PST)
Date:   Sat, 28 Nov 2020 18:53:28 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-input@vger.kernel.org, Andre <andre.muller@web.de>,
        Nick Dyer <nick.dyer@itdev.co.uk>,
        Jiada Wang <jiada_wang@mentor.com>, stable@vger.kernel.org
Subject: Re: [PATCH] Input: atmel_mxt_ts - Fix lost interrupts
Message-ID: <20201129025328.GH2034289@dtor-ws>
References: <20201128123720.929948-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201128123720.929948-1-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Linus,

On Sat, Nov 28, 2020 at 01:37:20PM +0100, Linus Walleij wrote:
> After commit 74d905d2d38a devices requiring the workaround
> for edge triggered interrupts stopped working.
> 
> This is because the "data" state container defaults to
> *not* using the workaround, but the workaround gets used
> *before* the check of whether it is needed or not. This
> semantic is not obvious from just looking on the patch,
> but related to the program flow.
> 
> The hardware needs the quirk to be used before even
> proceeding to check if the quirk is needed.
> 
> This patch makes the quirk be used until we determine
> it is *not* needed.

Thank you very much for root-causing the issue!

> 
> Cc: Andre <andre.muller@web.de>
> Cc: Nick Dyer <nick.dyer@itdev.co.uk>
> Cc: Jiada Wang <jiada_wang@mentor.com>
> Cc: stable@vger.kernel.org
> Fixes: 74d905d2d38a ("Input: atmel_mxt_ts - only read messages in mxt_acquire_irq() when necessary")
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/input/touchscreen/atmel_mxt_ts.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
> index e34984388791..f25b2f6038a7 100644
> --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> @@ -1297,8 +1297,6 @@ static int mxt_check_retrigen(struct mxt_data *data)
>  	int val;
>  	struct irq_data *irqd;
>  
> -	data->use_retrigen_workaround = false;
> -

So this will result in data->use_retrigen_workaround staying "true" for
level interrupts, which is not needed, as with those we will never lose
an edge. So I think your patch can be reduced to simply setting
data->use_retrigen_workaround to true in mxt_probe() and leaving
mxt_check_retrigen() without any changes.

However I wonder if it would not be better to simply call
mxt_check_retrigen() before calling mxt_acquire_irq() in mxt_probe()
instead of after.

>  	irqd = irq_get_irq_data(data->irq);
>  	if (!irqd)
>  		return -EINVAL;
> @@ -1313,8 +1311,10 @@ static int mxt_check_retrigen(struct mxt_data *data)
>  		if (error)
>  			return error;
>  
> -		if (val & MXT_COMMS_RETRIGEN)
> +		if (val & MXT_COMMS_RETRIGEN) {
> +			data->use_retrigen_workaround = false;
>  			return 0;
> +		}
>  	}
>  
>  	dev_warn(&client->dev, "Enabling RETRIGEN workaround\n");
> @@ -3117,6 +3117,7 @@ static int mxt_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  	data = devm_kzalloc(&client->dev, sizeof(struct mxt_data), GFP_KERNEL);
>  	if (!data)
>  		return -ENOMEM;
> +	data->use_retrigen_workaround = true;
>  
>  	snprintf(data->phys, sizeof(data->phys), "i2c-%u-%04x/input0",
>  		 client->adapter->nr, client->addr);
> -- 
> 2.26.2
> 

By the way, does your touchscreen work if you change interrupt trigger
to level in DTS?

Thanks.

-- 
Dmitry
