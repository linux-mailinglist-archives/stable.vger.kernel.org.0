Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877A549A444
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2371284AbiAYAH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:07:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2366198AbiAXXwa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:52:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F62DC07A95A;
        Mon, 24 Jan 2022 13:45:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E22EA61526;
        Mon, 24 Jan 2022 21:44:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C544DC340E4;
        Mon, 24 Jan 2022 21:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060699;
        bh=8bENf6cNn8iSqukolOSktTCl4u7Y/tJUsqjzNi6sVk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XPnEWuA8QNaeeQqqZQC7BsppBpqD6WeiZeJT8rCj7X/tnUBaggyL0TfmPw4rvr+yB
         PgZfK67DVoz2vBx5dnzs/K5EDKQzUt0grHgeztQPSszesuFR2B+CWS14qXH36yKV3W
         LuAKOSVtn1HoXFVR/IUSrVDMN/riMeQIGaWFlowU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.16 1034/1039] KVM: selftests: Rename get_cpuid_test to cpuid_test
Date:   Mon, 24 Jan 2022 19:47:03 +0100
Message-Id: <20220124184200.043291349@linuxfoundation.org>
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

commit 9e6d484f9991176269607bb3c54a494e32eab27a upstream.

In preparation to reusing the existing 'get_cpuid_test' for testing
"KVM_SET_CPUID{,2} after KVM_RUN" rename it to 'cpuid_test' to avoid
the confusion.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20220117150542.2176196-4-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/kvm/.gitignore                        | 2 +-
 tools/testing/selftests/kvm/Makefile                          | 4 ++--
 .../selftests/kvm/x86_64/{get_cpuid_test.c => cpuid_test.c}   | 0
 tools/testing/selftests/kvm/.gitignore              |    2 
 tools/testing/selftests/kvm/Makefile                |    4 
 tools/testing/selftests/kvm/x86_64/cpuid_test.c     |  179 ++++++++++++++++++++
 tools/testing/selftests/kvm/x86_64/get_cpuid_test.c |  179 --------------------
 4 files changed, 182 insertions(+), 182 deletions(-)
 rename tools/testing/selftests/kvm/x86_64/{get_cpuid_test.c => cpuid_test.c} (100%)

--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -7,11 +7,11 @@
 /s390x/memop
 /s390x/resets
 /s390x/sync_regs_test
+/x86_64/cpuid_test
 /x86_64/cr4_cpuid_sync_test
 /x86_64/debug_regs
 /x86_64/evmcs_test
 /x86_64/emulator_error_test
-/x86_64/get_cpuid_test
 /x86_64/get_msr_index_features
 /x86_64/kvm_clock_test
 /x86_64/kvm_pv_test
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -38,11 +38,11 @@ LIBKVM_x86_64 = lib/x86_64/apic.c lib/x8
 LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S lib/aarch64/spinlock.c lib/aarch64/gic.c lib/aarch64/gic_v3.c lib/aarch64/vgic.c
 LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_handler.c
 
-TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
+TEST_GEN_PROGS_x86_64 = x86_64/cpuid_test
+TEST_GEN_PROGS_x86_64 += x86_64/cr4_cpuid_sync_test
 TEST_GEN_PROGS_x86_64 += x86_64/get_msr_index_features
 TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
 TEST_GEN_PROGS_x86_64 += x86_64/emulator_error_test
