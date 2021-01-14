Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5FE82F5D33
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 10:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbhANJXC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 04:23:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727776AbhANJXC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jan 2021 04:23:02 -0500
Received: from shrek.podlesie.net (shrek-3s.podlesie.net [IPv6:2a00:13a0:3010::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1147CC061575;
        Thu, 14 Jan 2021 01:22:21 -0800 (PST)
Received: by shrek.podlesie.net (Postfix, from userid 603)
        id 5545A49B; Thu, 14 Jan 2021 10:22:18 +0100 (CET)
Date:   Thu, 14 Jan 2021 10:22:18 +0100
From:   Krzysztof Mazur <krzysiek@podlesie.net>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86/lib: don't use MMX before FPU initialization
Message-ID: <20210114092218.GA26786@shrek.podlesie.net>
References: <20201228160631.32732-1-krzysiek@podlesie.net>
 <20210112000923.GK25645@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112000923.GK25645@zn.tnic>
User-Agent: Mutt/1.6.2 (2016-07-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 12, 2021 at 01:09:23AM +0100, Borislav Petkov wrote:
> On Mon, Dec 28, 2020 at 05:06:31PM +0100, Krzysztof Mazur wrote:
> > When enabled, the MMX 3DNow! optimized memcpy() is used very early,
> > even before FPU is initialized. It worked fine, but commit
> > 7ad816762f9bf89e940e618ea40c43138b479e10 ("x86/fpu: Reset MXCSR
> > to default in kernel_fpu_begin()") broke that. After that commit
> > the kernel crashes just after "Booting the kernel." message.
> 
> Have you figured out in the meantime what exactly is causing the
> breakage?
> 
> Does it boot if you comment out
> 
> +       if (boot_cpu_has(X86_FEATURE_FPU))
> +               asm volatile ("fninit");
> 
> in kernel_fpu_begin()?
> 
> I'm guessing K7 doesn't have X86_FEATURE_XMM so the LDMXCSR won't
> matter...

K7 supports both XMM and FXSR:

flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 mmx fxsr sse syscall mmxext 3dnowext 3dnow cpuid 3dnowprefetch vmmcall

and the Linux 5.10 boots fine with:

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index eb86a2b831b1..08e5c5bea599 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -141,8 +141,10 @@ void kernel_fpu_begin(void)
 	}
 	__cpu_invalidate_fpregs_state();
 
+#if 0
 	if (boot_cpu_has(X86_FEATURE_XMM))
 		ldmxcsr(MXCSR_DEFAULT);
+#endif
 
 	if (boot_cpu_has(X86_FEATURE_FPU))
 		asm volatile ("fninit");


So, I'm guessing that the K7 does not like ldmxcsr(), when FXSR
or/and XMM are not enabled in CR4 (in fpu__init_cpu_generic()).
I verified that by adding kernel_fpu_begin()+kernel_fpu_end()
pair, before and after cr4_set_bits() in fpu__init_cpu_generic()
(on a kernel with disabled early MMX-optimized memcpy).

The kernel with kernel_fpu_begin() after cr4_set_bits():

diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
index 701f196d7c68..6d5db9107411 100644
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -25,6 +25,9 @@ static void fpu__init_cpu_generic(void)
 	if (cr4_mask)
 		cr4_set_bits(cr4_mask);
 
+	kernel_fpu_begin();
+	kernel_fpu_end();
+
 	cr0 = read_cr0();
 	cr0 &= ~(X86_CR0_TS|X86_CR0_EM); /* clear TS and EM */
 	if (!boot_cpu_has(X86_FEATURE_FPU))

boots fine, but the kernel with kernel_fpu_begin() before
cr4_set_bits():

diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
index 701f196d7c68..fcf3e6fbd3f8 100644
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -22,6 +22,9 @@ static void fpu__init_cpu_generic(void)
 		cr4_mask |= X86_CR4_OSFXSR;
 	if (boot_cpu_has(X86_FEATURE_XMM))
 		cr4_mask |= X86_CR4_OSXMMEXCPT;
+
+	kernel_fpu_begin();
+	kernel_fpu_end();
 	if (cr4_mask)
 		cr4_set_bits(cr4_mask);

crashes.


So the breakage is caused by using ldmxcsr(MXCSR_DEFAULT)
before X86_CR4_OSFXSR or/and X86_CR4_OSXMMEXCPT are set
in CR4.


So there are at least two alternative approaches (to disabling
MMX-optimized memcpy early):

	a) initialize FXSR/XMM bits in CR4 very early, before first memcpy()

	b) replacing boot_cpu_has(X86_FEATURE_XMM) in kernel_fpu_begin()
	   by something that is not enabled before CR4 is initialized.
	   This approach also comes with a runtime penalty, because
	   if kernel requires XMM, boot_cpu_has(X86_FEATURE_XMM) is
	   optimized out.

Best regards,
Krzysiek
