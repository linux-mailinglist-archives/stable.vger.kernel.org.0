Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5DF2F6378
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 15:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbhANOvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 09:51:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727460AbhANOvq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jan 2021 09:51:46 -0500
Received: from shrek.podlesie.net (shrek-3s.podlesie.net [IPv6:2a00:13a0:3010::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 09658C0613C1;
        Thu, 14 Jan 2021 06:51:06 -0800 (PST)
Received: by shrek.podlesie.net (Postfix, from userid 603)
        id 52B9D49B; Thu, 14 Jan 2021 15:51:05 +0100 (CET)
Date:   Thu, 14 Jan 2021 15:51:05 +0100
From:   Krzysztof Mazur <krzysiek@podlesie.net>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86/lib: don't use MMX before FPU initialization
Message-ID: <20210114145105.GA17363@shrek.podlesie.net>
References: <20201228160631.32732-1-krzysiek@podlesie.net>
 <20210112000923.GK25645@zn.tnic>
 <20210114092218.GA26786@shrek.podlesie.net>
 <20210114094425.GA12284@zn.tnic>
 <20210114123657.GA6358@shrek.podlesie.net>
 <20210114140737.GD12284@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114140737.GD12284@zn.tnic>
User-Agent: Mutt/1.6.2 (2016-07-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 14, 2021 at 03:07:37PM +0100, Borislav Petkov wrote:
> On Thu, Jan 14, 2021 at 01:36:57PM +0100, Krzysztof Mazur wrote:
> > The OSFXSR must be set only on CPUs with SSE. There
> > are some CPUs with 3DNow!, but without SSE and FXSR (like AMD
> > Geode LX, which is still used in many embedded systems).
> > So, I've changed that to:
> > 
> > if (unlikely(in_interrupt()) || (boot_cpu_has(X86_FEATURE_XMM) &&
> > 		unlikely(!(cr4_read_shadow() & X86_CR4_OSFXSR))))
> 
> Why?
> 
> X86_CR4_OSFXSR won't ever be set on those CPUs but the test will be
> performed anyway. So there's no need for boot_cpu_has().

Because the MMX version should be always used on those CPUs, even without
OSFXSR set. If the CPU does not support SSE, it is safe to
call kernel_fpu_begin() without OSFXSR set.
"!(cr4_read_shadow() & X86_CR4_OSFXSR)" will be always true on
those CPUs, and without boot_cpu_has() MMX version will be never used.

There are two cases:

3DNow! without SSE		always use MMX version
3DNow! + SSE (K7)		use MMX version only if FXSR is enabled

Thanks.

Best regards,
Krzysiek
-- >8 --
Subject: [PATCH] x86/lib: don't use mmx_memcpy() too early

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

Fixes: 7ad816762f9b ("x86/fpu: Reset MXCSR to default in kernel_fpu_begin()")
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <stable@vger.kernel.org> # 5.8+
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

