Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 706123EDA13
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 17:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233233AbhHPPoH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 11:44:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44906 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232849AbhHPPoE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 11:44:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629128612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=5+H3tVuFTE/yUYCGm/toB+kJDsMZHFf9GHrqRvwC/k8=;
        b=ZcH4mmDwaJXOgCzs8iwv9RsPo4rKHlF26YGVu6xa5T0Ch1GRCwGttqW1k5MNz9X/L3rLNg
        7P+5hmwNiqxxS4L21KITikt0zMoL2udUwCFeGO4SpOADaixql8n+jBfPnUwIvgAEKNX7jQ
        syWujZsbPFVAmA1pC/pIzkL095tTbpM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-of79Wm1UP2mspHzNqK-t-g-1; Mon, 16 Aug 2021 11:43:30 -0400
X-MC-Unique: of79Wm1UP2mspHzNqK-t-g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 483131082921;
        Mon, 16 Aug 2021 15:43:29 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DBBDF10013D7;
        Mon, 16 Aug 2021 15:43:28 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 5.13.y] KVM: nSVM: avoid picking up unsupported bits from L2 in int_ctl (CVE-2021-3653)
Date:   Mon, 16 Aug 2021 11:43:27 -0400
Message-Id: <20210816154328.3845839-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
---
 arch/x86/include/asm/svm.h | 2 ++
 arch/x86/kvm/svm/nested.c  | 9 ++++++---
 arch/x86/kvm/svm/svm.c     | 9 +++++----
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 772e60efe243..b6c445ced0e5 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -178,6 +178,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define V_IGN_TPR_SHIFT 20
 #define V_IGN_TPR_MASK (1 << V_IGN_TPR_SHIFT)
 
+#define V_IRQ_INJECTION_BITS_MASK (V_IRQ_MASK | V_INTR_PRIO_MASK | V_IGN_TPR_MASK)
+
 #define V_INTR_MASKING_SHIFT 24
 #define V_INTR_MASKING_MASK (1 << V_INTR_MASKING_SHIFT)
 
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 5e8d8443154e..7f3b55561ae8 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -480,7 +480,10 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 
 static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 {
-	const u32 mask = V_INTR_MASKING_MASK | V_GIF_ENABLE_MASK | V_GIF_MASK;
+	const u32 int_ctl_vmcb01_bits =
+		V_INTR_MASKING_MASK | V_GIF_MASK | V_GIF_ENABLE_MASK;
+
+	const u32 int_ctl_vmcb12_bits = V_TPR_MASK | V_IRQ_INJECTION_BITS_MASK;
 
 	/*
 	 * Filled at exit: exit_code, exit_code_hi, exit_info_1, exit_info_2,
@@ -511,8 +514,8 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 		svm->vcpu.arch.l1_tsc_offset + svm->nested.ctl.tsc_offset;
 
 	svm->vmcb->control.int_ctl             =
-		(svm->nested.ctl.int_ctl & ~mask) |
-		(svm->vmcb01.ptr->control.int_ctl & mask);
+		(svm->nested.ctl.int_ctl & int_ctl_vmcb12_bits) |
+		(svm->vmcb01.ptr->control.int_ctl & int_ctl_vmcb01_bits);
 
 	svm->vmcb->control.virt_ext            = svm->nested.ctl.virt_ext;
 	svm->vmcb->control.int_vector          = svm->nested.ctl.int_vector;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 62f1f06fe197..0a49a0db54e1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1552,17 +1552,18 @@ static void svm_set_vintr(struct vcpu_svm *svm)
 
 static void svm_clear_vintr(struct vcpu_svm *svm)
 {
-	const u32 mask = V_TPR_MASK | V_GIF_ENABLE_MASK | V_GIF_MASK | V_INTR_MASKING_MASK;
 	svm_clr_intercept(svm, INTERCEPT_VINTR);
 
 	/* Drop int_ctl fields related to VINTR injection.  */
-	svm->vmcb->control.int_ctl &= mask;
+	svm->vmcb->control.int_ctl &= ~V_IRQ_INJECTION_BITS_MASK;
 	if (is_guest_mode(&svm->vcpu)) {
-		svm->vmcb01.ptr->control.int_ctl &= mask;
+		svm->vmcb01.ptr->control.int_ctl &= ~V_IRQ_INJECTION_BITS_MASK;
 
 		WARN_ON((svm->vmcb->control.int_ctl & V_TPR_MASK) !=
 			(svm->nested.ctl.int_ctl & V_TPR_MASK));
-		svm->vmcb->control.int_ctl |= svm->nested.ctl.int_ctl & ~mask;
+
+		svm->vmcb->control.int_ctl |= svm->nested.ctl.int_ctl &
+			V_IRQ_INJECTION_BITS_MASK;
 	}
 
 	vmcb_mark_dirty(svm->vmcb, VMCB_INTR);
-- 
2.27.0

