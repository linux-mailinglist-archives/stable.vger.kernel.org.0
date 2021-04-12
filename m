Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A4C35BFF9
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238039AbhDLJIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:08:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238913AbhDLJGX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:06:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F7AA6137F;
        Mon, 12 Apr 2021 09:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218196;
        bh=xTY+pPggyyj25HYO7EgzLR40iVeg3onhNX2XEBX9FUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qWn9nJlswEIfmAUa2JOe6HmkfC1K1dYIsSbTWv7zmaMRHvKWcZqpNFu8sOrpNVTQL
         PQ6w9GdZKlxuLJFqSyYHHN+QZWLXQ4Q3XXCwK/tX35LYhF2ErmetaFMmgGivHq2MUi
         NAcD8wPsxAi/aS0bGqusvy4OKeWstvHPaEuU1rUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.11 090/210] powerpc/ptrace: Dont return error when getting/setting FP regs without CONFIG_PPC_FPU_REGS
Date:   Mon, 12 Apr 2021 10:39:55 +0200
Message-Id: <20210412084019.007370615@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 3618250c8399cb36f4a0fbc48610a178307e1c64 upstream.

An #ifdef CONFIG_PPC_FPU_REGS is missing in arch_ptrace() leading
to the following Oops because [REGSET_FPR] entry is not initialised in
native_regsets[].

