Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C45813ED87E
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 16:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236242AbhHPODY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 10:03:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51602 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231959AbhHPODX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 10:03:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629122571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=z7bgEj7pf0qR83AdLpsnYV0+Zd/w/LzG4EMhM5bKSNM=;
        b=UUBR68Fll98eW26sINAbnkuTfIP3PrfQeQxZORu7cDAZ5czeM+EEVvBjeA3lG1J0Sj04qK
        PMYMZZdqKjdKO32TOwQMu1dcYHUpqemk3yAclPM7hHaM+zWg6fOxzR5NB9Aw2bQr+CqOIC
        vrh4dUc+UVfZkgXYWAtCrOZqNvP0Azg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-h1L_Uep4MDanTClylLgAww-1; Mon, 16 Aug 2021 10:02:49 -0400
X-MC-Unique: h1L_Uep4MDanTClylLgAww-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2FA0D1853027;
        Mon, 16 Aug 2021 14:02:48 +0000 (UTC)
Received: from avogadro.lan (unknown [10.39.192.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E7E652CD33;
        Mon, 16 Aug 2021 14:02:46 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 4.9.y] KVM: nSVM: avoid picking up unsupported bits from L2 in int_ctl (CVE-2021-3653)
Date:   Mon, 16 Aug 2021 16:02:32 +0200
Message-Id: <20210816140240.11399-4-pbonzini@redhat.com>
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

 arch/x86/include/asm/svm.h | 2 ++
 arch/x86/kvm/svm.c         | 6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 14824fc78f7e..509b9f3307e4 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -113,6 +113,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define V_IGN_TPR_SHIFT 20
 #define V_IGN_TPR_MASK (1 << V_IGN_TPR_SHIFT)
 
+#define V_IRQ_INJECTION_BITS_MASK (V_IRQ_MASK | V_INTR_PRIO_MASK | V_IGN_TPR_MASK)
+
 #define V_INTR_MASKING_SHIFT 24
 #define V_INTR_MASKING_MASK (1 << V_INTR_MASKING_SHIFT)
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index cbc7f177bbd8..03fdeab057d2 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3048,7 +3048,11 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
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
2.26.3

