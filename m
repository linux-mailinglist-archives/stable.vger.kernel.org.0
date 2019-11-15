Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4E5FD649
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 07:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbfKOGXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 01:23:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:51358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727306AbfKOGWK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 01:22:10 -0500
Received: from localhost (unknown [104.132.150.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 782B72075E;
        Fri, 15 Nov 2019 06:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573798929;
        bh=IkdXxJete19VJkW6jFFP7lbIFcc9ZEGPf3R2bm+BPb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r6jsxbnlCur9+7BEx0zFmsVNHyQ/D7X84Bwv3iG0tiivJyoUbkMAYNzGV/Nj9YJLb
         XnTWwEEK+hEZaU/CKWCXQBGEWzW4PDepoO3/bJmIjrrwkcs+vCZmayeNuXGz8aT7SK
         Wfb7YMscSE/YmqZm7Wp5eB5EnbC2B7FEz/7acJuI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 16/31] KVM: x86: simplify ept_misconfig
Date:   Fri, 15 Nov 2019 14:20:45 +0800
Message-Id: <20191115062016.837160389@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191115062009.813108457@linuxfoundation.org>
References: <20191115062009.813108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit e08d26f0712532c79b5ba6200862eaf2036f8df6 upstream.

Calling handle_mmio_page_fault() has been unnecessary since commit
e9ee956e311d ("KVM: x86: MMU: Move handle_mmio_page_fault() call to
kvm_mmu_page_fault()", 2016-02-22).

handle_mmio_page_fault() can now be made static.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
[bwh: Backported to 4.9: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu.c |   19 ++++++++++++++++++-
 arch/x86/kvm/mmu.h |   17 -----------------
 arch/x86/kvm/vmx.c |   13 +++----------
 3 files changed, 21 insertions(+), 28 deletions(-)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3383,7 +3383,23 @@ exit:
 	return reserved;
 }
 
-int handle_mmio_page_fault(struct kvm_vcpu *vcpu, u64 addr, bool direct)
+/*
+ * Return values of handle_mmio_page_fault:
+ * RET_MMIO_PF_EMULATE: it is a real mmio page fault, emulate the instruction
+ *			directly.
+ * RET_MMIO_PF_INVALID: invalid spte is detected then let the real page
+ *			fault path update the mmio spte.
+ * RET_MMIO_PF_RETRY: let CPU fault again on the address.
+ * RET_MMIO_PF_BUG: a bug was detected (and a WARN was printed).
+ */
+enum {
+	RET_MMIO_PF_EMULATE = 1,
+	RET_MMIO_PF_INVALID = 2,
+	RET_MMIO_PF_RETRY = 0,
+	RET_MMIO_PF_BUG = -1
+};
+
+static int handle_mmio_page_fault(struct kvm_vcpu *vcpu, u64 addr, bool direct)
 {
 	u64 spte;
 	bool reserved;
@@ -4520,6 +4536,7 @@ int kvm_mmu_page_fault(struct kvm_vcpu *
 			return 1;
 		if (r < 0)
 			return r;
+		/* Must be RET_MMIO_PF_INVALID.  */
 	}
 
 	r = vcpu->arch.mmu.page_fault(vcpu, cr2, error_code, false);
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -56,23 +56,6 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio
 void
 reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu, struct kvm_mmu *context);
 
-/*
- * Return values of handle_mmio_page_fault:
- * RET_MMIO_PF_EMULATE: it is a real mmio page fault, emulate the instruction
- *			directly.
- * RET_MMIO_PF_INVALID: invalid spte is detected then let the real page
- *			fault path update the mmio spte.
- * RET_MMIO_PF_RETRY: let CPU fault again on the address.
- * RET_MMIO_PF_BUG: a bug was detected (and a WARN was printed).
- */
-enum {
-	RET_MMIO_PF_EMULATE = 1,
-	RET_MMIO_PF_INVALID = 2,
-	RET_MMIO_PF_RETRY = 0,
-	RET_MMIO_PF_BUG = -1
-};
-
-int handle_mmio_page_fault(struct kvm_vcpu *vcpu, u64 addr, bool direct);
 void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu);
 void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly);
 bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu);
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -6556,16 +6556,9 @@ static int handle_ept_misconfig(struct k
 						       NULL, 0) == EMULATE_DONE;
 	}
 
-	ret = handle_mmio_page_fault(vcpu, gpa, true);
-	if (likely(ret == RET_MMIO_PF_EMULATE))
-		return x86_emulate_instruction(vcpu, gpa, 0, NULL, 0) ==
-					      EMULATE_DONE;
-
-	if (unlikely(ret == RET_MMIO_PF_INVALID))
-		return kvm_mmu_page_fault(vcpu, gpa, 0, NULL, 0);
-
-	if (unlikely(ret == RET_MMIO_PF_RETRY))
-		return 1;
+	ret = kvm_mmu_page_fault(vcpu, gpa, PFERR_RSVD_MASK, NULL, 0);
+	if (ret >= 0)
+		return ret;
 
 	/* It is the real ept misconfig */
 	WARN_ON(1);


