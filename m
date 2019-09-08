Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A492CACE38
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbfIHMzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:55:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:42562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732507AbfIHMvP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:51:15 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A36BF20863;
        Sun,  8 Sep 2019 12:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567947074;
        bh=m/x0V6kE7E/90WMQ2msln4SAuZm1+BwYiGXmGrNHTQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o86nnPbgzuFh3fS53pMNtWAeiAKRWD09Ikmv9a3U2i2j4dDKccorMuD6EFHpV5SNs
         OxXcYcvnQ0e2ufnJ/tm4WdADC1DIiXJQnP+u3A1LS950rYh30gnrxTtVJ2e5I4PZ4T
         WDfM9E6BrYhz1cowFzUu02lSfFat9eVeBMx8p3kc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 49/94] selftests: kvm: provide common function to enable eVMCS
Date:   Sun,  8 Sep 2019 13:41:45 +0100
Message-Id: <20190908121151.841583971@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
References: <20190908121150.420989666@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



