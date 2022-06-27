Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B75C55C56C
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238259AbiF0Luk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238584AbiF0Lsr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:48:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69042CEA;
        Mon, 27 Jun 2022 04:42:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04DCB611AE;
        Mon, 27 Jun 2022 11:42:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC3AC3411D;
        Mon, 27 Jun 2022 11:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330153;
        bh=yTy+jkozP0hMY+B0KWkUgzOl8qgLaJsMF/9JTHu7dB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jr76LOE0se2fpNwdK/nBBIw0xSKGrZEnhUb+66edY7UNwg1mGt0JettLcSsHzBu/H
         R/4U8yp/i7vLQU2DdbLdffzqnvwwuJtyn/Ea6lUsZ9xCpQ9lrbhodhEYNhQm9KZA0t
         G/dnllkHF1he/CNwJnbT8Vu9X0Gan4BBjYExclIM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 103/181] KVM: SEV: Init target VMCBs in sev_migrate_from
Date:   Mon, 27 Jun 2022 13:21:16 +0200
Message-Id: <20220627111947.686004921@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Gonda <pgonda@google.com>

[ Upstream commit 6defa24d3b12bbd418bc8526dea1cbc605265c06 ]

The target VMCBs during an intra-host migration need to correctly setup
for running SEV and SEV-ES guests. Add sev_init_vmcb() function and make
sev_es_init_vmcb() static. sev_init_vmcb() uses the now private function
to init SEV-ES guests VMCBs when needed.

Fixes: 0b020f5af092 ("KVM: SEV: Add support for SEV-ES intra host migration")
Fixes: b56639318bb2 ("KVM: SEV: Add support for SEV intra host migration")
Signed-off-by: Peter Gonda <pgonda@google.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Message-Id: <20220623173406.744645-1-pgonda@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/sev.c | 68 ++++++++++++++++++++++++++++--------------
 arch/x86/kvm/svm/svm.c | 11 ++-----
 arch/x86/kvm/svm/svm.h |  2 +-
 3 files changed, 48 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 4b7d490c0b63..76e9e6eb71d6 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1665,19 +1665,24 @@ static void sev_migrate_from(struct kvm *dst_kvm, struct kvm *src_kvm)
 {
 	struct kvm_sev_info *dst = &to_kvm_svm(dst_kvm)->sev_info;
 	struct kvm_sev_info *src = &to_kvm_svm(src_kvm)->sev_info;
+	struct kvm_vcpu *dst_vcpu, *src_vcpu;
+	struct vcpu_svm *dst_svm, *src_svm;
 	struct kvm_sev_info *mirror;
+	unsigned long i;
 
 	dst->active = true;
 	dst->asid = src->asid;
 	dst->handle = src->handle;
 	dst->pages_locked = src->pages_locked;
 	dst->enc_context_owner = src->enc_context_owner;
+	dst->es_active = src->es_active;
 
 	src->asid = 0;
 	src->active = false;
 	src->handle = 0;
 	src->pages_locked = 0;
 	src->enc_context_owner = NULL;
+	src->es_active = false;
 
 	list_cut_before(&dst->regions_list, &src->regions_list, &src->regions_list);
 
@@ -1704,26 +1709,21 @@ static void sev_migrate_from(struct kvm *dst_kvm, struct kvm *src_kvm)
 		list_del(&src->mirror_entry);
 		list_add_tail(&dst->mirror_entry, &owner_sev_info->mirror_vms);
 	}
-}
 
