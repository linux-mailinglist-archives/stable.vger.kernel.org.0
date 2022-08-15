Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDE759350A
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 20:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239616AbiHOSS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239842AbiHOSSU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:18:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1CD62B60F;
        Mon, 15 Aug 2022 11:15:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 814C261255;
        Mon, 15 Aug 2022 18:15:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B5DEC433D6;
        Mon, 15 Aug 2022 18:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587350;
        bh=fCPMds9AEPMOFnboHopcJ1hJ4Lz/wfZyAyN3YzGFGGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qCB+JCJTDdmPlp20BKMtJYpYL/7LpxlNlqQaF6+Hty1wAdLOXi3B6Ni8BCugYC4ta
         nwbkjRsApapfVk7tHlERDFTiVp/WTL15T5GrFSASAJQl1/Cu3YbGzfX0E/seJ4MxPA
         j2WtrvHkvY5/S6eSvkUQWc3FneHT6sTVaDtlGHns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 025/779] KVM: nVMX: Let userspace set nVMX MSR to any _host_ supported value
Date:   Mon, 15 Aug 2022 19:54:29 +0200
Message-Id: <20220815180338.291845072@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
@@ -1217,7 +1217,7 @@ static int vmx_restore_vmx_basic(struct
 		BIT_ULL(49) | BIT_ULL(54) | BIT_ULL(55) |
 		/* reserved */
 		BIT_ULL(31) | GENMASK_ULL(47, 45) | GENMASK_ULL(63, 56);
-	u64 vmx_basic = vmx->nested.msrs.basic;
+	u64 vmx_basic = vmcs_config.nested.basic;
 
 	if (!is_bitwise_subset(vmx_basic, data, feature_and_reserved))
 		return -EINVAL;
@@ -1240,36 +1240,42 @@ static int vmx_restore_vmx_basic(struct
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
 
@@ -1281,6 +1287,7 @@ vmx_restore_control_msr(struct vcpu_vmx
 	if (!is_bitwise_subset(supported, data, GENMASK_ULL(63, 32)))
 		return -EINVAL;
 
+	vmx_get_control_msr(&vmx->nested.msrs, msr_index, &lowp, &highp);
 	*lowp = data;
 	*highp = data >> 32;
 	return 0;
@@ -1294,10 +1301,8 @@ static int vmx_restore_vmx_misc(struct v
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
@@ -1325,10 +1330,8 @@ static int vmx_restore_vmx_misc(struct v
 
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
@@ -1339,20 +1342,21 @@ static int vmx_restore_vmx_ept_vpid_cap(
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
@@ -1361,7 +1365,7 @@ static int vmx_restore_fixed0_msr(struct
 	if (!is_bitwise_subset(data, *msr, -1ULL))
 		return -EINVAL;
 
-	*msr = data;
+	*vmx_get_fixed0_msr(&vmx->nested.msrs, msr_index) = data;
 	return 0;
 }
 
@@ -1422,7 +1426,7 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcp
 		vmx->nested.msrs.vmcs_enum = data;
 		return 0;
 	case MSR_IA32_VMX_VMFUNC:
-		if (data & ~vmx->nested.msrs.vmfunc_controls)
+		if (data & ~vmcs_config.nested.vmfunc_controls)
 			return -EINVAL;
 		vmx->nested.msrs.vmfunc_controls = data;
 		return 0;


