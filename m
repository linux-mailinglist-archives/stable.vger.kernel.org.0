Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E60865BBDF
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237063AbjACIRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:17:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237039AbjACIQs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:16:48 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C81BEA
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 00:16:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 14C6ECE1048
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 08:16:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC34C433D2;
        Tue,  3 Jan 2023 08:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672733803;
        bh=NCVHqZ1A2hrGWACY4FOhjH2C1DxaP0Op1mFPecnzmjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TS/H/lAwy15IG4ybegLN2vqHoo/G+LqiAVpQyA3XWWzOUzudvWzz6r2a5kBfiz3/M
         hEU3J9pYNhgYrEoRaZLi1csy7zyGPqYyUVdnleMas3YGccjRxb79S10NOnddnUHTwk
         eOIq7yWNjh8PVmdQAAtEGVvANpUUcNyroKOzrUEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 49/63] arch: setup PF_IO_WORKER threads like PF_KTHREAD
Date:   Tue,  3 Jan 2023 09:14:19 +0100
Message-Id: <20230103081311.526943108@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
References: <20230103081308.548338576@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 4727dc20e0422211a0e0c72b1ace4ed6096df8a6 ]

PF_IO_WORKER are kernel threads too, but they aren't PF_KTHREAD in the
sense that we don't assign ->set_child_tid with our own structure. Just
ensure that every arch sets up the PF_IO_WORKER threads like kthreads
in the arch implementation of copy_thread().

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/alpha/kernel/process.c      |    2 +-
 arch/arc/kernel/process.c        |    2 +-
 arch/arm/kernel/process.c        |    2 +-
 arch/arm64/kernel/process.c      |    2 +-
 arch/csky/kernel/process.c       |    2 +-
 arch/h8300/kernel/process.c      |    2 +-
 arch/hexagon/kernel/process.c    |    2 +-
 arch/ia64/kernel/process.c       |    2 +-
 arch/m68k/kernel/process.c       |    2 +-
 arch/microblaze/kernel/process.c |    2 +-
 arch/mips/kernel/process.c       |    2 +-
 arch/nds32/kernel/process.c      |    2 +-
 arch/nios2/kernel/process.c      |    2 +-
 arch/openrisc/kernel/process.c   |    2 +-
 arch/riscv/kernel/process.c      |    2 +-
 arch/s390/kernel/process.c       |    2 +-
 arch/sh/kernel/process_32.c      |    2 +-
 arch/sparc/kernel/process_32.c   |    2 +-
 arch/sparc/kernel/process_64.c   |    2 +-
 arch/um/kernel/process.c         |    2 +-
 arch/x86/kernel/process.c        |    2 +-
 arch/xtensa/kernel/process.c     |    2 +-
 22 files changed, 22 insertions(+), 22 deletions(-)

