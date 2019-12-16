Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22C52120164
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 10:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbfLPJpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 04:45:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:49274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726937AbfLPJpa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 04:45:30 -0500
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D319320665;
        Mon, 16 Dec 2019 09:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576489529;
        bh=ID6AxVJaN/XZPaFJDNB6plYUfGK4flJOFGIZw/PCpfI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=usiK59CUF4wvbn/67RYEOn0Dl40MAPAvz11JWIwlYU8+v1B/eA6RgcQdph0DQoTse
         Uj9p2alU1Ex+bT22CAN1SPQ55yltS4CATkUF8CVhrxuLPw1v+4YAB2nPL5OmW/dDkm
         qn0CPviLJpyHQ7NqWfK4Ff2LapqUV9TjUR1xFzkk=
Date:   Mon, 16 Dec 2019 09:45:24 +0000
From:   Will Deacon <will@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "kernelci.org bot" <bot@kernelci.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 4.19 031/219] arm64: preempt: Fix big-endian when
 checking preempt count in assembly
Message-ID: <20191216094523.GA9938@willie-the-truck>
References: <20191122054911.1750-1-sashal@kernel.org>
 <20191122054911.1750-24-sashal@kernel.org>
 <20191214021403.GA1357@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191214021403.GA1357@home.goodmis.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 13, 2019 at 09:14:03PM -0500, Steven Rostedt wrote:
> On Fri, Nov 22, 2019 at 12:46:03AM -0500, Sasha Levin wrote:
> > From: Will Deacon <will.deacon@arm.com>
> > 
> > [ Upstream commit 7faa313f05cad184e8b17750f0cbe5216ac6debb ]
> > 
> > Commit 396244692232 ("arm64: preempt: Provide our own implementation of
> > asm/preempt.h") extended the preempt count field in struct thread_info
> > to 64 bits, so that it consists of a 32-bit count plus a 32-bit flag
> > indicating whether or not the current task needs rescheduling.
> > 
> > Whilst the asm-offsets definition of TSK_TI_PREEMPT was updated to point
> > to this new field, the assembly usage was left untouched meaning that a
> > 32-bit load from TSK_TI_PREEMPT on a big-endian machine actually returns
> > the reschedule flag instead of the count.
> > 
> > Whilst we could fix this by pointing TSK_TI_PREEMPT at the count field,
> > we're actually better off reworking the two assembly users so that they
> > operate on the whole 64-bit value in favour of inspecting the thread
> > flags separately in order to determine whether a reschedule is needed.
> > 
> > Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Reported-by: "kernelci.org bot" <bot@kernelci.org>
> > Tested-by: Kevin Hilman <khilman@baylibre.com>
> > Signed-off-by: Will Deacon <will.deacon@arm.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  arch/arm64/include/asm/assembler.h | 8 +++-----
> >  arch/arm64/kernel/entry.S          | 6 ++----
> >  2 files changed, 5 insertions(+), 9 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
> > index 5a97ac8531682..0c100506a29aa 100644
> > --- a/arch/arm64/include/asm/assembler.h
> > +++ b/arch/arm64/include/asm/assembler.h
> > @@ -683,11 +683,9 @@ USER(\label, ic	ivau, \tmp2)			// invalidate I line PoU
> >  	.macro		if_will_cond_yield_neon
> >  #ifdef CONFIG_PREEMPT
> >  	get_thread_info	x0
> > -	ldr		w1, [x0, #TSK_TI_PREEMPT]
> > -	ldr		x0, [x0, #TSK_TI_FLAGS]
> > -	cmp		w1, #PREEMPT_DISABLE_OFFSET
> > -	csel		x0, x0, xzr, eq
> > -	tbnz		x0, #TIF_NEED_RESCHED, .Lyield_\@	// needs rescheduling?
> > +	ldr		x0, [x0, #TSK_TI_PREEMPT]
> > +	sub		x0, x0, #PREEMPT_DISABLE_OFFSET
> > +	cbz		x0, .Lyield_\@
> >  	/* fall through to endif_yield_neon */
> >  	.subsection	1
> >  .Lyield_\@ :
> > diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> > index 5f800384cb9a8..bb68323530458 100644
> > --- a/arch/arm64/kernel/entry.S
> > +++ b/arch/arm64/kernel/entry.S
> > @@ -622,10 +622,8 @@ el1_irq:
> >  	irq_handler
> >  
> >  #ifdef CONFIG_PREEMPT
> > -	ldr	w24, [tsk, #TSK_TI_PREEMPT]	// get preempt count
> > -	cbnz	w24, 1f				// preempt count != 0
> > -	ldr	x0, [tsk, #TSK_TI_FLAGS]	// get flags
> > -	tbz	x0, #TIF_NEED_RESCHED, 1f	// needs rescheduling?
> > +	ldr	x24, [tsk, #TSK_TI_PREEMPT]	// get preempt count
> > +	cbnz	x24, 1f				// preempt count != 0
> >  	bl	el1_preempt
> 
> While updating 4.19-rt, I stumbled on this change to arm64 backport. And was
> confused by it, but looking deeper, this is something that breaks without
> having 396244692232f ("arm64: preempt: Provide our own implementation of
> asm/preempt.h").
> 
> That commit inverts the TIF_NEED_RESCHED meaning where set means we don't need
> to resched, and clear means we need to resched. This way we can combine the
> preempt count with the need resched flag test as they share the same 64bit
> word. A 0 means we need to preempt (as NEED_RESCHED being zero means we need
> to resched, and this also means preempt_count is zero). If the
> TIF_NEED_RESCHED bit is set, that means we don't need to resched, and if
> preempt count is something other than zero, we don't need to resched, and
> since those two are together by commit 396244692232f, we can just test
> #TSK_TI_PREEMPT. But because that commit does not exist in 4.19, we can't
> remove the TIF_NEED_RESCHED check, that this backport does, and then breaks
> the kernel!

Yup, without 396244692232 this commit makes no sense. That's why I didn't CC
stable or add a Fixes tag :(

Will
