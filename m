Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31370133FE
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 21:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbfECTYK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 15:24:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:33752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbfECTYK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 May 2019 15:24:10 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC5E02075C;
        Fri,  3 May 2019 19:24:06 +0000 (UTC)
Date:   Fri, 3 May 2019 15:24:05 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Nicolai Stange <nstange@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
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
Message-ID: <20190503152405.2d741af8@gandalf.local.home>
In-Reply-To: <CAHk-=wh8bi5c_GkyjPtDAiaXaZRqtmhWs30usUvs4qK_F+c9tg@mail.gmail.com>
References: <20190501202830.347656894@goodmis.org>
        <20190501203152.397154664@goodmis.org>
        <20190501232412.1196ef18@oasis.local.home>
        <20190502162133.GX2623@hirez.programming.kicks-ass.net>
        <CAHk-=wijZ-MD4g3zMJ9W2r=h8LUWneiu29OWuxZEoSfAF=0bhQ@mail.gmail.com>
        <20190502181811.GY2623@hirez.programming.kicks-ass.net>
        <CAHk-=wi6A9tgw=kkPh5Ywqt687VvsVEjYXVkAnq0jpt0u0tk6g@mail.gmail.com>
        <20190502202146.GZ2623@hirez.programming.kicks-ass.net>
        <CAHk-=wh8bi5c_GkyjPtDAiaXaZRqtmhWs30usUvs4qK_F+c9tg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2 May 2019 13:49:29 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, May 2, 2019 at 1:22 PM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > Something like so; it boots; but I could've made some horrible mistake
> > (again).  
> 
> This actually looks much better to me.
> 
> Maybe it's more lines (I didn't check), but it's a lot simpler in that
> now the magic of the int3 stack doesn't get exposed to anything else.
> 
> We *could* also make this kernel-mode-only do_int3() be a special
> function, and do something like
> 
>         # args: pt_regs pointer (no error code for int3)
>         movl %esp,%eax
>         # allocate a bit of extra room on the stack, so that
> 'kernel_int3' can move the pt_regs
>         subl $8,%esp
>         call kernel_int3
>         movl %eax,%esp
> 
> and not do any stack switching magic in the asm code AT ALL. We'd do
> 
>     struct pt_regs *kernel_int3(struct pt_regs *regs)
>     {
>         ..
>         return regs;
>     }
> 
> and now you the rule for call emulation ends up being that you need to
> "memmove()" the ptregs up and down properly, and return the new
> pt_regs pointer.
> 
> Hmm? That would simplify the asm code further, but some people might
> find it objectionable?
> 

The problem with this approach is that it would require doing the same
for x86_64, as the int3 C code is the same for both. And that may be a
bit more difficult on the x86_64 side because it's all done with a
simple flag in the idtentry macro to add the gap.

-- Steve
