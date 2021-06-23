Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2BCC3B1D24
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 17:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbhFWPHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 11:07:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:36488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhFWPHB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Jun 2021 11:07:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED9D96112D;
        Wed, 23 Jun 2021 15:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624460683;
        bh=d/HmZqC69C4x/aX5XbllpmTiOSLqA9GN+9UcMVEIaPg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JAq6fefHgwzwrltPQcvt/B4oxffVRoFVCDis7bNLnIjACfUd4c5bsAr7mQaR08qeY
         gDuFPVpw47ZdrcGGM9bl0ELU47+Zy8jZTc+K7BScMkAju6kYvY9U7HLZYcoIhjPHIh
         YHlj6HjMQQSvtX9i8pbLIMtL4PLAp9mAiLIj/mxI=
Date:   Wed, 23 Jun 2021 17:04:41 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Borislav Petkov <bp@suse.de>, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/fpu: Reset state for all signal
 restore failures" failed to apply to 4.4-stable tree
Message-ID: <YNNNiU7fFy/AFlxV@kroah.com>
References: <162427273275124@kroah.com>
 <YNDQHgGztJAWO2H+@zn.tnic>
 <YNG4q++kHwWtVupg@kroah.com>
 <878s31ekg8.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <878s31ekg8.ffs@nanos.tec.linutronix.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 22, 2021 at 10:03:03PM +0200, Thomas Gleixner wrote:
> On Tue, Jun 22 2021 at 12:17, Greg KH wrote:
> 
> > On Mon, Jun 21, 2021 at 07:45:02PM +0200, Borislav Petkov wrote:
> >> On Mon, Jun 21, 2021 at 12:52:12PM +0200, gregkh@linuxfoundation.org wrote:
> >> > 
> >> > The patch below does not apply to the 4.4-stable tree.
> >> > If someone wants it applied there, or to any other stable or longterm
> >> > tree, then please email the backport, including the original git commit
> >> > id to <stable@vger.kernel.org>.
> >> 
> >> Ok, how's this below?
> >> 
> >> It should at least capture the gist of what this commit is trying to
> >> achieve as the FPU mess has changed substantially since 4.4 so I'm
> >> really cautious here not to break any existing setups.
> >> 
> >> I've boot-tested this in a VM but Greg, I'd appreciate running it
> >> through some sort of stable testing framework if you're using one.
> >
> > This applied to 4.4.y and 4.9.y, but we still need a 4.14.y and 4.19.y
> > version if at all possible.
> 
> Everything is possible :)
> 
> ---
> Subject: x86/fpu: Reset state for all signal restore failures
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Wed Jun  9 21:18:00 2021 +0200
> 
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> commit efa165504943f2128d50f63de0c02faf6dcceb0d upstream
> 
> If access_ok() or fpregs_soft_set() fails in __fpu__restore_sig() then the
> function just returns but does not clear the FPU state as it does for all
> other fatal failures.
> 
> Clear the FPU state for these failures as well.
> 
> Fixes: 72a671ced66d ("x86, fpu: Unify signal handling code paths for x86 and x86_64 kernels")
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: stable@vger.kernel.org
> Link: https://lkml.kernel.org/r/87mtryyhhz.ffs@nanos.tec.linutronix.de
> 
> ---
>  arch/x86/kernel/fpu/signal.c |   30 +++++++++++++++++++-----------
>  1 file changed, 19 insertions(+), 11 deletions(-)
> ---
> --- a/arch/x86/kernel/fpu/signal.c
> +++ b/arch/x86/kernel/fpu/signal.c
> @@ -281,15 +281,21 @@ static int __fpu__restore_sig(void __use
>  		return 0;
>  	}
>  
> -	if (!access_ok(VERIFY_READ, buf, size))
> -		return -EACCES;
> +	if (!access_ok(VERIFY_READ, buf, size)) {
> +		ret = -EACCES;
> +		goto out_err;
> +	}
>  
>  	fpu__initialize(fpu);
>  
> -	if (!static_cpu_has(X86_FEATURE_FPU))
> -		return fpregs_soft_set(current, NULL,
> -				       0, sizeof(struct user_i387_ia32_struct),
> -				       NULL, buf) != 0;
> +	if (!static_cpu_has(X86_FEATURE_FPU)) {
> +		ret = fpregs_soft_set(current, NULL,
> +				      0, sizeof(struct user_i387_ia32_struct),
> +				      NULL, buf) != 0;
> +		if (ret)
> +			goto out_err;
> +		return 0;
> +	}
>  
>  	if (use_xsave()) {
>  		struct _fpx_sw_bytes fx_sw_user;
> @@ -349,6 +355,7 @@ static int __fpu__restore_sig(void __use
>  		fpu__restore(fpu);
>  		local_bh_enable();
>  
> +		/* Failure is already handled */
>  		return err;
>  	} else {
>  		/*
> @@ -356,13 +363,14 @@ static int __fpu__restore_sig(void __use
>  		 * state to the registers directly (with exceptions handled).
>  		 */
>  		user_fpu_begin();
> -		if (copy_user_to_fpregs_zeroing(buf_fx, xfeatures, fx_only)) {
> -			fpu__clear(fpu);
> -			return -1;
> -		}
> +		if (!copy_user_to_fpregs_zeroing(buf_fx, xfeatures, fx_only))
> +			return 0;
> +		ret = -1;
>  	}
>  
> -	return 0;
> +out_err:
> +	fpu__clear(fpu);
> +	return ret;
>  }
>  
>  static inline int xstate_sigframe_size(void)

Hm, did you build this?

I get the following build error:
arch/x86/kernel/fpu/signal.c: In function ‘__fpu__restore_sig’:
arch/x86/kernel/fpu/signal.c:285:17: error: ‘ret’ undeclared (first use in this function); did you mean ‘net’?
  285 |                 ret = -EACCES;
      |                 ^~~
      |                 net
arch/x86/kernel/fpu/signal.c:285:17: note: each undeclared identifier is reported only once for each function it appears in
arch/x86/kernel/fpu/signal.c:374:1: warning: control reaches end of non-void function [-Wreturn-type]
  374 | }
      | ^

I'll fix it up, it's an "obvious" change :)

thanks,

greg k-h
