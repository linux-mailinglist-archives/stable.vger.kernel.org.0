Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAC70291F61
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 22:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727739AbgJRTSk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:18:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727721AbgJRTSh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:18:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CED7B222C8;
        Sun, 18 Oct 2020 19:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048716;
        bh=AHB07H4g+FtQrevFC36rhkGgxQARMUiGwshddXeFTJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mlMCOP2usb+d7uWiwrb2ZfLoujO70GuHtXCf9omwmesQyrBQaIALrHpVcqofyqcXR
         XiL6EmnVwTQCdN5H7VrPzXynojLTOM42um0AVgy+Vyx/tWVyUdjTeEqCcP/k1CiD5K
         bqmYA2m9RLNIIOlidiM8AIpssFOkTNdaJWC0Wdrc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.9 023/111] x86/mce: Make mce_rdmsrl() panic on an inaccessible MSR
Date:   Sun, 18 Oct 2020 15:16:39 -0400
Message-Id: <20201018191807.4052726-23-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018191807.4052726-1-sashal@kernel.org>
References: <20201018191807.4052726-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit e2def7d49d0812ea40a224161b2001b2e815dce2 ]

If an exception needs to be handled while reading an MSR - which is in
most of the cases caused by a #GP on a non-existent MSR - then this
is most likely the incarnation of a BIOS or a hardware bug. Such bug
violates the architectural guarantee that MCA banks are present with all
MSRs belonging to them.

The proper fix belongs in the hardware/firmware - not in the kernel.

Handling an #MC exception which is raised while an NMI is being handled
would cause the nasty NMI nesting issue because of the shortcoming of
IRET of reenabling NMIs when executed. And the machine is in an #MC
context already so <Deity> be at its side.

Tracing MSR accesses while in #MC is another no-no due to tracing being
inherently a bad idea in atomic context:

  vmlinux.o: warning: objtool: do_machine_check()+0x4a: call to mce_rdmsrl() leaves .noinstr.text section

so remove all that "additional" functionality from mce_rdmsrl() and
provide it with a special exception handler which panics the machine
when that MSR is not accessible.

The exception handler prints a human-readable message explaining what
the panic reason is but, what is more, it panics while in the #GP
handler and latter won't have executed an IRET, thus opening the NMI
nesting issue in the case when the #MC has happened while handling
an NMI. (#MC itself won't be reenabled until MCG_STATUS hasn't been
cleared).

Suggested-by: Andy Lutomirski <luto@kernel.org>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
[ Add missing prototypes for ex_handler_* ]
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Link: https://lkml.kernel.org/r/20200906212130.GA28456@zn.tnic
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mce/core.c     | 72 +++++++++++++++++++++++++-----
 arch/x86/kernel/cpu/mce/internal.h | 10 +++++
 2 files changed, 70 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 4288645425f15..84eef4fa95990 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -373,10 +373,28 @@ static int msr_to_offset(u32 msr)
 	return -1;
 }
 
+__visible bool ex_handler_rdmsr_fault(const struct exception_table_entry *fixup,
+				      struct pt_regs *regs, int trapnr,
+				      unsigned long error_code,
+				      unsigned long fault_addr)
+{
+	pr_emerg("MSR access error: RDMSR from 0x%x at rIP: 0x%lx (%pS)\n",
+		 (unsigned int)regs->cx, regs->ip, (void *)regs->ip);
+
+	show_stack_regs(regs);
+
+	panic("MCA architectural violation!\n");
+
+	while (true)
+		cpu_relax();
+
+	return true;
+}
+
 /* MSR access wrappers used for error injection */
 static noinstr u64 mce_rdmsrl(u32 msr)
 {
-	u64 v;
+	DECLARE_ARGS(val, low, high);
 
 	if (__this_cpu_read(injectm.finished)) {
 		int offset;
@@ -395,21 +413,43 @@ static noinstr u64 mce_rdmsrl(u32 msr)
 		return ret;
 	}
 
-	if (rdmsrl_safe(msr, &v)) {
-		WARN_ONCE(1, "mce: Unable to read MSR 0x%x!\n", msr);
-		/*
-		 * Return zero in case the access faulted. This should
-		 * not happen normally but can happen if the CPU does
-		 * something weird, or if the code is buggy.
-		 */
-		v = 0;
-	}
+	/*
+	 * RDMSR on MCA MSRs should not fault. If they do, this is very much an
+	 * architectural violation and needs to be reported to hw vendor. Panic
+	 * the box to not allow any further progress.
+	 */
+	asm volatile("1: rdmsr\n"
+		     "2:\n"
+		     _ASM_EXTABLE_HANDLE(1b, 2b, ex_handler_rdmsr_fault)
+		     : EAX_EDX_RET(val, low, high) : "c" (msr));
 
-	return v;
+
+	return EAX_EDX_VAL(val, low, high);
+}
+
+__visible bool ex_handler_wrmsr_fault(const struct exception_table_entry *fixup,
+				      struct pt_regs *regs, int trapnr,
+				      unsigned long error_code,
+				      unsigned long fault_addr)
+{
+	pr_emerg("MSR access error: WRMSR to 0x%x (tried to write 0x%08x%08x) at rIP: 0x%lx (%pS)\n",
+		 (unsigned int)regs->cx, (unsigned int)regs->dx, (unsigned int)regs->ax,
+		  regs->ip, (void *)regs->ip);
+
+	show_stack_regs(regs);
+
+	panic("MCA architectural violation!\n");
+
+	while (true)
+		cpu_relax();
+
+	return true;
 }
 
 static noinstr void mce_wrmsrl(u32 msr, u64 v)
 {
+	u32 low, high;
+
 	if (__this_cpu_read(injectm.finished)) {
 		int offset;
 
@@ -423,7 +463,15 @@ static noinstr void mce_wrmsrl(u32 msr, u64 v)
 
 		return;
 	}
-	wrmsrl(msr, v);
+
+	low  = (u32)v;
+	high = (u32)(v >> 32);
+
+	/* See comment in mce_rdmsrl() */
+	asm volatile("1: wrmsr\n"
+		     "2:\n"
+		     _ASM_EXTABLE_HANDLE(1b, 2b, ex_handler_wrmsr_fault)
+		     : : "c" (msr), "a"(low), "d" (high) : "memory");
 }
 
 /*
diff --git a/arch/x86/kernel/cpu/mce/internal.h b/arch/x86/kernel/cpu/mce/internal.h
index 6473070b5da49..b122610e9046a 100644
--- a/arch/x86/kernel/cpu/mce/internal.h
+++ b/arch/x86/kernel/cpu/mce/internal.h
@@ -185,4 +185,14 @@ extern bool amd_filter_mce(struct mce *m);
 static inline bool amd_filter_mce(struct mce *m)			{ return false; };
 #endif
 
+__visible bool ex_handler_rdmsr_fault(const struct exception_table_entry *fixup,
+				      struct pt_regs *regs, int trapnr,
+				      unsigned long error_code,
+				      unsigned long fault_addr);
+
+__visible bool ex_handler_wrmsr_fault(const struct exception_table_entry *fixup,
+				      struct pt_regs *regs, int trapnr,
+				      unsigned long error_code,
+				      unsigned long fault_addr);
+
 #endif /* __X86_MCE_INTERNAL_H__ */
-- 
2.25.1

