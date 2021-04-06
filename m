Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 126F03554CC
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 15:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243606AbhDFNSu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 09:18:50 -0400
Received: from elvis.franken.de ([193.175.24.41]:59087 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242540AbhDFNSr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Apr 2021 09:18:47 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1lTlbK-0006qP-05; Tue, 06 Apr 2021 15:18:38 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 1A269C24D9; Tue,  6 Apr 2021 15:10:43 +0200 (CEST)
Date:   Tue, 6 Apr 2021 15:10:43 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc:     Mike Rapoport <rppt@kernel.org>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Jinyang He <hejinyang@loongson.cn>,
        Youling Tang <tangyouling@loongson.cn>,
        Tobias Wolf <dev-NTEO@vplace.de>,
        Marcin Nowakowski <marcin.nowakowski@mips.com>,
        linux-mips@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] MIPS: fix memory reservation for non-usermem setups
Message-ID: <20210406131043.GG9505@alpha.franken.de>
References: <20210307194030.8007-1-ilya.lipnitskiy@gmail.com>
 <20210312151934.GA4209@alpha.franken.de>
 <CALCv0x1AEZanNsVcNuUrbHuLyWYNegEVuye9Gso-Ou9xX8JEAg@mail.gmail.com>
 <YFGip16ObFp/vOZS@kernel.org>
 <CALCv0x3sGY8t_NCch7qa6KijoxwvFJJYQEZB5kOMuK35C=c3og@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCv0x3sGY8t_NCch7qa6KijoxwvFJJYQEZB5kOMuK35C=c3og@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 03, 2021 at 07:02:13PM -0700, Ilya Lipnitskiy wrote:
> Hi Mike,
> 
> On Tue, Mar 16, 2021 at 11:33 PM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > Hi Ilya,
> >
> > On Tue, Mar 16, 2021 at 10:10:09PM -0700, Ilya Lipnitskiy wrote:
> > > Hi Thomas,
> > >
> > > On Fri, Mar 12, 2021 at 7:19 AM Thomas Bogendoerfer
> > > <tsbogend@alpha.franken.de> wrote:
> > > >
> > > > On Sun, Mar 07, 2021 at 11:40:30AM -0800, Ilya Lipnitskiy wrote:
> > > > > From: Tobias Wolf <dev-NTEO@vplace.de>
> > > > >
> > > > > Commit 67a3ba25aa95 ("MIPS: Fix incorrect mem=X@Y handling") introduced a new
> > > > > issue for rt288x where "PHYS_OFFSET" is 0x0 but the calculated "ramstart" is
> > > > > not. As the prerequisite of custom memory map has been removed, this results
> > > > > in the full memory range of 0x0 - 0x8000000 to be marked as reserved for this
> > > > > platform.
> > > >
> > > > and where is the problem here ?
> > > Turns out this was already attempted to be upstreamed - not clear why
> > > it wasn't merged. Context:
> > > https://lore.kernel.org/linux-mips/6504517.U6H5IhoIOn@loki/
> > >
> > > I hope the thread above helps you understand the problem.
> >
> > The memory initialization was a bit different then. Do you still see the
> > same problem?
> Thanks for asking. I obtained a RT2880 device and gave it a try. It
> hangs at boot without this patch, however selecting

can you provide debug logs with memblock=debug for both good and bad
kernels ? I'm curious what's the reason for failing allocation...

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
