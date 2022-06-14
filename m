Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDF3854A67E
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355414AbiFNCcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355627AbiFNC3K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:29:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F38842EC1;
        Mon, 13 Jun 2022 19:11:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D38D61024;
        Tue, 14 Jun 2022 02:11:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FBB2C341C0;
        Tue, 14 Jun 2022 02:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172693;
        bh=pr6NzkI/XxpvvWceynxWmelVmldc64zZZ/z4qQBpAw8=;
        h=From:To:Cc:Subject:Date:From;
        b=sCTNonAu9ASXxM1AfMO5mzjr08ECI7hZ96nSnREhKgZvmJhx8DPoDaLDOl9L5eO24
         8txqD0Rd9PrizgfHHWOUyvDC3/YXZf8ptsouBqOmxPsFpuhGpS3eM3KEZTWGKFl8ff
         h4oJXKUC3R8REpt6Rmye0u631zneO0/4HkMaYRAH350E8l8clmqXGptA9Oc2+jGt8i
         5s8q2wC4uVm91d4qaHMzYQRAC/H4F0rRsGFECYG0ZCmrW+Vuoaykbm+iYj6VKj+VoH
         s343mBK1Is14DgL3EsfUv3wFmPVLyNWh0PVSDmAdN+zhvGYW0JoGAiEZ1TKEew4hhQ
         cxTej1jHeMYBQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Jann Horn <jannh@google.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.17 1/4] KVM: x86: do not report a vCPU as preempted outside instruction boundaries
Date:   Mon, 13 Jun 2022 22:11:27 -0400
Message-Id: <20220614021130.1101425-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit 6cd88243c7e03845a450795e134b488fc2afb736 ]

If a vCPU is outside guest mode and is scheduled out, it might be in the
process of making a memory access.  A problem occurs if another vCPU uses
the PV TLB flush feature during the period when the vCPU is scheduled
out, and a virtual address has already been translated but has not yet
been accessed, because this is equivalent to using a stale TLB entry.

To avoid this, only report a vCPU as preempted if sure that the guest
is at an instruction boundary.  A rescheduling request will be delivered
to the host physical CPU as an external interrupt, so for simplicity
consider any vmexit *not* instruction boundary except for external
interrupts.

It would in principle be okay to report the vCPU as preempted also
if it is sleeping in kvm_vcpu_block(): a TLB flush IPI will incur the
vmentry/vmexit overhead unnecessarily, and optimistic spinning is
also unlikely to succeed.  However, leave it for later because right
now kvm_vcpu_check_block() is doing memory accesses.  Even
though the TLB flush issue only applies to virtual memory address,
it's very much preferrable to be conservative.

Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/svm/svm.c          |  2 ++
 arch/x86/kvm/vmx/vmx.c          |  1 +
 arch/x86/kvm/x86.c              | 22 ++++++++++++++++++++++
 4 files changed, 28 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c4b4c0839dbd..db5d454cdf8f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -646,6 +646,7 @@ struct kvm_vcpu_arch {
 	u64 ia32_misc_enable_msr;
 	u64 smbase;
 	u64 smi_count;
+	bool at_instruction_boundary;
 	bool tpr_access_reporting;
 	bool xsaves_enabled;
 	bool xfd_no_write_intercept;
@@ -1283,6 +1284,8 @@ struct kvm_vcpu_stat {
 	u64 nested_run;
 	u64 directed_yield_attempted;
 	u64 directed_yield_successful;
+	u64 preemption_reported;
+	u64 preemption_other;
 	u64 guest_mode;
 };
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index fd3a00c892c7..0b8364f8415c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4182,6 +4182,8 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
 
 static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 {
+	if (to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_INTR)
+		vcpu->arch.at_instruction_boundary = true;
 }
 
 static void svm_sched_in(struct kvm_vcpu *vcpu, int cpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c87be7c52cc2..39a908e3da5a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6550,6 +6550,7 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 		return;
 
 	handle_interrupt_nmi_irqoff(vcpu, gate_offset(desc));
+	vcpu->arch.at_instruction_boundary = true;
 }
 
 static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5204283da798..8445d1d35c79 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -287,6 +287,8 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, nested_run),
 	STATS_DESC_COUNTER(VCPU, directed_yield_attempted),
 	STATS_DESC_COUNTER(VCPU, directed_yield_successful),
+	STATS_DESC_COUNTER(VCPU, preemption_reported),
+	STATS_DESC_COUNTER(VCPU, preemption_other),
 	STATS_DESC_ICOUNTER(VCPU, guest_mode)
 };
 
@@ -4573,6 +4575,19 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 	struct kvm_memslots *slots;
 	static const u8 preempted = KVM_VCPU_PREEMPTED;
 
+	/*
+	 * The vCPU can be marked preempted if and only if the VM-Exit was on
+	 * an instruction boundary and will not trigger guest emulation of any
+	 * kind (see vcpu_run).  Vendor specific code controls (conservatively)
+	 * when this is true, for example allowing the vCPU to be marked
+	 * preempted if and only if the VM-Exit was due to a host interrupt.
+	 */
+	if (!vcpu->arch.at_instruction_boundary) {
+		vcpu->stat.preemption_other++;
+		return;
+	}
+
+	vcpu->stat.preemption_reported++;
 	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
 		return;
 
@@ -10261,6 +10276,13 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 	vcpu->arch.l1tf_flush_l1d = true;
 
 	for (;;) {
+		/*
+		 * If another guest vCPU requests a PV TLB flush in the middle
+		 * of instruction emulation, the rest of the emulation could
+		 * use a stale page translation. Assume that any code after
+		 * this point can start executing an instruction.
+		 */
+		vcpu->arch.at_instruction_boundary = false;
 		if (kvm_vcpu_running(vcpu)) {
 			r = vcpu_enter_guest(vcpu);
 		} else {
-- 
2.35.1

