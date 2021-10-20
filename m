Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51971434E47
	for <lists+stable@lfdr.de>; Wed, 20 Oct 2021 16:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbhJTOyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 10:54:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56114 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230024AbhJTOyw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Oct 2021 10:54:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634741557;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=EOJKI5DiIEAdiCMwnSFoBtdcws6vk4gDTew6qqVUMsg=;
        b=bLUWtWedDZmCbs4AvfzuhqN1thP/xQF6pet8Y537a0n5Ksyh61wRTtO+pjxnwEN3c5qfWa
        BR/T+YS2P4K52qr6QgEpj9OtF7HQz7DkVrwXEhvP9iAuJTbdrujEpPlt4/FQjE2jnjooA8
        f+P2j2cb6tDTNB2rs0CBPEeasLK2MHg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-GpQSaoceMN-9MGXIiBQtjQ-1; Wed, 20 Oct 2021 10:52:34 -0400
X-MC-Unique: GpQSaoceMN-9MGXIiBQtjQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 081731926DAC;
        Wed, 20 Oct 2021 14:52:33 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8EBDC17155;
        Wed, 20 Oct 2021 14:52:32 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     wanpengli@tencent.com, seanjc@google.com, stable@vger.kernel.org
Subject: [PATCH] KVM: nVMX: promptly process interrupts delivered while in guest mode
Date:   Wed, 20 Oct 2021 10:52:30 -0400
Message-Id: <20211020145231.871299-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since commit c300ab9f08df ("KVM: x86: Replace late check_nested_events() hack with
more precise fix") there is no longer the certainty that check_nested_events()
tries to inject an external interrupt vmexit to L1 on every call to vcpu_enter_guest.
Therefore, even in that case we need to set KVM_REQ_EVENT.  This ensures
that inject_pending_event() is called, and from there kvm_check_nested_events().

Fixes: c300ab9f08df ("KVM: x86: Replace late check_nested_events() hack with more precise fix")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 79d6af09dbf4..7567e1d15017 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6331,18 +6331,13 @@ static int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
 
 		/*
 		 * If we are running L2 and L1 has a new pending interrupt
-		 * which can be injected, we should re-evaluate
-		 * what should be done with this new L1 interrupt.
-		 * If L1 intercepts external-interrupts, we should
-		 * exit from L2 to L1. Otherwise, interrupt should be
-		 * delivered directly to L2.
+		 * which can be injected, this may cause a vmexit or it may
+		 * be injected into L2.  Either way, this interrupt will be
+		 * processed via KVM_REQ_EVENT, not RVI, because we do not use
+		 * virtual interrupt delivery to inject L1 interrupts into L2.
 		 */
-		if (is_guest_mode(vcpu) && max_irr_updated) {
-			if (nested_exit_on_intr(vcpu))
-				kvm_vcpu_exiting_guest_mode(vcpu);
-			else
-				kvm_make_request(KVM_REQ_EVENT, vcpu);
-		}
+		if (is_guest_mode(vcpu) && max_irr_updated)
+			kvm_make_request(KVM_REQ_EVENT, vcpu);
 	} else {
 		max_irr = kvm_lapic_find_highest_irr(vcpu);
 	}
-- 
2.27.0

