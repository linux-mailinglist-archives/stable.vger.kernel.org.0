Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5000A2A6014
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 10:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbgKDJEo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 04:04:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:54250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727851AbgKDJEn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Nov 2020 04:04:43 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 183D52220B;
        Wed,  4 Nov 2020 09:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604480682;
        bh=fiKr+4M13c3O/9I8tqfhGSntV11bltH8OUZ8CPb8g+A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h14XOFR8+DlEMu/Wr1h6LbSob/cRFLVeP6h0rJYASP+TVNgPKkIgDMKreBSU8nPaU
         s9G0pXru898BZUhzP9bsk9BAV2Egp2aw8jgAZH1D4NBcEjCxNu3R6DD83p3TI4Omhq
         qznu5xHb51B/aP8xQUT4NhnDDTIPIeZ8GMwWEKVQ=
Date:   Wed, 4 Nov 2020 10:05:33 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     stable@vger.kernel.org, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org, npiggin@gmail.com,
        peterz@infradead.org
Subject: Re: [PATCH 4.19] mm: fix exec activate_mm vs TLB shootdown and lazy
 tlb switching race
Message-ID: <20201104090533.GA1588160@kroah.com>
References: <20201104011406.598487-1-mpe@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104011406.598487-1-mpe@ellerman.id.au>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 04, 2020 at 12:14:06PM +1100, Michael Ellerman wrote:
> From: Nicholas Piggin <npiggin@gmail.com>
> 
> commit d53c3dfb23c45f7d4f910c3a3ca84bf0a99c6143 upstream.
> 
> Reading and modifying current->mm and current->active_mm and switching
> mm should be done with irqs off, to prevent races seeing an intermediate
> state.
> 
> This is similar to commit 38cf307c1f20 ("mm: fix kthread_use_mm() vs TLB
> invalidate"). At exec-time when the new mm is activated, the old one
> should usually be single-threaded and no longer used, unless something
> else is holding an mm_users reference (which may be possible).
> 
> Absent other mm_users, there is also a race with preemption and lazy tlb
> switching. Consider the kernel_execve case where the current thread is
> using a lazy tlb active mm:
> 
>   call_usermodehelper()
>     kernel_execve()
>       old_mm = current->mm;
>       active_mm = current->active_mm;
>       *** preempt *** -------------------->  schedule()
>                                                prev->active_mm = NULL;
>                                                mmdrop(prev active_mm);
>                                              ...
>                       <--------------------  schedule()
>       current->mm = mm;
>       current->active_mm = mm;
>       if (!old_mm)
>           mmdrop(active_mm);
> 
> If we switch back to the kernel thread from a different mm, there is a
> double free of the old active_mm, and a missing free of the new one.
> 
> Closing this race only requires interrupts to be disabled while ->mm
> and ->active_mm are being switched, but the TLB problem requires also
> holding interrupts off over activate_mm. Unfortunately not all archs
> can do that yet, e.g., arm defers the switch if irqs are disabled and
> expects finish_arch_post_lock_switch() to be called to complete the
> flush; um takes a blocking lock in activate_mm().
> 
> So as a first step, disable interrupts across the mm/active_mm updates
> to close the lazy tlb preempt race, and provide an arch option to
> extend that to activate_mm which allows architectures doing IPI based
> TLB shootdowns to close the second race.
> 
> This is a bit ugly, but in the interest of fixing the bug and backporting
> before all architectures are converted this is a compromise.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> [mpe: Manual backport to 4.19 due to membarrier_exec_mmap(mm) changes]
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Link: https://lore.kernel.org/r/20200914045219.3736466-2-npiggin@gmail.com
> ---
>  arch/Kconfig |  7 +++++++
>  fs/exec.c    | 15 ++++++++++++++-
>  2 files changed, 21 insertions(+), 1 deletion(-)

Now queued up, thanks!

greg k-h
