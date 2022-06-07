Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF1E540685
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245226AbiFGRgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347023AbiFGReA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:34:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B743010636D;
        Tue,  7 Jun 2022 10:30:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88C326146F;
        Tue,  7 Jun 2022 17:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C75C385A5;
        Tue,  7 Jun 2022 17:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623025;
        bh=OtaDK/9/4CC4FHBdDAyjx3QgzFKJf/bhVbyteYso/MM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t2CnDW2CJ9iqUrkgbG8lGhE8IPJQtgMjeIcgvB+CPDn5Od7A3ICY1FlZmQtkFZNI1
         qU0c+8V/C+YLTP2GofeZdMAUUe/L21TZXduS9wH2xPd3HNZxVR4vTi34DkjKKUpuSa
         xNIdpAhcy9oOUNPELHVXVgqlwZTVXFreObXpFDd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 268/452] KVM: nVMX: Leave most VM-Exit info fields unmodified on failed VM-Entry
Date:   Tue,  7 Jun 2022 19:02:05 +0200
Message-Id: <20220607164916.538546527@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit c3634d25fbee88e2368a8e0903ae0d0670eb9e71 ]

Don't modify vmcs12 exit fields except EXIT_REASON and EXIT_QUALIFICATION
when performing a nested VM-Exit due to failed VM-Entry.  Per the SDM,
only the two aformentioned fields are filled and "All other VM-exit
information fields are unmodified".

Fixes: 4704d0befb07 ("KVM: nVMX: Exiting from L2 to L1")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220407002315.78092-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0c2389d0fdaf..fe53cab1a8a6 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4143,12 +4143,12 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	/* update exit information fields: */
 	vmcs12->vm_exit_reason = vm_exit_reason;
 	vmcs12->exit_qualification = exit_qualification;
-	vmcs12->vm_exit_intr_info = exit_intr_info;
-
-	vmcs12->idt_vectoring_info_field = 0;
-	vmcs12->vm_exit_instruction_len = vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
-	vmcs12->vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
 
+	/*
+	 * On VM-Exit due to a failed VM-Entry, the VMCS isn't marked launched
+	 * and only EXIT_REASON and EXIT_QUALIFICATION are updated, all other
+	 * exit info fields are unmodified.
+	 */
 	if (!(vmcs12->vm_exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY)) {
 		vmcs12->launch_state = 1;
 
@@ -4160,8 +4160,13 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 		 * Transfer the event that L0 or L1 may wanted to inject into
 		 * L2 to IDT_VECTORING_INFO_FIELD.
 		 */
+		vmcs12->idt_vectoring_info_field = 0;
 		vmcs12_save_pending_event(vcpu, vmcs12);
 
+		vmcs12->vm_exit_intr_info = exit_intr_info;
+		vmcs12->vm_exit_instruction_len = vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
+		vmcs12->vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
+
 		/*
 		 * According to spec, there's no need to store the guest's
 		 * MSRs if the exit is due to a VM-entry failure that occurs
-- 
2.35.1



