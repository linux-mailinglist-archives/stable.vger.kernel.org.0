Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79363437A0A
	for <lists+stable@lfdr.de>; Fri, 22 Oct 2021 17:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbhJVPis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Oct 2021 11:38:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57506 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233424AbhJVPiq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Oct 2021 11:38:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634916988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nYJhDUMIScdehYmXJpQ+Hb2cNtVotvJbnpVuRYHeaZo=;
        b=IpchU4XqfS01O1Fa1MsD3VOy4X2IykwowyJ60CxQ3CngG3g6KgtUEGZB44hvKeWavfcA7h
        iWlU3vuA6XZ2ZtrIAwqzg1e00IE+oA6l/7hSCAepibPErEwgvQgKQFEUqCcExL6SJFW0t0
        hxl3ZVF19k1e9e4piO6AcWcuXwCI510=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-GfYhB6faONGUwwl0N4_EZA-1; Fri, 22 Oct 2021 11:36:24 -0400
X-MC-Unique: GfYhB6faONGUwwl0N4_EZA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B096C8030B7;
        Fri, 22 Oct 2021 15:36:23 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4362560C13;
        Fri, 22 Oct 2021 15:36:23 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com, seanjc@google.com, stable@vger.kernel.org
Subject: [PATCH 03/13] KVM: SEV-ES: clean up kvm_sev_es_ins/outs
Date:   Fri, 22 Oct 2021 11:36:06 -0400
Message-Id: <20211022153616.1722429-4-pbonzini@redhat.com>
In-Reply-To: <20211022153616.1722429-1-pbonzini@redhat.com>
References: <20211022153616.1722429-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A few very small cleanups to the functions, smushed together because
the patch is already very small like this:

- inline emulator_pio_in_emulated and emulator_pio_out_emulated,
  since we already have the vCPU

- remove the data argument and pull setting vcpu->arch.sev_pio_data into
  the caller

- remove unnecessary clearing of vcpu->arch.pio.count when
  emulation is done by the kernel (and therefore vcpu->arch.pio.count
  is already clear on exit from emulator_pio_in and emulator_pio_out).

No functional change intended.

Cc: stable@vger.kernel.org
Fixes: 7ed9abfe8e9f ("KVM: SVM: Support string IO operations for an SEV-ES guest")
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dff28a4fbb21..78ed0fe9fa1e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12383,34 +12383,32 @@ static int complete_sev_es_emulated_ins(struct kvm_vcpu *vcpu)
 }
 
 static int kvm_sev_es_outs(struct kvm_vcpu *vcpu, unsigned int size,
-			   unsigned int port, void *data,  unsigned int count)
+			   unsigned int port, unsigned int count)
 {
-	int ret;
+	int ret = emulator_pio_out(vcpu, size, port,
+				   vcpu->arch.sev_pio_data, count);
 
-	ret = emulator_pio_out_emulated(vcpu->arch.emulate_ctxt, size, port,
-					data, count);
-	if (ret)
+	if (ret) {
+		/* Emulation done by the kernel.  */
 		return ret;
+	}
 
 	vcpu->arch.pio.count = 0;
-
 	return 0;
 }
 
 static int kvm_sev_es_ins(struct kvm_vcpu *vcpu, unsigned int size,
-			  unsigned int port, void *data, unsigned int count)
+			  unsigned int port, unsigned int count)
 {
-	int ret;
+	int ret = emulator_pio_in(vcpu, size, port,
+				  vcpu->arch.sev_pio_data, count);
 
-	ret = emulator_pio_in_emulated(vcpu->arch.emulate_ctxt, size, port,
-				       data, count);
 	if (ret) {
-		vcpu->arch.pio.count = 0;
-	} else {
-		vcpu->arch.sev_pio_data = data;
-		vcpu->arch.complete_userspace_io = complete_sev_es_emulated_ins;
+		/* Emulation done by the kernel.  */
+		return ret;
 	}
 
+	vcpu->arch.complete_userspace_io = complete_sev_es_emulated_ins;
 	return 0;
 }
 
@@ -12418,8 +12416,9 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 			 unsigned int port, void *data,  unsigned int count,
 			 int in)
 {
-	return in ? kvm_sev_es_ins(vcpu, size, port, data, count)
-		  : kvm_sev_es_outs(vcpu, size, port, data, count);
+	vcpu->arch.sev_pio_data = data;
+	return in ? kvm_sev_es_ins(vcpu, size, port, count)
+		  : kvm_sev_es_outs(vcpu, size, port, count);
 }
 EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
 
-- 
2.27.0


