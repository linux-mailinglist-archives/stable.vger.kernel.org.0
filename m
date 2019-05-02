Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75F3C11DA3
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbfEBPcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:32:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:51680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728320AbfEBPcK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:32:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C296620C01;
        Thu,  2 May 2019 15:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556811129;
        bh=g12iT4gdSLDmpyEcT8+qkZptIkafLkOcusTzNzd0og8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PtEHHwB/QVo9pMFPnedMQZx1heo+BYj8oTZGws9nlYVcKR1CPvmWwXJLE7oTaGtmK
         WRgBLLcbqRNkal47eCV+cjAKdFUtb+P5TuO5vsFlIRg0jglrMOgTyssp8ZnAy+DZQg
         TZnExlidBo60+Cjb2ZUg0PPBUwDq1bC/LNHd7OHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Huang <wei@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 086/101] KVM: selftests: assert on exit reason in CR4/cpuid sync test
Date:   Thu,  2 May 2019 17:21:28 +0200
Message-Id: <20190502143345.623099440@linuxfoundation.org>
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

[ Upstream commit 8df98ae0ab2ead9a02228756eec26f8d7b17f499 ]

...so that the test doesn't end up in an infinite loop if it fails for
whatever reason, e.g. SHUTDOWN due to gcc inserting stack canary code
into ucall() and attempting to derefence a null segment.

Fixes: ca359066889f7 ("kvm: selftests: add cr4_cpuid_sync_test")
Cc: Wei Huang <wei@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 .../kvm/x86_64/cr4_cpuid_sync_test.c          | 35 ++++++++++---------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c b/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
index d503a51fad30..7c2c4d4055a8 100644
--- a/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
@@ -87,22 +87,25 @@ int main(int argc, char *argv[])
 	while (1) {
 		rc = _vcpu_run(vm, VCPU_ID);
 
-		if (run->exit_reason == KVM_EXIT_IO) {
-			switch (get_ucall(vm, VCPU_ID, &uc)) {
-			case UCALL_SYNC:
-				/* emulate hypervisor clearing CR4.OSXSAVE */
-				vcpu_sregs_get(vm, VCPU_ID, &sregs);
-				sregs.cr4 &= ~X86_CR4_OSXSAVE;
-				vcpu_sregs_set(vm, VCPU_ID, &sregs);
-				break;
-			case UCALL_ABORT:
-				TEST_ASSERT(false, "Guest CR4 bit (OSXSAVE) unsynchronized with CPUID bit.");
-				break;
-			case UCALL_DONE:
-				goto done;
-			default:
-				TEST_ASSERT(false, "Unknown ucall 0x%x.", uc.cmd);
-			}
+		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+			    "Unexpected exit reason: %u (%s),\n",
+			    run->exit_reason,
+			    exit_reason_str(run->exit_reason));
+
+		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		case UCALL_SYNC:
+			/* emulate hypervisor clearing CR4.OSXSAVE */
+			vcpu_sregs_get(vm, VCPU_ID, &sregs);
+			sregs.cr4 &= ~X86_CR4_OSXSAVE;
+			vcpu_sregs_set(vm, VCPU_ID, &sregs);
+			break;
+		case UCALL_ABORT:
+			TEST_ASSERT(false, "Guest CR4 bit (OSXSAVE) unsynchronized with CPUID bit.");
+			break;
+		case UCALL_DONE:
+			goto done;
+		default:
+			TEST_ASSERT(false, "Unknown ucall 0x%x.", uc.cmd);
 		}
 	}
 
-- 
2.19.1



