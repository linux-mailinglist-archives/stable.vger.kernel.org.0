Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7201515C3A5
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728979AbgBMPnS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:43:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:53452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729516AbgBMP15 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:27:57 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB17324677;
        Thu, 13 Feb 2020 15:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607675;
        bh=XChCWwQA7p49qpA7/oQtOGhUEGaG7pAcVi/m2bGRhos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VoXfpWIqE6FnawUyVL2e8x2DNg3DGgIlOby/2ITbeH32EdstS6vh0anBiiE0qxZDZ
         e9AEpKEUwStDnNcoXrJ9auy6DupGSreJHRttKFt3zUCcZu5zOnt9OrBIEvuFrHkMJg
         tAbZBFc9QVIF0rhsGyVded2uXk9DxqBEvp8nXaXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 5.4 74/96] arm64: nofpsmid: Handle TIF_FOREIGN_FPSTATE flag cleanly
Date:   Thu, 13 Feb 2020 07:21:21 -0800
Message-Id: <20200213151907.256354946@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
References: <20200213151839.156309910@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

commit 52f73c383b2418f2d31b798e765ae7d596c35021 upstream.

We detect the absence of FP/SIMD after an incapable CPU is brought up,
and by then we have kernel threads running already with TIF_FOREIGN_FPSTATE set
which could be set for early userspace applications (e.g, modprobe triggered
from initramfs) and init. This could cause the applications to loop forever in
do_nofity_resume() as we never clear the TIF flag, once we now know that
we don't support FP.

Fix this by making sure that we clear the TIF_FOREIGN_FPSTATE flag
for tasks which may have them set, as we would have done in the normal
case, but avoiding touching the hardware state (since we don't support any).

Also to make sure we handle the cases seemlessly we categorise the
helper functions to two :
 1) Helpers for common core code, which calls into take appropriate
    actions without knowing the current FPSIMD state of the CPU/task.

    e.g fpsimd_restore_current_state(), fpsimd_flush_task_state(),
        fpsimd_save_and_flush_cpu_state().

    We bail out early for these functions, taking any appropriate actions
    (e.g, clearing the TIF flag) where necessary to hide the handling
    from core code.

 2) Helpers used when the presence of FP/SIMD is apparent.
    i.e, save/restore the FP/SIMD register state, modify the CPU/task
    FP/SIMD state.
    e.g,

    fpsimd_save(), task_fpsimd_load() - save/restore task FP/SIMD registers

    fpsimd_bind_task_to_cpu()  \
                                - Update the "state" metadata for CPU/task.
    fpsimd_bind_state_to_cpu() /

    fpsimd_update_current_state() - Update the fp/simd state for the current
                                    task from memory.

    These must not be called in the absence of FP/SIMD. Put in a WARNING
    to make sure they are not invoked in the absence of FP/SIMD.

KVM also uses the TIF_FOREIGN_FPSTATE flag to manage the FP/SIMD state
on the CPU. However, without FP/SIMD support we trap all accesses and
inject undefined instruction. Thus we should never "load" guest state.
Add a sanity check to make sure this is valid.

Fixes: 82e0191a1aa11abf ("arm64: Support systems without FP/ASIMD")
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/fpsimd.c  |   30 +++++++++++++++++++++++++++---
 arch/arm64/kvm/hyp/switch.c |   10 +++++++++-
 2 files changed, 36 insertions(+), 4 deletions(-)

