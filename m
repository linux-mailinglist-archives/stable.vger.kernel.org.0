Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 448FF6B928E
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 13:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbjCNMDg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 08:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbjCNMDd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 08:03:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA2759823
        for <stable@vger.kernel.org>; Tue, 14 Mar 2023 05:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678795208;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=wUnI4l1fJIq39Iu/vgThoYTI/vSFozVCmS4t49sYC3A=;
        b=IrFcbeWzuhVdrMWQtkAf8jE9HaYo3WUA5HTtenG/W/djtAfis7e40R1oE8Quv6Y2yF8Yr9
        Ybamt3gQVT5eebnW6f5Ugkg2RGSShS3JQCJjmKFNoLS5vWZZlZHKy06tqH+347/luAZYag
        3rFEOob9iiawVQbYJ2kiZ63l+FrYqwg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-457-dLSejJJQPByT080Bi69ygg-1; Tue, 14 Mar 2023 08:00:06 -0400
X-MC-Unique: dLSejJJQPByT080Bi69ygg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1CDDF18E6C5B;
        Tue, 14 Mar 2023 12:00:04 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C1F2D400F4F;
        Tue, 14 Mar 2023 12:00:03 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Reima ISHII <ishiir@g.ecc.u-tokyo.ac.jp>, stable@vger.kernel.org
Subject: [PATCH v2] KVM: nVMX: add missing consistency checks for CR0 and CR4
Date:   Tue, 14 Mar 2023 08:00:03 -0400
Message-Id: <20230314120003.3038323-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The effective values of the guest CR0 and CR4 registers may differ from
those included in the VMCS12.  In particular, disabling EPT forces
CR4.PAE=1 and disabling unrestricted guest mode forces CR0.PG=CR0.PE=1.

Therefore, checks on these bits cannot be delegated to the processor
and must be performed by KVM.

Reported-by: Reima ISHII <ishiir@g.ecc.u-tokyo.ac.jp>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d93c715cda6a..bceb5ad409c6 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3021,7 +3021,7 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 					struct vmcs12 *vmcs12,
 					enum vm_entry_failure_code *entry_failure_code)
 {
-	bool ia32e;
+	bool ia32e = !!(vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE);
 
 	*entry_failure_code = ENTRY_FAIL_DEFAULT;
 
@@ -3047,6 +3047,13 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 					   vmcs12->guest_ia32_perf_global_ctrl)))
 		return -EINVAL;
 
+	if (CC((vmcs12->guest_cr0 & (X86_CR0_PG | X86_CR0_PE)) == X86_CR0_PG))
+		return -EINVAL;
+
+	if (CC(ia32e && !(vmcs12->guest_cr4 & X86_CR4_PAE)) ||
+	    CC(ia32e && !(vmcs12->guest_cr0 & X86_CR0_PG)))
+		return -EINVAL;
+
 	/*
 	 * If the load IA32_EFER VM-entry control is 1, the following checks
 	 * are performed on the field for the IA32_EFER MSR:
@@ -3058,7 +3065,6 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 	 */
 	if (to_vmx(vcpu)->nested.nested_run_pending &&
 	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_EFER)) {
-		ia32e = (vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE) != 0;
 		if (CC(!kvm_valid_efer(vcpu, vmcs12->guest_ia32_efer)) ||
 		    CC(ia32e != !!(vmcs12->guest_ia32_efer & EFER_LMA)) ||
 		    CC(((vmcs12->guest_cr0 & X86_CR0_PG) &&
-- 
2.39.1

