Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B405635361F
	for <lists+stable@lfdr.de>; Sun,  4 Apr 2021 04:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236800AbhDDCC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Apr 2021 22:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236782AbhDDCC2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Apr 2021 22:02:28 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA60C061756;
        Sat,  3 Apr 2021 19:02:25 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id w2so4662376ilj.12;
        Sat, 03 Apr 2021 19:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iWLiBziOmLtAKhsDpcO5ROb0xigYNGMx9gk4xpg0odo=;
        b=egq0YPZFUPGytJk1ifWWiUjO8gxu6UsIOev3UzoBCn2BF+xGvioCFNrnOpqVThKKE4
         Dn/QpvdHNyWYnKoWisAUnwag5JUnjSqJOFC64tDby9dmtZrdfr9JHOLO5lDkgCXc/wt7
         REPUlKbGTbo7MH2FWaEPc3TrGXEiPrc29/2SVfKSoAYeUeRLruhhywkgGS6jWcWUS99o
         JRBm8dgsujfwVVwlS1y84q4+Mr0A2WeZMWcGk2KzTuwETHnfq1c6cmIpfwJ7oUI6HdfZ
         r7St3TL5x5eQbsDLF/o/n0hykbJ2By+hsq2BRwoyg+Xm0RayNXECUBRZMlVUv9nOWJd0
         /peA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iWLiBziOmLtAKhsDpcO5ROb0xigYNGMx9gk4xpg0odo=;
        b=FyYem2mz2j12+/q77UmZ7/tAdByWyheQNeAouMyIkFPzYyf42u7yg/cffPFq0tUArJ
         ApgDshJGkrqQ/6K/zEHMbo2YXYLaGzCmbs5dz0ZYKspXQThLrILFxbOrPFdJraB88WIr
         S0Uz04EiHg4k7fBtAt7AB4y/WbM8hE1lDWOLek0BszF8xW+xi21P0XfJJ8f7u/B0hi6S
         DGBtappe3J8GztMTtzVrbdv8RFcHg3X5a2on6W82uIoAJQt2mAAN8G5Jz3mVs/ou+/4N
         J2/b9cVpkLOPZmF5eaZiRPFr5mm1S1Ailc00QetacU96hZ61FAets4/qj2njOkrDVVkm
         XtzA==
X-Gm-Message-State: AOAM5328uj7me0BLsxiN4SJyArI91V06Pj1eYvFIsiNaTkhnv+Bi/P5L
        gfP9QxUubL/SAnjGfhDIJfoZTUkUmJ/qX1VCbaJB/HM7nxthKw==
X-Google-Smtp-Source: ABdhPJwAXmgF8c+oSLDEVmkpuPaNbxWygg+DNup0sWmd1TWubsJhs2gR8civ0rBtp5KOcYwjsPnXYehorjbnaU0tDRA=
X-Received: by 2002:a05:6e02:c4:: with SMTP id r4mr2033287ilq.179.1617501744596;
 Sat, 03 Apr 2021 19:02:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210307194030.8007-1-ilya.lipnitskiy@gmail.com>
 <20210312151934.GA4209@alpha.franken.de> <CALCv0x1AEZanNsVcNuUrbHuLyWYNegEVuye9Gso-Ou9xX8JEAg@mail.gmail.com>
 <YFGip16ObFp/vOZS@kernel.org>
In-Reply-To: <YFGip16ObFp/vOZS@kernel.org>
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Date:   Sat, 3 Apr 2021 19:02:13 -0700
Message-ID: <CALCv0x3sGY8t_NCch7qa6KijoxwvFJJYQEZB5kOMuK35C=c3og@mail.gmail.com>
Subject: Re: [PATCH] MIPS: fix memory reservation for non-usermem setups
To:     Mike Rapoport <rppt@kernel.org>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Jinyang He <hejinyang@loongson.cn>,
        Youling Tang <tangyouling@loongson.cn>,
        Tobias Wolf <dev-NTEO@vplace.de>,
        Marcin Nowakowski <marcin.nowakowski@mips.com>,
        linux-mips@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Mike,

On Tue, Mar 16, 2021 at 11:33 PM Mike Rapoport <rppt@kernel.org> wrote:
>
> Hi Ilya,
>
> On Tue, Mar 16, 2021 at 10:10:09PM -0700, Ilya Lipnitskiy wrote:
> > Hi Thomas,
> >
> > On Fri, Mar 12, 2021 at 7:19 AM Thomas Bogendoerfer
> > <tsbogend@alpha.franken.de> wrote:
> > >
> > > On Sun, Mar 07, 2021 at 11:40:30AM -0800, Ilya Lipnitskiy wrote:
> > > > From: Tobias Wolf <dev-NTEO@vplace.de>
> > > >
> > > > Commit 67a3ba25aa95 ("MIPS: Fix incorrect mem=X@Y handling") introduced a new
> > > > issue for rt288x where "PHYS_OFFSET" is 0x0 but the calculated "ramstart" is
> > > > not. As the prerequisite of custom memory map has been removed, this results
> > > > in the full memory range of 0x0 - 0x8000000 to be marked as reserved for this
> > > > platform.
> > >
> > > and where is the problem here ?
> > Turns out this was already attempted to be upstreamed - not clear why
> > it wasn't merged. Context:
> > https://lore.kernel.org/linux-mips/6504517.U6H5IhoIOn@loki/
> >
> > I hope the thread above helps you understand the problem.
>
> The memory initialization was a bit different then. Do you still see the
> same problem?
Thanks for asking. I obtained a RT2880 device and gave it a try. It
hangs at boot without this patch, however selecting
MIPS_AUTO_PFN_OFFSET fixes it. Also, no more messages like "Wasting
1048576 bytes for tracking 32768 unused pages". MIPS_AUTO_PFN_OFFSET
was suggested by Paul Burton here:
https://lore.kernel.org/linux-mips/20180820233111.xww5232dxbuouf4n@pburton-laptop/

I will supersede this patch with one that simply selects
MIPS_AUTO_PFN_OFFSET for this SOC.

Ilya
