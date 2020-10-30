Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8722A00B6
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 10:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725823AbgJ3JG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 05:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbgJ3JGZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 05:06:25 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C171C0613CF;
        Fri, 30 Oct 2020 02:06:25 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id p15so6782541ioh.0;
        Fri, 30 Oct 2020 02:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ajoTgRnqXmGr4NGz4sDpf2t3leA2CkfA49rjJDDlhoM=;
        b=KefjnyhYCfoYAm8EPLwzn8mn34N7B1TMaMJeF/wDuWddo58+UlTWBx1rN+Lb6ilbFL
         R9xoEiBixZKDGgnqOalWsSSdeN9mkKx4jf9JLPBcsK3T2ymLpf5W22DOWn+XkqaystSQ
         nls507X9al+GqM/2iGLlMTjznJS2kAensbitYckM9I+4aicXw5oCiproVXMfqX1p+btO
         qn2J1elUsgRgmcJbr9pJkmuwJRYyKX9vXGRjr81ksVNCc6gy9t1ULavQAJq0KyhuUaP9
         15mJOWUI3bxFFI2diqj/bBE6Z9WUsq27mWuuPera5ono9nNMxgykCnQ7ry+srf40XFd1
         lIjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ajoTgRnqXmGr4NGz4sDpf2t3leA2CkfA49rjJDDlhoM=;
        b=m1TgrjtLdu7lICkmQoi1AIuA7gE78XQnKfcBXhohK5TmJ5wOQ22WX60fHIqxD/kTDF
         nUtDoUQalUXEW1R4FIkpMeOkQOjCTNNpTRfma+iIK0fjkeN+7cGF65u/HYNw5p3ReUZo
         uw9kK/Q38Mp+q9hxW8KCY44EIZFhwAI9fur6m4tGf/5ivLghQkstCXTXkWE8dFrSfybT
         BE1Xm+SiMHn21EI9ySexFLTiFa+WKXEnQBfTLnlyGcsVJLUsuVistju8VpwqASiywGvd
         pxeJGa0i6tJCYHfExrMYbI+j1czPScnFurv6lZKBS6fQXqRRYsADxM1zmRIYB+FkcbKK
         9Zow==
X-Gm-Message-State: AOAM530V7IR5rtdOEfTjbLE+vJdb8qoId/xPKAmg2YaDzRWtq8E/k16d
        qfhzInB486T+4vh8uSHwSy8=
X-Google-Smtp-Source: ABdhPJw85sVyP6y5ilqXEh1EvkZzIms/rsekSrV637FLs1tm3tNCCEayMR8NXGizRE+7xH5lc+aNFg==
X-Received: by 2002:a6b:fe11:: with SMTP id x17mr1031699ioh.192.1604048784946;
        Fri, 30 Oct 2020 02:06:24 -0700 (PDT)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id c1sm4878264ile.0.2020.10.30.02.06.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 02:06:23 -0700 (PDT)
Date:   Fri, 30 Oct 2020 02:06:21 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Martin =?iso-8859-1?Q?Hundeb=F8ll?= <martin@geanix.com>
Cc:     Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Scott Branden <sbranden@broadcom.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        stable@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org, Ray Jui <rjui@broadcom.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] spi: bcm2835: fix gpio cs level inversion
Message-ID: <20201030090621.GA3594676@ubuntu-m3-large-x86>
References: <20201014090230.2706810-1-martin@geanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201014090230.2706810-1-martin@geanix.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 14, 2020 at 11:02:30AM +0200, Martin Hundebøll wrote:
> The work on improving gpio chip-select in spi core, and the following
> fixes, has caused the bcm2835 spi driver to use wrong levels. Fix this
> by simply removing level handling in the bcm2835 driver, and let the
> core do its work.
> 
> Fixes: 3e5ec1db8bfe ("spi: Fix SPI_CS_HIGH setting when using native and GPIO CS")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Martin Hundebøll <martin@geanix.com>
> ---
>  drivers/spi/spi-bcm2835.c | 12 ------------
>  1 file changed, 12 deletions(-)
> 
> diff --git a/drivers/spi/spi-bcm2835.c b/drivers/spi/spi-bcm2835.c
> index b87116e9b413..9b6ba94fe878 100644
> --- a/drivers/spi/spi-bcm2835.c
> +++ b/drivers/spi/spi-bcm2835.c
> @@ -1259,18 +1259,6 @@ static int bcm2835_spi_setup(struct spi_device *spi)
>  	if (!chip)
>  		return 0;
>  
> -	/*
> -	 * Retrieve the corresponding GPIO line used for CS.
> -	 * The inversion semantics will be handled by the GPIO core
> -	 * code, so we pass GPIOD_OUT_LOW for "unasserted" and
> -	 * the correct flag for inversion semantics. The SPI_CS_HIGH
> -	 * on spi->mode cannot be checked for polarity in this case
> -	 * as the flag use_gpio_descriptors enforces SPI_CS_HIGH.
> -	 */
> -	if (of_property_read_bool(spi->dev.of_node, "spi-cs-high"))
> -		lflags = GPIO_ACTIVE_HIGH;
> -	else
> -		lflags = GPIO_ACTIVE_LOW;
>  	spi->cs_gpiod = gpiochip_request_own_desc(chip, 8 - spi->chip_select,
>  						  DRV_NAME,
>  						  lflags,
> -- 
> 2.28.0
> 
> 

Clang now warns:

drivers/spi/spi-bcm2835.c:1264:9: warning: variable 'lflags' is uninitialized when used here [-Wuninitialized]
                                                  lflags,
                                                  ^~~~~~
drivers/spi/spi-bcm2835.c:1196:2: note: variable 'lflags' is declared here
        enum gpio_lookup_flags lflags;
        ^
1 warning generated.

Cheers,
Nathan
