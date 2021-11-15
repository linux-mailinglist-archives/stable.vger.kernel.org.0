Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 879DD4521B0
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240195AbhKPBGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:06:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:44638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245419AbhKOTUc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 735E463471;
        Mon, 15 Nov 2021 18:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001266;
        bh=h7wDkC7YNBUZyAyIparUiaNhlmSjofSjgAY87Tgd3uA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zli4S1fLWXoifSMSyA4kNKcY9kiOL1+qfm0DEfA4ganh3rvrZZ4m1Hxhs7spIWSfK
         7gwerTYh6VjvQKUfgx1MWjTEq+7Swa+GYSsr6xqHXRxj2W6opePJYRLCQLg6HXk18i
         4yfMNhgEagyeCU7C2BuL03LuPX/LcVnGSLRndylk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 123/917] KVM: x86: Add helper to consolidate core logic of SET_CPUID{2} flows
Date:   Mon, 15 Nov 2021 17:53:38 +0100
Message-Id: <20211115165432.923290421@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 8b44b174f6aca815fc84c2038e4523ef8e32fabb upstream.

Move the core logic of SET_CPUID and SET_CPUID2 to a common helper, the
only difference between the two ioctls() is the format of the userspace
struct.  A future fix will add yet more code to the core logic.

No functional change intended.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20211105095101.5384-2-pdurrant@amazon.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c |   47 ++++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -232,6 +232,25 @@ u64 kvm_vcpu_reserved_gpa_bits_raw(struc
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
@@ -268,18 +287,9 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_
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
@@ -303,20 +313,11 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm
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


