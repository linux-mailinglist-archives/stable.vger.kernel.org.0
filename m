Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE5913236
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 18:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbfECQbb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 3 May 2019 12:31:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726633AbfECQbb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 May 2019 12:31:31 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 322E620651;
        Fri,  3 May 2019 16:31:28 +0000 (UTC)
Date:   Fri, 3 May 2019 12:31:26 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Nicolai Stange <nstange@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Juergen Gross <jgross@suse.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nayna Jain <nayna@linux.ibm.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Joerg Roedel <jroedel@suse.de>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call
 functions
Message-ID: <20190503123126.3a2801be@gandalf.local.home>
In-Reply-To: <2045370D-38D8-406C-9E94-C1D483E232C9@amacapital.net>
References: <20190501203152.397154664@goodmis.org>
        <20190501232412.1196ef18@oasis.local.home>
        <20190502162133.GX2623@hirez.programming.kicks-ass.net>
        <CAHk-=wijZ-MD4g3zMJ9W2r=h8LUWneiu29OWuxZEoSfAF=0bhQ@mail.gmail.com>
        <20190502181811.GY2623@hirez.programming.kicks-ass.net>
        <CAHk-=wi6A9tgw=kkPh5Ywqt687VvsVEjYXVkAnq0jpt0u0tk6g@mail.gmail.com>
        <20190502202146.GZ2623@hirez.programming.kicks-ass.net>
        <20190502185225.0cdfc8bc@gandalf.local.home>
        <20190502193129.664c5b2e@gandalf.local.home>
        <20190502195052.0af473cf@gandalf.local.home>
        <20190503092959.GB2623@hirez.programming.kicks-ass.net>
        <20190503092247.20cc1ff0@gandalf.local.home>
        <2045370D-38D8-406C-9E94-C1D483E232C9@amacapital.net>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 3 May 2019 09:20:55 -0700
Andy Lutomirski <luto@amacapital.net> wrote:

> So here’s a somewhat nutty suggestion: how about we tweak the 32-bit entry code to emulate the sane 64-bit frame, not just for int3 but always?  Basically, the entry asm for entries from kernel mode would do, roughly:
> 
> push $0 ;dummy for call emulation
> push %ss
> push $0 ;a dummy for ESP
> push 3*4(%esp) ;EFLAGS
> push 3*4(%esp) ;CS
> push 3*4(%esp) ;EIP
> push %rax
> lea 7*4(%esp), %rax
> mov %rax, 4*4(%esp) ;ESP
> 
> And the exit asm would do a little dance to write EFLAGS, CS, and EIP to the right spot, then load ESP-3*4 into %esp and do IRET.
> 
> Now the annoying kernel_stack_pointer() hack can just go away, since regs->sp is always correct!
> 
> I probably screwed up some arithmetic there, but it’s the idea that counts :)

Yeah, as it will end up with:

 $0 ; dummy for call emulation
 %ss
 $0 ; dummy for ESP
 EIP
 $0
 %ss
 $0

As 3 only gets you over what you already pushed. I think 5*4 is what
you want.

I guess the real question is, what's the performance impact of doing
that? Although, this is only needed for kernel -> kernel exceptions,
which are hopefully a rarity.

-- Steve
