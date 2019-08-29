Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4DF7A25C0
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 20:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728851AbfH2SOc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 14:14:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728836AbfH2SOb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 14:14:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 766CE2339E;
        Thu, 29 Aug 2019 18:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102470;
        bh=bJlc/+TfIgbgjjmyWhzlBUWdW2bkR1oySzbllaFjg+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ExstUR2N4UeW5Im0znp1kKz6YpCnKI3yNM+AnQ085ujM+IO87E0Bisf4B6x09hQZ/
         wXms6Pk/W25mo1vBB/3xPJGRpnefsp9Cauz0bP+oFMfBWXWH1u7XiXQuxY7ZKRCSM/
         nNPEoltKw2cXnToRXp1+OcgU1tm7qBa+ugE1ITC0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 34/76] selftests: kvm: fix vmx_set_nested_state_test
Date:   Thu, 29 Aug 2019 14:12:29 -0400
Message-Id: <20190829181311.7562-34-sashal@kernel.org>
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

[ Upstream commit c930e19790bbbff31c018009907c813fa0925f63 ]

vmx_set_nested_state_test is trying to use the KVM_STATE_NESTED_EVMCS without
enabling enlightened VMCS first.  Correct the outcome of the test, and actually
test that it succeeds after the capability is enabled.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../kvm/x86_64/vmx_set_nested_state_test.c      | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
index a99fc66dafeb6..853e370e8a394 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
@@ -25,6 +25,8 @@
 #define VMCS12_REVISION 0x11e57ed0
 #define VCPU_ID 5
 
+bool have_evmcs;
+
 void test_nested_state(struct kvm_vm *vm, struct kvm_nested_state *state)
 {
 	vcpu_nested_state_set(vm, VCPU_ID, state, false);
@@ -75,8 +77,9 @@ void set_default_vmx_state(struct kvm_nested_state *state, int size)
 {
 	memset(state, 0, size);
 	state->flags = KVM_STATE_NESTED_GUEST_MODE  |
-			KVM_STATE_NESTED_RUN_PENDING |
-			KVM_STATE_NESTED_EVMCS;
+			KVM_STATE_NESTED_RUN_PENDING;
+	if (have_evmcs)
+		state->flags |= KVM_STATE_NESTED_EVMCS;
 	state->format = 0;
 	state->size = size;
 	state->hdr.vmx.vmxon_pa = 0x1000;
@@ -126,13 +129,19 @@ void test_vmx_nested_state(struct kvm_vm *vm)
 	/*
 	 * Setting vmxon_pa == -1ull and vmcs_pa == -1ull exits early without
 	 * setting the nested state but flags other than eVMCS must be clear.
+	 * The eVMCS flag can be set if the enlightened VMCS capability has
+	 * been enabled.
 	 */
 	set_default_vmx_state(state, state_sz);
 	state->hdr.vmx.vmxon_pa = -1ull;
 	state->hdr.vmx.vmcs12_pa = -1ull;
 	test_nested_state_expect_einval(vm, state);
 
-	state->flags = KVM_STATE_NESTED_EVMCS;
+	state->flags &= KVM_STATE_NESTED_EVMCS;
+	if (have_evmcs) {
+		test_nested_state_expect_einval(vm, state);
+		vcpu_enable_evmcs(vm, VCPU_ID);
+	}
 	test_nested_state(vm, state);
 
 	/* It is invalid to have vmxon_pa == -1ull and SMM flags non-zero. */
@@ -217,6 +226,8 @@ int main(int argc, char *argv[])
 	struct kvm_nested_state state;
 	struct kvm_cpuid_entry2 *entry = kvm_get_supported_cpuid_entry(1);
 
+	have_evmcs = kvm_check_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS);
+
 	if (!kvm_check_cap(KVM_CAP_NESTED_STATE)) {
 		printf("KVM_CAP_NESTED_STATE not available, skipping test\n");
 		exit(KSFT_SKIP);
-- 
2.20.1

