Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5C1F5631
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387807AbfKHTHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:07:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:38006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391425AbfKHTHS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:07:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B26A82196F;
        Fri,  8 Nov 2019 19:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240038;
        bh=cJ6t2TafyczZEuNkVhNQTkIyWqNQmIOm7Mg0qAcJHPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NDcpwX1/OMflu4QwjK2r/vPvKeU2wZLAiSUJSqe42lJme5mNSReer6uzhiktKMEBN
         BXlq0BBr2BUxsRLLv7nBsd1fE8ruoQovWDsQZmMmVAsAl373tjakOIGaobRl2+3Sf+
         y6n1paAQ65zjlNIeIu9ycsdCwOebV5qdyFMGCtAI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 065/140] selftests: kvm: vmx_set_nested_state_test: dont check for VMX support twice
Date:   Fri,  8 Nov 2019 19:49:53 +0100
Message-Id: <20191108174909.315506364@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit 700c17d9cec8712f4091692488fb63e2680f7a5d ]

vmx_set_nested_state_test() checks if VMX is supported twice: in the very
beginning (and skips the whole test if it's not) and before doing
test_vmx_nested_state(). One should be enough.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/kvm/x86_64/vmx_set_nested_state_test.c       | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
index 853e370e8a394..a6d85614ae4d6 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
@@ -271,12 +271,7 @@ int main(int argc, char *argv[])
 	state.flags = KVM_STATE_NESTED_RUN_PENDING;
 	test_nested_state_expect_einval(vm, &state);
 
-	/*
-	 * TODO: When SVM support is added for KVM_SET_NESTED_STATE
-	 *       add tests here to support it like VMX.
-	 */
-	if (entry->ecx & CPUID_VMX)
-		test_vmx_nested_state(vm);
+	test_vmx_nested_state(vm);
 
 	kvm_vm_free(vm);
 	return 0;
-- 
2.20.1