-static int sev_es_migrate_from(struct kvm *dst, struct kvm *src)
-{
-	unsigned long i;
-	struct kvm_vcpu *dst_vcpu, *src_vcpu;
-	struct vcpu_svm *dst_svm, *src_svm;
+	kvm_for_each_vcpu(i, dst_vcpu, dst_kvm) {
+		dst_svm = to_svm(dst_vcpu);
 
-	if (atomic_read(&src->online_vcpus) != atomic_read(&dst->online_vcpus))
-		return -EINVAL;
+		sev_init_vmcb(dst_svm);
 
-	kvm_for_each_vcpu(i, src_vcpu, src) {
-		if (!src_vcpu->arch.guest_state_protected)
-			return -EINVAL;
-	}
+		if (!dst->es_active)
+			continue;
 
-	kvm_for_each_vcpu(i, src_vcpu, src) {
+		/*
+		 * Note, the source is not required to have the same number of
+		 * vCPUs as the destination when migrating a vanilla SEV VM.
+		 */
+		src_vcpu = kvm_get_vcpu(dst_kvm, i);
 		src_svm = to_svm(src_vcpu);
-		dst_vcpu = kvm_get_vcpu(dst, i);
-		dst_svm = to_svm(dst_vcpu);
 
 		/*
 		 * Transfer VMSA and GHCB state to the destination.  Nullify and
@@ -1740,8 +1740,23 @@ static int sev_es_migrate_from(struct kvm *dst, struct kvm *src)
 		src_svm->vmcb->control.vmsa_pa = INVALID_PAGE;
 		src_vcpu->arch.guest_state_protected = false;
 	}
-	to_kvm_svm(src)->sev_info.es_active = false;
-	to_kvm_svm(dst)->sev_info.es_active = true;
+}
+
+static int sev_check_source_vcpus(struct kvm *dst, struct kvm *src)
+{
+	struct kvm_vcpu *src_vcpu;
+	unsigned long i;
+
+	if (!sev_es_guest(src))
+		return 0;
+
+	if (atomic_read(&src->online_vcpus) != atomic_read(&dst->online_vcpus))
+		return -EINVAL;
+
+	kvm_for_each_vcpu(i, src_vcpu, src) {
+		if (!src_vcpu->arch.guest_state_protected)
+			return -EINVAL;
+	}
 
 	return 0;
 }
@@ -1789,11 +1804,9 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 	if (ret)
 		goto out_dst_vcpu;
 
-	if (sev_es_guest(source_kvm)) {
-		ret = sev_es_migrate_from(kvm, source_kvm);
-		if (ret)
-			goto out_source_vcpu;
-	}
+	ret = sev_check_source_vcpus(kvm, source_kvm);
+	if (ret)
+		goto out_source_vcpu;
 
 	sev_migrate_from(kvm, source_kvm);
 	kvm_vm_dead(source_kvm);
@@ -2910,7 +2923,7 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
 				    count, in);
 }
 
-void sev_es_init_vmcb(struct vcpu_svm *svm)
+static void sev_es_init_vmcb(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 
@@ -2955,6 +2968,15 @@ void sev_es_init_vmcb(struct vcpu_svm *svm)
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP, 1, 1);
 }
 
+void sev_init_vmcb(struct vcpu_svm *svm)
+{
+	svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ENABLE;
+	clr_exception_intercept(svm, UD_VECTOR);
+
+	if (sev_es_guest(svm->vcpu.kvm))
+		sev_es_init_vmcb(svm);
+}
+
 void sev_es_vcpu_reset(struct vcpu_svm *svm)
 {
 	/*
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0c0a09b43b10..6bfb0b0e66bd 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1125,15 +1125,8 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 		svm->vmcb->control.int_ctl |= V_GIF_ENABLE_MASK;
 	}
 
-	if (sev_guest(vcpu->kvm)) {
-		svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ENABLE;
-		clr_exception_intercept(svm, UD_VECTOR);
-
-		if (sev_es_guest(vcpu->kvm)) {
-			/* Perform SEV-ES specific VMCB updates */
-			sev_es_init_vmcb(svm);
-		}
-	}
+	if (sev_guest(vcpu->kvm))
+		sev_init_vmcb(svm);
 
 	svm_hv_init_vmcb(svm->vmcb);
 	init_vmcb_after_set_cpuid(vcpu);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 34babf9185fe..8ec8fb58b924 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -616,10 +616,10 @@ void __init sev_set_cpu_caps(void);
 void __init sev_hardware_setup(void);
 void sev_hardware_unsetup(void);
 int sev_cpu_init(struct svm_cpu_data *sd);
+void sev_init_vmcb(struct vcpu_svm *svm);
 void sev_free_vcpu(struct kvm_vcpu *vcpu);
 int sev_handle_vmgexit(struct kvm_vcpu *vcpu);
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
-void sev_es_init_vmcb(struct vcpu_svm *svm);
 void sev_es_vcpu_reset(struct vcpu_svm *svm);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_switch_to_guest(struct vmcb_save_area *hostsa);
-- 
2.35.1



