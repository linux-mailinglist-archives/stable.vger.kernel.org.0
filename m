Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9538353481A
	for <lists+stable@lfdr.de>; Thu, 26 May 2022 03:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243733AbiEZB3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 21:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239482AbiEZB3b (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 21:29:31 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 484D29D067;
        Wed, 25 May 2022 18:29:30 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id l82so579552qke.3;
        Wed, 25 May 2022 18:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FbPPFb9rMCeh0SoOtVc42/2NbWJSabE6UzVds4NMhYU=;
        b=BOm/N6srzaQmptKq/40CH7xw/zMPM3qJmifHv3VbiyX3876cqB65IMMlrVc731N0eQ
         xwh5P0N5dcpp5fs7qe5WaCU4lbT0u9hQOml0wOy0SAPZMqPhE74G0fpTAwIwkHoztc0m
         ZASw18+4dlHKbcnCd0u2faA9Hsfu6rYRUT3Nz3s3slNhU5EUv0yarmPubQJv2INiMToa
         hCDaCpUUm/nYLnU8wzkxCpUtLvLtaNfxcJUsrMEWto2ofPksKE6cAr6+YNwLTy9Cdfl0
         Hxofy+sMIIn3ON9R40XfdY0/lqjqiVGmYWdu6Mm7zVyix0mZNnQTjnqckRIx6CX/y8SO
         hetQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FbPPFb9rMCeh0SoOtVc42/2NbWJSabE6UzVds4NMhYU=;
        b=Zs4lIJmN3lYv1gGNvC8K1QroBWjcR7ZEtLdZweChEhaChAusNA95e+1CJbfVfbO7xF
         bbfpI0GsWPORaZBaVl4XvSW3KyV2dJ9e6Wg71gAKzACRPUqvED94AlzJKR2DcG4X38xD
         xB62lrleCI7n8CoVKJHHaLGkC/aR1IIC9RnMDlW2osApNSja8WSsxz5XY4yueTi1BX40
         wfoH4sWtL1ta0g8tenu0E0Xl5Vcggp0vThQCzrUhqdGN8HcIGW2dVtLZViggt/e3lKla
         tLIjRvCrYlKeUm/l9b4v+AQRMvxgDRemvP1vZZOeM8fhHSW9TAIi9LhmahcVaUUNPDu0
         /YGw==
X-Gm-Message-State: AOAM531IyXNGoXqmm7k/LrDGl1/tjVBWL55fxv8NZ7gKGqfyFVjOs0E6
        WUxz2budu152Celrx2jsf8FTrOvVJC0b4A==
X-Google-Smtp-Source: ABdhPJwwpkcFO1ws/01FEXL4wTG6JIOaiT4NySHsersgMAFgDxqE0FBwsoKTX5BTb87QDwxZTo9jYg==
X-Received: by 2002:a37:7cb:0:b0:6a3:51fa:9ec2 with SMTP id 194-20020a3707cb000000b006a351fa9ec2mr18026701qkh.735.1653528569354;
        Wed, 25 May 2022 18:29:29 -0700 (PDT)
Received: from shaak (modemcable055.92-163-184.mc.videotron.ca. [184.163.92.55])
        by smtp.gmail.com with ESMTPSA id o7-20020a37a507000000b0069fc13ce225sm367478qke.86.2022.05.25.18.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 18:29:28 -0700 (PDT)
Date:   Wed, 25 May 2022 21:29:27 -0400
From:   Liam Beguin <liambeguin@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Peter Rosin <peda@axentia.se>, Jonathan Cameron <jic23@kernel.org>,
        linux-iio@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH] iio: afe: rescale: Fix logic bug
Message-ID: <Yo7X9w6i3uiNZqpW@shaak>
References: <20220524075448.140238-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220524075448.140238-1-linus.walleij@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 24, 2022 at 09:54:48AM +0200, Linus Walleij wrote:
> When introducing support for processed channels I needed
> to invert the expression:
> 
>   if (!iio_channel_has_info(schan, IIO_CHAN_INFO_RAW) ||
>       !iio_channel_has_info(schan, IIO_CHAN_INFO_SCALE))
>         dev_err(dev, "source channel does not support raw/scale\n");
> 
> To the inverse, meaning detect when we can usse raw+scale
> rather than when we can not. This was the result:
> 
>   if (iio_channel_has_info(schan, IIO_CHAN_INFO_RAW) ||
>       iio_channel_has_info(schan, IIO_CHAN_INFO_SCALE))
>        dev_info(dev, "using raw+scale source channel\n");
> 
> Ooops. Spot the error. Yep old George Boole came up and bit me.
> That should be an &&.
> 
> The current code "mostly works" because we have not run into
> systems supporting only raw but not scale or only scale but not
> raw, and I doubt there are few using the rescaler on anything
> such, but let's fix the logic.

Maybe `iio: afe: rescale: Fix boolean logic bug` if you're resending,
otherwise,

Reviewed-by: Liam Beguin <liambeguin@gmail.com>

Thanks,
Liam

> Cc: Liam Beguin <liambeguin@gmail.com>
> Cc: stable@vger.kernel.org
> Fixes: 53ebee949980 ("iio: afe: iio-rescale: Support processed channels")
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/iio/afe/iio-rescale.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iio/afe/iio-rescale.c b/drivers/iio/afe/iio-rescale.c
> index 7e511293d6d1..dc426e1484f0 100644
> --- a/drivers/iio/afe/iio-rescale.c
> +++ b/drivers/iio/afe/iio-rescale.c
> @@ -278,7 +278,7 @@ static int rescale_configure_channel(struct device *dev,
>  	chan->ext_info = rescale->ext_info;
>  	chan->type = rescale->cfg->type;
>  
> -	if (iio_channel_has_info(schan, IIO_CHAN_INFO_RAW) ||
> +	if (iio_channel_has_info(schan, IIO_CHAN_INFO_RAW) &&
>  	    iio_channel_has_info(schan, IIO_CHAN_INFO_SCALE)) {
>  		dev_info(dev, "using raw+scale source channel\n");
>  	} else if (iio_channel_has_info(schan, IIO_CHAN_INFO_PROCESSED)) {
> -- 
> 2.35.3
> 
