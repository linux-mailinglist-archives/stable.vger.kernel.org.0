Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A88DC4F02EC
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 15:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243417AbiDBNts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 09:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344402AbiDBNtq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 09:49:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0707160C21
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 06:47:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31C54B80883
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 13:47:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62609C340EE;
        Sat,  2 Apr 2022 13:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648907270;
        bh=diaRmqEghaoPiIa8npC1IyR/A4XzkS+BUlQBIg2f7RU=;
        h=Subject:To:Cc:From:Date:From;
        b=YsjmgEhE3t5ThcEbS57fyHE125D/EXCIH6AL0IGzvXlIdBoubF8onHsogPIHAmIl6
         wRIXpIOtnbY8YRiYMXUWZNDjpOHq7mqANXqoWzmvm+y6IVTm5cfoy0X+xvWxYu3Sqh
         vjQqtFuXRFJO5VAuixTXkTULvDZmp3wVRC9M0lGM=
Subject: FAILED: patch "[PATCH] KVM: SVM: Disable preemption across AVIC load/put during" failed to apply to 5.16-stable tree
To:     seanjc@google.com, mlevitsk@redhat.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 02 Apr 2022 15:47:45 +0200
Message-ID: <164890726523163@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.16-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b652de1e3dfb3b49e539e88a684a68e333e1bd7c Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 1 Mar 2022 09:05:09 -0800
Subject: [PATCH] KVM: SVM: Disable preemption across AVIC load/put during
 APICv refresh

Disable preemption when loading/putting the AVIC during an APICv refresh.
If the vCPU task is preempted and migrated ot a different pCPU, the
unprotected avic_vcpu_load() could set the wrong pCPU in the physical ID
cache/table.

Pull the necessary code out of avic_vcpu_{,un}blocking() and into a new
helper to reduce the probability of introducing this exact bug a third
time.

Fixes: df7e4827c549 ("KVM: SVM: call avic_vcpu_load/avic_vcpu_put when enabling/disabling AVIC")
Cc: stable@vger.kernel.org
Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index aea0b13773fd..1afde44b1252 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -616,38 +616,6 @@ static int avic_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
 	return ret;
 }
 
-void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
-	struct vmcb *vmcb = svm->vmcb01.ptr;
-	bool activated = kvm_vcpu_apicv_active(vcpu);
-
-	if (!enable_apicv)
-		return;
-
-	if (activated) {
-		/**
-		 * During AVIC temporary deactivation, guest could update
-		 * APIC ID, DFR and LDR registers, which would not be trapped
-		 * by avic_unaccelerated_access_interception(). In this case,
-		 * we need to check and update the AVIC logical APIC ID table
-		 * accordingly before re-activating.
-		 */
-		avic_apicv_post_state_restore(vcpu);
-		vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
-	} else {
-		vmcb->control.int_ctl &= ~AVIC_ENABLE_MASK;
-	}
-	vmcb_mark_dirty(vmcb, VMCB_AVIC);
-
-	if (activated)
-		avic_vcpu_load(vcpu, vcpu->cpu);
-	else
-		avic_vcpu_put(vcpu);
-
-	avic_set_pi_irte_mode(vcpu, activated);
-}
-
 static void svm_ir_list_del(struct vcpu_svm *svm, struct amd_iommu_pi_data *pi)
 {
 	unsigned long flags;
@@ -899,7 +867,7 @@ avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
 	return ret;
 }
 
-void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	u64 entry;
 	/* ID = 0xff (broadcast), ID > 0xff (reserved) */
@@ -936,7 +904,7 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, true);
 }
 
-void avic_vcpu_put(struct kvm_vcpu *vcpu)
+void __avic_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	u64 entry;
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -955,13 +923,63 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
 }
 
+static void avic_vcpu_load(struct kvm_vcpu *vcpu)
+{
+	int cpu = get_cpu();
+
+	WARN_ON(cpu != vcpu->cpu);
+
+	__avic_vcpu_load(vcpu, cpu);
+
+	put_cpu();
+}
+
+static void avic_vcpu_put(struct kvm_vcpu *vcpu)
+{
+	preempt_disable();
+
+	__avic_vcpu_put(vcpu);
+
+	preempt_enable();
+}
+
+void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb *vmcb = svm->vmcb01.ptr;
+	bool activated = kvm_vcpu_apicv_active(vcpu);
+
+	if (!enable_apicv)
+		return;
+
+	if (activated) {
+		/**
+		 * During AVIC temporary deactivation, guest could update
+		 * APIC ID, DFR and LDR registers, which would not be trapped
+		 * by avic_unaccelerated_access_interception(). In this case,
+		 * we need to check and update the AVIC logical APIC ID table
+		 * accordingly before re-activating.
+		 */
+		avic_apicv_post_state_restore(vcpu);
+		vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
+	} else {
+		vmcb->control.int_ctl &= ~AVIC_ENABLE_MASK;
+	}
+	vmcb_mark_dirty(vmcb, VMCB_AVIC);
+
+	if (activated)
+		avic_vcpu_load(vcpu);
+	else
+		avic_vcpu_put(vcpu);
+
+	avic_set_pi_irte_mode(vcpu, activated);
+}
+
 void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
 {
 	if (!kvm_vcpu_apicv_active(vcpu))
 		return;
 
-	preempt_disable();
-
        /*
         * Unload the AVIC when the vCPU is about to block, _before_
         * the vCPU actually blocks.
@@ -976,21 +994,12 @@ void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
         * the cause of errata #1235).
         */
 	avic_vcpu_put(vcpu);
-
-	preempt_enable();
 }
 
 void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
 {
-	int cpu;
-
 	if (!kvm_vcpu_apicv_active(vcpu))
 		return;
 
-	cpu = get_cpu();
-	WARN_ON(cpu != vcpu->cpu);
-
-	avic_vcpu_load(vcpu, cpu);
-
-	put_cpu();
+	avic_vcpu_load(vcpu);
 }
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7038c76fa841..c5e3f219803e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1318,13 +1318,13 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		indirect_branch_prediction_barrier();
 	}
 	if (kvm_vcpu_apicv_active(vcpu))
-		avic_vcpu_load(vcpu, cpu);
+		__avic_vcpu_load(vcpu, cpu);
 }
 
 static void svm_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	if (kvm_vcpu_apicv_active(vcpu))
-		avic_vcpu_put(vcpu);
+		__avic_vcpu_put(vcpu);
 
 	svm_prepare_host_switch(vcpu);
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 70850cbe5bcb..e45b5645d5e0 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -576,8 +576,8 @@ void avic_init_vmcb(struct vcpu_svm *svm);
 int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu);
 int avic_unaccelerated_access_interception(struct kvm_vcpu *vcpu);
 int avic_init_vcpu(struct vcpu_svm *svm);
-void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
-void avic_vcpu_put(struct kvm_vcpu *vcpu);
+void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
+void __avic_vcpu_put(struct kvm_vcpu *vcpu);
 void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu);
 void avic_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu);

