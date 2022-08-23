Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A89F559E279
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357110AbiHWLIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357399AbiHWLGu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:06:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1366F87093;
        Tue, 23 Aug 2022 02:16:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFCB1B81B1F;
        Tue, 23 Aug 2022 09:15:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48F2C433D6;
        Tue, 23 Aug 2022 09:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246136;
        bh=hu5TMgyBsQA+JM/nI10zy36YytDpLDwYhOtqzJPDFNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VTbXdj/oWFCl/SKX+NOkTq77QJb/f/he1XjP3vPYKzWy5NzpZuSOee0NTG09OCRj5
         Lq5rV2CeVBRtNSdbaZ8bfvQwdx2Ff62Ul7WXsGqbrRw0QlqOUsA4ZA3Yc2TMiNOQOK
         TGUoWfHBx3ZYoqRz7j4mEfZLuHJJBxmZI0igQqJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.4 013/389] KVM: nVMX: Snapshot pre-VM-Enter DEBUGCTL for !nested_run_pending case
Date:   Tue, 23 Aug 2022 10:21:31 +0200
Message-Id: <20220823080116.238840165@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 764643a6be07445308e492a528197044c801b3ba upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3065,7 +3065,8 @@ enum nvmx_vmentry_status nested_vmx_ente
 	if (likely(!evaluate_pending_interrupts) && kvm_vcpu_apicv_active(vcpu))
 		evaluate_pending_interrupts |= vmx_has_apicv_interrupt(vcpu);
 
-	if (!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
+	if (!vmx->nested.nested_run_pending ||
+	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
 		vmx->nested.vmcs01_debugctl = vmcs_read64(GUEST_IA32_DEBUGCTL);
 	if (kvm_mpx_supported() &&
 	    (!vmx->nested.nested_run_pending ||


