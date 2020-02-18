Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D229162E67
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 19:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbgBRSXK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 13:23:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:51204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726339AbgBRSXK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 13:23:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7332C2070B;
        Tue, 18 Feb 2020 18:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582050189;
        bh=wnuo9yeF5gE7V6j+6xgDye8o0DYbvJMmlwVoTj6dNUI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NuiKejeujU/3eynNVodlvXUSJ0DiUPFdZWKysDtJ1/SZHNR5kijYgD8IQM1RyEmPL
         EW5zO5LnSpXMgucPzaBRIzy5DwlKg8amueodMTOiz5vUYlVyDUUEVO/JeCDt/4sicy
         IdkkZ4g8871z5ExdTwEpJrYBz656hNgFBol+8t9Y=
Date:   Tue, 18 Feb 2020 19:23:07 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Subject: Re: mmc patches for v5.4.y, v5.5.y
Message-ID: <20200218182307.GB2635524@kroah.com>
References: <20200218171857.GA25822@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218171857.GA25822@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 18, 2020 at 09:18:57AM -0800, Guenter Roeck wrote:
> Hi Greg,
> 
> please apply the following two patches to v5.4.y and v5.5.y to fix a
> problem when trying to boot various pxa machines from MMC.
> 
> d3a5bcb4a17f gpio: add gpiod_toggle_active_low()
> 9073d10b0989 mmc: core: Rework wp-gpio handling
> 
> The second patch fixes the problem, the first patch is necessary for the
> second patch to compile.
> 
> Background: Commit 9073d10b0989 claims "No functional changes intended".
> However, it does include the following functional code change.
> 
> --- a/drivers/mmc/host/pxamci.c
> +++ b/drivers/mmc/host/pxamci.c
> @@ -740,16 +740,16 @@ static int pxamci_probe(struct platform_device *pdev)
>                         goto out;
>                 }
> 
> +               if (!host->pdata->gpio_card_ro_invert)
> +                       mmc->caps2 |= MMC_CAP2_RO_ACTIVE_HIGH;
> +
>                 ret = mmc_gpiod_request_ro(mmc, "wp", 0, 0, NULL);
>                 if (ret && ret != -ENOENT) {
>                         dev_err(dev, "Failed requesting gpio_ro\n");
>                         goto out;
>                 }
> -               if (!ret) {
> +               if (!ret)
>                         host->use_ro_gpio = true;
> -                       mmc->caps2 |= host->pdata->gpio_card_ro_invert ?
> -                               0 : MMC_CAP2_RO_ACTIVE_HIGH;
> -               }
> 
> This _is_ a functional change: Previously, if there was no "ro" gpio
> pin, caps2 was never updated to active-high. This can have the practical
> effect of making the the card read-only, thus preventing the system
> from booting if it was mounted (and expected to be mounted) read-write.
> This is seen when trying to boot "spitz" and similar qemu machines from
> mmc.
> 
> I bisected the problem to commit c914a27c92f91 ("mmc: pxamci: Support
> getting GPIO descs for RO and WP), affecting v5.0 and later kernels.

Looks like Sasha just beat me to this, thanks for letting us know about
this.

greg k-h
