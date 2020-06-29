Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E58D20E6D0
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404499AbgF2Vux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:50:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726666AbgF2Sfk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B45B12476F;
        Mon, 29 Jun 2020 15:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444087;
        bh=aZX3bH4RlKLW5bh/pndxC1n7t5/JBse0G0JucZ29OCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B1tTum5Rs/zc+xqhP7PcTlSA01KnnXnlr3CDnNe2s171OczQwYWT5g7PG+BrReTsc
         6vlI/IXaRPA2C8/oEJdN7xXJzu+s9MUkDVQtvVtgS5QcooTu1CG93Ur2gzrCKmhTkR
         Bgd3Ob7PdVClrF/QoBIOO4WZzQr8vdAlqbNfC36A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 197/265] s390/ptrace: fix setting syscall number
Date:   Mon, 29 Jun 2020 11:17:10 -0400
Message-Id: <20200629151818.2493727-198-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

[ Upstream commit 873e5a763d604c32988c4a78913a8dab3862d2f9 ]

When strace wants to update the syscall number, it sets GPR2
to the desired number and updates the GPR via PTRACE_SETREGSET.
It doesn't update regs->int_code which would cause the old syscall
executed on syscall restart. As we cannot change the ptrace ABI and
don't have a field for the interruption code, check whether the tracee
is in a syscall and the last instruction was svc. In that case assume
that the tracer wants to update the syscall number and copy the GPR2
value to regs->int_code.

Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/ptrace.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index fca78b269349d..e007224b65bb2 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -324,6 +324,25 @@ static inline void __poke_user_per(struct task_struct *child,
 		child->thread.per_user.end = data;
 }
 
+static void fixup_int_code(struct task_struct *child, addr_t data)
+{
+	struct pt_regs *regs = task_pt_regs(child);
+	int ilc = regs->int_code >> 16;
+	u16 insn;
+
+	if (ilc > 6)
+		return;
+
+	if (ptrace_access_vm(child, regs->psw.addr - (regs->int_code >> 16),
+			&insn, sizeof(insn), FOLL_FORCE) != sizeof(insn))
+		return;
+
+	/* double check that tracee stopped on svc instruction */
+	if ((insn >> 8) != 0xa)
+		return;
+
+	regs->int_code = 0x20000 | (data & 0xffff);
+}
 /*
  * Write a word to the user area of a process at location addr. This
  * operation does have an additional problem compared to peek_user.
@@ -335,7 +354,9 @@ static int __poke_user(struct task_struct *child, addr_t addr, addr_t data)
 	struct user *dummy = NULL;
 	addr_t offset;
 
+
 	if (addr < (addr_t) &dummy->regs.acrs) {
+		struct pt_regs *regs = task_pt_regs(child);
 		/*
 		 * psw and gprs are stored on the stack
 		 */
@@ -353,7 +374,11 @@ static int __poke_user(struct task_struct *child, addr_t addr, addr_t data)
 				/* Invalid addressing mode bits */
 				return -EINVAL;
 		}
-		*(addr_t *)((addr_t) &task_pt_regs(child)->psw + addr) = data;
+
+		if (test_pt_regs_flag(regs, PIF_SYSCALL) &&
+			addr == offsetof(struct user, regs.gprs[2]))
+			fixup_int_code(child, data);
+		*(addr_t *)((addr_t) &regs->psw + addr) = data;
 
 	} else if (addr < (addr_t) (&dummy->regs.orig_gpr2)) {
 		/*
@@ -719,6 +744,10 @@ static int __poke_user_compat(struct task_struct *child,
 			regs->psw.mask = (regs->psw.mask & ~PSW_MASK_BA) |
 				(__u64)(tmp & PSW32_ADDR_AMODE);
 		} else {
+
+			if (test_pt_regs_flag(regs, PIF_SYSCALL) &&
+				addr == offsetof(struct compat_user, regs.gprs[2]))
+				fixup_int_code(child, data);
 			/* gpr 0-15 */
 			*(__u32*)((addr_t) &regs->psw + addr*2 + 4) = tmp;
 		}
-- 
2.25.1

