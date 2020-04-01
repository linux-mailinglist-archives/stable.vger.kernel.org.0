Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7BD19AC1A
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 14:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732637AbgDAMxc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 08:53:32 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:48480 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732579AbgDAMxb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 08:53:31 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E00B3DC75536BD580075;
        Wed,  1 Apr 2020 20:52:30 +0800 (CST)
Received: from localhost (10.173.111.169) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Wed, 1 Apr 2020
 20:52:23 +0800
From:   Zhuang Yanying <ann.zhuangyanying@huawei.com>
To:     <pbonzini@redhat.com>, <greg@kroah.com>
CC:     <tv@lio96.de>, <stable@vger.kernel.org>,
        LinFeng <linfeng23@huawei.com>
Subject: [PATCH 0/2] KVM: fix overflow of zero page refcount with ksm running
Date:   Wed, 1 Apr 2020 20:50:54 +0800
Message-ID: <1585745456-24340-1-git-send-email-ann.zhuangyanying@huawei.com>
X-Mailer: git-send-email 1.8.5.2.msysgit.0
MIME-Version: 1.0
Content-Type: text/plain
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
other flows is also need by zero_page, if we would treat zero_page
as being reserved.

Well, as fixing all functions reference to kvm_is_reserved_pfn() in
this patch, we found that only kvm_release_pfn_clean() and
kvm_get_pfn() don't need special handling.

So, we thought why not only check is_zero_page() in before get and
put page, and revert our last commit:31e813f38f("KVM: fix overflow
of zero page refcount with ksm running") in master.
Instead of adding !is_zero_page() in kvm_is_reserved_pfn(),
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

And we check the code of v4.9.y v4.10.y v4.11.y v4.12.y, this bug exists
in v4.11.y and later, but not in v4.9.y v4.10.y or before.
After commit:e86c59b1b1("mm/ksm: improve deduplication of zero pages
with colouring"), ksm will use zero pages with colouring. This feature
was added in v4.11.y, so I wonder why v4.9.y has this bug.

We use crash tools attaching to /proc/kcore to check the refcount of
zero_page, then create and destroy vm. The refcount stays at 1 on v4.9.y,
well it increases only after v4.11.y. Are you sure it is the same bug
you run into? Is there something we missing?

LinFeng (1):
  KVM: special handling of zero_page in some flows

Zhuang Yanying (1):
  KVM: fix overflow of zero page refcount with ksm running

 arch/x86/kvm/mmu.c  | 2 ++
 virt/kvm/kvm_main.c | 9 +++++----
 2 files changed, 7 insertions(+), 4 deletions(-)

-- 
2.23.0


