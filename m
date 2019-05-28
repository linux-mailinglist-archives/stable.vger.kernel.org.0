Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB752C8ED
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 16:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbfE1Oid (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 10:38:33 -0400
Received: from mail-ua1-f66.google.com ([209.85.222.66]:43330 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbfE1Oic (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 May 2019 10:38:32 -0400
Received: by mail-ua1-f66.google.com with SMTP id u4so1698630uau.10
        for <stable@vger.kernel.org>; Tue, 28 May 2019 07:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xoaLrOaVKIM8ESM/O0FPRf0nY0zEO7GufQin910pcKk=;
        b=irftUQkii/33TKs92nEGhu6oEm/EW/DyqkbJsM8saeMvXwkfZS4WGQ/dEu6pFb6gGg
         0d1zWvIPJGBgIBmCeReqSQgMzYAPsgVxJF2pBEkSYRpOkTQBLERmkeYhgvUWbzeITOcZ
         DQFrs7MUbN0sMHD30cVrw4wDXvPXgNm24GlwI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xoaLrOaVKIM8ESM/O0FPRf0nY0zEO7GufQin910pcKk=;
        b=aRD+KGhEXmugCnCg97ByaXBNtW4TrnUBjSA69PZPai5p8qiTeb0invA757EIz2pJvD
         d6dLZPK/DNhjBUjQk7tSJXyhQw213JKmtHxptNAvMjbhfXI2Pmrx24mFwhnd8t451Wmp
         mY7yWcQoNLtsr64FJoxUtR3VZsWz4Bx+o6uHgW2ONLsCRgn9fU3NruhGie3ZITAe7nRB
         YYY19eJifJ1foz/I6CaTS9lt6Hhrfztm9HJNxALigehELzmD5bp5M01fBILRHRpXtFP4
         LT07K3Gh9DrEA6XXRgVLJyTR6h4P45jUGjhWO4y8ZLpIkBWMgxMSJBachW72sGtodW3M
         QDGA==
X-Gm-Message-State: APjAAAWDsBttPUgf7mPWUdoxzs8zCc6007/wjVbvWz79Mmf9CDpzP6hV
        BHueWC0Q13l4LiiGJnvsiCVN5XvmLms=
X-Google-Smtp-Source: APXvYqw17Zfu6Ro4Vo54nIp5ZQlCTLpa63zYdNQpDHMwilqbUVabAk8+QHTzw/N8V4few2as0dzLpw==
X-Received: by 2002:ab0:234d:: with SMTP id h13mr17215318uao.95.1559054310846;
        Tue, 28 May 2019 07:38:30 -0700 (PDT)
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com. [209.85.222.43])
        by smtp.gmail.com with ESMTPSA id d79sm10174620vkd.23.2019.05.28.07.38.26
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 07:38:29 -0700 (PDT)
Received: by mail-ua1-f43.google.com with SMTP id a95so7957293uaa.13
        for <stable@vger.kernel.org>; Tue, 28 May 2019 07:38:26 -0700 (PDT)
X-Received: by 2002:ab0:4a97:: with SMTP id s23mr27884679uae.19.1559054305839;
 Tue, 28 May 2019 07:38:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190429204040.18725-1-dianders@chromium.org> <CAD=FV=WEDkufoEUYv9U+c+Y_bm8MYEWS25n63vUeNG0LLCFnuw@mail.gmail.com>
 <CAPDyKFoKN2zUNvDkgciO6r_ohdh2Vaj5qQaAPwMq21y02XAK8A@mail.gmail.com>
In-Reply-To: <CAPDyKFoKN2zUNvDkgciO6r_ohdh2Vaj5qQaAPwMq21y02XAK8A@mail.gmail.com>
From:   Doug Anderson <dianders@chromium.org>
Date:   Tue, 28 May 2019 07:38:14 -0700
X-Gmail-Original-Message-ID: <CAD=FV=VqqDK6SLC_1_cFUjjEdTNUU09GJi4ZEMNwt_mgjnVRdg@mail.gmail.com>
Message-ID: <CAD=FV=VqqDK6SLC_1_cFUjjEdTNUU09GJi4ZEMNwt_mgjnVRdg@mail.gmail.com>
Subject: Re: [PATCH v2] mmc: dw_mmc: Disable SDIO interrupts while suspended
 to fix suspend/resume
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Guenter Roeck <groeck@chromium.org>,
        Brian Norris <briannorris@chromium.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Sonny Rao <sonnyrao@chromium.org>,
        Emil Renner Berthing <emil.renner.berthing@gmail.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Ryan Case <ryandcase@chromium.org>,
        "# 4.0+" <stable@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Shawn Lin <shawn.lin@rock-chips.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Tue, May 28, 2019 at 6:12 AM Ulf Hansson <ulf.hansson@linaro.org> wrote:
>
> On Mon, 20 May 2019 at 20:41, Doug Anderson <dianders@chromium.org> wrote:
> >
> > Hi,
> >
> > On Mon, Apr 29, 2019 at 1:41 PM Douglas Anderson <dianders@chromium.org> wrote:
> > >
> > > Processing SDIO interrupts while dw_mmc is suspended (or partly
> > > suspended) seems like a bad idea.  We really don't want to be
> > > processing them until we've gotten ourselves fully powered up.
> > >
> > > You might be wondering how it's even possible to become suspended when
> > > an SDIO interrupt is active.  As can be seen in
> > > dw_mci_enable_sdio_irq(), we explicitly keep dw_mmc out of runtime
> > > suspend when the SDIO interrupt is enabled.  ...but even though we
> > > stop normal runtime suspend transitions when SDIO interrupts are
> > > enabled, the dw_mci_runtime_suspend() can still get called for a full
> > > system suspend.
> > >
> > > Let's handle all this by explicitly masking SDIO interrupts in the
> > > suspend call and unmasking them later in the resume call.  To do this
> > > cleanly I'll keep track of whether the client requested that SDIO
> > > interrupts be enabled so that we can reliably restore them regardless
> > > of whether we're masking them for one reason or another.
> > >
> > > It should be noted that if dw_mci_enable_sdio_irq() is never called
> > > (for instance, if we don't have an SDIO card plugged in) that
> > > "client_sdio_enb" will always be false.  In those cases this patch
> > > adds a tiny bit of overhead to suspend/resume (a spinlock and a
> > > read/write of INTMASK) but other than that is a no-op.  The
> > > SDMMC_INT_SDIO bit should always be clear and clearing it again won't
> > > hurt.
> > >
> > > Without this fix it can be seen that rk3288-veyron Chromebooks with
> > > Marvell WiFi would sometimes fail to resume WiFi even after picking my
> > > recent mwifiex patch [1].  Specifically you'd see messages like this:
> > >   mwifiex_sdio mmc1:0001:1: Firmware wakeup failed
> > >   mwifiex_sdio mmc1:0001:1: PREP_CMD: FW in reset state
> > >
> > > ...and tracing through the resume code in the failing cases showed
> > > that we were processing a SDIO interrupt really early in the resume
> > > call.
> > >
> > > NOTE: downstream in Chrome OS 3.14 and 3.18 kernels (both of which
> > > support the Marvell SDIO WiFi card) we had a patch ("CHROMIUM: sdio:
> > > Defer SDIO interrupt handling until after resume") [2].  Presumably
> > > this is the same problem that was solved by that patch.
> > >
> > > [1] https://lkml.kernel.org/r/20190404040106.40519-1-dianders@chromium.org
> > > [2] https://crrev.com/c/230765
> > >
> > > Cc: <stable@vger.kernel.org> # 4.14.x
> > > Signed-off-by: Douglas Anderson <dianders@chromium.org>
> > > ---
> > > I didn't put any "Fixes" tag here, but presumably this could be
> > > backported to whichever kernels folks found it useful for.  I have at
> > > least confirmed that kernels v4.14 and v4.19 (as well as v5.1-rc2)
> > > show the problem.  It is very easy to pick this to v4.19 and it
> > > definitely fixes the problem there.
> > >
> > > I haven't spent the time to pick this to 4.14 myself, but presumably
> > > it wouldn't be too hard to backport this as far as v4.13 since that
> > > contains commit 32dba73772f8 ("mmc: dw_mmc: Convert to use
> > > MMC_CAP2_SDIO_IRQ_NOTHREAD for SDIO IRQs").  Prior to that it might
> > > make sense for anyone experiencing this problem to just pick the old
> > > CHROMIUM patch to fix them.
> > >
> > > Changes in v2:
> > > - Suggested 4.14+ in the stable tag (Sasha-bot)
> > > - Extra note that this is a noop on non-SDIO (Shawn / Emil)
> > > - Make boolean logic cleaner as per https://crrev.com/c/1586207/1
> > > - Hopefully clear comments as per https://crrev.com/c/1586207/1
> > >
> > >  drivers/mmc/host/dw_mmc.c | 27 +++++++++++++++++++++++----
> > >  drivers/mmc/host/dw_mmc.h |  3 +++
> > >  2 files changed, 26 insertions(+), 4 deletions(-)
> >
> > Ulf: are you the right person to land this?  With 5.2-rc1 out it might
> > be a good time for it?  To refresh your memory about this patch:
> >
> > * Patch v1 was posted back on April 10th [1] so we're at about 1.5
> > months of time for people to comment about it now.  Should be more
> > than enough.
>
> Apologize for the delay, not sure why this has slipped through my
> filters. Anyway, let me have a look at it now.

No worries.  If there's something better I can do in the future to
avoid problems, please let me know.


> > * Shawn Lin saw it and didn't hate it.  He had some confusion about
> > how it worked and I've hopefully alleviated via extra comments / text.
> >
> > * Emil Renner Berthing thought it caused a regression for him but then
> > tested further and was convinced that it didn't.  This is extra
> > confirmation that someone other than me did try the patch and found it
> > to not break things.  ;-)
> >
> > * It has been reviewed by Guenter Roeck (in v2)
>
> One question, I am guessing you are considering
> https://lkml.org/lkml/2019/5/17/761 as the long term solution, and
> thus $subject patch should go as fix+stable? No?

No, the two problems are completely separate.  ${SUBJECT} patch deals
with full system suspend/resume.  I originally reproduced the problems
on a device with Marvell WiFi, though it could possibly affect
Broadcom parts on dw_mmc too.  ${SUBJECT} patch is ready to land on
mainline Linux at your leisure.  Also: in case you didn't notice
(since it didn't thread properly for me), Shawn Lin gave it a reviewed
by [1].

The patch you refer to [2] is related to something akin to an idle
state (more like Runtime PM) and only affects Broadcom parts.  Also
the Broadcom issue ought to happen across all host controllers (AKA
not just dw_mmc).

[1] https://lkml.kernel.org/r/982ffba1-c599-e73d-e5e0-b1be5668851c@rock-chips.com
[2] https://lkml.org/lkml/2019/5/17/761

-Doug
