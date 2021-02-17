Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6448A31DEDC
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 19:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232887AbhBQSKn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 13:10:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:44750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232159AbhBQSKl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Feb 2021 13:10:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3F4564EAE
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 18:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613585401;
        bh=L1OIdISDMiKRSiSWhaILOTGeRPn9DN0OB9U34bRhQek=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=tmjHATDWxlVbs//lCjmhXz0QNI7+Gw1Xbz5+af5khjJyi1muOTUw92d/TN1UtGt2+
         1Z/+ybuCpbO2EuU6sV6G2o8r0rOKaIMJnntjfXGRivIE+IA4mvYi4YbzoyMI7hDer/
         W+sMpeU/DLDaMfSZAZqoR6H7pmny3c26/AsJDPnaPUqaignJNnOMxixNqBG5+/ifts
         CzF4JzxfYfG65uKYzuVz7Hvgsk6W8mumOCseKs0S+r2vq7S9vppmiuoK4a5bGMEgTe
         g0nDVaEOni97kwzYuN4Nci8afgF/Ru1s3VKUKUEVwa0DQWACmxa4F/Mwiofk9/5hLe
         afBfHjtP+JZig==
Received: by mail-ej1-f45.google.com with SMTP id b14so17877948eju.7
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 10:10:00 -0800 (PST)
X-Gm-Message-State: AOAM532EgJEQUjowkSAs7qb2qyOny8C1DMfjH8oHU7KX5CYhzVNDfrel
        iK8HNCsk0o2EB5K1wnnwy+QdojktzOsNStH+wyIJXg==
X-Google-Smtp-Source: ABdhPJzwArcpxgytNfc42oZjlVBrqCPpsnJwfz+6zR5LkK02Ldu1E4mXTepd7vnfdobtpuRYckLoG8BqletPssvhb9Y=
X-Received: by 2002:a17:906:b356:: with SMTP id cd22mr175224ejb.253.1613585399128;
 Wed, 17 Feb 2021 10:09:59 -0800 (PST)
MIME-Version: 1.0
References: <20210217120143.6106-1-joro@8bytes.org> <20210217120143.6106-3-joro@8bytes.org>
In-Reply-To: <20210217120143.6106-3-joro@8bytes.org>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Wed, 17 Feb 2021 10:09:46 -0800
X-Gmail-Original-Message-ID: <CALCETrWw-we3O4_upDoXJ4NzZHsBqNO69ht6nBp3y+QFhwPgKw@mail.gmail.com>
Message-ID: <CALCETrWw-we3O4_upDoXJ4NzZHsBqNO69ht6nBp3y+QFhwPgKw@mail.gmail.com>
Subject: Re: [PATCH 2/3] x86/sev-es: Check if regs->sp is trusted before
 adjusting #VC IST stack
To:     Joerg Roedel <joro@8bytes.org>
Cc:     X86 ML <x86@kernel.org>, Joerg Roedel <jroedel@suse.de>,
        Andy Lutomirski <luto@kernel.org>,
        stable <stable@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
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
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 17, 2021 at 4:02 AM Joerg Roedel <joro@8bytes.org> wrote:
>
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
>         old_ist = __this_cpu_read(cpu_tss_rw.x86_tss.ist[IST_INDEX_VC]);
>
>         /* Make room on the IST stack */
> -       if (on_vc_stack(regs->sp))
> +       if (on_vc_stack(regs->sp) &&
> +           !user_mode(regs) &&
> +           !from_syscall_gap(regs))
>                 new_ist = ALIGN_DOWN(regs->sp, 8) - sizeof(old_ist);
>         else
>

Can you get rid of the linked list hack while you're at it?  This code
is unnecessarily convoluted right now, and it seems to be just asking
for weird bugs.  Just stash the old value in a local variable, please.

Meanwhile, I'm pretty sure I can break this whole scheme if the
hypervisor is messing with us.  As a trivial example, the sequence
SYSCALL gap -> #VC -> NMI -> #VC will go quite poorly.  Is this really
better than just turning IST off for #VC and documenting that we are
not secure against a malicious hypervisor yet?

--Andy
