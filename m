Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1523931F049
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 20:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbhBRTpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 14:45:18 -0500
Received: from mx2.suse.de ([195.135.220.15]:48290 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230169AbhBRTWB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Feb 2021 14:22:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AC386AED2;
        Thu, 18 Feb 2021 19:21:19 +0000 (UTC)
Date:   Thu, 18 Feb 2021 20:21:17 +0100
From:   Joerg Roedel <jroedel@suse.de>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Joerg Roedel <joro@8bytes.org>, X86 ML <x86@kernel.org>,
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
Subject: Re: [PATCH 2/3] x86/sev-es: Check if regs->sp is trusted before
 adjusting #VC IST stack
Message-ID: <20210218192117.GL12716@suse.de>
References: <20210217120143.6106-1-joro@8bytes.org>
 <20210217120143.6106-3-joro@8bytes.org>
 <CALCETrWw-we3O4_upDoXJ4NzZHsBqNO69ht6nBp3y+QFhwPgKw@mail.gmail.com>
 <20210218112500.GH7302@8bytes.org>
 <CALCETrUohqQPVTBJZZKh-pj=4aZrwDAu5UFSetj3k5pGLDPbkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUohqQPVTBJZZKh-pj=4aZrwDAu5UFSetj3k5pGLDPbkA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 18, 2021 at 09:49:06AM -0800, Andy Lutomirski wrote:
> I don't understand what this means.  The whole entry mechanism on x86
> is structured so that we call a C function *and return from that C
> function without longjmp-like magic* with the sole exception of
> unwind_stack_do_exit().  This means that you can match up enters and
> exits, and that unwind_stack_do_exit() needs to unwind correctly.  In
> the former case, it's normal C and we can use normal local variables.
> In the latter case, we know exactly what state we're trying to restore
> and we can restore it directly without any linked lists or similar.

Okay, the unwinder will likely get confused by this logic.

> What do you have in mind that requires a linked list?

Cases when there are multiple IST vectors besides NMI that can hit while
the #VC handler is still on its own IST stack. #MCE comes to mind, but
that is broken anyway. At some point #VC itself will be one of them, but
when that happens the code will kill the machine.
This leaves #HV in the list, and I am not sure how that is going to be
handled yet. I think the goal is that the #HV handler is not allowed to
cause any #VC exception. In that case the linked-list logic will not be
needed.

> > I don't see how this would break, can you elaborate?
> >
> > What I think happens is:
> >
> > SYSCALL gap (RSP is from userspace and untrusted)
> >
> >         -> #VC - Handler on #VC IST stack detects that it interrupted
> >            the SYSCALL gap and switches to the task stack.
> >
> 
> Can you point me to exactly what code you're referring to?  I spent a
> while digging through the code and macro tangle and I can't find this.

See the entry code in arch/x86/entry/entry_64.S, macro idtentry_vc. It
creates the assembly code for the handler. At some point it calls
vc_switch_off_ist(), which is a C function in arch/x86/kernel/traps.c.
This function tries to find a new stack for the #VC handler.

The first thing it does is checking whether the exception came from the
SYSCALL gap and just uses the task stack in that case.

Then it will check for other kernel stacks which are safe to switch
to. If that fails it uses the fall-back stack (VC2), which will direct
the handler to a separate function which, for now, just calls panic().
Not safe are the entry or unknown stacks.

The function then copies pt_regs and returns the new stack pointer to
assembly code, which then writes it to %RSP.

> Unless AMD is more magic than I realize, the MOV SS bug^Wfeature means
> that #DB is *not* always called in safe places.

You are right, forgot about this. The MOV SS bug can very well
trigger a #VC(#DB) exception from the syscall gap.

> > And with SNP we need to be able to at least detect a malicious HV so we
> > can reliably kill the guest. Otherwise the HV could potentially take
> > control over the guest's execution flow and make it reveal its secrets.
> 
> True.  But is the rest of the machinery to be secure against EFLAGS.IF
> violations and such in place yet?

Not sure what you mean by EFLAGS.IF violations, probably enabling IRQs
while in the #VC handler? The #VC handler _must_ _not_ enable IRQs
anywhere in its call-path. If that ever happens it is a bug.

Regards,

	Joerg
