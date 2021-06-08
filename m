Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC7B39FFE9
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234863AbhFHShY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:37:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:57858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234851AbhFHSfW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:35:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D86F7613F4;
        Tue,  8 Jun 2021 18:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177136;
        bh=8NOjyvvQfL4HAU18FT1tzY1sJj2ikgSMgbfavif44Ac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y/FgJtspAC843d5nk+YRdORlTChBYkokDVgNShh2npZjU44w5QCaYn0YD9M4v2/59
         /xz9Qzgfp6RKPCTBIWBUNfGzW7DFZ4OH0uyq+l5CwgB6oEu/a3Qr9Mh/pPVMCP/7b0
         SZ8IRDRWUV/WmkxFXl12Il5nTG+Fc20Izt3xKgBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.14 45/47] KVM: SVM: Truncate GPR value for DR and CR accesses in !64-bit mode
Date:   Tue,  8 Jun 2021 20:27:28 +0200
Message-Id: <20210608175931.971396980@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175930.477274100@linuxfoundation.org>
References: <20210608175930.477274100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 0884335a2e653b8a045083aa1d57ce74269ac81d upstream.

Drop bits 63:32 on loads/stores to/from DRs and CRs when the vCPU is not
in 64-bit mode.  The APM states bits 63:32 are dropped for both DRs and
CRs:

  In 64-bit mode, the operand size is fixed at 64 bits without the need
  for a REX prefix. In non-64-bit mode, the operand size is fixed at 32
  bits and the upper 32 bits of the destination are forced to 0.

Fixes: 7ff76d58a9dc ("KVM: SVM: enhance MOV CR intercept handler")
Fixes: cae3797a4639 ("KVM: SVM: enhance mov DR intercept handler")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210422022128.3464144-4-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[sudip: manual backport to old file]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3532,7 +3532,7 @@ static int cr_interception(struct vcpu_s
 	err = 0;
 	if (cr >= 16) { /* mov to cr */
 		cr -= 16;
-		val = kvm_register_read(&svm->vcpu, reg);
+		val = kvm_register_readl(&svm->vcpu, reg);
 		switch (cr) {
 		case 0:
 			if (!check_selective_cr0_intercepted(svm, val))
@@ -3577,7 +3577,7 @@ static int cr_interception(struct vcpu_s
 			kvm_queue_exception(&svm->vcpu, UD_VECTOR);
 			return 1;
 		}
-		kvm_register_write(&svm->vcpu, reg, val);
+		kvm_register_writel(&svm->vcpu, reg, val);
 	}
 	return kvm_complete_insn_gp(&svm->vcpu, err);
 }
@@ -3607,13 +3607,13 @@ static int dr_interception(struct vcpu_s
 	if (dr >= 16) { /* mov to DRn */
 		if (!kvm_require_dr(&svm->vcpu, dr - 16))
 			return 1;
-		val = kvm_register_read(&svm->vcpu, reg);
+		val = kvm_register_readl(&svm->vcpu, reg);
 		kvm_set_dr(&svm->vcpu, dr - 16, val);
 	} else {
 		if (!kvm_require_dr(&svm->vcpu, dr))
 			return 1;
 		kvm_get_dr(&svm->vcpu, dr, &val);
-		kvm_register_write(&svm->vcpu, reg, val);
+		kvm_register_writel(&svm->vcpu, reg, val);
 	}
 
 	return kvm_skip_emulated_instruction(&svm->vcpu);


