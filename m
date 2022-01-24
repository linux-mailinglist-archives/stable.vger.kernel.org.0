Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC07499BBF
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379791AbiAXVyq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:54:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52686 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573520AbiAXVpF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:45:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0E54B811A9;
        Mon, 24 Jan 2022 21:45:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6216C340E4;
        Mon, 24 Jan 2022 21:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060702;
        bh=oA0SrxgSf2DHn1f9C5JzgLmAYlmqZ8cXWCLRmdb5jC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DZ2b1LZ6nOzTUqF7SoZ8nfn8dQg0gkRV/JK1FdrjtPN62WwJk6z9WtgLMtLiQeCYq
         tzftQnpVolJgZdtmW4jbExgs93q0DY7sywmyzj3hPoAO/yfIe4d3ap8FWouLlN3huT
         1z1xqHRBm29f1Y60VlxQqarnOf1o+mCReTAj7mdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.16 1035/1039] KVM: selftests: Test KVM_SET_CPUID2 after KVM_RUN
Date:   Mon, 24 Jan 2022 19:47:04 +0100
Message-Id: <20220124184200.082019564@linuxfoundation.org>
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

commit ecebb966acaab2466d9857d1cc435ee1fc9eee50 upstream.

KVM forbids KVM_SET_CPUID2 after KVM_RUN was performed on a vCPU unless
the supplied CPUID data is equal to what was previously set. Test this.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20220117150542.2176196-5-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h |    7 +++
 tools/testing/selftests/kvm/lib/x86_64/processor.c     |   33 ++++++++++++++---
 tools/testing/selftests/kvm/x86_64/cpuid_test.c        |   30 +++++++++++++++
 3 files changed, 66 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -358,6 +358,8 @@ uint64_t kvm_get_feature_msr(uint64_t ms
 struct kvm_cpuid2 *kvm_get_supported_cpuid(void);
 
 struct kvm_cpuid2 *vcpu_get_cpuid(struct kvm_vm *vm, uint32_t vcpuid);
+int __vcpu_set_cpuid(struct kvm_vm *vm, uint32_t vcpuid,
+		     struct kvm_cpuid2 *cpuid);
 void vcpu_set_cpuid(struct kvm_vm *vm, uint32_t vcpuid,
 		    struct kvm_cpuid2 *cpuid);
 
@@ -402,6 +404,11 @@ void vm_set_page_table_entry(struct kvm_
 			     uint64_t pte);
 
 /*
+ * get_cpuid() - find matching CPUID entry and return pointer to it.
+ */
+struct kvm_cpuid_entry2 *get_cpuid(struct kvm_cpuid2 *cpuid, uint32_t function,
+				   uint32_t index);
+/*
  * set_cpuid() - overwrites a matching cpuid entry with the provided value.
  *		 matches based on ent->function && ent->index. returns true
  *		 if a match was found and successfully overwritten.
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -847,6 +847,17 @@ kvm_get_supported_cpuid_index(uint32_t f
 	return entry;
 }
 
+
+int __vcpu_set_cpuid(struct kvm_vm *vm, uint32_t vcpuid,
+		     struct kvm_cpuid2 *cpuid)
+{
+	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
+
+	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
+
+	return ioctl(vcpu->fd, KVM_SET_CPUID2, cpuid);
+}
+
 /*
  * VM VCPU CPUID Set
  *
@@ -864,12 +875,9 @@ kvm_get_supported_cpuid_index(uint32_t f
 void vcpu_set_cpuid(struct kvm_vm *vm,
 		uint32_t vcpuid, struct kvm_cpuid2 *cpuid)
 {
-	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
 	int rc;
 
-	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
-
-	rc = ioctl(vcpu->fd, KVM_SET_CPUID2, cpuid);
+	rc = __vcpu_set_cpuid(vm, vcpuid, cpuid);
 	TEST_ASSERT(rc == 0, "KVM_SET_CPUID2 failed, rc: %i errno: %i",
 		    rc, errno);
 
@@ -1337,6 +1345,23 @@ void assert_on_unhandled_exception(struc
 	}
 }
 
+struct kvm_cpuid_entry2 *get_cpuid(struct kvm_cpuid2 *cpuid, uint32_t function,
+				   uint32_t index)
+{
+	int i;
+
+	for (i = 0; i < cpuid->nent; i++) {
+		struct kvm_cpuid_entry2 *cur = &cpuid->entries[i];
+
+		if (cur->function == function && cur->index == index)
+			return cur;
+	}
+
+	TEST_FAIL("CPUID function 0x%x index 0x%x not found ", function, index);
+
+	return NULL;
+}
+
 bool set_cpuid(struct kvm_cpuid2 *cpuid,
 	       struct kvm_cpuid_entry2 *ent)
 {
--- a/tools/testing/selftests/kvm/x86_64/cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
@@ -154,6 +154,34 @@ struct kvm_cpuid2 *vcpu_alloc_cpuid(stru
 	return guest_cpuids;
 }
 
+static void set_cpuid_after_run(struct kvm_vm *vm, struct kvm_cpuid2 *cpuid)
+{
+	struct kvm_cpuid_entry2 *ent;
+	int rc;
+	u32 eax, ebx, x;
+
+	/* Setting unmodified CPUID is allowed */
+	rc = __vcpu_set_cpuid(vm, VCPU_ID, cpuid);
+	TEST_ASSERT(!rc, "Setting unmodified CPUID after KVM_RUN failed: %d", rc);
+
+	/* Changing CPU features is forbidden */
+	ent = get_cpuid(cpuid, 0x7, 0);
+	ebx = ent->ebx;
+	ent->ebx--;
+	rc = __vcpu_set_cpuid(vm, VCPU_ID, cpuid);
+	TEST_ASSERT(rc, "Changing CPU features should fail");
+	ent->ebx = ebx;
+
+	/* Changing MAXPHYADDR is forbidden */
+	ent = get_cpuid(cpuid, 0x80000008, 0);
+	eax = ent->eax;
+	x = eax & 0xff;
+	ent->eax = (eax & ~0xffu) | (x - 1);
+	rc = __vcpu_set_cpuid(vm, VCPU_ID, cpuid);
+	TEST_ASSERT(rc, "Changing MAXPHYADDR should fail");
+	ent->eax = eax;
+}
+
 int main(void)
 {
 	struct kvm_cpuid2 *supp_cpuid, *cpuid2;
@@ -175,5 +203,7 @@ int main(void)
 	for (stage = 0; stage < 3; stage++)
 		run_vcpu(vm, VCPU_ID, stage);
 
+	set_cpuid_after_run(vm, cpuid2);
+
 	kvm_vm_free(vm);
 }


