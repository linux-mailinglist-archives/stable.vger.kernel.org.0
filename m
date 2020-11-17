Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55BF42B6E52
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 20:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgKQTSQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 14:18:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60581 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbgKQTSQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Nov 2020 14:18:16 -0500
Received: from 3.general.kamal.us.vpn ([10.172.68.53] helo=ascalon)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kamal@canonical.com>)
        id 1kf6UY-0001EN-CX
        for stable@vger.kernel.org; Tue, 17 Nov 2020 19:18:14 +0000
Received: from kamal by ascalon with local (Exim 4.90_1)
        (envelope-from <kamal@ascalon>)
        id 1kf6UV-00009Z-9l
        for stable@vger.kernel.org; Tue, 17 Nov 2020 11:18:11 -0800
MIME-Version: 1.0
Date:   Tue, 17 Nov 2020 10:51:16 -0800
References: <20201103203232.656475008@linuxfoundation.org>
        <20201103203239.940977599@linuxfoundation.org>
        <87361qug5a.fsf@mpe.ellerman.id.au>
In-Reply-To: <87361qug5a.fsf@mpe.ellerman.id.au>
Message-ID: <CAEO-eVMZ-qjZfdum=NQCq-hur=KkHvFgJO1maHw7C1S4NFbczw@mail.gmail.com>
Subject: Same problem for 4.14.y and a concern: Re: [PATCH 4.19 056/191]
 powerpc: select ARCH_WANT_IRQS_OFF_ACTIVATE_MM
From:   Kamal Mostafa <kamal@canonical.com>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Content-Type: multipart/alternative; boundary="000000000000ccf01a05b451fae9"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--000000000000ccf01a05b451fae9
Content-Type: text/plain; charset="UTF-8"

On Tue, Nov 3, 2020 at 4:22 PM Michael Ellerman <mpe@ellerman.id.au> wrote:

> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> > From: Nicholas Piggin <npiggin@gmail.com>
> >
> > [ Upstream commit 66acd46080bd9e5ad2be4b0eb1d498d5145d058e ]
> >
> > powerpc uses IPIs in some situations to switch a kernel thread away
> > from a lazy tlb mm, which is subject to the TLB flushing race
> > described in the changelog introducing ARCH_WANT_IRQS_OFF_ACTIVATE_MM.
> >
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> > Link:
> https://lore.kernel.org/r/20200914045219.3736466-3-npiggin@gmail.com
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  arch/powerpc/Kconfig                   | 1 +
> >  arch/powerpc/include/asm/mmu_context.h | 2 +-
> >  2 files changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> > index f38d153d25861..0bc53f0e37c0f 100644
> > --- a/arch/powerpc/Kconfig
> > +++ b/arch/powerpc/Kconfig
> > @@ -152,6 +152,7 @@ config PPC
> >       select ARCH_USE_BUILTIN_BSWAP
> >       select ARCH_USE_CMPXCHG_LOCKREF         if PPC64
> >       select ARCH_WANT_IPC_PARSE_VERSION
> > +     select ARCH_WANT_IRQS_OFF_ACTIVATE_MM
>
> This depends on upstream commit:
>
>   d53c3dfb23c4 ("mm: fix exec activate_mm vs TLB shootdown and lazy tlb
> switching race")
>
>
> Which I don't see in 4.19 stable, or in the email thread here.
>
> So this shouldn't be backported to 4.19 unless that commit is also
> backported.
>
> cheers
>

Hi-

This glitch has made its way into 4.14.y ...
    [4.14.y] c2bca8712a19 powerpc: select ARCH_WANT_IRQS_OFF_ACTIVATE_MM
But 4.14.y does not carry the prereq that introduces that config.

That said, I have a more general concern about the new config (in mainline
and the stable backports):
    [mainline] d53c3dfb23c4 mm: fix exec activate_mm vs TLB shootdown and
lazy tlb switching race
It would seem that the intent is that it should be *only* enabled
(currently at least) for arches that will explicitly select it, but the
config advice does not make that very clear.  Could that new config get an
explicit "default n" line?

 -Kamal

--000000000000ccf01a05b451fae9
Content-Type: message/external-body; access-type=x-mutt-deleted;
	expiration="Tue, 17 Nov 2020 11:03:37 -0800"; length=86

Content-Type: message/external-body; access-type=x-mutt-deleted;
	expiration="Tue, 17 Nov 2020 11:03:06 -0800"; length=3672


--000000000000ccf01a05b451fae9--
