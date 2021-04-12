Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C84C135CB30
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243431AbhDLQXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:23:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243442AbhDLQXi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 12:23:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B71F461288;
        Mon, 12 Apr 2021 16:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244600;
        bh=rkm6X9OKesAxMZd4NC2/70SbIw1V88Qvylcs74rdNc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pO9yaXxNuQLTY684DSBMOQKPkBmc39EwjXZDp8pwB9kaFaWL1eDIlXfp1fmqcofFS
         EHFLYjXXn1aSF+JSgnb1YrmKzYN5JNthLrcltzQW19vqYegBHriQfMcYZxa+B6QFLK
         EXTAjNbzQKclNKixHaeAVfjvZiI8IgEXYyui8lpNUqpjByRErA/zAZp4hHlcBz7/qc
         CO+TGi8GCKgNZmkraRntf2aBozxfltR12h+HYCszAh9cyJbGY7GHguYN432HkBX6qB
         6YOf5gpp1ZDuRbhHwSmSggl4WcIN7K8Y3r0z06f4cb4FHLblEKbuyzbB0BO0QuYYwM
         geSPjV4D2E+jw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.11 19/51] powerpc/signal32: Fix Oops on sigreturn with unmapped VDSO
Date:   Mon, 12 Apr 2021 12:22:24 -0400
Message-Id: <20210412162256.313524-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162256.313524-1-sashal@kernel.org>
References: <20210412162256.313524-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit acca57217c688c5bbbd5140974533d81e8757cc9 ]

