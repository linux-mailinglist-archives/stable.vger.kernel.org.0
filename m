Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9210B54976B
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352587AbiFMLST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353700AbiFMLQO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:16:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA9F13DFE;
        Mon, 13 Jun 2022 03:39:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CB25B80EA3;
        Mon, 13 Jun 2022 10:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C35C34114;
        Mon, 13 Jun 2022 10:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116755;
        bh=fRSEYjLJ7Be73HlQ/cs2aJFJ4b+svUT2XGeKLFQDamY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QzeL4f4G5fedXNyk4NFBx1zU92P1HXtB2/5Y7ybj9QR36hh/zeC/t1mu0OWBMzTGx
         aeWsqfxOSDiBf2+fRtlyWsR4dC47/od1Ct1LarFFief3IL5bkf3JCGswUT2tJGKLbE
         LoSLwsJA/kvzA2hrqH+iKGthMjKLXnl1uOQC2xZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 162/411] KVM: nVMX: Leave most VM-Exit info fields unmodified on failed VM-Entry
Date:   Mon, 13 Jun 2022 12:07:15 +0200
Message-Id: <20220613094933.519497808@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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
index 3041015b05f7..9f61ae64b727 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3746,12 +3746,12 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	/* update exit information fields: */
 	vmcs12->vm_exit_reason = exit_reason;
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
 
@@ -3763,8 +3763,13 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
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



