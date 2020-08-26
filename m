Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC11253483
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 18:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbgHZQOK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 12:14:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:44752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727099AbgHZQOF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 12:14:05 -0400
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13D4222B49
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 16:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598458444;
        bh=oKZFw6OKcCRaJR4UDthOfPIs8jXcSZfT0W9tTH84ZMU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=1lCAAob2AtBQ+GkYXC2zSZLe2Ta+bNQhiTBczPtVTrHqtM0sfM1EMwc4JPVmVqY4g
         yR9jjuBalhv5c+rvfluAyPkV4Kl4bUqgDaPQSTwuFc/jO7w2Igjwxw/aBzJKrhUOmF
         /abNVtgvy2wCV4V2kll0lR31mFW9eFX0amTa4KS0=
Received: by mail-lf1-f51.google.com with SMTP id k10so1298133lfm.5
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 09:14:04 -0700 (PDT)
X-Gm-Message-State: AOAM530FCjbaIlLu1mm6b7KVUQASgKfB4qJHVWtnr0sTPqy3Zv1sfTRB
        W4cxIVoUrohRRQO33ch98XXbV/C6pVDgYEQ0lsSiKg==
X-Google-Smtp-Source: ABdhPJwAbzxxlNHiuVxEKmNVT3p/k5xoMod3W+X/CpF95phFRbTBDJNyJX7NjguSFEFJNVQgYBihhImtDD3p/yTOrHE=
X-Received: by 2002:adf:f442:: with SMTP id f2mr5729898wrp.184.1598458441777;
 Wed, 26 Aug 2020 09:14:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200826115357.3049-1-graf@amazon.com> <87k0xlv5w5.fsf@nanos.tec.linutronix.de>
In-Reply-To: <87k0xlv5w5.fsf@nanos.tec.linutronix.de>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Wed, 26 Aug 2020 09:13:49 -0700
X-Gmail-Original-Message-ID: <CALCETrX-8a61k03+XJop=k11-TkE+7JOiGTH=81sHXPmXsA+Tw@mail.gmail.com>
Message-ID: <CALCETrX-8a61k03+XJop=k11-TkE+7JOiGTH=81sHXPmXsA+Tw@mail.gmail.com>
Subject: Re: [PATCH] x86/irq: Preserve vector in orig_ax for APIC code
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Alexander Graf <graf@amazon.com>, X86 ML <x86@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Will Deacon <will@kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Wei Liu <wei.liu@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Jason Chen CJ <jason.cj.chen@intel.com>,
        Zhao Yakui <yakui.zhao@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Avi Kivity <avi@scylladb.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>, robketr@amazon.de,
        Amos Kong <amos@scylladb.com>, Brian Gerst <brgerst@gmail.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 26, 2020 at 7:27 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Wed, Aug 26 2020 at 13:53, Alexander Graf wrote:
> > Commit 633260fa143 ("x86/irq: Convey vector as argument and not in ptregs")
> > changed the handover logic of the vector identifier from ~vector in orig_ax
> > to purely register based. Unfortunately, this field has another consumer
> > in the APIC code which the commit did not touch. The net result was that
> > IRQ balancing did not work and instead resulted in interrupt storms, slowing
> > down the system.
>
> The net result is an observationof the symptom but that does not explain
> what the underlying technical issue is.
>
> > This patch restores the original semantics that orig_ax contains the vector.
> > When we receive an interrupt now, the actual vector number stays stored in
> > the orig_ax field which then gets consumed by the APIC code.
> >
> > To ensure that nobody else trips over this in the future, the patch also adds
> > comments at strategic places to warn anyone who would refactor the code that
> > there is another consumer of the field.
> >
> > With this patch in place, IRQ balancing works as expected and performance
> > levels are restored to previous levels.
>
> There's a lot of 'This patch and we' in that changelog. Care to grep
> for 'This patch' in Documentation/process/ ?
>
> > diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
> > index df8c017..22e829c 100644
> > --- a/arch/x86/entry/entry_32.S
> > +++ b/arch/x86/entry/entry_32.S
> > @@ -727,7 +727,7 @@ SYM_CODE_START_LOCAL(asm_\cfunc)
> >       ENCODE_FRAME_POINTER
> >       movl    %esp, %eax
> >       movl    PT_ORIG_EAX(%esp), %edx         /* get the vector from stack */
> > -     movl    $-1, PT_ORIG_EAX(%esp)          /* no syscall to restart */
> > +     /* keep vector on stack for APIC's irq_complete_move() */
>
> Yes that's fixing your observed wreckage, but it introduces a worse one.
>
> user space
>   -> interrupt
>        push vector into orig_ax (values are in the ranges of 0-127 and -128 - 255
>                                  except for the system vectors which do
>                                  not go through this code)
>       handle()
>       ...
>       exit_to_user_mode_loop()
>          arch_do_signal()
>             /* Did we come from a system call? */
>             if (syscall_get_nr(current, regs) >= 0) {
>
>                ---> BOOM for any vector 0-127 because syscall_get_nr()
>                          resolves to regs->orig_ax
>
> Going to be fun to debug.
>
> The below nasty hack cures it, but I hate it with a passion. I'll look
> deeper for a sane variant.
>

Fundamentally, the way we overload orig_ax is problematic.  I have a
half-written series to improve it, but my series is broken.  I think
it's fixable, though.

First is this patch to use some __csh bits to indicate the entry type.
As far as I know, this patch is correct:

https://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git/commit/?h=x86/entry&id=dfff54208072a27909ae97ebce644c251a233ff2

Then I wrote this incorrect patch:

https://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git/commit/?h=x86/entry&id=3a5087acb8a2cc1e88b1a55fa36c2f8bef370572

That one is wrong because the orig_ax wreckage seems to have leaked
into user ABI -- user programs think that orig_ax has certain
semantics on user-visible entries.

But I think that the problem in this thread could be fixed quite
nicely by the first patch, plus a new CS_ENTRY_IRQ and allocating
eight bits of __csh to store the vector.  Then we could read out the
vector.


--Andy
