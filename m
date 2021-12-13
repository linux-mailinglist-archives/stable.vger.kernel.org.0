Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A96EE472ECB
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238936AbhLMOUW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:20:22 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41806 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238937AbhLMOUQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 09:20:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCDA561033;
        Mon, 13 Dec 2021 14:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA4FC34602;
        Mon, 13 Dec 2021 14:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639405215;
        bh=LtaLxXGopc0Aawl4z26TPr7ZksGgNHr/nNvVDzX3I8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J4sQXVd9fCnraUK/0ZIOpfKPLu3dZZ7fZPECdwOuCPlAB7ClC8sW8n3fXARreASMN
         1s14uoHXraD0SoBP10jfV2Y6CWu4KZTorNx5/MGs/MslsNRF3cMbGIlBT6T2g9dRvl
         pehuMXkGufIUon3jrfQ86pBQ91QQBnvPl86fX8R5PzsW1jVi/T6In3rk4raLqJbpnr
         BENSXLX/jI18pxR291IHVPhqPUhlqe4+SlI+LbQqmSA4CZEdovyJpo2r59j1uj4Cen
         56X/ApguJM85IpUm4j2shCTpTnmnApqfVwAwTa5NIwsUUCeiNoH6KxXB0ciRqAu9Ar
         3mny701no51Bw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        seanjc@google.com, ricarkol@google.com, maz@kernel.org,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH MANUALSEL 5.15 7/9] KVM: selftests: Avoid KVM_SET_CPUID2 after KVM_RUN in hyperv_features test
Date:   Mon, 13 Dec 2021 09:19:40 -0500
Message-Id: <20211213141944.352249-7-sashal@kernel.org>
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

[ Upstream commit 6c1186430a808f97e2052bd5d9eff12c5d5defb0 ]

hyperv_features's sole purpose is to test access to various Hyper-V MSRs
and hypercalls with different CPUID data. As KVM_SET_CPUID2 after KVM_RUN
is deprecated and soon-to-be forbidden, avoid it by re-creating test VM
for each sub-test.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20211122175818.608220-2-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/kvm/x86_64/hyperv_features.c    | 140 +++++++++---------
 1 file changed, 71 insertions(+), 69 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index 91d88aaa98992..672915ce73d8f 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -165,10 +165,10 @@ static void hv_set_cpuid(struct kvm_vm *vm, struct kvm_cpuid2 *cpuid,
 	vcpu_set_cpuid(vm, VCPU_ID, cpuid);
 }
 
