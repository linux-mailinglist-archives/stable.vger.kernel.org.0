Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1EFC499BC4
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1454897AbiAXVy7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:54:59 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52676 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573482AbiAXVo6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:44:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8842FB80CCF;
        Mon, 24 Jan 2022 21:44:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CBF5C340E4;
        Mon, 24 Jan 2022 21:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060696;
        bh=93huczeIyL5LcJsflgRKmCn63D+6drfz/04KRlXSC0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yEJy/fSU0ZwRBJnByBi4HS+eiUHXLIq8Ej3yBk4ORxom3J/FAfo8HVNicVC4bc3NF
         PX9e3Lvts57LoNTcCtamDwggCazlz1o0qE5859AOjwUSckvYX2+VDMs5otT12+XShe
         PucH1dnFVjSUOUsMSW31Au5isiWQlRup40lkOi4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Igor Mammedov <imammedo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.16 1033/1039] KVM: x86: Partially allow KVM_SET_CPUID{,2} after KVM_RUN
Date:   Mon, 24 Jan 2022 19:47:02 +0100
Message-Id: <20220124184200.012351266@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c |   36 ++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c   |   19 -------------------
 2 files changed, 36 insertions(+), 19 deletions(-)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -99,6 +99,28 @@ static int kvm_check_cpuid(struct kvm_cp
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
@@ -293,6 +315,20 @@ static int kvm_set_cpuid(struct kvm_vcpu
 
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
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5149,17 +5149,6 @@ long kvm_arch_vcpu_ioctl(struct file *fi
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
@@ -5170,14 +5159,6 @@ long kvm_arch_vcpu_ioctl(struct file *fi
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


