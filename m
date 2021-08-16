Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEDB3ED889
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 16:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237180AbhHPODd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 10:03:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32022 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231852AbhHPOD0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 10:03:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629122574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=yzdavpnyJfbcprFccnwdjqfp//3HvexWQ+5ti7Py9o8=;
        b=cODxEmoclRnIBQzX3/ql/kGEENFgJPCX3ipIii4mFoLxjdIIC6M5opK5SomD7b1RUtg3eq
        IelwKjHv4nk9VlPW4s4e6fhB2+4U/GHnaiHWqCTQLvQvmjbuMsNzrJas4RuMkWCaAw3uva
        UBDF+WRaQfhrA5U3FiGE22mmir6DMtI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-rCgu-NTLOPS3hnjnPtDNGQ-1; Mon, 16 Aug 2021 10:02:52 -0400
X-MC-Unique: rCgu-NTLOPS3hnjnPtDNGQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73D3A802929;
        Mon, 16 Aug 2021 14:02:51 +0000 (UTC)
Received: from avogadro.lan (unknown [10.39.192.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 366EE2CD33;
        Mon, 16 Aug 2021 14:02:50 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 5.12.y] KVM: nSVM: avoid picking up unsupported bits from L2 in int_ctl (CVE-2021-3653)
Date:   Mon, 16 Aug 2021 16:02:34 +0200
Message-Id: <20210816140240.11399-6-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
	The above upstream SHA1 is still on its way to Linus

 arch/x86/include/asm/svm.h |  2 ++
 arch/x86/kvm/svm/nested.c  | 11 +++++++----
 arch/x86/kvm/svm/svm.c     |  8 ++++----
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 1c561945b426..6278111bbf97 100644
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
index fb204eaa8bb3..4b8635d2296a 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -429,7 +429,10 @@ static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *vmcb12)
 
 static void nested_prepare_vmcb_control(struct vcpu_svm *svm)
 {
-	const u32 mask = V_INTR_MASKING_MASK | V_GIF_ENABLE_MASK | V_GIF_MASK;
+	const u32 int_ctl_vmcb01_bits =
+		V_INTR_MASKING_MASK | V_GIF_MASK | V_GIF_ENABLE_MASK;
+
+	const u32 int_ctl_vmcb12_bits = V_TPR_MASK | V_IRQ_INJECTION_BITS_MASK;
 
 	if (nested_npt_enabled(svm))
 		nested_svm_init_mmu_context(&svm->vcpu);
@@ -437,9 +440,9 @@ static void nested_prepare_vmcb_control(struct vcpu_svm *svm)
 	svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset =
 		svm->vcpu.arch.l1_tsc_offset + svm->nested.ctl.tsc_offset;
 
-	svm->vmcb->control.int_ctl             =
-		(svm->nested.ctl.int_ctl & ~mask) |
-		(svm->nested.hsave->control.int_ctl & mask);
+	svm->vmcb->control.int_ctl =
+		(svm->nested.ctl.int_ctl & int_ctl_vmcb12_bits) |
+		(svm->nested.hsave->control.int_ctl & int_ctl_vmcb01_bits);
 
 	svm->vmcb->control.virt_ext            = svm->nested.ctl.virt_ext;
 	svm->vmcb->control.int_vector          = svm->nested.ctl.int_vector;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f262edf7551b..4236188dda7d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1560,17 +1560,17 @@ static void svm_set_vintr(struct vcpu_svm *svm)
 
 static void svm_clear_vintr(struct vcpu_svm *svm)
 {
-	const u32 mask = V_TPR_MASK | V_GIF_ENABLE_MASK | V_GIF_MASK | V_INTR_MASKING_MASK;
 	svm_clr_intercept(svm, INTERCEPT_VINTR);
 
 	/* Drop int_ctl fields related to VINTR injection.  */
-	svm->vmcb->control.int_ctl &= mask;
+	svm->vmcb->control.int_ctl &= ~V_IRQ_INJECTION_BITS_MASK;
 	if (is_guest_mode(&svm->vcpu)) {
-		svm->nested.hsave->control.int_ctl &= mask;
+		svm->nested.hsave->control.int_ctl &= ~V_IRQ_INJECTION_BITS_MASK;
 
 		WARN_ON((svm->vmcb->control.int_ctl & V_TPR_MASK) !=
 			(svm->nested.ctl.int_ctl & V_TPR_MASK));
-		svm->vmcb->control.int_ctl |= svm->nested.ctl.int_ctl & ~mask;
+		svm->vmcb->control.int_ctl |= svm->nested.ctl.int_ctl &
+			V_IRQ_INJECTION_BITS_MASK;
 	}
 
 	vmcb_mark_dirty(svm->vmcb, VMCB_INTR);
-- 
2.26.3

