Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6105669AE04
	for <lists+stable@lfdr.de>; Fri, 17 Feb 2023 15:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjBQO0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Feb 2023 09:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjBQO0g (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Feb 2023 09:26:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA97E384
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 06:26:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47F1A61BE7
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 14:26:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595F3C433D2;
        Fri, 17 Feb 2023 14:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676643992;
        bh=IMPpr6TAAvPb5y46oNUdoV8WLf/sV/hb6SEcMDGgZYg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=er/bGH83Gu5JvEuTCl3mJEqxmbi0KbqYng+z95nsLjJrieUDhAI+ZJ2+L+3G39K2s
         Vn//uFq0U+miAkf9BSi1fslTollSqbyiD6Y6zkim7jzfO/DGugSnkpyDNYbsuh9Pf1
         8MXy7W+XaXFj93vAxFnj8w6Vbecqzz1C1IHhsXQM=
Date:   Fri, 17 Feb 2023 15:26:30 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Asmaa Mnebhi <asmaa@nvidia.com>
Cc:     kernel-team@lists.ubuntu.com, khoav@nvidia.com, meriton@nvidia.com,
        vlad@nvidia.com, Shreeya Patel <shreeya.patel@collabora.com>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: Re: [SRU][F:linux-bluefield][PATCH v2 1/2] gpio: Restrict usage of
 GPIO chip irq members before initialization
Message-ID: <Y++OlqihvPis7NK4@kroah.com>
References: <20230217140744.20600-1-asmaa@nvidia.com>
 <20230217140744.20600-2-asmaa@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217140744.20600-2-asmaa@nvidia.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 17, 2023 at 09:07:43AM -0500, Asmaa Mnebhi wrote:
> BugLink: https://bugs.launchpad.net/bugs/2007581
> 
> GPIO chip irq members are exposed before they could be completely
> initialized and this leads to race conditions.
> 
> One such issue was observed for the gc->irq.domain variable which
> was accessed through the I2C interface in gpiochip_to_irq() before
> it could be initialized by gpiochip_add_irqchip(). This resulted in
> Kernel NULL pointer dereference.
> 
> Following are the logs for reference :-
> 
> kernel: Call Trace:
> kernel:  gpiod_to_irq+0x53/0x70
> kernel:  acpi_dev_gpio_irq_get_by+0x113/0x1f0
> kernel:  i2c_acpi_get_irq+0xc0/0xd0
> kernel:  i2c_device_probe+0x28a/0x2a0
> kernel:  really_probe+0xf2/0x460
> kernel: RIP: 0010:gpiochip_to_irq+0x47/0xc0
> 
> To avoid such scenarios, restrict usage of GPIO chip irq members before
> they are completely initialized.
> 
> Signed-off-by: Shreeya Patel <shreeya.patel@collabora.com>
> Cc: stable@vger.kernel.org
> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
> (backported from commit 5467801f1fcbdc46bc7298a84dbf3ca1ff2a7320)
> Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
