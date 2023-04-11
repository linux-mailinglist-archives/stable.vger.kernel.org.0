Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF3DF6DD893
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 13:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjDKLBc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 07:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjDKLBZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 07:01:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05DD3421C
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 04:01:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 717BA621CC
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 11:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C63C433D2;
        Tue, 11 Apr 2023 11:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681210869;
        bh=M/3Cfb8JUy9A/myjNFxQ9Pof2/1ql0AwB8+8Yf2Stpc=;
        h=Subject:To:Cc:From:Date:From;
        b=EuLEH0NGGGNYoEn7HXX8Mqh5PR8osrUKRGhBG9R5+1LGq7aFff/V5H4Jtx6BfqdvP
         W1bEQHIg9HpxRfrpEXv6s1Uk3RJf/ZPOYrfIQGvGWk9MM9XUtrNgO7hD5EtXWxDdRW
         e7LRD4EZVpwBSvoZ90QvkrElnXx30oV/dPaKJJ2k=
Subject: FAILED: patch "[PATCH] KVM: nVMX: Do not report error code when synthesizing VM-Exit" failed to apply to 5.10-stable tree
To:     seanjc@google.com, mlevitsk@redhat.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 11 Apr 2023 13:01:05 +0200
Message-ID: <2023041104-scarf-keg-0b67@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
git checkout FETCH_HEAD
git cherry-pick -x 80962ec912db56d323883154efc2297473e692cb
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023041104-scarf-keg-0b67@gregkh' --subject-prefix 'PATCH 5.10.y' HEAD^..

Possible dependencies:

80962ec912db ("KVM: nVMX: Do not report error code when synthesizing VM-Exit from Real Mode")
d4963e319f1f ("KVM: x86: Make kvm_queued_exception a properly named, visible struct")
5623f751bd9c ("KVM: x86: Treat #DBs from the emulator as fault-like (code and DR7.GD=1)")
8d178f460772 ("KVM: nVMX: Treat General Detect #DB (DR7.GD=1) as fault-like")
eba9799b5a6e ("KVM: VMX: Drop bits 31:16 when shoving exception error code into VMCS")
a61d7c5432ac ("KVM: x86: Trace re-injected exceptions")
6ef88d6e36c2 ("KVM: SVM: Re-inject INT3/INTO instead of retrying the instruction")
3741aec4c38f ("KVM: SVM: Stuff next_rip on emulated INT3 injection if NRIPS is supported")
cd9e6da8048c ("KVM: SVM: Unwind "speculative" RIP advancement if INTn injection "fails"")
00f08d99dd7d ("KVM: nSVM: Sync next_rip field from vmcb12 to vmcb02")
9bd1f0efa859 ("KVM: nVMX: Clear IDT vectoring on nested VM-Exit for double/triple fault")
c3634d25fbee ("KVM: nVMX: Leave most VM-Exit info fields unmodified on failed VM-Entry")
1d5a1b5860ed ("KVM: x86: nSVM: correctly virtualize LBR msrs when L2 is running")
db663af4a001 ("kvm: x86: SVM: use vmcb* instead of svm->vmcb where it makes sense")
b9f3973ab3a8 ("KVM: x86: nSVM: implement nested VMLOAD/VMSAVE")
23e5092b6e2a ("KVM: SVM: Rename hook implementations to conform to kvm_x86_ops' names")
e27bc0440ebd ("KVM: x86: Rename kvm_x86_ops pointers to align w/ preferred vendor names")
068f7ea61895 ("KVM: SVM: improve split between svm_prepare_guest_switch and sev_es_prepare_guest_switch")
e1779c2714c3 ("KVM: x86: nSVM: fix potential NULL derefernce on nested migration")
54744e17f031 ("KVM: SVM: Move svm_hardware_setup() and its helpers below svm_x86_ops")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 80962ec912db56d323883154efc2297473e692cb Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 22 Mar 2023 07:33:00 -0700
Subject: [PATCH] KVM: nVMX: Do not report error code when synthesizing VM-Exit
 from Real Mode

Don't report an error code to L1 when synthesizing a nested VM-Exit and
L2 is in Real Mode.  Per Intel's SDM, regarding the error code valid bit:

  This bit is always 0 if the VM exit occurred while the logical processor
  was in real-address mode (CR0.PE=0).

The bug was introduced by a recent fix for AMD's Paged Real Mode, which
moved the error code suppression from the common "queue exception" path
to the "inject exception" path, but missed VMX's "synthesize VM-Exit"
path.

Fixes: b97f07458373 ("KVM: x86: determine if an exception has an error code only when injecting it.")
Cc: stable@vger.kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20230322143300.2209476-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1bc2b80273c9..768487611db7 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3868,7 +3868,12 @@ static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu)
 		exit_qual = 0;
 	}
 
-	if (ex->has_error_code) {
+	/*
+	 * Unlike AMD's Paged Real Mode, which reports an error code on #PF
+	 * VM-Exits even if the CPU is in Real Mode, Intel VMX never sets the
+	 * "has error code" flags on VM-Exit if the CPU is in Real Mode.
+	 */
+	if (ex->has_error_code && is_protmode(vcpu)) {
 		/*
 		 * Intel CPUs do not generate error codes with bits 31:16 set,
 		 * and more importantly VMX disallows setting bits 31:16 in the

