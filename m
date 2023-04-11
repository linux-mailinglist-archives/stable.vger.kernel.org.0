Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1716E6DDBC1
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 15:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbjDKNKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 09:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjDKNKK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 09:10:10 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D963540C5
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 06:10:08 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id 201so906514qkl.2
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 06:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1681218608;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zf73QU/vp2FR2MAJTQ+Ali/CjjJipWz08ZhCoQgQ1ms=;
        b=PHsTIwBY3MYsQ9dnFd+Ps0AgLQyXKa/g7dqspz1ZYbVa8+wrNGnkqtn8TZHNMkMUSr
         og3xCWJDxpwBegBEV/xShi4Lz6ogAqCiCKiRCkkbY8CLqcaJrwHKCXeAD74+t/ZVR++Q
         +bUahcSevbUmAy716SNvl6UHXnPAuHRYyAErI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681218608;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zf73QU/vp2FR2MAJTQ+Ali/CjjJipWz08ZhCoQgQ1ms=;
        b=AZlUHZl410qePqwqVRUnHXYLGzuvylGLSmU/IxXSORUFWiSX9ufXR4cBMC3UB/AXQH
         NcIyP2kq1Vj+PoCS4SX22Peve1VD5h1RJhU/W6KkLZgwUic1+0UxXYQtWCeQCOa+6RWM
         w9g33ohN8YjScx0JFWuJq5k4P3BNDz2NF/QiWELSXPjrg+SYlLrlgmQEuW73pOyNrITY
         Zk14WgFX74/PsiTb56B+UzSES8TfgTE8vYjcqgRyeQBH5TEecRzkzfuS1w4Ojln6Ovtk
         iw3D6J5a1q/IVThM1ukR0tfNnTpmLAPc+LgNkkGOu0gaYBXajajoSqDcOLET6zjVMTQw
         iOxw==
X-Gm-Message-State: AAQBX9cHaZQgDHUDA+lNoPr2GaTM3JPecOdHHa5SzfU664iwdA1cJ2zN
        u5AV2nhCRGqJF1STDvnOmuW/FkBaNQt4M+A27qASmQ==
X-Google-Smtp-Source: AKy350aytpXAmt2I4/HuOkFhNjWfbiyryLtfZciMpH4rg8ps+0TEo4wgOX9w5A+Nz5hz/IFjHMD3zaA2/sonr1A8iRs=
X-Received: by 2002:a05:620a:28c4:b0:745:a35f:ad71 with SMTP id
 l4-20020a05620a28c400b00745a35fad71mr4712462qkp.13.1681218607964; Tue, 11 Apr
 2023 06:10:07 -0700 (PDT)
MIME-Version: 1.0
References: <20230320093259.845178-1-korneld@chromium.org> <d1d39179-33a0-d35b-7593-e0a02aa3b10a@amd.com>
 <ed840be8-b27b-191e-4122-72f62d8f1b7b@amd.com> <37178398-497c-900b-361a-34b1b77517aa@leemhuis.info>
