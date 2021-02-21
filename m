Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE868320BAE
	for <lists+stable@lfdr.de>; Sun, 21 Feb 2021 17:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbhBUQSs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Feb 2021 11:18:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:51476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229585AbhBUQSr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Feb 2021 11:18:47 -0500
Received: from archlinux (cpc108967-cmbg20-2-0-cust86.5-4.cable.virginm.net [81.101.6.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22DEE64EF1;
        Sun, 21 Feb 2021 16:18:04 +0000 (UTC)
Date:   Sun, 21 Feb 2021 16:18:01 +0000
From:   Jonathan Cameron <jic23@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-iio@vger.kernel.org, Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        stable@vger.kernel.org
Subject: Re: [PATCH] iio: adc: ab8500-gpadc: Fix off by 10 to 3
Message-ID: <20210221161801.42532e87@archlinux>
In-Reply-To: <20201224011700.1059659-1-linus.walleij@linaro.org>
References: <20201224011700.1059659-1-linus.walleij@linaro.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 24 Dec 2020 02:17:00 +0100
Linus Walleij <linus.walleij@linaro.org> wrote:

> Fix an off by three orders of magnitude error in the AB8500
> GPADC driver. Luckily it showed up quite quickly when trying
> to make use of it. The processed reads were returning
> microvolts, microamperes and microcelsius instead of millivolts,
> milliamperes and millicelsius as advertised.
> 
> Cc: stable@vger.kernel.org
> Fixes: 07063bbfa98e ("iio: adc: New driver for the AB8500 GPADC")
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
No idea why I didn't pick this up before now.  I guess I forgot it
over xmas.

Anyhow, now applied to the fixes-togreg branch of iio.git.

Thanks,

Jonathan

> ---
>  drivers/iio/adc/ab8500-gpadc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iio/adc/ab8500-gpadc.c b/drivers/iio/adc/ab8500-gpadc.c
> index 6f9a3e2d5533..7b5212ba5501 100644
> --- a/drivers/iio/adc/ab8500-gpadc.c
> +++ b/drivers/iio/adc/ab8500-gpadc.c
> @@ -918,7 +918,7 @@ static int ab8500_gpadc_read_raw(struct iio_dev *indio_dev,
>  			return processed;
>  
>  		/* Return millivolt or milliamps or millicentigrades */
> -		*val = processed * 1000;
> +		*val = processed;
>  		return IIO_VAL_INT;
>  	}
>  

