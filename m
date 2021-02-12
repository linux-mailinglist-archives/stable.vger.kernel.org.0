Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9560131A520
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 20:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbhBLTNI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 12 Feb 2021 14:13:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:36264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231978AbhBLTNG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Feb 2021 14:13:06 -0500
Received: from archlinux (cpc108967-cmbg20-2-0-cust86.5-4.cable.virginm.net [81.101.6.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57BF360241;
        Fri, 12 Feb 2021 19:12:23 +0000 (UTC)
Date:   Fri, 12 Feb 2021 19:12:19 +0000
From:   Jonathan Cameron <jic23@kernel.org>
To:     Petr =?UTF-8?B?xaB0ZXRpYXI=?= <ynezz@true.cz>
Cc:     Tomasz Duszynski <tomasz.duszynski@octakon.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: chemical: scd30: fix Oops due to missing parent
 device
Message-ID: <20210212191219.7b16abbb@archlinux>
In-Reply-To: <20210208223947.32344-1-ynezz@true.cz>
References: <20210208223947.32344-1-ynezz@true.cz>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon,  8 Feb 2021 23:39:47 +0100
Petr Štetiar <ynezz@true.cz> wrote:

> My machine Oopsed while testing SCD30 sensor in interrupt driven mode:
> 
>  Unable to handle kernel NULL pointer dereference at virtual address 00000188
>  pgd = (ptrval)
>  [00000188] *pgd=00000000
>  Internal error: Oops: 5 [#1] SMP ARM
>  Modules linked in:
>  CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.4.96+ #473
>  Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
>  PC is at _raw_spin_lock_irqsave+0x10/0x4c
>  LR is at devres_add+0x18/0x38
>  ...
>  [<8070ecac>] (_raw_spin_lock_irqsave) from [<804916a8>] (devres_add+0x18/0x38)
>  [<804916a8>] (devres_add) from [<805ef708>] (devm_iio_trigger_alloc+0x5c/0x7c)
>  [<805ef708>] (devm_iio_trigger_alloc) from [<805f0a90>] (scd30_probe+0x1d4/0x3f0)
>  [<805f0a90>] (scd30_probe) from [<805f10fc>] (scd30_i2c_probe+0x54/0x64)
>  [<805f10fc>] (scd30_i2c_probe) from [<80583390>] (i2c_device_probe+0x150/0x278)
>  [<80583390>] (i2c_device_probe) from [<8048e6c0>] (really_probe+0x1f8/0x360)
> 
> I've found out, that it's due to missing parent/owner device in iio_dev struct
> which then leads to NULL pointer dereference during spinlock while registering
> the device resource via devres_add().
> 
> Cc: <stable@vger.kernel.org> # v5.9+
> Fixes: 64b3d8b1b0f5 ("iio: chemical: scd30: add core driver")
> Signed-off-by: Petr Štetiar <ynezz@true.cz>

Hi Petr,

So, we moved this into the core a while back (to avoid exactly this sort of issue).
That change predates this introduction of this driver as it went in
in v5.8

So I think you've hit an issue with a backport here to an earlier kernel?

Jonathan


> ---
>  drivers/iio/chemical/scd30_core.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/iio/chemical/scd30_core.c b/drivers/iio/chemical/scd30_core.c
> index 4d0d798c7cd3..33aa6eb1963d 100644
> --- a/drivers/iio/chemical/scd30_core.c
> +++ b/drivers/iio/chemical/scd30_core.c
> @@ -697,6 +697,7 @@ int scd30_probe(struct device *dev, int irq, const char *name, void *priv,
>  
>  	dev_set_drvdata(dev, indio_dev);
>  
> +	indio_dev->dev.parent = dev;
>  	indio_dev->info = &scd30_info;
>  	indio_dev->name = name;
>  	indio_dev->channels = scd30_channels;

