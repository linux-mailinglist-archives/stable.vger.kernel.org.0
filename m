Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6691A9D96
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409252AbgDOLqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:46:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:40462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409235AbgDOLp5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:45:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6B95206A2;
        Wed, 15 Apr 2020 11:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951157;
        bh=sscrRof2T2gOXm1DhhLMfhcfPs75brf/YmFVxd4ypA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eJFXgNSfYZma71e7veKU0jKfSkx5d3koLQphOU/zBanxDw14yiqOoh+hNGGWdIS7i
         hCM68MbY2/kQJPA6+UMjYF6uMNT5n9DSw6NdTTIUxS6mXtAIXp0XApk5UGtz1FWPq7
         k8j/n46V2RuqxfRSPVwql5BzsQajPAhP8KgRThSE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guo Ren <guoren@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>, linux-csky@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 63/84] csky: Fixup get wrong psr value from phyical reg
Date:   Wed, 15 Apr 2020 07:44:20 -0400
Message-Id: <20200415114442.14166-63-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114442.14166-1-sashal@kernel.org>
References: <20200415114442.14166-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

[ Upstream commit 9c0e343d7654a329d1f9b53d253cbf7fb6eff85d ]

We should get psr value from regs->psr in stack, not directly get
it from phyiscal register then save the vector number in
tsk->trap_no.

Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/csky/include/asm/processor.h |  1 +
 arch/csky/kernel/traps.c          | 11 ++++++++++-
 arch/csky/mm/fault.c              |  7 +++++++
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/csky/include/asm/processor.h b/arch/csky/include/asm/processor.h
index 21e0bd5293dde..c6bcd7f7c720b 100644
--- a/arch/csky/include/asm/processor.h
+++ b/arch/csky/include/asm/processor.h
@@ -43,6 +43,7 @@ extern struct cpuinfo_csky cpu_data[];
 struct thread_struct {
 	unsigned long  ksp;       /* kernel stack pointer */
 	unsigned long  sr;        /* saved status register */
+	unsigned long  trap_no;   /* saved status register */
 
 	/* FPU regs */
 	struct user_fp __aligned(16) user_fp;
diff --git a/arch/csky/kernel/traps.c b/arch/csky/kernel/traps.c
index b057480e7463c..63715cb90ee99 100644
--- a/arch/csky/kernel/traps.c
+++ b/arch/csky/kernel/traps.c
@@ -115,8 +115,9 @@ asmlinkage void trap_c(struct pt_regs *regs)
 	int sig;
 	unsigned long vector;
 	siginfo_t info;
+	struct task_struct *tsk = current;
 
-	vector = (mfcr("psr") >> 16) & 0xff;
+	vector = (regs->sr >> 16) & 0xff;
 
 	switch (vector) {
 	case VEC_ZERODIV:
@@ -129,6 +130,7 @@ asmlinkage void trap_c(struct pt_regs *regs)
 		sig = SIGTRAP;
 		break;
 	case VEC_ILLEGAL:
+		tsk->thread.trap_no = vector;
 		die_if_kernel("Kernel mode ILLEGAL", regs, vector);
 #ifndef CONFIG_CPU_NO_USER_BKPT
 		if (*(uint16_t *)instruction_pointer(regs) != USR_BKPT)
@@ -146,16 +148,20 @@ asmlinkage void trap_c(struct pt_regs *regs)
 		sig = SIGTRAP;
 		break;
 	case VEC_ACCESS:
+		tsk->thread.trap_no = vector;
 		return buserr(regs);
 #ifdef CONFIG_CPU_NEED_SOFTALIGN
 	case VEC_ALIGN:
+		tsk->thread.trap_no = vector;
 		return csky_alignment(regs);
 #endif
 #ifdef CONFIG_CPU_HAS_FPU
 	case VEC_FPE:
+		tsk->thread.trap_no = vector;
 		die_if_kernel("Kernel mode FPE", regs, vector);
 		return fpu_fpe(regs);
 	case VEC_PRIV:
+		tsk->thread.trap_no = vector;
 		die_if_kernel("Kernel mode PRIV", regs, vector);
 		if (fpu_libc_helper(regs))
 			return;
@@ -164,5 +170,8 @@ asmlinkage void trap_c(struct pt_regs *regs)
 		sig = SIGSEGV;
 		break;
 	}
+
+	tsk->thread.trap_no = vector;
+
 	send_sig(sig, current, 0);
 }
diff --git a/arch/csky/mm/fault.c b/arch/csky/mm/fault.c
index f76618b630f91..562c7f7087490 100644
--- a/arch/csky/mm/fault.c
+++ b/arch/csky/mm/fault.c
@@ -179,11 +179,14 @@ asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long write,
 bad_area_nosemaphore:
 	/* User mode accesses just cause a SIGSEGV */
 	if (user_mode(regs)) {
+		tsk->thread.trap_no = (regs->sr >> 16) & 0xff;
 		force_sig_fault(SIGSEGV, si_code, (void __user *)address);
 		return;
 	}
 
 no_context:
+	tsk->thread.trap_no = (regs->sr >> 16) & 0xff;
+
 	/* Are we prepared to handle this kernel fault? */
 	if (fixup_exception(regs))
 		return;
@@ -198,6 +201,8 @@ asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long write,
 	die_if_kernel("Oops", regs, write);
 
 out_of_memory:
+	tsk->thread.trap_no = (regs->sr >> 16) & 0xff;
+
 	/*
 	 * We ran out of memory, call the OOM killer, and return the userspace
 	 * (which will retry the fault, or kill us if we got oom-killed).
@@ -206,6 +211,8 @@ asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long write,
 	return;
 
 do_sigbus:
+	tsk->thread.trap_no = (regs->sr >> 16) & 0xff;
+
 	up_read(&mm->mmap_sem);
 
 	/* Kernel mode? Handle exceptions or die */
-- 
2.20.1

