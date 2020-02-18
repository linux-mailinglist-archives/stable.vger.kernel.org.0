Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8B5162E44
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 19:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgBRSSz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 13:18:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:47018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726239AbgBRSSz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 13:18:55 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F75D208C4;
        Tue, 18 Feb 2020 18:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582049934;
        bh=ZpGY9D7+2l6IKRqWfrOXTQRm81+TyGFCMM1+FE4XTDg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cpIsGXX+bXnSb49pBpOCw1x7qw7ywknXv1oygG1RmRVHVO+f84nvY6WX9DONhU1O1
         36JozN0yVzxWxxzukHmungTgqyShGEZDxb/Aj0Zsr8dm73lcytmXg3Z7pErhKzJkIP
         tvgViWOZcZbOgr61ApKH8P9YlCQveatZ7okLNe5c=
Date:   Tue, 18 Feb 2020 13:18:53 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Subject: Re: mmc patches for v5.4.y, v5.5.y
Message-ID: <20200218181853.GU1734@sasha-vm>
References: <20200218171857.GA25822@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200218171857.GA25822@roeck-us.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 18, 2020 at 09:18:57AM -0800, Guenter Roeck wrote:
>Hi Greg,
>
>please apply the following two patches to v5.4.y and v5.5.y to fix a
>problem when trying to boot various pxa machines from MMC.
>
>d3a5bcb4a17f gpio: add gpiod_toggle_active_low()
>9073d10b0989 mmc: core: Rework wp-gpio handling
>
>The second patch fixes the problem, the first patch is necessary for the
>second patch to compile.
>
>Background: Commit 9073d10b0989 claims "No functional changes intended".
>However, it does include the following functional code change.
>
>--- a/drivers/mmc/host/pxamci.c
>+++ b/drivers/mmc/host/pxamci.c
>@@ -740,16 +740,16 @@ static int pxamci_probe(struct platform_device *pdev)
>                        goto out;
>                }
>
>+               if (!host->pdata->gpio_card_ro_invert)
>+                       mmc->caps2 |= MMC_CAP2_RO_ACTIVE_HIGH;
>+
>                ret = mmc_gpiod_request_ro(mmc, "wp", 0, 0, NULL);
>                if (ret && ret != -ENOENT) {
>                        dev_err(dev, "Failed requesting gpio_ro\n");
>                        goto out;
>                }
>-               if (!ret) {
>+               if (!ret)
>                        host->use_ro_gpio = true;
>-                       mmc->caps2 |= host->pdata->gpio_card_ro_invert ?
>-                               0 : MMC_CAP2_RO_ACTIVE_HIGH;
>-               }
>
>This _is_ a functional change: Previously, if there was no "ro" gpio
>pin, caps2 was never updated to active-high. This can have the practical
>effect of making the the card read-only, thus preventing the system
>from booting if it was mounted (and expected to be mounted) read-write.
>This is seen when trying to boot "spitz" and similar qemu machines from
>mmc.
>
>I bisected the problem to commit c914a27c92f91 ("mmc: pxamci: Support
>getting GPIO descs for RO and WP), affecting v5.0 and later kernels.

I've queued both for 5.4 and 5.5, thank you.

-- 
Thanks,
Sasha
