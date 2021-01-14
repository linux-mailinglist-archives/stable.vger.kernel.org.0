Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D882F611A
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 13:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbhANMhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 07:37:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726259AbhANMhl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jan 2021 07:37:41 -0500
Received: from shrek.podlesie.net (shrek-3s.podlesie.net [IPv6:2a00:13a0:3010::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EE66FC061574;
        Thu, 14 Jan 2021 04:36:58 -0800 (PST)
Received: by shrek.podlesie.net (Postfix, from userid 603)
        id D198549B; Thu, 14 Jan 2021 13:36:57 +0100 (CET)
Date:   Thu, 14 Jan 2021 13:36:57 +0100
From:   Krzysztof Mazur <krzysiek@podlesie.net>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86/lib: don't use MMX before FPU initialization
Message-ID: <20210114123657.GA6358@shrek.podlesie.net>
References: <20201228160631.32732-1-krzysiek@podlesie.net>
 <20210112000923.GK25645@zn.tnic>
 <20210114092218.GA26786@shrek.podlesie.net>
 <20210114094425.GA12284@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114094425.GA12284@zn.tnic>
User-Agent: Mutt/1.6.2 (2016-07-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 14, 2021 at 10:44:25AM +0100, Borislav Petkov wrote:
> I believe the correct fix should be
> 
> 	if (unlikely(in_interrupt()) || !(cr4_read_shadow() & X86_CR4_OSFXSR))
> 		return __memcpy(to, from, len);
> 
> in _mmx_memcpy() as you had it in your first patch.
> 

The OSFXSR must be set only on CPUs with SSE. There
are some CPUs with 3DNow!, but without SSE and FXSR (like AMD
Geode LX, which is still used in many embedded systems).
So, I've changed that to:

if (unlikely(in_interrupt()) || (boot_cpu_has(X86_FEATURE_XMM) &&
		unlikely(!(cr4_read_shadow() & X86_CR4_OSFXSR))))


However, I'm not sure that adding two taken branches (that
second unlikely() does not help gcc to generate better code) and
a call to cr4_read_shadow() (not inlined) is a good idea.
The static branch adds a single jump, which is changed to
NOP. The code with boot_cpu_has() and CR4 checks adds:

c09932ad:	a1 50 50 c3 c0       	mov    0xc0c35050,%eax
c09932b2:	a9 00 00 00 02       	test   $0x2000000,%eax
/* this branch is taken */
c09932b7:	0f 85 13 01 00 00    	jne    c09933d0 <_mmx_memcpy+0x140>

c09932bd:	/* MMX code is here */

/* cr4_read_shadow is not inlined */
c09933d0:	e8 8b 01 78 ff       	call   c0113560 <cr4_read_shadow>
c09933d5:	f6 c4 02             	test   $0x2,%ah
/* this branch is also taken */
c09933d8:	0f 85 df fe ff ff    	jne    c09932bd <_mmx_memcpy+0x2d>


However, except for some embedded systems, probably almost nobody uses
that code today, and the most imporant is avoiding future breakage. And
I'm not sure which approach is better. Because that CR4 test tests
for a feature that is not used in mmx_memcpy(), but it's used in
kernel_fpu_begin(). And in future kernel_fpu_begin() may change and
require also other stuff. So I think that the best approach would be
delay any FPU optimized memcpy() after fpu__init_system() is executed.

Best regards,
Krzysiek
-- >8 --
Subject: [PATCH] x86/lib: don't use mmx_memcpy() to early

The MMX 3DNow! optimized memcpy() is used very early,
even before FPU is initialized in the kernel. It worked fine, but commit
7ad816762f9bf89e940e618ea40c43138b479e10 ("x86/fpu: Reset MXCSR
to default in kernel_fpu_begin()") broke that. After that
commit the kernel_fpu_begin() assumes that FXSR is enabled in
the CR4 register on all processors with SSE. Because memcpy() is used
before FXSR is enabled, the kernel crashes just after "Booting the kernel."
message. It affects all kernels with CONFIG_X86_USE_3DNOW (enabled when
some AMD/Cyrix processors are selected) on processors with SSE
(like AMD K7, which supports both MMX 3DNow! and SSE).

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>
---
 arch/x86/lib/mmx_32.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/lib/mmx_32.c b/arch/x86/lib/mmx_32.c
index 4321fa02e18d..70aa769570e6 100644
--- a/arch/x86/lib/mmx_32.c
+++ b/arch/x86/lib/mmx_32.c
@@ -25,13 +25,20 @@
 
 #include <asm/fpu/api.h>
 #include <asm/asm.h>
+#include <asm/tlbflush.h>
 
 void *_mmx_memcpy(void *to, const void *from, size_t len)
 {
 	void *p;
 	int i;
 
-	if (unlikely(in_interrupt()))
+	/*
+	 * kernel_fpu_begin() assumes that FXSR is enabled on all processors
+	 * with SSE. Thus, MMX-optimized version can't be used
+	 * before the kernel enables FXSR (OSFXSR bit in the CR4 register).
+	 */
+	if (unlikely(in_interrupt()) || (boot_cpu_has(X86_FEATURE_XMM) &&
+			unlikely(!(cr4_read_shadow() & X86_CR4_OSFXSR))))
 		return __memcpy(to, from, len);
 
 	p = to;
-- 
2.27.0.rc1.207.gb85828341f

