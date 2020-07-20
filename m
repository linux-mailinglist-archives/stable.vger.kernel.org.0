Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0642268F6
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732644AbgGTQXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:23:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:40862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732690AbgGTQFY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:05:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 109842065E;
        Mon, 20 Jul 2020 16:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261123;
        bh=UHTBCsg/QqgvyNMNI2gyYcukzr/gTi8xEjWWr4Et+xA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ufn+tk/gv8QQFk8btnDubpQmCyi2mkt5Gq2sT0TVC/6E7sI5jiNRmoD/d/XQkBhMO
         LgFiG0yljjPiJa4PsFhEGgtzIzxKP7qZZCG+fu4iJ9dr4Jn81K8BaYGNL7FbMqcR2r
         0Zv3h/tNwx5idWQfGl3apIS/K2JUcIAnstWXTHXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Keno Fischer <keno@juliacomputing.com>,
        Luis Machado <luis.machado@linaro.org>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.4 199/215] arm64: ptrace: Override SPSR.SS when single-stepping is enabled
Date:   Mon, 20 Jul 2020 17:38:01 +0200
Message-Id: <20200720152829.633398618@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

commit 3a5a4366cecc25daa300b9a9174f7fdd352b9068 upstream.

Luis reports that, when reverse debugging with GDB, single-step does not
function as expected on arm64:

  | I've noticed, under very specific conditions, that a PTRACE_SINGLESTEP
  | request by GDB won't execute the underlying instruction. As a consequence,
  | the PC doesn't move, but we return a SIGTRAP just like we would for a
  | regular successful PTRACE_SINGLESTEP request.

The underlying problem is that when the CPU register state is restored
as part of a reverse step, the SPSR.SS bit is cleared and so the hardware
single-step state can transition to the "active-pending" state, causing
an unexpected step exception to be taken immediately if a step operation
is attempted.

In hindsight, we probably shouldn't have exposed SPSR.SS in the pstate
accessible by the GPR regset, but it's a bit late for that now. Instead,
simply prevent userspace from configuring the bit to a value which is
inconsistent with the TIF_SINGLESTEP state for the task being traced.

Cc: <stable@vger.kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Keno Fischer <keno@juliacomputing.com>
Link: https://lore.kernel.org/r/1eed6d69-d53d-9657-1fc9-c089be07f98c@linaro.org
Reported-by: Luis Machado <luis.machado@linaro.org>
Tested-by: Luis Machado <luis.machado@linaro.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/debug-monitors.h |    2 ++
 arch/arm64/kernel/debug-monitors.c      |   20 ++++++++++++++++----
 arch/arm64/kernel/ptrace.c              |    4 ++--
 3 files changed, 20 insertions(+), 6 deletions(-)

--- a/arch/arm64/include/asm/debug-monitors.h
+++ b/arch/arm64/include/asm/debug-monitors.h
@@ -109,6 +109,8 @@ void disable_debug_monitors(enum dbg_act
 
 void user_rewind_single_step(struct task_struct *task);
 void user_fastforward_single_step(struct task_struct *task);
+void user_regs_reset_single_step(struct user_pt_regs *regs,
+				 struct task_struct *task);
 
 void kernel_enable_single_step(struct pt_regs *regs);
 void kernel_disable_single_step(void);
--- a/arch/arm64/kernel/debug-monitors.c
+++ b/arch/arm64/kernel/debug-monitors.c
@@ -141,17 +141,20 @@ postcore_initcall(debug_monitors_init);
 /*
  * Single step API and exception handling.
  */
-static void set_regs_spsr_ss(struct pt_regs *regs)
+static void set_user_regs_spsr_ss(struct user_pt_regs *regs)
 {
 	regs->pstate |= DBG_SPSR_SS;
 }
-NOKPROBE_SYMBOL(set_regs_spsr_ss);
+NOKPROBE_SYMBOL(set_user_regs_spsr_ss);
 
-static void clear_regs_spsr_ss(struct pt_regs *regs)
+static void clear_user_regs_spsr_ss(struct user_pt_regs *regs)
 {
 	regs->pstate &= ~DBG_SPSR_SS;
 }
-NOKPROBE_SYMBOL(clear_regs_spsr_ss);
+NOKPROBE_SYMBOL(clear_user_regs_spsr_ss);
+
+#define set_regs_spsr_ss(r)	set_user_regs_spsr_ss(&(r)->user_regs)
+#define clear_regs_spsr_ss(r)	clear_user_regs_spsr_ss(&(r)->user_regs)
 
 static DEFINE_SPINLOCK(debug_hook_lock);
 static LIST_HEAD(user_step_hook);
@@ -404,6 +407,15 @@ void user_fastforward_single_step(struct
 		clear_regs_spsr_ss(task_pt_regs(task));
 }
 
+void user_regs_reset_single_step(struct user_pt_regs *regs,
+				 struct task_struct *task)
+{
+	if (test_tsk_thread_flag(task, TIF_SINGLESTEP))
+		set_user_regs_spsr_ss(regs);
+	else
+		clear_user_regs_spsr_ss(regs);
+}
+
 /* Kernel API */
 void kernel_enable_single_step(struct pt_regs *regs)
 {
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -1935,8 +1935,8 @@ static int valid_native_regs(struct user
  */
 int valid_user_regs(struct user_pt_regs *regs, struct task_struct *task)
 {
-	if (!test_tsk_thread_flag(task, TIF_SINGLESTEP))
-		regs->pstate &= ~DBG_SPSR_SS;
+	/* https://lore.kernel.org/lkml/20191118131525.GA4180@willie-the-truck */
+	user_regs_reset_single_step(regs, task);
 
 	if (is_compat_thread(task_thread_info(task)))
 		return valid_compat_regs(regs);


