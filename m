Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 428502CD9FB
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 16:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbgLCPQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 10:16:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28461 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727536AbgLCPQr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 10:16:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607008520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=DyM6M0CaXHuUyJ1W1c9GKjJJgZPBG5nzEO24r4+1bEU=;
        b=i7KFhesaXxLnBsgiysKBEpCLWC4f4HWO0YCyKF3LoYO4SZOiCNVBRdnHtyZhainRd32tMz
        eW9BtqFvC79j53mGCVfuT1siolP9YpMzozAUa3UFhNtcCxbr0TOKjCsuJ0IWxMmCX0eHRf
        xYd4A8wn696etgF9zmPKtIb5QRpfctM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56-iio3t5tINAOA8sJd5cCiLQ-1; Thu, 03 Dec 2020 10:15:18 -0500
X-MC-Unique: iio3t5tINAOA8sJd5cCiLQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 77E96800D62;
        Thu,  3 Dec 2020 15:15:17 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DDB0E1F075;
        Thu,  3 Dec 2020 15:15:16 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     stable@vger.kernel.org, "Denis V . Lunev" <den@openvz.org>
Subject: [PATCH] KVM: x86: reinstate vendor-agnostic check on SPEC_CTRL cpuid bits
Date:   Thu,  3 Dec 2020 10:15:16 -0500
Message-Id: <20201203151516.14441-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Until commit e7c587da1252 ("x86/speculation: Use synthetic bits for IBRS/IBPB/STIBP",
2018-05-17), KVM was testing both Intel and AMD CPUID bits before allowing the
guest to write MSR_IA32_SPEC_CTRL and MSR_IA32_PRED_CMD.  Testing only Intel bits
on VMX processors, or only AMD bits on SVM processors, fails if the guests are
created with the "opposite" vendor as the host.

While at it, also tweak the host CPU check to use the vendor-agnostic feature bit
X86_FEATURE_IBPB, since we only care about the availability of the MSR on the host
here and not about specific CPUID bits.

Fixes: e7c587da1252 ("x86/speculation: Use synthetic bits for IBRS/IBPB/STIBP")
Cc: stable@vger.kernel.org
Reported-by: Denis V. Lunev <den@openvz.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/svm.c |  3 ++-
 arch/x86/kvm/vmx/vmx.c | 10 +++++++---
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 62390fbc9233..0b4aa60b2754 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2686,12 +2686,13 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		break;
 	case MSR_IA32_PRED_CMD:
 		if (!msr->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBPB))
 			return 1;
 
 		if (data & ~PRED_CMD_IBPB)
 			return 1;
-		if (!boot_cpu_has(X86_FEATURE_AMD_IBPB))
+		if (!boot_cpu_has(X86_FEATURE_IBPB))
 			return 1;
 		if (!data)
 			break;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c3441e7e5a87..b74d2105ced7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2028,7 +2028,10 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_SPEC_CTRL:
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
+                    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) &&
+                    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_STIBP) &&
+                    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS) &&
+                    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))
 			return 1;
 
 		if (kvm_spec_ctrl_test_value(data))
@@ -2063,12 +2066,13 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		goto find_uret_msr;
 	case MSR_IA32_PRED_CMD:
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
+		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBPB))
 			return 1;
 
 		if (data & ~PRED_CMD_IBPB)
 			return 1;
-		if (!boot_cpu_has(X86_FEATURE_SPEC_CTRL))
+		if (!boot_cpu_has(X86_FEATURE_IBPB))
 			return 1;
 		if (!data)
 			break;
-- 
2.26.2

