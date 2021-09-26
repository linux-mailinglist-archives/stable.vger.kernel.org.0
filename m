Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 706EE418571
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 03:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhIZB4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Sep 2021 21:56:33 -0400
Received: from mga17.intel.com ([192.55.52.151]:54551 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230211AbhIZB4d (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 25 Sep 2021 21:56:33 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10118"; a="204461314"
X-IronPort-AV: E=Sophos;i="5.85,322,1624345200"; 
   d="scan'208";a="204461314"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2021 18:54:57 -0700
X-IronPort-AV: E=Sophos;i="5.85,322,1624345200"; 
   d="scan'208";a="552321174"
Received: from duan-client-optiplex-7080.bj.intel.com ([10.238.156.101])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2021 18:54:55 -0700
From:   Zhenzhong Duan <zhenzhong.duan@intel.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, Zhenzhong Duan <zhenzhong.duan@intel.com>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Subject: [PATCH v2] KVM: VMX: Fix a TSX_CTRL_CPUID_CLEAR field mask issue
Date:   Sun, 26 Sep 2021 09:55:45 +0800
Message-Id: <20210926015545.281083-1-zhenzhong.duan@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When updating the host's mask for its MSR_IA32_TSX_CTRL user return entry,
clear the mask in the found uret MSR instead of vmx->guest_uret_msrs[i].
Modifying guest_uret_msrs directly is completely broken as 'i' does not
point at the MSR_IA32_TSX_CTRL entry.  In fact, it's guaranteed to be an
out-of-bounds accesses as is always set to kvm_nr_uret_msrs in a prior
loop. By sheer dumb luck, the fallout is limited to "only" failing to
preserve the host's TSX_CTRL_CPUID_CLEAR.  The out-of-bounds access is
benign as it's guaranteed to clear a bit in a guest MSR value, which are
always zero at vCPU creation on both x86-64 and i386.

Cc: stable@vger.kernel.org
Fixes: 8ea8b8d6f869 ("KVM: VMX: Use common x86's uret MSR list as the one true list")
Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0c2c0d5ae873..cbf3d33432b9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6833,7 +6833,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 		 */
 		tsx_ctrl = vmx_find_uret_msr(vmx, MSR_IA32_TSX_CTRL);
 		if (tsx_ctrl)
-			vmx->guest_uret_msrs[i].mask = ~(u64)TSX_CTRL_CPUID_CLEAR;
+			tsx_ctrl->mask = ~(u64)TSX_CTRL_CPUID_CLEAR;
 	}
 
 	err = alloc_loaded_vmcs(&vmx->vmcs01);
-- 
2.25.1

