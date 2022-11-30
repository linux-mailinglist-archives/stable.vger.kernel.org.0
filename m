Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCAB63D572
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 13:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbiK3MWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 07:22:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiK3MWK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 07:22:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D84416F825
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 04:22:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86439B81B31
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 12:22:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB22FC433D6;
        Wed, 30 Nov 2022 12:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669810927;
        bh=AJcmZngp3wxsBe2JXoe0xfVGtP8gkqQerLHgCcRSQTA=;
        h=Subject:To:Cc:From:Date:From;
        b=VTgxOEObqveHdRtYKZUmFT44w6/IPTQSWGQ1iQc7miP2gX4dUEZdBpa7SNjUGQZ0y
         horWL/9Ou8uyb0CEYvWIcbwNszhsbnC6GeSTcaYIM6XQAGma989OU8jD4rCzQ/72NZ
         Xe2pAa89CuGAM/IQNIeOMUZQX7d62sldTkILxz1A=
Subject: FAILED: patch "[PATCH] KVM: x86: nSVM: harden svm_free_nested against freeing vmcb02" failed to apply to 5.4-stable tree
To:     mlevitsk@redhat.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 30 Nov 2022 13:22:04 +0100
Message-ID: <1669810924129135@kroah.com>
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

16ae56d7e052 ("KVM: x86: nSVM: harden svm_free_nested against freeing vmcb02 while still in use")
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

From 16ae56d7e0528559bf8dc9070e3bfd8ba3de80df Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <mlevitsk@redhat.com>
Date: Thu, 3 Nov 2022 16:13:44 +0200
Subject: [PATCH] KVM: x86: nSVM: harden svm_free_nested against freeing vmcb02
 while still in use

Make sure that KVM uses vmcb01 before freeing nested state, and warn if
that is not the case.

This is a minimal fix for CVE-2022-3344 making the kernel print a warning
instead of a kernel panic.

Cc: stable@vger.kernel.org
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20221103141351.50662-3-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 4c620999d230..b02a3a1792f1 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1125,6 +1125,9 @@ void svm_free_nested(struct vcpu_svm *svm)
 	if (!svm->nested.initialized)
 		return;
 
+	if (WARN_ON_ONCE(svm->vmcb != svm->vmcb01.ptr))
+		svm_switch_vmcb(svm, &svm->vmcb01);
+
 	svm_vcpu_free_msrpm(svm->nested.msrpm);
 	svm->nested.msrpm = NULL;
 

