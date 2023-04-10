Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36B8E6DC958
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 18:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbjDJQdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 12:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbjDJQdL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 12:33:11 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0161EE60
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 09:33:10 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id cj22so6155636qtb.3
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 09:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1681144389;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vOqt5bGY3kNciAf6pRF9TDqG1MXHTnp3S4ERZCDT/DA=;
        b=l+KzfvBDEuyAAIoEfJbOVyL4AydLp6IS4ij70jql2WrfRurpWWpSTuXVaiRn988yMg
         iUt/PRbqbH/QwQtpBeea90UmMQ7D8VmcfTSHOzyHlo7LKGFeXWWxkd/SOVAIUKPMLkw5
         VJ5MGUaNDiQUwQwdFYoq1q2l3GhuUafUSIE1g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681144389;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vOqt5bGY3kNciAf6pRF9TDqG1MXHTnp3S4ERZCDT/DA=;
        b=4wpW/W8c1mWMN8PEvo3iSDIOTV5rabzRfQwkUc34DOJ47Wo3ISjWUBB6iOr+2lJ9GH
         QyepE5AP9APQMGBXntV0dFhaC+L0/nwvEBbvAIYi22rcxwwinQ7Ic2VDlFJZLH0u+Q8c
         ZiPm7zyudQl9BlVEG4iAFYkKJMaCJw5WarkVrANiQCnzqQPOtt7VJQIHXJNRbBpukkHd
         N6UW0WPNyucV1ejxOTnAE8VPcERzgVc0l/Pt175KVD5Df2wJXlNWt/mffjMoDmeL2qLn
         ohv5M+Lw6ruwOSRCinASbN6dUM20krYtj9A9r37AlwuUFp3uWP21oCn/7rIJINLA8TGe
         b+Sg==
X-Gm-Message-State: AAQBX9eNehiG7x1Dl3WC2Rwo5hzxg7tagWdzJnytxTLSb/5x0RvB3Rdf
        zdfwHjdXjcNBudoyDXI1OCDq0qlpnqpFqytbzaCgvQ==
X-Google-Smtp-Source: AKy350bijpEo3DiDjS2l7xbSnP2q0Igy8MzRljtqCaw/DnIxNffMKuFO1B5yHni8PpSdKIOCenGacJZcwRV8wv4tRe0=
X-Received: by 2002:ac8:5a95:0:b0:3e3:8e3e:27a4 with SMTP id
 c21-20020ac85a95000000b003e38e3e27a4mr4164239qtc.4.1681144389150; Mon, 10 Apr
 2023 09:33:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230320093259.845178-1-korneld@chromium.org> <d1d39179-33a0-d35b-7593-e0a02aa3b10a@amd.com>
 <ed840be8-b27b-191e-4122-72f62d8f1b7b@amd.com> <CAD=NsqxSDUu3wpfhUCDJgP2TaKb7dudB90snROQpPJPj3fdFgQ@mail.gmail.com>
In-Reply-To: <CAD=NsqxSDUu3wpfhUCDJgP2TaKb7dudB90snROQpPJPj3fdFgQ@mail.gmail.com>
From:   =?UTF-8?Q?Kornel_Dul=C4=99ba?= <korneld@chromium.org>
Date:   Mon, 10 Apr 2023 18:32:58 +0200
Message-ID: <CAD=NsqyAXK0z7XqVy=coSm40zOe0yS+h=oiDD8a-udDT5WKMdw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: amd: Disable and mask interrupts on resume
To:     "Gong, Richard" <richard.gong@amd.com>
Cc:     Mario Limonciello <mario.limonciello@amd.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        regressions@leemhuis.info,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        upstream@semihalf.com, rad@semihalf.com, mattedavis@google.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
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