[   41.917608] BUG: Unable to handle kernel instruction fetch
[   41.922849] Faulting instruction address: 0xff8fd228
[   41.927760] Oops: Kernel access of bad area, sig: 11 [#1]
[   41.933089] BE PAGE_SIZE=4K PREEMPT CMPC885
[   41.940753] Modules linked in:
[   41.943768] CPU: 0 PID: 366 Comm: gdb Not tainted 5.12.0-rc5-s3k-dev-01666-g7aac86a0f057-dirty #4835
[   41.952800] NIP:  ff8fd228 LR: c004d9e0 CTR: ff8fd228
[   41.957790] REGS: caae9df0 TRAP: 0400   Not tainted  (5.12.0-rc5-s3k-dev-01666-g7aac86a0f057-dirty)
[   41.966741] MSR:  40009032 <EE,ME,IR,DR,RI>  CR: 82004248  XER: 20000000
[   41.973540]
[   41.973540] GPR00: c004d9b4 caae9eb0 c1b64f60 c1b64520 c0713cd4 caae9eb8 c1bacdfc 00000004
[   41.973540] GPR08: 00000200 ff8fd228 c1bac700 00001032 28004242 1061aaf4 00000001 106d64a0
[   41.973540] GPR16: 00000000 00000000 7fa0a774 10610000 7fa0aef9 00000000 10610000 7fa0a538
[   41.973540] GPR24: 7fa0a580 7fa0a570 c1bacc00 c1b64520 c1bacc00 caae9ee8 00000108 c0713cd4
[   42.009685] NIP [ff8fd228] 0xff8fd228
[   42.013300] LR [c004d9e0] __regset_get+0x100/0x124
[   42.018036] Call Trace:
[   42.020443] [caae9eb0] [c004d9b4] __regset_get+0xd4/0x124 (unreliable)
[   42.026899] [caae9ee0] [c004da94] copy_regset_to_user+0x5c/0xb0
[   42.032751] [caae9f10] [c002f640] sys_ptrace+0xe4/0x588
[   42.037915] [caae9f30] [c0011010] ret_from_syscall+0x0/0x28
[   42.043422] --- interrupt: c00 at 0xfd1f8e4
[   42.047553] NIP:  0fd1f8e4 LR: 1004a688 CTR: 00000000
[   42.052544] REGS: caae9f40 TRAP: 0c00   Not tainted  (5.12.0-rc5-s3k-dev-01666-g7aac86a0f057-dirty)
[   42.061494] MSR:  0000d032 <EE,PR,ME,IR,DR,RI>  CR: 48004442  XER: 00000000
[   42.068551]
[   42.068551] GPR00: 0000001a 7fa0a040 77dad7e0 0000000e 00000170 00000000 7fa0a078 00000004
[   42.068551] GPR08: 00000000 108deb88 108dda40 106d6010 44004442 1061aaf4 00000001 106d64a0
[   42.068551] GPR16: 00000000 00000000 7fa0a774 10610000 7fa0aef9 00000000 10610000 7fa0a538
[   42.068551] GPR24: 7fa0a580 7fa0a570 1078fe00 1078fd70 1078fd70 00000170 0fdd3244 0000000d
[   42.104696] NIP [0fd1f8e4] 0xfd1f8e4
[   42.108225] LR [1004a688] 0x1004a688
[   42.111753] --- interrupt: c00
[   42.114768] Instruction dump:
[   42.117698] XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX
[   42.125443] XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX
[   42.133195] ---[ end trace d35616f22ab2100c ]---

Adding the missing #ifdef is not good because gdb doesn't like getting
an error when getting registers.

Instead, make ptrace return 0s when CONFIG_PPC_FPU_REGS is not set.

Fixes: b6254ced4da6 ("powerpc/signal: Don't manage floating point regs when no FPU")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/9121a44a2d50ba1af18d8aa5ada06c9a3bea8afd.1617200085.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/ptrace/Makefile       |    4 ++--
 arch/powerpc/kernel/ptrace/ptrace-decl.h  |   14 --------------
 arch/powerpc/kernel/ptrace/ptrace-fpu.c   |   10 ++++++++++
 arch/powerpc/kernel/ptrace/ptrace-novsx.c |    8 ++++++++
 arch/powerpc/kernel/ptrace/ptrace-view.c  |    2 --
 5 files changed, 20 insertions(+), 18 deletions(-)

--- a/arch/powerpc/kernel/ptrace/Makefile
+++ b/arch/powerpc/kernel/ptrace/Makefile
@@ -6,11 +6,11 @@
 CFLAGS_ptrace-view.o		+= -DUTS_MACHINE='"$(UTS_MACHINE)"'
 
 obj-y				+= ptrace.o ptrace-view.o
-obj-$(CONFIG_PPC_FPU_REGS)	+= ptrace-fpu.o
+obj-y				+= ptrace-fpu.o
 obj-$(CONFIG_COMPAT)		+= ptrace32.o
 obj-$(CONFIG_VSX)		+= ptrace-vsx.o
 ifneq ($(CONFIG_VSX),y)
-obj-$(CONFIG_PPC_FPU_REGS)	+= ptrace-novsx.o
+obj-y				+= ptrace-novsx.o
 endif
 obj-$(CONFIG_ALTIVEC)		+= ptrace-altivec.o
 obj-$(CONFIG_SPE)		+= ptrace-spe.o
--- a/arch/powerpc/kernel/ptrace/ptrace-decl.h
+++ b/arch/powerpc/kernel/ptrace/ptrace-decl.h
@@ -165,22 +165,8 @@ int ptrace_put_reg(struct task_struct *t
 extern const struct user_regset_view user_ppc_native_view;
 
 /* ptrace-fpu */
-#ifdef CONFIG_PPC_FPU_REGS
 int ptrace_get_fpr(struct task_struct *child, int index, unsigned long *data);
 int ptrace_put_fpr(struct task_struct *child, int index, unsigned long data);
-#else
-static inline int
-ptrace_get_fpr(struct task_struct *child, int index, unsigned long *data)
-{
-	return -EIO;
-}
-
-static inline int
-ptrace_put_fpr(struct task_struct *child, int index, unsigned long data)
-{
-	return -EIO;
-}
-#endif
 
 /* ptrace-(no)adv */
 void ppc_gethwdinfo(struct ppc_debug_info *dbginfo);
--- a/arch/powerpc/kernel/ptrace/ptrace-fpu.c
+++ b/arch/powerpc/kernel/ptrace/ptrace-fpu.c
@@ -8,32 +8,42 @@
 
 int ptrace_get_fpr(struct task_struct *child, int index, unsigned long *data)
 {
+#ifdef CONFIG_PPC_FPU_REGS
 	unsigned int fpidx = index - PT_FPR0;
+#endif
 
 	if (index > PT_FPSCR)
 		return -EIO;
 
+#ifdef CONFIG_PPC_FPU_REGS
 	flush_fp_to_thread(child);
 	if (fpidx < (PT_FPSCR - PT_FPR0))
 		memcpy(data, &child->thread.TS_FPR(fpidx), sizeof(long));
 	else
 		*data = child->thread.fp_state.fpscr;
+#else
+	*data = 0;
+#endif
 
 	return 0;
 }
 
 int ptrace_put_fpr(struct task_struct *child, int index, unsigned long data)
 {
+#ifdef CONFIG_PPC_FPU_REGS
 	unsigned int fpidx = index - PT_FPR0;
+#endif
 
 	if (index > PT_FPSCR)
 		return -EIO;
 
+#ifdef CONFIG_PPC_FPU_REGS
 	flush_fp_to_thread(child);
 	if (fpidx < (PT_FPSCR - PT_FPR0))
 		memcpy(&child->thread.TS_FPR(fpidx), &data, sizeof(long));
 	else
 		child->thread.fp_state.fpscr = data;
+#endif
 
 	return 0;
 }
--- a/arch/powerpc/kernel/ptrace/ptrace-novsx.c
+++ b/arch/powerpc/kernel/ptrace/ptrace-novsx.c
@@ -21,12 +21,16 @@
 int fpr_get(struct task_struct *target, const struct user_regset *regset,
 	    struct membuf to)
 {
+#ifdef CONFIG_PPC_FPU_REGS
 	BUILD_BUG_ON(offsetof(struct thread_fp_state, fpscr) !=
 		     offsetof(struct thread_fp_state, fpr[32]));
 
 	flush_fp_to_thread(target);
 
 	return membuf_write(&to, &target->thread.fp_state, 33 * sizeof(u64));
+#else
+	return membuf_write(&to, &empty_zero_page, 33 * sizeof(u64));
+#endif
 }
 
 /*
@@ -46,6 +50,7 @@ int fpr_set(struct task_struct *target,
 	    unsigned int pos, unsigned int count,
 	    const void *kbuf, const void __user *ubuf)
 {
+#ifdef CONFIG_PPC_FPU_REGS
 	BUILD_BUG_ON(offsetof(struct thread_fp_state, fpscr) !=
 		     offsetof(struct thread_fp_state, fpr[32]));
 
@@ -53,4 +58,7 @@ int fpr_set(struct task_struct *target,
 
 	return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
 				  &target->thread.fp_state, 0, -1);
+#else
+	return 0;
+#endif
 }
--- a/arch/powerpc/kernel/ptrace/ptrace-view.c
+++ b/arch/powerpc/kernel/ptrace/ptrace-view.c
@@ -522,13 +522,11 @@ static const struct user_regset native_r
 		.size = sizeof(long), .align = sizeof(long),
 		.regset_get = gpr_get, .set = gpr_set
 	},
-#ifdef CONFIG_PPC_FPU_REGS
 	[REGSET_FPR] = {
 		.core_note_type = NT_PRFPREG, .n = ELF_NFPREG,
 		.size = sizeof(double), .align = sizeof(double),
 		.regset_get = fpr_get, .set = fpr_set
 	},
-#endif
 #ifdef CONFIG_ALTIVEC
 	[REGSET_VMX] = {
 		.core_note_type = NT_PPC_VMX, .n = 34,


