Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 476DE197CFF
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 15:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbgC3NdP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 09:33:15 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:44586 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726548AbgC3NdP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Mar 2020 09:33:15 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 426FA68E36849A6AB0BF;
        Mon, 30 Mar 2020 21:33:04 +0800 (CST)
Received: from localhost (10.173.111.169) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Mon, 30 Mar 2020
 21:32:57 +0800
From:   Zhuang Yanying <ann.zhuangyanying@huawei.com>
To:     <tv@lio96.de>, <stable@vger.kernel.org>, <pbonzini@redhat.com>
CC:     <greg@kroah.com>, LinFeng <linfeng23@huawei.com>,
        Zhuang Yanying <ann.zhuangyanying@huawei.com>
Subject: [PATCH 2/2] KVM: special handling of zero_page in some flows
Date:   Mon, 30 Mar 2020 21:32:42 +0800
Message-ID: <1585575162-37912-3-git-send-email-ann.zhuangyanying@huawei.com>
X-Mailer: git-send-email 1.8.5.2.msysgit.0
In-Reply-To: <1585575162-37912-1-git-send-email-ann.zhuangyanying@huawei.com>
References: <8350b14e-f708-f2e3-19cd-4e85a4a3235c@redhat.com>
 <1585575162-37912-1-git-send-email-ann.zhuangyanying@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.173.111.169]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: LinFeng <linfeng23@huawei.com>

Just adding !is_zero_page() to kvm_is_reserved_pfn() is too
rough. According to commit:e433e83bc3("KVM: MMU: Do not treat
ZONE_DEVICE pages as being reserved"), special handling in some
other flows is also need by zero_page, if not treat zero_page as
being reserved.

Signed-off-by: LinFeng <linfeng23@huawei.com>
Signed-off-by: Zhuang Yanying <ann.zhuangyanying@huawei.com>
---
 arch/x86/kvm/mmu.c  | 2 ++
 virt/kvm/kvm_main.c | 6 +++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index d9c7e986b4e4..63155e67abf7 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2826,6 +2826,7 @@ static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
 	 * here.
 	 */
 	if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn) &&
+	    !is_zero_pfn(pfn) &&
 	    level == PT_PAGE_TABLE_LEVEL &&
 	    PageTransCompoundMap(pfn_to_page(pfn)) &&
 	    !mmu_gfn_lpage_is_disallowed(vcpu, gfn, PT_DIRECTORY_LEVEL)) {
@@ -4788,6 +4789,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 		 */
 		if (sp->role.direct &&
 			!kvm_is_reserved_pfn(pfn) &&
+			!is_zero_pfn(pfn) &&
 			PageTransCompoundMap(pfn_to_page(pfn))) {
 			drop_spte(kvm, sptep);
 			need_tlb_flush = 1;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d49cdd6ca883..ddc8c2a6e206 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1658,7 +1658,7 @@ static struct page *kvm_pfn_to_page(kvm_pfn_t pfn)
 	if (is_error_noslot_pfn(pfn))
 		return KVM_ERR_PTR_BAD_PAGE;
 
-	if (kvm_is_reserved_pfn(pfn)) {
+	if (kvm_is_reserved_pfn(pfn) && is_zero_pfn(pfn)) {
 		WARN_ON(1);
 		return KVM_ERR_PTR_BAD_PAGE;
 	}
@@ -1717,7 +1717,7 @@ static void kvm_release_pfn_dirty(kvm_pfn_t pfn)
 
 void kvm_set_pfn_dirty(kvm_pfn_t pfn)
 {
-	if (!kvm_is_reserved_pfn(pfn)) {
+	if (!kvm_is_reserved_pfn(pfn) && !is_zero_pfn(pfn)) {
 		struct page *page = pfn_to_page(pfn);
 
 		if (!PageReserved(page))
@@ -1728,7 +1728,7 @@ EXPORT_SYMBOL_GPL(kvm_set_pfn_dirty);
 
 void kvm_set_pfn_accessed(kvm_pfn_t pfn)
 {
-	if (!kvm_is_reserved_pfn(pfn))
+	if (!kvm_is_reserved_pfn(pfn) && !is_zero_pfn(pfn))
 		mark_page_accessed(pfn_to_page(pfn));
 }
 EXPORT_SYMBOL_GPL(kvm_set_pfn_accessed);
-- 
2.23.0


