Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB28D2A6016
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 10:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbgKDJE7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 04:04:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:54510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbgKDJE6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Nov 2020 04:04:58 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E2DD2220B;
        Wed,  4 Nov 2020 09:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604480698;
        bh=RrG7UZ6WXi39gsCIBfUePqokH5ljjR4rAlO1FEu4eP4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lgKqgbnMumChVGaGLx9OqXvrCL2umG5saMgHEwPOhTdPaaamkCnlRr3HiWvvkH0rP
         zAYPYAIP1yF0qcCcUlWinAdjXiZYhGHMTqcgujK8+jiJx31xKK78A57OeDfC/720ET
         NzUJR0KyrB+dp27OaaJ45prWzB8qFzXIxPERXvtM=
Date:   Wed, 4 Nov 2020 10:05:49 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 056/191] powerpc: select
 ARCH_WANT_IRQS_OFF_ACTIVATE_MM
Message-ID: <20201104090549.GB1588160@kroah.com>
References: <20201103203232.656475008@linuxfoundation.org>
 <20201103203239.940977599@linuxfoundation.org>
 <87361qug5a.fsf@mpe.ellerman.id.au>
 <87zh3xude6.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zh3xude6.fsf@mpe.ellerman.id.au>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 04, 2020 at 12:19:45PM +1100, Michael Ellerman wrote:
> Michael Ellerman <mpe@ellerman.id.au> writes:
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> >> From: Nicholas Piggin <npiggin@gmail.com>
> >>
> >> [ Upstream commit 66acd46080bd9e5ad2be4b0eb1d498d5145d058e ]
> >>
> >> powerpc uses IPIs in some situations to switch a kernel thread away
> >> from a lazy tlb mm, which is subject to the TLB flushing race
> >> described in the changelog introducing ARCH_WANT_IRQS_OFF_ACTIVATE_MM.
> >>
> >> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> >> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> >> Link: https://lore.kernel.org/r/20200914045219.3736466-3-npiggin@gmail.com
> >> Signed-off-by: Sasha Levin <sashal@kernel.org>
> >> ---
> >>  arch/powerpc/Kconfig                   | 1 +
> >>  arch/powerpc/include/asm/mmu_context.h | 2 +-
> >>  2 files changed, 2 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> >> index f38d153d25861..0bc53f0e37c0f 100644
> >> --- a/arch/powerpc/Kconfig
> >> +++ b/arch/powerpc/Kconfig
> >> @@ -152,6 +152,7 @@ config PPC
> >>  	select ARCH_USE_BUILTIN_BSWAP
> >>  	select ARCH_USE_CMPXCHG_LOCKREF		if PPC64
> >>  	select ARCH_WANT_IPC_PARSE_VERSION
> >> +	select ARCH_WANT_IRQS_OFF_ACTIVATE_MM
> >
> > This depends on upstream commit:
> >
> >   d53c3dfb23c4 ("mm: fix exec activate_mm vs TLB shootdown and lazy tlb switching race")
> >
> >
> > Which I don't see in 4.19 stable, or in the email thread here.
> >
> > So this shouldn't be backported to 4.19 unless that commit is also
> > backported.
> 
> I just sent you a backport of d53c3dfb23c4 for 4.19.

I've taken that at the proper part of this series now, thanks!

greg k-h