--- a/arch/alpha/kernel/process.c
+++ b/arch/alpha/kernel/process.c
@@ -249,7 +249,7 @@ int copy_thread(unsigned long clone_flag
 	childti->pcb.ksp = (unsigned long) childstack;
 	childti->pcb.flags = 1;	/* set FEN, clear everything else */
 
-	if (unlikely(p->flags & PF_KTHREAD)) {
+	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
 		/* kernel thread */
 		memset(childstack, 0,
 			sizeof(struct switch_stack) + sizeof(struct pt_regs));
--- a/arch/arc/kernel/process.c
+++ b/arch/arc/kernel/process.c
@@ -191,7 +191,7 @@ int copy_thread(unsigned long clone_flag
 	childksp[0] = 0;			/* fp */
 	childksp[1] = (unsigned long)ret_from_fork; /* blink */
 
-	if (unlikely(p->flags & PF_KTHREAD)) {
+	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
 		memset(c_regs, 0, sizeof(struct pt_regs));
 
 		c_callee->r13 = kthread_arg;
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -243,7 +243,7 @@ int copy_thread(unsigned long clone_flag
 	thread->cpu_domain = get_domain();
 #endif
 
-	if (likely(!(p->flags & PF_KTHREAD))) {
+	if (likely(!(p->flags & (PF_KTHREAD | PF_IO_WORKER)))) {
 		*childregs = *current_pt_regs();
 		childregs->ARM_r0 = 0;
 		if (stack_start)
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -398,7 +398,7 @@ int copy_thread(unsigned long clone_flag
 
 	ptrauth_thread_init_kernel(p);
 
-	if (likely(!(p->flags & PF_KTHREAD))) {
+	if (likely(!(p->flags & (PF_KTHREAD | PF_IO_WORKER)))) {
 		*childregs = *current_pt_regs();
 		childregs->regs[0] = 0;
 
--- a/arch/csky/kernel/process.c
+++ b/arch/csky/kernel/process.c
@@ -49,7 +49,7 @@ int copy_thread(unsigned long clone_flag
 	/* setup thread.sp for switch_to !!! */
 	p->thread.sp = (unsigned long)childstack;
 
-	if (unlikely(p->flags & PF_KTHREAD)) {
+	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
 		memset(childregs, 0, sizeof(struct pt_regs));
 		childstack->r15 = (unsigned long) ret_from_kernel_thread;
 		childstack->r10 = kthread_arg;
--- a/arch/h8300/kernel/process.c
+++ b/arch/h8300/kernel/process.c
@@ -112,7 +112,7 @@ int copy_thread(unsigned long clone_flag
 
 	childregs = (struct pt_regs *) (THREAD_SIZE + task_stack_page(p)) - 1;
 
-	if (unlikely(p->flags & PF_KTHREAD)) {
+	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
 		memset(childregs, 0, sizeof(struct pt_regs));
 		childregs->retpc = (unsigned long) ret_from_kernel_thread;
 		childregs->er4 = topstk; /* arg */
--- a/arch/hexagon/kernel/process.c
+++ b/arch/hexagon/kernel/process.c
@@ -73,7 +73,7 @@ int copy_thread(unsigned long clone_flag
 						    sizeof(*ss));
 	ss->lr = (unsigned long)ret_from_fork;
 	p->thread.switch_sp = ss;
-	if (unlikely(p->flags & PF_KTHREAD)) {
+	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
 		memset(childregs, 0, sizeof(struct pt_regs));
 		/* r24 <- fn, r25 <- arg */
 		ss->r24 = usp;
--- a/arch/ia64/kernel/process.c
+++ b/arch/ia64/kernel/process.c
@@ -338,7 +338,7 @@ copy_thread(unsigned long clone_flags, u
 
 	ia64_drop_fpu(p);	/* don't pick up stale state from a CPU's fph */
 
-	if (unlikely(p->flags & PF_KTHREAD)) {
+	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
 		if (unlikely(!user_stack_base)) {
 			/* fork_idle() called us */
 			return 0;
--- a/arch/m68k/kernel/process.c
+++ b/arch/m68k/kernel/process.c
@@ -157,7 +157,7 @@ int copy_thread(unsigned long clone_flag
 	 */
 	p->thread.fs = get_fs().seg;
 
-	if (unlikely(p->flags & PF_KTHREAD)) {
+	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
 		/* kernel thread */
 		memset(frame, 0, sizeof(struct fork_frame));
 		frame->regs.sr = PS_S;
--- a/arch/microblaze/kernel/process.c
+++ b/arch/microblaze/kernel/process.c
@@ -59,7 +59,7 @@ int copy_thread(unsigned long clone_flag
 	struct pt_regs *childregs = task_pt_regs(p);
 	struct thread_info *ti = task_thread_info(p);
 
-	if (unlikely(p->flags & PF_KTHREAD)) {
+	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
 		/* if we're creating a new kernel thread then just zeroing all
 		 * the registers. That's OK for a brand new thread.*/
 		memset(childregs, 0, sizeof(struct pt_regs));
--- a/arch/mips/kernel/process.c
+++ b/arch/mips/kernel/process.c
@@ -135,7 +135,7 @@ int copy_thread(unsigned long clone_flag
 	/*  Put the stack after the struct pt_regs.  */
 	childksp = (unsigned long) childregs;
 	p->thread.cp0_status = (read_c0_status() & ~(ST0_CU2|ST0_CU1)) | ST0_KERNEL_CUMASK;
-	if (unlikely(p->flags & PF_KTHREAD)) {
+	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
 		/* kernel thread */
 		unsigned long status = p->thread.cp0_status;
 		memset(childregs, 0, sizeof(struct pt_regs));
--- a/arch/nds32/kernel/process.c
+++ b/arch/nds32/kernel/process.c
@@ -156,7 +156,7 @@ int copy_thread(unsigned long clone_flag
 
 	memset(&p->thread.cpu_context, 0, sizeof(struct cpu_context));
 
-	if (unlikely(p->flags & PF_KTHREAD)) {
+	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
 		memset(childregs, 0, sizeof(struct pt_regs));
 		/* kernel thread fn */
 		p->thread.cpu_context.r6 = stack_start;
--- a/arch/nios2/kernel/process.c
+++ b/arch/nios2/kernel/process.c
@@ -109,7 +109,7 @@ int copy_thread(unsigned long clone_flag
 	struct switch_stack *childstack =
 		((struct switch_stack *)childregs) - 1;
 
-	if (unlikely(p->flags & PF_KTHREAD)) {
+	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
 		memset(childstack, 0,
 			sizeof(struct switch_stack) + sizeof(struct pt_regs));
 
--- a/arch/openrisc/kernel/process.c
+++ b/arch/openrisc/kernel/process.c
@@ -167,7 +167,7 @@ copy_thread(unsigned long clone_flags, u
 	sp -= sizeof(struct pt_regs);
 	kregs = (struct pt_regs *)sp;
 
-	if (unlikely(p->flags & PF_KTHREAD)) {
+	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
 		memset(kregs, 0, sizeof(struct pt_regs));
 		kregs->gpr[20] = usp; /* fn, kernel thread */
 		kregs->gpr[22] = arg;
--- a/arch/riscv/kernel/process.c
+++ b/arch/riscv/kernel/process.c
@@ -114,7 +114,7 @@ int copy_thread(unsigned long clone_flag
 	memset(&p->thread.s, 0, sizeof(p->thread.s));
 
 	/* p->thread holds context to be restored by __switch_to() */
-	if (unlikely(p->flags & PF_KTHREAD)) {
+	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
 		/* Kernel thread */
 		memset(childregs, 0, sizeof(struct pt_regs));
 		childregs->gp = gp_in_global;
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -127,7 +127,7 @@ int copy_thread(unsigned long clone_flag
 	frame->sf.gprs[9] = (unsigned long) frame;
 
 	/* Store access registers to kernel stack of new process. */
-	if (unlikely(p->flags & PF_KTHREAD)) {
+	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
 		/* kernel thread */
 		memset(&frame->childregs, 0, sizeof(struct pt_regs));
 		frame->childregs.psw.mask = PSW_KERNEL_BITS | PSW_MASK_DAT |
--- a/arch/sh/kernel/process_32.c
+++ b/arch/sh/kernel/process_32.c
@@ -114,7 +114,7 @@ int copy_thread(unsigned long clone_flag
 
 	childregs = task_pt_regs(p);
 	p->thread.sp = (unsigned long) childregs;
-	if (unlikely(p->flags & PF_KTHREAD)) {
+	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
 		memset(childregs, 0, sizeof(struct pt_regs));
 		p->thread.pc = (unsigned long) ret_from_kernel_thread;
 		childregs->regs[4] = arg;
--- a/arch/sparc/kernel/process_32.c
+++ b/arch/sparc/kernel/process_32.c
@@ -309,7 +309,7 @@ int copy_thread(unsigned long clone_flag
 	ti->ksp = (unsigned long) new_stack;
 	p->thread.kregs = childregs;
 
-	if (unlikely(p->flags & PF_KTHREAD)) {
+	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
 		extern int nwindows;
 		unsigned long psr;
 		memset(new_stack, 0, STACKFRAME_SZ + TRACEREG_SZ);
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -597,7 +597,7 @@ int copy_thread(unsigned long clone_flag
 				       sizeof(struct sparc_stackf));
 	t->fpsaved[0] = 0;
 
-	if (unlikely(p->flags & PF_KTHREAD)) {
+	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
 		memset(child_trap_frame, 0, child_stack_sz);
 		__thread_flag_byte_ptr(t)[TI_FLAG_BYTE_CWP] = 
 			(current_pt_regs()->tstate + 1) & TSTATE_CWP;
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -157,7 +157,7 @@ int copy_thread(unsigned long clone_flag
 		unsigned long arg, struct task_struct * p, unsigned long tls)
 {
 	void (*handler)(void);
-	int kthread = current->flags & PF_KTHREAD;
+	int kthread = current->flags & (PF_KTHREAD | PF_IO_WORKER);
 	int ret = 0;
 
 	p->thread = (struct thread_struct) INIT_THREAD;
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -162,7 +162,7 @@ int copy_thread(unsigned long clone_flag
 #endif
 
 	/* Kernel thread ? */
-	if (unlikely(p->flags & PF_KTHREAD)) {
+	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
 		memset(childregs, 0, sizeof(struct pt_regs));
 		kthread_frame_init(frame, sp, arg);
 		return 0;
--- a/arch/xtensa/kernel/process.c
+++ b/arch/xtensa/kernel/process.c
@@ -217,7 +217,7 @@ int copy_thread(unsigned long clone_flag
 
 	p->thread.sp = (unsigned long)childregs;
 
-	if (!(p->flags & PF_KTHREAD)) {
+	if (!(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
 		struct pt_regs *regs = current_pt_regs();
 		unsigned long usp = usp_thread_fn ?
 			usp_thread_fn : regs->areg[1];


