Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18AF31DEAC
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 19:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbhBQSA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 13:00:26 -0500
Received: from mail.skyhub.de ([5.9.137.197]:38786 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231856AbhBQSAZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Feb 2021 13:00:25 -0500
Received: from zn.tnic (p200300ec2f05bb00a5a1b5cb6f03bfce.dip0.t-ipconnect.de [IPv6:2003:ec:2f05:bb00:a5a1:b5cb:6f03:bfce])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id ED4941EC0402;
        Wed, 17 Feb 2021 18:59:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1613584784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=WmuQ8y/fflrvmjf86SX6xiFBOAxGxvoIY9jzq881ltE=;
        b=VtuqqWV9FksO9bvGEz8s/uGpYsmQhciTMb5Bf5x7ZRbliGBwcMAr4OEUnISJXR69BwU8JS
        gfteNUD430fYDD5Kj6HzYtes586+ku381MB0OWQ2UpD4sqHIPXR8P3HfmMaEIRoEW+MeMV
        +StFS37yM89lDHr/vpDza8tR87BZG+M=
Date:   Wed, 17 Feb 2021 18:59:39 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>,
        stable@vger.kernel.org, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 1/3] x86/sev-es: Introduce from_syscall_gap() helper
Message-ID: <20210217175939.GA6479@zn.tnic>
References: <20210217120143.6106-1-joro@8bytes.org>
 <20210217120143.6106-2-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210217120143.6106-2-joro@8bytes.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I guess subject prefix should be "x86/traps:" but I'll fix that up while
applying eventually.

On Wed, Feb 17, 2021 at 01:01:41PM +0100, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Introduce a helper to check whether an exception came from the syscall
> gap and use it in the SEV-ES code
> 
> Fixes: 315562c9af3d5 ("x86/sev-es: Adjust #VC IST Stack on entering NMI handler")
> Cc: stable@vger.kernel.org # 5.10+
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/include/asm/ptrace.h | 8 ++++++++
>  arch/x86/kernel/traps.c       | 3 +--
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
> index d8324a236696..14854b2c4944 100644
> --- a/arch/x86/include/asm/ptrace.h
> +++ b/arch/x86/include/asm/ptrace.h
> @@ -94,6 +94,8 @@ struct pt_regs {
>  #include <asm/paravirt_types.h>
>  #endif
>  
> +#include <asm/proto.h>
> +
>  struct cpuinfo_x86;
>  struct task_struct;
>  
> @@ -175,6 +177,12 @@ static inline bool any_64bit_mode(struct pt_regs *regs)
>  #ifdef CONFIG_X86_64
>  #define current_user_stack_pointer()	current_pt_regs()->sp
>  #define compat_user_stack_pointer()	current_pt_regs()->sp
> +
> +static inline bool from_syscall_gap(struct pt_regs *regs)

rip_within_syscall_gap() sounds kinda better to me and it is more
readable when you look at it at the usage site:

	if (rip_within_syscall_gap(regs))
		...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
