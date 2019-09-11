Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6846FAF392
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 02:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbfIKANb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 20:13:31 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:47671 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725916AbfIKANb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Sep 2019 20:13:31 -0400
Received: from neuling.org (localhost [127.0.0.1])
        by ozlabs.org (Postfix) with ESMTP id 46Sj6b6p9Zz9sCJ;
        Wed, 11 Sep 2019 10:13:27 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=neuling.org;
        s=201811; t=1568160808;
        bh=0AGDlcZqZDs7DeRmnSi1gq21BoDalePX2/5KJl/r6FI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=B4D5Xwt1TNcUc1FdgQKPD8Hn8WWCpxCFWSu7S7f/pr4xsZtshsbb1ZfjNxVNffs26
         B2pWoblQjbEZgQU9zXJYPZ0upXBpYbDQLeg1a1iy3VRdZJWMo6eOe99KoN0UB2NKIx
         F6NT2xYdia8o61+xrHQZHN6bhlhy6gsvQmh6WbA3wtOD+OnkjbFhr/gVoT59KUsGgz
         FMpI0UaXXEQpab70QGItCIk0OlocR7LQnv/YeDVYQDVeTd0Jn9Wus4QDxbAg+ennIb
         DU9G7ML/liY91NoHlG7moPdmMDoNzeh5g8s9chViBUfpSXtZ0RlG5yF3rcL/pe3pIt
         +Bx4uUbc2gmNg==
Received: by neuling.org (Postfix, from userid 1000)
        id DE3F22A01E8; Wed, 11 Sep 2019 10:13:27 +1000 (AEST)
Message-ID: <07d47bd664b13cf5cdc0361a59b26f9e448e2079.camel@neuling.org>
Subject: [PATCH 4.19] powerpc/tm: Fix restoring FP/VMX facility incorrectly
 on interrupts
From:   Michael Neuling <mikey@neuling.org>
To:     gregkh@linuxfoundation.org, gromero@linux.ibm.com,
        mpe@ellerman.id.au
Cc:     stable@vger.kernel.org
Date:   Wed, 11 Sep 2019 10:13:27 +1000
In-Reply-To: <15681148654568@kroah.com>
References: <15681148654568@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When in userspace and MSR FP=3D0 the hardware FP state is unrelated to
the current process. This is extended for transactions where if tbegin
is run with FP=3D0, the hardware checkpoint FP state will also be
unrelated to the current process. Due to this, we need to ensure this
hardware checkpoint is updated with the correct state before we enable
FP for this process.

Unfortunately we get this wrong when returning to a process from a
hardware interrupt. A process that starts a transaction with FP=3D0 can
take an interrupt. When the kernel returns back to that process, we
change to FP=3D1 but with hardware checkpoint FP state not updated. If
this transaction is then rolled back, the FP registers now contain the
wrong state.

The process looks like this:
   Userspace:                      Kernel

               Start userspace
                with MSR FP=3D0 TM=3D1
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
				        /* sees FP=3D0 */
                                        restore_fp()
                                          tm_active_with_fp()
					    /* sees FP=3D1 (Incorrect) */
                                          load_fp_state()
                                        FP =3D 0 -> 1
                  < -----
               Return to userspace
                 with MSR TM=3D1 FP=3D1
                 with junk in the FP TM checkpoint
   TM rollback
   reads FP junk

When returning from the hardware exception, tm_active_with_fp() is
incorrectly making restore_fp() call load_fp_state() which is setting
FP=3D1.

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

Fixes: a7771176b439 ("powerpc: Don't enable FP/Altivec if not checkpointed"=
)
Cc: stable@vger.kernel.org # 4.15+
Signed-off-by: Gustavo Romero <gromero@linux.ibm.com>
Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190904045529.23002-2-gromero@linux.vnet.i=
bm.com
---
Greg, This is a backport for v4.19 only since the original patch didn't
apply.

Commit a8318c13e79badb92bc6640704a64cc022a6eb97 upstream.

arch/powerpc/kernel/process.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index d29f2dca72..96edb4e129 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -106,23 +106,9 @@ static inline bool msr_tm_active(unsigned long msr)
 {
 	return MSR_TM_ACTIVE(msr);
 }
-
-static bool tm_active_with_fp(struct task_struct *tsk)
-{
-	return msr_tm_active(tsk->thread.regs->msr) &&
-		(tsk->thread.ckpt_regs.msr & MSR_FP);
-}
-
-static bool tm_active_with_altivec(struct task_struct *tsk)
-{
-	return msr_tm_active(tsk->thread.regs->msr) &&
-		(tsk->thread.ckpt_regs.msr & MSR_VEC);
-}
 #else
 static inline bool msr_tm_active(unsigned long msr) { return false; }
 static inline void check_if_tm_restore_required(struct task_struct *tsk) {=
 }
-static inline bool tm_active_with_fp(struct task_struct *tsk) { return fal=
se; }
-static inline bool tm_active_with_altivec(struct task_struct *tsk) { retur=
n false; }
 #endif /* CONFIG_PPC_TRANSACTIONAL_MEM */
=20
 bool strict_msr_control;
@@ -256,7 +242,7 @@ EXPORT_SYMBOL(enable_kernel_fp);
=20
 static int restore_fp(struct task_struct *tsk)
 {
-	if (tsk->thread.load_fp || tm_active_with_fp(tsk)) {
+	if (tsk->thread.load_fp) {
 		load_fp_state(&current->thread.fp_state);
 		current->thread.load_fp++;
 		return 1;
@@ -337,8 +323,7 @@ EXPORT_SYMBOL_GPL(flush_altivec_to_thread);
=20
 static int restore_altivec(struct task_struct *tsk)
 {
-	if (cpu_has_feature(CPU_FTR_ALTIVEC) &&
-		(tsk->thread.load_vec || tm_active_with_altivec(tsk))) {
+	if (cpu_has_feature(CPU_FTR_ALTIVEC) && (tsk->thread.load_vec)) {
 		load_vr_state(&tsk->thread.vr_state);
 		tsk->thread.used_vr =3D 1;
 		tsk->thread.load_vec++;
--=20
2.21.0


