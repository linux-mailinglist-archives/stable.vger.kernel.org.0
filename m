Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3BF4260A3
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 01:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233316AbhJGXmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 19:42:11 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:40324 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231373AbhJGXmK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Oct 2021 19:42:10 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633650015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9641XH6wBjWKqS4wnknUNssteTZImIDG9FGAAxiK/lE=;
        b=4E5bi0F3l/eICG5udutOIMRYo/TcPS4IzqeIYgvzMf8CCHCeycOyRwdGOEMYPHccmsnalC
        YsPSyiwasz4AeVgyejSDus1XIF2DRb25kCUX5tdLxkaPR1oL/jkEgKRu86uVxsFeVtX7Ws
        oDMdK+zp5+W46vYjgkVCQkyxovcNbptKCTl5Yvy25b/4HqtKVmGn3+8Zw+8WLyUfwq3Jcc
        7sl0gJCSb+1JyiAIQe1S3ptN8wiqlWYDmAYxkEQrtwtHwe1kJZQZVcjVkgSOn9XTk6vsw1
        wZThNH/ImAWkeVe611ZvdIbTyDGR0xLPOtr7tAURzlBstABriev8+092P+/yLA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633650015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9641XH6wBjWKqS4wnknUNssteTZImIDG9FGAAxiK/lE=;
        b=p0KHo6mP03uvLpZG9IYjafM6wZKg2LloS/O1j4DyWlBw86xDAKizjJkKzpvsBZq2IU47sA
        dPb8Qn79lH98RCBw==
To:     tip-bot2 for Borislav Petkov <tip-bot2@linutronix.de>,
        linux-tip-commits@vger.kernel.org
Cc:     Ser Olmy <ser.olmy@protonmail.com>, Borislav Petkov <bp@suse.de>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [tip: x86/urgent] x86/fpu: Restore the masking out of reserved
 MXCSR bits
In-Reply-To: <163354193576.25758.8132624386883258818.tip-bot2@tip-bot2>
References: <YVtA67jImg3KlBTw@zn.tnic>
 <163354193576.25758.8132624386883258818.tip-bot2@tip-bot2>
Date:   Fri, 08 Oct 2021 01:40:14 +0200
Message-ID: <87mtnke74x.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 06 2021 at 17:38, tip-bot wrote:
> Ser bisected the problem to the commit in Fixes.
>
> tglx suggested reverting the rejection of invalid MXCSR values which
> this commit introduced and replacing it with what the old code did -
> simply masking them out to zero.
>
> Further debugging confirmed his suggestion:
>
>   fpu->state.fxsave.mxcsr: 0xb7be13b4, mxcsr_feature_mask: 0xffbf
>   WARNING: CPU: 0 PID: 1 at arch/x86/kernel/fpu/signal.c:384 __fpu_restore_sig+0x51f/0x540
>
> so restore the original behavior.
>
> Fixes: 6f9866a166cd ("x86/fpu/signal: Let xrstor handle the features to init")
> Reported-by: Ser Olmy <ser.olmy@protonmail.com>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Tested-by: Ser Olmy <ser.olmy@protonmail.com>
> Cc: <stable@vger.kernel.org>
> Link: https://lkml.kernel.org/r/YVtA67jImg3KlBTw@zn.tnic
> ---
>  arch/x86/kernel/fpu/signal.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
> index 445c57c..684be34 100644
> --- a/arch/x86/kernel/fpu/signal.c
> +++ b/arch/x86/kernel/fpu/signal.c
> @@ -379,9 +379,8 @@ static int __fpu_restore_sig(void __user *buf, void __user *buf_fx,
>  				     sizeof(fpu->state.fxsave)))
>  			return -EFAULT;
>  
> -		/* Reject invalid MXCSR values. */
> -		if (fpu->state.fxsave.mxcsr & ~mxcsr_feature_mask)
> -			return -EINVAL;
> +		/* Mask out reserved MXCSR bits. */
> +		fpu->state.fxsave.mxcsr &= mxcsr_feature_mask;

can we please make this:

--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -384,9 +384,14 @@ static bool __fpu_restore_sig(void __use
 				     sizeof(fpu->state.fxsave)))
 			return false;
 
-		/* Reject invalid MXCSR values. */
-		if (fpu->state.fxsave.mxcsr & ~mxcsr_feature_mask)
-			return false;
+		if (IS_ENABLED(CONFIG_X86_64)) {
+			/* Reject invalid MXCSR values. */
+			if (fpu->state.fxsave.mxcsr & ~mxcsr_feature_mask)
+				return false;
+		} else {
+			/* Mask invalid bits out for historical reasons (broken hardware) */
+			fpu->state.fxsave.mxcsr &= ~mxcsr_feature_mask;
+		}
 
 		/* Enforce XFEATURE_MASK_FPSSE when XSAVE is enabled */
 		if (use_xsave())

On a 64 bit kernel even 32bit user space which supplies broken mxcsr
values has to be considered malicious.

The 32bit story on those stone age machines is different because the
hardware is simply buggy and we can't differentiate between broken
hardware and broken or malicious software.

Thanks,

        tglx
