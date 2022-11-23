Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E432A6357F0
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237278AbiKWJsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:48:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238002AbiKWJs0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:48:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B2AE1181E3
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:45:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1136EB81E5E
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:45:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62434C433C1;
        Wed, 23 Nov 2022 09:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196732;
        bh=Diy9z6yndmnXKTl3026OW7o1j9M3UzQBLRfFNaXohng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PWXuf1AqPh6Io479NARGjPqOSqS3bmQvoaImPTfYaqhsn0gpDzHAVOiH6yfhTWYt3
         VnfihSV6NieBo8knkzgJBK8LGoq5uTJ7Ez1C91JqyhIrvH1f2ouCO1oeIxbkmdvwia
         r95lgwnKZor4Vm2AOJ3vGh8uLqfRx7+yujRZ7llI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 068/314] KVM: SVM: do not allocate struct svm_cpu_data dynamically
Date:   Wed, 23 Nov 2022 09:48:33 +0100
Message-Id: <20221123084628.567517037@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit 73412dfeea724e6bd775ba64d21157ff322eac9a ]

The svm_data percpu variable is a pointer, but it is allocated via
svm_hardware_setup() when KVM is loaded.  Unlike hardware_enable()
this means that it is never NULL for the whole lifetime of KVM, and
static allocation does not waste any memory compared to the status quo.
It is also more efficient and more easily handled from assembly code,
so do it and don't look back.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: e287bd005ad9 ("KVM: SVM: restore host save area from assembly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/sev.c |  4 ++--
 arch/x86/kvm/svm/svm.c | 41 +++++++++++++++--------------------------
 arch/x86/kvm/svm/svm.h |  2 +-
 3 files changed, 18 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c9c9bd453a97..efaaef2b7ae1 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -196,7 +196,7 @@ static void sev_asid_free(struct kvm_sev_info *sev)
 	__set_bit(sev->asid, sev_reclaim_asid_bitmap);
 
 	for_each_possible_cpu(cpu) {
-		sd = per_cpu(svm_data, cpu);
+		sd = per_cpu_ptr(&svm_data, cpu);
 		sd->sev_vmcbs[sev->asid] = NULL;
 	}
 
@@ -2600,7 +2600,7 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 
 void pre_sev_run(struct vcpu_svm *svm, int cpu)
 {
-	struct svm_cpu_data *sd = per_cpu(svm_data, cpu);
+	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
 	int asid = sev_get_asid(svm->vcpu.kvm);
 
 	/* Assign the asid allocated with this SEV guest */
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ecf4d8233e49..6b2f332f5d54 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -245,7 +245,7 @@ struct kvm_ldttss_desc {
 	u32 zero1;
 } __attribute__((packed));
 
-DEFINE_PER_CPU(struct svm_cpu_data *, svm_data);
+DEFINE_PER_CPU(struct svm_cpu_data, svm_data);
 
 /*
  * Only MSR_TSC_AUX is switched via the user return hook.  EFER is switched via
@@ -583,12 +583,7 @@ static int svm_hardware_enable(void)
 		pr_err("%s: err EOPNOTSUPP on %d\n", __func__, me);
 		return -EINVAL;
 	}
-	sd = per_cpu(svm_data, me);
-	if (!sd) {
-		pr_err("%s: svm_data is NULL on %d\n", __func__, me);
-		return -EINVAL;
-	}
-
+	sd = per_cpu_ptr(&svm_data, me);
 	sd->asid_generation = 1;
 	sd->max_asid = cpuid_ebx(SVM_CPUID_FUNC) - 1;
 	sd->next_asid = sd->max_asid + 1;
@@ -648,41 +643,35 @@ static int svm_hardware_enable(void)
 
 static void svm_cpu_uninit(int cpu)
 {
-	struct svm_cpu_data *sd = per_cpu(svm_data, cpu);
+	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
 
-	if (!sd)
+	if (!sd->save_area)
 		return;
 
-	per_cpu(svm_data, cpu) = NULL;
 	kfree(sd->sev_vmcbs);
 	__free_page(sd->save_area);
-	kfree(sd);
+	sd->save_area = NULL;
 }
 
 static int svm_cpu_init(int cpu)
 {
-	struct svm_cpu_data *sd;
+	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
 	int ret = -ENOMEM;
 
-	sd = kzalloc(sizeof(struct svm_cpu_data), GFP_KERNEL);
-	if (!sd)
-		return ret;
+	memset(sd, 0, sizeof(struct svm_cpu_data));
 	sd->save_area = alloc_page(GFP_KERNEL | __GFP_ZERO);
 	if (!sd->save_area)
-		goto free_cpu_data;
+		return ret;
 
 	ret = sev_cpu_init(sd);
 	if (ret)
 		goto free_save_area;
 
-	per_cpu(svm_data, cpu) = sd;
-
 	return 0;
 
 free_save_area:
 	__free_page(sd->save_area);
-free_cpu_data:
-	kfree(sd);
+	sd->save_area = NULL;
 	return ret;
 
 }
@@ -1426,7 +1415,7 @@ static void svm_clear_current_vmcb(struct vmcb *vmcb)
 	int i;
 
 	for_each_online_cpu(i)
-		cmpxchg(&per_cpu(svm_data, i)->current_vmcb, vmcb, NULL);
+		cmpxchg(per_cpu_ptr(&svm_data.current_vmcb, i), vmcb, NULL);
 }
 
 static void svm_vcpu_free(struct kvm_vcpu *vcpu)
@@ -1451,7 +1440,7 @@ static void svm_vcpu_free(struct kvm_vcpu *vcpu)
 static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	struct svm_cpu_data *sd = per_cpu(svm_data, vcpu->cpu);
+	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, vcpu->cpu);
 
 	if (sev_es_guest(vcpu->kvm))
 		sev_es_unmap_ghcb(svm);
@@ -1488,7 +1477,7 @@ static void svm_prepare_host_switch(struct kvm_vcpu *vcpu)
 static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	struct svm_cpu_data *sd = per_cpu(svm_data, cpu);
+	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
 
 	if (sd->current_vmcb != svm->vmcb) {
 		sd->current_vmcb = svm->vmcb;
@@ -3443,7 +3432,7 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 
 static void reload_tss(struct kvm_vcpu *vcpu)
 {
-	struct svm_cpu_data *sd = per_cpu(svm_data, vcpu->cpu);
+	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, vcpu->cpu);
 
 	sd->tss_desc->type = 9; /* available 32/64-bit TSS */
 	load_TR_desc();
@@ -3451,7 +3440,7 @@ static void reload_tss(struct kvm_vcpu *vcpu)
 
 static void pre_svm_run(struct kvm_vcpu *vcpu)
 {
-	struct svm_cpu_data *sd = per_cpu(svm_data, vcpu->cpu);
+	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, vcpu->cpu);
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	/*
@@ -3920,7 +3909,7 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 	if (sev_es_guest(vcpu->kvm)) {
 		__svm_sev_es_vcpu_run(svm);
 	} else {
-		struct svm_cpu_data *sd = per_cpu(svm_data, vcpu->cpu);
+		struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, vcpu->cpu);
 
 		__svm_vcpu_run(svm);
 		vmload(__sme_page_pa(sd->save_area));
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 8a8894d948a0..f1483209e186 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -294,7 +294,7 @@ struct svm_cpu_data {
 	struct vmcb **sev_vmcbs;
 };
 
-DECLARE_PER_CPU(struct svm_cpu_data *, svm_data);
+DECLARE_PER_CPU(struct svm_cpu_data, svm_data);
 
 void recalc_intercepts(struct vcpu_svm *svm);
 
-- 
2.35.1



