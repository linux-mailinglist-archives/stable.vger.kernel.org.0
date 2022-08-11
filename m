Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A08D58FED4
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235237AbiHKPJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiHKPJc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:09:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3CD66A67
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 08:09:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AB2D615D9
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 15:09:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38AF6C433D6;
        Thu, 11 Aug 2022 15:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660230570;
        bh=ERsOBf+ZiiWFfxMXyIN72K6DWmRT1fllE3MNjjv2XiY=;
        h=Subject:To:Cc:From:Date:From;
        b=ItdrDEomE3U3u3uYSbR/2M0rq32H8PuyIPY3yBDTSv70J4bR6z+Ihk9CIGrMB2SBW
         5MPcjtFQP3ptBAdrPGI1diIwjFeoT+W8J6gSmmmPXgb743e3suL5JBL87C2nYDSQLf
         3C1DYyNrlqpmYvFy70COOtZLwvapBqvtipnX4N/E=
Subject: FAILED: patch "[PATCH] KVM: nVMX: Snapshot pre-VM-Enter BNDCFGS for" failed to apply to 4.19-stable tree
To:     seanjc@google.com, lei4.wang@intel.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Aug 2022 17:09:27 +0200
Message-ID: <1660230567134232@kroah.com>
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

From fa578398a0ba2c079fa1170da21fa5baae0cedb2 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 14 Jun 2022 21:58:27 +0000
Subject: [PATCH] KVM: nVMX: Snapshot pre-VM-Enter BNDCFGS for
 !nested_run_pending case

If a nested run isn't pending, snapshot vmcs01.GUEST_BNDCFGS irrespective
of whether or not VM_ENTRY_LOAD_BNDCFGS is set in vmcs12.  When restoring
nested state, e.g. after migration, without a nested run pending,
prepare_vmcs02() will propagate nested.vmcs01_guest_bndcfgs to vmcs02,
i.e. will load garbage/zeros into vmcs02.GUEST_BNDCFGS.

If userspace restores nested state before MSRs, then loading garbage is a
non-issue as loading BNDCFGS will also update vmcs02.  But if usersepace
restores MSRs first, then KVM is responsible for propagating L2's value,
which is actually thrown into vmcs01, into vmcs02.

Restoring L2 MSRs into vmcs01, i.e. loading all MSRs before nested state
is all kinds of bizarre and ideally would not be supported.  Sadly, some
VMMs do exactly that and rely on KVM to make things work.

Note, there's still a lurking SMM bug, as propagating vmcs01.GUEST_BNDFGS
to vmcs02 across RSM may corrupt L2's BNDCFGS.  But KVM's entire VMX+SMM
emulation is flawed as SMI+RSM should not toouch _any_ VMCS when use the
"default treatment of SMIs", i.e. when not using an SMI Transfer Monitor.

Link: https://lore.kernel.org/all/Yobt1XwOfb5M6Dfa@google.com
Fixes: 62cf9bd8118c ("KVM: nVMX: Fix emulation of VM_ENTRY_LOAD_BNDCFGS")
Cc: stable@vger.kernel.org
Cc: Lei Wang <lei4.wang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220614215831.3762138-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 7d8cd0ebcc75..66c25bb56938 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3382,7 +3382,8 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	if (!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
 		vmx->nested.vmcs01_debugctl = vmcs_read64(GUEST_IA32_DEBUGCTL);
 	if (kvm_mpx_supported() &&
-		!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
+	    (!vmx->nested.nested_run_pending ||
+	     !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
 		vmx->nested.vmcs01_guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
 
 	/*

