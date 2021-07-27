Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309873D7B92
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 19:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbhG0RG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 13:06:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50915 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229497AbhG0RG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 13:06:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627405588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=j2qe/ijQLQToepBoJMzhqETg7K1u+t/Q843JAnPvZpU=;
        b=Ih6a58gKL6Gm0W5hp9Dqfq5nfBm022x6TJ7wGMggnDFLTvFvQXTl8gITB46a60CMvAszwa
        RYFIt4PI45I8c2Fj4FkVDXo2aq473FnvnStBxwNh4j65jWWVlvrUWIgTnNj6aKKPU8bf+M
        vfzStrpcwiVZ4KyN/ni9lubQdE3gmEs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-WVSlZ9TlM5ylatKTca3tZA-1; Tue, 27 Jul 2021 13:06:22 -0400
X-MC-Unique: WVSlZ9TlM5ylatKTca3tZA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 08F0093921;
        Tue, 27 Jul 2021 17:06:21 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9FBD960BD9;
        Tue, 27 Jul 2021 17:06:20 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     stable@vger.kernel.org, Stas Sergeev <stsp2@yandex.ru>
Subject: [PATCH v2] KVM: x86: accept userspace interrupt only if no event is injected
Date:   Tue, 27 Jul 2021 13:06:20 -0400
Message-Id: <20210727170620.1643969-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
(cherry picked from commit 043264d97e9ab74cc9661c8b1f9c00c8ce24cad9)
---
 arch/x86/kvm/x86.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4116567f3d44..5e921f1e00db 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4358,8 +4358,18 @@ static int kvm_cpu_accept_dm_intr(struct kvm_vcpu *vcpu)
 
 static int kvm_vcpu_ready_for_interrupt_injection(struct kvm_vcpu *vcpu)
 {
+	/*
+	 * Do not cause an interrupt window exit if an exception
+	 * is pending or an event needs reinjection; userspace
+	 * might want to inject the interrupt manually using KVM_SET_REGS
+	 * or KVM_SET_SREGS.  For that to work, we must be at an
+	 * instruction boundary and with no events half-injected.
+	 */
 	return kvm_arch_interrupt_allowed(vcpu) &&
-		kvm_cpu_accept_dm_intr(vcpu);
+		kvm_cpu_accept_dm_intr(vcpu) &&
+	        !kvm_event_needs_reinjection(vcpu)
+	        !vcpu->arch.exception.pending;
+
 }
 
 static int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
-- 
2.27.0