PPC32 encounters a KUAP fault when trying to handle a signal with
VDSO unmapped.

	Kernel attempted to read user page (7fc07ec0) - exploit attempt? (uid: 0)
	BUG: Unable to handle kernel data access on read at 0x7fc07ec0
	Faulting instruction address: 0xc00111d4
	Oops: Kernel access of bad area, sig: 11 [#1]
	BE PAGE_SIZE=16K PREEMPT CMPC885
	CPU: 0 PID: 353 Comm: sigreturn_vdso Not tainted 5.12.0-rc4-s3k-dev-01553-gb30c310ea220 #4814
	NIP:  c00111d4 LR: c0005a28 CTR: 00000000
	REGS: cadb3dd0 TRAP: 0300   Not tainted  (5.12.0-rc4-s3k-dev-01553-gb30c310ea220)
	MSR:  00009032 <EE,ME,IR,DR,RI>  CR: 48000884  XER: 20000000
	DAR: 7fc07ec0 DSISR: 88000000
	GPR00: c0007788 cadb3e90 c28d4a40 7fc07ec0 7fc07ed0 000004e0 7fc07ce0 00000000
	GPR08: 00000001 00000001 7fc07ec0 00000000 28000282 1001b828 100a0920 00000000
	GPR16: 100cac0c 100b0000 105c43a4 105c5685 100d0000 100d0000 100d0000 100b2e9e
	GPR24: ffffffff 105c43c8 00000000 7fc07ec8 cadb3f40 cadb3ec8 c28d4a40 00000000
	NIP [c00111d4] flush_icache_range+0x90/0xb4
	LR [c0005a28] handle_signal32+0x1bc/0x1c4
	Call Trace:
	[cadb3e90] [100d0000] 0x100d0000 (unreliable)
	[cadb3ec0] [c0007788] do_notify_resume+0x260/0x314
	[cadb3f20] [c000c764] syscall_exit_prepare+0x120/0x184
	[cadb3f30] [c00100b4] ret_from_syscall+0xc/0x28
	--- interrupt: c00 at 0xfe807f8
	NIP:  0fe807f8 LR: 10001060 CTR: c0139378
	REGS: cadb3f40 TRAP: 0c00   Not tainted  (5.12.0-rc4-s3k-dev-01553-gb30c310ea220)
	MSR:  0000d032 <EE,PR,ME,IR,DR,RI>  CR: 28000482  XER: 20000000

	GPR00: 00000025 7fc081c0 77bb1690 00000000 0000000a 28000482 00000001 0ff03a38
	GPR08: 0000d032 00006de5 c28d4a40 00000009 88000482 1001b828 100a0920 00000000
	GPR16: 100cac0c 100b0000 105c43a4 105c5685 100d0000 100d0000 100d0000 100b2e9e
	GPR24: ffffffff 105c43c8 00000000 77ba7628 10002398 10010000 10002124 00024000
	NIP [0fe807f8] 0xfe807f8
	LR [10001060] 0x10001060
	--- interrupt: c00
	Instruction dump:
	38630010 7c001fac 38630010 4200fff0 7c0004ac 4c00012c 4e800020 7c001fac
	2c0a0000 38630010 4082ffcc 4bffffe4 <7c00186c> 2c070000 39430010 4082ff8c
	---[ end trace 3973fb72b049cb06 ]---

This is because flush_icache_range() is called on user addresses.

The same problem was detected some time ago on PPC64. It was fixed by
enabling KUAP in commit 59bee45b9712 ("powerpc/mm: Fix missing KUAP
disable in flush_coherent_icache()").

PPC32 doesn't use flush_coherent_icache() and fallbacks on
clean_dcache_range() and invalidate_icache_range().

We could fix it similarly by enabling user access in those functions,
but this is overkill for just flushing two instructions.

The two instructions are 8 bytes aligned, so a single dcbst/icbi is
enough to flush them. Do like __patch_instruction() and inline
a dcbst followed by an icbi just after the write of the instructions,
while user access is still allowed. The isync is not required because
rfi will be used to return to user.

icbi() is handled as a read so read-write user access is needed.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/bde9154e5351a5ac7bca3d59cdb5a5e8edacbb79.1617199569.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/signal_32.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_32.c
index 934cbdf6dd10..30eddc69c9cf 100644
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -775,7 +775,7 @@ int handle_rt_signal32(struct ksignal *ksig, sigset_t *oldset,
 	else
 		prepare_save_user_regs(1);
 
-	if (!user_write_access_begin(frame, sizeof(*frame)))
+	if (!user_access_begin(frame, sizeof(*frame)))
 		goto badframe;
 
 	/* Put the siginfo & fill in most of the ucontext */
@@ -809,17 +809,15 @@ int handle_rt_signal32(struct ksignal *ksig, sigset_t *oldset,
 		unsafe_put_user(PPC_INST_ADDI + __NR_rt_sigreturn, &mctx->mc_pad[0],
 				failed);
 		unsafe_put_user(PPC_INST_SC, &mctx->mc_pad[1], failed);
+		asm("dcbst %y0; sync; icbi %y0; sync" :: "Z" (mctx->mc_pad[0]));
 	}
 	unsafe_put_sigset_t(&frame->uc.uc_sigmask, oldset, failed);
 
-	user_write_access_end();
+	user_access_end();
 
 	if (copy_siginfo_to_user(&frame->info, &ksig->info))
 		goto badframe;
 
-	if (tramp == (unsigned long)mctx->mc_pad)
-		flush_icache_range(tramp, tramp + 2 * sizeof(unsigned long));
-
 	regs->link = tramp;
 
 #ifdef CONFIG_PPC_FPU_REGS
@@ -844,7 +842,7 @@ int handle_rt_signal32(struct ksignal *ksig, sigset_t *oldset,
 	return 0;
 
 failed:
-	user_write_access_end();
+	user_access_end();
 
 badframe:
 	signal_fault(tsk, regs, "handle_rt_signal32", frame);
@@ -879,7 +877,7 @@ int handle_signal32(struct ksignal *ksig, sigset_t *oldset,
 	else
 		prepare_save_user_regs(1);
 
-	if (!user_write_access_begin(frame, sizeof(*frame)))
+	if (!user_access_begin(frame, sizeof(*frame)))
 		goto badframe;
 	sc = (struct sigcontext __user *) &frame->sctx;
 
@@ -908,11 +906,9 @@ int handle_signal32(struct ksignal *ksig, sigset_t *oldset,
 		/* Set up the sigreturn trampoline: li r0,sigret; sc */
 		unsafe_put_user(PPC_INST_ADDI + __NR_sigreturn, &mctx->mc_pad[0], failed);
 		unsafe_put_user(PPC_INST_SC, &mctx->mc_pad[1], failed);
+		asm("dcbst %y0; sync; icbi %y0; sync" :: "Z" (mctx->mc_pad[0]));
 	}
-	user_write_access_end();
-
-	if (tramp == (unsigned long)mctx->mc_pad)
-		flush_icache_range(tramp, tramp + 2 * sizeof(unsigned long));
+	user_access_end();
 
 	regs->link = tramp;
 
@@ -934,7 +930,7 @@ int handle_signal32(struct ksignal *ksig, sigset_t *oldset,
 	return 0;
 
 failed:
-	user_write_access_end();
+	user_access_end();
 
 badframe:
 	signal_fault(tsk, regs, "handle_signal32", frame);
-- 
2.30.2

