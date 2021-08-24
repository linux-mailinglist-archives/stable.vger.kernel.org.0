Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB6A3F6674
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239877AbhHXRYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:24:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:58968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240512AbhHXRV7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:21:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5676F61B08;
        Tue, 24 Aug 2021 17:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824613;
        bh=HHn2ZRlyD2k9AG5oa2+hGdrofZOM0lN31Owpkucosqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G1hUcCJh277R7JIVjs7xoLq49+1YP5q5JzZIR8o6u9G2GbxTHQZZkqzIIsyMQXU+y
         3LZPush0TSzM5RE3GnKhdSOdKMSwZhiWw3aw5lNXW69GcFIEKn2QpilxZ3klxAacH8
         ZP3XjgGdOqcWD2yebJeWlM1li/asO2lplxMAx0/OjAQMVyp5hnAE37Puq+6/gtIyU+
         L4IYteSuqxrjF5EI0+76UFiX5OPImR2BeckmuF6YUlrzHj/FZV6WYmX7H7kL6zfoEx
         ecu/UwxIzWx84suRUgTKF77p1FNqOJhaLSz2c5gda1rDuHhIc/JTNhZR6eHUO5/kop
         UHqlOFOksBFgA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 43/84] KVM: nSVM: avoid picking up unsupported bits from L2 in int_ctl (CVE-2021-3653)
Date:   Tue, 24 Aug 2021 13:02:09 -0400
Message-Id: <20210824170250.710392-44-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

[ upstream commit 0f923e07124df069ba68d8bb12324398f4b6b709 ]

* Invert the mask of bits that we pick from L2 in
  nested_vmcb02_prepare_control

* Invert and explicitly use VIRQ related bits bitmask in svm_clear_vintr

This fixes a security issue that allowed a malicious L1 to run L2 with
AVIC enabled, which allowed the L2 to exploit the uninitialized and enabled
AVIC to read/write the host physical memory at some offsets.

Fixes: 3d6368ef580a ("KVM: SVM: Add VMRUN handler")
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/svm.h |  2 ++
 arch/x86/kvm/svm.c         | 15 ++++++++-------
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 93b462e48067..b6dedf6c835c 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -118,6 +118,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define V_IGN_TPR_SHIFT 20
 #define V_IGN_TPR_MASK (1 << V_IGN_TPR_SHIFT)
 
+#define V_IRQ_INJECTION_BITS_MASK (V_IRQ_MASK | V_INTR_PRIO_MASK | V_IGN_TPR_MASK)
+
 #define V_INTR_MASKING_SHIFT 24
 #define V_INTR_MASKING_MASK (1 << V_INTR_MASKING_SHIFT)
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 9673ddb3d7a0..85181457413e 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1444,12 +1444,7 @@ static __init int svm_hardware_setup(void)
 		}
 	}
 
-	if (vgif) {
-		if (!boot_cpu_has(X86_FEATURE_VGIF))
-			vgif = false;
-		else
-			pr_info("Virtual GIF supported\n");
-	}
+	vgif = false; /* Disabled for CVE-2021-3653 */
 
 	return 0;
 
@@ -3593,7 +3588,13 @@ static void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 	svm->nested.intercept            = nested_vmcb->control.intercept;
 
 	svm_flush_tlb(&svm->vcpu, true);
-	svm->vmcb->control.int_ctl = nested_vmcb->control.int_ctl | V_INTR_MASKING_MASK;
+
+	svm->vmcb->control.int_ctl &=
+			V_INTR_MASKING_MASK | V_GIF_ENABLE_MASK | V_GIF_MASK;
+
+	svm->vmcb->control.int_ctl |= nested_vmcb->control.int_ctl &
+			(V_TPR_MASK | V_IRQ_INJECTION_BITS_MASK);
+
 	if (nested_vmcb->control.int_ctl & V_INTR_MASKING_MASK)
 		svm->vcpu.arch.hflags |= HF_VINTR_MASK;
 	else
-- 
2.30.2

