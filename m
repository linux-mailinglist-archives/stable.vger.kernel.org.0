Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF59F7F132
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728693AbfHBJg7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:36:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404462AbfHBJgY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:36:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAF36217D7;
        Fri,  2 Aug 2019 09:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738583;
        bh=BiALBVb/N8Fsm4R+469HhuEF45AObVBncms9OQ4TZjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uDsm8dAuxOEXz7EZ+Ixrj00e2/iXl2UxshYDS3bqjCaB0E/HjbySyk2XccobR9PRb
         JzAD0D9rmXG/CC1kb77t7HXDHGisau/oB42ZC+3QfTC2idXQa4F+iwts5BHMoW+k+N
         3CFZMZeTmuFWPbLSJ71OetcZeaRbh38l13YeJM2c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Praveen Pandey <Praveen.Pandey@in.ibm.com>,
        Michael Neuling <mikey@neuling.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 146/158] powerpc/tm: Fix oops on sigreturn on systems without TM
Date:   Fri,  2 Aug 2019 11:29:27 +0200
Message-Id: <20190802092232.161854071@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092203.671944552@linuxfoundation.org>
References: <20190802092203.671944552@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: stable@vger.kernel.org # v3.9
Reported-by: Praveen Pandey <Praveen.Pandey@in.ibm.com>
Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190719050502.405-1-mikey@neuling.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/signal_32.c |    3 +++
 arch/powerpc/kernel/signal_64.c |    5 +++++
 2 files changed, 8 insertions(+)

--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -1261,6 +1261,9 @@ long sys_rt_sigreturn(int r3, int r4, in
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
@@ -695,6 +695,11 @@ int sys_rt_sigreturn(unsigned long r3, u
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


