Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2899DACDB0
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733015AbfIHMwZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:52:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:44640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733013AbfIHMwY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:52:24 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA2042082C;
        Sun,  8 Sep 2019 12:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567947144;
        bh=2Y+6CDgrKEz6Cux0z2cDSXvMPHzCVWlx+iOsPn0mNl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CbhXJoIvDIWhKsOoUKteSIEe4W0LFeemdT2xJwlmPyr7CbtIlVj7qsQmqcYECVrGm
         2hmWtf85OueRcwIJkF9PYuZnTNaAfHOX3butvJPDjfrUy5ZLnS7r6zHYNCh8eKbuHq
         kNl1s9la6Y5qJVNI27rQiw+bwL453C0W+/u9jeQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 78/94] selftests/kvm: make platform_info_test pass on AMD
Date:   Sun,  8 Sep 2019 13:42:14 +0100
Message-Id: <20190908121152.669381097@linuxfoundation.org>
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



