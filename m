Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8CBC437A1E
	for <lists+stable@lfdr.de>; Fri, 22 Oct 2021 17:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233545AbhJVPjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Oct 2021 11:39:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38243 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233453AbhJVPir (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Oct 2021 11:38:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634916989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PmrXtbWPHh+yJlxyT85LTWelcMxlBGuMNwifngD9rq4=;
        b=LPAY7aEMLvQbzjIq+dZCG76oHNcirceKG3UmmU4OaWgRrbsNIEPYwzZ/wtwMbb1Tx2EMbb
        jyWdRi8mv6o/zcIstmE3evoUf1O1Zsa6na2gDP2NthQeN8NWjliP2w95XPJhqfMIhdSl0o
        vPFaqyJ1dXCrk1YpYAPG3ulvs1FeaNo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-p1Zo1DiiMTuduqUyD9hssA-1; Fri, 22 Oct 2021 11:36:26 -0400
X-MC-Unique: p1Zo1DiiMTuduqUyD9hssA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CDC85802B78;
        Fri, 22 Oct 2021 15:36:24 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F78860C04;
        Fri, 22 Oct 2021 15:36:24 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com, seanjc@google.com, stable@vger.kernel.org
Subject: [PATCH 05/13] KVM: x86: remove unnecessary arguments from complete_emulator_pio_in
Date:   Fri, 22 Oct 2021 11:36:08 -0400
Message-Id: <20211022153616.1722429-6-pbonzini@redhat.com>
In-Reply-To: <20211022153616.1722429-1-pbonzini@redhat.com>
References: <20211022153616.1722429-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

complete_emulator_pio_in can expect that vcpu->arch.pio has been filled in,
and therefore does not need the size and count arguments.  This makes things
nicer when the function is called directly from a complete_userspace_io
callback.

No functional change intended.

Cc: stable@vger.kernel.org
Fixes: 7ed9abfe8e9f ("KVM: SVM: Support string IO operations for an SEV-ES guest")
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c51ea81019e3..63f9cb33cc19 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6935,11 +6935,12 @@ static int __emulator_pio_in(struct kvm_vcpu *vcpu, int size,
 	return emulator_pio_in_out(vcpu, size, port, count, true);
 }
 
-static void complete_emulator_pio_in(struct kvm_vcpu *vcpu, int size,
-				    unsigned short port, void *val)
+static void complete_emulator_pio_in(struct kvm_vcpu *vcpu, void *val)
 {
-	memcpy(val, vcpu->arch.pio_data, size * vcpu->arch.pio.count);
-	trace_kvm_pio(KVM_PIO_IN, port, size, vcpu->arch.pio.count, vcpu->arch.pio_data);
+	int size = vcpu->arch.pio.size;
+	unsigned count = vcpu->arch.pio.count;
+	memcpy(val, vcpu->arch.pio_data, size * count);
+	trace_kvm_pio(KVM_PIO_IN, vcpu->arch.pio.port, size, count, vcpu->arch.pio_data);
 	vcpu->arch.pio.count = 0;
 }
 
@@ -6957,7 +6958,7 @@ static int emulator_pio_in(struct kvm_vcpu *vcpu, int size,
 	}
 
 	WARN_ON(count != vcpu->arch.pio.count);
-	complete_emulator_pio_in(vcpu, size, port, val);
+	complete_emulator_pio_in(vcpu, val);
 	return 1;
 }
 
-- 
2.27.0


