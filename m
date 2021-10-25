Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A05043A2FB
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237634AbhJYTza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:55:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:42076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237875AbhJYTv5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:51:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 817556112F;
        Mon, 25 Oct 2021 19:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635191017;
        bh=gPWUYlS9fee5QYFOoeLxtRQ9wXVi8zSc0CwmW131fvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ijuhJHrUCFUExA1Ar0fGrYmqL4db5EPRTlbBVR58VqBTpq0SbkQYN3xKT9If+ZMdG
         Qv9Rw2AHTbwD/HFV/QaFgU4GAGFqKzXMA9B+CRnQ3WFFWCwULU9p3vKIWQ3rSrYKHd
         JlHc5SzfdbYA6IaLdxd/1EvcelsfUVM+ptwvM4g8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.14 106/169] KVM: SEV-ES: rename guest_ins_data to sev_pio_data
Date:   Mon, 25 Oct 2021 21:14:47 +0200
Message-Id: <20211025191031.550186419@linuxfoundation.org>
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

commit b5998402e3de429b5e5f9bdea08ddf77c5fd661e upstream.

We will be using this field for OUTS emulation as well, in case the
data that is pushed via OUTS spans more than one page.  In that case,
there will be a need to save the data pointer across exits to userspace.

So, change the name to something that refers to any kind of PIO.
Also spell out what it is used for, namely SEV-ES.

No functional change intended.

Cc: stable@vger.kernel.org
Fixes: 7ed9abfe8e9f ("KVM: SVM: Support string IO operations for an SEV-ES guest")
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm_host.h |    2 +-
 arch/x86/kvm/x86.c              |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -695,7 +695,7 @@ struct kvm_vcpu_arch {
 
 	struct kvm_pio_request pio;
 	void *pio_data;
-	void *guest_ins_data;
+	void *sev_pio_data;
 
 	u8 event_exit_inst_len;
 
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12322,7 +12322,7 @@ EXPORT_SYMBOL_GPL(kvm_sev_es_mmio_read);
 
 static int complete_sev_es_emulated_ins(struct kvm_vcpu *vcpu)
 {
-	memcpy(vcpu->arch.guest_ins_data, vcpu->arch.pio_data,
+	memcpy(vcpu->arch.sev_pio_data, vcpu->arch.pio_data,
 	       vcpu->arch.pio.count * vcpu->arch.pio.size);
 	vcpu->arch.pio.count = 0;
 
@@ -12354,7 +12354,7 @@ static int kvm_sev_es_ins(struct kvm_vcp
 	if (ret) {
 		vcpu->arch.pio.count = 0;
 	} else {
-		vcpu->arch.guest_ins_data = data;
+		vcpu->arch.sev_pio_data = data;
 		vcpu->arch.complete_userspace_io = complete_sev_es_emulated_ins;
 	}
 


