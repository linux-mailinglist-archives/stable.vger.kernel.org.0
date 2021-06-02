Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B89398DEC
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 17:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbhFBPIO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Jun 2021 11:08:14 -0400
Received: from mail.skyhub.de ([5.9.137.197]:50944 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231363AbhFBPIO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Jun 2021 11:08:14 -0400
Received: from zn.tnic (p200300ec2f0f0e005c4e243f0fb70cb5.dip0.t-ipconnect.de [IPv6:2003:ec:2f0f:e00:5c4e:243f:fb7:cb5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BD8931EC04DA;
        Wed,  2 Jun 2021 17:06:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1622646389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=GLWo6MfRPcT6nWe8NHI4WFqqbmkdaQ4ZZQY/piZdHeU=;
        b=qbf3r+Gj2yplgXjCEnLC/DsRJugo7eLaCzPnlvwBVGxIUVxpIzt578YaWQ2GYTijnJFjda
        X2QgSwxrkOxfTNfx1sUU7EKevIo01fSPXsiPKPcmmVsth1MBbkHNhcPBIRlSwQex6iA0uW
        PkpOuj1ZrSUQR1TOEXgC8AEby+njEvw=
Date:   Wed, 2 Jun 2021 17:06:29 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>, stable@vger.kernel.org
Subject: Re: [patch 3/8] x86/fpu: Invalidate FPU state after a failed XRSTOR
 from a user buffer
Message-ID: <YLeedfdsnsKqcbGx@zn.tnic>
References: <20210602095543.149814064@linutronix.de>
 <20210602101618.627715436@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210602101618.627715436@linutronix.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 02, 2021 at 11:55:46AM +0200, Thomas Gleixner wrote:
> From: Andy Lutomirski <luto@kernel.org>
> 
> If XRSTOR fails due to sufficiently complicated paging errors (e.g.
> concurrent TLB invalidation),

I can't connect "concurrent TLB invalidation" to "sufficiently
complicated paging errors". Can you elaborate pls?

> it may fault with #PF but still modify
> portions of the user extended state.

Yikes, leaky leaky insn.

> If this happens in __fpu_restore_sig() with a victim task's FPU registers
> loaded and the task is preempted by the victim task,

This is probably meaning another task but the only task mentioned here
is a "victim task"?

> the victim task
> resumes with partially corrupt extended state.
> 
> Invalidate the FPU registers when XRSTOR fails to prevent this scenario.
> 
> Fixes: 1d731e731c4c ("x86/fpu: Add a fastpath to __fpu__restore_sig()")
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: stable@vger.kernel.org
> ---
>  arch/x86/kernel/fpu/signal.c |   21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> --- a/arch/x86/kernel/fpu/signal.c
> +++ b/arch/x86/kernel/fpu/signal.c
> @@ -369,6 +369,27 @@ static int __fpu__restore_sig(void __use
>  			fpregs_unlock();
>  			return 0;
>  		}
> +
> +		if (test_thread_flag(TIF_NEED_FPU_LOAD)) {
> +			/*
> +			 * The FPU registers do not belong to current, and
> +			 * we just did an FPU restore operation, restricted

Please get rid of the "we"-personal pronouns formulations.

> +			 * to the user portion of the register file, and

"register file"? That sounds like comment which belongs in microcode but
not in software. :-)

> +			 * failed.  In the event that the ucode was
> +			 * unfriendly and modified the registers at all, we
> +			 * need to make sure that we aren't corrupting an
> +			 * innocent non-current task's registers.
> +			 */
> +			__cpu_invalidate_fpregs_state();
> +		} else {
> +			/*
> +			 * As above, we may have just clobbered current's
> +			 * user FPU state.  We will either successfully
> +			 * load it or clear it below, so no action is
> +			 * required here.
> +			 */
> +		}

I'm wondering if that comment can simply be above the TIF_NEED_FPU_LOAD
testing, standalone, instead of having it in an empty else? And then get
rid of that else.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