-static void guest_test_msrs_access(struct kvm_vm *vm, struct msr_data *msr,
-				   struct kvm_cpuid2 *best)
+static void guest_test_msrs_access(void)
 {
 	struct kvm_run *run;
+	struct kvm_vm *vm;
 	struct ucall uc;
 	int stage = 0, r;
 	struct kvm_cpuid_entry2 feat = {
@@ -180,11 +180,34 @@ static void guest_test_msrs_access(struct kvm_vm *vm, struct msr_data *msr,
 	struct kvm_cpuid_entry2 dbg = {
 		.function = HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES
 	};
-	struct kvm_enable_cap cap = {0};
-
-	run = vcpu_state(vm, VCPU_ID);
+	struct kvm_cpuid2 *best;
+	vm_vaddr_t msr_gva;
+	struct kvm_enable_cap cap = {
+		.cap = KVM_CAP_HYPERV_ENFORCE_CPUID,
+		.args = {1}
+	};
+	struct msr_data *msr;
 
 	while (true) {
+		vm = vm_create_default(VCPU_ID, 0, guest_msr);
+
+		msr_gva = vm_vaddr_alloc_page(vm);
+		memset(addr_gva2hva(vm, msr_gva), 0x0, getpagesize());
+		msr = addr_gva2hva(vm, msr_gva);
+
+		vcpu_args_set(vm, VCPU_ID, 1, msr_gva);
+		vcpu_enable_cap(vm, VCPU_ID, &cap);
+
+		vcpu_set_hv_cpuid(vm, VCPU_ID);
+
+		best = kvm_get_supported_hv_cpuid();
+
+		vm_init_descriptor_tables(vm);
+		vcpu_init_descriptor_tables(vm, VCPU_ID);
+		vm_install_exception_handler(vm, GP_VECTOR, guest_gp_handler);
+
+		run = vcpu_state(vm, VCPU_ID);
+
 		switch (stage) {
 		case 0:
 			/*
@@ -315,6 +338,7 @@ static void guest_test_msrs_access(struct kvm_vm *vm, struct msr_data *msr,
 			 * capability enabled and guest visible CPUID bit unset.
 			 */
 			cap.cap = KVM_CAP_HYPERV_SYNIC2;
+			cap.args[0] = 0;
 			vcpu_enable_cap(vm, VCPU_ID, &cap);
 			break;
 		case 22:
@@ -461,9 +485,9 @@ static void guest_test_msrs_access(struct kvm_vm *vm, struct msr_data *msr,
 
 		switch (get_ucall(vm, VCPU_ID, &uc)) {
 		case UCALL_SYNC:
-			TEST_ASSERT(uc.args[1] == stage,
-				    "Unexpected stage: %ld (%d expected)\n",
-				    uc.args[1], stage);
+			TEST_ASSERT(uc.args[1] == 0,
+				    "Unexpected stage: %ld (0 expected)\n",
+				    uc.args[1]);
 			break;
 		case UCALL_ABORT:
 			TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0],
@@ -474,13 +498,14 @@ static void guest_test_msrs_access(struct kvm_vm *vm, struct msr_data *msr,
 		}
 
 		stage++;
+		kvm_vm_free(vm);
 	}
 }
 
-static void guest_test_hcalls_access(struct kvm_vm *vm, struct hcall_data *hcall,
-				     void *input, void *output, struct kvm_cpuid2 *best)
+static void guest_test_hcalls_access(void)
 {
 	struct kvm_run *run;
+	struct kvm_vm *vm;
 	struct ucall uc;
 	int stage = 0, r;
 	struct kvm_cpuid_entry2 feat = {
@@ -493,10 +518,38 @@ static void guest_test_hcalls_access(struct kvm_vm *vm, struct hcall_data *hcall
 	struct kvm_cpuid_entry2 dbg = {
 		.function = HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES
 	};
-
-	run = vcpu_state(vm, VCPU_ID);
+	struct kvm_enable_cap cap = {
+		.cap = KVM_CAP_HYPERV_ENFORCE_CPUID,
+		.args = {1}
+	};
+	vm_vaddr_t hcall_page, hcall_params;
+	struct hcall_data *hcall;
+	struct kvm_cpuid2 *best;
 
 	while (true) {
+		vm = vm_create_default(VCPU_ID, 0, guest_hcall);
+
+		vm_init_descriptor_tables(vm);
+		vcpu_init_descriptor_tables(vm, VCPU_ID);
+		vm_install_exception_handler(vm, UD_VECTOR, guest_ud_handler);
+
+		/* Hypercall input/output */
+		hcall_page = vm_vaddr_alloc_pages(vm, 2);
+		hcall = addr_gva2hva(vm, hcall_page);
+		memset(addr_gva2hva(vm, hcall_page), 0x0, 2 * getpagesize());
+
+		hcall_params = vm_vaddr_alloc_page(vm);
+		memset(addr_gva2hva(vm, hcall_params), 0x0, getpagesize());
+
+		vcpu_args_set(vm, VCPU_ID, 2, addr_gva2gpa(vm, hcall_page), hcall_params);
+		vcpu_enable_cap(vm, VCPU_ID, &cap);
+
+		vcpu_set_hv_cpuid(vm, VCPU_ID);
+
+		best = kvm_get_supported_hv_cpuid();
+
+		run = vcpu_state(vm, VCPU_ID);
+
 		switch (stage) {
 		case 0:
 			hcall->control = 0xdeadbeef;
@@ -606,9 +659,9 @@ static void guest_test_hcalls_access(struct kvm_vm *vm, struct hcall_data *hcall
 
 		switch (get_ucall(vm, VCPU_ID, &uc)) {
 		case UCALL_SYNC:
-			TEST_ASSERT(uc.args[1] == stage,
-				    "Unexpected stage: %ld (%d expected)\n",
-				    uc.args[1], stage);
+			TEST_ASSERT(uc.args[1] == 0,
+				    "Unexpected stage: %ld (0 expected)\n",
+				    uc.args[1]);
 			break;
 		case UCALL_ABORT:
 			TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0],
@@ -619,66 +672,15 @@ static void guest_test_hcalls_access(struct kvm_vm *vm, struct hcall_data *hcall
 		}
 
 		stage++;
+		kvm_vm_free(vm);
 	}
 }
 
 int main(void)
 {
-	struct kvm_cpuid2 *best;
-	struct kvm_vm *vm;
-	vm_vaddr_t msr_gva, hcall_page, hcall_params;
-	struct kvm_enable_cap cap = {
-		.cap = KVM_CAP_HYPERV_ENFORCE_CPUID,
-		.args = {1}
-	};
-
-	/* Test MSRs */
-	vm = vm_create_default(VCPU_ID, 0, guest_msr);
-
-	msr_gva = vm_vaddr_alloc_page(vm);
-	memset(addr_gva2hva(vm, msr_gva), 0x0, getpagesize());
-	vcpu_args_set(vm, VCPU_ID, 1, msr_gva);
-	vcpu_enable_cap(vm, VCPU_ID, &cap);
-
-	vcpu_set_hv_cpuid(vm, VCPU_ID);
-
-	best = kvm_get_supported_hv_cpuid();
-
-	vm_init_descriptor_tables(vm);
-	vcpu_init_descriptor_tables(vm, VCPU_ID);
-	vm_install_exception_handler(vm, GP_VECTOR, guest_gp_handler);
-
 	pr_info("Testing access to Hyper-V specific MSRs\n");
-	guest_test_msrs_access(vm, addr_gva2hva(vm, msr_gva),
-			       best);
-	kvm_vm_free(vm);
-
-	/* Test hypercalls */
-	vm = vm_create_default(VCPU_ID, 0, guest_hcall);
-
-	vm_init_descriptor_tables(vm);
-	vcpu_init_descriptor_tables(vm, VCPU_ID);
-	vm_install_exception_handler(vm, UD_VECTOR, guest_ud_handler);
-
-	/* Hypercall input/output */
-	hcall_page = vm_vaddr_alloc_pages(vm, 2);
-	memset(addr_gva2hva(vm, hcall_page), 0x0, 2 * getpagesize());
-
-	hcall_params = vm_vaddr_alloc_page(vm);
-	memset(addr_gva2hva(vm, hcall_params), 0x0, getpagesize());
-
-	vcpu_args_set(vm, VCPU_ID, 2, addr_gva2gpa(vm, hcall_page), hcall_params);
-	vcpu_enable_cap(vm, VCPU_ID, &cap);
-
-	vcpu_set_hv_cpuid(vm, VCPU_ID);
-
-	best = kvm_get_supported_hv_cpuid();
+	guest_test_msrs_access();
 
 	pr_info("Testing access to Hyper-V hypercalls\n");
-	guest_test_hcalls_access(vm, addr_gva2hva(vm, hcall_params),
-				 addr_gva2hva(vm, hcall_page),
-				 addr_gva2hva(vm, hcall_page) + getpagesize(),
-				 best);
-
-	kvm_vm_free(vm);
+	guest_test_hcalls_access();
 }
-- 
2.33.0