In-Reply-To: <37178398-497c-900b-361a-34b1b77517aa@leemhuis.info>
From:   =?UTF-8?Q?Kornel_Dul=C4=99ba?= <korneld@chromium.org>
Date:   Tue, 11 Apr 2023 15:09:56 +0200
Message-ID: <CAD=NsqzFiQBxtVDmCiJ24HD0YZiwZ4PQkojHHic775EKfeuiaQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: amd: Disable and mask interrupts on resume
To:     Linux regressions mailing list <regressions@lists.linux.dev>
Cc:     gregkh@linuxfoundation.org,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        upstream@semihalf.com, rad@semihalf.com, mattedavis@google.com,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        "Gong, Richard" <richard.gong@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 11, 2023 at 2:50=E2=80=AFPM Linux regression tracking (Thorsten
Leemhuis) <regressions@leemhuis.info> wrote:
>
>
>
> On 10.04.23 17:29, Gong, Richard wrote:
> > On 4/10/2023 12:03 AM, Mario Limonciello wrote:
> >> On 3/20/23 04:32, Kornel Dul=C4=99ba wrote:
> >>
> >>> This fixes a similar problem to the one observed in:
> >>> commit 4e5a04be88fe ("pinctrl: amd: disable and mask interrupts on
> >>> probe").
> >>>
> >>> On some systems, during suspend/resume cycle firmware leaves
> >>> an interrupt enabled on a pin that is not used by the kernel.
> >>> This confuses the AMD pinctrl driver and causes spurious interrupts.
> >>>
> >>> The driver already has logic to detect if a pin is used by the kernel=
.
> >>> Leverage it to re-initialize interrupt fields of a pin only if it's n=
ot
> >>> used by us.
> >>>
> >>> Signed-off-by: Kornel Dul=C4=99ba <korneld@chromium.org>
> >>> ---
> >>>   drivers/pinctrl/pinctrl-amd.c | 36 +++++++++++++++++++-------------=
---
> >>>   1 file changed, 20 insertions(+), 16 deletions(-)
> >>>
> >>> diff --git a/drivers/pinctrl/pinctrl-amd.c
> >>> b/drivers/pinctrl/pinctrl-amd.c
> >>> index 9236a132c7ba..609821b756c2 100644
> >>> --- a/drivers/pinctrl/pinctrl-amd.c
> >>> +++ b/drivers/pinctrl/pinctrl-amd.c
> >>> @@ -872,32 +872,34 @@ static const struct pinconf_ops amd_pinconf_ops
> >>> =3D {
> >>>       .pin_config_group_set =3D amd_pinconf_group_set,
> >>>   };
> >>>   -static void amd_gpio_irq_init(struct amd_gpio *gpio_dev)
> >>> +static void amd_gpio_irq_init_pin(struct amd_gpio *gpio_dev, int pin=
)
> >>>   {
> >>> -    struct pinctrl_desc *desc =3D gpio_dev->pctrl->desc;
> >>> +    const struct pin_desc *pd;
> >>>       unsigned long flags;
> >>>       u32 pin_reg, mask;
> >>> -    int i;
> >>>         mask =3D BIT(WAKE_CNTRL_OFF_S0I3) | BIT(WAKE_CNTRL_OFF_S3) |
> >>>           BIT(INTERRUPT_MASK_OFF) | BIT(INTERRUPT_ENABLE_OFF) |
> >>>           BIT(WAKE_CNTRL_OFF_S4);
> >>>   -    for (i =3D 0; i < desc->npins; i++) {
> >>> -        int pin =3D desc->pins[i].number;
> >>> -        const struct pin_desc *pd =3D pin_desc_get(gpio_dev->pctrl, =
pin);
> >>> -
> >>> -        if (!pd)
> >>> -            continue;
> >>> +    pd =3D pin_desc_get(gpio_dev->pctrl, pin);
> >>> +    if (!pd)
> >>> +        return;
> >>>   -        raw_spin_lock_irqsave(&gpio_dev->lock, flags);
> >>> +    raw_spin_lock_irqsave(&gpio_dev->lock, flags);
> >>> +    pin_reg =3D readl(gpio_dev->base + pin * 4);
> >>> +    pin_reg &=3D ~mask;
> >>> +    writel(pin_reg, gpio_dev->base + pin * 4);
> >>> +    raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
> >>> +}
> >>>   -        pin_reg =3D readl(gpio_dev->base + i * 4);
> >>> -        pin_reg &=3D ~mask;
> >>> -        writel(pin_reg, gpio_dev->base + i * 4);
> >>> +static void amd_gpio_irq_init(struct amd_gpio *gpio_dev)
> >>> +{
> >>> +    struct pinctrl_desc *desc =3D gpio_dev->pctrl->desc;
> >>> +    int i;
> >>>   -        raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
> >>> -    }
> >>> +    for (i =3D 0; i < desc->npins; i++)
> >>> +        amd_gpio_irq_init_pin(gpio_dev, i);
> >>>   }
> >>>     #ifdef CONFIG_PM_SLEEP
> >>> @@ -950,8 +952,10 @@ static int amd_gpio_resume(struct device *dev)
> >>>       for (i =3D 0; i < desc->npins; i++) {
> >>>           int pin =3D desc->pins[i].number;
> >>>   -        if (!amd_gpio_should_save(gpio_dev, pin))
> >>> +        if (!amd_gpio_should_save(gpio_dev, pin)) {
> >>> +            amd_gpio_irq_init_pin(gpio_dev, pin);
> >>>               continue;
> >>> +        }
> >>>             raw_spin_lock_irqsave(&gpio_dev->lock, flags);
> >>>           gpio_dev->saved_regs[i] |=3D readl(gpio_dev->base + pin * 4=
)
> >>> & PIN_IRQ_PENDING;
> >>
> >> Hello Kornel,
> >>
> >> I've found that this commit which was included in 6.3-rc5 is causing a
> >> regression waking up from lid on a Lenovo Z13.
> > observed "unable to wake from power button" on AMD based Dell platform.
>
> This sounds like something that we want to fix quickly.
>
> > Reverting "pinctrl: amd: Disable and mask interrupts on resume" on the
> > top of 6.3-rc6 does fix the issue.
> >>
> >> Reverting it on top of 6.3-rc6 resolves the problem.
> >>
> >> I've collected what I can into this bug report:
> >>
> >> https://bugzilla.kernel.org/show_bug.cgi?id=3D217315
> >>
> >> Linus Walleij,
> >>
> >> It looks like this was CC to stable.  If we can't get a quick solution
> >> we might want to pull this from stable.
> >
> > this commit landed into 6.1.23 as well
> >
> >         d9c63daa576b2 pinctrl: amd: Disable and mask interrupts on resu=
me
>
> It made it back up to 5.10.y afaics.
>
> The culprit has no fixes tag, which makes me wonder: should we quickly
> (e.g. today) revert this in mainline to get back to the previous state,
> so that Greg can pick up the revert for the next stable releases he
> apparently currently prepares?
>
> Greg, is there another way to make you quickly fix this in the stable
> trees? One option obviously would be "revert this now in stable, reapply
> it later together with a fix ". But I'm under the impression that this
> is too much of a hassle and thus something you only do in dire situations=
?
>
> I'm asking because I over time noticed that quite a few regressions are
> in a similar situation -- and quite a few of them take quite some time
> to get fixed even when a developer provided a fix, because reviewing and
> mainlining the fix takes a week or two (sometimes more). And that is a
> situation that is more and more hitting a nerve here. :-/

I've looked into this and at this moment I can't really find a quick fix.
See https://bugzilla.kernel.org/show_bug.cgi?id=3D217315#c3.
It seems that reverting this might be the best solution for now.

Regards
Kornel
