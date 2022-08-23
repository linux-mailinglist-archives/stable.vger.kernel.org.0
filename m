Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE73359DC81
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350363AbiHWLHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357186AbiHWLGQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:06:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 723CEB4428;
        Tue, 23 Aug 2022 02:15:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DBAB6113E;
        Tue, 23 Aug 2022 09:15:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB62C433D6;
        Tue, 23 Aug 2022 09:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246142;
        bh=mDlYbZ72tFL3h6CgQb2aswkXH6xQo02++k4Kfhq0lG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zGz60ejMkcgItNYt0anbNWv4zJD0RcEBfrSyW5XlexuhZ+DKF/pCzSJXwBBr3+5dL
         qvk6h2ULGF6SylQteFINCywRNg6cwX3QWftQLu8PJquddECyn1pSl34vTM+/oAMum0
         xOa7gbaKWzbmZ41udAeLCmF9h3AQnY5c6mMX/kzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.4 015/389] KVM: nVMX: Let userspace set nVMX MSR to any _host_ supported value
Date:   Tue, 23 Aug 2022 10:21:33 +0200
Message-Id: <20220823080116.324525248@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Sean Christopherson <seanjc@google.com>

commit f8ae08f9789ad59d318ea75b570caa454aceda81 upstream.

Restrict the nVMX MSRs based on KVM's config, not based on the guest's
current config.  Using the guest's config to audit the new config
prevents userspace from restoring the original config (KVM's config) if
at any point in the past the guest's config was restricted in any way.

Fixes: 62cc6b9dc61e ("KVM: nVMX: support restore of VMX capability MSRs")
Cc: stable@vger.kernel.org
Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220607213604.3346000-6-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c |   70 ++++++++++++++++++++++++----------------------
 1 file changed, 37 insertions(+), 33 deletions(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1060,7 +1060,7 @@ static int vmx_restore_vmx_basic(struct
 		BIT_ULL(49) | BIT_ULL(54) | BIT_ULL(55) |
 		/* reserved */
 		BIT_ULL(31) | GENMASK_ULL(47, 45) | GENMASK_ULL(63, 56);
-	u64 vmx_basic = vmx->nested.msrs.basic;
+	u64 vmx_basic = vmcs_config.nested.basic;
 
 	if (!is_bitwise_subset(vmx_basic, data, feature_and_reserved))
 		return -EINVAL;
@@ -1083,36 +1083,42 @@ static int vmx_restore_vmx_basic(struct
 	return 0;
 }
 
-static int
-vmx_restore_control_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
+static void vmx_get_control_msr(struct nested_vmx_msrs *msrs, u32 msr_index,
+				u32 **low, u32 **high)
 {
-	u64 supported;
-	u32 *lowp, *highp;
-
 	switch (msr_index) {
 	case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
-		lowp = &vmx->nested.msrs.pinbased_ctls_low;
-		highp = &vmx->nested.msrs.pinbased_ctls_high;
+		*low = &msrs->pinbased_ctls_low;
+		*high = &msrs->pinbased_ctls_high;
 		break;
 	case MSR_IA32_VMX_TRUE_PROCBASED_CTLS:
-		lowp = &vmx->nested.msrs.procbased_ctls_low;
-		highp = &vmx->nested.msrs.procbased_ctls_high;
+		*low = &msrs->procbased_ctls_low;
+		*high = &msrs->procbased_ctls_high;
 		break;
 	case MSR_IA32_VMX_TRUE_EXIT_CTLS:
-		lowp = &vmx->nested.msrs.exit_ctls_low;
-		highp = &vmx->nested.msrs.exit_ctls_high;
+		*low = &msrs->exit_ctls_low;
+		*high = &msrs->exit_ctls_high;
 		break;
 	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
-		lowp = &vmx->nested.msrs.entry_ctls_low;
-		highp = &vmx->nested.msrs.entry_ctls_high;
+		*low = &msrs->entry_ctls_low;
+		*high = &msrs->entry_ctls_high;
 		break;
 	case MSR_IA32_VMX_PROCBASED_CTLS2:
-		lowp = &vmx->nested.msrs.secondary_ctls_low;
-		highp = &vmx->nested.msrs.secondary_ctls_high;
+		*low = &msrs->secondary_ctls_low;
+		*high = &msrs->secondary_ctls_high;
 		break;
 	default:
 		BUG();
 	}
+}
+
+static int
+vmx_restore_control_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
+{
+	u32 *lowp, *highp;
+	u64 supported;
+
+	vmx_get_control_msr(&vmcs_config.nested, msr_index, &lowp, &highp);
 
 	supported = vmx_control_msr(*lowp, *highp);
 
@@ -1124,6 +1130,7 @@ vmx_restore_control_msr(struct vcpu_vmx
 	if (!is_bitwise_subset(supported, data, GENMASK_ULL(63, 32)))
 		return -EINVAL;
 
+	vmx_get_control_msr(&vmx->nested.msrs, msr_index, &lowp, &highp);
 	*lowp = data;
 	*highp = data >> 32;
 	return 0;
@@ -1137,10 +1144,8 @@ static int vmx_restore_vmx_misc(struct v
 		BIT_ULL(28) | BIT_ULL(29) | BIT_ULL(30) |
 		/* reserved */
 		GENMASK_ULL(13, 9) | BIT_ULL(31);
-	u64 vmx_misc;
-
-	vmx_misc = vmx_control_msr(vmx->nested.msrs.misc_low,
-				   vmx->nested.msrs.misc_high);
+	u64 vmx_misc = vmx_control_msr(vmcs_config.nested.misc_low,
+				       vmcs_config.nested.misc_high);
 
 	if (!is_bitwise_subset(vmx_misc, data, feature_and_reserved_bits))
 		return -EINVAL;
@@ -1168,10 +1173,8 @@ static int vmx_restore_vmx_misc(struct v
 
 static int vmx_restore_vmx_ept_vpid_cap(struct vcpu_vmx *vmx, u64 data)
 {
-	u64 vmx_ept_vpid_cap;
-
-	vmx_ept_vpid_cap = vmx_control_msr(vmx->nested.msrs.ept_caps,
-					   vmx->nested.msrs.vpid_caps);
+	u64 vmx_ept_vpid_cap = vmx_control_msr(vmcs_config.nested.ept_caps,
+					       vmcs_config.nested.vpid_caps);
 
 	/* Every bit is either reserved or a feature bit. */
 	if (!is_bitwise_subset(vmx_ept_vpid_cap, data, -1ULL))
@@ -1182,20 +1185,21 @@ static int vmx_restore_vmx_ept_vpid_cap(
 	return 0;
 }
 
-static int vmx_restore_fixed0_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
+static u64 *vmx_get_fixed0_msr(struct nested_vmx_msrs *msrs, u32 msr_index)
 {
-	u64 *msr;
-
 	switch (msr_index) {
 	case MSR_IA32_VMX_CR0_FIXED0:
-		msr = &vmx->nested.msrs.cr0_fixed0;
-		break;
+		return &msrs->cr0_fixed0;
 	case MSR_IA32_VMX_CR4_FIXED0:
-		msr = &vmx->nested.msrs.cr4_fixed0;
-		break;
+		return &msrs->cr4_fixed0;
 	default:
 		BUG();
 	}
+}
+
+static int vmx_restore_fixed0_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
+{
+	const u64 *msr = vmx_get_fixed0_msr(&vmcs_config.nested, msr_index);
 
 	/*
 	 * 1 bits (which indicates bits which "must-be-1" during VMX operation)
@@ -1204,7 +1208,7 @@ static int vmx_restore_fixed0_msr(struct
 	if (!is_bitwise_subset(data, *msr, -1ULL))
 		return -EINVAL;
 
-	*msr = data;
+	*vmx_get_fixed0_msr(&vmx->nested.msrs, msr_index) = data;
 	return 0;
 }
 
@@ -1265,7 +1269,7 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcp
 		vmx->nested.msrs.vmcs_enum = data;
 		return 0;
 	case MSR_IA32_VMX_VMFUNC:
-		if (data & ~vmx->nested.msrs.vmfunc_controls)
+		if (data & ~vmcs_config.nested.vmfunc_controls)
 			return -EINVAL;
 		vmx->nested.msrs.vmfunc_controls = data;
 		return 0;


