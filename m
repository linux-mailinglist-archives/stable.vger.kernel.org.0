Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D0A3F483E
	for <lists+stable@lfdr.de>; Mon, 23 Aug 2021 12:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232990AbhHWKIQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 06:08:16 -0400
Received: from pegase2.c-s.fr ([93.17.235.10]:60147 "EHLO pegase2.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232386AbhHWKIP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 06:08:15 -0400
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4GtSbR5lzTz9sTF;
        Mon, 23 Aug 2021 12:07:31 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id trzcqDxyUJ-y; Mon, 23 Aug 2021 12:07:31 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4GtSbR4S6Jz9sSl;
        Mon, 23 Aug 2021 12:07:31 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 54E428B78C;
        Mon, 23 Aug 2021 12:07:31 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id noyFMA_O5PtN; Mon, 23 Aug 2021 12:07:31 +0200 (CEST)
Received: from po9473vm.idsi0.si.c-s.fr (po15451.idsi0.si.c-s.fr [172.25.230.100])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 2EEE98B796;
        Mon, 23 Aug 2021 12:07:31 +0200 (CEST)
Received: by po9473vm.idsi0.si.c-s.fr (Postfix, from userid 0)
        id E513A663D4; Mon, 23 Aug 2021 10:07:30 +0000 (UTC)
Message-Id: <84a44c20e8878a37d7dcfccaad71109c012ff3cf.1629713148.git.christophe.leroy@csgroup.eu>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH] powerpc/32s: Fix random crashes by adding isync() after
 locking/unlocking KUEP
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        userm57@yahoo.com, fthain@linux-m68k.org
Date:   Mon, 23 Aug 2021 10:07:30 +0000 (UTC)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport for kernel 5.13

(cherry picked from commit ef486bf448a057a6e2d50e40ae879f7add6585da)

Commit b5efec00b671 ("powerpc/32s: Move KUEP locking/unlocking in C")
removed the 'isync' instruction after adding/removing NX bit in user
segments. The reasoning behind this change was that when setting the
NX bit we don't mind it taking effect with delay as the kernel never
executes text from userspace, and when clearing the NX bit this is
to return to userspace and then the 'rfi' should synchronise the
context.

However, it looks like on book3s/32 having a hash page table, at least
on the G3 processor, we get an unexpected fault from userspace, then
this is followed by something wrong in the verification of MSR_PR
at end of another interrupt.

This is fixed by adding back the removed isync() following update
of NX bit in user segment registers. Only do it for cores with an
hash table, as 603 cores don't exhibit that problem and the two isync
increase ./null_syscall selftest by 6 cycles on an MPC 832x.

First problem: unexpected WARN_ON() for mysterious PROTFAULT

  WARNING: CPU: 0 PID: 1660 at arch/powerpc/mm/fault.c:354 do_page_fault+0x6c/0x5b0
  Modules linked in:
  CPU: 0 PID: 1660 Comm: Xorg Not tainted 5.13.0-pmac-00028-gb3c15b60339a #40
  NIP:  c001b5c8 LR: c001b6f8 CTR: 00000000
  REGS: e2d09e40 TRAP: 0700   Not tainted  (5.13.0-pmac-00028-gb3c15b60339a)
  MSR:  00021032 <ME,IR,DR,RI>  CR: 42d04f30  XER: 20000000
  GPR00: c000424c e2d09f00 c301b680 e2d09f40 0000001e 42000000 00cba028 00000000
  GPR08: 08000000 48000010 c301b680 e2d09f30 22d09f30 00c1fff0 00cba000 a7b7ba4c
  GPR16: 00000031 00000000 00000000 00000000 00000000 00000000 a7b7b0d0 00c5c010
  GPR24: a7b7b64c a7b7d2f0 00000004 00000000 c1efa6c0 00cba02c 00000300 e2d09f40
  NIP [c001b5c8] do_page_fault+0x6c/0x5b0
  LR [c001b6f8] do_page_fault+0x19c/0x5b0
  Call Trace:
  [e2d09f00] [e2d09f04] 0xe2d09f04 (unreliable)
  [e2d09f30] [c000424c] DataAccess_virt+0xd4/0xe4
  --- interrupt: 300 at 0xa7a261dc
  NIP:  a7a261dc LR: a7a253bc CTR: 00000000
  REGS: e2d09f40 TRAP: 0300   Not tainted  (5.13.0-pmac-00028-gb3c15b60339a)
  MSR:  0000d032 <EE,PR,ME,IR,DR,RI>  CR: 228428e2  XER: 20000000
  DAR: 00cba02c DSISR: 42000000
  GPR00: a7a27448 afa6b0e0 a74c35c0 a7b7b614 0000001e a7b7b614 00cba028 00000000
  GPR08: 00020fd9 00000031 00cb9ff8 a7a273b0 220028e2 00c1fff0 00cba000 a7b7ba4c
  GPR16: 00000031 00000000 00000000 00000000 00000000 00000000 a7b7b0d0 00c5c010
  GPR24: a7b7b64c a7b7d2f0 00000004 00000002 0000001e a7b7b614 a7b7aff4 00000030
  NIP [a7a261dc] 0xa7a261dc
  LR [a7a253bc] 0xa7a253bc
  --- interrupt: 300
  Instruction dump:
  7c4a1378 810300a0 75278410 83820298 83a300a4 553b018c 551e0036 4082038c
  2e1b0000 40920228 75280800 41820220 <0fe00000> 3b600000 41920214 81420594

