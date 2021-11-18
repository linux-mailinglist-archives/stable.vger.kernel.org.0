Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7707945582F
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 10:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243548AbhKRJnC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 04:43:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242788AbhKRJnB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 04:43:01 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67F28C061570;
        Thu, 18 Nov 2021 01:40:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ogCf4AytFUFECDajO7C4/wd84tMdRQVBsKyePnKRwKk=; b=ngAbZZvsDoH/aHl2u2ApTYpDbK
        x5hRRWlzgHEbYmSnYWjcsHzz6ZgHi8LGMl5E4uN8GjJAzMtzZraw5KEdIdTR2z+SoS4v3qMl/cpPM
        299e6tCkDvUxjeUFm+UjyglASUbdper+V4MfkNqkQ4b89bq28Oqu3poyEigSKDoWgKY1QaLE4qvZr
        1uPpKZFGElBtKfcFAdgmhDQMk/LUFnqG5ImLE4LBE3Eeta/OFq6IZoB8eUd3Lp+gg7JEcAucV7hJx
        Wg1AiHbAJIpfbkQKCtKKy2knL9a2RovCCaV0rRqjGnmvNnxMA/fu1dcbbXhdIaEWXcxXjASq2m5i2
        mkg8iZ4w==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mndtT-00GfRe-UX; Thu, 18 Nov 2021 09:39:48 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 5CF70300129;
        Thu, 18 Nov 2021 10:39:44 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 30B212CFFA13E; Thu, 18 Nov 2021 10:39:44 +0100 (CET)
Date:   Thu, 18 Nov 2021 10:39:44 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Justin Forbes <jmforbes@linuxtx.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        stable <stable@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH 5.15 000/923] 5.15.3-rc3 review
Message-ID: <YZYfYOcqNqOyZ8Yo@hirez.programming.kicks-ass.net>
References: <20211117101657.463560063@linuxfoundation.org>
 <YZV02RCRVHIa144u@fedora64.linuxtx.org>
 <55c7b316-e03d-9e91-d74c-fea63c469b3b@applied-asynchrony.com>
 <CAHk-=wjHbKfck1Ws4Y0pUZ7bxdjU9eh2WK0EFsv65utfeVkT9Q@mail.gmail.com>
 <20211118080627.GH174703@worktop.programming.kicks-ass.net>
 <20211118081852.GM174730@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211118081852.GM174730@worktop.programming.kicks-ass.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 18, 2021 at 09:18:52AM +0100, Peter Zijlstra wrote:
> On Thu, Nov 18, 2021 at 09:06:27AM +0100, Peter Zijlstra wrote:
> > On Wed, Nov 17, 2021 at 03:50:17PM -0800, Linus Torvalds wrote:
> > 
> > > I really don't think the WCHAN code should use unwinders at all. It's
> > > too damn fragile, and it's too easily triggered from user space.
> > 
> > On x86, esp. with ORC, it pretty much has to. The thing is, the ORC
> > unwinder has been very stable so far. I'm guessing there's some really
> > stupid thing going on, like for example trying to unwind a freed stack.
> > 
> > I *just* managed to reproduce, so let me go have a poke.
> 
> Confirmed, with the below it no longer reproduces. Now, let me go undo
> that and fix the unwinder to not explode while trying to unwind nothing.

