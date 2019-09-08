Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE04ACD97
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732536AbfIHMvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:51:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732530AbfIHMvR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:51:17 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 417D2218AC;
        Sun,  8 Sep 2019 12:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567947076;
        bh=qiMYYrfTPi075togGcZvOW8cKQL36BR/ZK0ZrlNGj24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A7OOM72bpwltCJef6EEBxtpWO5t4FW1u7S6rNbF3EmX4va1pdIUjc/ujBeNjUViGR
         oCFkWeXvYEMwrgPZ9Ehy3st2TQnMkk/1FTnKZLhrxZbKD1QSD1MC831o+/iZvjfzcp
         gtBSc8ehrtyXaX0+3Rj1tzOJvzCc6sUENpvbI6gg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 50/94] selftests: kvm: fix vmx_set_nested_state_test
Date:   Sun,  8 Sep 2019 13:41:46 +0100
Message-Id: <20190908121151.871633476@linuxfoundation.org>
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



