Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 987F549CC0C
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 15:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241995AbiAZOPm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 09:15:42 -0500
Received: from mout.kundenserver.de ([212.227.126.135]:57449 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235463AbiAZOPm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 09:15:42 -0500
Received: from mail-wr1-f50.google.com ([209.85.221.50]) by
 mrelayeu.kundenserver.de (mreue012 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1N7QM9-1mBqPB1rTh-017iJ2; Wed, 26 Jan 2022 15:15:40 +0100
Received: by mail-wr1-f50.google.com with SMTP id k18so26034955wrg.11;
        Wed, 26 Jan 2022 06:15:40 -0800 (PST)
X-Gm-Message-State: AOAM530ugkm/qztGhthuiFIYMdJ5k0aoJjFJMqC0f5rUWoWOdYRS68Fs
        VonoMytk6WeSBrVTTljHGHDOkuVNkJydbdGWJBA=
X-Google-Smtp-Source: ABdhPJypUHBTeRx/2wQs8W86Fm5/h6oi7YvMer36TrIuhT81FZ7IHgq/MbBkCknxuUWDS+dxyf0rqtN/tkqX9OjSS6E=
X-Received: by 2002:adf:fd05:: with SMTP id e5mr22581036wrr.192.1643206539963;
 Wed, 26 Jan 2022 06:15:39 -0800 (PST)
MIME-Version: 1.0
References: <20220121200738.2577697-1-laurent@vivier.eu> <20220121200738.2577697-3-laurent@vivier.eu>
 <YfFPjOEELiTWr2uj@kroah.com>
In-Reply-To: <YfFPjOEELiTWr2uj@kroah.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 26 Jan 2022 15:15:23 +0100
X-Gmail-Original-Message-ID: <CAK8P3a32PRo4OJmUPmgnhp_14biz4bfs5BnDXej1itwOfkuvKA@mail.gmail.com>
Message-ID: <CAK8P3a32PRo4OJmUPmgnhp_14biz4bfs5BnDXej1itwOfkuvKA@mail.gmail.com>
Subject: Re: [PATCH v12 2/5] tty: goldfish: introduce gf_ioread32()/gf_iowrite32()
To:     Greg KH <greg@kroah.com>
Cc:     Laurent Vivier <laurent@vivier.eu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-rtc@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        John Stultz <john.stultz@linaro.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:da1ACItRTuMgThyod6/gjWphq5DEo5CVHj91Vz8Mu4gVnexpOYC
 9jPy7BRL5eW693zWdS3/cQpiWH6Y2LxQbAya4pDiXuRzaTfvSMcBdQUlfHHYniDAsl3/fcX
 7si/NQ5h4+HsxgOzTtOi0QyQIS3CeOiJ8jBe6Sgr8mJ+luyryqzKP6Vi/0nOtabjsXNdtkU
 yqYXzj3INOU80whTAhLlg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:j53BWYrUBMw=:V3FZdYwU2HxGDp1mqEuK7y
 Y2yl4RsgnYFjwB61vcDcOo6syxQLoaFWtDMFQl237mLWFdJApnXjpbIxiallMyUX1IP7QyV6z
 xAz2X9ymX1VB11hFkxv2LQBCirfWpbJ1tzoNF/AfF1z6N7JE75xiEiBio5Pl0oCs4xdyWuM5p
 aWN5iysDeZ16hOU+kkH4SP/g2YsQYPs8CqlIuYq/kodLg88q8Tj8gPoW7Nz54sXh6m7NdSFk0
 d9WRgFaqG4Bs3yIEGV+mJxy56oPvC3hcTyHprR3FFUZBTW0aE6C+buQJNxH3xR4ek9m5r5kIi
 7g7CDF6VpwOxLwGUKR4KGv5XPF+5k0vp1nLDwi3opOdrQxWDtxUSHU6OUGCSu6uxefJSzeElq
 OnUJOTp8IfVs0iHsctd9w01xYewnQyCgIHTbebfqhUXGW2GBnOS3Hxj6dhKz0qfyZpg+DWboG
 dhSBTP+CvjP8jYE26/grpEq3KeAUTmzXhOfeE6PVBqIlF3V4RVHrOE9FGBCTlntXBhnBDD4q/
 y8riMIS3v2WKcagxutj7rjKPQIVm/ffbgVT+hREnEju3c981Baq/3l/QrttnmKTd2YBmv2Aj/
 N5u7v2+x3pqwxtfGgPm2hZ3+aY4Lku0dmeHHgi8TeFwEbRkU9DvCed+sB3TZoYZN4o9qYA6Pv
 m1c95w1F2tKjOVrlqG9eJOsWVtJH9fnNpC0umOx1niwUtgZgojfpT+UUF/V1SdOx3R5iRqntR
 ALcBk608MAQC4/Pjcs2p6aMIfiDUyMGY7krtE3/VEdrVIeCRyqQ0Xu589EqFIBs1Rw27bkK7P
 dCndg3BnQcPRBPsfJPGU5b2L++bmJCdJvXzSTSB8SbStDIXka4=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 26, 2022 at 2:41 PM Greg KH <greg@kroah.com> wrote:
>
> On Fri, Jan 21, 2022 at 09:07:35PM +0100, Laurent Vivier wrote:
> > Revert
> > commit da31de35cd2f ("tty: goldfish: use __raw_writel()/__raw_readl()")
>
> Why?
>
> > and define gf_ioread32()/gf_iowrite32() to be able to use accessors
> > defined by the architecture.
>
> What does this do?

The reverted commit was an incorrect workaround for an old qemu bug:

The goldfish devices are apparently defined as "native" endianness,
which in qemu is whatever the architecture maintainers thought it should
be at the time (little-endian on arm, big-endian on powerpc, board
specific on mips, etc.) but independent of what kernel is actually running
on the machine if the CPU supports both.

m68k in qemu picked big-endian here, which is the opposite of what
the kernel driver does, presumably because that is the endianness of
the CPU itself.

Since we can't fix qemu any more, and runtime detection doesn't work
on machines without devicetree, having a sane default (whatever the
driver used to do) and an architecture specific override for those that
got it wrong is probably our best option.

       Arnd
