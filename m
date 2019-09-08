Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDEEDACE1D
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732511AbfIHMvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:51:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732490AbfIHMvM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:51:12 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FCE8218AF;
        Sun,  8 Sep 2019 12:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567947071;
        bh=a4D6nv6ufKNPfOmERythkXGnps4qhqRayQhCLJMesIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xeNCokZY2gDW8WkiGGRr03V7FpmHAAnMdIAjSoBaGcTPbPuURYXJQBqOQwHZy2o42
         HGyUQoBvoVGb3JzUebGlJWIjmEJCZfE1fw1fqlUETtivhyI5JdgqeOZ4jMtxuYkExR
         f2E3HnxHnsw7ScKauRp9U8orlMluWzbtuc+GrY+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 48/94] selftests: kvm: do not try running the VM in vmx_set_nested_state_test
Date:   Sun,  8 Sep 2019 13:41:44 +0100
Message-Id: <20190908121151.813950180@linuxfoundation.org>
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

[ Upstream commit 92cd0f0be3d7adb63611c28693ec0399beded837 ]

This test is only covering various edge cases of the
KVM_SET_NESTED_STATE ioctl.  Running the VM does not really
add anything.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../kvm/x86_64/vmx_set_nested_state_test.c        | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
index ed7218d166da6..a99fc66dafeb6 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
@@ -27,22 +27,13 @@
 
 void test_nested_state(struct kvm_vm *vm, struct kvm_nested_state *state)
 {
-	volatile struct kvm_run *run;
-
 	vcpu_nested_state_set(vm, VCPU_ID, state, false);
-	run = vcpu_state(vm, VCPU_ID);
-	vcpu_run(vm, VCPU_ID);
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_SHUTDOWN,
-		"Got exit_reason other than KVM_EXIT_SHUTDOWN: %u (%s),\n",
-		run->exit_reason,
-		exit_reason_str(run->exit_reason));
 }
 
 void test_nested_state_expect_errno(struct kvm_vm *vm,
 				    struct kvm_nested_state *state,
 				    int expected_errno)
 {
-	volatile struct kvm_run *run;
 	int rv;
 
 	rv = vcpu_nested_state_set(vm, VCPU_ID, state, true);
@@ -50,12 +41,6 @@ void test_nested_state_expect_errno(struct kvm_vm *vm,
 		"Expected %s (%d) from vcpu_nested_state_set but got rv: %i errno: %s (%d)",
 		strerror(expected_errno), expected_errno, rv, strerror(errno),
 		errno);
-	run = vcpu_state(vm, VCPU_ID);
-	vcpu_run(vm, VCPU_ID);
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_SHUTDOWN,
-		"Got exit_reason other than KVM_EXIT_SHUTDOWN: %u (%s),\n",
-		run->exit_reason,
-		exit_reason_str(run->exit_reason));
 }
 
 void test_nested_state_expect_einval(struct kvm_vm *vm,
-- 
2.20.1



