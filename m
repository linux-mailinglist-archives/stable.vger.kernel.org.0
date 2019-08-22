Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB72299AE2
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390375AbfHVRQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:16:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390371AbfHVRIc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:08:32 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F4A723407;
        Thu, 22 Aug 2019 17:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493711;
        bh=/RMruXm/kbYs/pmyESdYEDkg//1Rj8h9JYIuw284yYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N43vpsxwxcj/JGCG87QJMbzo+iL19bCaIRQTW1mllCI8C6g1YyoIwqciY/R8F7Rvm
         WFtceASzBsuLBoPheSjN1T/yqkRqSRfxtaBF+Pz+r3Q5iLi096VwaWdtIXYbjNQW4B
         TILMQPv3gLdGc1flBYFZVOXTy6y/vkU8TcCbrWBA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincent Chen <vincent.chen@sifive.com>,
        Anup Patel <anup@brainfault.org>,
        Christoph Hellwig <hch@lst.de>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.2 032/135] riscv: Correct the initialized flow of FP register
Date:   Thu, 22 Aug 2019 13:06:28 -0400
Message-Id: <20190822170811.13303-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Chen <vincent.chen@sifive.com>

commit 8ac71d7e46b94a4fc8ffc6f1c88004cdf24459e8 upstream.

  The following two reasons cause FP registers are sometimes not
initialized before starting the user program.
1. Currently, the FP context is initialized in flush_thread() function
   and we expect these initial values to be restored to FP register when
   doing FP context switch. However, the FP context switch only occurs in
   switch_to function. Hence, if this process does not be scheduled out
   and scheduled in before entering the user space, the FP registers
   have no chance to initialize.
2. In flush_thread(), the state of reg->sstatus.FS inherits from the
   parent. Hence, the state of reg->sstatus.FS may be dirty. If this
   process is scheduled out during flush_thread() and initializing the
   FP register, the fstate_save() in switch_to will corrupt the FP context
   which has been initialized until flush_thread().

  To solve the 1st case, the initialization of the FP register will be
completed in start_thread(). It makes sure all FP registers are initialized
before starting the user program. For the 2nd case, the state of
reg->sstatus.FS in start_thread will be set to SR_FS_OFF to prevent this
process from corrupting FP context in doing context save. The FP state is
set to SR_FS_INITIAL in start_trhead().

Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Fixes: 7db91e57a0acd ("RISC-V: Task implementation")
Cc: stable@vger.kernel.org
[paul.walmsley@sifive.com: fixed brace alignment issue reported by
 checkpatch]
Signed-off-by: Paul Walmsley <paul.walmsley@sifive.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/switch_to.h |  6 ++++++
 arch/riscv/kernel/process.c        | 11 +++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/switch_to.h b/arch/riscv/include/asm/switch_to.h
index 853b65ef656da..949d9cd91dec4 100644
--- a/arch/riscv/include/asm/switch_to.h
+++ b/arch/riscv/include/asm/switch_to.h
@@ -19,6 +19,12 @@ static inline void __fstate_clean(struct pt_regs *regs)
 	regs->sstatus |= (regs->sstatus & ~(SR_FS)) | SR_FS_CLEAN;
 }
 
+static inline void fstate_off(struct task_struct *task,
+			      struct pt_regs *regs)
+{
+	regs->sstatus = (regs->sstatus & ~SR_FS) | SR_FS_OFF;
+}
+
 static inline void fstate_save(struct task_struct *task,
 			       struct pt_regs *regs)
 {
diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
index f23794bd1e90c..fb3a082362eb8 100644
--- a/arch/riscv/kernel/process.c
+++ b/arch/riscv/kernel/process.c
@@ -64,8 +64,14 @@ void start_thread(struct pt_regs *regs, unsigned long pc,
 	unsigned long sp)
 {
 	regs->sstatus = SR_SPIE;
-	if (has_fpu)
+	if (has_fpu) {
 		regs->sstatus |= SR_FS_INITIAL;
+		/*
+		 * Restore the initial value to the FP register
+		 * before starting the user program.
+		 */
+		fstate_restore(current, regs);
+	}
 	regs->sepc = pc;
 	regs->sp = sp;
 	set_fs(USER_DS);
@@ -75,10 +81,11 @@ void flush_thread(void)
 {
 #ifdef CONFIG_FPU
 	/*
-	 * Reset FPU context
+	 * Reset FPU state and context
 	 *	frm: round to nearest, ties to even (IEEE default)
 	 *	fflags: accrued exceptions cleared
 	 */
+	fstate_off(current, task_pt_regs(current));
 	memset(&current->thread.fstate, 0, sizeof(current->thread.fstate));
 #endif
 }
-- 
2.20.1

