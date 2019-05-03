Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC2D512A7D
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 11:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726041AbfECJar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 05:30:47 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36870 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbfECJar (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 May 2019 05:30:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/sJFNjnkXiIwcXqbtjN09ZmuuifrOAid7089Ha4ecjg=; b=mcoWHhStv7fEKw2GUAKatzGDe
        PVcoK+XWyUpxja6wb7rQMMvbiDpxYJcikrKi4TYhdDcrt7FcLuztkV3Z0llyLOyTLdWIBMZmg4TOv
        zuVhsnaan5xTVDcCbrfeX9+VvbEMWNd7GQxoSVEMegwm0gFXFVwk52orBeOPOiqn2C3YzC+6x/JU+
        OJHUVlioJ0yhdg/jsyV0C5634itkGTUZtNHPVxojO94elcLU9qBw/1L5HjgP7Rff8ochhshhT8L/Z
        wVo+5VB+J2ZV50RMBUUGbA/avxgnfY4dpk0FR9wnWoHRttbcF4OM3Ijy7gLqYn/O8ToNn5mUN1k0L
        Qj715Jf7Q==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hMUW3-0008PY-TQ; Fri, 03 May 2019 09:30:04 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id ABE0C209A1C83; Fri,  3 May 2019 11:29:59 +0200 (CEST)
Date:   Fri, 3 May 2019 11:29:59 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Steven Rostedt <rostedt@goodmis.org>
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
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call functions
Message-ID: <20190503092959.GB2623@hirez.programming.kicks-ass.net>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502195052.0af473cf@gandalf.local.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 02, 2019 at 07:50:52PM -0400, Steven Rostedt wrote:
> On Thu, 2 May 2019 19:31:29 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Digging a little further, I pinpointed it out to being kretprobes. The
> > problem I believe is the use of kernel_stack_pointer() which does some
> > magic on x86_32. kretprobes uses this to hijack the return address of
> > the function (much like the function graph tracer does). I do have code
> > that would allow kretprobes to use the function graph tracer instead,
> > but that's still in progress (almost done!). But still, we should not
> > have this break the use of kernel_stack_pointer() either.
> > 
> > Adding some printks in that code, it looks to be returning "&regs->sp"
> > which I think we changed.
> >
> 
> This appears to fix it!
> 
> -- Steve
> 
> diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
> index 4b8ee05dd6ad..600ead178bf4 100644
> --- a/arch/x86/kernel/ptrace.c
> +++ b/arch/x86/kernel/ptrace.c
> @@ -171,8 +171,12 @@ unsigned long kernel_stack_pointer(struct pt_regs *regs)
>  	unsigned long sp = (unsigned long)&regs->sp;
>  	u32 *prev_esp;
>  
> -	if (context == (sp & ~(THREAD_SIZE - 1)))
> +	if (context == (sp & ~(THREAD_SIZE - 1))) {
> +		/* int3 code adds a gap */
> +		if (sp == regs->sp - 5*4)
> +			return regs->sp;
>  		return sp;
> +	}
>  
>  	prev_esp = (u32 *)(context);
>  	if (*prev_esp)

OMG, WTF, ARGH... That code is fsck'ing horrible. I'd almost argue to
always do the INT3 thing, just to avoid games like that.

That said; for normal traps &regs->sp is indeed the previous context --
if it doesn't fall off the stack. Your hack detects the regular INT3
frame. Howver if regs->sp has been modified (int3_emulate_push, for
example) your detectoring comes unstuck.

Now, it is rather unlikely these two code paths interact, but just to be
safe, something like so might be more reliable:


diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 4b8ee05dd6ad..aceaad0cc9a9 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -163,6 +163,9 @@ static inline bool invalid_selector(u16 value)
  * stack pointer we fall back to regs as stack if no previous stack
  * exists.
  *
+ * There is a special case for INT3, there we construct a full pt_regs
+ * environment. We can detect this case by a high bit in regs->cs
+ *
  * This is valid only for kernel mode traps.
  */
 unsigned long kernel_stack_pointer(struct pt_regs *regs)
@@ -171,6 +174,9 @@ unsigned long kernel_stack_pointer(struct pt_regs *regs)
 	unsigned long sp = (unsigned long)&regs->sp;
 	u32 *prev_esp;
 
+	if (regs->__csh & (1 << 13)) /* test CS_FROM_INT3 */
+		return regs->sp;
+
 	if (context == (sp & ~(THREAD_SIZE - 1)))
 		return sp;
 
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -388,6 +388,7 @@
 
 #define CS_FROM_ENTRY_STACK	(1 << 31)
 #define CS_FROM_USER_CR3	(1 << 30)
+#define CS_FROM_INT3		(1 << 29)
 
 .macro SWITCH_TO_KERNEL_STACK
 
@@ -1515,6 +1516,9 @@ ENTRY(int3)
 
 	add	$16, 12(%esp) # point sp back at the previous context
 
+	andl	$0x0000ffff, 4(%esp)
+	orl	$CS_FROM_INT3, 4(%esp)
+
 	pushl	$-1				# orig_eax; mark as interrupt
 
 	SAVE_ALL
