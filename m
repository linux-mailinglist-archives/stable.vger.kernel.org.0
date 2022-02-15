Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6844B76B1
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 21:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238283AbiBOTXJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 14:23:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236160AbiBOTXI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 14:23:08 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3D47EB1D
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 11:22:58 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id z15-20020a25bb0f000000b00613388c7d99so42915582ybg.8
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 11:22:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+Qagel9nxFYYnNu2HO8CI3hbxGS3rPswiuqZekiakKs=;
        b=li8UV/c9WCi6LXoDFvpYmTXYrRW7F85lEGiJd8p70kxSkOWAWsw/rBrAAy6p0krLV8
         AheJXPAHJ4LQu1QXcJ062+EJcq3X1rx1XujfG9+LxPpF1E36wcG9csbxb8xHgQCizzDc
         2Y/vkr4iJebx9bSFG6bdSg3Wg9aE8iY3nWgHNIY6a2mIgL9YtgMDY5h2NUGiC1ba3OGx
         HDs7l7+gpVLbVImM2iDn+TnStY79NQ2OF+cOJA5ItPQbG3WkFyv8EEJ2u3KXiGCU4jn6
         6f2nTGnhJjil6JPxiVTWl7XYCQ6OarH/2zom4PJA0tf8NdDV6x5DWtU/HH8/QdQPMR4X
         v9wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+Qagel9nxFYYnNu2HO8CI3hbxGS3rPswiuqZekiakKs=;
        b=Cb7YP/nIOFEicDO40rrWs8l5891hBGdsG59UJIC8ViERNJ3vrRv1CJV1AnV/KRwZTJ
         Zq22jQV97yfJ/LPuRyxLFobmI3JP5BgjgAHPTQ4Wn8bfz0/FaElaCaSgIZOLi+h+sMEx
         NnJyTzhmt2JGOu/pVU7AjD2hIoubNRRvABfw6CBhHSe0qnaUcKyPdc4owuzmQJH3dDgi
         tl342d5frWSuyCQRTpSmnsw4ENereR6S0wA4l39qImwjD0JOf16NobQgFhefiUgb0fcD
         UuXs/FcQiMhnTqu9FkIp5tf0ltu2FdRwsePjSWahZCu7Zbs3EDIivesI23zoalku6DT9
         wkjw==
X-Gm-Message-State: AOAM530AeHjWnB9X458KK6QwI1vXLRzQ7VPlnQECXx2gVnyU/ZleO5+E
        gb6zqWr5sGzHXmwnU90aO0Bc9UJo4ryO
X-Google-Smtp-Source: ABdhPJxAUxFFPS+GiBvMggHlTCE+Y2IVZgCgbqT1fUdihi1KYP3j9OJC2WvQbznhoZPN5QXJ9cWVtVmbBlPH
X-Received: from bg.sfo.corp.google.com ([2620:15c:11a:202:c66c:3ade:392d:9c60])
 (user=bgeffon job=sendgmr) by 2002:a81:1f89:: with SMTP id
 f131mr357116ywf.261.1644952977298; Tue, 15 Feb 2022 11:22:57 -0800 (PST)
Date:   Tue, 15 Feb 2022 11:22:33 -0800
In-Reply-To: <543efc25-9b99-53cd-e305-d8b4d917b64b@intel.com>
Message-Id: <20220215192233.8717-1-bgeffon@google.com>
Mime-Version: 1.0
References: <543efc25-9b99-53cd-e305-d8b4d917b64b@intel.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH stable 5.4,5.10] x86/fpu: Correct pkru/xstate inconsistency
From:   Brian Geffon <bgeffon@google.com>
To:     Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Willis Kung <williskung@google.com>,
        Guenter Roeck <groeck@google.com>,
        Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Brian Geffon <bgeffon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When eagerly switching PKRU in switch_fpu_finish() it checks that
current is not a kernel thread as kernel threads will never use PKRU.
It's possible that this_cpu_read_stable() on current_task
(ie. get_current()) is returning an old cached value. To resolve this
reference next_p directly rather than relying on current.

As written it's possible when switching from a kernel thread to a
userspace thread to observe a cached PF_KTHREAD flag and never restore
the PKRU. And as a result this issue only occurs when switching
from a kernel thread to a userspace thread, switching from a non kernel
thread works perfectly fine because all that is considered in that
situation are the flags from some other non kernel task and the next fpu
is passed in to switch_fpu_finish().

This behavior only exists between 5.2 and 5.13 when it was fixed by a
rewrite decoupling PKRU from xstate, in:
  commit 954436989cc5 ("x86/fpu: Remove PKRU handling from switch_fpu_finish()")

Unfortunately backporting the fix from 5.13 is probably not realistic as
it's part of a 60+ patch series which rewrites most of the PKRU handling.

