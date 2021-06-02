Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA8B3398A39
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 15:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhFBNO3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Jun 2021 09:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbhFBNO3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Jun 2021 09:14:29 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E419C061574;
        Wed,  2 Jun 2021 06:12:46 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0f0e00eeb0fb45e4479fa5.dip0.t-ipconnect.de [IPv6:2003:ec:2f0f:e00:eeb0:fb45:e447:9fa5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8F2241EC03D2;
        Wed,  2 Jun 2021 15:12:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1622639564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IinqjbSWeoabF0QmaUNNBv38d7v6vXyIK8neZqnz8q4=;
        b=rycYARL02BpEmdJ1FQ3jhabykdaVumGareEHhsrECJc4ozzj9ncaby8N+ZOgPpufVUv391
        vwuLqtQOTiy0BH07bATdt+7hpnl1fF4FKcwfoHJGtkK1wxUrE+hb0ZRscEpWsXcI+AkVKm
        Hm3Ezk4P3U9y/ixWfx4dhROc4lGCclE=
Date:   Wed, 2 Jun 2021 15:12:39 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>,
        syzbot+2067e764dbcd10721e2e@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Subject: Re: [patch 2/8] x86/fpu: Prevent state corruption in
 __fpu__restore_sig()
Message-ID: <YLeDx+EohkPpjabd@zn.tnic>
References: <20210602095543.149814064@linutronix.de>
 <20210602101618.462908825@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210602101618.462908825@linutronix.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 02, 2021 at 11:55:45AM +0200, Thomas Gleixner wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> The non-compacted slowpath uses __copy_from_user() and copies the entire
> user buffer into the kernel buffer, verbatim.  This means that the kernel
> buffer may now contain entirely invalid state on which XRSTOR will #GP.
> validate_user_xstate_header() can detect some of that corruption, but that
> leaves the onus on callers to clear the buffer.
> 
> Prior to XSAVES support it was possible just to reinitialize the buffer,
> completely, but with supervisor states that is not longer possible as the
> buffer clearing code split got it backwards. Fixing that is possible, but
> not corrupting the state in the first place is more robust.
> 
> Avoid corruption of the kernel XSAVE buffer by using copy_user_to_xstate()
> which validates the XSAVE header contents before copying the actual states
> to the kernel. copy_user_to_xstate() was previously only called for
> compacted-format kernel buffers, but it works for both compacted and
> non-compacted forms.
> 
> Using it for the non-compacted form is slower because of multiple
> __copy_from_user() operations, but that cost is less important than robust
> code in an already slow path.
> 
> [ Changelog polished by Dave Hansen ]

Nice polishing!

> Fixes: b860eb8dce59 ("x86/fpu/xstate: Define new functions for clearing fpregs and xstates")
> Reported-by: syzbot+2067e764dbcd10721e2e@syzkaller.appspotmail.com
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: stable@vger.kernel.org
> ---
>  arch/x86/include/asm/fpu/xstate.h |    4 ----
>  arch/x86/kernel/fpu/signal.c      |    9 +--------
>  arch/x86/kernel/fpu/xstate.c      |    2 +-
>  3 files changed, 2 insertions(+), 13 deletions(-)
> 
> --- a/arch/x86/include/asm/fpu/xstate.h
> +++ b/arch/x86/include/asm/fpu/xstate.h
> @@ -112,8 +112,4 @@ void copy_supervisor_to_kernel(struct xr
>  void copy_dynamic_supervisor_to_kernel(struct xregs_state *xstate, u64 mask);
>  void copy_kernel_to_dynamic_supervisor(struct xregs_state *xstate, u64 mask);
>  
> -
> -/* Validate an xstate header supplied by userspace (ptrace or sigreturn) */
> -int validate_user_xstate_header(const struct xstate_header *hdr);
> -
>  #endif
> --- a/arch/x86/kernel/fpu/signal.c
> +++ b/arch/x86/kernel/fpu/signal.c
> @@ -405,14 +405,7 @@ static int __fpu__restore_sig(void __use
>  	if (use_xsave() && !fx_only) {
>  		u64 init_bv = xfeatures_mask_user() & ~user_xfeatures;
>  
> -		if (using_compacted_format()) {
> -			ret = copy_user_to_xstate(&fpu->state.xsave, buf_fx);
> -		} else {
> -			ret = __copy_from_user(&fpu->state.xsave, buf_fx, state_size);
> -
> -			if (!ret && state_size > offsetof(struct xregs_state, header))
> -				ret = validate_user_xstate_header(&fpu->state.xsave.header);
> -		}
> +		ret = copy_user_to_xstate(&fpu->state.xsave, buf_fx);
>  		if (ret)
>  			goto err_out;
>  
> --- a/arch/x86/kernel/fpu/xstate.c
> +++ b/arch/x86/kernel/fpu/xstate.c
> @@ -515,7 +515,7 @@ int using_compacted_format(void)
>  }
>  
>  /* Validate an xstate header supplied by userspace (ptrace or sigreturn) */
> -int validate_user_xstate_header(const struct xstate_header *hdr)
> +static int validate_user_xstate_header(const struct xstate_header *hdr)

Can't do that yet - that one is still called from regset.c:

arch/x86/kernel/fpu/regset.c: In function ‘xstateregs_set’:
arch/x86/kernel/fpu/regset.c:135:10: error: implicit declaration of function ‘validate_user_xstate_header’ [-Werror=implicit-function-declaration]
  135 |    ret = validate_user_xstate_header(&xsave->header);
      |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~
cc1: some warnings being treated as errors

Maybe after the 5th patch which kills that usage too.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
