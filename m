Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 306B919BE52
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 11:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387865AbgDBJDp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 05:03:45 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:12605 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728612AbgDBJDp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Apr 2020 05:03:45 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 1A79BD675952EEFFFF05;
        Thu,  2 Apr 2020 17:03:35 +0800 (CST)
Received: from localhost (10.173.111.169) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Thu, 2 Apr 2020
 17:03:25 +0800
From:   Zhuang Yanying <ann.zhuangyanying@huawei.com>
To:     <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>,
        Zhuang Yanying <ann.zhuangyanying@huawei.com>,
        <stable@vger.kernel.org>, LinFeng <linfeng23@huawei.com>
Subject: [PATCH] KVM: special handling of zero_page in some flows
Date:   Thu, 2 Apr 2020 17:03:22 +0800
Message-ID: <1585818202-28564-1-git-send-email-ann.zhuangyanying@huawei.com>
X-Mailer: git-send-email 1.8.5.2.msysgit.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.173.111.169]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We found that the !is_zero_page() in kvm_is_mmio_pfn() was submmited
in commit:85c8555ff0("KVM: check for !is_zero_pfn() in
kvm_is_mmio_pfn()"), but reverted in commit:bf4bea8e9a("kvm: fix
kvm_is_mmio_pfn() and rename to kvm_is_reserved_pfn()").

Maybe just adding !is_zero_page() to kvm_is_reserved_pfn() is too
rough. According to commit:a78986aae9("KVM: MMU: Do not treat
ZONE_DEVICE pages as being reserved"), special handling in some other
flows is also need by zero_page, if we would not treat zero_page as
being reserved.

And we check the code of v4.9.y v4.10.y v4.11.y v4.12.y, this bug
exists in v4.11.y and later, but not in v4.9.y v4.10.y or before.
After commit:e86c59b1b1("mm/ksm: improve deduplication of zero pages
with colouring"), ksm will use zero pages with colouring.

We use crash tools attaching to /proc/kcore to check the refcount of
zero_page, then create and destroy vm. The refcount stays at 1 on
v4.9.y, well it increases only after v4.11.y.

Fix commit:7df003c852("KVM: fix overflow of zero page refcount with
ksm running")

Cc: stable@vger.kernel.org
Signed-off-by: LinFeng <linfeng23@huawei.com>
Signed-off-by: Zhuang Yanying <ann.zhuangyanying@huawei.com>
---
Well, as fixing all functions reference to kvm_is_reserved_pfn() in
this patch, we found that only kvm_release_pfn_clean() and
kvm_get_pfn() don't need special handling.

So, we thought why not only check is_zero_page() in before get and put
page, and revert our last commit:7df003c852("KVM: fix overflow of zero
page refcount with ksm running").
Instead of adding !is_zero_page() in kvm_is_reserved_pfn(), new idea
is as follow:

 >diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
 >7f9ee2929cfe..f9a1f9cf188e 100644
 >--- a/virt/kvm/kvm_main.c
 >+++ b/virt/kvm/kvm_main.c
 >@@ -1695,7 +1695,8 @@ EXPORT_SYMBOL_GPL(kvm_release_page_clean);
 >
 > void kvm_release_pfn_clean(kvm_pfn_t pfn)  {
 >-	if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn))
 >+	if (!is_error_noslot_pfn(pfn) &&
 >+	    (!kvm_is_reserved_pfn(pfn) || is_zero_pfn(pfn)))
 > 		put_page(pfn_to_page(pfn));
 > }
 > EXPORT_SYMBOL_GPL(kvm_release_pfn_clean);
 >@@ -1734,7 +1735,7 @@ EXPORT_SYMBOL_GPL(kvm_set_pfn_accessed);
 >
 > void kvm_get_pfn(kvm_pfn_t pfn)
 > {
 >-	if (!kvm_is_reserved_pfn(pfn))
 >+	if (!kvm_is_reserved_pfn(pfn) || is_zero_pfn(pfn))
 > 		get_page(pfn_to_page(pfn));
 > }
 > EXPORT_SYMBOL_GPL(kvm_get_pfn);

We are confused why ZONE_DEVICE not do this, but treating it as no
reserved. Is it racy if we only use the patch above, and revert our
last commit:7df003c852("KVM: fix overflow of zero page refcount with
ksm running").
---
 arch/x86/kvm/mmu/mmu.c | 4 +++-
 virt/kvm/kvm_main.c    | 8 +++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 87e9ba27ada1..c82c0dfd3a67 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3285,7 +3285,8 @@ static int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 	if (unlikely(max_level == PT_PAGE_TABLE_LEVEL))
 		return PT_PAGE_TABLE_LEVEL;
 
-	if (is_error_noslot_pfn(pfn) || kvm_is_reserved_pfn(pfn))
+	if (is_error_noslot_pfn(pfn) || kvm_is_reserved_pfn(pfn) ||
+	    is_zero_pfn(pfn))
 		return PT_PAGE_TABLE_LEVEL;
 
 	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, true);
@@ -5914,6 +5915,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 		 * mapping if the indirect sp has level = 1.
 		 */
 		if (sp->role.direct && !kvm_is_reserved_pfn(pfn) &&
+		    !is_zero_pfn(pfn) &&
 		    (kvm_is_zone_device_pfn(pfn) ||
 		     PageCompound(pfn_to_page(pfn)))) {
 			pte_list_remove(rmap_head, sptep);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 70f03ce0e5c1..dff3b94e6270 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1800,7 +1800,7 @@ static struct page *kvm_pfn_to_page(kvm_pfn_t pfn)
 	if (is_error_noslot_pfn(pfn))
 		return KVM_ERR_PTR_BAD_PAGE;
 
-	if (kvm_is_reserved_pfn(pfn)) {
+	if (kvm_is_reserved_pfn(pfn) && !is_zero_pfn(pfn)) {
 		WARN_ON(1);
 		return KVM_ERR_PTR_BAD_PAGE;
 	}
@@ -2007,14 +2007,16 @@ EXPORT_SYMBOL_GPL(kvm_release_pfn_dirty);
 
 void kvm_set_pfn_dirty(kvm_pfn_t pfn)
 {
-	if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn))
+	if (!kvm_is_reserved_pfn(pfn) &&
+	    !kvm_is_zone_device_pfn(pfn) && !is_zero_pfn(pfn))
 		SetPageDirty(pfn_to_page(pfn));
 }
 EXPORT_SYMBOL_GPL(kvm_set_pfn_dirty);
 
 void kvm_set_pfn_accessed(kvm_pfn_t pfn)
 {
-	if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn))
+	if (!kvm_is_reserved_pfn(pfn) &&
+	    !kvm_is_zone_device_pfn(pfn) && !is_zero_pfn(pfn))
 		mark_page_accessed(pfn_to_page(pfn));
 }
 EXPORT_SYMBOL_GPL(kvm_set_pfn_accessed);
-- 
2.19.1


