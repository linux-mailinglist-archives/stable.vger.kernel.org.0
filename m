Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 789A13A971B
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 12:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbhFPKWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 06:22:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:45144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231769AbhFPKWi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 06:22:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF0D261153;
        Wed, 16 Jun 2021 10:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623838832;
        bh=Ym1vZEQrl4FAJY3nRQwAl9nRr777Xn5/+ZCgT0X7n8o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZjywvkZIEHr7cruyFpHj70eyFM9ijUIhaAuvYmmopSWlueo/fLaio4NubUX6xnoJx
         o8ztFiM/vr9zlSHMPNnyHqtWCPfhn0EplH/dMsOk/CkDCXq7XNu4yZkca+ExvW6M/z
         svHRm9f0cpkHkcRVAwmM74jbiLrhjJhVazJu9F4VL3whpPGTzOHLLKq25Bvd9DEBZC
         XLQ32bZXu2kgxxjZ3MrcwNC6Ii7Dauc9QMdPRD2f/I9PXJHcznekU243PsMIKz5Skc
         2zCtOJD456kw7DB2FcF2DTd9smFB25yvi/SNPP0yujLgqjmIYSfNEADIOjLqNxXptc
         FEnFGcxf5eI8w==
Date:   Wed, 16 Jun 2021 11:20:26 +0100
From:   Will Deacon <will@kernel.org>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     x86@kernel.org, Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, Nicholas Piggin <npiggin@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org
Subject: Re: [PATCH 8/8] membarrier: Rewrite sync_core_before_usermode() and
 improve documentation
Message-ID: <20210616102026.GB22350@willie-the-truck>
References: <cover.1623813516.git.luto@kernel.org>
 <07a8b963002cb955b7516e61bad19514a3acaa82.1623813516.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07a8b963002cb955b7516e61bad19514a3acaa82.1623813516.git.luto@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 15, 2021 at 08:21:13PM -0700, Andy Lutomirski wrote:
> The old sync_core_before_usermode() comments suggested that a non-icache-syncing
> return-to-usermode instruction is x86-specific and that all other
> architectures automatically notice cross-modified code on return to
> userspace.
> 
> This is misleading.  The incantation needed to modify code from one
> CPU and execute it on another CPU is highly architecture dependent.
> On x86, according to the SDM, one must modify the code, issue SFENCE
> if the modification was WC or nontemporal, and then issue a "serializing
> instruction" on the CPU that will execute the code.  membarrier() can do
> the latter.
> 
> On arm64 and powerpc, one must flush the icache and then flush the pipeline
> on the target CPU, although the CPU manuals don't necessarily use this
> language.
> 
> So let's drop any pretense that we can have a generic way to define or
> implement membarrier's SYNC_CORE operation and instead require all
> architectures to define the helper and supply their own documentation as to
> how to use it.  This means x86, arm64, and powerpc for now.  Let's also
> rename the function from sync_core_before_usermode() to
> membarrier_sync_core_before_usermode() because the precise flushing details
> may very well be specific to membarrier, and even the concept of
> "sync_core" in the kernel is mostly an x86-ism.
> 
> (It may well be the case that, on real x86 processors, synchronizing the
>  icache (which requires no action at all) and "flushing the pipeline" is
>  sufficient, but trying to use this language would be confusing at best.
>  LFENCE does something awfully like "flushing the pipeline", but the SDM
>  does not permit LFENCE as an alternative to a "serializing instruction"
>  for this purpose.)
> 
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: x86@kernel.org
> Cc: stable@vger.kernel.org
> Fixes: 70216e18e519 ("membarrier: Provide core serializing command, *_SYNC_CORE")
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> ---
>  .../membarrier-sync-core/arch-support.txt     | 68 ++++++-------------
>  arch/arm64/include/asm/sync_core.h            | 19 ++++++
>  arch/powerpc/include/asm/sync_core.h          | 14 ++++
>  arch/x86/Kconfig                              |  1 -
>  arch/x86/include/asm/sync_core.h              |  7 +-
>  arch/x86/kernel/alternative.c                 |  2 +-
>  arch/x86/kernel/cpu/mce/core.c                |  2 +-
>  arch/x86/mm/tlb.c                             |  3 +-
>  drivers/misc/sgi-gru/grufault.c               |  2 +-
>  drivers/misc/sgi-gru/gruhandles.c             |  2 +-
>  drivers/misc/sgi-gru/grukservices.c           |  2 +-
>  include/linux/sched/mm.h                      |  1 -
>  include/linux/sync_core.h                     | 21 ------
>  init/Kconfig                                  |  3 -
>  kernel/sched/membarrier.c                     | 15 ++--
>  15 files changed, 75 insertions(+), 87 deletions(-)
>  create mode 100644 arch/arm64/include/asm/sync_core.h
>  create mode 100644 arch/powerpc/include/asm/sync_core.h
>  delete mode 100644 include/linux/sync_core.h

For the arm64 bits (docs and asm/sync_core.h):

Acked-by: Will Deacon <will@kernel.org>

Will
