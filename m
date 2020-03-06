Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E55317BF67
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 14:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgCFNn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 08:43:27 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35227 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbgCFNn1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Mar 2020 08:43:27 -0500
Received: by mail-lj1-f193.google.com with SMTP id a12so2271090ljj.2
        for <stable@vger.kernel.org>; Fri, 06 Mar 2020 05:43:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zb2TTsi0V/WK3nQTc1Yis0dTQ/eZrvkVEovvn7cohJk=;
        b=ZRPCnB6gB2icTUcLEGf/QfTE6829diowNo1PYDn9Np7inEPSwC2tWuTp2fZEb1OiLh
         lktsBsxe/fYfmSHXfVc3V7TvWaskkSztIxXt9UiRDxZZ6a0YOKwS8G+S/MWbJCgFbI5v
         +Klpzvmz1FDqFsBSu2lAOGTL63LqHZ7iieQsE7Pub763BbHPPUytzgXTGPjX1mMDtDD+
         ncFg8x/9ABUicNp/k7NQvGJCfHLYbOgHEOzfd+oQo3+TDnUM9gQQR4/K9omOkBcmuS+s
         IfeBdp0yoS2oZsyg4PKLy0G+Cax9qhglDjkYJO3TxAumovhGv9ivyF31krNwNrLu7hWn
         SBDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zb2TTsi0V/WK3nQTc1Yis0dTQ/eZrvkVEovvn7cohJk=;
        b=SdVOuPHYsphFgCtJNvJEBT5XooS7iWLkQ8FFWNSf4bWe+js7eabpdqKtoI/O2nwhIB
         ouFmy4eu3RhaeFchS9JSyHrVN9BC35yO6eRbjBDmr2WzDGZakf6ubf0Ng1Vl1JH9bel3
         G5Zz72H7ZBGvKdXiAVBI9avtp9/C7mibBwLX2dMLcH+crPo6AWZi8qIOnmHTo25o9A0T
         kz7YZIcuOWv/2OKjSyLBCYuMvFK1egpou+1DRNYhEHYa++opjF/ZK+H7qPwLP4Bi2txH
         9+6ji5BOp90oMpEqPofnmAzfQO/SAWc9v0RrLf0yRMF2gEhsikjfHV4uiiMrjhdjawtb
         PH7A==
X-Gm-Message-State: ANhLgQ2wTsa+2wdsgBw7HNb0PJ1l/BSj00ToUaiiQOEefYquqOJmnLdl
        CFPmNKA2GfDwDGYvYfodJ6Kh2BpMB5vWPxTSeB8dgg==
X-Google-Smtp-Source: ADFU+vtF/x1al2/6PrB3XuIDiJLvtaydKKZye9VdfRaEqnHdO8AJrJYADGUDTVFvLXh/xCxVUBPho141tXnr3CVSzDE=
X-Received: by 2002:a05:651c:44b:: with SMTP id g11mr2051727ljg.168.1583502205236;
 Fri, 06 Mar 2020 05:43:25 -0800 (PST)
MIME-Version: 1.0
References: <20200306121221.1231296-1-linus.walleij@linaro.org> <bf5be11de00a4d32c31bfc122704c5b0@kernel.org>
In-Reply-To: <bf5be11de00a4d32c31bfc122704c5b0@kernel.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Fri, 6 Mar 2020 14:43:13 +0100
Message-ID: <CACRpkdb4_QN35=GYuOfBWMEv=sZX95bQsoNgux0zruZEj2-7BA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: qcom: Guard irq_eoi()
To:     Marc Zyngier <maz@kernel.org>
Cc:     "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Lina Iyer <ilina@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 6, 2020 at 1:18 PM Marc Zyngier <maz@kernel.org> wrote:
> On 2020-03-06 12:12, Linus Walleij wrote:

> > +static void msm_gpio_irq_eoi(struct irq_data *d)
> > +{
> > +     if (d->parent_data)
> > +             irq_chip_eoi_parent(d);
> > +}
> > +
(...)
> > -     pctrl->irq_chip.irq_eoi = irq_chip_eoi_parent;
> > +     pctrl->irq_chip.irq_eoi = msm_gpio_irq_eoi;
> >       pctrl->irq_chip.irq_set_type = msm_gpio_irq_set_type;
> >       pctrl->irq_chip.irq_set_wake = msm_gpio_irq_set_wake;
> >       pctrl->irq_chip.irq_request_resources = msm_gpio_irq_reqres;
>
> Long term, it may me better to offer a different set of callbacks
> for interrupts that are terminated at the pinctrl level.

Yeah, it's gpiolib here actually. Pin control is pretty much innocent,
it's just that the driver doubles as a GPIO driver with an irqchip
inside it.

> In the meantime, and as a fix:
>
> Acked-by: Marc Zyngier <maz@kernel.org>
>
> I assume you'll take this via the pinctrl tree?

Yeps, thanks Marc!

Yours,
Linus Walleij
