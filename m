Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C29B42C707
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 18:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237899AbhJMQ7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 12:59:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28239 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237977AbhJMQ7e (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 12:59:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634144250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fyu09GZFGUx4nBOLNYk/fAUDRi0wmwohbIJZu/R+jms=;
        b=gUl/Gxw8K7L3RwSz6QAPyTIFYRksae6HC6bgMs+RlbohlYwmDv2/dM9MzyC8fUzv2vX6UX
        qO6DapZdyXb7LeYWfar56HW604cCSGA4di/6JRF3lVXXhBl9ABPlZQebhuGWdaW6D8i4Rh
        p/GMmKTMdXVvVCXYv556nctJShblHW4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-EYOD87vJPUCv-BKchwdkhA-1; Wed, 13 Oct 2021 12:56:21 -0400
X-MC-Unique: EYOD87vJPUCv-BKchwdkhA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9664F1842154;
        Wed, 13 Oct 2021 16:56:20 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1929D5DA60;
        Wed, 13 Oct 2021 16:56:20 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     fwilhelm@google.com, seanjc@google.com, oupton@google.com,
        stable@vger.kernel.org
Subject: [PATCH 5/8] KVM: x86: split the two parts of emulator_pio_in
Date:   Wed, 13 Oct 2021 12:56:13 -0400
Message-Id: <20211013165616.19846-6-pbonzini@redhat.com>
In-Reply-To: <20211013165616.19846-1-pbonzini@redhat.com>
References: <20211013165616.19846-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

emulator_pio_in handles both the case where the data is pending in
vcpu->arch.pio.count, and the case where I/O has to be done via either
an in-kernel device or a userspace exit.  For SEV-ES we would like
to split these, to identify clearly the moment at which the
sev_pio_data is consumed.  To this end, create two different
functions: __emulator_pio_in fills in vcpu->arch.pio.count, while
complete_emulator_pio_in clears it and releases vcpu->arch.pio.data.

While at it, remove the void* argument also from emulator_pio_in_out.

No functional change intended.

Cc: stable@vger.kernel.org
Fixes: 7ed9abfe8e9f ("KVM: SVM: Support string IO operations for an SEV-ES guest")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 42 +++++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8880dc36a2b4..07d9533b471d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6906,7 +6906,7 @@ static int kernel_pio(struct kvm_vcpu *vcpu, void *pd)
 }
 
 static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
-			       unsigned short port, void *val,
+			       unsigned short port,
 			       unsigned int count, bool in)
 {
 	vcpu->arch.pio.port = port;
@@ -6927,26 +6927,31 @@ static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
 	return 0;
 }
 
-static int emulator_pio_in(struct kvm_vcpu *vcpu, int size,
-			   unsigned short port, void *val, unsigned int count)
+static int __emulator_pio_in(struct kvm_vcpu *vcpu, int size,
+			     unsigned short port, unsigned int count)
 {
-	int ret;
-
-	if (vcpu->arch.pio.count)
-		goto data_avail;
-
+	WARN_ON(vcpu->arch.pio.count);
 	memset(vcpu->arch.pio_data, 0, size * count);
+	return emulator_pio_in_out(vcpu, size, port, count, true);
+}
 
-	ret = emulator_pio_in_out(vcpu, size, port, val, count, true);
-	if (ret) {
-data_avail:
-		memcpy(val, vcpu->arch.pio_data, size * count);
-		trace_kvm_pio(KVM_PIO_IN, port, size, count, vcpu->arch.pio_data);
-		vcpu->arch.pio.count = 0;
-		return 1;
-	}
+static void complete_emulator_pio_in(struct kvm_vcpu *vcpu, int size,
+				    unsigned short port, void *val)
+{
+	memcpy(val, vcpu->arch.pio_data, size * vcpu->arch.pio.count);
+	trace_kvm_pio(KVM_PIO_IN, port, size, vcpu->arch.pio.count, vcpu->arch.pio_data);
+	vcpu->arch.pio.count = 0;
+}
 
-	return 0;
+static int emulator_pio_in(struct kvm_vcpu *vcpu, int size,
+			   unsigned short port, void *val, unsigned int count)
+{
+	if (!vcpu->arch.pio.count && !__emulator_pio_in(vcpu, size, port, count))
+		return 0;
+
+	WARN_ON(count != vcpu->arch.pio.count);
+	complete_emulator_pio_in(vcpu, size, port, val);
+	return 1;
 }
 
 static int emulator_pio_in_emulated(struct x86_emulate_ctxt *ctxt,
@@ -6965,12 +6970,11 @@ static int emulator_pio_out(struct kvm_vcpu *vcpu, int size,
 
 	memcpy(vcpu->arch.pio_data, val, size * count);
 	trace_kvm_pio(KVM_PIO_OUT, port, size, count, vcpu->arch.pio_data);
-	ret = emulator_pio_in_out(vcpu, size, port, (void *)val, count, false);
+	ret = emulator_pio_in_out(vcpu, size, port, count, false);
 	if (ret)
                 vcpu->arch.pio.count = 0;
 
         return ret;
-
 }
 
 static int emulator_pio_out_emulated(struct x86_emulate_ctxt *ctxt,
-- 
2.27.0


