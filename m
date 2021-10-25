Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E3243A302
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236073AbhJYTze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:55:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237510AbhJYTwl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:52:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F973611C3;
        Mon, 25 Oct 2021 19:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635191035;
        bh=XAZI9IdXUAp0hXWlvq+dsmpgWWX95+qTDj/WBP7VN50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q74XeOCxLdv7Lr99mhjlpOu2KIrn9vewFlRrJEwojiAdHyhFiSqUh6CW3MBngQSi0
         LqC5SUVDlEOrlYUU7VYIewvobEYQCwZmx4ujuX6U5yFk9Od7LGVWgIHfSi6ehV5Afo
         bjtcwNi1FoaBa6aaEvhPanFw8S44i9ggEzygomEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Wilhelm <fwilhelm@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.14 110/169] KVM: SEV-ES: go over the sev_pio_data buffer in multiple passes if needed
Date:   Mon, 25 Oct 2021 21:14:51 +0200
Message-Id: <20211025191031.990100427@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 95e16b4792b0429f1933872f743410f00e590c55 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm_host.h |    1 
 arch/x86/kvm/x86.c              |   72 +++++++++++++++++++++++++++++++---------
 2 files changed, 57 insertions(+), 16 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -696,6 +696,7 @@ struct kvm_vcpu_arch {
 	struct kvm_pio_request pio;
 	void *pio_data;
 	void *sev_pio_data;
+	unsigned sev_pio_count;
 
 	u8 event_exit_inst_len;
 
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12321,38 +12321,77 @@ int kvm_sev_es_mmio_read(struct kvm_vcpu
 EXPORT_SYMBOL_GPL(kvm_sev_es_mmio_read);
 
 static int kvm_sev_es_outs(struct kvm_vcpu *vcpu, unsigned int size,
-			   unsigned int port, unsigned int count)
+			   unsigned int port);
+
+static int complete_sev_es_emulated_outs(struct kvm_vcpu *vcpu)
+{
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
 {
-	int ret = emulator_pio_out(vcpu, size, port,
-				   vcpu->arch.sev_pio_data, count);
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
@@ -12364,8 +12403,9 @@ int kvm_sev_es_string_io(struct kvm_vcpu
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
 