OK, so the bug is firmly with 5d1ceb3969b6 ("x86: Fix __get_wchan() for
!STACKTRACE") which lost the try_get_task_stack() that stack_trace_*()
does.

We can ofc trivially re-instate that, but I'm now running with the
below which I suppose is a better fix, hmm?

(obv I still need to look a the other two unwinders)

---
diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
index e6f7592790af..9261ff1343cf 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -352,8 +352,14 @@ static bool deref_stack_reg(struct unwind_state *state, unsigned long addr,
 	if (!stack_access_ok(state, addr, sizeof(long)))
 		return false;
 
-	*val = READ_ONCE_NOCHECK(*(unsigned long *)addr);
+	pagefault_disable();
+	__get_kernel_nofault(val, addr, unsigned long, Efault);
+	pagefault_enable();
 	return true;
+
+Efault:
+	pagefault_enable();
+	return false;
 }
 
 static bool deref_stack_regs(struct unwind_state *state, unsigned long addr,
@@ -367,9 +373,16 @@ static bool deref_stack_regs(struct unwind_state *state, unsigned long addr,
 	if (!stack_access_ok(state, addr, sizeof(struct pt_regs)))
 		return false;
 
-	*ip = READ_ONCE_NOCHECK(regs->ip);
-	*sp = READ_ONCE_NOCHECK(regs->sp);
+	pagefault_disable();
+	__get_kernel_nofault(ip, &regs->ip, unsigned long, Efault);
+	__get_kernel_nofault(sp, &regs->sp, unsigned long, Efault);
+	pagefault_enable();
+
 	return true;
+
+Efault:
+	pagefault_enable();
+	return false;
 }
 
 static bool deref_stack_iret_regs(struct unwind_state *state, unsigned long addr,
@@ -380,9 +393,16 @@ static bool deref_stack_iret_regs(struct unwind_state *state, unsigned long addr
 	if (!stack_access_ok(state, addr, IRET_FRAME_SIZE))
 		return false;
 
-	*ip = READ_ONCE_NOCHECK(regs->ip);
-	*sp = READ_ONCE_NOCHECK(regs->sp);
+	pagefault_disable();
+	__get_kernel_nofault(ip, &regs->ip, unsigned long, Efault);
+	__get_kernel_nofault(sp, &regs->sp, unsigned long, Efault);
+	pagefault_enable();
+
 	return true;
+
+Efault:
+	pagefault_enable();
+	return false;
 }
 
 /*
@@ -396,22 +416,27 @@ static bool deref_stack_iret_regs(struct unwind_state *state, unsigned long addr
 static bool get_reg(struct unwind_state *state, unsigned int reg_off,
 		    unsigned long *val)
 {
-	unsigned int reg = reg_off/8;
-
 	if (!state->regs)
 		return false;
 
+	pagefault_disable();
 	if (state->full_regs) {
-		*val = READ_ONCE_NOCHECK(((unsigned long *)state->regs)[reg]);
+		__get_kernel_nofault(val, (void *)state->regs + reg_off, unsigned long, Efault);
+		pagefault_enable();
 		return true;
 	}
 
 	if (state->prev_regs) {
-		*val = READ_ONCE_NOCHECK(((unsigned long *)state->prev_regs)[reg]);
+		__get_kernel_nofault(val, (void *)state->regs + reg_off, unsigned long, Efault);
+		pagefault_enable();
 		return true;
 	}
 
 	return false;
+
+Efault:
+	pagefault_enable();
+	return false;
 }
 
 bool unwind_next_frame(struct unwind_state *state)
@@ -673,8 +698,12 @@ void __unwind_start(struct unwind_state *state, struct task_struct *task,
 		struct inactive_task_frame *frame = (void *)task->thread.sp;
 
 		state->sp = task->thread.sp + sizeof(*frame);
-		state->bp = READ_ONCE_NOCHECK(frame->bp);
-		state->ip = READ_ONCE_NOCHECK(frame->ret_addr);
+
+		pagefault_disable();
+		__get_kernel_nofault(&state->bp, &frame->bp, unsigned long, Efault);
+		__get_kernel_nofault(&state->ip, &frame->ret_addr, unsigned long, Efault);
+		pagefault_enable();
+
 		state->signal = (void *)state->ip == ret_from_fork;
 	}
 
@@ -713,6 +742,8 @@ void __unwind_start(struct unwind_state *state, struct task_struct *task,
 
 	return;
 
+Efault:
+	pagefault_enable();
 err:
 	state->error = true;
 the_end:
