Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72CF14DC1D2
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 09:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbiCQIt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 04:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbiCQItz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 04:49:55 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61F899EC1;
        Thu, 17 Mar 2022 01:48:38 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id D0D0222205;
        Thu, 17 Mar 2022 09:48:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1647506915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4a3Y2KbnQUavIG9wl141tJRVHNXn1CwqBXUisBhaUd4=;
        b=NZ9t78xnhuHUDDjP/0YFzN3J6vMiQe0j3kwSsCbKIbcZz+Fprpc0+HEHh8vMORaKPGKk++
        9meCilS92zd6+m1L4z6nTn3dhfRMW98yBBlSgVPNtw1JFfHnRFV6f2dteqiWXm2z0R9D6Z
        cFvgNtnxbY4bMJKb4DC+RnPdDo5KDVs=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 17 Mar 2022 09:48:28 +0100
From:   Michael Walle <michael@walle.cc>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Saravana Kannan <saravanak@google.com>,
        Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>,
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
In-Reply-To: <CAHp75VeoFQHAh6SbVu7fsXfziW+2RoFTWKA6jFhFswBbazzGAA@mail.gmail.com>
References: <20211217153555.9413-1-marcelo.jimenez@gmail.com>
 <20220314155509.552218-1-michael@walle.cc>
 <CAMRc=MfH00YJv07TaiZ5z1w4gzqP5_8z9bKFcNU1Z37AVih4hQ@mail.gmail.com>
 <fe1ba600b2b30b4cba702d6aebdfda50@walle.cc>
 <CAHp75VeoFQHAh6SbVu7fsXfziW+2RoFTWKA6jFhFswBbazzGAA@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <8a1a46f1e5b822fd49f56f2fe50c5396@walle.cc>
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

Am 2022-03-17 09:37, schrieb Andy Shevchenko:
> On Thu, Mar 17, 2022 at 7:36 AM Michael Walle <michael@walle.cc> wrote:
>> Am 2022-03-15 16:32, schrieb Bartosz Golaszewski:
>> > On Mon, Mar 14, 2022 at 4:55 PM Michael Walle <michael@walle.cc> wrote:
> 
> ...
> 
>> I started to try this out, but then I was wondering if there weren't
>> other gpio/pinctrl drivers with the same problem. And judging by the
>> reports [1], I'd say there are. Then I wasn't sure if this is actually
>> the correct fix here - or if that old workaround [2] doesn't work
>> anymore because it might have that empty ranges "feature".
>> 
>> To answer your question: I don't know. But I don't know if that is
>> actually the correct way of fixing this either.
>> 
>> >> Also, I'm not sure if there are any other other driver which get
>> >> broken by this. I.e. ones falling into the gpio_stub_drv category.
> 
> I know that OF is a mess, but I want to understand why in ACPI we
> haven't experienced such an issue. Any pointers would be appreciated.

During debugging I've seen that the pinctrl-microchip-sgpio will
report itself as gpio_stub_drv. You'll find that this driver
was added by the following commit:

commit 4731210c09f5977300f439b6c56ba220c65b2348
Author: Saravana Kannan <saravanak@google.com>
Date:   Fri Jan 22 11:35:59 2021 -0800

     gpiolib: Bind gpio_device to a driver to enable fw_devlink=on by 
default

The microchip driver has actually a binding which was described in
that commit message. Thus I concluded, that it makes sense this driver
falls into that workaround. That is where I stopped and wrote this mail.
Actually, I haven't found out yet where that fallback to gpio_stub_drv
is happening.

-michael
