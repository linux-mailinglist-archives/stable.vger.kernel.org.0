Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16DF54BE33C
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232754AbiBULHS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 06:07:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345988AbiBULFj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 06:05:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A09353FBE3
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 02:33:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645439618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2s850PTFKMgt+79nojpojufcF5kfxJ20TLZLutPamXM=;
        b=DUogjPZ+45IGi5Mlx1LyGCtdOUlgnTXLDSO4awkw+SCbGxhRalrOwSuYqJPQNO2tsVGvSP
        nYcMixkW3+VV8LCj5NlzcGrh/rhU6zYHrRWpMnd0E3S6vaY94jan2H1W+fNMkzQi/8lega
        yv3lbUcox/SshM0Ev1WB4cKFvpjydAg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-322-k1gX53XgNweS7itiC_n6RQ-1; Mon, 21 Feb 2022 05:33:35 -0500
X-MC-Unique: k1gX53XgNweS7itiC_n6RQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A28F814243;
        Mon, 21 Feb 2022 10:33:34 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5AB236F9D0;
        Mon, 21 Feb 2022 10:33:32 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>, stable@vger.kernel.org,
        =?UTF-8?q?D=C4=81vis=20Mos=C4=81ns?= <davispuh@gmail.com>
Subject: [PATCH] KVM: nSVM: fix nested tsc scaling when not enabled but MSR_AMD64_TSC_RATIO set
Date:   Mon, 21 Feb 2022 12:33:31 +0200
Message-Id: <20220221103331.58956-1-mlevitsk@redhat.com>
In-Reply-To: <0a0b61c5c071415f213a4704ebd73e65761ec1a3.camel@redhat.com>
References: <0a0b61c5c071415f213a4704ebd73e65761ec1a3.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For compatibility with userspace the MSR_AMD64_TSC_RATIO can be set
even when the feature is not exposed to the guest, which breaks assumptions
that it has the default value in this case.

Fixes: 5228eb96a487 ("KVM: x86: nSVM: implement nested TSC scaling")
Cc: stable@vger.kernel.org

Reported-by: Dāvis Mosāns <davispuh@gmail.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 10 ++++------
 arch/x86/kvm/svm/svm.c    |  5 +++--
 arch/x86/kvm/svm/svm.h    |  1 +
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 1218b5a342fc..a2e2436057dc 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -574,14 +574,12 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 	vcpu->arch.tsc_offset = kvm_calc_nested_tsc_offset(
 			vcpu->arch.l1_tsc_offset,
 			svm->nested.ctl.tsc_offset,
-			svm->tsc_ratio_msr);
+			svm_get_l2_tsc_multiplier(vcpu));
 
 	svm->vmcb->control.tsc_offset = vcpu->arch.tsc_offset;
 
-	if (svm->tsc_ratio_msr != kvm_default_tsc_scaling_ratio) {
-		WARN_ON(!svm->tsc_scaling_enabled);
+	if (svm_get_l2_tsc_multiplier(vcpu) != kvm_default_tsc_scaling_ratio)
 		nested_svm_update_tsc_ratio_msr(vcpu);
-	}
 
 	svm->vmcb->control.int_ctl             =
 		(svm->nested.ctl.int_ctl & int_ctl_vmcb12_bits) |
@@ -867,8 +865,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 		vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
 	}
 
-	if (svm->tsc_ratio_msr != kvm_default_tsc_scaling_ratio) {
-		WARN_ON(!svm->tsc_scaling_enabled);
+	if (svm_get_l2_tsc_multiplier(vcpu) != kvm_default_tsc_scaling_ratio) {
 		vcpu->arch.tsc_scaling_ratio = vcpu->arch.l1_tsc_scaling_ratio;
 		svm_write_tsc_multiplier(vcpu, vcpu->arch.tsc_scaling_ratio);
 	}
@@ -1264,6 +1261,7 @@ void nested_svm_update_tsc_ratio_msr(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	WARN_ON_ONCE(!svm->tsc_scaling_enabled);
 	vcpu->arch.tsc_scaling_ratio =
 		kvm_calc_nested_tsc_multiplier(vcpu->arch.l1_tsc_scaling_ratio,
 					       svm->tsc_ratio_msr);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 975be872cd1a..5cf6bb5bfd3e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -911,11 +911,12 @@ static u64 svm_get_l2_tsc_offset(struct kvm_vcpu *vcpu)
 	return svm->nested.ctl.tsc_offset;
 }
 
-static u64 svm_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu)
+u64 svm_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	return svm->tsc_ratio_msr;
+	return svm->tsc_scaling_enabled ? svm->tsc_ratio_msr :
+	       kvm_default_tsc_scaling_ratio;
 }
 
 static void svm_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 852b12aee03d..006571dd30df 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -542,6 +542,7 @@ int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 			       bool has_error_code, u32 error_code);
 int nested_svm_exit_special(struct vcpu_svm *svm);
 void nested_svm_update_tsc_ratio_msr(struct kvm_vcpu *vcpu);
+u64 svm_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
 void svm_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 multiplier);
 void nested_copy_vmcb_control_to_cache(struct vcpu_svm *svm,
 				       struct vmcb_control_area *control);
-- 
2.26.3

