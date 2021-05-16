Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2D58381D92
	for <lists+stable@lfdr.de>; Sun, 16 May 2021 11:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbhEPJOz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 May 2021 05:14:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231771AbhEPJOz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 16 May 2021 05:14:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52962610C9;
        Sun, 16 May 2021 09:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621156419;
        bh=ZiK1VNc7cOF0Y+lq8wf1aQ3+dq/I0B4THIbs52k21Vs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tUgEBZNnJxc+QskhSGtN7qQlxQ/yI7rbVEVemh1wVkw0u0Jw71AfMHpTf+hWs/u5D
         EuvPFHuNJOYX5JlP8WwEiu8Gpspyqeae2Bz93NiyhNI+yKfs7ZXLqy/p+AiMoajUDB
         ASYKkSIQu0ya5haOaJ9SrzfC4W+MKDdggUteO4/c=
Date:   Sun, 16 May 2021 11:13:37 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     stable@vger.kernel.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: Re: [PATCH 5.12] MIPS: Reinstate platform `__div64_32' handler
Message-ID: <YKDiQUcuqIDwRvyg@kroah.com>
References: <alpine.DEB.2.21.2105160318070.3032@angie.orcam.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2105160318070.3032@angie.orcam.me.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 16, 2021 at 03:58:19AM +0200, Maciej W. Rozycki wrote:
> Our current MIPS platform `__div64_32' handler is inactive, because it 
> is incorrectly only enabled for 64-bit configurations, for which generic 
> `do_div' code does not call it anyway.
> 
> The handler is not suitable for being called from there though as it 
> only calculates 32 bits of the quotient under the assumption the 64-bit 
> divident has been suitably reduced.  Code for such reduction used to be 
> there, however it has been incorrectly removed with commit c21004cd5b4c 
> ("MIPS: Rewrite <asm/div64.h> to work with gcc 4.4.0."), which should 
> have only updated an obsoleted constraint for an inline asm involving 
> $hi and $lo register outputs, while possibly wiring the original MIPS 
> variant of the `do_div' macro as `__div64_32' handler for the generic 
> `do_div' implementation
> 
> Correct the handler as follows then:
> 
> - Revert most of the commit referred, however retaining the current 
>   formatting, except for the final two instructions of the inline asm 
>   sequence, which the original commit missed.  Omit the original 64-bit 
>   parts though.
> 
> - Rename the original `do_div' macro to `__div64_32'.  Remove the inline 
>   asm with a DIVU instruction and use plain C code for the intended DIVMOD 
>   calculation instead.  GCC is smart enough to know that both the quotient 
>   and the remainder are calculated with single DIVU, so with ISAs up to R5 
>   the same instruction is actually produced with overall similar code.
> 
>   For R6 compiled code will work, but separate DIVU and MODU instructions 
>   will be produced, which are also interlocked, so scalar implementations 
>   will likely not perform as well as older ISAs with their asynchronous MD 
>   unit.  Likely still faster than the generic algorithm though.
> 
> - Rename the `__base' local variable in `__div64_32' to `__radix' to 
>   avoid a conflict with a local variable in `do_div'.
> 
> - Actually enable this code for 32-bit rather than 64-bit configurations
>   by qualifying it with BITS_PER_LONG being 32 instead of 64.  Include 
>   <asm/bitsperlong.h> for this macro rather than <linux/types.h> as we 
>   don't need anything else.
> 
> - Finally include <asm-generic/div64.h> last rather than first.
> 
> This has passed correctness verification with test_div64 and reduced the 
> module's average execution time down to 1.0668s and 0.2629s from 2.1529s 
> and 0.5647s respectively for an R3400 CPU @40MHz and a 5Kc CPU @160MHz.  
> For a reference 64-bit `do_div' code where we have the DDIVU instruction 
> available to do the whole calculation right away averages at 0.0660s for 
> the latter CPU.
> 
> Reported-by: Huacai Chen <chenhuacai@kernel.org>
> Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
> Fixes: c21004cd5b4c ("MIPS: Rewrite <asm/div64.h> to work with gcc 4.4.0.")
> Cc: stable@vger.kernel.org # v2.6.30+
> ---
> Hi,
> 
>  This is a backported version of commit c49f71f60754 with a fix for MIPSr6 
> compilation, that is commit 25ab14cbe9d1 included and the commit message 
> amended accordingly.  I have folded intermediate commit c1d337d45ec0 into 
> this change as well, as trivially obvious and mechanically in the way 
> between the two former changes, though strictly speaking an enhancement 
> rather than a fix.  This way the state between master and stable branches 
> is consistent.
> 
>  Rationale: the three changes could be applied separately as with master, 
> however we'd have an unnecessary intermediate MIPSr6 build regression, 
> which caused the drop of the original fix.
> 
>  This is for 5.12-stable and before.  Let me know if you'd prefer me to 
> resolve this differently, or otherwise please apply.
> 
>  NB verified with a couple of representative defconfigs and booted on hw 
> where available (with the test_div64 test module backported and enabled).

I would prefer to take the same exact commits that are in Linus's tree,
that makes it easier to track over time and ensure that we have this
correct.

So what commit ids should I apply in what order?

thanks,

greg k-h
