Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B00843A2FA
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237362AbhJYTza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:55:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:42078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237878AbhJYTv5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:51:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EDFB60E8F;
        Mon, 25 Oct 2021 19:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635191021;
        bh=Zpd5mQ1Uz1WX1EIg+Aw8Xx2pYmiCKp1KX8iOMp/Y+2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nQ0KHV3WGkhJtR7/VnRDMBSnFDuvlaebDAA0y8FWlWFYT6+sn1rFVInxtNaxZ5yxg
         fFsqb1ov1kzNAO681nX+rtxd6+8FR4ArxyK1IE4+/8gq/LFVm6oXTXMzTmbnYEGZnY
         EmDB/wPM7MNlfMnFsAgUQz6KI7YQ0tVT2PbVQLJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.14 107/169] KVM: SEV-ES: clean up kvm_sev_es_ins/outs
Date:   Mon, 25 Oct 2021 21:14:48 +0200
Message-Id: <20211025191031.660457753@linuxfoundation.org>
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

commit ea724ea420aac58b41bc822d1aed6940b136b78d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12330,34 +12330,32 @@ static int complete_sev_es_emulated_ins(
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
 
@@ -12365,8 +12363,9 @@ int kvm_sev_es_string_io(struct kvm_vcpu
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
 


