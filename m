Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546D942C6E9
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 18:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237897AbhJMQ6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 12:58:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21687 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237654AbhJMQ6Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 12:58:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634144182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vUAVjKQkq2g15zkTPDuGPxcuOVr2U5kgKEC2+VtOj5U=;
        b=Mm4ym3e2j1e4PcZFgS0FXhUrpyFGxpZVk2Gu16kzsh8peQEtY5VigG7O1GiQY8Tvd29rBs
        /OYyEa/pjFF73R8L+rgceVVfHPIPleUvghYUO3ARverwFnJqFrXRY3cdlJQQ4gW0spvJQF
        VXBm4A7j+Pwfz9l05/bDndYdKa3zWt4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-dtR4dPZsPR64bhLzhhBK3A-1; Wed, 13 Oct 2021 12:56:20 -0400
X-MC-Unique: dtR4dPZsPR64bhLzhhBK3A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7442E1842158;
        Wed, 13 Oct 2021 16:56:19 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D345F5DA60;
        Wed, 13 Oct 2021 16:56:18 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     fwilhelm@google.com, seanjc@google.com, oupton@google.com,
        stable@vger.kernel.org
Subject: [PATCH 3/8] KVM: x86: leave vcpu->arch.pio.count alone in emulator_pio_in_out
Date:   Wed, 13 Oct 2021 12:56:11 -0400
Message-Id: <20211013165616.19846-4-pbonzini@redhat.com>
In-Reply-To: <20211013165616.19846-1-pbonzini@redhat.com>
References: <20211013165616.19846-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently emulator_pio_in clears vcpu->arch.pio.count twice if
emulator_pio_in_out performs kernel PIO.  Move the clear into
emulator_pio_out where it is actually necessary.

No functional change intended.

Cc: stable@vger.kernel.org
Fixes: 7ed9abfe8e9f ("KVM: SVM: Support string IO operations for an SEV-ES guest")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 722f5fcf76e1..218877e297e5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6914,10 +6914,8 @@ static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
 	vcpu->arch.pio.count  = count;
 	vcpu->arch.pio.size = size;
 
-	if (!kernel_pio(vcpu, vcpu->arch.pio_data)) {
-		vcpu->arch.pio.count = 0;
+	if (!kernel_pio(vcpu, vcpu->arch.pio_data))
 		return 1;
-	}
 
 	vcpu->run->exit_reason = KVM_EXIT_IO;
 	vcpu->run->io.direction = in ? KVM_EXIT_IO_IN : KVM_EXIT_IO_OUT;
@@ -6963,9 +6961,16 @@ static int emulator_pio_out(struct kvm_vcpu *vcpu, int size,
 			    unsigned short port, const void *val,
 			    unsigned int count)
 {
+	int ret;
+
 	memcpy(vcpu->arch.pio_data, val, size * count);
 	trace_kvm_pio(KVM_PIO_OUT, port, size, count, vcpu->arch.pio_data);
-	return emulator_pio_in_out(vcpu, size, port, (void *)val, count, false);
+	ret = emulator_pio_in_out(vcpu, size, port, (void *)val, count, false);
+	if (ret)
+                vcpu->arch.pio.count = 0;
+
+        return ret;
+
 }
 
 static int emulator_pio_out_emulated(struct x86_emulate_ctxt *ctxt,
-- 
2.27.0


