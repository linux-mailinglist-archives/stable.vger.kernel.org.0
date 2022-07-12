Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7FF571349
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 09:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232391AbiGLHlx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 03:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiGLHlt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 03:41:49 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C269B9C4
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 00:41:48 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id sz17so12803080ejc.9
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 00:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NSrNMqUgWaYuH+mTVW1bDRg+I5uODANEes06ggGuCQ8=;
        b=hSinwd2+o7s7Z5GqAva/JbWo3c3bbU31+fz4J9bmDcla74i63981XKzdYwltOdOu1s
         2jTGjN6+qb5wlVV+hkl0h60UYgDH8kFDFL2aVikT8YCXbwim0ernZtNOJWgcZbcLbb2i
         PdZr11THsg6zAbwfwDrRoSIduA+KV9lUAknSTADM1h0faJPFYZo/mf86nSUbWkClq5Mp
         52rUpSHWGHvwV/UJ1DbTRI/iEgEA0ZuaV0I/zwH8xzq5VaxPhbdIqHoWScSbZ4olJSPO
         CfUTV8fs2HWp92EhfeTstC8tbHSSCX/trZxM0SQybm5vscnXl8h0QEebFp1UHZlMj3zm
         xCQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NSrNMqUgWaYuH+mTVW1bDRg+I5uODANEes06ggGuCQ8=;
        b=fZ+Ub1zKlms8T7ATh66TUOLb7aWWQOCeQ/XI+k/KJxQq2OmUx7+WSjdRR8TNKKoO09
         1Gsu9ieTY7aJWpDpaDlzw27prULn0yGGsORSh0lDYO/Quw04qoMjiuuW0CIojZiaF+dZ
         daWMEN9bb6xZD2K74OR6tUW/6tK330QiIVOzC5imH7jDPQHEqs2u9MZ6zz/KB4ut7kUv
         a3mC2mO/ZwgzzDUU71RyApcYHl9UQ407kiYN8diWiaag/tw+ZNYW6XtP5ccYsAtb0VDS
         uwyDWjNYTxgmWcqHUudKw7nbMbDDKvsE3Vl+ss1ZzSNZSfOP9M6140ibtX5Kz5t3bnqD
         Pv/A==
X-Gm-Message-State: AJIora8j59O0mmPXRpnqwjO5eyGppZ+BwXx3ByM1YZ4nbYnxw6XOnbQb
        RAzh3mrJ6xChyZ3wRku5lBxUsf6kzqRyOWQW4owrVg==
X-Google-Smtp-Source: AGRyM1t1jqeS/pkiVbY2dvEmVvi4l4xwSga9AY8LFBsQiNHxBtdvWIBVEBlrrfH6Dh4ib0IVtklOMMyO9OTHI3qY87c=
X-Received: by 2002:a17:907:cc14:b0:726:3555:ac63 with SMTP id
 uo20-20020a170907cc1400b007263555ac63mr21853308ejc.697.1657611706834; Tue, 12
 Jul 2022 00:41:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220711173418.91709-1-brgl@bgdev.pl> <20220712023714.GA9406@sol>
In-Reply-To: <20220712023714.GA9406@sol>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Tue, 12 Jul 2022 09:41:36 +0200
Message-ID: <CAMRc=McJjcOo2_xcU0CgoQMO9PJH3t_dWeSyS8QX3wYaxeufhA@mail.gmail.com>
Subject: Re: [PATCH] gpio: sim: fix the chip_name configfs item
To:     Kent Gibson <warthog618@gmail.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 12, 2022 at 4:37 AM Kent Gibson <warthog618@gmail.com> wrote:
>
> On Mon, Jul 11, 2022 at 07:34:18PM +0200, Bartosz Golaszewski wrote:
> > The chip_name configs attribute always displays the device name of the
> > first GPIO bank because the logic of the relevant function is simply
> > wrong.
> >
> > Fix it by correctly comparing the bank's swnode against the GPIO
> > device's children.
> >
>
> That works for me, so thanks for that.
>
> Not totally convinced by Andy's suggestion to rename swnode to fwnode.
> Variables should be named for what they represent, not their type, and
> you use swnode extensively elsewhere in the module, so either change it
> everywhere or not at all, and such a sweeping change is beyond the scope
> this patch.
>
> Though it may make his other suggestion to use device_match_fwnode()
> read a little better.  No issue with that suggestion.
>
> Cheers,
> Kent.

I agree on device_match_fwnode() and disagree on the swnode rename. v2 sent out.

Bart
