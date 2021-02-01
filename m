Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 437FC30B199
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 21:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbhBAUcf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 15:32:35 -0500
Received: from mail.skyhub.de ([5.9.137.197]:39726 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231603AbhBAUc3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Feb 2021 15:32:29 -0500
Received: from zn.tnic (p200300ec2f06fe00e55f3102cc5eb27e.dip0.t-ipconnect.de [IPv6:2003:ec:2f06:fe00:e55f:3102:cc5e:b27e])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BB27E1EC0323;
        Mon,  1 Feb 2021 21:31:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1612211507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TV9f+dpKWOVsk2LSoz04Z2RDuyCnkg95cSCDMqN5B9s=;
        b=bfGckd5M+f8QRAdD+DDtDRCQirda9nLvUBcAt5ZdCHXXCypTwGa8xrYXUbA7kjZ1if6Hzz
        cMq/UGC2eL/YcFvHWqJ/krVlNfc4KOJPQrm6+06nNdc+dn1z2XZP5tyYVKuvSLpkmkMMDI
        tz0OU4whXdfOwOjsNdnq5V0sncwJuQA=
Date:   Mon, 1 Feb 2021 21:31:46 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        Masami Hiramatsu <mhiramat@kernel.org>, stable@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/11] x86/fault: Fix AMD erratum #91 errata fixup for
 user code
Message-ID: <20210201203146.GC14590@zn.tnic>
References: <cover.1612113550.git.luto@kernel.org>
 <7aaa6ff8d29faea5a9324a85e5ad6c41c654e9e0.1612113550.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7aaa6ff8d29faea5a9324a85e5ad6c41c654e9e0.1612113550.git.luto@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 31, 2021 at 09:24:32AM -0800, Andy Lutomirski wrote:
> The recent rework of probe_kernel_read() and its conversion to

Judging by

  25f12ae45fc1 ("maccess: rename probe_kernel_address to get_kernel_nofault")

I think you mean probe_kernel_address() above and below.

> get_kernel_nofault() inadvertently broke is_prefetch().  We were using

Let's drop the "we" pls and switch to passive voice.

> probe_kernel_read() as a sloppy "read user or kernel memory" helper, but it
> doens't do that any more.  The new get_kernel_nofault() reads *kernel*
> memory only, which completely broke is_prefetch() for user access.
> 
> Adjust the code to the the correct accessor based on access mode.  The

s/the //

> manual address bounds check is no longer necessary, since the accessor
> helpers (get_user() / get_kernel_nofault()) do the right thing all by
> themselves.  As a bonus, by using the correct accessor, we don't need the
> open-coded address bounds check.
> 
> While we're at it, disable the workaround on all CPUs except AMD Family
> 0xF.  By my reading of the Revision Guide for AMD Athlon™ 64 and AMD
> Opteron™ Processors, only family 0xF is affected.

Yah, actually, only !NPT K8s have the erratum listed, i.e., CPU models <
0x40, AFAICT.

I.e., your test should be:

	struct cpuinfo_x86 *c = &boot_cpu_data;

	...

	/* Erratum #91 on AMD K8, pre-NPT CPUs */
        if (likely(c->x86_vendor != X86_VENDOR_AMD ||
		   c->x86 != 0xf ||
		   c->x86_model >= 0x40))
		return 0;

I can try to dig out such a machine to test this on if you wanna. We
might still have one collecting dust somewhere in a corner...

> Fixes: eab0c6089b68 ("maccess: unify the probe kernel arch hooks")
> Cc: stable@vger.kernel.org

@stable because theoretically without that fix, kernel should explode on
those machines when it #PFs on a prefetch insn in user mode?

Hmm, yap, probably...

> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> ---
>  arch/x86/mm/fault.c | 31 +++++++++++++++++++++----------
>  1 file changed, 21 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 106b22d1d189..50dfdc71761e 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -54,7 +54,7 @@ kmmio_fault(struct pt_regs *regs, unsigned long addr)
>   * 32-bit mode:
>   *
>   *   Sometimes AMD Athlon/Opteron CPUs report invalid exceptions on prefetch.
> - *   Check that here and ignore it.
> + *   Check that here and ignore it.  This is AMD erratum #91.
>   *
>   * 64-bit mode:
>   *
> @@ -83,11 +83,7 @@ check_prefetch_opcode(struct pt_regs *regs, unsigned char *instr,
>  #ifdef CONFIG_X86_64
>  	case 0x40:
>  		/*
> -		 * In AMD64 long mode 0x40..0x4F are valid REX prefixes
> -		 * Need to figure out under what instruction mode the
> -		 * instruction was issued. Could check the LDT for lm,
> -		 * but for now it's good enough to assume that long
> -		 * mode only uses well known segments or kernel.
> +		 * In 64-bit mode 0x40..0x4F are valid REX prefixes
>  		 */
>  		return (!user_mode(regs) || user_64bit_mode(regs));
>  #endif

Yah, no need to convert that to the insn decoder - that can die together
with the hardware it is supposed to query...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
