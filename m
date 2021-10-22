Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64AA437A10
	for <lists+stable@lfdr.de>; Fri, 22 Oct 2021 17:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233519AbhJVPiu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Oct 2021 11:38:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40973 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233450AbhJVPis (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Oct 2021 11:38:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634916989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IaCyK1QA5G26CGbqSdz/wNYCpDSyyw8YiNAfRW5RT9I=;
        b=cDH3UetkNOH3zDrt3imdfLxS96cSg3G0RYkXVAv5M7iYZecHq5bEamooF4G7maLrcIhCK4
        mIp8r1S+PH4UVs97XlqpT5G/JbYNBaFITU+nudL5lCRIoO1mWspT/RaRqCDv9zhvzWVf3R
        4ticQM4B1FqYQSVEYswVBq1TFQ5m894=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-JxNx6slBOxaEswNW7QOtmA-1; Fri, 22 Oct 2021 11:36:24 -0400
X-MC-Unique: JxNx6slBOxaEswNW7QOtmA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 28B0910A8E00;
        Fri, 22 Oct 2021 15:36:23 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B00D160C04;
        Fri, 22 Oct 2021 15:36:22 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com, seanjc@google.com, stable@vger.kernel.org
Subject: [PATCH 02/13] KVM: x86: leave vcpu->arch.pio.count alone in emulator_pio_in_out
Date:   Fri, 22 Oct 2021 11:36:05 -0400
Message-Id: <20211022153616.1722429-3-pbonzini@redhat.com>
In-Reply-To: <20211022153616.1722429-1-pbonzini@redhat.com>
References: <20211022153616.1722429-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently emulator_pio_in clears vcpu->arch.pio.count twice if
emulator_pio_in_out performs kernel PIO.  Move the clear into
emulator_pio_out where it is actually necessary.

No functional change intended.

Cc: stable@vger.kernel.org
Fixes: 7ed9abfe8e9f ("KVM: SVM: Support string IO operations for an SEV-ES guest")
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 379175b725a1..dff28a4fbb21 100644
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


