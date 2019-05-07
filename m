Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E617B163B9
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 14:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfEGM1V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 08:27:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbfEGM1V (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 08:27:21 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E807520825;
        Tue,  7 May 2019 12:27:17 +0000 (UTC)
Date:   Tue, 7 May 2019 08:27:16 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
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
Message-ID: <20190507082716.73cd5a01@gandalf.local.home>
In-Reply-To: <20190507092731.GH2650@hirez.programming.kicks-ass.net>
References: <20190502202146.GZ2623@hirez.programming.kicks-ass.net>
        <20190502185225.0cdfc8bc@gandalf.local.home>
        <20190502193129.664c5b2e@gandalf.local.home>
        <20190502195052.0af473cf@gandalf.local.home>
        <20190503092959.GB2623@hirez.programming.kicks-ass.net>
        <20190503092247.20cc1ff0@gandalf.local.home>
        <2045370D-38D8-406C-9E94-C1D483E232C9@amacapital.net>
        <CAHk-=wjrOLqBG1qe9C3T=fLN0m=78FgNOGOEL22gU=+Pw6Mu9Q@mail.gmail.com>
        <20190506081951.GJ2606@hirez.programming.kicks-ass.net>
        <20190507085753.GO2606@hirez.programming.kicks-ass.net>
        <20190507092731.GH2650@hirez.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 7 May 2019 11:27:31 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> FWIW, both these trampolines assume a kprobe will not
> int3_emulate_{push/call}(), for both bitnesses.
> 
> But then; I'm thinking kprobes should be inspection only and not modify
> things. So that might just be good enough.

I believe there are kprobe calls that do modify things. Note, they can
modify regs->ip. Kprobes sets the FTRACE_OPS_FL_IPMODIFY flag, thus
they can never be put at the same location that is being live patched.

-- Steve
