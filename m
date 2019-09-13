Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 347EAB1E5F
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388549AbfIMNJg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:09:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388533AbfIMNJd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:09:33 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3A762089F;
        Fri, 13 Sep 2019 13:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380172;
        bh=3PY/NNR9mlGmTuaPwzlQKVuEgDoiAjQwTzC3+QkvHZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NtKmchMdDzdcbzrpCcWWg3MbJYoBSOQF364rdSxZ533jWKJ/9m4u43MxoJ5SA6wxx
         2OL9AEepKieE+0zS2GAQnqxBrwwVaoxpe/hXJsBbdm4ljXS9szsmFVcSSqOd/MTkI9
         81h5Hc4AagCky9FEIK26e7MFUkZCgiOMMX/4uezs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gustavo Romero <gromero@linux.vnet.ibm.com>,
        Michael Neuling <mikey@neuling.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.9 05/14] powerpc/tm: Fix FP/VMX unavailable exceptions inside a transaction
Date:   Fri, 13 Sep 2019 14:06:58 +0100
Message-Id: <20190913130444.097940154@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130440.264749443@linuxfoundation.org>
References: <20190913130440.264749443@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo Romero <gromero@linux.ibm.com>

commit 8205d5d98ef7f155de211f5e2eb6ca03d95a5a60 upstream.

When we take an FP unavailable exception in a transaction we have to
account for the hardware FP TM checkpointed registers being
incorrect. In this case for this process we know the current and
checkpointed FP registers must be the same (since FP wasn't used
inside the transaction) hence in the thread_struct we copy the current
FP registers to the checkpointed ones.

This copy is done in tm_reclaim_thread(). We use thread->ckpt_regs.msr
to determine if FP was on when in userspace. thread->ckpt_regs.msr
represents the state of the MSR when exiting userspace. This is setup
by check_if_tm_restore_required().

Unfortunatley there is an optimisation in giveup_all() which returns
early if tsk->thread.regs->msr (via local variable `usermsr`) has
FP=VEC=VSX=SPE=0. This optimisation means that
check_if_tm_restore_required() is not called and hence
thread->ckpt_regs.msr is not updated and will contain an old value.

This can happen if due to load_fp=255 we start a userspace process
with MSR FP=1 and then we are context switched out. In this case
thread->ckpt_regs.msr will contain FP=1. If that same process is then
context switched in and load_fp overflows, MSR will have FP=0. If that
process now enters a transaction and does an FP instruction, the FP
unavailable will not update thread->ckpt_regs.msr (the bug) and MSR
FP=1 will be retained in thread->ckpt_regs.msr.  tm_reclaim_thread()
will then not perform the required memcpy and the checkpointed FP regs
in the thread struct will contain the wrong values.

The code path for this happening is:

       Userspace:                      Kernel
                   Start userspace
                    with MSR FP/VEC/VSX/SPE=0 TM=1
                      < -----
       ...
       tbegin
       bne
       fp instruction
                   FP unavailable
                       ---- >
                                        fp_unavailable_tm()
					  tm_reclaim_current()
					    tm_reclaim_thread()
					      giveup_all()
					        return early since FP/VMX/VSX=0
						/* ckpt MSR not updated (Incorrect) */
					      tm_reclaim()
					        /* thread_struct ckpt FP regs contain junk (OK) */
                                              /* Sees ckpt MSR FP=1 (Incorrect) */
					      no memcpy() performed
					        /* thread_struct ckpt FP regs not fixed (Incorrect) */
					  tm_recheckpoint()
					     /* Put junk in hardware checkpoint FP regs */
                                         ....
                      < -----
                   Return to userspace
                     with MSR TM=1 FP=1
                     with junk in the FP TM checkpoint
       TM rollback
       reads FP junk

This is a data integrity problem for the current process as the FP
registers are corrupted. It's also a security problem as the FP
registers from one process may be leaked to another.

This patch moves up check_if_tm_restore_required() in giveup_all() to
ensure thread->ckpt_regs.msr is updated correctly.

A simple testcase to replicate this will be posted to
tools/testing/selftests/powerpc/tm/tm-poison.c

Similarly for VMX.

This fixes CVE-2019-15030.

Fixes: f48e91e87e67 ("powerpc/tm: Fix FP and VMX register corruption")
Cc: stable@vger.kernel.org # 4.12+
Signed-off-by: Gustavo Romero <gromero@linux.vnet.ibm.com>
Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190904045529.23002-1-gromero@linux.vnet.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/process.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -476,13 +476,14 @@ void giveup_all(struct task_struct *tsk)
 	if (!tsk->thread.regs)
 		return;
 
+	check_if_tm_restore_required(tsk);
+
 	usermsr = tsk->thread.regs->msr;
 
 	if ((usermsr & msr_all_available) == 0)
 		return;
 
 	msr_check_and_set(msr_all_available);
-	check_if_tm_restore_required(tsk);
 
 #ifdef CONFIG_PPC_FPU
 	if (usermsr & MSR_FP)


