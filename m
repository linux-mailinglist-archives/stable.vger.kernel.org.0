Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4394504D8E
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 10:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235025AbiDRIKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 04:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231859AbiDRIKh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 04:10:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5E811C32
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 01:07:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3D7F61044
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 08:07:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6857C385A7;
        Mon, 18 Apr 2022 08:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650269278;
        bh=2lA0FXAX69mAAaCQRKl6zLW1PmF6HkTyh7ZA8CQ0XJ0=;
        h=Subject:To:Cc:From:Date:From;
        b=ereLMZGmt6y1c3Ta8HdIYJ3nLa9Lx3XUIwg96W4wODOb1dRZ4nR1elHnlS2Htiv9l
         9lsP31LC/YWTjb2BXYvYiFujQvm4G9G7cz+jDYLGxproIhX+PYvaWOGG3HwpHuz+UV
         /QsorBsk1f1hJuf2xPC78t9+r/7/2OglQlrftma4=
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Resolve nx_huge_pages when kvm.ko is loaded" failed to apply to 4.9-stable tree
To:     seanjc@google.com, bgoncalv@redhat.com, jstancek@redhat.com,
        pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Apr 2022 10:07:55 +0200
Message-ID: <1650269275141191@kroah.com>
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1d0e84806047f38027d7572adb4702ef7c09b317 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 31 Mar 2022 22:13:59 +0000
Subject: [PATCH] KVM: x86/mmu: Resolve nx_huge_pages when kvm.ko is loaded

Resolve nx_huge_pages to true/false when kvm.ko is loaded, leaving it as
-1 is technically undefined behavior when its value is read out by
param_get_bool(), as boolean values are supposed to be '0' or '1'.

Alternatively, KVM could define a custom getter for the param, but the
auto value doesn't depend on the vendor module in any way, and printing
"auto" would be unnecessarily unfriendly to the user.

In addition to fixing the undefined behavior, resolving the auto value
also fixes the scenario where the auto value resolves to N and no vendor
module is loaded.  Previously, -1 would result in Y being printed even
though KVM would ultimately disable the mitigation.

Rename the existing MMU module init/exit helpers to clarify that they're
invoked with respect to the vendor module, and add comments to document
why KVM has two separate "module init" flows.

  =========================================================================
  UBSAN: invalid-load in kernel/params.c:320:33
  load of value 255 is not a valid value for type '_Bool'
  CPU: 6 PID: 892 Comm: tail Not tainted 5.17.0-rc3+ #799
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  Call Trace:
   <TASK>
   dump_stack_lvl+0x34/0x44
   ubsan_epilogue+0x5/0x40
   __ubsan_handle_load_invalid_value.cold+0x43/0x48
   param_get_bool.cold+0xf/0x14
   param_attr_show+0x55/0x80
   module_attr_show+0x1c/0x30
   sysfs_kf_seq_show+0x93/0xc0
   seq_read_iter+0x11c/0x450
   new_sync_read+0x11b/0x1a0
   vfs_read+0xf0/0x190
   ksys_read+0x5f/0xe0
   do_syscall_64+0x3b/0xc0
   entry_SYSCALL_64_after_hwframe+0x44/0xae
   </TASK>
  =========================================================================

Fixes: b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation")
Cc: stable@vger.kernel.org
Reported-by: Bruno Goncalves <bgoncalv@redhat.com>
Reported-by: Jan Stancek <jstancek@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220331221359.3912754-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d23e80a56eb8..0d37ba442de3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1585,8 +1585,9 @@ static inline int kvm_arch_flush_remote_tlb(struct kvm *kvm)
 #define kvm_arch_pmi_in_guest(vcpu) \
 	((vcpu) && (vcpu)->arch.handling_intr_from_guest)
 
-int kvm_mmu_module_init(void);
-void kvm_mmu_module_exit(void);
+void kvm_mmu_x86_module_init(void);
+int kvm_mmu_vendor_module_init(void);
+void kvm_mmu_vendor_module_exit(void);
 
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_mmu_create(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8f19ea752704..f9080ee50ffa 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6237,12 +6237,24 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
 	return 0;
 }
 
-int kvm_mmu_module_init(void)
+/*
+ * nx_huge_pages needs to be resolved to true/false when kvm.ko is loaded, as
+ * its default value of -1 is technically undefined behavior for a boolean.
+ */
+void kvm_mmu_x86_module_init(void)
 {
-	int ret = -ENOMEM;
-
 	if (nx_huge_pages == -1)
 		__set_nx_huge_pages(get_nx_auto_mode());
+}
+
+/*
+ * The bulk of the MMU initialization is deferred until the vendor module is
+ * loaded as many of the masks/values may be modified by VMX or SVM, i.e. need
+ * to be reset when a potentially different vendor module is loaded.
+ */
+int kvm_mmu_vendor_module_init(void)
+{
+	int ret = -ENOMEM;
 
 	/*
 	 * MMU roles use union aliasing which is, generally speaking, an
@@ -6290,7 +6302,7 @@ void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 	mmu_free_memory_caches(vcpu);
 }
 
-void kvm_mmu_module_exit(void)
+void kvm_mmu_vendor_module_exit(void)
 {
 	mmu_destroy_caches();
 	percpu_counter_destroy(&kvm_total_used_mmu_pages);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0c0ca599a353..de49a88df1c2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8926,7 +8926,7 @@ int kvm_arch_init(void *opaque)
 	}
 	kvm_nr_uret_msrs = 0;
 
-	r = kvm_mmu_module_init();
+	r = kvm_mmu_vendor_module_init();
 	if (r)
 		goto out_free_percpu;
 
@@ -8974,7 +8974,7 @@ void kvm_arch_exit(void)
 	cancel_work_sync(&pvclock_gtod_work);
 #endif
 	kvm_x86_ops.hardware_enable = NULL;
-	kvm_mmu_module_exit();
+	kvm_mmu_vendor_module_exit();
 	free_percpu(user_return_msrs);
 	kmem_cache_destroy(x86_emulator_cache);
 #ifdef CONFIG_KVM_XEN
@@ -12986,3 +12986,19 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_enter);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_enter);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_exit);
+
+static int __init kvm_x86_init(void)
+{
+	kvm_mmu_x86_module_init();
+	return 0;
+}
+module_init(kvm_x86_init);
+
+static void __exit kvm_x86_exit(void)
+{
+	/*
+	 * If module_init() is implemented, module_exit() must also be
+	 * implemented to allow module unload.
+	 */
+}
+module_exit(kvm_x86_exit);

