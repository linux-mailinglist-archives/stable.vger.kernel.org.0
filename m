Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7D01630DB
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 20:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbgBRT5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 14:57:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:34198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727761AbgBRT5B (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 14:57:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A7C124670;
        Tue, 18 Feb 2020 19:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582055819;
        bh=mi1fa9tjV0BUcFYBmkbrq5si7+ROUjp6B9kLMqc2Fkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OlE93QL8HCTLTCrVxk+YobygV38gC/i0Rylq80NmgBaKSed3RCNRZ6bwp66cFejXi
         8bWLauJToTnDrwjDPFkiREk2aC5zyXHJQ6P1AfdXU8mcDU8+l9KfC0s9tZ9Zrul2F0
         +AyoK9sjpCyMYPn1/SzF2sNcB8jPDtle5m2pqyvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 08/38] arm64: nofpsmid: Handle TIF_FOREIGN_FPSTATE flag cleanly
Date:   Tue, 18 Feb 2020 20:54:54 +0100
Message-Id: <20200218190419.519633378@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190418.536430858@linuxfoundation.org>
References: <20200218190418.536430858@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

commit 52f73c383b2418f2d31b798e765ae7d596c35021 upstream

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

Cc: stable@vger.kernel.org # v4.19
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/fpsimd.c  | 20 ++++++++++++++++++--
 arch/arm64/kvm/hyp/switch.c | 10 +++++++++-
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 58c53bc969289..14fdbaa6ee3ab 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -218,6 +218,7 @@ static void sve_free(struct task_struct *task)
 static void task_fpsimd_load(void)
 {
 	WARN_ON(!in_softirq() && !irqs_disabled());
+	WARN_ON(!system_supports_fpsimd());
 
 	if (system_supports_sve() && test_thread_flag(TIF_SVE))
 		sve_load_state(sve_pffr(&current->thread),
@@ -238,6 +239,7 @@ void fpsimd_save(void)
 	struct user_fpsimd_state *st = __this_cpu_read(fpsimd_last_state.st);
 	/* set by fpsimd_bind_task_to_cpu() or fpsimd_bind_state_to_cpu() */
 
+	WARN_ON(!system_supports_fpsimd());
 	WARN_ON(!in_softirq() && !irqs_disabled());
 
 	if (!test_thread_flag(TIF_FOREIGN_FPSTATE)) {
@@ -977,6 +979,7 @@ void fpsimd_bind_task_to_cpu(void)
 	struct fpsimd_last_state_struct *last =
 		this_cpu_ptr(&fpsimd_last_state);
 
+	WARN_ON(!system_supports_fpsimd());
 	last->st = &current->thread.uw.fpsimd_state;
 	current->thread.fpsimd_cpu = smp_processor_id();
 
@@ -996,6 +999,7 @@ void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *st)
 	struct fpsimd_last_state_struct *last =
 		this_cpu_ptr(&fpsimd_last_state);
 
+	WARN_ON(!system_supports_fpsimd());
 	WARN_ON(!in_softirq() && !irqs_disabled());
 
 	last->st = st;
@@ -1008,8 +1012,19 @@ void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *st)
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
 
 	local_bh_disable();
 
@@ -1028,7 +1043,7 @@ void fpsimd_restore_current_state(void)
  */
 void fpsimd_update_current_state(struct user_fpsimd_state const *state)
 {
-	if (!system_supports_fpsimd())
+	if (WARN_ON(!system_supports_fpsimd()))
 		return;
 
 	local_bh_disable();
@@ -1055,6 +1070,7 @@ void fpsimd_flush_task_state(struct task_struct *t)
 
 void fpsimd_flush_cpu_state(void)
 {
+	WARN_ON(!system_supports_fpsimd());
 	__this_cpu_write(fpsimd_last_state.st, NULL);
 	set_thread_flag(TIF_FOREIGN_FPSTATE);
 }
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 6290a4e81d57a..f3978931aaf40 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -37,7 +37,15 @@
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
 
-- 
2.20.1



