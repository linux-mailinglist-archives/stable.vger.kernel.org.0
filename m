Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B884461F4
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 11:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233033AbhKEKK5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 06:10:57 -0400
Received: from mail.xenproject.org ([104.130.215.37]:56646 "EHLO
        mail.xenproject.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233028AbhKEKK5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Nov 2021 06:10:57 -0400
X-Greylist: delayed 1007 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Nov 2021 06:10:57 EDT
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <pdurrant@amazon.com>)
        id 1mivsQ-00048a-Cu; Fri, 05 Nov 2021 09:51:14 +0000
Received: from host86-165-42-146.range86-165.btcentralplus.com ([86.165.42.146] helo=debian.home)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <pdurrant@amazon.com>)
        id 1mivsQ-00088M-4M; Fri, 05 Nov 2021 09:51:14 +0000
From:   Paul Durrant <pdurrant@amazon.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>, stable@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 1/2] KVM: x86: Add helper to consolidate core logic of SET_CPUID{2} flows
Date:   Fri,  5 Nov 2021 09:51:00 +0000
Message-Id: <20211105095101.5384-2-pdurrant@amazon.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211105095101.5384-1-pdurrant@amazon.com>
References: <20211105095101.5384-1-pdurrant@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Move the core logic of SET_CPUID and SET_CPUID2 to a common helper, the
only difference between the two ioctls() is the format of the userspace
struct.  A future fix will add yet more code to the core logic.

No functional change intended.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Joerg Roedel <joro@8bytes.org>

v2:
 - New in v2
---
 arch/x86/kvm/cpuid.c | 47 ++++++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 2d70edb0f323..41529c168e91 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -239,6 +239,25 @@ u64 kvm_vcpu_reserved_gpa_bits_raw(struct kvm_vcpu *vcpu)
 	return rsvd_bits(cpuid_maxphyaddr(vcpu), 63);
 }
 
+static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
+                        int nent)
+{
+    int r;
+
+    r = kvm_check_cpuid(e2, nent);
+    if (r)
+        return r;
+
+    kvfree(vcpu->arch.cpuid_entries);
+    vcpu->arch.cpuid_entries = e2;
+    vcpu->arch.cpuid_nent = nent;
+
+    kvm_update_cpuid_runtime(vcpu);
+    kvm_vcpu_after_set_cpuid(vcpu);
+
+    return 0;
+}
+
 /* when an old userspace process fills a new kernel module */
 int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 			     struct kvm_cpuid *cpuid,
@@ -275,18 +294,9 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 		e2[i].padding[2] = 0;
 	}
 
-	r = kvm_check_cpuid(e2, cpuid->nent);
-	if (r) {
+	r = kvm_set_cpuid(vcpu, e2, cpuid->nent);
+	if (r)
 		kvfree(e2);
-		goto out_free_cpuid;
-	}
-
-	kvfree(vcpu->arch.cpuid_entries);
-	vcpu->arch.cpuid_entries = e2;
-	vcpu->arch.cpuid_nent = cpuid->nent;
-
-	kvm_update_cpuid_runtime(vcpu);
-	kvm_vcpu_after_set_cpuid(vcpu);
 
 out_free_cpuid:
 	kvfree(e);
@@ -310,20 +320,11 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
 			return PTR_ERR(e2);
 	}
 
-	r = kvm_check_cpuid(e2, cpuid->nent);
-	if (r) {
+	r = kvm_set_cpuid(vcpu, e2, cpuid->nent);
+	if (r)
 		kvfree(e2);
-		return r;
-	}
 
-	kvfree(vcpu->arch.cpuid_entries);
-	vcpu->arch.cpuid_entries = e2;
-	vcpu->arch.cpuid_nent = cpuid->nent;
-
-	kvm_update_cpuid_runtime(vcpu);
-	kvm_vcpu_after_set_cpuid(vcpu);
-
-	return 0;
+	return r;
 }
 
 int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
-- 
2.20.1

