Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 562D54C73CB
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235672AbiB1RjC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:39:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238558AbiB1Rh7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:37:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7186E53B5C;
        Mon, 28 Feb 2022 09:32:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DD4E609EE;
        Mon, 28 Feb 2022 17:32:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C6BC340E7;
        Mon, 28 Feb 2022 17:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069574;
        bh=6SylHDLmOv0JwBhMhYAiI6qLnfRWw42Ro4CXXV9oZEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tb/pcXxpS9vyO0cbG5j7CLBUdyH8DnKNRN3Wx6YwpTbP9TlTTs+QzDANoKDHbnQSC
         Im/L7ZfE+BrUR/Fxb8OBqZtK6540eE2i/PAIFtDaohNWRUb2Rxx1o28b/ZCc0dhkcA
         wZJAfxLAtAw4homyK9tr4DmlI+b9m+63jI/1Zv2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Geffon <bgeffon@google.com>,
        Willis Kung <williskung@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 5.10 16/80] x86/fpu: Correct pkru/xstate inconsistency
Date:   Mon, 28 Feb 2022 18:23:57 +0100
Message-Id: <20220228172313.553949149@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172311.789892158@linuxfoundation.org>
References: <20220228172311.789892158@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Geffon <bgeffon@google.com>

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
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/fpu/internal.h |   13 ++++++++-----
 arch/x86/kernel/process_32.c        |    6 ++----
 arch/x86/kernel/process_64.c        |    6 ++----
 3 files changed, 12 insertions(+), 13 deletions(-)

--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -531,9 +531,11 @@ static inline void __fpregs_load_activat
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
@@ -552,10 +554,11 @@ static inline void switch_fpu_prepare(st
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
@@ -569,7 +572,7 @@ static inline void switch_fpu_finish(str
 	 * PKRU state is switched eagerly because it needs to be valid before we
 	 * return to userland e.g. for a copy_to_user() operation.
 	 */
-	if (!(current->flags & PF_KTHREAD)) {
+	if (!(next->flags & PF_KTHREAD)) {
 		/*
 		 * If the PKRU bit in xsave.header.xfeatures is not set,
 		 * then the PKRU component was in init state, which means
@@ -578,7 +581,7 @@ static inline void switch_fpu_finish(str
 		 * in memory is not valid. This means pkru_val has to be
 		 * set to 0 and not to init_pkru_value.
 		 */
-		pk = get_xsave_addr(&new_fpu->state.xsave, XFEATURE_PKRU);
+		pk = get_xsave_addr(&next_fpu->state.xsave, XFEATURE_PKRU);
 		pkru_val = pk ? pk->pkru : 0;
 	}
 	__write_pkru(pkru_val);
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -159,14 +159,12 @@ __switch_to(struct task_struct *prev_p,
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
@@ -213,7 +211,7 @@ __switch_to(struct task_struct *prev_p,
 
 	this_cpu_write(current_task, next_p);
 
-	switch_fpu_finish(next_fpu);
+	switch_fpu_finish(next_p);
 
 	/* Load the Intel cache allocation PQR MSR. */
 	resctrl_sched_in();
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -535,15 +535,13 @@ __switch_to(struct task_struct *prev_p,
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
@@ -595,7 +593,7 @@ __switch_to(struct task_struct *prev_p,
 	this_cpu_write(current_task, next_p);
 	this_cpu_write(cpu_current_top_of_stack, task_top_of_stack(next_p));
 
-	switch_fpu_finish(next_fpu);
+	switch_fpu_finish(next_p);
 
 	/* Reload sp0. */
 	update_task_stack(next_p);


