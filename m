Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA37D35F560
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 15:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349081AbhDNNrd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 09:47:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:53270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348684AbhDNNrc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Apr 2021 09:47:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B76E9611EE;
        Wed, 14 Apr 2021 13:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618408031;
        bh=mfIzprwlfl8gA6WjqilLB/e5g2WRcCToRYhdfla3psQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gnjzTAVr5QiF6z5cl0OWBs8b1nJGNVh5hQoZyKyniiqXH7CvDMhwEYxVYHZ4XMxvz
         cEVAQiqshzmxWjZOzmTpol8Mw88odn+srobvl4NJEW1+BXmT1+Bs0VQaGVdhO0eSgu
         jzHGTSApWmpe8LNawSCFIT9of9XAuj4vUwe+feN1KeIBc1XwmOsWlY2/fRrjY2tqsC
         gzbCMrdj+F5IwkaLkCHlDH/i3U9eqeyUKGzLDs0UO2eeyEku03W9+HFSt8jSTiDzLM
         f+072gX0geggdNLEjiJJaxkbIZSD9GtyLn7mKhrlLOOd+oVZRkL48T5GVTx0M7viZM
         fm9xjfsBLbA7Q==
Date:   Wed, 14 Apr 2021 16:46:59 +0300
From:   Mike Rapoport <rppt@kernel.org>
To:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Jinyang He <hejinyang@loongson.cn>,
        Youling Tang <tangyouling@loongson.cn>,
        Tobias Wolf <dev-NTEO@vplace.de>,
        Marcin Nowakowski <marcin.nowakowski@mips.com>,
        linux-mips@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] MIPS: fix memory reservation for non-usermem setups
Message-ID: <YHbyU3n+My/0+3g7@kernel.org>
References: <20210307194030.8007-1-ilya.lipnitskiy@gmail.com>
 <20210312151934.GA4209@alpha.franken.de>
 <CALCv0x1AEZanNsVcNuUrbHuLyWYNegEVuye9Gso-Ou9xX8JEAg@mail.gmail.com>
 <YFGip16ObFp/vOZS@kernel.org>
 <CALCv0x3sGY8t_NCch7qa6KijoxwvFJJYQEZB5kOMuK35C=c3og@mail.gmail.com>
 <20210406131043.GG9505@alpha.franken.de>
 <CALCv0x3rZXK2KYM+twkd_3v2bzqrVAXaA2NnaP8AJh76NeME8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCv0x3rZXK2KYM+twkd_3v2bzqrVAXaA2NnaP8AJh76NeME8w@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 12, 2021 at 11:45:45PM -0700, Ilya Lipnitskiy wrote:
> Hi Thomas,
> 
> On Tue, Apr 6, 2021 at 6:18 AM Thomas Bogendoerfer
> <tsbogend@alpha.franken.de> wrote:
> >
> > On Sat, Apr 03, 2021 at 07:02:13PM -0700, Ilya Lipnitskiy wrote:
> > > Hi Mike,
> > >
> > > On Tue, Mar 16, 2021 at 11:33 PM Mike Rapoport <rppt@kernel.org> wrote:
> > > >
> > > > Hi Ilya,
> > > >
> > > > On Tue, Mar 16, 2021 at 10:10:09PM -0700, Ilya Lipnitskiy wrote:
> > > > > Hi Thomas,
> > > > >
> > > > > On Fri, Mar 12, 2021 at 7:19 AM Thomas Bogendoerfer
> > > > > <tsbogend@alpha.franken.de> wrote:
> > > > > >
> > > > > > On Sun, Mar 07, 2021 at 11:40:30AM -0800, Ilya Lipnitskiy wrote:
> > > > > > > From: Tobias Wolf <dev-NTEO@vplace.de>
> > > > > > >
> > > > > > > Commit 67a3ba25aa95 ("MIPS: Fix incorrect mem=X@Y handling") introduced a new
> > > > > > > issue for rt288x where "PHYS_OFFSET" is 0x0 but the calculated "ramstart" is
> > > > > > > not. As the prerequisite of custom memory map has been removed, this results
> > > > > > > in the full memory range of 0x0 - 0x8000000 to be marked as reserved for this
> > > > > > > platform.
> > > > > >
> > > > > > and where is the problem here ?
> > > > > Turns out this was already attempted to be upstreamed - not clear why
> > > > > it wasn't merged. Context:
> > > > > https://lore.kernel.org/linux-mips/6504517.U6H5IhoIOn@loki/
> > > > >
> > > > > I hope the thread above helps you understand the problem.
> > > >
> > > > The memory initialization was a bit different then. Do you still see the
> > > > same problem?
> > > Thanks for asking. I obtained a RT2880 device and gave it a try. It
> > > hangs at boot without this patch, however selecting
> >
> > can you provide debug logs with memblock=debug for both good and bad
> > kernels ? I'm curious what's the reason for failing allocation...
>
> Sorry for taking a while to respond. See attached.
> FWIW, it seems these are the lines that stand out in hang.log:
> [    0.000000] memblock_reserve: [0x00000000-0x07ffffff] setup_arch+0x214/0x5d8
> [    0.000000] Wasting 1048576 bytes for tracking 32768 unused pages
> ...
> [    0.000000]  reserved[0x0]    [0x00000000-0x087137aa], 0x087137ab
> bytes flags: 0x0
> 
> Ilya

> ---------------------------CONTINUTES-BOOTING-NORMALLY-----------------------

> [    0.000000] MEMBLOCK configuration:
> [    0.000000]  memory size = 0x02000000 reserved size = 0x0875a542
> [    0.000000]  memory.cnt  = 0x1
> [    0.000000]  memory[0x0]	[0x08000000-0x09ffffff], 0x02000000 bytes flags: 0x0
> [    0.000000]  reserved.cnt  = 0x5
> [    0.000000]  reserved[0x0]	[0x00000000-0x087137aa], 0x087137ab bytes flags: 0x0
> [    0.000000]  reserved[0x1]	[0x087137b0-0x087137b3], 0x00000004 bytes flags: 0x0
> [    0.000000]  reserved[0x2]	[0x087137c0-0x08715276], 0x00001ab7 bytes flags: 0x0
> [    0.000000]  reserved[0x3]	[0x08715278-0x0871a533], 0x000052bc bytes flags: 0x0
> [    0.000000]  reserved[0x4]	[0x0871a540-0x0875a55f], 0x00040020 bytes flags: 0x0

...

> [    0.000000] Memory: 25168K/32768K available (4299K kernel code, 575K rwdata, 952K rodata, 1204K init, 205K bss, 7600K reserved, 0K cma-reserved)
> ----------------------------------------HANGS-FOREVER-HERE---------------------------------

I'd say that with ARCH_PFN_OFFSET set to 0 and actual memory start address
at 0x08000000 any attempt to do pfn_to_page()/page_to_pfn()/page_address()
will give an incorrect result and will crash the system.

No idea why the crash is silent, though :)

-- 
Sincerely yours,
Mike.
