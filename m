Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32D1C548068
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 09:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237859AbiFMHVB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 03:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232635AbiFMHVA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 03:21:00 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B679A1ADB0
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 00:20:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 14FE3CE0F77
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 07:20:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D282C34114;
        Mon, 13 Jun 2022 07:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655104856;
        bh=PJtZ5jFJZWQA5bimDc4ut2i1mFQN/ujU8sjmTl89AI4=;
        h=Subject:To:Cc:From:Date:From;
        b=Dfxk6CLO0Amiocn9nDo3x84rAw3tVQ0aZmh4S8PHwnLSG+jX2QxznW5lXDYVYDXy3
         v9eTrHD6FLmj2PrqJjHOPcxC+huBQRZScGXzEA0agdeQRcmSqDMynmah6zjErYkvil
         61nEhyiv9zPw9X6VTqnoAyK9H91jP86bhqAOLA9I=
Subject: FAILED: patch "[PATCH] KVM: SVM: fix tsc scaling cache logic" failed to apply to 5.15-stable tree
To:     mlevitsk@redhat.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Jun 2022 09:20:53 +0200
Message-ID: <165510485318356@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 11d39e8cc43e1c6737af19ca9372e590061b5ad2 Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <mlevitsk@redhat.com>
Date: Mon, 6 Jun 2022 21:11:49 +0300
Subject: [PATCH] KVM: SVM: fix tsc scaling cache logic

SVM uses a per-cpu variable to cache the current value of the
tsc scaling multiplier msr on each cpu.

Commit 1ab9287add5e2
("KVM: X86: Add vendor callbacks for writing the TSC multiplier")
broke this caching logic.

Refactor the code so that all TSC scaling multiplier writes go through
a single function which checks and updates the cache.

This fixes the following scenario:

1. A CPU runs a guest with some tsc scaling ratio.

2. New guest with different tsc scaling ratio starts on this CPU
   and terminates almost immediately.

   This ensures that the short running guest had set the tsc scaling ratio just
   once when it was set via KVM_SET_TSC_KHZ. Due to the bug,
   the per-cpu cache is not updated.

3. The original guest continues to run, it doesn't restore the msr
   value back to its own value, because the cache matches,
   and thus continues to run with a wrong tsc scaling ratio.

Fixes: 1ab9287add5e2 ("KVM: X86: Add vendor callbacks for writing the TSC multiplier")
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20220606181149.103072-1-mlevitsk@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index bed5e1692cef..3361258640a2 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -982,7 +982,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	if (svm->tsc_ratio_msr != kvm_default_tsc_scaling_ratio) {
 		WARN_ON(!svm->tsc_scaling_enabled);
 		vcpu->arch.tsc_scaling_ratio = vcpu->arch.l1_tsc_scaling_ratio;
-		svm_write_tsc_multiplier(vcpu, vcpu->arch.tsc_scaling_ratio);
+		__svm_write_tsc_multiplier(vcpu->arch.tsc_scaling_ratio);
 	}
 
 	svm->nested.ctl.nested_cr3 = 0;
@@ -1387,7 +1387,7 @@ void nested_svm_update_tsc_ratio_msr(struct kvm_vcpu *vcpu)
 	vcpu->arch.tsc_scaling_ratio =
 		kvm_calc_nested_tsc_multiplier(vcpu->arch.l1_tsc_scaling_ratio,
 					       svm->tsc_ratio_msr);
-	svm_write_tsc_multiplier(vcpu, vcpu->arch.tsc_scaling_ratio);
+	__svm_write_tsc_multiplier(vcpu->arch.tsc_scaling_ratio);
 }
 
 /* Inverse operation of nested_copy_vmcb_control_to_cache(). asid is copied too. */
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 63880b33ce37..478e6ee81d88 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -465,11 +465,24 @@ static int has_svm(void)
 	return 1;
 }
 
+void __svm_write_tsc_multiplier(u64 multiplier)
+{
+	preempt_disable();
+
+	if (multiplier == __this_cpu_read(current_tsc_ratio))
+		goto out;
+
+	wrmsrl(MSR_AMD64_TSC_RATIO, multiplier);
+	__this_cpu_write(current_tsc_ratio, multiplier);
+out:
+	preempt_enable();
+}
+
 static void svm_hardware_disable(void)
 {
 	/* Make sure we clean up behind us */
 	if (tsc_scaling)
-		wrmsrl(MSR_AMD64_TSC_RATIO, SVM_TSC_RATIO_DEFAULT);
+		__svm_write_tsc_multiplier(SVM_TSC_RATIO_DEFAULT);
 
 	cpu_svm_disable();
 
@@ -515,8 +528,7 @@ static int svm_hardware_enable(void)
 		 * Set the default value, even if we don't use TSC scaling
 		 * to avoid having stale value in the msr
 		 */
-		wrmsrl(MSR_AMD64_TSC_RATIO, SVM_TSC_RATIO_DEFAULT);
-		__this_cpu_write(current_tsc_ratio, SVM_TSC_RATIO_DEFAULT);
+		__svm_write_tsc_multiplier(SVM_TSC_RATIO_DEFAULT);
 	}
 
 
@@ -999,11 +1011,12 @@ static void svm_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 	vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
 }
 
-void svm_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 multiplier)
+static void svm_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 multiplier)
 {
-	wrmsrl(MSR_AMD64_TSC_RATIO, multiplier);
+	__svm_write_tsc_multiplier(multiplier);
 }
 
+
 /* Evaluate instruction intercepts that depend on guest CPUID features. */
 static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu,
 					      struct vcpu_svm *svm)
@@ -1363,13 +1376,8 @@ static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 		sev_es_prepare_switch_to_guest(hostsa);
 	}
 
-	if (tsc_scaling) {
-		u64 tsc_ratio = vcpu->arch.tsc_scaling_ratio;
-		if (tsc_ratio != __this_cpu_read(current_tsc_ratio)) {
-			__this_cpu_write(current_tsc_ratio, tsc_ratio);
-			wrmsrl(MSR_AMD64_TSC_RATIO, tsc_ratio);
-		}
-	}
+	if (tsc_scaling)
+		__svm_write_tsc_multiplier(vcpu->arch.tsc_scaling_ratio);
 
 	if (likely(tsc_aux_uret_slot >= 0))
 		kvm_set_user_return_msr(tsc_aux_uret_slot, svm->tsc_aux, -1ull);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 45a87b2a8b3c..29d6fd205a49 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -590,7 +590,7 @@ int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 			       bool has_error_code, u32 error_code);
 int nested_svm_exit_special(struct vcpu_svm *svm);
 void nested_svm_update_tsc_ratio_msr(struct kvm_vcpu *vcpu);
-void svm_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 multiplier);
+void __svm_write_tsc_multiplier(u64 multiplier);
 void nested_copy_vmcb_control_to_cache(struct vcpu_svm *svm,
 				       struct vmcb_control_area *control);
 void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,

