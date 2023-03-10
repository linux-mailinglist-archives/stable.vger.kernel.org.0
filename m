Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31EBF6B55E4
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 00:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbjCJXoM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 18:44:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbjCJXn5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 18:43:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AEB97AA6
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:43:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678491789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=CItiKWqjEFyVHtEXbQCIcOVc9Rye/Ry28d+d9WjUAEQ=;
        b=ioPhK1yT3SxzdXVT4WE4iA9DctJJZfHhZ9ilpVRkAveYuXr2jswrpJ/lVNDbQCOq4y15DE
        hKl0OZbvqaQmJOpNMcXa931u/DbzEZds/5TjS8qkPYz76LKcHayQct1dDVty6zU4EljWcD
        8mL+prxMNgHxAhSwv5iq7/eL8arO+tY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-PhfRdPegO06_zVT9DIbu9g-1; Fri, 10 Mar 2023 18:43:05 -0500
X-MC-Unique: PhfRdPegO06_zVT9DIbu9g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F0C09185A794;
        Fri, 10 Mar 2023 23:43:04 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A1F242026D4B;
        Fri, 10 Mar 2023 23:43:04 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Reima ISHII <ishiir@g.ecc.u-tokyo.ac.jp>, stable@vger.kernel.org
Subject: [PATCH] KVM: nVMX: add missing consistency checks for CR0 and CR4
Date:   Fri, 10 Mar 2023 18:43:04 -0500
Message-Id: <20230310234304.2908714-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
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
 arch/x86/kvm/vmx/nested.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d93c715cda6a..43693e4772ff 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3047,6 +3047,19 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 					   vmcs12->guest_ia32_perf_global_ctrl)))
 		return -EINVAL;
 
+	if (CC((vmcs12->guest_cr0 & (X86_CR0_PG | X86_CR0_PE)) == X86_CR0_PG))
+		return -EINVAL;
+
+#ifdef CONFIG_X86_64
+	ia32e = !!(vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE);
+#else
+	ia32e = false;
+#endif
+	if (CC(ia32e &&
+	       (!(vmcs12->guest_cr4 & X86_CR4_PAE) ||
+		!(vmcs12->guest_cr0 & X86_CR0_PG))))
+		return -EINVAL;
+
 	/*
 	 * If the load IA32_EFER VM-entry control is 1, the following checks
 	 * are performed on the field for the IA32_EFER MSR:
@@ -3058,7 +3071,6 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 	 */
 	if (to_vmx(vcpu)->nested.nested_run_pending &&
 	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_EFER)) {
-		ia32e = (vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE) != 0;
 		if (CC(!kvm_valid_efer(vcpu, vmcs12->guest_ia32_efer)) ||
 		    CC(ia32e != !!(vmcs12->guest_ia32_efer & EFER_LMA)) ||
 		    CC(((vmcs12->guest_cr0 & X86_CR0_PG) &&
-- 
2.39.1

