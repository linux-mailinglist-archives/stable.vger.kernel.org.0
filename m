Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBAA45EF12
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 14:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242338AbhKZN0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 08:26:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24292 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344908AbhKZNYu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 08:24:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637932897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=34sYTYVyXuYs+CPwdd7XUd+SQ49NoZZow/8OSNllSUk=;
        b=fBGiYappsV0rJWI403NUjBPV0RbzkWQA8ZGJzlFJiGPP/H2SeWRxe4wycMfvrPYJ5l48F0
        bUpCwxjlGmM4BxyUrpUzj5l1mYP6tdmG5IjPzR/cWvhnCrV8UjrqTl+fOKexE/EpMzdEP2
        53rIVq8uRUCC3z6DjSjHgNjt71zrdjg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-w7tcNeMNOCyLupiTaHXOFA-1; Fri, 26 Nov 2021 08:21:34 -0500
X-MC-Unique: w7tcNeMNOCyLupiTaHXOFA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E7FFD80F051;
        Fri, 26 Nov 2021 13:21:32 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5911F5C1CF;
        Fri, 26 Nov 2021 13:21:32 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     laijs@linux.alibaba.com, stable@vger.kernel.org
Subject: [PATCH] KVM: MMU: shadow nested paging does not have PKU
Date:   Fri, 26 Nov 2021 08:21:31 -0500
Message-Id: <20211126132131.26077-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Initialize the mask for PKU permissions as if CR4.PKE=0, avoiding
incorrect interpretations of the nested hypervisor's page tables.

Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5942e9c6dd6e..a33b5361bc67 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4855,7 +4855,7 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
 	struct kvm_mmu *context = &vcpu->arch.guest_mmu;
 	struct kvm_mmu_role_regs regs = {
 		.cr0 = cr0,
-		.cr4 = cr4,
+		.cr4 = cr4 & ~X86_CR4_PKE,
 		.efer = efer,
 	};
 	union kvm_mmu_role new_role;
@@ -4919,7 +4919,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 	context->direct_map = false;
 
 	update_permission_bitmask(context, true);
-	update_pkru_bitmask(context);
+	context->pkru_mask = 0;
 	reset_rsvds_bits_mask_ept(vcpu, context, execonly);
 	reset_ept_shadow_zero_bits_mask(vcpu, context, execonly);
 }
-- 
2.31.1

