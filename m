Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5672A2505
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 20:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729297AbfH2SP3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 14:15:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:57182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729280AbfH2SP1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 14:15:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04E8323403;
        Thu, 29 Aug 2019 18:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102526;
        bh=xhiJezHpjdSXTTeSHRbLmmELwKti5nXh3MfmoKvhZEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qSE8kO3oXJkV+YykhS3BvrKzN/zpk857a6rL8L68iD3s+k8T3bFeazVF8krL4Vcet
         xdDSTZCsKG+xOaqyyw+E5UkEgmyZqshoRiN8beRFHoic0CQY0P05fukNClBQwwHv0M
         h5EU+tJbqhGQVQUEwj0r1YqDy5SQkr9Rw39ylA2U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 64/76] selftests/kvm: make platform_info_test pass on AMD
Date:   Thu, 29 Aug 2019 14:12:59 -0400
Message-Id: <20190829181311.7562-64-sashal@kernel.org>
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
 tools/testing/selftests/kvm/x86_64/platform_info_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/platform_info_test.c b/tools/testing/selftests/kvm/x86_64/platform_info_test.c
index 40050e44ec0ac..f9334bd3cce9f 100644
--- a/tools/testing/selftests/kvm/x86_64/platform_info_test.c
+++ b/tools/testing/selftests/kvm/x86_64/platform_info_test.c
@@ -99,8 +99,8 @@ int main(int argc, char *argv[])
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

