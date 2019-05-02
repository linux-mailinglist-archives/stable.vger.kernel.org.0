Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E85B01251E
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 01:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfEBXbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 19:31:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:33954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726022AbfEBXbe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 19:31:34 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41B9A206DF;
        Thu,  2 May 2019 23:31:31 +0000 (UTC)
Date:   Thu, 2 May 2019 19:31:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <20190502193129.664c5b2e@gandalf.local.home>
In-Reply-To: <20190502185225.0cdfc8bc@gandalf.local.home>
References: <20190501202830.347656894@goodmis.org>
        <20190501203152.397154664@goodmis.org>
        <20190501232412.1196ef18@oasis.local.home>
        <20190502162133.GX2623@hirez.programming.kicks-ass.net>
        <CAHk-=wijZ-MD4g3zMJ9W2r=h8LUWneiu29OWuxZEoSfAF=0bhQ@mail.gmail.com>
        <20190502181811.GY2623@hirez.programming.kicks-ass.net>
        <CAHk-=wi6A9tgw=kkPh5Ywqt687VvsVEjYXVkAnq0jpt0u0tk6g@mail.gmail.com>
        <20190502202146.GZ2623@hirez.programming.kicks-ass.net>
        <20190502185225.0cdfc8bc@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2 May 2019 18:52:25 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 2 May 2019 22:21:46 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Thu, May 02, 2019 at 11:43:37AM -0700, Linus Torvalds wrote:  
> > > What would it look like with the "int3-from-kernel is special" modification?    
> > 
> > Something like so; it boots; but I could've made some horrible mistake
> > (again).
> > 
> > ---
> > diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
> > index 7b23431be5cb..4de51cff5b8a 100644
> > --- a/arch/x86/entry/entry_32.S
> > +++ b/arch/x86/entry/entry_32.S  
> 
> Oh, and so close!
> 
> I was running this on my i386 tests and for test 8 of 9 (passed 1-7) I
> hit this:

Digging a little further, I pinpointed it out to being kretprobes. The
problem I believe is the use of kernel_stack_pointer() which does some
magic on x86_32. kretprobes uses this to hijack the return address of
the function (much like the function graph tracer does). I do have code
that would allow kretprobes to use the function graph tracer instead,
but that's still in progress (almost done!). But still, we should not
have this break the use of kernel_stack_pointer() either.

Adding some printks in that code, it looks to be returning "&regs->sp"
which I think we changed.

-- Steve