Second problem: MSR PR is seen unset allthough the interrupt frame shows it set

  kernel BUG at arch/powerpc/kernel/interrupt.c:458!
  Oops: Exception in kernel mode, sig: 5 [#1]
  BE PAGE_SIZE=4K MMU=Hash SMP NR_CPUS=2 PowerMac
  Modules linked in:
  CPU: 0 PID: 1660 Comm: Xorg Tainted: G        W         5.13.0-pmac-00028-gb3c15b60339a #40
  NIP:  c0011434 LR: c001629c CTR: 00000000
  REGS: e2d09e70 TRAP: 0700   Tainted: G        W          (5.13.0-pmac-00028-gb3c15b60339a)
  MSR:  00029032 <EE,ME,IR,DR,RI>  CR: 42d09f30  XER: 00000000
  GPR00: 00000000 e2d09f30 c301b680 e2d09f40 83440000 c44d0e68 e2d09e8c 00000000
  GPR08: 00000002 00dc228a 00004000 e2d09f30 22d09f30 00c1fff0 afa6ceb4 00c26144
  GPR16: 00c25fb8 00c26140 afa6ceb8 90000000 00c944d8 0000001c 00000000 00200000
  GPR24: 00000000 000001fb afa6d1b4 00000001 00000000 a539a2a0 a530fd80 00000089
  NIP [c0011434] interrupt_exit_kernel_prepare+0x10/0x70
  LR [c001629c] interrupt_return+0x9c/0x144
  Call Trace:
  [e2d09f30] [c000424c] DataAccess_virt+0xd4/0xe4 (unreliable)
  --- interrupt: 300 at 0xa09be008
  NIP:  a09be008 LR: a09bdfe8 CTR: a09bdfc0
  REGS: e2d09f40 TRAP: 0300   Tainted: G        W          (5.13.0-pmac-00028-gb3c15b60339a)
  MSR:  0000d032 <EE,PR,ME,IR,DR,RI>  CR: 420028e2  XER: 20000000
  DAR: a539a308 DSISR: 0a000000
  GPR00: a7b90d50 afa6b2d0 a74c35c0 a0a8b690 a0a8b698 a5365d70 a4fa82a8 00000004
  GPR08: 00000000 a09bdfc0 00000000 a5360000 a09bde7c 00c1fff0 afa6ceb4 00c26144
  GPR16: 00c25fb8 00c26140 afa6ceb8 90000000 00c944d8 0000001c 00000000 00200000
  GPR24: 00000000 000001fb afa6d1b4 00000001 00000000 a539a2a0 a530fd80 00000089
  NIP [a09be008] 0xa09be008
  LR [a09bdfe8] 0xa09bdfe8
  --- interrupt: 300
  Instruction dump:
  80010024 83e1001c 7c0803a6 4bffff80 3bc00800 4bffffd0 486b42fd 4bffffcc
  81430084 71480002 41820038 554a0462 <0f0a0000> 80620060 74630001 40820034

Fixes: b5efec00b671 ("powerpc/32s: Move KUEP locking/unlocking in C")
Cc: stable@vger.kernel.org # v5.13+
Reported-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/4856f5574906e2aec0522be17bf3848a22b2cd0b.1629269345.git.christophe.leroy@csgroup.eu
---
 arch/powerpc/mm/book3s32/kuep.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/powerpc/mm/book3s32/kuep.c b/arch/powerpc/mm/book3s32/kuep.c
index 8ed1b8634839..7015bd489063 100644
--- a/arch/powerpc/mm/book3s32/kuep.c
+++ b/arch/powerpc/mm/book3s32/kuep.c
@@ -4,6 +4,7 @@
 #include <asm/reg.h>
 #include <asm/task_size_32.h>
 #include <asm/mmu.h>
+#include <asm/synch.h>
 
 #define KUEP_UPDATE_TWO_USER_SEGMENTS(n) do {		\
 	if (TASK_SIZE > ((n) << 28))			\
@@ -32,9 +33,27 @@ static __always_inline void kuep_update(u32 val)
 void kuep_lock(void)
 {
 	kuep_update(mfsr(0) | SR_NX);
+	/*
+	 * This isync() shouldn't be necessary as the kernel is not excepted to
+	 * run any instruction in userspace soon after the update of segments,
+	 * but hash based cores (at least G3) seem to exhibit a random
+	 * behaviour when the 'isync' is not there. 603 cores don't have this
+	 * behaviour so don't do the 'isync' as it saves several CPU cycles.
+	 */
+	if (mmu_has_feature(MMU_FTR_HPTE_TABLE))
+		isync();	/* Context sync required after mtsr() */
 }
 
 void kuep_unlock(void)
 {
 	kuep_update(mfsr(0) & ~SR_NX);
+	/*
+	 * This isync() shouldn't be necessary as a 'rfi' will soon be executed
+	 * to return to userspace, but hash based cores (at least G3) seem to
+	 * exhibit a random behaviour when the 'isync' is not there. 603 cores
+	 * don't have this behaviour so don't do the 'isync' as it saves several
+	 * CPU cycles.
+	 */
+	if (mmu_has_feature(MMU_FTR_HPTE_TABLE))
+		isync();	/* Context sync required after mtsr() */
 }
-- 
2.25.0