-TEST_GEN_PROGS_x86_64 += x86_64/get_cpuid_test
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_clock
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_features
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
@@ -0,0 +1,179 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2021, Red Hat Inc.
+ *
+ * Generic tests for KVM CPUID set/get ioctls
+ */
+#include <asm/kvm_para.h>
+#include <linux/kvm_para.h>
+#include <stdint.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+
+#define VCPU_ID 0
+
+/* CPUIDs known to differ */
+struct {
+	u32 function;
+	u32 index;
+} mangled_cpuids[] = {
+	/*
+	 * These entries depend on the vCPU's XCR0 register and IA32_XSS MSR,
+	 * which are not controlled for by this test.
+	 */
+	{.function = 0xd, .index = 0},
+	{.function = 0xd, .index = 1},
+};
+
+static void test_guest_cpuids(struct kvm_cpuid2 *guest_cpuid)
+{
+	int i;
+	u32 eax, ebx, ecx, edx;
+
+	for (i = 0; i < guest_cpuid->nent; i++) {
+		eax = guest_cpuid->entries[i].function;
+		ecx = guest_cpuid->entries[i].index;
+
+		cpuid(&eax, &ebx, &ecx, &edx);
+
+		GUEST_ASSERT(eax == guest_cpuid->entries[i].eax &&
+			     ebx == guest_cpuid->entries[i].ebx &&
+			     ecx == guest_cpuid->entries[i].ecx &&
+			     edx == guest_cpuid->entries[i].edx);
+	}
+
+}
+
+static void test_cpuid_40000000(struct kvm_cpuid2 *guest_cpuid)
+{
+	u32 eax = 0x40000000, ebx, ecx = 0, edx;
+
+	cpuid(&eax, &ebx, &ecx, &edx);
+
+	GUEST_ASSERT(eax == 0x40000001);
+}
+
+static void guest_main(struct kvm_cpuid2 *guest_cpuid)
+{
+	GUEST_SYNC(1);
+
+	test_guest_cpuids(guest_cpuid);
+
+	GUEST_SYNC(2);
+
+	test_cpuid_40000000(guest_cpuid);
+
+	GUEST_DONE();
+}
+
+static bool is_cpuid_mangled(struct kvm_cpuid_entry2 *entrie)
+{
+	int i;
+
+	for (i = 0; i < sizeof(mangled_cpuids); i++) {
+		if (mangled_cpuids[i].function == entrie->function &&
+		    mangled_cpuids[i].index == entrie->index)
+			return true;
+	}
+
+	return false;
+}
+
+static void check_cpuid(struct kvm_cpuid2 *cpuid, struct kvm_cpuid_entry2 *entrie)
+{
+	int i;
+
+	for (i = 0; i < cpuid->nent; i++) {
+		if (cpuid->entries[i].function == entrie->function &&
+		    cpuid->entries[i].index == entrie->index) {
+			if (is_cpuid_mangled(entrie))
+				return;
+
+			TEST_ASSERT(cpuid->entries[i].eax == entrie->eax &&
+				    cpuid->entries[i].ebx == entrie->ebx &&
+				    cpuid->entries[i].ecx == entrie->ecx &&
+				    cpuid->entries[i].edx == entrie->edx,
+				    "CPUID 0x%x.%x differ: 0x%x:0x%x:0x%x:0x%x vs 0x%x:0x%x:0x%x:0x%x",
+				    entrie->function, entrie->index,
+				    cpuid->entries[i].eax, cpuid->entries[i].ebx,
+				    cpuid->entries[i].ecx, cpuid->entries[i].edx,
+				    entrie->eax, entrie->ebx, entrie->ecx, entrie->edx);
+			return;
+		}
+	}
+
+	TEST_ASSERT(false, "CPUID 0x%x.%x not found", entrie->function, entrie->index);
+}
+
+static void compare_cpuids(struct kvm_cpuid2 *cpuid1, struct kvm_cpuid2 *cpuid2)
+{
+	int i;
+
+	for (i = 0; i < cpuid1->nent; i++)
+		check_cpuid(cpuid2, &cpuid1->entries[i]);
+
+	for (i = 0; i < cpuid2->nent; i++)
+		check_cpuid(cpuid1, &cpuid2->entries[i]);
+}
+
+static void run_vcpu(struct kvm_vm *vm, uint32_t vcpuid, int stage)
+{
+	struct ucall uc;
+
+	_vcpu_run(vm, vcpuid);
+
+	switch (get_ucall(vm, vcpuid, &uc)) {
+	case UCALL_SYNC:
+		TEST_ASSERT(!strcmp((const char *)uc.args[0], "hello") &&
+			    uc.args[1] == stage + 1,
+			    "Stage %d: Unexpected register values vmexit, got %lx",
+			    stage + 1, (ulong)uc.args[1]);
+		return;
+	case UCALL_DONE:
+		return;
+	case UCALL_ABORT:
+		TEST_ASSERT(false, "%s at %s:%ld\n\tvalues: %#lx, %#lx", (const char *)uc.args[0],
+			    __FILE__, uc.args[1], uc.args[2], uc.args[3]);
+	default:
+		TEST_ASSERT(false, "Unexpected exit: %s",
+			    exit_reason_str(vcpu_state(vm, vcpuid)->exit_reason));
+	}
+}
+
+struct kvm_cpuid2 *vcpu_alloc_cpuid(struct kvm_vm *vm, vm_vaddr_t *p_gva, struct kvm_cpuid2 *cpuid)
+{
+	int size = sizeof(*cpuid) + cpuid->nent * sizeof(cpuid->entries[0]);
+	vm_vaddr_t gva = vm_vaddr_alloc(vm, size, KVM_UTIL_MIN_VADDR);
+	struct kvm_cpuid2 *guest_cpuids = addr_gva2hva(vm, gva);
+
+	memcpy(guest_cpuids, cpuid, size);
+
+	*p_gva = gva;
+	return guest_cpuids;
+}
+
+int main(void)
+{
+	struct kvm_cpuid2 *supp_cpuid, *cpuid2;
+	vm_vaddr_t cpuid_gva;
+	struct kvm_vm *vm;
+	int stage;
+
+	vm = vm_create_default(VCPU_ID, 0, guest_main);
+
+	supp_cpuid = kvm_get_supported_cpuid();
+	cpuid2 = vcpu_get_cpuid(vm, VCPU_ID);
+
+	compare_cpuids(supp_cpuid, cpuid2);
+
+	vcpu_alloc_cpuid(vm, &cpuid_gva, cpuid2);
+
+	vcpu_args_set(vm, VCPU_ID, 1, cpuid_gva);
+
+	for (stage = 0; stage < 3; stage++)
+		run_vcpu(vm, VCPU_ID, stage);
+
+	kvm_vm_free(vm);
+}
--- a/tools/testing/selftests/kvm/x86_64/get_cpuid_test.c
+++ /dev/null
@@ -1,179 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Copyright (C) 2021, Red Hat Inc.
- *
- * Generic tests for KVM CPUID set/get ioctls
- */
-#include <asm/kvm_para.h>
-#include <linux/kvm_para.h>
-#include <stdint.h>
-
-#include "test_util.h"
-#include "kvm_util.h"
-#include "processor.h"
-
-#define VCPU_ID 0
-
-/* CPUIDs known to differ */
-struct {
-	u32 function;
-	u32 index;
-} mangled_cpuids[] = {
-	/*
-	 * These entries depend on the vCPU's XCR0 register and IA32_XSS MSR,
-	 * which are not controlled for by this test.
-	 */
-	{.function = 0xd, .index = 0},
-	{.function = 0xd, .index = 1},
-};
-
-static void test_guest_cpuids(struct kvm_cpuid2 *guest_cpuid)
-{
-	int i;
-	u32 eax, ebx, ecx, edx;
-
-	for (i = 0; i < guest_cpuid->nent; i++) {
-		eax = guest_cpuid->entries[i].function;
-		ecx = guest_cpuid->entries[i].index;
-
-		cpuid(&eax, &ebx, &ecx, &edx);
-
-		GUEST_ASSERT(eax == guest_cpuid->entries[i].eax &&
-			     ebx == guest_cpuid->entries[i].ebx &&
-			     ecx == guest_cpuid->entries[i].ecx &&
-			     edx == guest_cpuid->entries[i].edx);
-	}
-
-}
-
-static void test_cpuid_40000000(struct kvm_cpuid2 *guest_cpuid)
-{
-	u32 eax = 0x40000000, ebx, ecx = 0, edx;
-
-	cpuid(&eax, &ebx, &ecx, &edx);
-
-	GUEST_ASSERT(eax == 0x40000001);
-}
-
-static void guest_main(struct kvm_cpuid2 *guest_cpuid)
-{
-	GUEST_SYNC(1);
-
-	test_guest_cpuids(guest_cpuid);
-
-	GUEST_SYNC(2);
-
-	test_cpuid_40000000(guest_cpuid);
-
-	GUEST_DONE();
-}
-
-static bool is_cpuid_mangled(struct kvm_cpuid_entry2 *entrie)
-{
-	int i;
-
-	for (i = 0; i < sizeof(mangled_cpuids); i++) {
-		if (mangled_cpuids[i].function == entrie->function &&
-		    mangled_cpuids[i].index == entrie->index)
-			return true;
-	}
-
-	return false;
-}
-
-static void check_cpuid(struct kvm_cpuid2 *cpuid, struct kvm_cpuid_entry2 *entrie)
-{
-	int i;
-
-	for (i = 0; i < cpuid->nent; i++) {
-		if (cpuid->entries[i].function == entrie->function &&
-		    cpuid->entries[i].index == entrie->index) {
-			if (is_cpuid_mangled(entrie))
-				return;
-
-			TEST_ASSERT(cpuid->entries[i].eax == entrie->eax &&
-				    cpuid->entries[i].ebx == entrie->ebx &&
-				    cpuid->entries[i].ecx == entrie->ecx &&
-				    cpuid->entries[i].edx == entrie->edx,
-				    "CPUID 0x%x.%x differ: 0x%x:0x%x:0x%x:0x%x vs 0x%x:0x%x:0x%x:0x%x",
-				    entrie->function, entrie->index,
-				    cpuid->entries[i].eax, cpuid->entries[i].ebx,
-				    cpuid->entries[i].ecx, cpuid->entries[i].edx,
-				    entrie->eax, entrie->ebx, entrie->ecx, entrie->edx);
-			return;
-		}
-	}
-
-	TEST_ASSERT(false, "CPUID 0x%x.%x not found", entrie->function, entrie->index);
-}
-
-static void compare_cpuids(struct kvm_cpuid2 *cpuid1, struct kvm_cpuid2 *cpuid2)
-{
-	int i;
-
-	for (i = 0; i < cpuid1->nent; i++)
-		check_cpuid(cpuid2, &cpuid1->entries[i]);
-
-	for (i = 0; i < cpuid2->nent; i++)
-		check_cpuid(cpuid1, &cpuid2->entries[i]);
-}
-
-static void run_vcpu(struct kvm_vm *vm, uint32_t vcpuid, int stage)
-{
-	struct ucall uc;
-
-	_vcpu_run(vm, vcpuid);
-
-	switch (get_ucall(vm, vcpuid, &uc)) {
-	case UCALL_SYNC:
-		TEST_ASSERT(!strcmp((const char *)uc.args[0], "hello") &&
-			    uc.args[1] == stage + 1,
-			    "Stage %d: Unexpected register values vmexit, got %lx",
-			    stage + 1, (ulong)uc.args[1]);
-		return;
-	case UCALL_DONE:
-		return;
-	case UCALL_ABORT:
-		TEST_ASSERT(false, "%s at %s:%ld\n\tvalues: %#lx, %#lx", (const char *)uc.args[0],
-			    __FILE__, uc.args[1], uc.args[2], uc.args[3]);
-	default:
-		TEST_ASSERT(false, "Unexpected exit: %s",
-			    exit_reason_str(vcpu_state(vm, vcpuid)->exit_reason));
-	}
-}
-
-struct kvm_cpuid2 *vcpu_alloc_cpuid(struct kvm_vm *vm, vm_vaddr_t *p_gva, struct kvm_cpuid2 *cpuid)
-{
-	int size = sizeof(*cpuid) + cpuid->nent * sizeof(cpuid->entries[0]);
-	vm_vaddr_t gva = vm_vaddr_alloc(vm, size, KVM_UTIL_MIN_VADDR);
-	struct kvm_cpuid2 *guest_cpuids = addr_gva2hva(vm, gva);
-
-	memcpy(guest_cpuids, cpuid, size);
-
-	*p_gva = gva;
-	return guest_cpuids;
-}
-
-int main(void)
-{
-	struct kvm_cpuid2 *supp_cpuid, *cpuid2;
-	vm_vaddr_t cpuid_gva;
-	struct kvm_vm *vm;
-	int stage;
-
-	vm = vm_create_default(VCPU_ID, 0, guest_main);
-
-	supp_cpuid = kvm_get_supported_cpuid();
-	cpuid2 = vcpu_get_cpuid(vm, VCPU_ID);
-
-	compare_cpuids(supp_cpuid, cpuid2);
-
-	vcpu_alloc_cpuid(vm, &cpuid_gva, cpuid2);
-
-	vcpu_args_set(vm, VCPU_ID, 1, cpuid_gva);
-
-	for (stage = 0; stage < 3; stage++)
-		run_vcpu(vm, VCPU_ID, stage);
-
-	kvm_vm_free(vm);
-}


