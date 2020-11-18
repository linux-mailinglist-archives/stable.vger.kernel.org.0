Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5EA32B838C
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 19:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgKRSC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 13:02:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39430 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbgKRSC3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 13:02:29 -0500
Received: from 3.general.kamal.us.vpn ([10.172.68.53] helo=ascalon)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kamal@canonical.com>)
        id 1kfRmi-0007Yv-6o; Wed, 18 Nov 2020 18:02:24 +0000
Received: from kamal by ascalon with local (Exim 4.90_1)
        (envelope-from <kamal@ascalon>)
        id 1kfRmd-00038H-Er; Wed, 18 Nov 2020 10:02:19 -0800
Date:   Wed, 18 Nov 2020 10:02:17 -0800
From:   Kamal Mostafa <kamal@canonical.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: Re: Same problem for 4.14.y and a concern: Re: [PATCH 4.19 056/191]
 powerpc: select ARCH_WANT_IRQS_OFF_ACTIVATE_MM
Message-ID: <20201118180216.GA31560@ascalon>
References: <20201103203232.656475008@linuxfoundation.org>
 <20201103203239.940977599@linuxfoundation.org>
 <87361qug5a.fsf@mpe.ellerman.id.au>
 <CAEO-eVMZ-qjZfdum=NQCq-hur=KkHvFgJO1maHw7C1S4NFbczw@mail.gmail.com>
 <20201118004528.GA629656@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118004528.GA629656@sasha-vm>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 17, 2020 at 07:45:28PM -0500, Sasha Levin wrote:
> On Tue, Nov 17, 2020 at 10:51:16AM -0800, Kamal Mostafa wrote:
> > On Tue, Nov 3, 2020 at 4:22 PM Michael Ellerman <mpe@ellerman.id.au> wrote:
> > 
> > > Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> > > > From: Nicholas Piggin <npiggin@gmail.com>
> > > >
> > > > [ Upstream commit 66acd46080bd9e5ad2be4b0eb1d498d5145d058e ]
> > > >
> > > > powerpc uses IPIs in some situations to switch a kernel thread away
> > > > from a lazy tlb mm, which is subject to the TLB flushing race
> > > > described in the changelog introducing ARCH_WANT_IRQS_OFF_ACTIVATE_MM.
> > > >
> > > > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > > > Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> > > > Link:
> > > https://lore.kernel.org/r/20200914045219.3736466-3-npiggin@gmail.com
> > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > > ---
> > > >  arch/powerpc/Kconfig                   | 1 +
> > > >  arch/powerpc/include/asm/mmu_context.h | 2 +-
> > > >  2 files changed, 2 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> > > > index f38d153d25861..0bc53f0e37c0f 100644
> > > > --- a/arch/powerpc/Kconfig
> > > > +++ b/arch/powerpc/Kconfig
> > > > @@ -152,6 +152,7 @@ config PPC
> > > >       select ARCH_USE_BUILTIN_BSWAP
> > > >       select ARCH_USE_CMPXCHG_LOCKREF         if PPC64
> > > >       select ARCH_WANT_IPC_PARSE_VERSION
> > > > +     select ARCH_WANT_IRQS_OFF_ACTIVATE_MM
> > > 
> > > This depends on upstream commit:
> > > 
> > >   d53c3dfb23c4 ("mm: fix exec activate_mm vs TLB shootdown and lazy tlb
> > > switching race")
> > > 
> > > 
> > > Which I don't see in 4.19 stable, or in the email thread here.
> > > 
> > > So this shouldn't be backported to 4.19 unless that commit is also
> > > backported.
> > > 
> > > cheers
> > > 
> > 
> > Hi-
> > 
> > This glitch has made its way into 4.14.y ...
> >    [4.14.y] c2bca8712a19 powerpc: select ARCH_WANT_IRQS_OFF_ACTIVATE_MM
> > But 4.14.y does not carry the prereq that introduces that config.
> 
> I'll queue up the 4.19 backport for 4.14 too, thanks!
> 

Thanks Sasha.

And nevermind my other concern ...

> > It would seem that the intent is that it should be *only* enabled
> > (currently at least) for arches that will explicitly select it, but the
> > config advice does not make that very clear.  Could that new config get
> > an explicit "default n" line?

... I see now that a 'default' isn't necessary; the config only appears
for arches which explicitly select it, as intended.

 -Kamal
