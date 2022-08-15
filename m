Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 428F45942A7
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350410AbiHOVxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350608AbiHOVvq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:51:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C5E10777C;
        Mon, 15 Aug 2022 12:33:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F11AE60EF0;
        Mon, 15 Aug 2022 19:33:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003C6C433D6;
        Mon, 15 Aug 2022 19:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591992;
        bh=UDIfRdCg/9MJ7PfRFF1L942/9m5Ku730mwHGprEd1s8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yF7ps9dAScO/QVqkTWHp4NauZV3vwtgogWPK+FjzBwUM4Ez3jpCXcY3OSu5S+Abdl
         4Oj0/jcYS5NjeFB1v5PfHr0OZHKPk2AERQupMi/bf81T6+GrV547yk1F0KKqAMMjnh
         UhiFdnbluCpvD5ZpgD6WzKubhV3xZtUxAyDhLxW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.19 0041/1157] KVM: x86/mmu: Fully re-evaluate MMIO caching when SPTE masks change
Date:   Mon, 15 Aug 2022 19:49:57 +0200
Message-Id: <20220815180441.084124063@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

commit c3e0c8c2e8b17bae30d5978bc2decdd4098f0f99 upstream.

Fully re-evaluate whether or not MMIO caching can be enabled when SPTE
masks change; simply clearing enable_mmio_caching when a configuration
isn't compatible with caching fails to handle the scenario where the
masks are updated, e.g. by VMX for EPT or by SVM to account for the C-bit
location, and toggle compatibility from false=>true.

Snapshot the original module param so that re-evaluating MMIO caching
preserves userspace's desire to allow caching.  Use a snapshot approach
so that enable_mmio_caching still reflects KVM's actual behavior.

Fixes: 8b9e74bfbf8c ("KVM: x86/mmu: Use enable_mmio_caching to track if MMIO caching is enabled")
Reported-by: Michael Roth <michael.roth@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: stable@vger.kernel.org
Tested-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Message-Id: <20220803224957.1285926-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c  |    4 ++++
 arch/x86/kvm/mmu/spte.c |   19 +++++++++++++++++++
 arch/x86/kvm/mmu/spte.h |    1 +
 3 files changed, 24 insertions(+)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6274,11 +6274,15 @@ static int set_nx_huge_pages(const char
 /*
  * nx_huge_pages needs to be resolved to true/false when kvm.ko is loaded, as
  * its default value of -1 is technically undefined behavior for a boolean.
+ * Forward the module init call to SPTE code so that it too can handle module
+ * params that need to be resolved/snapshot.
  */
 void __init kvm_mmu_x86_module_init(void)
 {
 	if (nx_huge_pages == -1)
 		__set_nx_huge_pages(get_nx_auto_mode());
+
+	kvm_mmu_spte_module_init();
 }
 
 /*
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -20,6 +20,7 @@
 #include <asm/vmx.h>
 
 bool __read_mostly enable_mmio_caching = true;
+static bool __ro_after_init allow_mmio_caching;
 module_param_named(mmio_caching, enable_mmio_caching, bool, 0444);
 EXPORT_SYMBOL_GPL(enable_mmio_caching);
 
@@ -43,6 +44,18 @@ u64 __read_mostly shadow_nonpresent_or_r
 
 u8 __read_mostly shadow_phys_bits;
 
+void __init kvm_mmu_spte_module_init(void)
+{
+	/*
+	 * Snapshot userspace's desire to allow MMIO caching.  Whether or not
+	 * KVM can actually enable MMIO caching depends on vendor-specific
+	 * hardware capabilities and other module params that can't be resolved
+	 * until the vendor module is loaded, i.e. enable_mmio_caching can and
+	 * will change when the vendor module is (re)loaded.
+	 */
+	allow_mmio_caching = enable_mmio_caching;
+}
+
 static u64 generation_mmio_spte_mask(u64 gen)
 {
 	u64 mask;
@@ -338,6 +351,12 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio
 	BUG_ON((u64)(unsigned)access_mask != access_mask);
 	WARN_ON(mmio_value & shadow_nonpresent_or_rsvd_lower_gfn_mask);
 
+	/*
+	 * Reset to the original module param value to honor userspace's desire
+	 * to (dis)allow MMIO caching.  Update the param itself so that
+	 * userspace can see whether or not KVM is actually using MMIO caching.
+	 */
+	enable_mmio_caching = allow_mmio_caching;
 	if (!enable_mmio_caching)
 		mmio_value = 0;
 
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -444,6 +444,7 @@ static inline u64 restore_acc_track_spte
 
 u64 kvm_mmu_changed_pte_notifier_make_spte(u64 old_spte, kvm_pfn_t new_pfn);
 
+void __init kvm_mmu_spte_module_init(void);
 void kvm_mmu_reset_all_pte_masks(void);
 
 #endif


