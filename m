Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D99E0505172
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239191AbiDRMew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239062AbiDRMbj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:31:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51188DF44;
        Mon, 18 Apr 2022 05:24:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FC8BB80EDC;
        Mon, 18 Apr 2022 12:24:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7C8C385A8;
        Mon, 18 Apr 2022 12:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284643;
        bh=wJm47E6R0VD1i5A84/nqrHc9/278wZiiN/0GWqJeu/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kjrtrl0yo8+RmRUOhPGMaNtxlTD8W6CFYaZFZIa2Kt1gueRpglUsSBkFFMkjYPL3i
         dtS8BQorGe2mStNnbd9rpFP2+854hiwzF1A/TARBhLnkDuYu5ehDTR2G9It2nIfjtp
         pGOKVxBgo9DwZQaS1tEoW2C+UyzNBRpGGGgO7ZdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bruno Goncalves <bgoncalv@redhat.com>,
        Jan Stancek <jstancek@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.17 182/219] KVM: x86/mmu: Resolve nx_huge_pages when kvm.ko is loaded
Date:   Mon, 18 Apr 2022 14:12:31 +0200
Message-Id: <20220418121211.971773008@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Sean Christopherson <seanjc@google.com>

commit 1d0e84806047f38027d7572adb4702ef7c09b317 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm_host.h |    5 +++--
 arch/x86/kvm/mmu/mmu.c          |   20 ++++++++++++++++----
 arch/x86/kvm/x86.c              |   20 ++++++++++++++++++--
 3 files changed, 37 insertions(+), 8 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1574,8 +1574,9 @@ static inline int kvm_arch_flush_remote_
 #define kvm_arch_pmi_in_guest(vcpu) \
 	((vcpu) && (vcpu)->arch.handling_intr_from_guest)
 
-int kvm_mmu_module_init(void);
-void kvm_mmu_module_exit(void);
+void kvm_mmu_x86_module_init(void);
+int kvm_mmu_vendor_module_init(void);
+void kvm_mmu_vendor_module_exit(void);
 
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_mmu_create(struct kvm_vcpu *vcpu);
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6144,12 +6144,24 @@ static int set_nx_huge_pages(const char
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
@@ -6197,7 +6209,7 @@ void kvm_mmu_destroy(struct kvm_vcpu *vc
 	mmu_free_memory_caches(vcpu);
 }
 
-void kvm_mmu_module_exit(void)
+void kvm_mmu_vendor_module_exit(void)
 {
 	mmu_destroy_caches();
 	percpu_counter_destroy(&kvm_total_used_mmu_pages);
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8846,7 +8846,7 @@ int kvm_arch_init(void *opaque)
 	}
 	kvm_nr_uret_msrs = 0;
 
-	r = kvm_mmu_module_init();
+	r = kvm_mmu_vendor_module_init();
 	if (r)
 		goto out_free_percpu;
 
@@ -8894,7 +8894,7 @@ void kvm_arch_exit(void)
 	cancel_work_sync(&pvclock_gtod_work);
 #endif
 	kvm_x86_ops.hardware_enable = NULL;
-	kvm_mmu_module_exit();
+	kvm_mmu_vendor_module_exit();
 	free_percpu(user_return_msrs);
 	kmem_cache_destroy(x86_emulator_cache);
 #ifdef CONFIG_KVM_XEN
@@ -12887,3 +12887,19 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit
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


