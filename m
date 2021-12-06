Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64238469EF4
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386095AbhLFPo4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:44:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390745AbhLFPmt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:42:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E296C07E5E0;
        Mon,  6 Dec 2021 07:30:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B6786132E;
        Mon,  6 Dec 2021 15:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0FD4C34900;
        Mon,  6 Dec 2021 15:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804615;
        bh=3y7uuz14VXplgQt6IuUT9qYCliUFKj9GEnkdjndRIVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BpbghS5NhNzzLcaeQUS6WHkH86bBYTQ1OTKm9THNTNzW2EnEx6GQdUpLODtQZ6wIK
         CFxC/RxSUMABT3lT7PNzI3uC0YgDevCqNYKNBrHVHYfGcq+YxhT1nxV3QNsI3jzNI7
         AocTnQl/3nDBf5JLep8NPgbiTlzUpyFxjy4hX2WU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 178/207] KVM: SEV: Return appropriate error codes if SEV-ES scratch setup fails
Date:   Mon,  6 Dec 2021 15:57:12 +0100
Message-Id: <20211206145616.436869514@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 75236f5f2299b502e4b9b267c1ce3bc14a222ceb ]

Return appropriate error codes if setting up the GHCB scratch area for an
SEV-ES guest fails.  In particular, returning -EINVAL instead of -ENOMEM
when allocating the kernel buffer could be confusing as userspace would
likely suspect a guest issue.

Fixes: 8f423a80d299 ("KVM: SVM: Support MMIO for an SEV-ES guest")
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20211109222350.2266045-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/sev.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index ca0effb79eab9..134c4ea5e6ad8 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2317,7 +2317,7 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
 }
 
 #define GHCB_SCRATCH_AREA_LIMIT		(16ULL * PAGE_SIZE)
-static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
+static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	struct ghcb *ghcb = svm->ghcb;
@@ -2328,14 +2328,14 @@ static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 	scratch_gpa_beg = ghcb_get_sw_scratch(ghcb);
 	if (!scratch_gpa_beg) {
 		pr_err("vmgexit: scratch gpa not provided\n");
-		return false;
+		return -EINVAL;
 	}
 
 	scratch_gpa_end = scratch_gpa_beg + len;
 	if (scratch_gpa_end < scratch_gpa_beg) {
 		pr_err("vmgexit: scratch length (%#llx) not valid for scratch address (%#llx)\n",
 		       len, scratch_gpa_beg);
-		return false;
+		return -EINVAL;
 	}
 
 	if ((scratch_gpa_beg & PAGE_MASK) == control->ghcb_gpa) {
@@ -2353,7 +2353,7 @@ static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 		    scratch_gpa_end > ghcb_scratch_end) {
 			pr_err("vmgexit: scratch area is outside of GHCB shared buffer area (%#llx - %#llx)\n",
 			       scratch_gpa_beg, scratch_gpa_end);
-			return false;
+			return -EINVAL;
 		}
 
 		scratch_va = (void *)svm->ghcb;
@@ -2366,18 +2366,18 @@ static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 		if (len > GHCB_SCRATCH_AREA_LIMIT) {
 			pr_err("vmgexit: scratch area exceeds KVM limits (%#llx requested, %#llx limit)\n",
 			       len, GHCB_SCRATCH_AREA_LIMIT);
-			return false;
+			return -EINVAL;
 		}
 		scratch_va = kzalloc(len, GFP_KERNEL_ACCOUNT);
 		if (!scratch_va)
-			return false;
+			return -ENOMEM;
 
 		if (kvm_read_guest(svm->vcpu.kvm, scratch_gpa_beg, scratch_va, len)) {
 			/* Unable to copy scratch area from guest */
 			pr_err("vmgexit: kvm_read_guest for scratch area failed\n");
 
 			kfree(scratch_va);
-			return false;
+			return -EFAULT;
 		}
 
 		/*
@@ -2393,7 +2393,7 @@ static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 	svm->ghcb_sa = scratch_va;
 	svm->ghcb_sa_len = len;
 
-	return true;
+	return 0;
 }
 
 static void set_ghcb_msr_bits(struct vcpu_svm *svm, u64 value, u64 mask,
@@ -2532,10 +2532,10 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 	ghcb_set_sw_exit_info_1(ghcb, 0);
 	ghcb_set_sw_exit_info_2(ghcb, 0);
 
-	ret = -EINVAL;
 	switch (exit_code) {
 	case SVM_VMGEXIT_MMIO_READ:
-		if (!setup_vmgexit_scratch(svm, true, control->exit_info_2))
+		ret = setup_vmgexit_scratch(svm, true, control->exit_info_2);
+		if (ret)
 			break;
 
 		ret = kvm_sev_es_mmio_read(vcpu,
@@ -2544,7 +2544,8 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 					   svm->ghcb_sa);
 		break;
 	case SVM_VMGEXIT_MMIO_WRITE:
-		if (!setup_vmgexit_scratch(svm, false, control->exit_info_2))
+		ret = setup_vmgexit_scratch(svm, false, control->exit_info_2);
+		if (ret)
 			break;
 
 		ret = kvm_sev_es_mmio_write(vcpu,
@@ -2587,6 +2588,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
 			    control->exit_info_1, control->exit_info_2);
+		ret = -EINVAL;
 		break;
 	default:
 		ret = svm_invoke_exit_handler(vcpu, exit_code);
@@ -2599,6 +2601,7 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
 {
 	int count;
 	int bytes;
+	int r;
 
 	if (svm->vmcb->control.exit_info_2 > INT_MAX)
 		return -EINVAL;
@@ -2607,8 +2610,9 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
 	if (unlikely(check_mul_overflow(count, size, &bytes)))
 		return -EINVAL;
 
-	if (!setup_vmgexit_scratch(svm, in, bytes))
-		return -EINVAL;
+	r = setup_vmgexit_scratch(svm, in, bytes);
+	if (r)
+		return r;
 
 	return kvm_sev_es_string_io(&svm->vcpu, size, port, svm->ghcb_sa, count, in);
 }
-- 
2.33.0



