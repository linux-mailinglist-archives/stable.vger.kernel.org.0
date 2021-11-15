Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6A9451110
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237999AbhKOTAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:00:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:33630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243307AbhKOS6c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:58:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA70663491;
        Mon, 15 Nov 2021 18:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999977;
        bh=u7muo/mGyPVEsoiZHOl5X7P4PEuR9PTtZuoVs3d+uE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gfmyUL0z6Xza/aOi480BPKetswpzcI1Esesas4UTV7NYTF786IDCIaYfSL3rvDfd9
         YFZhLTV13U6AxhRsedvtXKlBGvWRI7SBgfEMdJMWf5zE60ojA17aWYAIQaMAtv5sqS
         fv7RNVL03Sx6I4iJyK6+ccYMtf1f9GQYx041chpA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ricardo Koller <ricarkol@google.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 491/849] KVM: selftests: Fix nested SVM tests when built with clang
Date:   Mon, 15 Nov 2021 17:59:34 +0100
Message-Id: <20211115165436.891144908@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Mattson <jmattson@google.com>

[ Upstream commit ed290e1c20da19fa100a3e0f421aa31b65984960 ]

Though gcc conveniently compiles a simple memset to "rep stos," clang
prefers to call the libc version of memset. If a test is dynamically
linked, the libc memset isn't available in L1 (nor is the PLT or the
GOT, for that matter). Even if the test is statically linked, the libc
memset may choose to use some CPU features, like AVX, which may not be
enabled in L1. Note that __builtin_memset doesn't solve the problem,
because (a) the compiler is free to call memset anyway, and (b)
__builtin_memset may also choose to use features like AVX, which may
not be available in L1.

To avoid a myriad of problems, use an explicit "rep stos" to clear the
VMCB in generic_svm_setup(), which is called both from L0 and L1.

Reported-by: Ricardo Koller <ricarkol@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
Fixes: 20ba262f8631a ("selftests: KVM: AMD Nested test infrastructure")
Message-Id: <20210930003649.4026553-1-jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/lib/x86_64/svm.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/svm.c b/tools/testing/selftests/kvm/lib/x86_64/svm.c
index 2ac98d70d02bd..161eba7cd1289 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/svm.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/svm.c
@@ -54,6 +54,18 @@ static void vmcb_set_seg(struct vmcb_seg *seg, u16 selector,
 	seg->base = base;
 }
 
+/*
+ * Avoid using memset to clear the vmcb, since libc may not be
+ * available in L1 (and, even if it is, features that libc memset may
+ * want to use, like AVX, may not be enabled).
+ */
+static void clear_vmcb(struct vmcb *vmcb)
+{
+	int n = sizeof(*vmcb) / sizeof(u32);
+
+	asm volatile ("rep stosl" : "+c"(n), "+D"(vmcb) : "a"(0) : "memory");
+}
+
 void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_rsp)
 {
 	struct vmcb *vmcb = svm->vmcb;
@@ -70,7 +82,7 @@ void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_r
 	wrmsr(MSR_EFER, efer | EFER_SVME);
 	wrmsr(MSR_VM_HSAVE_PA, svm->save_area_gpa);
 
-	memset(vmcb, 0, sizeof(*vmcb));
+	clear_vmcb(vmcb);
 	asm volatile ("vmsave %0\n\t" : : "a" (vmcb_gpa) : "memory");
 	vmcb_set_seg(&save->es, get_es(), 0, -1U, data_seg_attr);
 	vmcb_set_seg(&save->cs, get_cs(), 0, -1U, code_seg_attr);
-- 
2.33.0



