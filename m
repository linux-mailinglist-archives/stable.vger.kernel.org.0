Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18E2031DEB5
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 19:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233054AbhBQSAu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 13:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234667AbhBQSAs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 13:00:48 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943A5C061574;
        Wed, 17 Feb 2021 10:00:08 -0800 (PST)
Received: from zn.tnic (p200300ec2f05bb00a5a1b5cb6f03bfce.dip0.t-ipconnect.de [IPv6:2003:ec:2f05:bb00:a5a1:b5cb:6f03:bfce])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 37E1F1EC0531;
        Wed, 17 Feb 2021 19:00:06 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1613584806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=W/PjtAFD7kN1k373OiTnMpXJo6wSfCFewIb7shmRoAo=;
        b=eWIvMjcR2w2Szi9tvlUj/PBm2DwWXFJEV6+2klCghZf1r9mpzHJQsSclQG/T7mwfY0uiQo
        rMtKbbqzVOerG0czLj1WllEinByD4lSHtLn93sBH0+1z7g/qOd18ASqqXmXgniWL7fCCaj
        U249HiTnjWRQTmgbdVAvXjFEVHgaw54=
Date:   Wed, 17 Feb 2021 19:00:09 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org,
        hpa@zytor.com, Dave Hansen <dave.hansen@linux.intel.com>,
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
Subject: Re: [PATCH 2/3] x86/sev-es: Check if regs->sp is trusted before
 adjusting #VC IST stack
Message-ID: <20210217180009.GB6479@zn.tnic>
References: <20210217120143.6106-1-joro@8bytes.org>
 <20210217120143.6106-3-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210217120143.6106-3-joro@8bytes.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 17, 2021 at 01:01:42PM +0100, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> The code in the NMI handler to adjust the #VC handler IST stack is
> needed in case an NMI hits when the #VC handler is still using its IST
> stack.
> But the check for this condition also needs to look if the regs->sp
> value is trusted, meaning it was not set by user-space. Extend the
> check to not use regs->sp when the NMI interrupted user-space code or
> the SYSCALL gap.
> 
> Reported-by: Andy Lutomirski <luto@kernel.org>
> Fixes: 315562c9af3d5 ("x86/sev-es: Adjust #VC IST Stack on entering NMI handler")
> Cc: stable@vger.kernel.org # 5.10+
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/kernel/sev-es.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
> index 84c1821819af..0df38b185d53 100644
> --- a/arch/x86/kernel/sev-es.c
> +++ b/arch/x86/kernel/sev-es.c
> @@ -144,7 +144,9 @@ void noinstr __sev_es_ist_enter(struct pt_regs *regs)
>  	old_ist = __this_cpu_read(cpu_tss_rw.x86_tss.ist[IST_INDEX_VC]);
>  
>  	/* Make room on the IST stack */
> -	if (on_vc_stack(regs->sp))
> +	if (on_vc_stack(regs->sp) &&
> +	    !user_mode(regs) &&
> +	    !from_syscall_gap(regs))

Why not add those checks to on_vc_stack() directly? Because in it, you
can say:

on_vc_stack():

	/* user mode rSP is not trusted */
	if (user_mode())
		return false;

	/* ditto */
	if (ip_within_syscall_gap())
		return false;

	...

?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
