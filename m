Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 547DD3C932F
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 23:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233918AbhGNVln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 17:41:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33856 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231177AbhGNVlm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 17:41:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626298730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=AS2PhfoWmQKR8Ft5CX0e3UMsUDYv8nJr/WqBjmF1Fek=;
        b=IDlFRxObJsHVuTeKtwnpZp9BwSL31ZlHRXa7Pghpg0GA9/b92MaTE+vDkmWdRoxJsGf2jq
        FqbYoLRhvFUwTjPJZs+u1BCIjfsvXsPnIvw4FhaZ/cOMgGntAZ7oz+bzww+NzRZcDYETcb
        9mBCuvBNTWTbyVdNLbgReRpcWfMFwh0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-518-l4tbBZzgNjqr1nduikmTsw-1; Wed, 14 Jul 2021 17:38:48 -0400
X-MC-Unique: l4tbBZzgNjqr1nduikmTsw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 46B7710C1ADC;
        Wed, 14 Jul 2021 21:38:47 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA2435D9DD;
        Wed, 14 Jul 2021 21:38:46 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     stable@vger.kernel.org, Stas Sergeev <stsp2@yandex.ru>
Subject: [PATCH] KVM: x86: accept userspace interrupt only if no event is injected
Date:   Wed, 14 Jul 2021 17:38:46 -0400
Message-Id: <20210714213846.854837-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
an injected exception is present.  However, DOSBox is using
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
 arch/x86/kvm/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fe3aaf195292..7fbab29b3569 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4342,6 +4342,9 @@ static int kvm_vcpu_ioctl_set_lapic(struct kvm_vcpu *vcpu,
 
 static int kvm_cpu_accept_dm_intr(struct kvm_vcpu *vcpu)
 {
+	if (kvm_event_needs_reinjection(vcpu))
+		return false;
+
 	/*
 	 * We can accept userspace's request for interrupt injection
 	 * as long as we have a place to store the interrupt number.
-- 
2.27.0

