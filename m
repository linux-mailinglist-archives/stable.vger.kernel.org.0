Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42B70450E10
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240566AbhKOSKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:10:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:46100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239854AbhKOSEz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:04:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F8F5632EC;
        Mon, 15 Nov 2021 17:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997989;
        bh=BvlYVHrUYQXTquSRd/uRvMyPPNfhn8iFGtq6hN0ybuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HC1lhuKNCyTehAk8LBkbUGAjj9ozkXmurpOeNeLSiutztk/39JMCW5udFbVOPwKwG
         jpz43YmW8qHhaxLDP+YZf1eDO8sDXulHgyeVrcwvWQZ+3/p0dluQzz01j6RC/XFD/M
         3wZqdvkPuN9/No/EuqI4y/ufnBL5QGkjZEmRNxss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 347/575] KVM: selftests: Add operand to vmsave/vmload/vmrun in svm.c
Date:   Mon, 15 Nov 2021 18:01:12 +0100
Message-Id: <20211115165355.798466375@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Koller <ricarkol@google.com>

[ Upstream commit 47bc726fe8d1910872dc3d7e7ec70f8b9e6043b7 ]

Building the KVM selftests with LLVM's integrated assembler fails with:

  $ CFLAGS=-fintegrated-as make -C tools/testing/selftests/kvm CC=clang
  lib/x86_64/svm.c:77:16: error: too few operands for instruction
          asm volatile ("vmsave\n\t" : : "a" (vmcb_gpa) : "memory");
                        ^
  <inline asm>:1:2: note: instantiated into assembly here
          vmsave
          ^
  lib/x86_64/svm.c:134:3: error: too few operands for instruction
                  "vmload\n\t"
                  ^
  <inline asm>:1:2: note: instantiated into assembly here
          vmload
          ^
This is because LLVM IAS does not currently support calling vmsave,
vmload, or vmload without an explicit %rax operand.

Add an explicit operand to vmsave, vmload, and vmrum in svm.c. Fixing
this was suggested by Sean Christopherson.

Tested: building without this error in clang 11. The following patch
(not queued yet) needs to be applied to solve the other remaining error:
"selftests: kvm: remove reassignment of non-absolute variables".

Suggested-by: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/kvm/X+Df2oQczVBmwEzi@google.com/
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
Message-Id: <20210210031719.769837-1-ricarkol@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/lib/x86_64/svm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/svm.c b/tools/testing/selftests/kvm/lib/x86_64/svm.c
index 3a5c72ed2b792..827fe6028dd42 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/svm.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/svm.c
@@ -74,7 +74,7 @@ void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_r
 	wrmsr(MSR_VM_HSAVE_PA, svm->save_area_gpa);
 
 	memset(vmcb, 0, sizeof(*vmcb));
-	asm volatile ("vmsave\n\t" : : "a" (vmcb_gpa) : "memory");
+	asm volatile ("vmsave %0\n\t" : : "a" (vmcb_gpa) : "memory");
 	vmcb_set_seg(&save->es, get_es(), 0, -1U, data_seg_attr);
 	vmcb_set_seg(&save->cs, get_cs(), 0, -1U, code_seg_attr);
 	vmcb_set_seg(&save->ss, get_ss(), 0, -1U, data_seg_attr);
@@ -131,19 +131,19 @@ void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_r
 void run_guest(struct vmcb *vmcb, uint64_t vmcb_gpa)
 {
 	asm volatile (
-		"vmload\n\t"
+		"vmload %[vmcb_gpa]\n\t"
 		"mov rflags, %%r15\n\t"	// rflags
 		"mov %%r15, 0x170(%[vmcb])\n\t"
 		"mov guest_regs, %%r15\n\t"	// rax
 		"mov %%r15, 0x1f8(%[vmcb])\n\t"
 		LOAD_GPR_C
-		"vmrun\n\t"
+		"vmrun %[vmcb_gpa]\n\t"
 		SAVE_GPR_C
 		"mov 0x170(%[vmcb]), %%r15\n\t"	// rflags
 		"mov %%r15, rflags\n\t"
 		"mov 0x1f8(%[vmcb]), %%r15\n\t"	// rax
 		"mov %%r15, guest_regs\n\t"
-		"vmsave\n\t"
+		"vmsave %[vmcb_gpa]\n\t"
 		: : [vmcb] "r" (vmcb), [vmcb_gpa] "a" (vmcb_gpa)
 		: "r15", "memory");
 }
-- 
2.33.0



