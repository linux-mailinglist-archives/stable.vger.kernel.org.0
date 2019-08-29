Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C782A25C7
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 20:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbfH2SO1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 14:14:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:56096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727867AbfH2SO1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 14:14:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C77632189D;
        Thu, 29 Aug 2019 18:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102465;
        bh=XthpPwotghu3IJEJAgMSp7dudSEot0I9LrgFHMcKiUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y7zw0o7M1U8dBLvtxu4Jl+Iw+RcydgfiuuQgFDjNi76HhCcYdFVr/wEkYLHnvHwuY
         U7R6uuGaCc37TIkKy5Z0ERYmnXQRS5Gj6MFSZQ2qAjkJKcCGQgr8/uYT4IQ8f74+7g
         QYh19MmV//OYUh7ZST+HZ+ljebbvVCi+t7cs4h9s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 33/76] selftests: kvm: provide common function to enable eVMCS
Date:   Thu, 29 Aug 2019 14:12:28 -0400
Message-Id: <20190829181311.7562-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181311.7562-1-sashal@kernel.org>
References: <20190829181311.7562-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit 65efa61dc0d536d5f0602c33ee805a57cc07e9dc ]

There are two tests already enabling eVMCS and a third is coming.
Add a function that enables the capability and tests the result.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/include/evmcs.h   |  2 ++
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  | 20 +++++++++++++++++++
 .../testing/selftests/kvm/x86_64/evmcs_test.c | 15 ++------------
 .../selftests/kvm/x86_64/hyperv_cpuid.c       | 12 ++++-------
 4 files changed, 28 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/evmcs.h b/tools/testing/selftests/kvm/include/evmcs.h
index 4059014d93ea1..4912d23844bc6 100644
--- a/tools/testing/selftests/kvm/include/evmcs.h
+++ b/tools/testing/selftests/kvm/include/evmcs.h
@@ -220,6 +220,8 @@ struct hv_enlightened_vmcs {
 struct hv_enlightened_vmcs *current_evmcs;
 struct hv_vp_assist_page *current_vp_assist;
 
+int vcpu_enable_evmcs(struct kvm_vm *vm, int vcpu_id);
+
 static inline int enable_vp_assist(uint64_t vp_assist_pa, void *vp_assist)
 {
 	u64 val = (vp_assist_pa & HV_X64_MSR_VP_ASSIST_PAGE_ADDRESS_MASK) |
diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index fe56d159d65fd..52b6491ed7061 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -14,6 +14,26 @@
 
 bool enable_evmcs;
 
+int vcpu_enable_evmcs(struct kvm_vm *vm, int vcpu_id)
+{
+	uint16_t evmcs_ver;
+
+	struct kvm_enable_cap enable_evmcs_cap = {
+		.cap = KVM_CAP_HYPERV_ENLIGHTENED_VMCS,
+		 .args[0] = (unsigned long)&evmcs_ver
+	};
+
+	vcpu_ioctl(vm, vcpu_id, KVM_ENABLE_CAP, &enable_evmcs_cap);
+
+	/* KVM should return supported EVMCS version range */
+	TEST_ASSERT(((evmcs_ver >> 8) >= (evmcs_ver & 0xff)) &&
+		    (evmcs_ver & 0xff) > 0,
+		    "Incorrect EVMCS version range: %x:%x\n",
+		    evmcs_ver & 0xff, evmcs_ver >> 8);
+
+	return evmcs_ver;
+}
+
 /* Allocate memory regions for nested VMX tests.
  *
  * Input Args:
diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
index 241919ef1eaca..9f250c39c9bb8 100644
--- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
@@ -79,11 +79,6 @@ int main(int argc, char *argv[])
 	struct kvm_x86_state *state;
 	struct ucall uc;
 	int stage;
-	uint16_t evmcs_ver;
-	struct kvm_enable_cap enable_evmcs_cap = {
-		.cap = KVM_CAP_HYPERV_ENLIGHTENED_VMCS,
-		 .args[0] = (unsigned long)&evmcs_ver
-	};
 
 	/* Create VM */
 	vm = vm_create_default(VCPU_ID, 0, guest_code);
@@ -96,13 +91,7 @@ int main(int argc, char *argv[])
 		exit(KSFT_SKIP);
 	}
 
-	vcpu_ioctl(vm, VCPU_ID, KVM_ENABLE_CAP, &enable_evmcs_cap);
-
-	/* KVM should return supported EVMCS version range */
-	TEST_ASSERT(((evmcs_ver >> 8) >= (evmcs_ver & 0xff)) &&
-		    (evmcs_ver & 0xff) > 0,
-		    "Incorrect EVMCS version range: %x:%x\n",
-		    evmcs_ver & 0xff, evmcs_ver >> 8);
+	vcpu_enable_evmcs(vm, VCPU_ID);
 
 	run = vcpu_state(vm, VCPU_ID);
 
@@ -146,7 +135,7 @@ int main(int argc, char *argv[])
 		kvm_vm_restart(vm, O_RDWR);
 		vm_vcpu_add(vm, VCPU_ID, 0, 0);
 		vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
-		vcpu_ioctl(vm, VCPU_ID, KVM_ENABLE_CAP, &enable_evmcs_cap);
+		vcpu_enable_evmcs(vm, VCPU_ID);
 		vcpu_load_state(vm, VCPU_ID, state);
 		run = vcpu_state(vm, VCPU_ID);
 		free(state);
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
index f72b3043db0eb..ee59831fbc984 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
@@ -18,6 +18,7 @@
 #include "test_util.h"
 #include "kvm_util.h"
 #include "processor.h"
+#include "vmx.h"
 
 #define VCPU_ID 0
 
@@ -106,12 +107,7 @@ int main(int argc, char *argv[])
 {
 	struct kvm_vm *vm;
 	int rv;
-	uint16_t evmcs_ver;
 	struct kvm_cpuid2 *hv_cpuid_entries;
-	struct kvm_enable_cap enable_evmcs_cap = {
-		.cap = KVM_CAP_HYPERV_ENLIGHTENED_VMCS,
-		 .args[0] = (unsigned long)&evmcs_ver
-	};
 
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
@@ -136,14 +132,14 @@ int main(int argc, char *argv[])
 
 	free(hv_cpuid_entries);
 
-	rv = _vcpu_ioctl(vm, VCPU_ID, KVM_ENABLE_CAP, &enable_evmcs_cap);
-
-	if (rv) {
+	if (!kvm_check_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS)) {
 		fprintf(stderr,
 			"Enlightened VMCS is unsupported, skip related test\n");
 		goto vm_free;
 	}
 
+	vcpu_enable_evmcs(vm, VCPU_ID);
+
 	hv_cpuid_entries = kvm_get_supported_hv_cpuid(vm);
 	if (!hv_cpuid_entries)
 		return 1;
-- 
2.20.1

