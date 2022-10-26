Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 835EA60E420
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 17:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbiJZPIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 11:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234284AbiJZPIj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 11:08:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F535125038
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 08:08:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CBAD61F4E
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 15:08:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F084C433D7;
        Wed, 26 Oct 2022 15:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666796917;
        bh=9WX5WJ5QCo7hc5LA8I30a46R/fHJRCxWyp/2lofU/cQ=;
        h=Subject:To:Cc:From:Date:From;
        b=eMI6SDXZHnoITWTDTQTej47oMI7NFapoVxXT/4TBOHqexwqM+9dhNsEmZa3uumARw
         o2PBaS8FrBexMKxLAVxgpLS9ykkDWQ3Csj2MIrRlJ18qCnP72PTP4vext8uC2FtWOw
         kbaBhh0D2eh44FYnpnA9vButLr5KAbBGyLdsAmbo=
Subject: FAILED: patch "[PATCH] KVM: x86: Copy filter arg outside" failed to apply to 5.10-stable tree
To:     graf@amazon.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 26 Oct 2022 17:08:35 +0200
Message-ID: <16667969154640@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

2e3272bc1790 ("KVM: x86: Copy filter arg outside kvm_vm_ioctl_set_msr_filter()")
cf5029d5dd7c ("KVM: x86: Protect the unused bits in MSR exiting flags")
b318e8decf6b ("KVM: x86: Protect userspace MSR filter with SRCU, and set atomically-ish")
b3646477d458 ("KVM: x86: use static calls to reduce kvm_x86_ops overhead")
fe6b6bc802b4 ("KVM: VMX: Enable bus lock VM exit")
8e5332402164 ("KVM: VMX: Convert vcpu_vmx.exit_reason to a union")
15b51dc08a34 ("KVM: x86: Take KVM's SRCU lock only if steal time update is needed")
19979fba9bfa ("KVM: x86: Remove obsolete disabling of page faults in kvm_arch_vcpu_put()")
647daca25d24 ("KVM: SVM: Add support for booting APs in an SEV-ES guest")
8640ca588b03 ("KVM: SVM: Add AP_JUMP_TABLE support in prep for AP booting")
861377730aa9 ("KVM: SVM: Provide support for SEV-ES vCPU loading")
376c6d285017 ("KVM: SVM: Provide support for SEV-ES vCPU creation/loading")
85ca8be938c0 ("KVM: SVM: Set the encryption mask for the SVM host save area")
4444dfe4050b ("KVM: SVM: Add NMI support for an SEV-ES guest")
5719455fbd95 ("KVM: SVM: Do not report support for SMM for an SEV-ES guest")
7ed9abfe8e9f ("KVM: SVM: Support string IO operations for an SEV-ES guest")
8f423a80d299 ("KVM: SVM: Support MMIO for an SEV-ES guest")
d523ab6ba275 ("KVM: SVM: Create trace events for VMGEXIT processing")
d36946679ef6 ("KVM: SVM: Add support for SEV-ES GHCB MSR protocol function 0x004")
1edc14599e06 ("KVM: SVM: Add support for SEV-ES GHCB MSR protocol function 0x002")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2e3272bc1790825c43d2c39690bf2836b81c6d36 Mon Sep 17 00:00:00 2001
From: Alexander Graf <graf@amazon.com>
Date: Mon, 17 Oct 2022 20:45:40 +0200
Subject: [PATCH] KVM: x86: Copy filter arg outside
 kvm_vm_ioctl_set_msr_filter()

In the next patch we want to introduce a second caller to
set_msr_filter() which constructs its own filter list on the stack.
Refactor the original function so it takes it as argument instead of
reading it through copy_from_user().

Signed-off-by: Alexander Graf <graf@amazon.com>
Message-Id: <20221017184541.2658-3-graf@amazon.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4bd5f8a751de..78f779f0264b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6442,26 +6442,22 @@ static int kvm_add_msr_filter(struct kvm_x86_msr_filter *msr_filter,
 	return 0;
 }
 
-static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm, void __user *argp)
+static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm,
+				       struct kvm_msr_filter *filter)
 {
-	struct kvm_msr_filter __user *user_msr_filter = argp;
 	struct kvm_x86_msr_filter *new_filter, *old_filter;
-	struct kvm_msr_filter filter;
 	bool default_allow;
 	bool empty = true;
 	int r = 0;
 	u32 i;
 
-	if (copy_from_user(&filter, user_msr_filter, sizeof(filter)))
-		return -EFAULT;
-
-	if (filter.flags & ~KVM_MSR_FILTER_DEFAULT_DENY)
+	if (filter->flags & ~KVM_MSR_FILTER_DEFAULT_DENY)
 		return -EINVAL;
 
-	for (i = 0; i < ARRAY_SIZE(filter.ranges); i++)
-		empty &= !filter.ranges[i].nmsrs;
+	for (i = 0; i < ARRAY_SIZE(filter->ranges); i++)
+		empty &= !filter->ranges[i].nmsrs;
 
-	default_allow = !(filter.flags & KVM_MSR_FILTER_DEFAULT_DENY);
+	default_allow = !(filter->flags & KVM_MSR_FILTER_DEFAULT_DENY);
 	if (empty && !default_allow)
 		return -EINVAL;
 
@@ -6469,8 +6465,8 @@ static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm, void __user *argp)
 	if (!new_filter)
 		return -ENOMEM;
 
-	for (i = 0; i < ARRAY_SIZE(filter.ranges); i++) {
-		r = kvm_add_msr_filter(new_filter, &filter.ranges[i]);
+	for (i = 0; i < ARRAY_SIZE(filter->ranges); i++) {
+		r = kvm_add_msr_filter(new_filter, &filter->ranges[i]);
 		if (r) {
 			kvm_free_msr_filter(new_filter);
 			return r;
@@ -6915,9 +6911,16 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	case KVM_SET_PMU_EVENT_FILTER:
 		r = kvm_vm_ioctl_set_pmu_event_filter(kvm, argp);
 		break;
-	case KVM_X86_SET_MSR_FILTER:
-		r = kvm_vm_ioctl_set_msr_filter(kvm, argp);
+	case KVM_X86_SET_MSR_FILTER: {
+		struct kvm_msr_filter __user *user_msr_filter = argp;
+		struct kvm_msr_filter filter;
+
+		if (copy_from_user(&filter, user_msr_filter, sizeof(filter)))
+			return -EFAULT;
+
+		r = kvm_vm_ioctl_set_msr_filter(kvm, &filter);
 		break;
+	}
 	default:
 		r = -ENOTTY;
 	}

