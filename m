Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A2E456C59
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 10:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbhKSJdJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 04:33:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbhKSJdJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 04:33:09 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE63C061574;
        Fri, 19 Nov 2021 01:30:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=j5rsFNOcSbmv2uht0jmJfe9vv3H1xhRH8zAhuhB8Is8=; b=fWIYXThbsAmFiLDPRQA8qlxd5H
        Hy5DV3BdLCsaw09fjIVoi5hIJQ2sEq6OI0RXJXkGWnRU2P98Av6nSGXHVWILRw6hPAvirvPNPwI2E
        FMSlCCY1tEnStr+lisGuiKdSeUcRtC34fMu7cZIol+47ooITIKceBmccT+GHbvb1gf9bdPLPNVcNo
        YjwqBUAtq3+Dxa27TwH7rePAnF9FcapZEGbcFNYTQAuSi1PG1IiN7+wvaufvO0jTHHN92YhIlI2Z5
        19V6AyAuj2Kn4UY1KBOk2s8HI04GHqONRvtBj+tttmAD6/dxQypFKBuseAIEz8qGWgqMqb0zbh7q7
        WZo580jA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mo0DN-009N3h-0K; Fri, 19 Nov 2021 09:29:49 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 07AA2300129;
        Fri, 19 Nov 2021 10:29:48 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id E329A265BA04B; Fri, 19 Nov 2021 10:29:47 +0100 (CET)
Date:   Fri, 19 Nov 2021 10:29:47 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Holger Hoffst??tte <holger@applied-asynchrony.com>,
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
        stable <stable@vger.kernel.org>
Subject: [PATCH] x86: Pin task-stack in __get_wchan()
Message-ID: <YZduix64h64cDa7R@hirez.programming.kicks-ass.net>
References: <20211117101657.463560063@linuxfoundation.org>
 <YZV02RCRVHIa144u@fedora64.linuxtx.org>
 <55c7b316-e03d-9e91-d74c-fea63c469b3b@applied-asynchrony.com>
 <CAHk-=wjHbKfck1Ws4Y0pUZ7bxdjU9eh2WK0EFsv65utfeVkT9Q@mail.gmail.com>
 <20211118080627.GH174703@worktop.programming.kicks-ass.net>
 <20211118081852.GM174730@worktop.programming.kicks-ass.net>
 <YZYfYOcqNqOyZ8Yo@hirez.programming.kicks-ass.net>
 <YZZC3Shc0XA/gHK9@hirez.programming.kicks-ass.net>
 <20211119020427.2y5esq2czquwmvwc@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211119020427.2y5esq2czquwmvwc@treble>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 18, 2021 at 06:04:27PM -0800, Josh Poimboeuf wrote:
> On Thu, Nov 18, 2021 at 01:11:09PM +0100, Peter Zijlstra wrote:

> > I now have the below, the only thing missing is that there's a
> > user_mode() call on a stack based regs. Now on x86_64 we can
> > __get_kernel_nofault() regs->cs and call it a day, but on i386 we have
> > to also fetch regs->flags.
> > 
> > Is this really the way to go?
> 
> Please no.  Can we just add a check in unwind_start() to ensure the
> caller did try_get_task_stack()?

I tried; but at best it's fundamentally racy and in practise its worse
because init_task doesn't seem to believe in refcounts and kthreads are
odd for some raisin. Now those are fixable, but given the fundamental
races, I don't see how it's ever going to be reliable.

I don't mind the __get_kernel_nofault() usage and think I can do a
better implementation that will allow us to get rid of the
pagefault_{dis,en}able() sprinkling, but that's for another day. It's
just the user_mode(regs) usage that's going to be somewhat ugleh.

Anyway, below is the minimal fix for the situation at hand. I'm not
going to be around much today, so if Linus wants to pick that up instead
of mass revert things that's obviously fine too.

---
Subject: x86: Pin task-stack in __get_wchan()

When commit 5d1ceb3969b6 ("x86: Fix __get_wchan() for !STACKTRACE")
moved from stacktrace to native unwind_*() usage, the
try_get_task_stack() got lost, leading to use-after-free issues for
dying tasks.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/kernel/process.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index e9ee8b526319..04143a653a8a 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -964,6 +964,9 @@ unsigned long __get_wchan(struct task_struct *p)
 	struct unwind_state state;
 	unsigned long addr = 0;
 
+	if (!try_get_task_stack(p))
+		return 0;
+
 	for (unwind_start(&state, p, NULL, NULL); !unwind_done(&state);
 	     unwind_next_frame(&state)) {
 		addr = unwind_get_return_address(&state);
@@ -974,6 +977,8 @@ unsigned long __get_wchan(struct task_struct *p)
 		break;
 	}
 
+	put_task_stack(p);
+
 	return addr;
 }
 
