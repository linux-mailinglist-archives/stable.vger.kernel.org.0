Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 106BD50E872
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 20:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244489AbiDYSoe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 14:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244491AbiDYSoc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 14:44:32 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA4F23148
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 11:41:26 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id w16so10102681ejb.13
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 11:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mya3nkIwUh+TIu4djYFcQK6BbUW1zaOYt4akasWqvFg=;
        b=B9KKXsLTpzuVV8sBlKnNNvWObeafflqmJvR/smeZgdhpHe7uFZ496oEr1jZfzXMymA
         pVVpZlQzDspkhMyYyU2BEn3cLLzy+4K1AJIP8KNuHHK2F4+OXzHT0Lx4MAnyADwSC2fz
         C3xXlkkJaCxNbA2z0qwrIsYi0VRxXQVfQNb4GKBP2wWkiow6GzhhujMirqo82yf2GMd/
         sS9eWHmKe84vW/wgDaguhMBHbRRg6rKcnOyzyk/LMSi+TOaBqwwqq8KAdCli/3p2a2Tp
         LEvpc51OZYXOjxQlQEjLMcq9Lpjbv+8TlCYiyAzWWCKDPD+dZI8GzuCtdxJwpd8joV6j
         Wcaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mya3nkIwUh+TIu4djYFcQK6BbUW1zaOYt4akasWqvFg=;
        b=e5EKtUey3s+6NNgcoZBpdlghEHUEDzq0+d+2opXz5guDJsgDe71264UNktv94yjdqv
         RvN3+AbnDlgQRgB2xd17pCACIECHBE7ZMGzoW5Pt0nL7yh12zX1vdiiynC7uhxTrTrO/
         itczxXGAgCzz73GBcGgcuLoqZv8Xdyn6q7ugH4LhFoMILGxYw6pCfGAiACgc7VB9HRBE
         GiFcbqqa2RnVE/Eo7cV1wmJ+1VQUPo0Rv/VORQf7E4LKg0nVhJUDzNHit4xtJws9T1mc
         cV8SGDE/fE64KywdxMZd/mB7xj900ec4BQr5if3S3QIiiMN77/oBtM9PdlQVEBIpp6Gl
         sOGg==
X-Gm-Message-State: AOAM5300rUDbLe7PTZZKiZkKEioSvvPGOq7ItHImj9mbYTskL7d4Nxqm
        xXpwdOOciKvEte4nFvXEnTTms3Y091HaKwY9mcz/E5X93J+/dw==
X-Google-Smtp-Source: ABdhPJxxi69r7JPs9NcrUSZVx/mya0DVWjV7GHPAed3DI2n08j+lZIdXYcnh6dMilSxNEph0K4PXbEgKFunxQP6p+cs=
X-Received: by 2002:a17:907:6d94:b0:6e8:c309:9923 with SMTP id
 sb20-20020a1709076d9400b006e8c3099923mr17335243ejc.101.1650912084719; Mon, 25
 Apr 2022 11:41:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220422131452.20757-1-mario.limonciello@amd.com>
In-Reply-To: <20220422131452.20757-1-mario.limonciello@amd.com>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Mon, 25 Apr 2022 20:41:14 +0200
Message-ID: <CAMRc=Mf7FVN4QeAEdap_JzKmTy6i0A=BbcCZtCCQhzocg4PDfg@mail.gmail.com>
Subject: Re: [PATCH v2 0/1] Fix regression in 5.18 for GPIO
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Natikar Basavaraj <Basavaraj.Natikar@amd.com>,
        Gong Richard <Richard.Gong@amd.com>,
        regressions@lists.linux.dev,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Greg KH <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Shreeya Patel <shreeya.patel@collabora.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 22, 2022 at 3:15 PM Mario Limonciello
<mario.limonciello@amd.com> wrote:
>
> Linus,
>
> This patch is being sent directly to you because there has been
> a regression in 5.18 that I identified and sent a fix up that has been
> reviewed/tested/acked for nearly a week but the current subsystem
> maintainer (Bartosz) hasn't picked it up to send to you.
>

Hi Mario!

I don't have any previous submission in my inbox. Are you sure to have
used my current address (brgl@bgdev.pl)?

Bart

> It's a severe problem; anyone who hits it:
> 1) Power button doesn't work anymore
> 2) Can't resume their laptop from S3 or s2idle
>
> Because the original patch was cc stable@, it landed in stable releases
> and has been breaking people left and right as distros track the stable
> channels.  The patch is well tested. Would you please consider to pick
> this up directly to fix that regression?
>
> Thanks,
>
> Mario Limonciello (1):
>   gpio: Request interrupts after IRQ is initialized
>
>  drivers/gpio/gpiolib.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> --
> 2.34.1
>
