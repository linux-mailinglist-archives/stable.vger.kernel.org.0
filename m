Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9F76811C2
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237365AbjA3OQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:16:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237383AbjA3OQc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:16:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E034C3CE1F
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:16:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D42061047
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:16:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9E4C433EF;
        Mon, 30 Jan 2023 14:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088189;
        bh=yP+C9jsDkhvmUpRU0rh3670V1w1/7fAVpedJOou/BHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wmWr6XEzBO9sOKbms0+0DseR+rRa4kIgM8DqYnvKn1U7OUHB5y0Kz3q/kdeifAmfO
         iuKtA/JwOcKfAQJk+BbCnmjl3sce9ZpNbrG6ArwQCWkXeJc8W9Z3qRbqqN1Yixz+gb
         vCEQ+VBJdxL3dwAdNpAMFV480ozQ5ey/5WoHI6y0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 146/204] KVM: SVM: fix tsc scaling cache logic
Date:   Mon, 30 Jan 2023 14:51:51 +0100
Message-Id: <20230130134322.967580282@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

[ Upstream commit 11d39e8cc43e1c6737af19ca9372e590061b5ad2 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/svm.c | 34 +++++++++++++++++++++++-----------
 arch/x86/kvm/svm/svm.h |  1 +
 2 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 773420203305..c1a758038892 100644
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
 	if (static_cpu_has(X86_FEATURE_TSCRATEMSR))
-		wrmsrl(MSR_AMD64_TSC_RATIO, TSC_RATIO_DEFAULT);
+		__svm_write_tsc_multiplier(TSC_RATIO_DEFAULT);
 
 	cpu_svm_disable();
 
@@ -511,8 +524,11 @@ static int svm_hardware_enable(void)
 	wrmsrl(MSR_VM_HSAVE_PA, __sme_page_pa(sd->save_area));
 
 	if (static_cpu_has(X86_FEATURE_TSCRATEMSR)) {
-		wrmsrl(MSR_AMD64_TSC_RATIO, TSC_RATIO_DEFAULT);
-		__this_cpu_write(current_tsc_ratio, TSC_RATIO_DEFAULT);
+		/*
+		 * Set the default value, even if we don't use TSC scaling
+		 * to avoid having stale value in the msr
+		 */
+		__svm_write_tsc_multiplier(TSC_RATIO_DEFAULT);
 	}
 
 
@@ -1125,9 +1141,10 @@ static void svm_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 
 static void svm_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 multiplier)
 {
-	wrmsrl(MSR_AMD64_TSC_RATIO, multiplier);
+	__svm_write_tsc_multiplier(multiplier);
 }
 
+
 /* Evaluate instruction intercepts that depend on guest CPUID features. */
 static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu,
 					      struct vcpu_svm *svm)
@@ -1451,13 +1468,8 @@ static void svm_prepare_guest_switch(struct kvm_vcpu *vcpu)
 		vmsave(__sme_page_pa(sd->save_area));
 	}
 
-	if (static_cpu_has(X86_FEATURE_TSCRATEMSR)) {
-		u64 tsc_ratio = vcpu->arch.tsc_scaling_ratio;
-		if (tsc_ratio != __this_cpu_read(current_tsc_ratio)) {
-			__this_cpu_write(current_tsc_ratio, tsc_ratio);
-			wrmsrl(MSR_AMD64_TSC_RATIO, tsc_ratio);
-		}
-	}
+	if (static_cpu_has(X86_FEATURE_TSCRATEMSR))
+		__svm_write_tsc_multiplier(vcpu->arch.tsc_scaling_ratio);
 
 	if (likely(tsc_aux_uret_slot >= 0))
 		kvm_set_user_return_msr(tsc_aux_uret_slot, svm->tsc_aux, -1ull);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 7004f356edf9..1d9b1a9e4398 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -487,6 +487,7 @@ int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 int nested_svm_exit_special(struct vcpu_svm *svm);
 void nested_load_control_from_vmcb12(struct vcpu_svm *svm,
 				     struct vmcb_control_area *control);
+void __svm_write_tsc_multiplier(u64 multiplier);
 void nested_sync_control_from_vmcb02(struct vcpu_svm *svm);
 void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm);
 void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb);
-- 
2.39.0



