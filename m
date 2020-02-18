Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 542701631E1
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbgBRUDR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:03:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:44388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728097AbgBRUDQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 15:03:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CBAF2467C;
        Tue, 18 Feb 2020 20:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582056195;
        bh=YF3VbNLAWeFow/GX9TNsqGP4ZhMFgY7IC8NXxq8Ui1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t6624u/OinVmb7i5KQG5nY0BBDtmF0XU9Jl7Hnk3znJIAQY5QRygy4dl6bZwL/JJW
         g27MvwSU2KTDXtGdIS6oO8M1xm3vQ0/8JCg3FY6uQSK9+PpugMNrscBGC5IOWmgCnA
         VUpl4w2J7ZqyDxIs3d3BiCh2LqaStoHboFFRes2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.5 70/80] KVM: nVMX: Handle pending #DB when injecting INIT VM-exit
Date:   Tue, 18 Feb 2020 20:55:31 +0100
Message-Id: <20200218190438.602113447@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190432.043414522@linuxfoundation.org>
References: <20200218190432.043414522@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Upton <oupton@google.com>

commit 684c0422da71da0cd81319c90b8099b563b13da4 upstream.

SDM 27.3.4 states that the 'pending debug exceptions' VMCS field will
be populated if a VM-exit caused by an INIT signal takes priority over a
debug-trap. Emulate this behavior when synthesizing an INIT signal
VM-exit into L1.

Fixes: 4b9852f4f389 ("KVM: x86: Fix INIT signal handling in various CPU states")
Signed-off-by: Oliver Upton <oupton@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx/nested.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3583,6 +3583,33 @@ static void nested_vmx_inject_exception_
 	nested_vmx_vmexit(vcpu, EXIT_REASON_EXCEPTION_NMI, intr_info, exit_qual);
 }
 
+/*
+ * Returns true if a debug trap is pending delivery.
+ *
+ * In KVM, debug traps bear an exception payload. As such, the class of a #DB
+ * exception may be inferred from the presence of an exception payload.
+ */
+static inline bool vmx_pending_dbg_trap(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.exception.pending &&
+			vcpu->arch.exception.nr == DB_VECTOR &&
+			vcpu->arch.exception.payload;
+}
+
+/*
+ * Certain VM-exits set the 'pending debug exceptions' field to indicate a
+ * recognized #DB (data or single-step) that has yet to be delivered. Since KVM
+ * represents these debug traps with a payload that is said to be compatible
+ * with the 'pending debug exceptions' field, write the payload to the VMCS
+ * field if a VM-exit is delivered before the debug trap.
+ */
+static void nested_vmx_update_pending_dbg(struct kvm_vcpu *vcpu)
+{
+	if (vmx_pending_dbg_trap(vcpu))
+		vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS,
+			    vcpu->arch.exception.payload);
+}
+
 static int vmx_check_nested_events(struct kvm_vcpu *vcpu, bool external_intr)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -3595,6 +3622,7 @@ static int vmx_check_nested_events(struc
 		test_bit(KVM_APIC_INIT, &apic->pending_events)) {
 		if (block_nested_events)
 			return -EBUSY;
+		nested_vmx_update_pending_dbg(vcpu);
 		clear_bit(KVM_APIC_INIT, &apic->pending_events);
 		nested_vmx_vmexit(vcpu, EXIT_REASON_INIT_SIGNAL, 0, 0);
 		return 0;


