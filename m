Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63A92171B43
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732823AbgB0OAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:00:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:34566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732820AbgB0OAy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:00:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 096C221556;
        Thu, 27 Feb 2020 14:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812054;
        bh=A5eJRkIxHXYZYGfzRKlgumnOYOGJoFzREid9BwALZVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JF2EZYyx0nBHA6VP5GJmxuCaH5T8i6zN2lDaNXYnYrysbfK8fO83qfDvT1zojbyYy
         TSzJGWG+COlsKyzJrH3jyTwxchZc7iLaOgtEBCQUFJBJZct5X9Eu2sCjc9PfGrOlmH
         Vvg9AzkHQwgFX0G1sWQN5DL8Nuue+Er/X66QJRG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gustavo Romero <gromero@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 205/237] powerpc/tm: Fix endianness flip on trap
Date:   Thu, 27 Feb 2020 14:36:59 +0100
Message-Id: <20200227132311.326575336@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo Romero <gromero@linux.vnet.ibm.com>

[ Upstream commit 1c200e63d055ec0125e44a5e386b9b78aada7eb3 ]

Currently it's possible that a thread on PPC64 LE has its endianness
flipped inadvertently to Big-Endian resulting in a crash once the process
is back from the signal handler.

If giveup_all() is called when regs->msr has the bits MSR.FP and MSR.VEC
disabled (and hence MSR.VSX disabled too) it returns without calling
check_if_tm_restore_required() which copies regs->msr to ckpt_regs->msr if
the process caught a signal whilst in transactional mode. Then once in
setup_tm_sigcontexts() MSR from ckpt_regs.msr is used, but since
check_if_tm_restore_required() was not called previuosly, gp_regs[PT_MSR]
gets a copy of invalid MSR bits as MSR in ckpt_regs was not updated from
regs->msr and so is zeroed. Later when leaving the signal handler once in
sys_rt_sigreturn() the TS bits of gp_regs[PT_MSR] are checked to determine
if restore_tm_sigcontexts() must be called to pull in the correct MSR state
into the user context. Because TS bits are zeroed
restore_tm_sigcontexts() is never called and MSR restored from the user
context on returning from the signal handler has the MSR.LE (the endianness
bit) forced to zero (Big-Endian). That leads, for instance, to 'nop' being
treated as an illegal instruction in the following sequence:

	tbegin.
	beq	1f
	trap
	tend.
1:	nop

on PPC64 LE machines and the process dies just after returning from the
signal handler.

PPC64 BE is also affected but in a subtle way since forcing Big-Endian on
a BE machine does not change the endianness.

This commit fixes the issue described above by ensuring that once in
setup_tm_sigcontexts() the MSR used is from regs->msr instead of from
ckpt_regs->msr and by ensuring that we pull in only the MSR.FP, MSR.VEC,
and MSR.VSX bits from ckpt_regs->msr.

The fix was tested both on LE and BE machines and no regression regarding
the powerpc/tm selftests was observed.

Signed-off-by: Gustavo Romero <gromero@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/signal_64.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/signal_64.c b/arch/powerpc/kernel/signal_64.c
index 2d52fed72e216..b203c16d46d4e 100644
--- a/arch/powerpc/kernel/signal_64.c
+++ b/arch/powerpc/kernel/signal_64.c
@@ -207,7 +207,7 @@ static long setup_tm_sigcontexts(struct sigcontext __user *sc,
 	elf_vrreg_t __user *tm_v_regs = sigcontext_vmx_regs(tm_sc);
 #endif
 	struct pt_regs *regs = tsk->thread.regs;
-	unsigned long msr = tsk->thread.ckpt_regs.msr;
+	unsigned long msr = tsk->thread.regs->msr;
 	long err = 0;
 
 	BUG_ON(tsk != current);
@@ -216,6 +216,12 @@ static long setup_tm_sigcontexts(struct sigcontext __user *sc,
 
 	WARN_ON(tm_suspend_disabled);
 
+	/* Restore checkpointed FP, VEC, and VSX bits from ckpt_regs as
+	 * it contains the correct FP, VEC, VSX state after we treclaimed
+	 * the transaction and giveup_all() was called on reclaiming.
+	 */
+	msr |= tsk->thread.ckpt_regs.msr & (MSR_FP | MSR_VEC | MSR_VSX);
+
 	/* Remove TM bits from thread's MSR.  The MSR in the sigcontext
 	 * just indicates to userland that we were doing a transaction, but we
 	 * don't want to return in transactional state.  This also ensures
-- 
2.20.1



