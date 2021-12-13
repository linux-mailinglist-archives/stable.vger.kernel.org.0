Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1CC472EB9
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238879AbhLMOUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:20:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238847AbhLMOUH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 09:20:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38646C061574;
        Mon, 13 Dec 2021 06:20:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC2FD61003;
        Mon, 13 Dec 2021 14:20:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19373C34606;
        Mon, 13 Dec 2021 14:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639405206;
        bh=T79iOtEFLobZ4T4axIwAfyU8EpytqKkYZULNP5G5MOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QymjElF6OJgiiEZ65w6mZ3sBwFtjZf+XRRMYxbxdUmW3BUJkD3687M7soK8gkjLHg
         /khE5tn/0dnKt1yDiTC/6gM6UFTFZ4kFvgyX7cBXDDbY+2EgR5FtUQXeHiUxT+omku
         dpBlkA46kaFBpLTqlQv9FARJsYEwPfy1rv+mS93z+t8B3vDHWhb37mHM8kV3YGnie5
         HsXYJI4qKBVPMAK5jSlXyXistGfVFy4yyO+mlmI16qJCBhTQHh3fW+4aGHVpFsCzrD
         HvLFUD7QN6QxtZri02FEVj9sSoZdT1oY4NtlfbMJUPVltv2E/bBAWe8kUMA6tYaWHk
         kO9mjlofg/cDQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.15 6/9] KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN
Date:   Mon, 13 Dec 2021 09:19:39 -0500
Message-Id: <20211213141944.352249-6-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211213141944.352249-1-sashal@kernel.org>
References: <20211213141944.352249-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit feb627e8d6f69c9a319fe279710959efb3eba873 ]

Commit 63f5a1909f9e ("KVM: x86: Alert userspace that KVM_SET_CPUID{,2}
after KVM_RUN is broken") officially deprecated KVM_SET_CPUID{,2} ioctls
after first successful KVM_RUN and promissed to make this sequence forbiden
in 5.16. It's time to fulfil the promise.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20211122175818.608220-3-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c | 28 +++++++++++-----------------
 arch/x86/kvm/x86.c     | 19 +++++++++++++++++++
 2 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0a88cb4f731f4..31392e492ce5e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5022,6 +5022,14 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	/*
 	 * Invalidate all MMU roles to force them to reinitialize as CPUID
 	 * information is factored into reserved bit calculations.
+	 *
+	 * Correctly handling multiple vCPU models with respect to paging and
+	 * physical address properties) in a single VM would require tracking
+	 * all relevant CPUID information in kvm_mmu_page_role. That is very
+	 * undesirable as it would increase the memory requirements for
+	 * gfn_track (see struct kvm_mmu_page_role comments).  For now that
+	 * problem is swept under the rug; KVM's CPUID API is horrific and
+	 * it's all but impossible to solve it without introducing a new API.
 	 */
 	vcpu->arch.root_mmu.mmu_role.ext.valid = 0;
 	vcpu->arch.guest_mmu.mmu_role.ext.valid = 0;
@@ -5029,24 +5037,10 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	kvm_mmu_reset_context(vcpu);
 
 	/*
-	 * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
-	 * MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, etc.. aren't
-	 * tracked in kvm_mmu_page_role.  As a result, KVM may miss guest page
-	 * faults due to reusing SPs/SPTEs.  Alert userspace, but otherwise
-	 * sweep the problem under the rug.
-	 *
-	 * KVM's horrific CPUID ABI makes the problem all but impossible to
-	 * solve, as correctly handling multiple vCPU models (with respect to
-	 * paging and physical address properties) in a single VM would require
-	 * tracking all relevant CPUID information in kvm_mmu_page_role.  That
-	 * is very undesirable as it would double the memory requirements for
-	 * gfn_track (see struct kvm_mmu_page_role comments), and in practice
-	 * no sane VMM mucks with the core vCPU model on the fly.
+	 * Changing guest CPUID after KVM_RUN is forbidden, see the comment in
+	 * kvm_arch_vcpu_ioctl().
 	 */
-	if (vcpu->arch.last_vmentry_cpu != -1) {
-		pr_warn_ratelimited("KVM: KVM_SET_CPUID{,2} after KVM_RUN may cause guest instability\n");
-		pr_warn_ratelimited("KVM: KVM_SET_CPUID{,2} will fail after KVM_RUN starting with Linux 5.16\n");
-	}
+	KVM_BUG_ON(vcpu->arch.last_vmentry_cpu != -1, vcpu->kvm);
 }
 
 void kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b7aa845f7beee..2a584070833f9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5088,6 +5088,17 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		struct kvm_cpuid __user *cpuid_arg = argp;
 		struct kvm_cpuid cpuid;
 
+		/*
+		 * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
+		 * MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, etc.. aren't
+		 * tracked in kvm_mmu_page_role.  As a result, KVM may miss guest page
+		 * faults due to reusing SPs/SPTEs.  In practice no sane VMM mucks with
+		 * the core vCPU model on the fly, so fail.
+		 */
+		r = -EINVAL;
+		if (vcpu->arch.last_vmentry_cpu != -1)
+			goto out;
+
 		r = -EFAULT;
 		if (copy_from_user(&cpuid, cpuid_arg, sizeof(cpuid)))
 			goto out;
@@ -5098,6 +5109,14 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		struct kvm_cpuid2 __user *cpuid_arg = argp;
 		struct kvm_cpuid2 cpuid;
 
+		/*
+		 * KVM_SET_CPUID{,2} after KVM_RUN is forbidded, see the comment in
+		 * KVM_SET_CPUID case above.
+		 */
+		r = -EINVAL;
+		if (vcpu->arch.last_vmentry_cpu != -1)
+			goto out;
+
 		r = -EFAULT;
 		if (copy_from_user(&cpuid, cpuid_arg, sizeof(cpuid)))
 			goto out;
-- 
2.33.0

