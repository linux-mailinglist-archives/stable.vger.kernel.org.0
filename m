Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB418B2052
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390631AbfIMNUq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:20:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390618AbfIMNUm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:20:42 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDC6E206BB;
        Fri, 13 Sep 2019 13:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380841;
        bh=rkVZ5kBIPKMz+ijzPJxA9cMCfBnIJst1W8eeNI2q6Q0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y9gSGl82yrO4+YVVzYrnJC6KuSgn2YrEDhXpjuRyp2FY2KDo5zVbCuMCgL2uvuaPv
         hneuEpq4ub3WpqzLu9ChP12ZKh9tGQ2pkO7ZkmiUD5MSNOJ81e/+SykAMEHk3uCojC
         4xPPqnqbR8Sj5hLWOhqcV0QuAtvGgUlEMJWrUGtA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gustavo Romero <gromero@linux.ibm.com>,
        Michael Neuling <mikey@neuling.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 188/190] powerpc/tm: Fix restoring FP/VMX facility incorrectly on interrupts
Date:   Fri, 13 Sep 2019 14:07:23 +0100
Message-Id: <20190913130614.938853371@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a8318c13e79badb92bc6640704a64cc022a6eb97 ]

When in userspace and MSR FP=0 the hardware FP state is unrelated to
the current process. This is extended for transactions where if tbegin
is run with FP=0, the hardware checkpoint FP state will also be
unrelated to the current process. Due to this, we need to ensure this
hardware checkpoint is updated with the correct state before we enable
FP for this process.

Unfortunately we get this wrong when returning to a process from a
hardware interrupt. A process that starts a transaction with FP=0 can
take an interrupt. When the kernel returns back to that process, we
change to FP=1 but with hardware checkpoint FP state not updated. If
this transaction is then rolled back, the FP registers now contain the
wrong state.

The process looks like this:
   Userspace:                      Kernel

               Start userspace
                with MSR FP=0 TM=1
                  < -----
   ...
   tbegin
   bne
               Hardware interrupt
                   ---- >
                                    <do_IRQ...>
                                    ....
                                    ret_from_except
                                      restore_math()
				        /* sees FP=0 */
                                        restore_fp()
                                          tm_active_with_fp()
					    /* sees FP=1 (Incorrect) */
                                          load_fp_state()
                                        FP = 0 -> 1
                  < -----
               Return to userspace
                 with MSR TM=1 FP=1
                 with junk in the FP TM checkpoint
   TM rollback
   reads FP junk

When returning from the hardware exception, tm_active_with_fp() is
incorrectly making restore_fp() call load_fp_state() which is setting
FP=1.

The fix is to remove tm_active_with_fp().

tm_active_with_fp() is attempting to handle the case where FP state
has been changed inside a transaction. In this case the checkpointed
and transactional FP state is different and hence we must restore the
FP state (ie. we can't do lazy FP restore inside a transaction that's
used FP). It's safe to remove tm_active_with_fp() as this case is
handled by restore_tm_state(). restore_tm_state() detects if FP has
been using inside a transaction and will set load_fp and call
restore_math() to ensure the FP state (checkpoint and transaction) is
restored.

This is a data integrity problem for the current process as the FP
registers are corrupted. It's also a security problem as the FP
registers from one process may be leaked to another.

Similarly for VMX.

A simple testcase to replicate this will be posted to
tools/testing/selftests/powerpc/tm/tm-poison.c

This fixes CVE-2019-15031.

Fixes: a7771176b439 ("powerpc: Don't enable FP/Altivec if not checkpointed")
Cc: stable@vger.kernel.org # 4.15+
Signed-off-by: Gustavo Romero <gromero@linux.ibm.com>
Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190904045529.23002-2-gromero@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/process.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 49c6d474eb5ac..909c9407e392a 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -102,21 +102,8 @@ static void check_if_tm_restore_required(struct task_struct *tsk)
 	}
 }
 
-static bool tm_active_with_fp(struct task_struct *tsk)
-{
-	return MSR_TM_ACTIVE(tsk->thread.regs->msr) &&
-		(tsk->thread.ckpt_regs.msr & MSR_FP);
-}
-
-static bool tm_active_with_altivec(struct task_struct *tsk)
-{
-	return MSR_TM_ACTIVE(tsk->thread.regs->msr) &&
-		(tsk->thread.ckpt_regs.msr & MSR_VEC);
-}
 #else
 static inline void check_if_tm_restore_required(struct task_struct *tsk) { }
-static inline bool tm_active_with_fp(struct task_struct *tsk) { return false; }
-static inline bool tm_active_with_altivec(struct task_struct *tsk) { return false; }
 #endif /* CONFIG_PPC_TRANSACTIONAL_MEM */
 
 bool strict_msr_control;
@@ -251,7 +238,7 @@ EXPORT_SYMBOL(enable_kernel_fp);
 
 static int restore_fp(struct task_struct *tsk)
 {
-	if (tsk->thread.load_fp || tm_active_with_fp(tsk)) {
+	if (tsk->thread.load_fp) {
 		load_fp_state(&current->thread.fp_state);
 		current->thread.load_fp++;
 		return 1;
@@ -333,8 +320,7 @@ EXPORT_SYMBOL_GPL(flush_altivec_to_thread);
 
 static int restore_altivec(struct task_struct *tsk)
 {
-	if (cpu_has_feature(CPU_FTR_ALTIVEC) &&
-		(tsk->thread.load_vec || tm_active_with_altivec(tsk))) {
+	if (cpu_has_feature(CPU_FTR_ALTIVEC) && (tsk->thread.load_vec)) {
 		load_vr_state(&tsk->thread.vr_state);
 		tsk->thread.used_vr = 1;
 		tsk->thread.load_vec++;
-- 
2.20.1



