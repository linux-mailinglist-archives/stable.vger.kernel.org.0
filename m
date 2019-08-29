Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74AC5A247E
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 20:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729861AbfH2SQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 14:16:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729849AbfH2SQq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 14:16:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C82C233FF;
        Thu, 29 Aug 2019 18:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102605;
        bh=CKyadd5oos7cAu41Ww1xXGPEYoofd2Y6aSlkbogwEdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oYQ4dk5eT05jxY6+s7EM38VCbSC4aFkaMazh5GrR1hPXRVRTfNsdJ7eD9z7oHDqFF
         1eHcivQwrNqKv6pV3EBnPPrriOELy9rscZdi5A2B6gYihxjn7hCTXKTHcbWDZ0gV04
         nufM7pQYv+CUEweJcuBwC7QTXBq+tcbRUVM3Hz9g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 39/45] selftests/kvm: make platform_info_test pass on AMD
Date:   Thu, 29 Aug 2019 14:15:39 -0400
Message-Id: <20190829181547.8280-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181547.8280-1-sashal@kernel.org>
References: <20190829181547.8280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit e4427372398c31f57450565de277f861a4db5b3b ]

test_msr_platform_info_disabled() generates EXIT_SHUTDOWN but VMCB state
is undefined after that so an attempt to launch this guest again from
test_msr_platform_info_enabled() fails. Reorder the tests to make test
pass.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/platform_info_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/platform_info_test.c b/tools/testing/selftests/kvm/platform_info_test.c
index 3764e71212650..65db510dddc34 100644
--- a/tools/testing/selftests/kvm/platform_info_test.c
+++ b/tools/testing/selftests/kvm/platform_info_test.c
@@ -100,8 +100,8 @@ int main(int argc, char *argv[])
 	msr_platform_info = vcpu_get_msr(vm, VCPU_ID, MSR_PLATFORM_INFO);
 	vcpu_set_msr(vm, VCPU_ID, MSR_PLATFORM_INFO,
 		msr_platform_info | MSR_PLATFORM_INFO_MAX_TURBO_RATIO);
-	test_msr_platform_info_disabled(vm);
 	test_msr_platform_info_enabled(vm);
+	test_msr_platform_info_disabled(vm);
 	vcpu_set_msr(vm, VCPU_ID, MSR_PLATFORM_INFO, msr_platform_info);
 
 	kvm_vm_free(vm);
-- 
2.20.1

