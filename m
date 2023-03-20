Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD556C1933
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233084AbjCTPbp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232710AbjCTPbZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:31:25 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE21305F3
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:23:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A3189CE12E9
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:23:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B77CC4339B;
        Mon, 20 Mar 2023 15:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325825;
        bh=uq28ypyHXCnhKkAPCWvExcHXdkwRSN6lB7C39oNqNDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iaHlZeeSrnHmg+5erxqEAtKKNd9DKWQ8nKaeYserp3D1F/d9270uo6yLXFsSX5Ajb
         puDtFr+/g92lEnxwzdspE//KeSX9FLcxIiUJi9IiVpvGvkW0+V7B1WTleKHf816SIq
         6HpxCSdshoCUljepFGjxC7w4+lOBTvs1OthGuWPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Reima ISHII <ishiir@g.ecc.u-tokyo.ac.jp>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.1 149/198] KVM: nVMX: add missing consistency checks for CR0 and CR4
Date:   Mon, 20 Mar 2023 15:54:47 +0100
Message-Id: <20230320145513.800963566@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 112e66017bff7f2837030f34c2bc19501e9212d5 upstream.

The effective values of the guest CR0 and CR4 registers may differ from
those included in the VMCS12.  In particular, disabling EPT forces
CR4.PAE=1 and disabling unrestricted guest mode forces CR0.PG=CR0.PE=1.

Therefore, checks on these bits cannot be delegated to the processor
and must be performed by KVM.

Reported-by: Reima ISHII <ishiir@g.ecc.u-tokyo.ac.jp>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2999,7 +2999,7 @@ static int nested_vmx_check_guest_state(
 					struct vmcs12 *vmcs12,
 					enum vm_entry_failure_code *entry_failure_code)
 {
-	bool ia32e;
+	bool ia32e = !!(vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE);
 
 	*entry_failure_code = ENTRY_FAIL_DEFAULT;
 
@@ -3025,6 +3025,13 @@ static int nested_vmx_check_guest_state(
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
@@ -3036,7 +3043,6 @@ static int nested_vmx_check_guest_state(
 	 */
 	if (to_vmx(vcpu)->nested.nested_run_pending &&
 	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_EFER)) {
-		ia32e = (vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE) != 0;
 		if (CC(!kvm_valid_efer(vcpu, vmcs12->guest_ia32_efer)) ||
 		    CC(ia32e != !!(vmcs12->guest_ia32_efer & EFER_LMA)) ||
 		    CC(((vmcs12->guest_cr0 & X86_CR0_PG) &&