Fixes: 0cecca9d03c9 ("x86/fpu: Eager switch PKRU state")
Signed-off-by: Brian Geffon <bgeffon@google.com>
Signed-off-by: Willis Kung <williskung@google.com>
Tested-by: Willis Kung <williskung@google.com>
Cc: <stable@vger.kernel.org> # v5.4.x
Cc: <stable@vger.kernel.org> # v5.10.x
---
 arch/x86/include/asm/fpu/internal.h | 13 ++++++++-----
 arch/x86/kernel/process_32.c        |  6 ++----
 arch/x86/kernel/process_64.c        |  6 ++----
 3 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index 03b3de491b5e..5ed702e2c55f 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -560,9 +560,11 @@ static inline void __fpregs_load_activate(void)
  * The FPU context is only stored/restored for a user task and
  * PF_KTHREAD is used to distinguish between kernel and user threads.
  */
-static inline void switch_fpu_prepare(struct fpu *old_fpu, int cpu)
+static inline void switch_fpu_prepare(struct task_struct *prev, int cpu)
 {
-	if (static_cpu_has(X86_FEATURE_FPU) && !(current->flags & PF_KTHREAD)) {
+	struct fpu *old_fpu = &prev->thread.fpu;
+
+	if (static_cpu_has(X86_FEATURE_FPU) && !(prev->flags & PF_KTHREAD)) {
 		if (!copy_fpregs_to_fpstate(old_fpu))
 			old_fpu->last_cpu = -1;
 		else
@@ -581,10 +583,11 @@ static inline void switch_fpu_prepare(struct fpu *old_fpu, int cpu)
  * Load PKRU from the FPU context if available. Delay loading of the
  * complete FPU state until the return to userland.
  */
-static inline void switch_fpu_finish(struct fpu *new_fpu)
+static inline void switch_fpu_finish(struct task_struct *next)
 {
 	u32 pkru_val = init_pkru_value;
 	struct pkru_state *pk;
+	struct fpu *next_fpu = &next->thread.fpu;
 
 	if (!static_cpu_has(X86_FEATURE_FPU))
 		return;
@@ -598,7 +601,7 @@ static inline void switch_fpu_finish(struct fpu *new_fpu)
 	 * PKRU state is switched eagerly because it needs to be valid before we
 	 * return to userland e.g. for a copy_to_user() operation.
 	 */
-	if (!(current->flags & PF_KTHREAD)) {
+	if (!(next->flags & PF_KTHREAD)) {
 		/*
 		 * If the PKRU bit in xsave.header.xfeatures is not set,
 		 * then the PKRU component was in init state, which means
@@ -607,7 +610,7 @@ static inline void switch_fpu_finish(struct fpu *new_fpu)
 		 * in memory is not valid. This means pkru_val has to be
 		 * set to 0 and not to init_pkru_value.
 		 */
-		pk = get_xsave_addr(&new_fpu->state.xsave, XFEATURE_PKRU);
+		pk = get_xsave_addr(&next_fpu->state.xsave, XFEATURE_PKRU);
 		pkru_val = pk ? pk->pkru : 0;
 	}
 	__write_pkru(pkru_val);
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index b8ceec4974fe..352f876950ab 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -229,14 +229,12 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 {
 	struct thread_struct *prev = &prev_p->thread,
 			     *next = &next_p->thread;
-	struct fpu *prev_fpu = &prev->fpu;
-	struct fpu *next_fpu = &next->fpu;
 	int cpu = smp_processor_id();
 
 	/* never put a printk in __switch_to... printk() calls wake_up*() indirectly */
 
 	if (!test_thread_flag(TIF_NEED_FPU_LOAD))
-		switch_fpu_prepare(prev_fpu, cpu);
+		switch_fpu_prepare(prev_p, cpu);
 
 	/*
 	 * Save away %gs. No need to save %fs, as it was saved on the
@@ -292,7 +290,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 
 	this_cpu_write(current_task, next_p);
 
-	switch_fpu_finish(next_fpu);
+	switch_fpu_finish(next_p);
 
 	/* Load the Intel cache allocation PQR MSR. */
 	resctrl_sched_in();
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index da3cc3a10d63..633788362906 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -505,15 +505,13 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 {
 	struct thread_struct *prev = &prev_p->thread;
 	struct thread_struct *next = &next_p->thread;
-	struct fpu *prev_fpu = &prev->fpu;
-	struct fpu *next_fpu = &next->fpu;
 	int cpu = smp_processor_id();
 
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_DEBUG_ENTRY) &&
 		     this_cpu_read(irq_count) != -1);
 
 	if (!test_thread_flag(TIF_NEED_FPU_LOAD))
-		switch_fpu_prepare(prev_fpu, cpu);
+		switch_fpu_prepare(prev_p, cpu);
 
 	/* We must save %fs and %gs before load_TLS() because
 	 * %fs and %gs may be cleared by load_TLS().
@@ -565,7 +563,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	this_cpu_write(current_task, next_p);
 	this_cpu_write(cpu_current_top_of_stack, task_top_of_stack(next_p));
 
-	switch_fpu_finish(next_fpu);
+	switch_fpu_finish(next_p);
 
 	/* Reload sp0. */
 	update_task_stack(next_p);
-- 
2.35.1.265.g69c8d7142f-goog

