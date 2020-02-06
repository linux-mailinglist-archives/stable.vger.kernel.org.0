Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA9781543ED
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 13:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbgBFMUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 07:20:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:47626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727111AbgBFMUw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Feb 2020 07:20:52 -0500
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D044221741;
        Thu,  6 Feb 2020 12:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580991652;
        bh=Hz5mpDtiqCA0N/S1stMo+BEahL/BwrOPzwytyLbcvNQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RMhc20A6ccaCbc9w6tjniyG1wGM6LnQ7MctrJ88A82L9QdoUUDV1jFIwumX34uQRt
         T/YzRaL4SoWJPuMhu65w7sxTkjAXL3LOmnsLXrkKFGH+anVJEm11GMlk27ty5HjFSs
         e3J7Q3E/YF5v/tvxJm0I7aIU3TPwJLWewDt+nXoI=
Date:   Thu, 6 Feb 2020 12:20:47 +0000
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com,
        kernel-team@android.com, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Srinivas Ramana <sramana@codeaurora.org>
Subject: Re: [PATCH] arm64: ssbs: Fix context-switch when SSBS instructions
 are present
Message-ID: <20200206122047.GA18762@willie-the-truck>
References: <20200206113410.18301-1-will@kernel.org>
 <10b7b4b0bcc443db7028efbdee789549@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10b7b4b0bcc443db7028efbdee789549@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 06, 2020 at 11:49:31AM +0000, Marc Zyngier wrote:
> On 2020-02-06 11:34, Will Deacon wrote:
> > When all CPUs in the system implement the SSBS instructions, we
> > advertise this via an HWCAP and allow EL0 to toggle the SSBS field
> > in PSTATE directly. Consequently, the state of the mitigation is not
> > accurately tracked by the TIF_SSBD thread flag and the PSTATE value
> > is authoritative.
> > 
> > Avoid forcing the SSBS field in context-switch on such a system, and
> > simply rely on the PSTATE register instead.
> > 
> > Cc: <stable@vger.kernel.org>
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Srinivas Ramana <sramana@codeaurora.org>
> > Fixes: cbdf8a189a66 ("arm64: Force SSBS on context switch")
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> >  arch/arm64/kernel/process.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> > index d54586d5b031..45e867f40a7a 100644
> > --- a/arch/arm64/kernel/process.c
> > +++ b/arch/arm64/kernel/process.c
> > @@ -466,6 +466,13 @@ static void ssbs_thread_switch(struct task_struct
> > *next)
> >  	if (unlikely(next->flags & PF_KTHREAD))
> >  		return;
> > 
> > +	/*
> > +	 * If all CPUs implement the SSBS instructions, then we just
> > +	 * need to context-switch the PSTATE field.
> > +	 */
> > +	if (cpu_have_feature(cpu_feature(SSBS)))
> > +		return;
> > +
> >  	/* If the mitigation is enabled, then we leave SSBS clear. */
> >  	if ((arm64_get_ssbd_state() == ARM64_SSBD_FORCE_ENABLE) ||
> >  	    test_tsk_thread_flag(next, TIF_SSBD))
> 
> Looks goot to me.

Ja!

> Reviewed-by: Marc Zyngier <maz@kernel.org>

Cheers. It occurs to me that, although the patch is correct, the comment and
the commit message need tweaking because we're actually predicating this on
the presence of SSBS in any form, so the instructions may not be
implemented. That's fine because the prctl() updates pstate, so it remains
authoritative and can't be lost by one of the CPUs treating it as RAZ/WI.

I'll spin a v2 later on.

Will
