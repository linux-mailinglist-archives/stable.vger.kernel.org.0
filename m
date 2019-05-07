Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAE81699A
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 19:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbfEGRxw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 13:53:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34000 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbfEGRxw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 13:53:52 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 38B66301EA86;
        Tue,  7 May 2019 17:53:51 +0000 (UTC)
Received: from treble (ovpn-123-166.rdu2.redhat.com [10.10.123.166])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3CEB2600D4;
        Tue,  7 May 2019 17:53:45 +0000 (UTC)
Date:   Tue, 7 May 2019 12:53:42 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
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
        the arch/x86 maintainers <x86@kernel.org>,
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
Subject: Re: [RFC][PATCH 2/3] x86_64: Allow breakpoints to emulate call
 functions
Message-ID: <20190507175342.fskdj2qidpao65qi@treble>
References: <20190507174227.673261270@goodmis.org>
 <20190507174400.219947724@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190507174400.219947724@goodmis.org>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Tue, 07 May 2019 17:53:51 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 07, 2019 at 01:42:29PM -0400, Steven Rostedt wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> 
> In order to allow breakpoints to emulate call functions, they need to push
> the return address onto the stack. But because the breakpoint exception
> frame is added to the stack when the breakpoint is hit, there's no room to
> add the address onto the stack and return to the address of the emulated
> called funtion.
> 
> To handle this, copy the exception frame on entry of the breakpoint handler
> and have leave a gap that can be used to add a return address to the stack
> frame and return from the breakpoint to the emulated called function,
> allowing for that called function to return back to the location after the
> breakpoint was placed.

This part is done by patch 1.

> 
> The helper functions were also added:

No longer "also" :-)

>   int3_emulate_push(): to push the address onto the gap in the stack
>   int3_emulate_jmp(): changes the location of the regs->ip to return there.
>   int3_emulate_call(): push the return address and change regs->ip
> 
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Nicolai Stange <nstange@suse.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: the arch/x86 maintainers <x86@kernel.org>
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Jiri Kosina <jikos@kernel.org>
> Cc: Miroslav Benes <mbenes@suse.cz>
> Cc: Petr Mladek <pmladek@suse.com>
> Cc: Joe Lawrence <joe.lawrence@redhat.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Tim Chen <tim.c.chen@linux.intel.com>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Mimi Zohar <zohar@linux.ibm.com>
> Cc: Juergen Gross <jgross@suse.com>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: Nayna Jain <nayna@linux.ibm.com>
> Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> Cc: Joerg Roedel <jroedel@suse.de>
> Cc: "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>
> Cc: stable@vger.kernel.org
> Fixes: b700e7f03df5 ("livepatch: kernel: add support for live patching")
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> [ Modified to only work for x86_64 ]
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>  arch/x86/include/asm/text-patching.h | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/arch/x86/include/asm/text-patching.h b/arch/x86/include/asm/text-patching.h
> index e85ff65c43c3..455bf9f88233 100644
> --- a/arch/x86/include/asm/text-patching.h
> +++ b/arch/x86/include/asm/text-patching.h
> @@ -39,4 +39,26 @@ extern int poke_int3_handler(struct pt_regs *regs);
>  extern void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler);
>  extern int after_bootmem;
>  
> +static inline void int3_emulate_jmp(struct pt_regs *regs, unsigned long ip)
> +{
> +	regs->ip = ip;
> +}
> +
> +#define INT3_INSN_SIZE 1
> +#define CALL_INSN_SIZE 5
> +
> +#ifdef CONFIG_X86_64
> +static inline void int3_emulate_push(struct pt_regs *regs, unsigned long val)
> +{
> +	regs->sp -= sizeof(unsigned long);
> +	*(unsigned long *)regs->sp = val;
> +}

How this works isn't really obvious.  A comment is probably warranted to
explain the fact that the int3 entry code reserved some space on the
stack.

-- 
Josh
