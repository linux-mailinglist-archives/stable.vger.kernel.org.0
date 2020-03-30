Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF524197CFE
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 15:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgC3NdK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 09:33:10 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:49758 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727929AbgC3NdK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Mar 2020 09:33:10 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 3354C749177CF6EB9D87;
        Mon, 30 Mar 2020 21:33:07 +0800 (CST)
Received: from localhost (10.173.111.169) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Mon, 30 Mar 2020
 21:32:57 +0800
From:   Zhuang Yanying <ann.zhuangyanying@huawei.com>
To:     <tv@lio96.de>, <stable@vger.kernel.org>, <pbonzini@redhat.com>
CC:     <greg@kroah.com>, LinFeng <linfeng23@huawei.com>
Subject: [PATCH 0/2] KVM: fix overflow of zero page refcount with ksm running
Date:   Mon, 30 Mar 2020 21:32:40 +0800
Message-ID: <1585575162-37912-1-git-send-email-ann.zhuangyanying@huawei.com>
X-Mailer: git-send-email 1.8.5.2.msysgit.0
In-Reply-To: <8350b14e-f708-f2e3-19cd-4e85a4a3235c@redhat.com>
References: <8350b14e-f708-f2e3-19cd-4e85a4a3235c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.111.169]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: LinFeng <linfeng23@huawei.com>

We found that the !is_zero_page() in kvm_is_mmio_pfn() was
submmited in commit:90cff5a8cc("KVM: check for !is_zero_pfn() in
kvm_is_mmio_pfn()"), but reverted in commit:0ef2459983("kvm: fix
kvm_is_mmio_pfn() and rename to kvm_is_reserved_pfn()").

Maybe just adding !is_zero_page() to kvm_is_reserved_pfn() is too
rough. According to commit:e433e83bc3("KVM: MMU: Do not treat
ZONE_DEVICE pages as being reserved"), special handling in some
other flows is also need by zero_page, if we treat zero_page as
being reserved.

Well, as fixing all functions reference to kvm_is_reserved_pfn() in
this patch, we found that only kvm_release_pfn_clean() and
kvm_get_pfn() don't need special handling.

So, we thought why not only check is_zero_page() in before get and
put page, and revert our last commit:31e813f38f("KVM: fix overflow
of zero page refcount with ksm running").
Instead of add !is_zero_page() in kvm_is_reserved_pfn(),
new idea is as follow:

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7f9ee2929cfe..f9a1f9cf188e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1695,7 +1695,8 @@ EXPORT_SYMBOL_GPL(kvm_release_page_clean);
 
 void kvm_release_pfn_clean(kvm_pfn_t pfn)
 {
-	if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn))
+	if (!is_error_noslot_pfn(pfn) &&
+	    (!kvm_is_reserved_pfn(pfn) || is_zero_pfn(pfn)))
 		put_page(pfn_to_page(pfn));
 }
 EXPORT_SYMBOL_GPL(kvm_release_pfn_clean);
@@ -1734,7 +1735,7 @@ EXPORT_SYMBOL_GPL(kvm_set_pfn_accessed);
 
 void kvm_get_pfn(kvm_pfn_t pfn)
 {
-	if (!kvm_is_reserved_pfn(pfn))
+	if (!kvm_is_reserved_pfn(pfn) || is_zero_pfn(pfn))
 		get_page(pfn_to_page(pfn));
 }
 EXPORT_SYMBOL_GPL(kvm_get_pfn);

We are confused why ZONE_DEVICE not do this, but treating it as
no reserved. Is it racy if we change only use the patch in cover letter,
but not the series patches.

LinFeng (1):
  KVM: special handling of zero_page in some flows

Zhuang Yanying (1):
  KVM: fix overflow of zero page refcount with ksm running

 arch/x86/kvm/mmu.c  | 2 ++
 virt/kvm/kvm_main.c | 9 +++++----
 2 files changed, 7 insertions(+), 4 deletions(-)

-- 
2.23.0


