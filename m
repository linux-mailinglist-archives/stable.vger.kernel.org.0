Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABF952C316
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 21:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241779AbiERTJz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 15:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241758AbiERTJy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 15:09:54 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5DB81F1CA9;
        Wed, 18 May 2022 12:09:53 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id a19so2980473pgw.6;
        Wed, 18 May 2022 12:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=D/0bpZqeX7kwydajsXx1JK+na+8xnT2KPMKht+WnGIw=;
        b=pL97U5rBL40s6HgLZElcctoLmGXiYsq9qcbA4YDOLRLEuxA8vvkVSzqo0rzJiEhph+
         8b+3SgI95EswOIbOjXR955qQrJ3kkZ8hSuqmupwM9HOgD88nPNWVHyh4lK6MWCbnMb/l
         AIhPqyQfu9OvnO9vRvt6LGV+kXDsvAo/FRRSGCgnQeMCEbpcV+o7jAp7LVK1DpiVgpEn
         FOjLOtGJeyoUQRaWKoShl2QYPJJv/KPR2F8ns/siK49n0VqgbTW9iz4GR6TkGveLfx+y
         SjkOwxzBwhzv/y/c423XLscui6e7oxpoHmtC+gJwkv8HHA6pdU7WUk27agvEpn96fi8I
         DiQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D/0bpZqeX7kwydajsXx1JK+na+8xnT2KPMKht+WnGIw=;
        b=xV/6KcbDysod5X0G0bosDvf+v1zrEDpHcSPRZ6/46wd0oIZHcrpr7nMrT+zJxbRem/
         OsqtZfWoWGKUf+x7KfIrWCdnyYiCfj1vWRi+OS6htRdpMD53h2lpPcQd7yczf6L5mk4l
         /UV7ppSClco5uQEX6ymedNwQCJbE2CSMbj0xu9f+pvoryWBN9avQZRiyWmugUOMwcL38
         DH8qtcbXQGuDAOIqZ8HD6yd9ynWsd3pPlB5UvcwZlOdvGFu5Q9uSyOggq4R2sDZkhizp
         0eT5jFiZ0nEuzYOfRvGIQbnBHRU8HC0f2G3Odtp3pvkFr876eZ+swhn0qTjJ6yZ/kDqw
         +DTA==
X-Gm-Message-State: AOAM533XqCkaD7eufz82sC6CObkb2h+UBu82Lo74UaE8rUp12GTw4Zca
        DS6F+Nlc1v4WMC5SZEXqPFo=
X-Google-Smtp-Source: ABdhPJy4eQ5dE5GRsK8w1TG6VTV4ma+rWfbYt6rKDgocW1XHFt3qY45KJDqjMR7tSVaHpAkRPRr+hw==
X-Received: by 2002:a63:c147:0:b0:3f5:f6f5:fe0e with SMTP id p7-20020a63c147000000b003f5f6f5fe0emr725231pgi.501.1652900993019;
        Wed, 18 May 2022 12:09:53 -0700 (PDT)
Received: from google.com ([2620:15c:202:201:1a53:727c:6847:3659])
        by smtp.gmail.com with ESMTPSA id i24-20020a056a00225800b0050dc7628168sm2305464pfu.66.2022.05.18.12.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 12:09:52 -0700 (PDT)
Date:   Wed, 18 May 2022 12:09:50 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Marek Vasut <marex@denx.de>
Cc:     linux-input@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] Input: ili210x - Fix reset timing
Message-ID: <YoVEftKRoTndAn9R@google.com>
References: <20220518163430.41192-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518163430.41192-1-marex@denx.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 18, 2022 at 06:34:30PM +0200, Marek Vasut wrote:
> According to Ilitek "231x & ILI251x Programming Guide" Version: 2.30
> "2.1. Power Sequence", "T4 Chip Reset and discharge time" is minimum
> 10ms and "T2 Chip initial time" is maximum 150ms. Adjust the reset
> timings such that T4 is 15ms and T2 is 160ms to fit those figures.
> 
> This prevents sporadic touch controller start up failures when some
> systems with at least ILI251x controller boot, without this patch
> the systems sometimes fail to communicate with the touch controller.
> 
> Fixes: 201f3c803544c ("Input: ili210x - add reset GPIO support")
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>  drivers/input/touchscreen/ili210x.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/ili210x.c b/drivers/input/touchscreen/ili210x.c
> index 2bd407d86bae5..131cb648a82ae 100644
> --- a/drivers/input/touchscreen/ili210x.c
> +++ b/drivers/input/touchscreen/ili210x.c
> @@ -951,9 +951,9 @@ static int ili210x_i2c_probe(struct i2c_client *client,
>  		if (error)
>  			return error;
>  
> -		usleep_range(50, 100);
> +		msleep(15);

WARNING: msleep < 20ms can sleep for up to 20ms; see
Documentation/timers/timers-howto.rst
#38: FILE: drivers/input/touchscreen/ili210x.c:954:
+               msleep(15);

Should this be usleep_range(10000, 15000) like in
ili251x_hardware_reset()? Actually, should we adopt
ili251x_hardware_reset() to be used there?

>  		gpiod_set_value_cansleep(reset_gpio, 0);
> -		msleep(100);
> +		msleep(160);
>  	}
>  
>  	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
> -- 
> 2.35.1
> 

Thanks.

-- 
Dmitry
