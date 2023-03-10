Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEF416B4A53
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234166AbjCJPVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:21:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234172AbjCJPVG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:21:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14569127131
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:11:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED81AB822E7
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4742FC433A0;
        Fri, 10 Mar 2023 15:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678461043;
        bh=dOHAVYz1N08wthrxklw00t+/XHp55vmfG7ioMjr5djM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kqf9eByIWdnzFYP4s90CGr3OnskHgshpXsYCPzI4OTcC7+hi7aOacSoid3LTVoRHY
         gPu5HYDKDKTtgXYhGTsAbYGnMFtKWMv5uGsSySlE85LzQG9tj7J9SsOIAysw+Wzmlo
         hca4cKIaB7fPA7lE9r5vzS4miKraWpwVJ5CfqIhA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stephane Eranian <eranian@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tony Luck <tony.luck@intel.com>,
        Babu Moger <babu.moger@amd.com>, stable@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 515/529] x86/resctl: fix scheduler confusion with current
Date:   Fri, 10 Mar 2023 14:40:58 +0100
Message-Id: <20230310133828.685810770@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 7fef099702527c3b2c5234a2ea6a24411485a13a upstream.

The implementation of 'current' on x86 is very intentionally special: it
is a very common thing to look up, and it uses 'this_cpu_read_stable()'
to get the current thread pointer efficiently from per-cpu storage.

And the keyword in there is 'stable': the current thread pointer never
changes as far as a single thread is concerned.  Even if when a thread
is preempted, or moved to another CPU, or even across an explicit call
'schedule()' that thread will still have the same value for 'current'.

It is, after all, the kernel base pointer to thread-local storage.
That's why it's stable to begin with, but it's also why it's important
enough that we have that special 'this_cpu_read_stable()' access for it.

So this is all done very intentionally to allow the compiler to treat
'current' as a value that never visibly changes, so that the compiler
can do CSE and combine multiple different 'current' accesses into one.

However, there is obviously one very special situation when the
currently running thread does actually change: inside the scheduler
itself.

So the scheduler code paths are special, and do not have a 'current'
thread at all.  Instead there are _two_ threads: the previous and the
next thread - typically called 'prev' and 'next' (or prev_p/next_p)
internally.

So this is all actually quite straightforward and simple, and not all
that complicated.

Except for when you then have special code that is run in scheduler
context, that code then has to be aware that 'current' isn't really a
valid thing.  Did you mean 'prev'? Did you mean 'next'?

In fact, even if then look at the code, and you use 'current' after the
new value has been assigned to the percpu variable, we have explicitly
told the compiler that 'current' is magical and always stable.  So the
compiler is quite free to use an older (or newer) value of 'current',
and the actual assignment to the percpu storage is not relevant even if
it might look that way.

Which is exactly what happened in the resctl code, that blithely used
'current' in '__resctrl_sched_in()' when it really wanted the new
process state (as implied by the name: we're scheduling 'into' that new
resctl state).  And clang would end up just using the old thread pointer
value at least in some configurations.

This could have happened with gcc too, and purely depends on random
compiler details.  Clang just seems to have been more aggressive about
moving the read of the per-cpu current_task pointer around.

The fix is trivial: just make the resctl code adhere to the scheduler
rules of using the prev/next thread pointer explicitly, instead of using
'current' in a situation where it just wasn't valid.

That same code is then also used outside of the scheduler context (when
a thread resctl state is explicitly changed), and then we will just pass
in 'current' as that pointer, of course.  There is no ambiguity in that
case.

The fix may be trivial, but noticing and figuring out what went wrong
was not.  The credit for that goes to Stephane Eranian.

Reported-by: Stephane Eranian <eranian@google.com>
Link: https://lore.kernel.org/lkml/20230303231133.1486085-1-eranian@google.com/
Link: https://lore.kernel.org/lkml/alpine.LFD.2.01.0908011214330.3304@localhost.localdomain/
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Tony Luck <tony.luck@intel.com>
Tested-by: Stephane Eranian <eranian@google.com>
Tested-by: Babu Moger <babu.moger@amd.com>
Cc: stable@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/resctrl.h         |   12 ++++++------
 arch/x86/kernel/cpu/resctrl/rdtgroup.c |    4 ++--
 arch/x86/kernel/process_32.c           |    2 +-
 arch/x86/kernel/process_64.c           |    2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

--- a/arch/x86/include/asm/resctrl.h
+++ b/arch/x86/include/asm/resctrl.h
@@ -51,7 +51,7 @@ DECLARE_STATIC_KEY_FALSE(rdt_mon_enable_
  *   simple as possible.
  * Must be called with preemption disabled.
  */
-static void __resctrl_sched_in(void)
+static inline void __resctrl_sched_in(struct task_struct *tsk)
 {
 	struct resctrl_pqr_state *state = this_cpu_ptr(&pqr_state);
 	u32 closid = state->default_closid;
@@ -63,13 +63,13 @@ static void __resctrl_sched_in(void)
 	 * Else use the closid/rmid assigned to this cpu.
 	 */
 	if (static_branch_likely(&rdt_alloc_enable_key)) {
-		tmp = READ_ONCE(current->closid);
+		tmp = READ_ONCE(tsk->closid);
 		if (tmp)
 			closid = tmp;
 	}
 
 	if (static_branch_likely(&rdt_mon_enable_key)) {
-		tmp = READ_ONCE(current->rmid);
+		tmp = READ_ONCE(tsk->rmid);
 		if (tmp)
 			rmid = tmp;
 	}
@@ -81,17 +81,17 @@ static void __resctrl_sched_in(void)
 	}
 }
 
-static inline void resctrl_sched_in(void)
+static inline void resctrl_sched_in(struct task_struct *tsk)
 {
 	if (static_branch_likely(&rdt_enable_key))
-		__resctrl_sched_in();
+		__resctrl_sched_in(tsk);
 }
 
 void resctrl_cpu_detect(struct cpuinfo_x86 *c);
 
 #else
 
-static inline void resctrl_sched_in(void) {}
+static inline void resctrl_sched_in(struct task_struct *tsk) {}
 static inline void resctrl_cpu_detect(struct cpuinfo_x86 *c) {}
 
 #endif /* CONFIG_X86_CPU_RESCTRL */
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -311,7 +311,7 @@ static void update_cpu_closid_rmid(void
 	 * executing task might have its own closid selected. Just reuse
 	 * the context switch code.
 	 */
-	resctrl_sched_in();
+	resctrl_sched_in(current);
 }
 
 /*
@@ -532,7 +532,7 @@ static void _update_task_closid_rmid(voi
 	 * Otherwise, the MSR is updated when the task is scheduled in.
 	 */
 	if (task == current)
-		resctrl_sched_in();
+		resctrl_sched_in(task);
 }
 
 static void update_task_closid_rmid(struct task_struct *t)
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -214,7 +214,7 @@ __switch_to(struct task_struct *prev_p,
 	switch_fpu_finish(next_p);
 
 	/* Load the Intel cache allocation PQR MSR. */
-	resctrl_sched_in();
+	resctrl_sched_in(next_p);
 
 	return prev_p;
 }
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -629,7 +629,7 @@ __switch_to(struct task_struct *prev_p,
 	}
 
 	/* Load the Intel cache allocation PQR MSR. */
-	resctrl_sched_in();
+	resctrl_sched_in(next_p);
 
 	return prev_p;
 }


