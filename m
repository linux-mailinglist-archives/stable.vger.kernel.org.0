Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2E4437A0C
	for <lists+stable@lfdr.de>; Fri, 22 Oct 2021 17:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbhJVPis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Oct 2021 11:38:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48657 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233346AbhJVPiq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Oct 2021 11:38:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634916988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vXr+Exal5LNQsSdCGyAV58Icl9lg1z0ShZaCE7sWcgg=;
        b=XhvByc+rVqsXVeKujcDOUod4CIiRZGz3qXX5W3QvLyU2wClK6vzgT/jgjpKNwGCl66Wz3J
        HeodCggx+KmwfOA/alNaoYL3Fu7o4SXbg4FB20IghwL3M4LUXakIzFCwKXWuEOzbJVYpnL
        Ep/7kjWpkr+drIb56dJ1jFi07eFopfQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-2UVFjmngPoSIOTFjQ2TDHw-1; Fri, 22 Oct 2021 11:36:25 -0400
X-MC-Unique: 2UVFjmngPoSIOTFjQ2TDHw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 463B1362FE;
        Fri, 22 Oct 2021 15:36:24 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB12260C04;
        Fri, 22 Oct 2021 15:36:23 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com, seanjc@google.com, stable@vger.kernel.org
Subject: [PATCH 04/13] KVM: x86: split the two parts of emulator_pio_in
Date:   Fri, 22 Oct 2021 11:36:07 -0400
Message-Id: <20211022153616.1722429-5-pbonzini@redhat.com>
In-Reply-To: <20211022153616.1722429-1-pbonzini@redhat.com>
References: <20211022153616.1722429-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

Because this patch has to be backported, things are left a bit messy.
kernel_pio() operates on vcpu->arch.pio, which leads to emulator_pio_in()
having with two calls to complete_emulator_pio_in().  It will be fixed
in the next release.

While at it, remove the unused void* val argument of emulator_pio_in_out.
The function currently hardcodes vcpu->arch.pio_data as the
source/destination buffer, which sucks but will be fixed after the more
severe SEV-ES buffer overflow.

No functional change intended.

Cc: stable@vger.kernel.org
Fixes: 7ed9abfe8e9f ("KVM: SVM: Support string IO operations for an SEV-ES guest")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 45 ++++++++++++++++++++++++++++-----------------
 1 file changed, 28 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 78ed0fe9fa1e..c51ea81019e3 100644
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
@@ -6927,26 +6927,38 @@ static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
 	return 0;
 }
 
+static int __emulator_pio_in(struct kvm_vcpu *vcpu, int size,
+			     unsigned short port, unsigned int count)
+{
+	WARN_ON(vcpu->arch.pio.count);
+	memset(vcpu->arch.pio_data, 0, size * count);
+	return emulator_pio_in_out(vcpu, size, port, count, true);
+}
+
+static void complete_emulator_pio_in(struct kvm_vcpu *vcpu, int size,
+				    unsigned short port, void *val)
+{
+	memcpy(val, vcpu->arch.pio_data, size * vcpu->arch.pio.count);
+	trace_kvm_pio(KVM_PIO_IN, port, size, vcpu->arch.pio.count, vcpu->arch.pio_data);
+	vcpu->arch.pio.count = 0;
+}
+
 static int emulator_pio_in(struct kvm_vcpu *vcpu, int size,
 			   unsigned short port, void *val, unsigned int count)
 {
-	int ret;
+	if (vcpu->arch.pio.count) {
+		/* Complete previous iteration.  */
+	} else {
+		int r = __emulator_pio_in(vcpu, size, port, count);
+		if (!r)
+			return r;
 
-	if (vcpu->arch.pio.count)
-		goto data_avail;
-
-	memset(vcpu->arch.pio_data, 0, size * count);
-
-	ret = emulator_pio_in_out(vcpu, size, port, val, count, true);
-	if (ret) {
-data_avail:
-		memcpy(val, vcpu->arch.pio_data, size * count);
-		trace_kvm_pio(KVM_PIO_IN, port, size, count, vcpu->arch.pio_data);
-		vcpu->arch.pio.count = 0;
-		return 1;
+		/* Results already available, fall through.  */
 	}
 
-	return 0;
+	WARN_ON(count != vcpu->arch.pio.count);
+	complete_emulator_pio_in(vcpu, size, port, val);
+	return 1;
 }
 
 static int emulator_pio_in_emulated(struct x86_emulate_ctxt *ctxt,
@@ -6965,12 +6977,11 @@ static int emulator_pio_out(struct kvm_vcpu *vcpu, int size,
 
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


