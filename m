Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1975354A688
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354677AbiFNC1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354616AbiFNCZa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:25:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AEC736E35;
        Mon, 13 Jun 2022 19:11:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF59960EE1;
        Tue, 14 Jun 2022 02:11:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 219F2C341C0;
        Tue, 14 Jun 2022 02:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172679;
        bh=cx8dXSfJMM65Dx7oEQhGNE/xAv1BxP8sP+76SbXcyk4=;
        h=From:To:Cc:Subject:Date:From;
        b=k7KyrYxoRwXI+CoQq3EYfe7dRskOcE9t97WvY5GWt1TjuQ75TV01iBvcVfEdIOYnD
         wFGLVDUcfVvjrjBEWPNXeQ7rCebqKfeEDRvkQAff3eY3Cr1dnpEWhMSTe0cq4Plots
         yt6YoV9LHTTHInsK3JMs4CWg1JlP0pmWUxx/i9J3VpFxJBfHhE1/s69s2TbowYsMuZ
         UkX+CAShw4wK/GLqGnOeMimE0iTjruAWcpcd2Uw/LeJvpSbZHx3Qnw6B7JiNIp+kiS
         r7CJdr0FE7AtunwauN900lawq95moOvoZOy2+BNOlkrg1pKHD+NEvfX+pyGk3LRxTw
         pppwNjTJlaqnw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Jann Horn <jannh@google.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.18 1/6] KVM: x86: do not report a vCPU as preempted outside instruction boundaries
Date:   Mon, 13 Jun 2022 22:11:10 -0400
Message-Id: <20220614021116.1101331-1-sashal@kernel.org>
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
index 4ff36610af6a..9fdaa847d4b6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -651,6 +651,7 @@ struct kvm_vcpu_arch {
 	u64 ia32_misc_enable_msr;
 	u64 smbase;
 	u64 smi_count;
+	bool at_instruction_boundary;
 	bool tpr_access_reporting;
 	bool xsaves_enabled;
 	bool xfd_no_write_intercept;
@@ -1289,6 +1290,8 @@ struct kvm_vcpu_stat {
 	u64 nested_run;
 	u64 directed_yield_attempted;
 	u64 directed_yield_successful;
+	u64 preemption_reported;
+	u64 preemption_other;
 	u64 guest_mode;
 };
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7e45d03cd018..5842abf1eac4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4165,6 +4165,8 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
 
 static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 {
+	if (to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_INTR)
+		vcpu->arch.at_instruction_boundary = true;
 }
 
 static void svm_sched_in(struct kvm_vcpu *vcpu, int cpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 982df9c000d3..c44f8e1d30c8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6549,6 +6549,7 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 		return;
 
 	handle_interrupt_nmi_irqoff(vcpu, gate_offset(desc));
+	vcpu->arch.at_instruction_boundary = true;
 }
 
 static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 39c571224ac2..36453517e847 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -291,6 +291,8 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, nested_run),
 	STATS_DESC_COUNTER(VCPU, directed_yield_attempted),
 	STATS_DESC_COUNTER(VCPU, directed_yield_successful),
+	STATS_DESC_COUNTER(VCPU, preemption_reported),
+	STATS_DESC_COUNTER(VCPU, preemption_other),
 	STATS_DESC_ICOUNTER(VCPU, guest_mode)
 };
 
@@ -4604,6 +4606,19 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
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
 
@@ -10358,6 +10373,13 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
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