--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -269,6 +269,7 @@ static void sve_free(struct task_struct
  */
 static void task_fpsimd_load(void)
 {
+	WARN_ON(!system_supports_fpsimd());
 	WARN_ON(!have_cpu_fpsimd_context());
 
 	if (system_supports_sve() && test_thread_flag(TIF_SVE))
@@ -289,6 +290,7 @@ static void fpsimd_save(void)
 		this_cpu_ptr(&fpsimd_last_state);
 	/* set by fpsimd_bind_task_to_cpu() or fpsimd_bind_state_to_cpu() */
 
+	WARN_ON(!system_supports_fpsimd());
 	WARN_ON(!have_cpu_fpsimd_context());
 
 	if (!test_thread_flag(TIF_FOREIGN_FPSTATE)) {
@@ -1092,6 +1094,7 @@ void fpsimd_bind_task_to_cpu(void)
 	struct fpsimd_last_state_struct *last =
 		this_cpu_ptr(&fpsimd_last_state);
 
+	WARN_ON(!system_supports_fpsimd());
 	last->st = &current->thread.uw.fpsimd_state;
 	last->sve_state = current->thread.sve_state;
 	last->sve_vl = current->thread.sve_vl;
@@ -1114,6 +1117,7 @@ void fpsimd_bind_state_to_cpu(struct use
 	struct fpsimd_last_state_struct *last =
 		this_cpu_ptr(&fpsimd_last_state);
 
+	WARN_ON(!system_supports_fpsimd());
 	WARN_ON(!in_softirq() && !irqs_disabled());
 
 	last->st = st;
@@ -1128,8 +1132,19 @@ void fpsimd_bind_state_to_cpu(struct use
  */
 void fpsimd_restore_current_state(void)
 {
-	if (!system_supports_fpsimd())
+	/*
+	 * For the tasks that were created before we detected the absence of
+	 * FP/SIMD, the TIF_FOREIGN_FPSTATE could be set via fpsimd_thread_switch(),
+	 * e.g, init. This could be then inherited by the children processes.
+	 * If we later detect that the system doesn't support FP/SIMD,
+	 * we must clear the flag for  all the tasks to indicate that the
+	 * FPSTATE is clean (as we can't have one) to avoid looping for ever in
+	 * do_notify_resume().
+	 */
+	if (!system_supports_fpsimd()) {
+		clear_thread_flag(TIF_FOREIGN_FPSTATE);
 		return;
+	}
 
 	get_cpu_fpsimd_context();
 
@@ -1148,7 +1163,7 @@ void fpsimd_restore_current_state(void)
  */
 void fpsimd_update_current_state(struct user_fpsimd_state const *state)
 {
-	if (!system_supports_fpsimd())
+	if (WARN_ON(!system_supports_fpsimd()))
 		return;
 
 	get_cpu_fpsimd_context();
@@ -1179,7 +1194,13 @@ void fpsimd_update_current_state(struct
 void fpsimd_flush_task_state(struct task_struct *t)
 {
 	t->thread.fpsimd_cpu = NR_CPUS;
-
+	/*
+	 * If we don't support fpsimd, bail out after we have
+	 * reset the fpsimd_cpu for this task and clear the
+	 * FPSTATE.
+	 */
+	if (!system_supports_fpsimd())
+		return;
 	barrier();
 	set_tsk_thread_flag(t, TIF_FOREIGN_FPSTATE);
 
@@ -1193,6 +1214,7 @@ void fpsimd_flush_task_state(struct task
  */
 static void fpsimd_flush_cpu_state(void)
 {
+	WARN_ON(!system_supports_fpsimd());
 	__this_cpu_write(fpsimd_last_state.st, NULL);
 	set_thread_flag(TIF_FOREIGN_FPSTATE);
 }
@@ -1203,6 +1225,8 @@ static void fpsimd_flush_cpu_state(void)
  */
 void fpsimd_save_and_flush_cpu_state(void)
 {
+	if (!system_supports_fpsimd())
+		return;
 	WARN_ON(preemptible());
 	__get_cpu_fpsimd_context();
 	fpsimd_save();
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -28,7 +28,15 @@
 /* Check whether the FP regs were dirtied while in the host-side run loop: */
 static bool __hyp_text update_fp_enabled(struct kvm_vcpu *vcpu)
 {
-	if (vcpu->arch.host_thread_info->flags & _TIF_FOREIGN_FPSTATE)
+	/*
+	 * When the system doesn't support FP/SIMD, we cannot rely on
+	 * the _TIF_FOREIGN_FPSTATE flag. However, we always inject an
+	 * abort on the very first access to FP and thus we should never
+	 * see KVM_ARM64_FP_ENABLED. For added safety, make sure we always
+	 * trap the accesses.
+	 */
+	if (!system_supports_fpsimd() ||
+	    vcpu->arch.host_thread_info->flags & _TIF_FOREIGN_FPSTATE)
 		vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED |
 				      KVM_ARM64_FP_HOST);
 


