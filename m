Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B70B57F89D
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393521AbfHBNVE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:21:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:59576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393513AbfHBNVB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:21:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B07FD21874;
        Fri,  2 Aug 2019 13:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752060;
        bh=f8G2/wd67YDwZwe/iPPwCfXyLCn6p/rf/hjQ1CysWqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y+0QzwJtWVb7AXzB2ZbIZZ7oCFJdygy+RnV3QdAeQBUF5yWdq7eyIGWejNgJETQpC
         JVa++9wji2X4VWJiMn7x1gg9ugmsB3ylw1/S/FOWIIhxaFvLNhWk053gcM2JfyYa2v
         vFr7RAy5zmobJygv1St9dqsY0dNOJ4rsPJiCRfZo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 38/76] arm64: Force SSBS on context switch
Date:   Fri,  2 Aug 2019 09:19:12 -0400
Message-Id: <20190802131951.11600-38-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802131951.11600-1-sashal@kernel.org>
References: <20190802131951.11600-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

[ Upstream commit cbdf8a189a66001c36007bf0f5c975d0376c5c3a ]

On a CPU that doesn't support SSBS, PSTATE[12] is RES0.  In a system
where only some of the CPUs implement SSBS, we end-up losing track of
the SSBS bit across task migration.

To address this issue, let's force the SSBS bit on context switch.

Fixes: 8f04e8e6e29c ("arm64: ssbd: Add support for PSTATE.SSBS rather than trapping to EL3")
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
[will: inverted logic and added comments]
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/processor.h | 14 ++++++++++++--
 arch/arm64/kernel/process.c        | 29 ++++++++++++++++++++++++++++-
 2 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index fd5b1a4efc70e..844e2964b0f5e 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -193,6 +193,16 @@ static inline void start_thread_common(struct pt_regs *regs, unsigned long pc)
 		regs->pmr_save = GIC_PRIO_IRQON;
 }
 
+static inline void set_ssbs_bit(struct pt_regs *regs)
+{
+	regs->pstate |= PSR_SSBS_BIT;
+}
+
+static inline void set_compat_ssbs_bit(struct pt_regs *regs)
+{
+	regs->pstate |= PSR_AA32_SSBS_BIT;
+}
+
 static inline void start_thread(struct pt_regs *regs, unsigned long pc,
 				unsigned long sp)
 {
@@ -200,7 +210,7 @@ static inline void start_thread(struct pt_regs *regs, unsigned long pc,
 	regs->pstate = PSR_MODE_EL0t;
 
 	if (arm64_get_ssbd_state() != ARM64_SSBD_FORCE_ENABLE)
-		regs->pstate |= PSR_SSBS_BIT;
+		set_ssbs_bit(regs);
 
 	regs->sp = sp;
 }
@@ -219,7 +229,7 @@ static inline void compat_start_thread(struct pt_regs *regs, unsigned long pc,
 #endif
 
 	if (arm64_get_ssbd_state() != ARM64_SSBD_FORCE_ENABLE)
-		regs->pstate |= PSR_AA32_SSBS_BIT;
+		set_compat_ssbs_bit(regs);
 
 	regs->compat_sp = sp;
 }
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 6a869d9f304f7..b0c859ca63201 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -398,7 +398,7 @@ int copy_thread(unsigned long clone_flags, unsigned long stack_start,
 			childregs->pstate |= PSR_UAO_BIT;
 
 		if (arm64_get_ssbd_state() == ARM64_SSBD_FORCE_DISABLE)
-			childregs->pstate |= PSR_SSBS_BIT;
+			set_ssbs_bit(childregs);
 
 		if (system_uses_irq_prio_masking())
 			childregs->pmr_save = GIC_PRIO_IRQON;
@@ -442,6 +442,32 @@ void uao_thread_switch(struct task_struct *next)
 	}
 }
 
+/*
+ * Force SSBS state on context-switch, since it may be lost after migrating
+ * from a CPU which treats the bit as RES0 in a heterogeneous system.
+ */
+static void ssbs_thread_switch(struct task_struct *next)
+{
+	struct pt_regs *regs = task_pt_regs(next);
+
+	/*
+	 * Nothing to do for kernel threads, but 'regs' may be junk
+	 * (e.g. idle task) so check the flags and bail early.
+	 */
+	if (unlikely(next->flags & PF_KTHREAD))
+		return;
+
+	/* If the mitigation is enabled, then we leave SSBS clear. */
+	if ((arm64_get_ssbd_state() == ARM64_SSBD_FORCE_ENABLE) ||
+	    test_tsk_thread_flag(next, TIF_SSBD))
+		return;
+
+	if (compat_user_mode(regs))
+		set_compat_ssbs_bit(regs);
+	else if (user_mode(regs))
+		set_ssbs_bit(regs);
+}
+
 /*
  * We store our current task in sp_el0, which is clobbered by userspace. Keep a
  * shadow copy so that we can restore this upon entry from userspace.
@@ -471,6 +497,7 @@ __notrace_funcgraph struct task_struct *__switch_to(struct task_struct *prev,
 	entry_task_switch(next);
 	uao_thread_switch(next);
 	ptrauth_thread_switch(next);
+	ssbs_thread_switch(next);
 
 	/*
 	 * Complete any pending TLB or cache maintenance on this CPU in case
-- 
2.20.1

