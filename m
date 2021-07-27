Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDF533D80F5
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 23:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbhG0VKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 17:10:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54670 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235239AbhG0VJV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 17:09:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627420160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=epqNANSa//JBOqbfDJlxqgrU5mQ/ZOYCzCBkRvtlhEQ=;
        b=IeZyyoKjFAkH66rOLSKxrOdbLez6lR60UdcfzlYW2cWTF+gJfnWOpSrsMZX9/ECYdfX5MT
        fpPvA9QLOJJDYvomNvopwjh6XVvJe6dY/yU/hT2FxFOwairdoficJhUuxayq7Nz80GZxGa
        vqFDxaenCtleJRlafYpffna1KgAzLww=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-IR3A2OY7PgWndQt2uHqkyQ-1; Tue, 27 Jul 2021 17:09:18 -0400
X-MC-Unique: IR3A2OY7PgWndQt2uHqkyQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D52C8010F4;
        Tue, 27 Jul 2021 21:09:17 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 27AE460C9F;
        Tue, 27 Jul 2021 21:09:17 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, stable@vger.kernel.org,
        Stas Sergeev <stsp2@yandex.ru>
Subject: [PATCH v3] KVM: x86: accept userspace interrupt only if no event is injected
Date:   Tue, 27 Jul 2021 17:09:16 -0400
Message-Id: <20210727210916.1652841-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Once an exception has been injected, any side effects related to
the exception (such as setting CR2 or DR6) have been taked place.
Therefore, once KVM sets the VM-entry interruption information
field or the AMD EVENTINJ field, the next VM-entry must deliver that
exception.

Pending interrupts are processed after injected exceptions, so
in theory it would not be a problem to use KVM_INTERRUPT when
an injected exception is present.  However, DOSEMU is using
run->ready_for_interrupt_injection to detect interrupt windows
and then using KVM_SET_SREGS/KVM_SET_REGS to inject the
interrupt manually.  For this to work, the interrupt window
must be delayed after the completion of the previous event
injection.

Cc: stable@vger.kernel.org
Reported-by: Stas Sergeev <stsp2@yandex.ru>
Tested-by: Stas Sergeev <stsp2@yandex.ru>
Fixes: 71cc849b7093 ("KVM: x86: Fix split-irqchip vs interrupt injection window request")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4116567f3d44..e5d5c5ed7dd4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4358,8 +4358,17 @@ static int kvm_cpu_accept_dm_intr(struct kvm_vcpu *vcpu)
 
 static int kvm_vcpu_ready_for_interrupt_injection(struct kvm_vcpu *vcpu)
 {
-	return kvm_arch_interrupt_allowed(vcpu) &&
-		kvm_cpu_accept_dm_intr(vcpu);
+	/*
+	 * Do not cause an interrupt window exit if an exception
+	 * is pending or an event needs reinjection; userspace
+	 * might want to inject the interrupt manually using KVM_SET_REGS
+	 * or KVM_SET_SREGS.  For that to work, we must be at an
+	 * instruction boundary and with no events half-injected.
+	 */
+	return (kvm_arch_interrupt_allowed(vcpu) &&
+		kvm_cpu_accept_dm_intr(vcpu) &&
+		!kvm_event_needs_reinjection(vcpu) &&
+		!vcpu->arch.exception.pending);
 }
 
 static int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
-- 
2.27.0

