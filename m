Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE2AFAE91D
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 13:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfIJL1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 07:27:51 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:40695 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726073AbfIJL1u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Sep 2019 07:27:50 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id B66165D0;
        Tue, 10 Sep 2019 07:27:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 10 Sep 2019 07:27:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=mp4mkT
        vLx/6VC+cpRl4mncoUQN8rL86E47yB2BRUcWk=; b=YKEPoSrL2e1JiDwPyi2JEq
        axdmDrAp/IMhbk02lVF8nYO4dgiR9eNXEAeOpVLA8I9NKae8U2PwcXVqqZimA53F
        k0zPRJbi7IFKtpj8I2tQn4b5rbTKJQM1gu7Z2fFr7HKn6H2x45S2jc2wxsgKfeyM
        QQewrJPeC277FhSXcK36a0wLt+hmf8D3eCoJA6rkMdNBLg1iZ2MXtA3Wj4uTLSqf
        BbxzTU3oF7FYbwGRk653bjBUwNM1PSJwC/PHa+uT/Ete3+WWtaGDRDPybSRRHFMG
        J7Z8RQaTw7IXFzIJsj8uLvroYlU6osRKLprjz89w+enzr3w4l8863PSwmZKoVrJA
        ==
X-ME-Sender: <xms:tYh3XTnox7xkbt0NqtnDGp6eyum6ZsBErD_1GTELJJp0tjpHF5XD1A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrtddtgddukecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppedvudefrdeftddrkedrud
    dutdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:tYh3XfmxdRvNY4s1T5y0sBtbyr4p_qhglJBDIIKZhWvAzemZIdB5Ew>
    <xmx:tYh3XYWcLbl6LyixmBKIag-ab3a1d2Dg66Nl9ZkFwRi5yk-8JCSOGA>
    <xmx:tYh3Xd-5wdXwSOhwTHHKbAEph0nj36q9vtB0rtxVAZ90xzMew_uhQA>
    <xmx:tYh3XfaTuXaKJp-RFugiPHifc8nNf3h8BPdZT0xHTMY9Bb0w_NhGkA>
Received: from localhost (110.8.30.213.rev.vodafone.pt [213.30.8.110])
        by mail.messagingengine.com (Postfix) with ESMTPA id 853AAD6005E;
        Tue, 10 Sep 2019 07:27:48 -0400 (EDT)
Subject: FAILED: patch "[PATCH] powerpc/tm: Fix restoring FP/VMX facility incorrectly on" failed to apply to 4.19-stable tree
To:     gromero@linux.ibm.com, mikey@neuling.org, mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Sep 2019 12:27:45 +0100
Message-ID: <15681148654568@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a8318c13e79badb92bc6640704a64cc022a6eb97 Mon Sep 17 00:00:00 2001
From: Gustavo Romero <gromero@linux.ibm.com>
Date: Wed, 4 Sep 2019 00:55:28 -0400
Subject: [PATCH] powerpc/tm: Fix restoring FP/VMX facility incorrectly on
 interrupts

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

diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 437b57068cf8..7a84c9f1778e 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -101,21 +101,8 @@ static void check_if_tm_restore_required(struct task_struct *tsk)
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
@@ -252,7 +239,7 @@ EXPORT_SYMBOL(enable_kernel_fp);
 
 static int restore_fp(struct task_struct *tsk)
 {
-	if (tsk->thread.load_fp || tm_active_with_fp(tsk)) {
+	if (tsk->thread.load_fp) {
 		load_fp_state(&current->thread.fp_state);
 		current->thread.load_fp++;
 		return 1;
@@ -334,8 +321,7 @@ EXPORT_SYMBOL_GPL(flush_altivec_to_thread);
 
 static int restore_altivec(struct task_struct *tsk)
 {
-	if (cpu_has_feature(CPU_FTR_ALTIVEC) &&
-		(tsk->thread.load_vec || tm_active_with_altivec(tsk))) {
+	if (cpu_has_feature(CPU_FTR_ALTIVEC) && (tsk->thread.load_vec)) {
 		load_vr_state(&tsk->thread.vr_state);
 		tsk->thread.used_vr = 1;
 		tsk->thread.load_vec++;

