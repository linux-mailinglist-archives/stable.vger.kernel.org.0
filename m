Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9DAA212ECE
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 23:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726015AbgGBV0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 17:26:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725937AbgGBV0c (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jul 2020 17:26:32 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B27E212CC;
        Thu,  2 Jul 2020 21:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593725191;
        bh=ZU5bN8TFKsBpG7ffBzcNwKzyng+zc2xtVawCNyfX2Do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OMSPuUXRbnym3iADurHhuu+tR2caxUYLK0/6QPliNF1ijzRUfTUD1wJPFHf7xnZ4P
         PEjI6e8dn617nAh+gA0cIyFUcECAN0uZLGQCskk77sZHPYHI+772GKxJ6v9k4VEFbu
         UIXFVXuBiB4PvnlR19iZG4Yie7lxPa9vj+E3/g9w=
From:   Will Deacon <will@kernel.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Will Deacon <will@kernel.org>, kernel-team@android.com,
        Mark Rutland <mark.rutland@arm.com>,
        Luis Machado <luis.machado@linaro.org>,
        Keno Fischer <keno@juliacomputing.com>, stable@vger.kernel.org
Subject: [PATCH v2 3/4] arm64: Override SPSR.SS when single-stepping is enabled
Date:   Thu,  2 Jul 2020 22:26:17 +0100
Message-Id: <20200702212618.17800-4-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200702212618.17800-1-will@kernel.org>
References: <20200702212618.17800-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 arch/arm64/include/asm/debug-monitors.h |  2 ++
 arch/arm64/kernel/debug-monitors.c      | 20 ++++++++++++++++----
 arch/arm64/kernel/ptrace.c              |  4 ++--
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/debug-monitors.h b/arch/arm64/include/asm/debug-monitors.h
index e5ceea213e39..0b298f48f5bf 100644
--- a/arch/arm64/include/asm/debug-monitors.h
+++ b/arch/arm64/include/asm/debug-monitors.h
@@ -109,6 +109,8 @@ void disable_debug_monitors(enum dbg_active_el el);
 
 void user_rewind_single_step(struct task_struct *task);
 void user_fastforward_single_step(struct task_struct *task);
+void user_regs_reset_single_step(struct user_pt_regs *regs,
+				 struct task_struct *task);
 
 void kernel_enable_single_step(struct pt_regs *regs);
 void kernel_disable_single_step(void);
diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug-monitors.c
index 5df49366e9ab..91146c0a3691 100644
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
@@ -402,6 +405,15 @@ void user_fastforward_single_step(struct task_struct *task)
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
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 7b46caea1278..89fbee3991a2 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -1959,8 +1959,8 @@ static int valid_native_regs(struct user_pt_regs *regs)
  */
 int valid_user_regs(struct user_pt_regs *regs, struct task_struct *task)
 {
-	if (!test_tsk_thread_flag(task, TIF_SINGLESTEP))
-		regs->pstate &= ~DBG_SPSR_SS;
+	/* https://lore.kernel.org/lkml/20191118131525.GA4180@willie-the-truck */
+	user_regs_reset_single_step(regs, task);
 
 	if (is_compat_thread(task_thread_info(task)))
 		return valid_compat_regs(regs);
-- 
2.27.0.212.ge8ba1cc988-goog

