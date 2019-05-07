Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA95A168E9
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 19:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfEGRQC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 13:16:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726225AbfEGRQC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 13:16:02 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96E9B2053B;
        Tue,  7 May 2019 17:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557249361;
        bh=1tjepSiisGYS9Zw/hu0W/Biyos5/k6p+iNt0W5aPIfw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tbmhMejcd6UkaxE2Uc/e+c1SOvBxCdyGipmE+RR6jxCNZznKgtg3N7SWrzmejNe2S
         bZMTe28ufQmpnn4bWqCa625z50NVnKbbuUw22wxAqslIUJirfKKoK8urWAI8RWYkkf
         IQDEJkiufK4HEkdxeCGE4UoiFnMz/ZaM9a7soISg=
Date:   Wed, 8 May 2019 02:15:51 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
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
Message-Id: <20190508021551.ca791c725cbddc2db541273f@kernel.org>
In-Reply-To: <20190507231340.92b1b0665d1110f90929d878@kernel.org>
References: <20190502181811.GY2623@hirez.programming.kicks-ass.net>
        <20190502195052.0af473cf@gandalf.local.home>
        <20190503092959.GB2623@hirez.programming.kicks-ass.net>
        <20190503092247.20cc1ff0@gandalf.local.home>
        <2045370D-38D8-406C-9E94-C1D483E232C9@amacapital.net>
        <CAHk-=wjrOLqBG1qe9C3T=fLN0m=78FgNOGOEL22gU=+Pw6Mu9Q@mail.gmail.com>
        <20190506081951.GJ2606@hirez.programming.kicks-ass.net>
        <20190506095631.6f71ad7c@gandalf.local.home>
        <CAHk-=wgw_Jmn1iJWanoSFb1QZn3mbTD_JEoMsWcWj5QPeyHZHA@mail.gmail.com>
        <20190506130643.62c35eeb@gandalf.local.home>
        <CAHk-=whesas+GDtHZks62wqXWXe4d_g3XJ359GX81qj=Fgs6qQ@mail.gmail.com>
        <20190506145745.17c59596@gandalf.local.home>
        <CAHk-=witfFBW2O5v6g--FmqnAFsMkKNLosTFfWyaoJ7euQF8kQ@mail.gmail.com>
        <20190506162915.380993f9@gandalf.local.home>
        <CAHk-=wi5KBWUOvM94aTOPnoJ5L_aQG=vgLQ4SxxZDeQD0pF2tQ@mail.gmail.com>
        <20190506174511.2f8b696b@gandalf.local.home>
        <20190507231340.92b1b0665d1110f90929d878@kernel.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 7 May 2019 23:13:40 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> On Mon, 6 May 2019 17:45:11 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > If we go with Peter's patch, I can make this code much more sane, and
> > not have to worry about having &regs->sp be at the top of the stack. I
> > could simply, just push everything in the order of pt_regs and call the
> > handler.
> 
> Hi Steve, I need to catch up with the origin of this series, but it seems
> also good to optprobe which is doing similar trick on pt_regs. If we can
> assume that int3 pt_regs can have a gap, optprobe can also make a gap, and
> it can be also used for storing destination address.

Sorry, I misunderstood. I see the issue ( https://lkml.org/lkml/2019/5/1/497 )
and solutions on the thread. If we really need to fix this trace-livepatch
combination issue, it may be good to backport to stable trees.
From this viewpoint, Linus's suggestion (no pt_reg changes on x86-32) seems
to have a point.

BTW, even though I think Peter's patch (unifying pt_regs behavior) will also
be good for us for more general reason (not only for fixing actual issue).

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
