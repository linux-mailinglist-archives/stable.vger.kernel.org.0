Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8A134020
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 09:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfFDHbP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 03:31:15 -0400
Received: from mail-ua1-f66.google.com ([209.85.222.66]:46430 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726742AbfFDHbP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 03:31:15 -0400
Received: by mail-ua1-f66.google.com with SMTP id a95so7414309uaa.13
        for <stable@vger.kernel.org>; Tue, 04 Jun 2019 00:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=liKHPncWOckMU0VpUC12b4lHB8RDKVamTsMkqWq9QS8=;
        b=pBWhAx1YgC0xfBUniJ64GQxUiO+aAT1hfrtvJ3NHp7giCrOXogoNhXvDhHaneh0wvt
         3LNcd2E9BBt5jRT4Hh8q2/pxIP4n/6QfNng62w1L9Na2TniGZKWcRbo45voYqcLguccz
         qTv55JDhWIHfY4Jjl/P53uPtQVNQvtfOIfjbbEuWh3fQngdSz5k1sa4NaQ9+DC8012Ot
         DDHkh4Lew+iPe8KLIZymjj1fOf3tinN0ERo6InehQK22Mppo7htd85X5kdeew7KW6n3W
         jRvG/NNzn4+76SVcU9CeRQDGRV4PFWOKQwiyV4dMGkr4o0CY1yjM9KtiObPKEYD9IBt9
         9jcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=liKHPncWOckMU0VpUC12b4lHB8RDKVamTsMkqWq9QS8=;
        b=pYgwvp4mCBKpf9w8k3KrRhAxfG4T5Lpe02cwTtJnX2RUCDCf8EAD3JMvzoa/kSDDnN
         N3kWDQAzhM+ENSwkB6cEJrtJVzEFNMeu4SH4Pt+2jsErGPppXBxtYU0WSzS4Bpd6659e
         V8jQveV8WGiy4+5r/ayE1eWGDqgCnnb3CdACwlnGoq+RE6CsZoElZYNBrIFMnrlU22kt
         nEDCD49pI+hRfUsCruaqf3pnMSOrKXedp8bFtlIJKTvBSOcyG23wXXS2BrA5uxTYpB1S
         J9zMTRE9UUinAg6tnRrOru2y17ZZji5g3eKQbF10DwfOtnx2QmbLdCj4M6g9OxHNBrW5
         i5sQ==
X-Gm-Message-State: APjAAAXkOmd253u3VWWgiVxG5k9dKfc4UomIAMkG+vkV6LV/YSXD+RYa
        BZTEHDW1ZqPAUj4PfWmKp/WhYO30Zfhi93hdtGnXuA==
X-Google-Smtp-Source: APXvYqwRSbtZYdCjB8whq7+U5NeLJqf4f+zeXI8CzJ2cgm83LN/kdT2cdEZ7iFkIM1drZeG9nKJsq5islj1NytCSefw=
X-Received: by 2002:ab0:5608:: with SMTP id y8mr15100647uaa.129.1559633474312;
 Tue, 04 Jun 2019 00:31:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190429204040.18725-1-dianders@chromium.org> <CAPDyKFp0fQ+3CS-DadE9rO-9Npzve-nztY9hRaMdX7Pw9sUZMw@mail.gmail.com>
 <CAD=FV=XMph_CE3pFZGP+5d0K2FgbPbheF1oX72TfZn_dpf8SQA@mail.gmail.com> <CAD=FV=U7_ek_z7UfaDn9My8UfZfpNom04OJHowoH-sNsGZQnxA@mail.gmail.com>
In-Reply-To: <CAD=FV=U7_ek_z7UfaDn9My8UfZfpNom04OJHowoH-sNsGZQnxA@mail.gmail.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Tue, 4 Jun 2019 09:30:37 +0200
Message-ID: <CAPDyKFoo7yyhZq8G3PzHSNnF5nWPL7Dy5a-abL-kQTP2jEt9KQ@mail.gmail.com>
Subject: Re: [PATCH v2] mmc: dw_mmc: Disable SDIO interrupts while suspended
 to fix suspend/resume
To:     Doug Anderson <dianders@chromium.org>
Cc:     Jaehoon Chung <jh80.chung@samsung.com>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Heiko Stuebner <heiko@sntech.de>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Guenter Roeck <groeck@chromium.org>,
        Brian Norris <briannorris@chromium.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Sonny Rao <sonnyrao@chromium.org>,
        Emil Renner Berthing <emil.renner.berthing@gmail.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Ryan Case <ryandcase@chromium.org>,
        "# 4.0+" <stable@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 3 Jun 2019 at 20:41, Doug Anderson <dianders@chromium.org> wrote:
>
> Ulf,
>
> On Tue, May 28, 2019 at 3:49 PM Doug Anderson <dianders@chromium.org> wrote:
> >
> > > 1) As kind of stated above, did you consider a solution where the core
> > > simply disables the SDIO IRQ in case it isn't enabled for system
> > > wakeup? In this way all host drivers would benefit.
> >
> > I can give it a shot if you can give me a bunch of specific advice,
> > but I only have access to a few devices doing anything with SDIO and
> > they are all using Marvell or Broadcom on dw_mmc.
> >
> > In general I have no idea how SDIO wakeup (plumbed through the SD
> > controller) would work.  As per below the only way I've seen it done
> > is totally out-of-band.  ...and actually, I'm not sure I've actually
> > ever seen even the out of band stuff truly work on a system myself.
> > It's always been one of those "we should support wake on WiFi" but
> > never made it all the way to implementation.  In any case, if there
> > are examples of people plumbing wakeup through the SD controller I'd
> > need to figure out how to not break them.  Just doing a solution for
> > dw_mmc means I don't have to worry about this since dw_mmc definitely
> > doesn't support SDIO wakeup.
> >
> > Maybe one way to get a more generic solution is if you had an idea for
> > a patch that would work for many host controllers then you could post
> > it and I could test to confirm that it's happy on dw_mmc?  ...similar
> > to when you switched dw_mmc away from the old kthread-based SDIO
> > stuff?

Let me have a look and see if I can post something for you to test.

>
> Unless you have time to help dig into all the possibilities here to
> help understand how this should behave across all the different host
> controllers / wakeup setups, maybe we could just land ${SUBJECT} patch
> for now and when there is more clarity we can revisit?

That's an option. I only fear that the revisit part never happens
(because of me personally being occupied with other things).

If I not able to come up with something within a week, then I will
queue up this as fix.

Kind regards
Uffe
