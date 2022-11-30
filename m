Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2E3A63D582
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 13:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233453AbiK3MXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 07:23:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234496AbiK3MXY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 07:23:24 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2FBC2B618
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 04:23:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0E34ECE18D1
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 12:23:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0799C433D6;
        Wed, 30 Nov 2022 12:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669811000;
        bh=+Q0410y8NUelgYGM8gz5sodRkf3fXCtTvHQZo7DnTgY=;
        h=Subject:To:Cc:From:Date:From;
        b=O3to/hT9680UPY9ITOg7C8bzqk992BLWGyLf/typ+mVwEqUbhsDBdYnNDw4uvsDYt
         mX+WFT7bTxFYNvy3++MusEUkVmWaVZyDyT43h061zw+wCa4oz+Ecd+4N6WOalR91L2
         De80FuIzj9qfON1epq2J0PxnczxvEAydHjwaTkxI=
Subject: FAILED: patch "[PATCH] KVM: x86: remove exit_int_info warning in svm_handle_exit" failed to apply to 4.19-stable tree
To:     mlevitsk@redhat.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 30 Nov 2022 13:23:09 +0100
Message-ID: <1669810989156166@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

05311ce954ae ("KVM: x86: remove exit_int_info warning in svm_handle_exit")
404d5d7bff0d ("KVM: X86: Introduce more exit_fastpath_completion enum values")
dcf068da7eb2 ("KVM: VMX: Introduce generic fastpath handler")
a9ab13ff6e84 ("KVM: X86: Improve latency for single target IPI fastpath")
873e1da16918 ("KVM: VMX: Optimize handling of VM-Entry failures in vmx_vcpu_run()")
e64419d991ea ("KVM: x86: Move "flush guest's TLB" logic to separate kvm_x86_ops hook")
56a87e5d997b ("KVM: SVM: Fix __svm_vcpu_run declaration.")
199cd1d7b534 ("KVM: SVM: Split svm_vcpu_run inline assembly to separate file")
eaf78265a4ab ("KVM: SVM: Move SEV code to separate file")
ef0f64960d01 ("KVM: SVM: Move AVIC code to separate file")
883b0a91f41a ("KVM: SVM: Move Nested SVM Implementation to nested.c")
46a010dd6896 ("kVM SVM: Move SVM related files to own sub-directory")
8c1b724ddb21 ("Merge tag 'for-linus' of git://git.kernel.org/pub/scm/virt/kvm/kvm")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 05311ce954aebe75935d9ae7d38ac82b5b796e33 Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <mlevitsk@redhat.com>
Date: Thu, 3 Nov 2022 16:13:51 +0200
Subject: [PATCH] KVM: x86: remove exit_int_info warning in svm_handle_exit

It is valid to receive external interrupt and have broken IDT entry,
which will lead to #GP with exit_int_into that will contain the index of
the IDT entry (e.g any value).

Other exceptions can happen as well, like #NP or #SS
(if stack switch fails).

Thus this warning can be user triggred and has very little value.

Cc: stable@vger.kernel.org
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20221103141351.50662-10-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 098f04bec8ef..c0950ae86b2b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -346,12 +346,6 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 	return 0;
 }
 
-static int is_external_interrupt(u32 info)
-{
-	info &= SVM_EVTINJ_TYPE_MASK | SVM_EVTINJ_VALID;
-	return info == (SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_INTR);
-}
-
 static u32 svm_get_interrupt_shadow(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -3426,15 +3420,6 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 		return 0;
 	}
 
-	if (is_external_interrupt(svm->vmcb->control.exit_int_info) &&
-	    exit_code != SVM_EXIT_EXCP_BASE + PF_VECTOR &&
-	    exit_code != SVM_EXIT_NPF && exit_code != SVM_EXIT_TASK_SWITCH &&
-	    exit_code != SVM_EXIT_INTR && exit_code != SVM_EXIT_NMI)
-		printk(KERN_ERR "%s: unexpected exit_int_info 0x%x "
-		       "exit_code 0x%x\n",
-		       __func__, svm->vmcb->control.exit_int_info,
-		       exit_code);
-
 	if (exit_fastpath != EXIT_FASTPATH_NONE)
 		return 1;
 

