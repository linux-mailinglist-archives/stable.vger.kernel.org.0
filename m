Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 430AB27C621
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730295AbgI2LmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:42:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:38926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730664AbgI2Llz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:41:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB3E62065C;
        Tue, 29 Sep 2020 11:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379714;
        bh=d5F1MGfGLk6sCvzAZcrL+0rbDMayo1dF3lrg8wJ4ydA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W9KGn7qNy6Qfu1y5j72AuW5wV6KPtAoubs655mq6CXbWF7jrJEi2uemgMY/0c6LRG
         teetAkvXo9LWuJ1ViQN7GmIsl/2zl4RMoGeebuSgWAZ9P4wGL4j+e9Xze6bJyQrMFF
         UGwmCD9XikSeAYR9oKurN1JjEcEcCg+walwUN6hM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Peterson <everdox@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 256/388] KVM: x86: handle wrap around 32-bit address space
Date:   Tue, 29 Sep 2020 12:59:47 +0200
Message-Id: <20200929110022.866189703@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit fede8076aab4c2280c673492f8f7a2e87712e8b4 ]

KVM is not handling the case where EIP wraps around the 32-bit address
space (that is, outside long mode).  This is needed both in vmx.c
and in emulate.c.  SVM with NRIPS is okay, but it can still print
an error to dmesg due to integer overflow.

Reported-by: Nick Peterson <everdox@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/emulate.c |  2 ++
 arch/x86/kvm/svm.c     |  3 ---
 arch/x86/kvm/vmx/vmx.c | 15 ++++++++++++---
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 128d3ad46e965..cc7823e7ef96c 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -5836,6 +5836,8 @@ writeback:
 	}
 
 	ctxt->eip = ctxt->_eip;
+	if (ctxt->mode != X86EMUL_MODE_PROT64)
+		ctxt->eip = (u32)ctxt->_eip;
 
 done:
 	if (rc == X86EMUL_PROPAGATE_FAULT) {
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 3243a80ea32c0..802b5f9ab7446 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -787,9 +787,6 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
 		if (!kvm_emulate_instruction(vcpu, EMULTYPE_SKIP))
 			return 0;
 	} else {
-		if (svm->next_rip - kvm_rip_read(vcpu) > MAX_INST_SIZE)
-			pr_err("%s: ip 0x%lx next 0x%llx\n",
-			       __func__, kvm_rip_read(vcpu), svm->next_rip);
 		kvm_rip_write(vcpu, svm->next_rip);
 	}
 	svm_set_interrupt_shadow(vcpu, 0);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d4a364db27ee8..2a1ed3aae100e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1541,7 +1541,7 @@ static int vmx_rtit_ctl_check(struct kvm_vcpu *vcpu, u64 data)
 
 static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
 {
-	unsigned long rip;
+	unsigned long rip, orig_rip;
 
 	/*
 	 * Using VMCS.VM_EXIT_INSTRUCTION_LEN on EPT misconfig depends on
@@ -1553,8 +1553,17 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	 */
 	if (!static_cpu_has(X86_FEATURE_HYPERVISOR) ||
 	    to_vmx(vcpu)->exit_reason != EXIT_REASON_EPT_MISCONFIG) {
-		rip = kvm_rip_read(vcpu);
-		rip += vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
+		orig_rip = kvm_rip_read(vcpu);
+		rip = orig_rip + vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
+#ifdef CONFIG_X86_64
+		/*
+		 * We need to mask out the high 32 bits of RIP if not in 64-bit
+		 * mode, but just finding out that we are in 64-bit mode is
+		 * quite expensive.  Only do it if there was a carry.
+		 */
+		if (unlikely(((rip ^ orig_rip) >> 31) == 3) && !is_64_bit_mode(vcpu))
+			rip = (u32)rip;
+#endif
 		kvm_rip_write(vcpu, rip);
 	} else {
 		if (!kvm_emulate_instruction(vcpu, EMULTYPE_SKIP))
-- 
2.25.1