On Mon, Apr 10, 2023 at 6:17=E2=80=AFPM Kornel Dul=C4=99ba <korneld@chromiu=
m.org> wrote:
>
> On Mon, Apr 10, 2023 at 5:29=E2=80=AFPM Gong, Richard <richard.gong@amd.c=
om> wrote:
> >
> > On 4/10/2023 12:03 AM, Mario Limonciello wrote:
> > > On 3/20/23 04:32, Kornel Dul=C4=99ba wrote:
> > >
> > >> This fixes a similar problem to the one observed in:
> > >> commit 4e5a04be88fe ("pinctrl: amd: disable and mask interrupts on
> > >> probe").
> > >>
> > >> On some systems, during suspend/resume cycle firmware leaves
> > >> an interrupt enabled on a pin that is not used by the kernel.
> > >> This confuses the AMD pinctrl driver and causes spurious interrupts.
> > >>
> > >> The driver already has logic to detect if a pin is used by the kerne=
l.
> > >> Leverage it to re-initialize interrupt fields of a pin only if it's =
not
> > >> used by us.
> > >>
> > >> Signed-off-by: Kornel Dul=C4=99ba <korneld@chromium.org>
> > >> ---
> > >>   drivers/pinctrl/pinctrl-amd.c | 36 +++++++++++++++++++------------=
----
> > >>   1 file changed, 20 insertions(+), 16 deletions(-)
> > >>
> > >> diff --git a/drivers/pinctrl/pinctrl-amd.c
> > >> b/drivers/pinctrl/pinctrl-amd.c
> > >> index 9236a132c7ba..609821b756c2 100644
> > >> --- a/drivers/pinctrl/pinctrl-amd.c
> > >> +++ b/drivers/pinctrl/pinctrl-amd.c
> > >> @@ -872,32 +872,34 @@ static const struct pinconf_ops amd_pinconf_op=
s
> > >> =3D {
> > >>       .pin_config_group_set =3D amd_pinconf_group_set,
> > >>   };
> > >>   -static void amd_gpio_irq_init(struct amd_gpio *gpio_dev)
> > >> +static void amd_gpio_irq_init_pin(struct amd_gpio *gpio_dev, int pi=
n)
> > >>   {
> > >> -    struct pinctrl_desc *desc =3D gpio_dev->pctrl->desc;
> > >> +    const struct pin_desc *pd;
> > >>       unsigned long flags;
> > >>       u32 pin_reg, mask;
> > >> -    int i;
> > >>         mask =3D BIT(WAKE_CNTRL_OFF_S0I3) | BIT(WAKE_CNTRL_OFF_S3) |
> > >>           BIT(INTERRUPT_MASK_OFF) | BIT(INTERRUPT_ENABLE_OFF) |
> > >>           BIT(WAKE_CNTRL_OFF_S4);
> > >>   -    for (i =3D 0; i < desc->npins; i++) {
> > >> -        int pin =3D desc->pins[i].number;
> > >> -        const struct pin_desc *pd =3D pin_desc_get(gpio_dev->pctrl,=
 pin);
> > >> -
> > >> -        if (!pd)
> > >> -            continue;
> > >> +    pd =3D pin_desc_get(gpio_dev->pctrl, pin);
> > >> +    if (!pd)
> > >> +        return;
> > >>   -        raw_spin_lock_irqsave(&gpio_dev->lock, flags);
> > >> +    raw_spin_lock_irqsave(&gpio_dev->lock, flags);
> > >> +    pin_reg =3D readl(gpio_dev->base + pin * 4);
> > >> +    pin_reg &=3D ~mask;
> > >> +    writel(pin_reg, gpio_dev->base + pin * 4);
> > >> +    raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
> > >> +}
> > >>   -        pin_reg =3D readl(gpio_dev->base + i * 4);
> > >> -        pin_reg &=3D ~mask;
> > >> -        writel(pin_reg, gpio_dev->base + i * 4);
> > >> +static void amd_gpio_irq_init(struct amd_gpio *gpio_dev)
> > >> +{
> > >> +    struct pinctrl_desc *desc =3D gpio_dev->pctrl->desc;
> > >> +    int i;
> > >>   -        raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
> > >> -    }
> > >> +    for (i =3D 0; i < desc->npins; i++)
> > >> +        amd_gpio_irq_init_pin(gpio_dev, i);
> > >>   }
> > >>     #ifdef CONFIG_PM_SLEEP
> > >> @@ -950,8 +952,10 @@ static int amd_gpio_resume(struct device *dev)
> > >>       for (i =3D 0; i < desc->npins; i++) {
> > >>           int pin =3D desc->pins[i].number;
> > >>   -        if (!amd_gpio_should_save(gpio_dev, pin))
> > >> +        if (!amd_gpio_should_save(gpio_dev, pin)) {
> > >> +            amd_gpio_irq_init_pin(gpio_dev, pin);
> > >>               continue;
> > >> +        }
> > >>             raw_spin_lock_irqsave(&gpio_dev->lock, flags);
> > >>           gpio_dev->saved_regs[i] |=3D readl(gpio_dev->base + pin * =
4)
> > >> & PIN_IRQ_PENDING;
> > >
> > > Hello Kornel,
> > >
> > > I've found that this commit which was included in 6.3-rc5 is causing =
a
> > > regression waking up from lid on a Lenovo Z13.
> > observed "unable to wake from power button" on AMD based Dell platform.
> > Reverting "pinctrl: amd: Disable and mask interrupts on resume" on the
> > top of 6.3-rc6 does fix the issue.
>
> Whoops, sorry for the breakage.
> Could you please share the output of "/sys/kernel/debug/gpio" before
> and after the first suspend/resume cycle.
Oh and also I'd need to compare the output from this with and without
this patch reverted.
> I've looked at the patch again and found a rather silly mistake.
> Please try the following.
> Note that I don't have access to hardware with this controller at the
> moment, so I've only compile tested it.
>
> diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.=
c
> index 609821b756c2..7e7770152ca8 100644
> --- a/drivers/pinctrl/pinctrl-amd.c
> +++ b/drivers/pinctrl/pinctrl-amd.c
> @@ -899,7 +899,7 @@ static void amd_gpio_irq_init(struct amd_gpio *gpio_d=
ev)
>         int i;
>
>         for (i =3D 0; i < desc->npins; i++)
> -               amd_gpio_irq_init_pin(gpio_dev, i);
> +               amd_gpio_irq_init_pin(gpio_dev, desc->pins[i].number);
>  }
>
>
> > >
> > > Reverting it on top of 6.3-rc6 resolves the problem.
> > >
> > > I've collected what I can into this bug report:
> > >
> > > https://bugzilla.kernel.org/show_bug.cgi?id=3D217315
> > >
> > > Linus Walleij,
> > >
> > > It looks like this was CC to stable.  If we can't get a quick solutio=
n
> > > we might want to pull this from stable.
> >
> > this commit landed into 6.1.23 as well
> >
> >          d9c63daa576b2 pinctrl: amd: Disable and mask interrupts on res=
ume
> >
> > >
> > > Thanks,
> > >
> > >
> > Regards,
> >
> > Richard
> >
