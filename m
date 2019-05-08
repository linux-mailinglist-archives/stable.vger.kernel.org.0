Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70AA11701D
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 06:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbfEHEac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 00:30:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:44768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725825AbfEHEac (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 May 2019 00:30:32 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A07821019;
        Wed,  8 May 2019 04:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557289830;
        bh=sgs6ytJVn9qBYplg2hYQ+XOt9DqBHh15P7mn2I3W6ac=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NgH+vDrx//pebh1V6TMfYZeViVKqiJape+anma/JjnKItD3ZSXojjOoOUuYTSWKXR
         +8zmAaoHcuu3391UqImrgZa8fESLt7q9yqhxXynu0zzuHRkOB41yUFB51EHNx7elpS
         gI4w6Ui5tWAQey2rt3dz7TYq23OAaY8TXwAvkXxI=
Date:   Wed, 8 May 2019 13:30:22 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
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
Subject: Re: [PATCH 0/3] x86_64/ftrace: Emulate calls from int3 when
 patching functions
Message-Id: <20190508133022.78cd9c9b8fcb7838fc0280d0@kernel.org>
In-Reply-To: <20190508015559.767152678@goodmis.org>
References: <20190508015559.767152678@goodmis.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 07 May 2019 21:55:59 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> [
>   This is the non-RFC version.
> 
>   It went through and passed all my tests. If there's no objections
>   I'm going to include this in my pull request. I still have patches
>   in my INBOX that may still be included, so I need to run those through
>   my tests as well, so a pull request wont be immediate.
> ]
> 
> Nicolai Stange discovered that Live Kernel Patching can have unforseen
> consequences if tracing is enabled when there are functions that are
> patched. The reason being, is that Live Kernel patching is built on top
> of ftrace, which will have the patched functions call the live kernel
> trampoline directly, and that trampoline will modify the regs->ip address
> to return to the patched function.
> 
> But in the transition between changing the call to the customized
> trampoline, the tracing code is needed to have its handler called
> an well, so the function fentry location must be changed from calling
> the live kernel patching trampoline, to the ftrace_reg_caller trampoline
> which will iterate through all the registered ftrace handlers for
> that function.
> 
> During this transition, a break point is added to do the live code
> modifications. But if that break point is hit, it just skips calling
> any handler, and makes the call site act as a nop. For tracing, the
> worse that can happen is that you miss a function being traced, but
> for live kernel patching the affects are more severe, as the old buggy
> function is now called.
> 
> To solve this, an int3_emulate_call() is created for x86_64 to allow
> ftrace on x86_64 to emulate the call to ftrace_regs_caller() which will
> make sure all the registered handlers to that function are still called.
> And this keeps live kernel patching happy!

Out of curiosity, would you have any idea to re-use these function for
other use-case? Maybe kprobes can reuse it, but very limited use-case.

> To mimimize the changes, and to avoid controversial patches, this
> only changes x86_64. Due to the way x86_32 implements the regs->sp
> the complexity of emulating calls on that platform is too much for
> stable patches, and live kernel patching does not support x86_32 anyway.

This series looks good to me.

Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>

Thanks!

-- 
Masami Hiramatsu <mhiramat@kernel.org>
