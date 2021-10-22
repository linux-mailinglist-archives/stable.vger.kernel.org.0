Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950B6437A0D
	for <lists+stable@lfdr.de>; Fri, 22 Oct 2021 17:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233508AbhJVPit (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Oct 2021 11:38:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52789 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233484AbhJVPis (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Oct 2021 11:38:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634916990;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q0CvSslHDevyrnR+8XQKuDPFSDw/2SdQ3R2X/xAGlqw=;
        b=JEnulUxJtRLRs+/4osS09cZzPocXMPGwgXJMfAQ/Znf8Lr6RtTgyGvRhC3O+MWkGWmVRxk
        0HGw5evyS2Jxp8MN7/yLnElGWCt+A/s81F8WKlITfiWjTu3lZtpNiHRhWjD+0/7mrWffa0
        r08BVy/BuwD2GGfE9DiqhqsjFuRXfVI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372-0-vLUh74O7mOlrhfeVrJQg-1; Fri, 22 Oct 2021 11:36:27 -0400
X-MC-Unique: 0-vLUh74O7mOlrhfeVrJQg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 05E531006AA5;
        Fri, 22 Oct 2021 15:36:26 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D6BD60C04;
        Fri, 22 Oct 2021 15:36:25 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com, seanjc@google.com, stable@vger.kernel.org,
        Felix Wilhelm <fwilhelm@google.com>
Subject: [PATCH 07/13] KVM: SEV-ES: go over the sev_pio_data buffer in multiple passes if needed
Date:   Fri, 22 Oct 2021 11:36:10 -0400
Message-Id: <20211022153616.1722429-8-pbonzini@redhat.com>
In-Reply-To: <20211022153616.1722429-1-pbonzini@redhat.com>
References: <20211022153616.1722429-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The PIO scratch buffer is larger than a single page, and therefore
it is not possible to copy it in a single step to vcpu->arch/pio_data.
Bound each call to emulator_pio_in/out to a single page; keep
track of how many I/O operations are left in vcpu->arch.sev_pio_count,
so that the operation can be restarted in the complete_userspace_io
callback.

For OUT, this means that the previous kvm_sev_es_outs implementation
becomes an iterator of the loop, and we can consume the sev_pio_data
buffer before leaving to userspace.

For IN, instead, consuming the buffer and decreasing sev_pio_count
is always done in the complete_userspace_io callback, because that
is when the memcpy is done into sev_pio_data.

Cc: stable@vger.kernel.org
Fixes: 7ed9abfe8e9f ("KVM: SVM: Support string IO operations for an SEV-ES guest")
Reported-by: Felix Wilhelm <fwilhelm@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 72 +++++++++++++++++++++++++--------
 2 files changed, 57 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6bed6c416c6c..5a0298aa56ba 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -703,6 +703,7 @@ struct kvm_vcpu_arch {
 	struct kvm_pio_request pio;
 	void *pio_data;
 	void *sev_pio_data;
+	unsigned sev_pio_count;
 
 	u8 event_exit_inst_len;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 23e772412134..b26647a5ea22 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12386,38 +12386,77 @@ int kvm_sev_es_mmio_read(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned int bytes,
 EXPORT_SYMBOL_GPL(kvm_sev_es_mmio_read);
 
 static int kvm_sev_es_outs(struct kvm_vcpu *vcpu, unsigned int size,
-			   unsigned int port, unsigned int count)
+			   unsigned int port);
+
+static int complete_sev_es_emulated_outs(struct kvm_vcpu *vcpu)
 {
-	int ret = emulator_pio_out(vcpu, size, port,
-				   vcpu->arch.sev_pio_data, count);
+	int size = vcpu->arch.pio.size;
+	int port = vcpu->arch.pio.port;
+
+	vcpu->arch.pio.count = 0;
+	if (vcpu->arch.sev_pio_count)
+		return kvm_sev_es_outs(vcpu, size, port);
+	return 1;
+}
+
+static int kvm_sev_es_outs(struct kvm_vcpu *vcpu, unsigned int size,
+			   unsigned int port)
+{
+	for (;;) {
+		unsigned int count =
+			min_t(unsigned int, PAGE_SIZE / size, vcpu->arch.sev_pio_count);
+		int ret = emulator_pio_out(vcpu, size, port, vcpu->arch.sev_pio_data, count);
+
+		/* memcpy done already by emulator_pio_out.  */
+		vcpu->arch.sev_pio_count -= count;
+		vcpu->arch.sev_pio_data += count * vcpu->arch.pio.size;
+		if (!ret)
+			break;
 
-	if (ret) {
 		/* Emulation done by the kernel.  */
-		return ret;
+		if (!vcpu->arch.sev_pio_count)
+			return 1;
 	}
 
-	vcpu->arch.pio.count = 0;
+	vcpu->arch.complete_userspace_io = complete_sev_es_emulated_outs;
 	return 0;
 }
 
+static int kvm_sev_es_ins(struct kvm_vcpu *vcpu, unsigned int size,
+			  unsigned int port);
+
+static void advance_sev_es_emulated_ins(struct kvm_vcpu *vcpu)
+{
+	unsigned count = vcpu->arch.pio.count;
+	complete_emulator_pio_in(vcpu, vcpu->arch.sev_pio_data);
+	vcpu->arch.sev_pio_count -= count;
+	vcpu->arch.sev_pio_data += count * vcpu->arch.pio.size;
+}
+
 static int complete_sev_es_emulated_ins(struct kvm_vcpu *vcpu)
 {
-	memcpy(vcpu->arch.sev_pio_data, vcpu->arch.pio_data,
-	       vcpu->arch.pio.count * vcpu->arch.pio.size);
-	vcpu->arch.pio.count = 0;
+	int size = vcpu->arch.pio.size;
+	int port = vcpu->arch.pio.port;
 
+	advance_sev_es_emulated_ins(vcpu);
+	if (vcpu->arch.sev_pio_count)
+		return kvm_sev_es_ins(vcpu, size, port);
 	return 1;
 }
 
 static int kvm_sev_es_ins(struct kvm_vcpu *vcpu, unsigned int size,
-			  unsigned int port, unsigned int count)
+			  unsigned int port)
 {
-	int ret = emulator_pio_in(vcpu, size, port,
-				  vcpu->arch.sev_pio_data, count);
+	for (;;) {
+		unsigned int count =
+			min_t(unsigned int, PAGE_SIZE / size, vcpu->arch.sev_pio_count);
+		if (!__emulator_pio_in(vcpu, size, port, count))
+			break;
 
-	if (ret) {
 		/* Emulation done by the kernel.  */
-		return ret;
+		advance_sev_es_emulated_ins(vcpu);
+		if (!vcpu->arch.sev_pio_count)
+			return 1;
 	}
 
 	vcpu->arch.complete_userspace_io = complete_sev_es_emulated_ins;
@@ -12429,8 +12468,9 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 			 int in)
 {
 	vcpu->arch.sev_pio_data = data;
-	return in ? kvm_sev_es_ins(vcpu, size, port, count)
-		  : kvm_sev_es_outs(vcpu, size, port, count);
+	vcpu->arch.sev_pio_count = count;
+	return in ? kvm_sev_es_ins(vcpu, size, port)
+		  : kvm_sev_es_outs(vcpu, size, port);
 }
 EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
 
-- 
2.27.0


