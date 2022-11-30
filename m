Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A11EC63D579
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 13:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbiK3MW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 07:22:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233986AbiK3MWl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 07:22:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979712613
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 04:22:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47104B81B2F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 12:22:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08D4C433C1;
        Wed, 30 Nov 2022 12:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669810956;
        bh=yEm+IapcngranccYw5xJDNzUsj8ldcOwatDn977UkaI=;
        h=Subject:To:Cc:From:Date:From;
        b=e9uuMT8BaejEklVN/JFL7UJK0vzIJe+t+G2Fs47Jwi9NHuojJcwpzk0qQB4z9hhQW
         RkT3ZmGUHuH5SKKyseMCB8M8J4pHAzADnYEm8AKfp2ZkFDvKjGCeWFxTRQfbJrp6Lw
         h/wbvrIu0oEZup7aj1TZB8mVdXUOM3387MCx8ALE=
Subject: FAILED: patch "[PATCH] KVM: x86: nSVM: leave nested mode on vCPU free" failed to apply to 4.9-stable tree
To:     mlevitsk@redhat.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 30 Nov 2022 13:22:13 +0100
Message-ID: <16698109334394@kroah.com>
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

917401f26a6a ("KVM: x86: nSVM: leave nested mode on vCPU free")
2fcf4876ada8 ("KVM: nSVM: implement on demand allocation of the nested state")
72f211ecaa80 ("KVM: x86: allow kvm_x86_ops.set_efer to return an error value")
fd6fa73d1337 ("KVM: x86: SVM: Prevent MSR passthrough when MSR access is denied")
476c9bd8e997 ("KVM: x86: Prepare MSR bitmaps for userspace tracked MSRs")
d85a8034c016 ("KVM: VMX: Rename "find_msr_entry" to "vmx_find_uret_msr"")
eb3db1b13788 ("KVM: VMX: Rename the "shared_msr_entry" struct to "vmx_uret_msr"")
ce833b2324ba ("KVM: VMX: Prepend "MAX_" to MSR array size defines")
7e34fbd05c63 ("KVM: x86: Rename "shared_msrs" to "user_return_msrs"")
8d22b90e942c ("KVM: SVM: refactor exit labels in svm_create_vcpu")
0681de1b8369 ("KVM: SVM: use __GFP_ZERO instead of clear_page")
f4c847a95654 ("KVM: SVM: refactor msr permission bitmap allocation")
0dd16b5b0c9b ("KVM: nSVM: rename nested vmcb to vmcb12")
1feaba144cd3 ("KVM: SVM: rename a variable in the svm_create_vcpu")
bf3c0e5e7102 ("Merge branch 'x86-seves-for-paolo' of https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip into HEAD")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 917401f26a6af5756d89b550a8e1bd50cf42b07e Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <mlevitsk@redhat.com>
Date: Thu, 3 Nov 2022 16:13:43 +0200
Subject: [PATCH] KVM: x86: nSVM: leave nested mode on vCPU free

If the VM was terminated while nested, we free the nested state
while the vCPU still is in nested mode.

Soon a warning will be added for this condition.

Cc: stable@vger.kernel.org
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20221103141351.50662-2-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9f88c8e6766e..098f04bec8ef 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1438,6 +1438,7 @@ static void svm_vcpu_free(struct kvm_vcpu *vcpu)
 	 */
 	svm_clear_current_vmcb(svm->vmcb);
 
+	svm_leave_nested(vcpu);
 	svm_free_nested(svm);
 
 	sev_free_vcpu(vcpu);

