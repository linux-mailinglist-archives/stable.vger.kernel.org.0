Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB785121CF
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 20:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbfEBSS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 14:18:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58240 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbfEBSS4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 14:18:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=OUOTgiwlJlyZHx9KJsKpSdKtPOxMeVL7eOFNyapCTik=; b=WsqGR+fQ18Y7cQXaFj2PBR02v
        siV99KT4OxQS33ZTF4/KhMGLopbfOEy4qIqFqmlrCQKyXadrdliOch0gxjFo36IcvxUXyp4/I+8E0
        Bt+/C9Rws0ye6wGr+2M0kEBR/Fh56+eO0qLl4vjM33C1+haONnTBfkkDrJtQ/yatcor+M7a489jC6
        t1+StvXmvEK1c5zs4lIYiuKDgzytIXU9N5gBwohiHgGN0jzWcHUw2NFJ3Ix+sztlRL2UliPb7OTBa
        0GHQP6eKghAhHNeaNvLCIChZ/r7egen0P+JCVAhtErt1P2lUDj4lDnxBjI65lESFDfb46oB+TcWnv
        CNRUWs51Q==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hMGHf-0002Df-16; Thu, 02 May 2019 18:18:15 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D1CE12066BB8E; Thu,  2 May 2019 20:18:11 +0200 (CEST)
Date:   Thu, 2 May 2019 20:18:11 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
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
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call functions
Message-ID: <20190502181811.GY2623@hirez.programming.kicks-ass.net>
References: <20190501202830.347656894@goodmis.org>
 <20190501203152.397154664@goodmis.org>
 <20190501232412.1196ef18@oasis.local.home>
 <20190502162133.GX2623@hirez.programming.kicks-ass.net>
 <CAHk-=wijZ-MD4g3zMJ9W2r=h8LUWneiu29OWuxZEoSfAF=0bhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wijZ-MD4g3zMJ9W2r=h8LUWneiu29OWuxZEoSfAF=0bhQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 02, 2019 at 11:02:40AM -0700, Linus Torvalds wrote:
> On Thu, May 2, 2019 at 9:21 AM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > TL;DR, on x86_32 kernel->kernel IRET frames are only 3 entries and do
> > not include ESP/SS, so not only wasn't regs->sp setup, if you changed it
> > it wouldn't be effective and corrupt random stack state.
> 
> Indeed, the 32-bit case for same-RPL exceptions/iret is entirely
> different, and I'd forgotten about that.
> 
> And honestly, this makes the 32-bit case much worse. Now the entry
> stack modifications of int3 suddenly affect not just the entry, but
> every exit too.

We could fix this by not using the common exit path on int3; not sure we
want to go there, but that is an option.

> This is _exactly_ the kind of subtle kernel entry/exit code I wanted
> us to avoid.
> 
> And while your code looks kind of ok, it's subtly buggy. This sequence:
> 
> +       pushl   %eax
> +       movl    %esp, %eax
> +
> +       movl    4*4(%eax), %esp         # restore (modified) regs->sp
> +
> +       /* rebuild IRET frame */
> +       pushl   3*4(%eax)               # flags
> +       pushl   2*4(%eax)               # cs
> +       pushl   1*4(%eax)               # ip
> +
> +       andl    $0x0000ffff, 4(%esp)    # clear high CS bits
> +
> +       movl    (%eax), %eax            # restore eax
> 
> looks very wrong to me. When you do that "restore (modified)
> regs->sp", isn't that now resetting %esp to the point where %eax now
> points below the stack? So if we get an NMI in this sequence, that
> will overwrite the parts you are trying to copy from?

ARGH; I knew it was too pretty :/ Yes, something like what you suggest
will be needed, I'll go look at that once my brain recovers a bit from
staring at entry code all day.
