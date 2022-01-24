Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01AC6498068
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 14:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242880AbiAXNFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 08:05:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34793 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239721AbiAXNFp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 08:05:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643029545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y9XdJI0onvJoCdSTO3zWbK1yaLtPTwQERDe6IWNipTs=;
        b=Ddx/TkVGO2bYsOe/+E9exP1QKCN3a0ar8HvF+ms5+y/Q1YGcTklaC5/gHLPaZaK3ZD16gp
        +FL2yDqLcg8B+2Bqd0xBzmYopncd7WyQqg1O2ZTUzyTS7kmzh4Zgi4N0GGlBgLlVcF2z5V
        FXzotygbLutmwhKGUXhzPwuKZ1hngFs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-362-KhRoKB50Me2Ib837t_6mug-1; Mon, 24 Jan 2022 08:05:42 -0500
X-MC-Unique: KhRoKB50Me2Ib837t_6mug-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A7EB8143EB;
        Mon, 24 Jan 2022 13:05:41 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 70A0B7D533;
        Mon, 24 Jan 2022 13:05:39 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>, gregkh@linuxfoundation.org
Subject: [PATCH stable 5.16 v1 2/4] KVM: x86: Partially allow KVM_SET_CPUID{,2} after KVM_RUN
Date:   Mon, 24 Jan 2022 14:05:32 +0100
Message-Id: <20220124130534.2645955-3-vkuznets@redhat.com>
In-Reply-To: <20220124130534.2645955-1-vkuznets@redhat.com>
References: <20220124130534.2645955-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit c6617c61e8fe44b9e9fdfede921f61cac6b5149d upstream.

Commit feb627e8d6f6 ("KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN")
forbade changing CPUID altogether but unfortunately this is not fully
compatible with existing VMMs. In particular, QEMU reuses vCPU fds for
CPU hotplug after unplug and it calls KVM_SET_CPUID2. Instead of full ban,
check whether the supplied CPUID data is equal to what was previously set.

Reported-by: Igor Mammedov <imammedo@redhat.com>
Fixes: feb627e8d6f6 ("KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20220117150542.2176196-3-vkuznets@redhat.com>
Cc: stable@vger.kernel.org
[Do not call kvm_find_cpuid_entry repeatedly. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/cpuid.c | 36 ++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c   | 19 -------------------
 2 files changed, 36 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index c4d4c350afbe..e5e597fc3c86 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -99,6 +99,28 @@ static int kvm_check_cpuid(struct kvm_cpuid_entry2 *entries, int nent)
 	return 0;
 }
 
+/* Check whether the supplied CPUID data is equal to what is already set for the vCPU. */
+static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
+				 int nent)
+{
+	struct kvm_cpuid_entry2 *orig;
+	int i;
+
+	if (nent != vcpu->arch.cpuid_nent)
+		return -EINVAL;
+
+	for (i = 0; i < nent; i++) {
+		orig = &vcpu->arch.cpuid_entries[i];
+		if (e2[i].function != orig->function ||
+		    e2[i].index != orig->index ||
+		    e2[i].eax != orig->eax || e2[i].ebx != orig->ebx ||
+		    e2[i].ecx != orig->ecx || e2[i].edx != orig->edx)
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
 static void kvm_update_kvm_cpuid_base(struct kvm_vcpu *vcpu)
 {
 	u32 function;
@@ -293,6 +315,20 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 
 	__kvm_update_cpuid_runtime(vcpu, e2, nent);
 
+	/*
+	 * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
+	 * MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, etc.. aren't
+	 * tracked in kvm_mmu_page_role.  As a result, KVM may miss guest page
+	 * faults due to reusing SPs/SPTEs. In practice no sane VMM mucks with
+	 * the core vCPU model on the fly. It would've been better to forbid any
+	 * KVM_SET_CPUID{,2} calls after KVM_RUN altogether but unfortunately
+	 * some VMMs (e.g. QEMU) reuse vCPU fds for CPU hotplug/unplug and do
+	 * KVM_SET_CPUID{,2} again. To support this legacy behavior, check
+	 * whether the supplied CPUID data is equal to what's already set.
+	 */
+	if (vcpu->arch.last_vmentry_cpu != -1)
+		return kvm_cpuid_check_equal(vcpu, e2, nent);
+
 	r = kvm_check_cpuid(e2, nent);
 	if (r)
 		return r;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0b5c61bb24a1..d8277a35dfb8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5148,17 +5148,6 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		struct kvm_cpuid __user *cpuid_arg = argp;
 		struct kvm_cpuid cpuid;
 
-		/*
-		 * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
-		 * MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, etc.. aren't
-		 * tracked in kvm_mmu_page_role.  As a result, KVM may miss guest page
-		 * faults due to reusing SPs/SPTEs.  In practice no sane VMM mucks with
-		 * the core vCPU model on the fly, so fail.
-		 */
-		r = -EINVAL;
-		if (vcpu->arch.last_vmentry_cpu != -1)
-			goto out;
-
 		r = -EFAULT;
 		if (copy_from_user(&cpuid, cpuid_arg, sizeof(cpuid)))
 			goto out;
@@ -5169,14 +5158,6 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		struct kvm_cpuid2 __user *cpuid_arg = argp;
 		struct kvm_cpuid2 cpuid;
 
-		/*
-		 * KVM_SET_CPUID{,2} after KVM_RUN is forbidded, see the comment in
-		 * KVM_SET_CPUID case above.
-		 */
-		r = -EINVAL;
-		if (vcpu->arch.last_vmentry_cpu != -1)
-			goto out;
-
 		r = -EFAULT;
 		if (copy_from_user(&cpuid, cpuid_arg, sizeof(cpuid)))
 			goto out;
-- 
2.34.1

