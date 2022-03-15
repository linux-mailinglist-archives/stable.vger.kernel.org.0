Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD1C84D9F01
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 16:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344752AbiCOPqU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 11:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236068AbiCOPqT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 11:46:19 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1669713D6D;
        Tue, 15 Mar 2022 08:45:05 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id DBBD622247;
        Tue, 15 Mar 2022 16:45:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1647359103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JfosakXBgjInItGIDwOVGdxA4oBENc+T56qzt13SnWQ=;
        b=MLev/5zo+b0bVDICdH2Lq4/tsy6sprEVzbSMhpsrBkAujkGf53LA3rMnV472fgX0dR/ag9
        cHKUdVSJYnmCxo1ddz1rvSwoFNLqiNOf0VdBQs9DgSzcPZ73qJKe5AHRahgj3pmBVRjHwF
        4JF8NFtrRd7YQHCKHj6//h5MU5F2Utg=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 15 Mar 2022 16:45:01 +0100
From:   Michael Walle <michael@walle.cc>
To:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Saravana Kannan <saravanak@google.com>
Cc:     Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>,
        Andrew Chant <achant@google.com>,
        Edmond Chung <edmondchung@google.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        regressions@lists.linux.dev,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        stable <stable@vger.kernel.org>,
        Sergio Tanzilli <tanzilli@acmesystems.it>,
        Thierry Reding <treding@nvidia.com>,
        Vidya Sagar <vidyas@nvidia.com>,
        Will McVicker <willmcvicker@google.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: Re: [PATCH] gpio: Revert regression in sysfs-gpio (gpiolib.c)
In-Reply-To: <CAMRc=MfH00YJv07TaiZ5z1w4gzqP5_8z9bKFcNU1Z37AVih4hQ@mail.gmail.com>
References: <20211217153555.9413-1-marcelo.jimenez@gmail.com>
 <20220314155509.552218-1-michael@walle.cc>
 <CAMRc=MfH00YJv07TaiZ5z1w4gzqP5_8z9bKFcNU1Z37AVih4hQ@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <fe1ba600b2b30b4cba702d6aebdfda50@walle.cc>
X-Sender: michael@walle.cc
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[+ Saravana ]

Am 2022-03-15 16:32, schrieb Bartosz Golaszewski:
> On Mon, Mar 14, 2022 at 4:55 PM Michael Walle <michael@walle.cc> wrote:
>> > Some GPIO lines have stopped working after the patch
>> > commit 2ab73c6d8323f ("gpio: Support GPIO controllers without pin-ranges")
>> >
>> > And this has supposedly been fixed in the following patches
>> > commit 89ad556b7f96a ("gpio: Avoid using pin ranges with !PINCTRL")
>> > commit 6dbbf84603961 ("gpiolib: Don't free if pin ranges are not defined")
>> >
>> > But an erratic behavior where some GPIO lines work while others do not work
>> > has been introduced.
>> >
>> > This patch reverts those changes so that the sysfs-gpio interface works
>> > properly again.
>> >
>> > Signed-off-by: Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>
>> 
>> This breaks the pinctrl-microchip-sgpio driver as far as I can see.
>> 
>> I tried to debug it and this is what I have discovered so far:
>>  (1) the sgpio driver will use the gpio_stub_drv for its child nodes.
>>      Looks like a workaround, see [1].
>>  (2) these will have an empty gpio range
>>  (3) with the changes of this patch, pinctrl_gpio_request() will now
>>      be called and will fail with -EPROBE_DEFER.
>> 
>> I'm not exactly sure what to do here. Saravana Kannan once suggested
>> to use devm_of_platform_populate() to probe the child nodes [2]. But
>> I haven't found any other driver doing that.

Oh I meant gpio/pinctrl drivers.

> TI AEMIF driver (drivers/memory/ti-aemif.c) does something like this:
> 
> 406         if (np) {
> 407                 for_each_available_child_of_node(np, child_np) {
> 408                         ret = of_platform_populate(child_np, NULL,
> 409                                                    dev_lookup, 
> dev);
> 410                         if (ret < 0) {
> 411                                 of_node_put(child_np);
> 412                                 goto error;
> 413                         }
> 414                 }
> 415         } else if (pdata) {
> 416                 for (i = 0; i < pdata->num_sub_devices; i++) {
> 417                         pdata->sub_devices[i].dev.parent = dev;
> 418                         ret =
> platform_device_register(&pdata->sub_devices[i]);
> 419                         if (ret) {
> 420                                 dev_warn(dev, "Error register sub
> device %s\n",
> 421                                          
> pdata->sub_devices[i].name);
> 422                         }
> 423                 }
> 424         }
> 
> A bunch of different devices (like NAND) get instantiated this way.
> Would this work?

I started to try this out, but then I was wondering if there weren't
other gpio/pinctrl drivers with the same problem. And judging by the
reports [1], I'd say there are. Then I wasn't sure if this is actually
the correct fix here - or if that old workaround [2] doesn't work
anymore because it might have that empty ranges "feature".

To answer your question: I don't know. But I don't know if that is
actually the correct way of fixing this either.

>> Also, I'm not sure if there are any other other driver which get
>> broken by this. I.e. ones falling into the gpio_stub_drv category.
>> 
>> [1] 
>> https://lore.kernel.org/lkml/20210122193600.1415639-1-saravanak@google.com/
>> [2] 
>> https://lore.kernel.org/lkml/CAGETcx9PiX==mLxB9PO8Myyk6u2vhPVwTMsA5NkD-ywH5xhusw@mail.gmail.com/
>> 
>> -michael
>> 
>> NB. this patch doesn't contain a Fixes tag. Was this on purpose?

-michael

[1] https://lore.kernel.org/lkml/20220314192522.GA3031157@roeck-us.net/
[2] 
https://lore.kernel.org/lkml/20210122193600.1415639-1-saravanak@google.com/
