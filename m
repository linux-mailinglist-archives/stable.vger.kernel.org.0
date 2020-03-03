Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 437EE1780BB
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387403AbgCCR63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:58:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:41324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732859AbgCCR63 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:58:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D80A20728;
        Tue,  3 Mar 2020 17:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258308;
        bh=008dOLlFKIktXb24OrvAG80tGZUu59mSd3sOA31cZbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fKiL6KENobMFploB8KNNeJM7EbFKtPad30XeQrBiaJvVs4jRpDNUScNZqxLsPEvb9
         egTIVO5Z7+zmziBnfLSQHENjAU3j0dmbxuvI46+Vvy8vf5sHrqgaHk5i18IFtEXsTY
         xgr5aay1GyCJuoaehmNOkd2lsNUOoA1ncsAa5JKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Jon Cargille <jcargill@google.com>
Subject: [PATCH 5.4 152/152] kvm: nVMX: VMWRITE checks unsupported field before read-only field
Date:   Tue,  3 Mar 2020 18:44:10 +0100
Message-Id: <20200303174320.103888736@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Mattson <jmattson@google.com>

commit 693e02cc24090c379217138719d9d84e50036b24 upstream.

According to the SDM, VMWRITE checks to see if the secondary source
operand corresponds to an unsupported VMCS field before it checks to
see if the secondary source operand corresponds to a VM-exit
information field and the processor does not support writing to
VM-exit information fields.

Fixes: 49f705c5324aa ("KVM: nVMX: Implement VMREAD and VMWRITE")
Signed-off-by: Jim Mattson <jmattson@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Jon Cargille <jcargill@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx/nested.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4741,6 +4741,12 @@ static int handle_vmwrite(struct kvm_vcp
 
 
 	field = kvm_register_readl(vcpu, (((vmx_instruction_info) >> 28) & 0xf));
+
+	offset = vmcs_field_to_offset(field);
+	if (offset < 0)
+		return nested_vmx_failValid(vcpu,
+			VMXERR_UNSUPPORTED_VMCS_COMPONENT);
+
 	/*
 	 * If the vCPU supports "VMWRITE to any supported field in the
 	 * VMCS," then the "read-only" fields are actually read/write.
@@ -4757,11 +4763,6 @@ static int handle_vmwrite(struct kvm_vcp
 	if (!is_guest_mode(vcpu) && !is_shadow_field_rw(field))
 		copy_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
 
-	offset = vmcs_field_to_offset(field);
-	if (offset < 0)
-		return nested_vmx_failValid(vcpu,
-			VMXERR_UNSUPPORTED_VMCS_COMPONENT);
-
 	/*
 	 * Some Intel CPUs intentionally drop the reserved bits of the AR byte
 	 * fields on VMWRITE.  Emulate this behavior to ensure consistent KVM


