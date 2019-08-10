Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64B0E88DD3
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbfHJUt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:49:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54636 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726755AbfHJUn6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:58 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDT-00053u-9y; Sat, 10 Aug 2019 21:43:55 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDO-0003jf-G0; Sat, 10 Aug 2019 21:43:50 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Michael Ellerman" <mpe@ellerman.id.au>,
        "Michael Neuling" <mikey@neuling.org>,
        "Praveen Pandey" <Praveen.Pandey@in.ibm.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.372546052@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 137/157] powerpc/tm: Fix oops on sigreturn on systems
 without TM
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Neuling <mikey@neuling.org>

commit f16d80b75a096c52354c6e0a574993f3b0dfbdfe upstream.

On systems like P9 powernv where we have no TM (or P8 booted with
ppc_tm=off), userspace can construct a signal context which still has
the MSR TS bits set. The kernel tries to restore this context which
results in the following crash:

  Unexpected TM Bad Thing exception at c0000000000022fc (msr 0x8000000102a03031) tm_scratch=800000020280f033
  Oops: Unrecoverable exception, sig: 6 [#1]
  LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
  Modules linked in:
  CPU: 0 PID: 1636 Comm: sigfuz Not tainted 5.2.0-11043-g0a8ad0ffa4 #69
  NIP:  c0000000000022fc LR: 00007fffb2d67e48 CTR: 0000000000000000
  REGS: c00000003fffbd70 TRAP: 0700   Not tainted  (5.2.0-11045-g7142b497d8)
  MSR:  8000000102a03031 <SF,VEC,VSX,FP,ME,IR,DR,LE,TM[E]>  CR: 42004242  XER: 00000000
  CFAR: c0000000000022e0 IRQMASK: 0
  GPR00: 0000000000000072 00007fffb2b6e560 00007fffb2d87f00 0000000000000669
  GPR04: 00007fffb2b6e728 0000000000000000 0000000000000000 00007fffb2b6f2a8
  GPR08: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
  GPR12: 0000000000000000 00007fffb2b76900 0000000000000000 0000000000000000
  GPR16: 00007fffb2370000 00007fffb2d84390 00007fffea3a15ac 000001000a250420
  GPR20: 00007fffb2b6f260 0000000010001770 0000000000000000 0000000000000000
  GPR24: 00007fffb2d843a0 00007fffea3a14a0 0000000000010000 0000000000800000
  GPR28: 00007fffea3a14d8 00000000003d0f00 0000000000000000 00007fffb2b6e728
  NIP [c0000000000022fc] rfi_flush_fallback+0x7c/0x80
  LR [00007fffb2d67e48] 0x7fffb2d67e48
  Call Trace:
  Instruction dump:
  e96a0220 e96a02a8 e96a0330 e96a03b8 394a0400 4200ffdc 7d2903a6 e92d0c00
  e94d0c08 e96d0c10 e82d0c18 7db242a6 <4c000024> 7db243a6 7db142a6 f82d0c18

The problem is the signal code assumes TM is enabled when
CONFIG_PPC_TRANSACTIONAL_MEM is enabled. This may not be the case as
with P9 powernv or if `ppc_tm=off` is used on P8.

This means any local user can crash the system.

Fix the problem by returning a bad stack frame to the user if they try
to set the MSR TS bits with sigreturn() on systems where TM is not
supported.

Found with sigfuz kernel selftest on P9.

This fixes CVE-2019-13648.

Fixes: 2b0a576d15e0 ("powerpc: Add new transactional memory state to the signal context")
Reported-by: Praveen Pandey <Praveen.Pandey@in.ibm.com>
Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190719050502.405-1-mikey@neuling.org
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/kernel/signal_32.c | 3 +++
 arch/powerpc/kernel/signal_64.c | 5 +++++
 2 files changed, 8 insertions(+)

--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -1274,6 +1274,9 @@ long sys_rt_sigreturn(int r3, int r4, in
 			goto bad;
 
 		if (MSR_TM_ACTIVE(msr_hi<<32)) {
+			/* Trying to start TM on non TM system */
+			if (!cpu_has_feature(CPU_FTR_TM))
+				goto bad;
 			/* We only recheckpoint on return if we're
 			 * transaction.
 			 */
--- a/arch/powerpc/kernel/signal_64.c
+++ b/arch/powerpc/kernel/signal_64.c
@@ -702,6 +702,11 @@ int sys_rt_sigreturn(unsigned long r3, u
 	if (MSR_TM_ACTIVE(msr)) {
 		/* We recheckpoint on return. */
 		struct ucontext __user *uc_transact;
+
+		/* Trying to start TM on non TM system */
+		if (!cpu_has_feature(CPU_FTR_TM))
+			goto badframe;
+
 		if (__get_user(uc_transact, &uc->uc_link))
 			goto badframe;
 		if (restore_tm_sigcontexts(regs, &uc->uc_mcontext,

