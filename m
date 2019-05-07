Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D605157FE
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 05:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfEGDWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 23:22:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:54858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726512AbfEGDWD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 23:22:03 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1B47206BF;
        Tue,  7 May 2019 03:21:59 +0000 (UTC)
Date:   Mon, 6 May 2019 23:21:58 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
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
        <linux-kselftest@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call
 functions
Message-ID: <20190506232158.13c9123b@oasis.local.home>
In-Reply-To: <CAHk-=wh4FCNBLe8OyDZt2Tr+k9JhhTsg3H8R4b55peKcf0b6eQ@mail.gmail.com>
References: <20190502181811.GY2623@hirez.programming.kicks-ass.net>
        <20190506095631.6f71ad7c@gandalf.local.home>
        <CAHk-=wgw_Jmn1iJWanoSFb1QZn3mbTD_JEoMsWcWj5QPeyHZHA@mail.gmail.com>
        <20190506130643.62c35eeb@gandalf.local.home>
        <CAHk-=whesas+GDtHZks62wqXWXe4d_g3XJ359GX81qj=Fgs6qQ@mail.gmail.com>
        <20190506145745.17c59596@gandalf.local.home>
        <CAHk-=witfFBW2O5v6g--FmqnAFsMkKNLosTFfWyaoJ7euQF8kQ@mail.gmail.com>
        <20190506162915.380993f9@gandalf.local.home>
        <CAHk-=wi5KBWUOvM94aTOPnoJ5L_aQG=vgLQ4SxxZDeQD0pF2tQ@mail.gmail.com>
        <20190506174511.2f8b696b@gandalf.local.home>
        <CAHk-=wj3R_s0RTJOmTBNaUPhu4fz2shNBUr4M6Ej65UYSNCs-g@mail.gmail.com>
        <20190506210416.2489a659@oasis.local.home>
        <CAHk-=whZwqzbu-=1r_j_cXfd=ta1q7RFCuneqBZfQQhS_P-BmQ@mail.gmail.com>
        <20190506215353.14a8ef78@oasis.local.home>
        <CAHk-=wjLXmOn=Cp=uOfO4gE01eN_-UcOUyrMTTw5-f_OfPO48Q@mail.gmail.com>
        <20190506225819.11756974@oasis.local.home>
        <CAHk-=wh4FCNBLe8OyDZt2Tr+k9JhhTsg3H8R4b55peKcf0b6eQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 6 May 2019 20:05:24 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:


> It would emulate the call that has had its first byte overwritten by
> 'int3'. Without doing any lookups of what it was supposed to change
> the call to, because it simply depends on what the rewriting code is
> doing on another CPU (or on the same CPU - it wouldn't care).

OK, so this is just about what to have it call.

> 
> So no need to look up anything, not at int3 time, and not at return
> time. It would just emulate the instruction atomically, with no state,
> and no need to look up what the 'ip' instruction is at the time.
> 
> It could literally just use a single flag: "is ftrace updating call
> instructions". Add another flag for the "I'm nop'ing out call
> instructions" so that it knows to emulate a jump-over instead. That's
> it.

Well we have that, and we have to look up the record regardless to know
if this was a ftrace int3 or not (the ftrace_location(ip) does that).
And the record has a counter to # of attached callers. Zero being to
turn it into a nop.

Note, if we are going from nop to call or call to nop, it would need to
read the offset to see if it is a nop (don't want to call with the nop
offset)

> 
> Because all the actual *values* would be entirely be determined by the
> actual rewriting that is going on independently of the 'int3'
> exception.

But still, we need to emulate the call, which requires pushing the
return code back onto the stack. I believe that part is the part we are
struggling with.

-- Steve
