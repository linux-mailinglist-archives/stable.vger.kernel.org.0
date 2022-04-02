Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCA2B4F02E7
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 15:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345979AbiDBNtT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 09:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355722AbiDBNtS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 09:49:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C704D166E22
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 06:47:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63D30614FC
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 13:47:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7104EC340EE;
        Sat,  2 Apr 2022 13:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648907245;
        bh=ncAkKwV9mytTcbiibehGBtYZlH/Kz3YBhNzJAXFGqrk=;
        h=Subject:To:Cc:From:Date:From;
        b=A+xkQ3QeDQKaQeAQw+OteWLW+WmEXDDmMrEByTCqBLZNblqa2beGWJKHRx2bF6CJv
         K2apeqsZ0t8fEr0cGOmwDRN1CA7DO2Cnry6zl1163Et9SgFANhGgxb3TFOseHgvxEA
         cOXBiL+CE0D+dmtqmX4IBFnD3YZ6MaQX6vqLmhl0=
Subject: FAILED: patch "[PATCH] KVM: SVM: Allow AVIC support on system w/ physical APIC ID >" failed to apply to 5.4-stable tree
To:     suravee.suthikulpanit@amd.com, mlevitsk@redhat.com,
        pbonzini@redhat.com, seanjc@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 02 Apr 2022 15:47:23 +0200
Message-ID: <1648907243206132@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4a204f7895878363ca8211f50ec610408c8c70aa Mon Sep 17 00:00:00 2001
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Date: Thu, 10 Feb 2022 18:08:51 -0600
Subject: [PATCH] KVM: SVM: Allow AVIC support on system w/ physical APIC ID >
 255

Expand KVM's mask for the AVIC host physical ID to the full 12 bits defined
by the architecture.  The number of bits consumed by hardware is model
specific, e.g. early CPUs ignored bits 11:8, but there is no way for KVM
to enumerate the "true" size.  So, KVM must allow using all bits, else it
risks rejecting completely legal x2APIC IDs on newer CPUs.

This means KVM relies on hardware to not assign x2APIC IDs that exceed the
"true" width of the field, but presumably hardware is smart enough to tie
the width to the max x2APIC ID.  KVM also relies on hardware to support at
least 8 bits, as the legacy xAPIC ID is writable by software.  But, those
assumptions are unavoidable due to the lack of any way to enumerate the
"true" width.

Cc: stable@vger.kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Fixes: 44a95dae1d22 ("KVM: x86: Detect and Initialize AVIC support")
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Message-Id: <20220211000851.185799-1-suravee.suthikulpanit@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index bb2fb78523ce..7eb2df5417fb 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -226,7 +226,7 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define AVIC_LOGICAL_ID_ENTRY_VALID_BIT			31
 #define AVIC_LOGICAL_ID_ENTRY_VALID_MASK		(1 << 31)
 
-#define AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK	(0xFFULL)
+#define AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK	GENMASK_ULL(11, 0)
 #define AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK	(0xFFFFFFFFFFULL << 12)
 #define AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK		(1ULL << 62)
 #define AVIC_PHYSICAL_ID_ENTRY_VALID_MASK		(1ULL << 63)
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 1afde44b1252..b37b353ec086 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -870,17 +870,12 @@ avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
 void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	u64 entry;
-	/* ID = 0xff (broadcast), ID > 0xff (reserved) */
 	int h_physical_id = kvm_cpu_get_apicid(cpu);
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	lockdep_assert_preemption_disabled();
 
-	/*
-	 * Since the host physical APIC id is 8 bits,
-	 * we can support host APIC ID upto 255.
-	 */
-	if (WARN_ON(h_physical_id > AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK))
+	if (WARN_ON(h_physical_id & ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK))
 		return;
 
 	/*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index e45b5645d5e0..e37bb3508cfa 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -569,6 +569,17 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
 
 /* avic.c */
 
+#define AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK	(0xFF)
+#define AVIC_LOGICAL_ID_ENTRY_VALID_BIT			31
+#define AVIC_LOGICAL_ID_ENTRY_VALID_MASK		(1 << 31)
+
+#define AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK	GENMASK_ULL(11, 0)
+#define AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK	(0xFFFFFFFFFFULL << 12)
+#define AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK		(1ULL << 62)
+#define AVIC_PHYSICAL_ID_ENTRY_VALID_MASK		(1ULL << 63)
+
+#define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
+
 int avic_ga_log_notifier(u32 ga_tag);
 void avic_vm_destroy(struct kvm *kvm);
 int avic_vm_init(struct kvm *kvm);

