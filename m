Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C831D6C1757
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbjCTPND (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232401AbjCTPMd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:12:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6473510265
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:07:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D44C61582
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:07:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD11C433EF;
        Mon, 20 Mar 2023 15:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324851;
        bh=pMg80H108ZnXFkQEBUO+XhK1yVzB2dQGtQ3ly/ZV6Zs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rOobjPLcmnLeZclREQy0eAQ6PaajC3fCdH8W+PLlG3SMBEdyXSqC6Jd+O5HafuSaQ
         JdcxTbWga8kSkVDB4tTD4rtArXkw6Yr10I1h/4Y/Q4vo76twNW/Nh3O4Fn+ya92jP5
         VUmrAoN3rZaxvbGgQlTCAhWu19JoEfQxLZj5E1Xw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Reima ISHII <ishiir@g.ecc.u-tokyo.ac.jp>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 65/99] KVM: nVMX: add missing consistency checks for CR0 and CR4
Date:   Mon, 20 Mar 2023 15:54:43 +0100
Message-Id: <20230320145446.122864603@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
References: <20230320145443.333824603@linuxfoundation.org>
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
@@ -2998,7 +2998,7 @@ static int nested_vmx_check_guest_state(
 					struct vmcs12 *vmcs12,
 					enum vm_entry_failure_code *entry_failure_code)
 {
-	bool ia32e;
+	bool ia32e = !!(vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE);
 
 	*entry_failure_code = ENTRY_FAIL_DEFAULT;
 
@@ -3024,6 +3024,13 @@ static int nested_vmx_check_guest_state(
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
@@ -3035,7 +3042,6 @@ static int nested_vmx_check_guest_state(
 	 */
 	if (to_vmx(vcpu)->nested.nested_run_pending &&
 	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_EFER)) {
-		ia32e = (vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE) != 0;
 		if (CC(!kvm_valid_efer(vcpu, vmcs12->guest_ia32_efer)) ||
 		    CC(ia32e != !!(vmcs12->guest_ia32_efer & EFER_LMA)) ||
 		    CC(((vmcs12->guest_cr0 & X86_CR0_PG) &&


