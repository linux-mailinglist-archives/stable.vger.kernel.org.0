Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9826E44F7CF
	for <lists+stable@lfdr.de>; Sun, 14 Nov 2021 13:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235272AbhKNMWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Nov 2021 07:22:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:40382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229563AbhKNMVr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Nov 2021 07:21:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B7D761056;
        Sun, 14 Nov 2021 12:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636892333;
        bh=mWGoh2ELJTIgNW4Ypzns1Yu5MZAB/qkYLN4pkJ2Hdhw=;
        h=Subject:To:Cc:From:Date:From;
        b=1yvO/KOXOs6cd6xw9fCoh5l0sB1Rv4jI0NIgnJrlPbO+cZSeXj0Tzy8hQt0+sU8Zh
         AUqnW/DGnSKnHzvkgxprdCcNLD6z/SdzUZBfB1EA2imTku0UhenWg7UZU8cWRf3inu
         W8NAiMVckTaMXR0PZAmbVoaHJZ/btUG7nek6hUg0=
Subject: FAILED: patch "[PATCH] KVM: x86: Add helper to consolidate core logic of" failed to apply to 5.10-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 14 Nov 2021 13:18:41 +0100
Message-ID: <163689232146110@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8b44b174f6aca815fc84c2038e4523ef8e32fabb Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 5 Nov 2021 09:51:00 +0000
Subject: [PATCH] KVM: x86: Add helper to consolidate core logic of
 SET_CPUID{2} flows

Move the core logic of SET_CPUID and SET_CPUID2 to a common helper, the
only difference between the two ioctls() is the format of the userspace
struct.  A future fix will add yet more code to the core logic.

No functional change intended.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20211105095101.5384-2-pdurrant@amazon.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

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

