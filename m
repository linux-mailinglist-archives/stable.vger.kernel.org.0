Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4DC858FED7
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234731AbiHKPKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiHKPKJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:10:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE147B793
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 08:10:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE57C615D9
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 15:10:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E93C433D6;
        Thu, 11 Aug 2022 15:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660230608;
        bh=J/rzHPho0LhyPnArBxB1bo093cud4H8ZQVPc8HZH6hM=;
        h=Subject:To:Cc:From:Date:From;
        b=aXnrhIADCVe4SDJwAvaoxHXmaWFbatykFBSLil0wVbBK0bUq+Z5Ve2CJlhxN+X5vQ
         2RnrhVVT+6Jdj1jyqNJbhvxyhUUdy7aLGK49R67lgC7BfOj9e+AA28HAswU2JFGGc6
         ft2sa3J7mL1JYUcf+swOm+YLuH8lKs8+eQ+7aXfg=
Subject: FAILED: patch "[PATCH] KVM: nVMX: Snapshot pre-VM-Enter DEBUGCTL for" failed to apply to 4.19-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Aug 2022 17:10:05 +0200
Message-ID: <16602306058091@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 764643a6be07445308e492a528197044c801b3ba Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 14 Jun 2022 21:58:28 +0000
Subject: [PATCH] KVM: nVMX: Snapshot pre-VM-Enter DEBUGCTL for
 !nested_run_pending case

If a nested run isn't pending, snapshot vmcs01.GUEST_IA32_DEBUGCTL
irrespective of whether or not VM_ENTRY_LOAD_DEBUG_CONTROLS is set in
vmcs12.  When restoring nested state, e.g. after migration, without a
nested run pending, prepare_vmcs02() will propagate
nested.vmcs01_debugctl to vmcs02, i.e. will load garbage/zeros into
vmcs02.GUEST_IA32_DEBUGCTL.

If userspace restores nested state before MSRs, then loading garbage is a
non-issue as loading DEBUGCTL will also update vmcs02.  But if usersepace
restores MSRs first, then KVM is responsible for propagating L2's value,
which is actually thrown into vmcs01, into vmcs02.

Restoring L2 MSRs into vmcs01, i.e. loading all MSRs before nested state
is all kinds of bizarre and ideally would not be supported.  Sadly, some
VMMs do exactly that and rely on KVM to make things work.

Note, there's still a lurking SMM bug, as propagating vmcs01's DEBUGCTL
to vmcs02 across RSM may corrupt L2's DEBUGCTL.  But KVM's entire VMX+SMM
emulation is flawed as SMI+RSM should not toouch _any_ VMCS when use the
"default treatment of SMIs", i.e. when not using an SMI Transfer Monitor.

Link: https://lore.kernel.org/all/Yobt1XwOfb5M6Dfa@google.com
Fixes: 8fcc4b5923af ("kvm: nVMX: Introduce KVM_CAP_NESTED_STATE")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220614215831.3762138-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 66c25bb56938..4a53e0c73445 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3379,7 +3379,8 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	if (likely(!evaluate_pending_interrupts) && kvm_vcpu_apicv_active(vcpu))
 		evaluate_pending_interrupts |= vmx_has_apicv_interrupt(vcpu);
 
-	if (!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
+	if (!vmx->nested.nested_run_pending ||
+	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
 		vmx->nested.vmcs01_debugctl = vmcs_read64(GUEST_IA32_DEBUGCTL);
 	if (kvm_mpx_supported() &&
 	    (!vmx->nested.nested_run_pending ||

