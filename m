Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B54131EDF8
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 19:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbhBRSFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 13:05:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:50564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232283AbhBRRuA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Feb 2021 12:50:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 738ED64EB7
        for <stable@vger.kernel.org>; Thu, 18 Feb 2021 17:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613670559;
        bh=S9HE1UIVHUZqDSOtYFkGj6UL4dBAx+REIzCSaf9/6jc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=d/Bc2C8KUym4ZU7TWGQ7q54Ca0hDxEIeGDqRB2j4VtfqaYPh+Gxl+Dv/ISjm+NaoR
         RrlYDDmrRBkdwoDJQaOG+xCV5f6aRjAmrw7GU3CjgiH6ZQJ8mj3X9sTTedGJLkFLL1
         /kmwS1lyIdWFTUZm3ma7wES/0djtI6ykZYqMtYtYnysEcDTIJAHxRvPz6D8E9nrHlh
         KStoTs/B/QhfuR69Nj74VAzGwz3YdnKrpK6+WiQOw4MJaM5re2UyhF15uXSf993ZSl
         Sk4SD2Xh3Y7V9qCw+xaDHayu0zP615JdvXUOu6qyACP9IoEiSvXTipHT6tEE6XZhWh
         aH3LRk3he0ZgQ==
Received: by mail-ej1-f44.google.com with SMTP id n13so6960384ejx.12
        for <stable@vger.kernel.org>; Thu, 18 Feb 2021 09:49:19 -0800 (PST)
X-Gm-Message-State: AOAM531ff0uhdGdMTNegfolD8RwYz941G29f63cyuBJ7AD44ZiP7HHeG
        nHZp+rLzh8xERdO0c9N27vE3N+7HuD4VsxFhKX2oQA==
X-Google-Smtp-Source: ABdhPJwj3aEDXoeyomFpvPGRsKjYAWGF9foiPbsnT1S5rrYJDU4WAyOZvJVqaV0lfVp5BLdNddsftppBTtCUMQqxZB4=
X-Received: by 2002:a17:906:d10d:: with SMTP id b13mr4988544ejz.204.1613670557791;
 Thu, 18 Feb 2021 09:49:17 -0800 (PST)
MIME-Version: 1.0
References: <20210217120143.6106-1-joro@8bytes.org> <20210217120143.6106-3-joro@8bytes.org>
 <CALCETrWw-we3O4_upDoXJ4NzZHsBqNO69ht6nBp3y+QFhwPgKw@mail.gmail.com> <20210218112500.GH7302@8bytes.org>
In-Reply-To: <20210218112500.GH7302@8bytes.org>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 18 Feb 2021 09:49:06 -0800
X-Gmail-Original-Message-ID: <CALCETrUohqQPVTBJZZKh-pj=4aZrwDAu5UFSetj3k5pGLDPbkA@mail.gmail.com>
Message-ID: <CALCETrUohqQPVTBJZZKh-pj=4aZrwDAu5UFSetj3k5pGLDPbkA@mail.gmail.com>
Subject: Re: [PATCH 2/3] x86/sev-es: Check if regs->sp is trusted before
 adjusting #VC IST stack
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
        Joerg Roedel <jroedel@suse.de>,
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

On Thu, Feb 18, 2021 at 3:25 AM Joerg Roedel <joro@8bytes.org> wrote:
>
> Hi Andy,
>
> On Wed, Feb 17, 2021 at 10:09:46AM -0800, Andy Lutomirski wrote:
> > Can you get rid of the linked list hack while you're at it?  This code
> > is unnecessarily convoluted right now, and it seems to be just asking
> > for weird bugs.  Just stash the old value in a local variable, please.
>
> Yeah, the linked list is not really necessary right now, because of the
> way nested NMI handling works and given that these functions are only
> used in the NMI handler right now.
> The whole #VC handling code was written with future requirements in
> mind, like what is needed when debugging registers get virtualized and
> #HV gets enabled.
> Until its clear whether __sev_es_ist_enter/exit() is needed in any of
> these paths, I'd like to keep the linked list for now. It is more
> complicated but allows nesting.

I don't understand what this means.  The whole entry mechanism on x86
is structured so that we call a C function *and return from that C
function without longjmp-like magic* with the sole exception of
unwind_stack_do_exit().  This means that you can match up enters and
exits, and that unwind_stack_do_exit() needs to unwind correctly.  In
the former case, it's normal C and we can use normal local variables.
In the latter case, we know exactly what state we're trying to restore
and we can restore it directly without any linked lists or similar.

What do you have in mind that requires a linked list?

>
> > Meanwhile, I'm pretty sure I can break this whole scheme if the
> > hypervisor is messing with us.  As a trivial example, the sequence
> > SYSCALL gap -> #VC -> NMI -> #VC will go quite poorly.
>
> I don't see how this would break, can you elaborate?
>
> What I think happens is:
>
> SYSCALL gap (RSP is from userspace and untrusted)
>
>         -> #VC - Handler on #VC IST stack detects that it interrupted
>            the SYSCALL gap and switches to the task stack.
>

Can you point me to exactly what code you're referring to?  I spent a
while digging through the code and macro tangle and I can't find this.

>
>         -> NMI - Now running on NMI IST stack. Depending on whether the
>            stack switch in the #VC handler already happened, the #VC IST
>            entry is adjusted so that a subsequent #VC will not overwrite
>            the interrupted handlers stack frame.
>
>         -> #VC - Handler runs on the adjusted #VC IST stack and switches
>            itself back to the NMI IST stack. This is safe wrt. nested
>            NMIs as long as nested NMIs itself are safe.
>
> As a rule of thumb, think of the #VC handler as trying to be a non-IST
> handler by switching itself to the interrupted stack or the task stack.
> If it detects that this is not possible (which can't happen right now,
> but with SNP), it will kill the guest.

I will try to think of this, but it's hard, since I can't find the code :)

I found this comment:

 * With the current implementation it is always possible to switch to a safe
 * stack because #VC exceptions only happen at known places, like intercepted
 * instructions or accesses to MMIO areas/IO ports. They can also happen with
 * code instrumentation when the hypervisor intercepts #DB, but the critical
 * paths are forbidden to be instrumented, so #DB exceptions currently also
 * only happen in safe places.

Unless AMD is more magic than I realize, the MOV SS bug^Wfeature means
that #DB is *not* always called in safe places.

But I *thnk* the code you're talking about is this:

    /*
     * If the entry is from userspace, switch stacks and treat it as
     * a normal entry.
     */
    testb    $3, CS-ORIG_RAX(%rsp)
    jnz    .Lfrom_usermode_switch_stack_\@

which does not run on #VC from kernel code.

> It needs to be IST, even without SNP, because #DB is IST too. When the
> hypervisor intercepts #DB then any #DB exception will be turned into
> #VC, so #VC needs to be handled anywhere a #DB can happen.

Eww.

>
> And with SNP we need to be able to at least detect a malicious HV so we
> can reliably kill the guest. Otherwise the HV could potentially take
> control over the guest's execution flow and make it reveal its secrets.

True.  But is the rest of the machinery to be secure against EFLAGS.IF
violations and such in place yet?

>
> Regards,
>
>         Joerg
