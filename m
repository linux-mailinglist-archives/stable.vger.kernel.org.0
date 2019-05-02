Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6534311DAB
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbfEBPcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:32:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:51888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728705AbfEBPcU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:32:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2768E20675;
        Thu,  2 May 2019 15:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556811139;
        bh=TVoHAgqcEJ94Co5Z20LLuN59dMPXT+3TfJ6ArdGWSIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KFcTPjwy8BUi0GR2vgwEyNdBRoXl6U4Hxd+9L1jDoaY5pMFqAOVxAD+xEjp5xyXgP
         ARWV1Ae9Em5sI/3dRbrtNYcC8WCEcgFOpjgGj8/DN7Gitp4YStG/13Ewum5WNiwP0G
         bhRMR4nzWEGEGkf+XdqFrZbo+5RBEB98zY/ej1+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 089/101] KVM: selftests: complete IO before migrating guest state
Date:   Thu,  2 May 2019 17:21:31 +0200
Message-Id: <20190502143345.814312829@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 0f73bbc851ed32d22bbd86be09e0365c460bcd2e ]

Documentation/virtual/kvm/api.txt states:

  NOTE: For KVM_EXIT_IO, KVM_EXIT_MMIO, KVM_EXIT_OSI, KVM_EXIT_PAPR and
        KVM_EXIT_EPR the corresponding operations are complete (and guest
        state is consistent) only after userspace has re-entered the
        kernel with KVM_RUN.  The kernel side will first finish incomplete
        operations and then check for pending signals.  Userspace can
        re-enter the guest with an unmasked signal pending to complete
        pending operations.

Because guest state may be inconsistent, starting state migration after
an IO exit without first completing IO may result in test failures, e.g.
a proposed change to KVM's handling of %rip in its fast PIO handling[1]
will cause the new VM, i.e. the post-migration VM, to have its %rip set
to the IN instruction that triggered KVM_EXIT_IO, leading to a test
assertion due to a stage mismatch.

For simplicitly, require KVM_CAP_IMMEDIATE_EXIT to complete IO and skip
the test if it's not available.  The addition of KVM_CAP_IMMEDIATE_EXIT
predates the state selftest by more than a year.

[1] https://patchwork.kernel.org/patch/10848545/

Fixes: fa3899add1056 ("kvm: selftests: add basic test for state save and restore")
Reported-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 tools/testing/selftests/kvm/include/kvm_util.h |  1 +
 tools/testing/selftests/kvm/lib/kvm_util.c     | 16 ++++++++++++++++
 .../testing/selftests/kvm/x86_64/state_test.c  | 18 ++++++++++++++++--
 3 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index a84785b02557..07b71ad9734a 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -102,6 +102,7 @@ vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva);
 struct kvm_run *vcpu_state(struct kvm_vm *vm, uint32_t vcpuid);
 void vcpu_run(struct kvm_vm *vm, uint32_t vcpuid);
 int _vcpu_run(struct kvm_vm *vm, uint32_t vcpuid);
+void vcpu_run_complete_io(struct kvm_vm *vm, uint32_t vcpuid);
 void vcpu_set_mp_state(struct kvm_vm *vm, uint32_t vcpuid,
 		       struct kvm_mp_state *mp_state);
 void vcpu_regs_get(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_regs *regs);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index b52cfdefecbf..efa0aad8b3c6 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1121,6 +1121,22 @@ int _vcpu_run(struct kvm_vm *vm, uint32_t vcpuid)
 	return rc;
 }
 
+void vcpu_run_complete_io(struct kvm_vm *vm, uint32_t vcpuid)
+{
+	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
+	int ret;
+
+	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
+
+	vcpu->state->immediate_exit = 1;
+	ret = ioctl(vcpu->fd, KVM_RUN, NULL);
+	vcpu->state->immediate_exit = 0;
+
+	TEST_ASSERT(ret == -1 && errno == EINTR,
+		    "KVM_RUN IOCTL didn't exit immediately, rc: %i, errno: %i",
+		    ret, errno);
+}
+
 /*
  * VM VCPU Set MP State
  *
diff --git a/tools/testing/selftests/kvm/x86_64/state_test.c b/tools/testing/selftests/kvm/x86_64/state_test.c
index 4b3f556265f1..30f75856cf39 100644
--- a/tools/testing/selftests/kvm/x86_64/state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/state_test.c
@@ -134,6 +134,11 @@ int main(int argc, char *argv[])
 
 	struct kvm_cpuid_entry2 *entry = kvm_get_supported_cpuid_entry(1);
 
+	if (!kvm_check_cap(KVM_CAP_IMMEDIATE_EXIT)) {
+		fprintf(stderr, "immediate_exit not available, skipping test\n");
+		exit(KSFT_SKIP);
+	}
+
 	/* Create VM */
 	vm = vm_create_default(VCPU_ID, 0, guest_code);
 	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
@@ -156,8 +161,6 @@ int main(int argc, char *argv[])
 			    stage, run->exit_reason,
 			    exit_reason_str(run->exit_reason));
 
-		memset(&regs1, 0, sizeof(regs1));
-		vcpu_regs_get(vm, VCPU_ID, &regs1);
 		switch (get_ucall(vm, VCPU_ID, &uc)) {
 		case UCALL_ABORT:
 			TEST_ASSERT(false, "%s at %s:%d", (const char *)uc.args[0],
@@ -176,6 +179,17 @@ int main(int argc, char *argv[])
 			    uc.args[1] == stage, "Unexpected register values vmexit #%lx, got %lx",
 			    stage, (ulong)uc.args[1]);
 
+		/*
+		 * When KVM exits to userspace with KVM_EXIT_IO, KVM guarantees
+		 * guest state is consistent only after userspace re-enters the
+		 * kernel with KVM_RUN.  Complete IO prior to migrating state
+		 * to a new VM.
+		 */
+		vcpu_run_complete_io(vm, VCPU_ID);
+
+		memset(&regs1, 0, sizeof(regs1));
+		vcpu_regs_get(vm, VCPU_ID, &regs1);
+
 		state = vcpu_save_state(vm, VCPU_ID);
 		kvm_vm_release(vm);
 
-- 
2.19.1



