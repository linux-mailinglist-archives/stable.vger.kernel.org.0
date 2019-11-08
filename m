Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E394F5633
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391436AbfKHTHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:07:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:38062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391433AbfKHTHW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:07:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C89A2196F;
        Fri,  8 Nov 2019 19:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240041;
        bh=U6mQTsy5KRGATuoXfZpLNAFdrLh+vePMFSghfQV+rcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lILiIJ9SCe92q1npgz8CaNVbhXaW3KZG9wjojmurNiN1VjnUY6oZawquNOpEYnpZC
         7aX8SzqnFGv1CQ53GPCS/lqPRNkpIv4mBu2OLLus//Weh621rqYawg2bdfnUOtPp4/
         JlbAbN9n52C+hRVhdswWpiR3DPzpvR3a18pLv67o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 066/140] selftests: kvm: fix sync_regs_test with newer gccs
Date:   Fri,  8 Nov 2019 19:49:54 +0100
Message-Id: <20191108174909.367973493@linuxfoundation.org>
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

[ Upstream commit ef4059809890f732c69cc1726d3a9a108a832a2f ]

Commit 204c91eff798a ("KVM: selftests: do not blindly clobber registers in
 guest asm") was intended to make test more gcc-proof, however, the result
is exactly the opposite: on newer gccs (e.g. 8.2.1) the test breaks with

==== Test Assertion Failure ====
  x86_64/sync_regs_test.c:168: run->s.regs.regs.rbx == 0xBAD1DEA + 1
  pid=14170 tid=14170 - Invalid argument
     1	0x00000000004015b3: main at sync_regs_test.c:166 (discriminator 6)
     2	0x00007f413fb66412: ?? ??:0
     3	0x000000000040191d: _start at ??:?
  rbx sync regs value incorrect 0x1.

Apparently, compile is still free to play games with registers even
when they have variables attached.

Re-write guest code with 'asm volatile' by embedding ucall there and
making sure rbx is preserved.

Fixes: 204c91eff798a ("KVM: selftests: do not blindly clobber registers in guest asm")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/kvm/x86_64/sync_regs_test.c     | 21 ++++++++++---------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
index 11c2a70a7b87a..5c82242562943 100644
--- a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
@@ -22,18 +22,19 @@
 
 #define VCPU_ID 5
 
+#define UCALL_PIO_PORT ((uint16_t)0x1000)
+
+/*
+ * ucall is embedded here to protect against compiler reshuffling registers
+ * before calling a function. In this test we only need to get KVM_EXIT_IO
+ * vmexit and preserve RBX, no additional information is needed.
+ */
 void guest_code(void)
 {
-	/*
-	 * use a callee-save register, otherwise the compiler
-	 * saves it around the call to GUEST_SYNC.
-	 */
-	register u32 stage asm("rbx");
-	for (;;) {
-		GUEST_SYNC(0);
-		stage++;
-		asm volatile ("" : : "r" (stage));
-	}
+	asm volatile("1: in %[port], %%al\n"
+		     "add $0x1, %%rbx\n"
+		     "jmp 1b"
+		     : : [port] "d" (UCALL_PIO_PORT) : "rax", "rbx");
 }
 
 static void compare_regs(struct kvm_regs *left, struct kvm_regs *right)
-- 
2.20.1



