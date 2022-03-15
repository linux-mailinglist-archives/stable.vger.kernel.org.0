Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8A34D9EC1
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 16:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238025AbiCOPdl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 11:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236492AbiCOPdk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 11:33:40 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDDD453B59
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 08:32:27 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id dr20so41105369ejc.6
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 08:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WIbu0rPO1oEyVSZctnr9unTIMs3QGdYvEZIGw/Rg3/M=;
        b=HW7L3aAEZpfJkkBKbcufU2ZBL+b2nHn0dDrxs5vR26Qi6wcZlPM8V3P9He2mTCDsQO
         KRj0dLcVsqMvv7Ks8EhENQi9VzfbZFlP7hge5Rk7YTLYlWdrszJxcikMY8gRfXfjlwcp
         AxcTUWtaCO3f8Ej5DZkJzqR2BPlHllGfAqzcS1scF3qGc+EUjEoO+kekfCS0/rGz9zkX
         PENpa3IJsd9no9oV4krFC7LGcYdQg4FJ7Yix4uxCj+CzIX4RQaKbRyzkLLrVh1XWP4w5
         uCEUDGut1JuLC0/ytPkNIg6DqIqReIosVZzoclxoBa7Ao1IKn2R6SHM/CGZdmY2o6ZLZ
         EuFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WIbu0rPO1oEyVSZctnr9unTIMs3QGdYvEZIGw/Rg3/M=;
        b=3bPDxUQVrNfEX3hgn+5BbDy2m3dWMqmUeL8GiB5/zwKmsfR/wuM3iLAmyzQaiSC3Kp
         IMWLBVTN4e3oQ/vCdefzkVlyJ+AjhTwew32FDE/Z+lyWccf1hmBHhRzBh8QmsQErMyKQ
         FxlwlQ9D4nuOXizCEgiQ4uX5o4BeJnEjfK+Uj/JkXUaExKuOPnvdyhYD3AorTJz0sLS7
         zA81lSb3IhyDeDw7dfBg1s3BqcGH8PPB3kvPobBkUoYN9vwzrGcqeeIPlIPuifOEZ6+D
         nMDEsSrwOCe4xk1Kg7lF+GnBz3FBt2XpSnRtVDrWvUfGM8m8k0pUvpSECH/WrRxBznka
         ytJQ==
X-Gm-Message-State: AOAM533uWtljmBFv/+YeXoIJtki+7s0whzmyqSdZ+aCryLcFoanAmA8L
        2HIf1kSvj5Vy8semM1Orpae/kJ0VUfDaG94mjvw3MQ==
X-Google-Smtp-Source: ABdhPJzPF76GqyUDd0qxghCloyB+ZKiQw/x2JzVMxKx4UnoTcArbLgDEl86pODyHYw8xGOUTMJcsMDvHaSa/YLQWDF4=
X-Received: by 2002:a17:907:97d4:b0:6db:ab53:1fe3 with SMTP id
 js20-20020a17090797d400b006dbab531fe3mr16562134ejc.492.1647358339569; Tue, 15
 Mar 2022 08:32:19 -0700 (PDT)
MIME-Version: 1.0
References: <20211217153555.9413-1-marcelo.jimenez@gmail.com> <20220314155509.552218-1-michael@walle.cc>
In-Reply-To: <20220314155509.552218-1-michael@walle.cc>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Tue, 15 Mar 2022 16:32:08 +0100
Message-ID: <CAMRc=MfH00YJv07TaiZ5z1w4gzqP5_8z9bKFcNU1Z37AVih4hQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: Revert regression in sysfs-gpio (gpiolib.c)
To:     Michael Walle <michael@walle.cc>
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 14, 2022 at 4:55 PM Michael Walle <michael@walle.cc> wrote:
>
> Hi,
>
> > Some GPIO lines have stopped working after the patch
> > commit 2ab73c6d8323f ("gpio: Support GPIO controllers without pin-ranges")
> >
> > And this has supposedly been fixed in the following patches
> > commit 89ad556b7f96a ("gpio: Avoid using pin ranges with !PINCTRL")
> > commit 6dbbf84603961 ("gpiolib: Don't free if pin ranges are not defined")
> >
> > But an erratic behavior where some GPIO lines work while others do not work
> > has been introduced.
> >
> > This patch reverts those changes so that the sysfs-gpio interface works
> > properly again.
> >
> > Signed-off-by: Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>
>
> This breaks the pinctrl-microchip-sgpio driver as far as I can see.
>
> I tried to debug it and this is what I have discovered so far:
>  (1) the sgpio driver will use the gpio_stub_drv for its child nodes.
>      Looks like a workaround, see [1].
>  (2) these will have an empty gpio range
>  (3) with the changes of this patch, pinctrl_gpio_request() will now
>      be called and will fail with -EPROBE_DEFER.
>
> I'm not exactly sure what to do here. Saravana Kannan once suggested
> to use devm_of_platform_populate() to probe the child nodes [2]. But
> I haven't found any other driver doing that.
>

TI AEMIF driver (drivers/memory/ti-aemif.c) does something like this:

406         if (np) {
407                 for_each_available_child_of_node(np, child_np) {
408                         ret = of_platform_populate(child_np, NULL,
409                                                    dev_lookup, dev);
410                         if (ret < 0) {
411                                 of_node_put(child_np);
412                                 goto error;
413                         }
414                 }
415         } else if (pdata) {
416                 for (i = 0; i < pdata->num_sub_devices; i++) {
417                         pdata->sub_devices[i].dev.parent = dev;
418                         ret =
platform_device_register(&pdata->sub_devices[i]);
419                         if (ret) {
420                                 dev_warn(dev, "Error register sub
device %s\n",
421                                          pdata->sub_devices[i].name);
422                         }
423                 }
424         }

A bunch of different devices (like NAND) get instantiated this way.
Would this work?

Bart

> Also, I'm not sure if there are any other other driver which get
> broken by this. I.e. ones falling into the gpio_stub_drv category.
>
> [1] https://lore.kernel.org/lkml/20210122193600.1415639-1-saravanak@google.com/
> [2] https://lore.kernel.org/lkml/CAGETcx9PiX==mLxB9PO8Myyk6u2vhPVwTMsA5NkD-ywH5xhusw@mail.gmail.com/
>
> -michael
>
> NB. this patch doesn't contain a Fixes tag. Was this on purpose?
