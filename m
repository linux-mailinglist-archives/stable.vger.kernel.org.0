Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB80A20624
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 13:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbfEPLrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 07:47:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:48516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727674AbfEPLkU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 07:40:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DEF621473;
        Thu, 16 May 2019 11:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558006819;
        bh=XHv33oDvCTQ41+E7zo+bGDI+pR7RThafNLojm+xkSyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aPCGCffawrqjul51YR3WXX1t57ZUM/sLgSo9TlK9JOjqXNSReKlE0HY2ZL5K8Jsch
         40ncIhwSxQkPvRrdQpUCixnpFLtXM8RGuj0p0xMUh1NntqsMOe4fb44yg2x6Ue+4X0
         wBrqTygT8owgKU/s4AK2VljcIuQAvDOfHunrbl7U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 29/34] KVM: selftests: make hyperv_cpuid test pass on AMD
Date:   Thu, 16 May 2019 07:39:26 -0400
Message-Id: <20190516113932.8348-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190516113932.8348-1-sashal@kernel.org>
References: <20190516113932.8348-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit eba3afde1cea7dbd7881683232f2a85e2ed86bfe ]

Enlightened VMCS is only supported on Intel CPUs but the test shouldn't
fail completely.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
index 264425f75806b..9a21e912097c4 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
@@ -141,7 +141,13 @@ int main(int argc, char *argv[])
 
 	free(hv_cpuid_entries);
 
-	vcpu_ioctl(vm, VCPU_ID, KVM_ENABLE_CAP, &enable_evmcs_cap);
+	rv = _vcpu_ioctl(vm, VCPU_ID, KVM_ENABLE_CAP, &enable_evmcs_cap);
+
+	if (rv) {
+		fprintf(stderr,
+			"Enlightened VMCS is unsupported, skip related test\n");
+		goto vm_free;
+	}
 
 	hv_cpuid_entries = kvm_get_supported_hv_cpuid(vm);
 	if (!hv_cpuid_entries)
@@ -151,6 +157,7 @@ int main(int argc, char *argv[])
 
 	free(hv_cpuid_entries);
 
+vm_free:
 	kvm_vm_free(vm);
 
 	return 0;
-- 
2.20.1

