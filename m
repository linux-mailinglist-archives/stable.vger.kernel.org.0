Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1F4B1FBB2F
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730863AbgFPPjK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:39:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:52218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730855AbgFPPjJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:39:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09BB72145D;
        Tue, 16 Jun 2020 15:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592321948;
        bh=GssrMXDNOwDHdJuiCAJNLMd36mCN15OYRpsTd2kEqN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=19hqMeGlQcsqITZ2lbAcNpiMUyb8Vpy+LvnHerCkHS3oY6Uzb0eiy/J9e3MOtGJgs
         URlT9WGIc6jTU4jJXcO1zhiH7VstWbDuie7OIv3mrpOPZV+49iuxIKIjxGTH9flEW8
         7t95HMJJy5jaGpmxmJxRodLpenwi7Dgsm/Htg2UI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eiichi Tsukata <eiichi.tsukata@nutanix.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.4 047/134] KVM: x86: Fix APIC page invalidation race
Date:   Tue, 16 Jun 2020 17:33:51 +0200
Message-Id: <20200616153103.047680094@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153100.633279950@linuxfoundation.org>
References: <20200616153100.633279950@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eiichi Tsukata <eiichi.tsukata@nutanix.com>

commit e649b3f0188f8fd34dd0dde8d43fd3312b902fb2 upstream.

Commit b1394e745b94 ("KVM: x86: fix APIC page invalidation") tried
to fix inappropriate APIC page invalidation by re-introducing arch
specific kvm_arch_mmu_notifier_invalidate_range() and calling it from
kvm_mmu_notifier_invalidate_range_start. However, the patch left a
possible race where the VMCS APIC address cache is updated *before*
it is unmapped:

  (Invalidator) kvm_mmu_notifier_invalidate_range_start()
  (Invalidator) kvm_make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD)
  (KVM VCPU) vcpu_enter_guest()
  (KVM VCPU) kvm_vcpu_reload_apic_access_page()
  (Invalidator) actually unmap page

Because of the above race, there can be a mismatch between the
host physical address stored in the APIC_ACCESS_PAGE VMCS field and
the host physical address stored in the EPT entry for the APIC GPA
(0xfee0000).  When this happens, the processor will not trap APIC
accesses, and will instead show the raw contents of the APIC-access page.
Because Windows OS periodically checks for unexpected modifications to
the LAPIC register, this will show up as a BSOD crash with BugCheck
CRITICAL_STRUCTURE_CORRUPTION (109) we are currently seeing in
https://bugzilla.redhat.com/show_bug.cgi?id=1751017.

The root cause of the issue is that kvm_arch_mmu_notifier_invalidate_range()
cannot guarantee that no additional references are taken to the pages in
the range before kvm_mmu_notifier_invalidate_range_end().  Fortunately,
this case is supported by the MMU notifier API, as documented in
include/linux/mmu_notifier.h:

	 * If the subsystem
         * can't guarantee that no additional references are taken to
         * the pages in the range, it has to implement the
         * invalidate_range() notifier to remove any references taken
         * after invalidate_range_start().

The fix therefore is to reload the APIC-access page field in the VMCS
from kvm_mmu_notifier_invalidate_range() instead of ..._range_start().

Cc: stable@vger.kernel.org
Fixes: b1394e745b94 ("KVM: x86: fix APIC page invalidation")
Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=197951
Signed-off-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
Message-Id: <20200606042627.61070-1-eiichi.tsukata@nutanix.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c       |    7 ++-----
 include/linux/kvm_host.h |    4 ++--
 virt/kvm/kvm_main.c      |   26 ++++++++++++++++----------
 3 files changed, 20 insertions(+), 17 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7978,9 +7978,8 @@ static void vcpu_load_eoi_exitmap(struct
 	kvm_x86_ops->load_eoi_exitmap(vcpu, eoi_exit_bitmap);
 }
 
-int kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
-		unsigned long start, unsigned long end,
-		bool blockable)
+void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
+					    unsigned long start, unsigned long end)
 {
 	unsigned long apic_address;
 
@@ -7991,8 +7990,6 @@ int kvm_arch_mmu_notifier_invalidate_ran
 	apic_address = gfn_to_hva(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
 	if (start <= apic_address && apic_address < end)
 		kvm_make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD);
-
-	return 0;
 }
 
 void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1376,8 +1376,8 @@ static inline long kvm_arch_vcpu_async_i
 }
 #endif /* CONFIG_HAVE_KVM_VCPU_ASYNC_IOCTL */
 
-int kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
-		unsigned long start, unsigned long end, bool blockable);
+void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
+					    unsigned long start, unsigned long end);
 
 #ifdef CONFIG_HAVE_KVM_VCPU_RUN_PID_CHANGE
 int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu);
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -157,10 +157,9 @@ static void kvm_uevent_notify_change(uns
 static unsigned long long kvm_createvm_count;
 static unsigned long long kvm_active_vms;
 
-__weak int kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
-		unsigned long start, unsigned long end, bool blockable)
+__weak void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
+						   unsigned long start, unsigned long end)
 {
-	return 0;
 }
 
 bool kvm_is_zone_device_pfn(kvm_pfn_t pfn)
@@ -381,6 +380,18 @@ static inline struct kvm *mmu_notifier_t
 	return container_of(mn, struct kvm, mmu_notifier);
 }
 
+static void kvm_mmu_notifier_invalidate_range(struct mmu_notifier *mn,
+					      struct mm_struct *mm,
+					      unsigned long start, unsigned long end)
+{
+	struct kvm *kvm = mmu_notifier_to_kvm(mn);
+	int idx;
+
+	idx = srcu_read_lock(&kvm->srcu);
+	kvm_arch_mmu_notifier_invalidate_range(kvm, start, end);
+	srcu_read_unlock(&kvm->srcu, idx);
+}
+
 static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 					struct mm_struct *mm,
 					unsigned long address,
@@ -405,7 +416,6 @@ static int kvm_mmu_notifier_invalidate_r
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
 	int need_tlb_flush = 0, idx;
-	int ret;
 
 	idx = srcu_read_lock(&kvm->srcu);
 	spin_lock(&kvm->mmu_lock);
@@ -422,14 +432,9 @@ static int kvm_mmu_notifier_invalidate_r
 		kvm_flush_remote_tlbs(kvm);
 
 	spin_unlock(&kvm->mmu_lock);
-
-	ret = kvm_arch_mmu_notifier_invalidate_range(kvm, range->start,
-					range->end,
-					mmu_notifier_range_blockable(range));
-
 	srcu_read_unlock(&kvm->srcu, idx);
 
-	return ret;
+	return 0;
 }
 
 static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
@@ -535,6 +540,7 @@ static void kvm_mmu_notifier_release(str
 }
 
 static const struct mmu_notifier_ops kvm_mmu_notifier_ops = {
+	.invalidate_range	= kvm_mmu_notifier_invalidate_range,
 	.invalidate_range_start	= kvm_mmu_notifier_invalidate_range_start,
 	.invalidate_range_end	= kvm_mmu_notifier_invalidate_range_end,
 	.clear_flush_young	= kvm_mmu_notifier_clear_flush_young,


