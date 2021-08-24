Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 567413F6811
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239755AbhHXRkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:40:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241843AbhHXRiO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:38:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FE3D61BF7;
        Tue, 24 Aug 2021 17:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824879;
        bh=bggxmQ4/NIESsrzeDjUpmEdNKlfBZUPxmQySwsFCbCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WNGqzulNoM6bXkKTjuMLRSG0VJXOLEYixk9j62cd7VAq8bxIPOPH87wPphEz5dL9L
         RD06m9gv6qjYTFI8fy7tlTmDWIZwFdocuTZHDJO1K+m1lzNEeL1BIbMG8bdpdiPg3N
         Yr76VY379D6CZpz+FGBJzCUReFRufiS5Yr+Z+bWvVLsCmJWpiTJrGSJ5OFOeMojuYR
         kU9OMokxw8cHbBB732bmnXWIp7VYhGbfCWp8awSrmFjo3wVkUtaL13SGlWX8zor4PN
         HJ/hbnFnQkKPMQYITc93JWMPZULRvEcC7Zg8xxP958Czck5nazST7YbufsWt2D+2CN
         bgwuR9fa9B13A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.4 15/31] KVM: nSVM: avoid picking up unsupported bits from L2 in int_ctl (CVE-2021-3653)
Date:   Tue, 24 Aug 2021 13:07:27 -0400
Message-Id: <20210824170743.710957-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170743.710957-1-sashal@kernel.org>
References: <20210824170743.710957-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.282-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.282-rc1
X-KernelTest-Deadline: 2021-08-26T17:07+00:00
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
 arch/x86/include/asm/svm.h | 2 ++
 arch/x86/kvm/svm.c         | 6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 6136d99f537b..c1adb2ed6d41 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -108,6 +108,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define V_IGN_TPR_SHIFT 20
 #define V_IGN_TPR_MASK (1 << V_IGN_TPR_SHIFT)
 
+#define V_IRQ_INJECTION_BITS_MASK (V_IRQ_MASK | V_INTR_PRIO_MASK | V_IGN_TPR_MASK)
+
 #define V_INTR_MASKING_SHIFT 24
 #define V_INTR_MASKING_MASK (1 << V_INTR_MASKING_SHIFT)
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 931acac69703..77bee73faebc 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2564,7 +2564,11 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	svm->nested.intercept            = nested_vmcb->control.intercept;
 
 	svm_flush_tlb(&svm->vcpu);
-	svm->vmcb->control.int_ctl = nested_vmcb->control.int_ctl | V_INTR_MASKING_MASK;
+	svm->vmcb->control.int_ctl = nested_vmcb->control.int_ctl &
+			(V_TPR_MASK | V_IRQ_INJECTION_BITS_MASK);
+
+	svm->vmcb->control.int_ctl |= V_INTR_MASKING_MASK;
+
 	if (nested_vmcb->control.int_ctl & V_INTR_MASKING_MASK)
 		svm->vcpu.arch.hflags |= HF_VINTR_MASK;
 	else
-- 
2.30.2

