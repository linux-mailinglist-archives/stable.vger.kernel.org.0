Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B30DE2F6F3E
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 01:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729186AbhAOAGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 19:06:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727047AbhAOAGi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jan 2021 19:06:38 -0500
Received: from shrek.podlesie.net (shrek-3s.podlesie.net [IPv6:2a00:13a0:3010::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 12960C061575;
        Thu, 14 Jan 2021 16:05:58 -0800 (PST)
Received: by shrek.podlesie.net (Postfix, from userid 603)
        id 594E86C9; Fri, 15 Jan 2021 01:05:57 +0100 (CET)
Date:   Fri, 15 Jan 2021 01:05:57 +0100
From:   Krzysztof Mazur <krzysiek@podlesie.net>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     "Jason A. Donenfeld" <zx2c4@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] x86/lib: don't use MMX before FPU initialization
Message-ID: <20210115000557.GA12468@shrek.podlesie.net>
References: <20201228160631.32732-1-krzysiek@podlesie.net>
 <20210112000923.GK25645@zn.tnic>
 <20210114092218.GA26786@shrek.podlesie.net>
 <20210114094425.GA12284@zn.tnic>
 <20210114123657.GA6358@shrek.podlesie.net>
 <20210114140737.GD12284@zn.tnic>
 <20210114145105.GA17363@shrek.podlesie.net>
 <CALCETrU0Y_Cg--Vs-88Hu9vTR-QynC0AQOpYehE86MYow5u3RQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrU0Y_Cg--Vs-88Hu9vTR-QynC0AQOpYehE86MYow5u3RQ@mail.gmail.com>
User-Agent: Mutt/1.6.2 (2016-07-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 14, 2021 at 08:31:30AM -0800, Andy Lutomirski wrote:
> This is gross.  I realize this is only used for old CPUs that we don't
> care about perf-wise

Performance might be still important for embedded systems (Geode LX
seems to be supported "until at least 2021").

> , but this code is nonsense -- it makes absolutely
> to sense to put this absurd condition here to work around
> kernel_fpu_begin() bugs.

Yes, it's nonsense. But I think that the kernel might have a silent
assumption, that the FPU cannot be used too early.

> If we want to use MMX, we should check MMX.
> And we should also check the correct condition re: irqs.  So this code
> should be:
> 
> if (boot_cpu_has(X86_FEATURE_XMM) && irq_fpu_usable()) {
>   kernel_fpu_begin_mask(FPU_MASK_XMM);
>   ...

This code does not use SSE (XMM). It uses only MMX and 3DNow!, so XMM
check is not needed here. And this code is enabled only when a processor
with 3DNow! is selected ("lib-$(CONFIG_X86_USE_3DNOW) += mmx_32.o"
in Makefile). So:

	if (!irq_fpu_usable())
		fallback_to_non_mmx_code();

is sufficient.

But the original:

	if (!in_interrupt())
		fallback_to_non_mmx_code();

is also valid. Changing it to irq_fpu_usable() might allow using
MMX variant in more cases and even improve performance. But it
can also introduce some regressions.

> or we could improve code gen by adding a try_kernel_fpu_begin_mask()
> so we can do a single call instead of two.
> [...]
> What do you all think?  If you're generally in favor, I can write the
> code and do a quick audit for other weird cases in the kernel.

I think that the cleanest approach would be introducing fpu_usable(),
which returns 0 (or false) if FPU is not initialized yet. Then
irq_fpu_usable() could be changed to:

bool irq_fpu_usable(void)
{
	return fpu_usable() && (!in_interrupt() ||
		interrupted_user_mode() ||
		interrupted_kernel_fpu_idle());
}

and in the _mmx_memcpy():

-	if (unlikely(in_interrupt()))
+	if (unlikely(irq_fpu_usable()))
		return __memcpy(to, from, len);


try_kernel_fpu_begin(), even without mask, is also a good idea.
If the FPU is not available yet (FPU not initizalized yet) it can fail
and a fallback code would be used. However, in some cases fpu_usable()
+ kernel_fpu_begin() might be better, if between fpu_usable() check
and kernel_fpu_begin() long preparation is required. (kernel_fpu_begin()
disables preemption). In the mmx_32.c case try_kernel_fpu_begin()
looks good, only two simple lines are added to a section with disabled
preemption:

diff --git a/arch/x86/lib/mmx_32.c b/arch/x86/lib/mmx_32.c
index 4321fa02e18d..9c6dadd2b2ef 100644
--- a/arch/x86/lib/mmx_32.c
+++ b/arch/x86/lib/mmx_32.c
@@ -31,14 +31,12 @@ void *_mmx_memcpy(void *to, const void *from, size_t len)
 	void *p;
 	int i;
 
-	if (unlikely(in_interrupt()))
+	if (unlikely(try_kernel_fpu_begin()))
 		return __memcpy(to, from, len);
 
 	p = to;
 	i = len >> 6; /* len/64 */
 
-	kernel_fpu_begin();
-
 	__asm__ __volatile__ (
 		"1: prefetch (%0)\n"		/* This set is 28 bytes */
 		"   prefetch 64(%0)\n"



And if try_kernel_fpu_begin_mask() with a mask will allow for some
optimizations it also might be a good idea.

> Or we could flip the OSFSXR bit very early, I suppose.

I think that my original static_branch_likely() workaround might
be the simplest and touches only mmx_32.c. Such approach is already
used in the kernel, for instance in the crypto code:

$ git grep static_branch arch/x86/crypto/


And maybe using FPU too early should be forbidden.

Best regards,
Krzysiek
