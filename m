Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB7574A0076
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 19:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238277AbiA1SyP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 13:54:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbiA1SyO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 13:54:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4D6C061714
        for <stable@vger.kernel.org>; Fri, 28 Jan 2022 10:54:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4651B61BF2
        for <stable@vger.kernel.org>; Fri, 28 Jan 2022 18:54:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978F8C340E7;
        Fri, 28 Jan 2022 18:54:12 +0000 (UTC)
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     D Scott Phillips <scott@os.amperecomputing.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH stable-5.4] arm64: errata: Fix exec handling in erratum 1418040 workaround
Date:   Fri, 28 Jan 2022 18:54:10 +0000
Message-Id: <20220128185410.1729965-1-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: D Scott Phillips <scott@os.amperecomputing.com>

commit 38e0257e0e6f4fef2aa2966b089b56a8b1cfb75c upstream.

The erratum 1418040 workaround enables CNTVCT_EL1 access trapping in EL0
when executing compat threads. The workaround is applied when switching
between tasks, but the need for the workaround could also change at an
exec(), when a non-compat task execs a compat binary or vice versa. Apply
the workaround in arch_setup_new_exec().

This leaves a small window of time between SET_PERSONALITY and
arch_setup_new_exec where preemption could occur and confuse the old
workaround logic that compares TIF_32BIT between prev and next. Instead, we
can just read cntkctl to make sure it's in the state that the next task
needs. I measured cntkctl read time to be about the same as a mov from a
general-purpose register on N1. Update the workaround logic to examine the
current value of cntkctl instead of the previous task's compat state.

Fixes: d49f7d7376d0 ("arm64: Move handling of erratum 1418040 into C code")
Cc: <stable@vger.kernel.org> # 5.9.x
Signed-off-by: D Scott Phillips <scott@os.amperecomputing.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20211220234114.3926-1-scott@os.amperecomputing.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/kernel/process.c | 39 +++++++++++++++----------------------
 1 file changed, 16 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index f61ef46ebff7..d07fbc21f14c 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -500,34 +500,26 @@ static void entry_task_switch(struct task_struct *next)
 
 /*
  * ARM erratum 1418040 handling, affecting the 32bit view of CNTVCT.
- * Assuming the virtual counter is enabled at the beginning of times:
- *
- * - disable access when switching from a 64bit task to a 32bit task
- * - enable access when switching from a 32bit task to a 64bit task
+ * Ensure access is disabled when switching to a 32bit task, ensure
+ * access is enabled when switching to a 64bit task.
  */
-static void erratum_1418040_thread_switch(struct task_struct *prev,
-					  struct task_struct *next)
+static void erratum_1418040_thread_switch(struct task_struct *next)
 {
-	bool prev32, next32;
-	u64 val;
-
-	if (!IS_ENABLED(CONFIG_ARM64_ERRATUM_1418040))
-		return;
-
-	prev32 = is_compat_thread(task_thread_info(prev));
-	next32 = is_compat_thread(task_thread_info(next));
-
-	if (prev32 == next32 || !this_cpu_has_cap(ARM64_WORKAROUND_1418040))
+	if (!IS_ENABLED(CONFIG_ARM64_ERRATUM_1418040) ||
+	    !this_cpu_has_cap(ARM64_WORKAROUND_1418040))
 		return;
 
-	val = read_sysreg(cntkctl_el1);
-
-	if (!next32)
-		val |= ARCH_TIMER_USR_VCT_ACCESS_EN;
+	if (is_compat_thread(task_thread_info(next)))
+		sysreg_clear_set(cntkctl_el1, ARCH_TIMER_USR_VCT_ACCESS_EN, 0);
 	else
-		val &= ~ARCH_TIMER_USR_VCT_ACCESS_EN;
+		sysreg_clear_set(cntkctl_el1, 0, ARCH_TIMER_USR_VCT_ACCESS_EN);
+}
 
-	write_sysreg(val, cntkctl_el1);
+static void erratum_1418040_new_exec(void)
+{
+	preempt_disable();
+	erratum_1418040_thread_switch(current);
+	preempt_enable();
 }
 
 /*
@@ -546,7 +538,7 @@ __notrace_funcgraph struct task_struct *__switch_to(struct task_struct *prev,
 	uao_thread_switch(next);
 	ptrauth_thread_switch(next);
 	ssbs_thread_switch(next);
-	erratum_1418040_thread_switch(prev, next);
+	erratum_1418040_thread_switch(next);
 
 	/*
 	 * Complete any pending TLB or cache maintenance on this CPU in case
@@ -605,6 +597,7 @@ void arch_setup_new_exec(void)
 	current->mm->context.flags = is_compat_task() ? MMCF_AARCH32 : 0;
 
 	ptrauth_thread_init_user(current);
+	erratum_1418040_new_exec();
 }
 
 #ifdef CONFIG_ARM64_TAGGED_ADDR_ABI
