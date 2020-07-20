Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95353226B63
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729615AbgGTPpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:45:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729621AbgGTPo5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:44:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0A292064B;
        Mon, 20 Jul 2020 15:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259897;
        bh=LJUl+vg1sUAgM3/aWo+82X5SN5T2AVXyXPOjZo5Upcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fyTJkPJtmfFUa1FKXpKLBS1dGIkjN9nGjIFpTtXP+ZV0E/wNEl0VvZEuDy3uuBnQR
         uFl3DwPEhungTyiYhOGm+Pgcuu+yqVJWQYY5uchefKajlqkkMYLybnpdJORswGxoTx
         i96we0FDdUpun7J3NdB3zllsrAcqDlHUs6znopPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.14 033/125] KVM: x86: Mark CR4.TSD as being possibly owned by the guest
Date:   Mon, 20 Jul 2020 17:36:12 +0200
Message-Id: <20200720152804.584712772@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152802.929969555@linuxfoundation.org>
References: <20200720152802.929969555@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit 7c83d096aed055a7763a03384f92115363448b71 upstream.

Mark CR4.TSD as being possibly owned by the guest as that is indeed the
case on VMX.  Without TSD being tagged as possibly owned by the guest, a
targeted read of CR4 to get TSD could observe a stale value.  This bug
is benign in the current code base as the sole consumer of TSD is the
emulator (for RDTSC) and the emulator always "reads" the entirety of CR4
when grabbing bits.

Add a build-time assertion in to ensure VMX doesn't hand over more CR4
bits without also updating x86.

Fixes: 52ce3c21aec3 ("x86,kvm,vmx: Don't trap writes to CR4.TSD")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Message-Id: <20200703040422.31536-2-sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/kvm_cache_regs.h |    2 +-
 arch/x86/kvm/vmx.c            |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -5,7 +5,7 @@
 #define KVM_POSSIBLE_CR0_GUEST_BITS X86_CR0_TS
 #define KVM_POSSIBLE_CR4_GUEST_BITS				  \
 	(X86_CR4_PVI | X86_CR4_DE | X86_CR4_PCE | X86_CR4_OSFXSR  \
-	 | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_PGE)
+	 | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_PGE | X86_CR4_TSD)
 
 static inline unsigned long kvm_register_read(struct kvm_vcpu *vcpu,
 					      enum kvm_reg reg)
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5592,6 +5592,8 @@ static void vmx_set_constant_host_state(
 
 static void set_cr4_guest_host_mask(struct vcpu_vmx *vmx)
 {
+	BUILD_BUG_ON(KVM_CR4_GUEST_OWNED_BITS & ~KVM_POSSIBLE_CR4_GUEST_BITS);
+
 	vmx->vcpu.arch.cr4_guest_owned_bits = KVM_CR4_GUEST_OWNED_BITS;
 	if (enable_ept)
 		vmx->vcpu.arch.cr4_guest_owned_bits |= X86_CR4_PGE;


