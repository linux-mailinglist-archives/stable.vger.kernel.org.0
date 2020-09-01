Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5052B2594CB
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731640AbgIAPnI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:43:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731630AbgIAPnE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:43:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D58AD2064B;
        Tue,  1 Sep 2020 15:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974983;
        bh=rpauGeZABoOovO9KdfgP02+QEUTjAZ89+rWMnfA0VKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aoPb+Z+9/5V0Ih82OZdIUFkuBp6H/iu3aMwK2OvKHjHxTyPbtxUpaZOFIPd/BSbVl
         y/TiEdp8EoFWJggHxAH//3u3lQm0orhJIx9xL8ICfh7vYi3eJ1ElVp9w56VaNnu3iW
         tkp2OhkeUpL59s/w17kCCEM2UEgWKzVxx4SM1XKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 165/255] arm64: Move handling of erratum 1418040 into C code
Date:   Tue,  1 Sep 2020 17:10:21 +0200
Message-Id: <20200901151008.600564125@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit d49f7d7376d0c0daf8680984a37bd07581ac7d38 ]

Instead of dealing with erratum 1418040 on each entry and exit,
let's move the handling to __switch_to() instead, which has
several advantages:

- It can be applied when it matters (switching between 32 and 64
  bit tasks).
- It is written in C (yay!)
- It can rely on static keys rather than alternatives

Signed-off-by: Marc Zyngier <maz@kernel.org>
Tested-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20200731173824.107480-2-maz@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/entry.S   | 21 ---------------------
 arch/arm64/kernel/process.c | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 35de8ba60e3d5..44445d471442d 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -169,19 +169,6 @@ alternative_cb_end
 	stp	x28, x29, [sp, #16 * 14]
 
 	.if	\el == 0
-	.if	\regsize == 32
-	/*
-	 * If we're returning from a 32-bit task on a system affected by
-	 * 1418040 then re-enable userspace access to the virtual counter.
-	 */
-#ifdef CONFIG_ARM64_ERRATUM_1418040
-alternative_if ARM64_WORKAROUND_1418040
-	mrs	x0, cntkctl_el1
-	orr	x0, x0, #2	// ARCH_TIMER_USR_VCT_ACCESS_EN
-	msr	cntkctl_el1, x0
-alternative_else_nop_endif
-#endif
-	.endif
 	clear_gp_regs
 	mrs	x21, sp_el0
 	ldr_this_cpu	tsk, __entry_task, x20
@@ -337,14 +324,6 @@ alternative_else_nop_endif
 	tst	x22, #PSR_MODE32_BIT		// native task?
 	b.eq	3f
 
-#ifdef CONFIG_ARM64_ERRATUM_1418040
-alternative_if ARM64_WORKAROUND_1418040
-	mrs	x0, cntkctl_el1
-	bic	x0, x0, #2			// ARCH_TIMER_USR_VCT_ACCESS_EN
-	msr	cntkctl_el1, x0
-alternative_else_nop_endif
-#endif
-
 #ifdef CONFIG_ARM64_ERRATUM_845719
 alternative_if ARM64_WORKAROUND_845719
 #ifdef CONFIG_PID_IN_CONTEXTIDR
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 6089638c7d43f..d8a10cf28f827 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -515,6 +515,39 @@ static void entry_task_switch(struct task_struct *next)
 	__this_cpu_write(__entry_task, next);
 }
 
+/*
+ * ARM erratum 1418040 handling, affecting the 32bit view of CNTVCT.
+ * Assuming the virtual counter is enabled at the beginning of times:
+ *
+ * - disable access when switching from a 64bit task to a 32bit task
+ * - enable access when switching from a 32bit task to a 64bit task
+ */
+static void erratum_1418040_thread_switch(struct task_struct *prev,
+					  struct task_struct *next)
+{
+	bool prev32, next32;
+	u64 val;
+
+	if (!(IS_ENABLED(CONFIG_ARM64_ERRATUM_1418040) &&
+	      cpus_have_const_cap(ARM64_WORKAROUND_1418040)))
+		return;
+
+	prev32 = is_compat_thread(task_thread_info(prev));
+	next32 = is_compat_thread(task_thread_info(next));
+
+	if (prev32 == next32)
+		return;
+
+	val = read_sysreg(cntkctl_el1);
+
+	if (!next32)
+		val |= ARCH_TIMER_USR_VCT_ACCESS_EN;
+	else
+		val &= ~ARCH_TIMER_USR_VCT_ACCESS_EN;
+
+	write_sysreg(val, cntkctl_el1);
+}
+
 /*
  * Thread switching.
  */
@@ -530,6 +563,7 @@ __notrace_funcgraph struct task_struct *__switch_to(struct task_struct *prev,
 	entry_task_switch(next);
 	uao_thread_switch(next);
 	ssbs_thread_switch(next);
+	erratum_1418040_thread_switch(prev, next);
 
 	/*
 	 * Complete any pending TLB or cache maintenance on this CPU in case
-- 
2.25.1



