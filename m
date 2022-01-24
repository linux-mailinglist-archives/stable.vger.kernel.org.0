Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF359499213
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380926AbiAXURV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:17:21 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54100 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354844AbiAXUMs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:12:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B846B8122C;
        Mon, 24 Jan 2022 20:12:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F252C36AF7;
        Mon, 24 Jan 2022 20:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055165;
        bh=OyAxWRyTORWwfydUXk/mk1xaM+bjpiLPUqUmxODiws8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OelarNXx1G+nrnz2qn0SyShP2nPLRfv7koAsN1AlqtVneHA1lLEOl7w2oM54C/2PB
         JjKUEeR1ezFlksuUm78c/A6S63pMeMBgNP5KlIMmpNyKX5e8v50EvoLfE9w9XlSt9T
         nV6QKQE3ln1p5AIEgmzA8yXQDIZlJYNUxgGE4HNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        D Scott Phillips <scott@os.amperecomputing.com>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.15 062/846] arm64: errata: Fix exec handling in erratum 1418040 workaround
Date:   Mon, 24 Jan 2022 19:32:59 +0100
Message-Id: <20220124184103.109839229@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/process.c |   39 ++++++++++++++++-----------------------
 1 file changed, 16 insertions(+), 23 deletions(-)

--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -439,34 +439,26 @@ static void entry_task_switch(struct tas
 
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
@@ -501,7 +493,7 @@ __notrace_funcgraph struct task_struct *
 	contextidr_thread_switch(next);
 	entry_task_switch(next);
 	ssbs_thread_switch(next);
-	erratum_1418040_thread_switch(prev, next);
+	erratum_1418040_thread_switch(next);
 	ptrauth_thread_switch_user(next);
 
 	/*
@@ -613,6 +605,7 @@ void arch_setup_new_exec(void)
 	current->mm->context.flags = mmflags;
 	ptrauth_thread_init_user();
 	mte_thread_init_user();
+	erratum_1418040_new_exec();
 
 	if (task_spec_ssb_noexec(current)) {
 		arch_prctl_spec_ctrl_set(current, PR_SPEC_STORE_BYPASS,


