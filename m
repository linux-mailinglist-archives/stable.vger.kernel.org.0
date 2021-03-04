Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E249732D043
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 11:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238183AbhCDJ71 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 04:59:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238178AbhCDJ7Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 04:59:25 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A2CC061574;
        Thu,  4 Mar 2021 01:58:59 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id s23so6541456pji.1;
        Thu, 04 Mar 2021 01:58:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n4CkASMCqnRVKlVMuJIlE3MUCpSbMkYMNXckSMWm4yU=;
        b=kD12OzyrjUv66c03Uw8JyGct02j39byIAVQFPy6UHJHrlPPciybOg2kcF90RCEzvPp
         BOASrUL8jYq3O+VLz+Qhlx6/MtJ29eQwxLorY2NT9i9xUQij+1BxCkexGif8nEJNfXmx
         V+NrpzmY8rUXFounOiJuCEXwG2qEKKImOMD2qW0DeO7g0MKne00MmADavgl3nHiyg5kD
         GJQI62DCzVFOaoFmejkNCFSZcauw0Jcyo2Lqg+opaDR5txmoZlb9AAIfenlJu2lNYTBI
         pkQHCns3c3blvQswShIsz05pAXNU3q+Blfium59uxCnNtf5THamebdhOb//+TcbLWAEo
         k0Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n4CkASMCqnRVKlVMuJIlE3MUCpSbMkYMNXckSMWm4yU=;
        b=OQcfepajcMmkrANCQDqGazw74TXAY5ffWjjVs5hOPzbZdJ51BjZ9xi7xwFWjKE51if
         1o3jbViZuaFxkDbVJLHNs10o/3M2yVROpu8aReK2TYPtiK8yq1+q2M06pMMPeFtOBRNP
         VGo9tMPvTjYDwe+7ftQTYJchrrnaZLMUy8EC0LQFqGXYG6+/MOYYreYrGEbdFemu3xJQ
         pHvyybkd9m9XlPsMenRv/42oFVQpkWR1LFh2s+UtE+QQ31pmoiDLr7HcNiBGG1Jr7/iZ
         sdqRFlVE1hOGUiyB8z5J3ARu6iQ6Mocq/DeVkqCN9bT1hPcDp7pyVKPtESE+Oy08zTfv
         QtYw==
X-Gm-Message-State: AOAM530+GB9O3L5lImyMBRdtVuVFcEFepCV9nN1XySUSSoKF65EdZnXN
        O1eiDe18qqf2Sqkj374z+Dk=
X-Google-Smtp-Source: ABdhPJz11DGPywcaGov16qLHJPteMitUsxd1qVspYeC8e4qrs50QmNjkEhzLrLlQrMX0OpoY3+F+qQ==
X-Received: by 2002:a17:90a:7309:: with SMTP id m9mr3743213pjk.23.1614851939139;
        Thu, 04 Mar 2021 01:58:59 -0800 (PST)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id a19sm9503339pjh.39.2021.03.04.01.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 01:58:58 -0800 (PST)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     linux-mm@kvack.org
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Nadav Amit <namit@vmware.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Minchan Kim <minchan@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org,
        Yu Zhao <yuzhao@google.com>, Peter Xu <peterx@redhat.com>
Subject: [PATCH v4] mm/userfaultfd: fix memory corruption due to writeprotect
Date:   Thu,  4 Mar 2021 01:54:23 -0800
Message-Id: <20210304095423.3825684-1-namit@vmware.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

Userfaultfd self-test fails occasionally, indicating a memory
corruption.

Analyzing this problem indicates that there is a real bug since
mmap_lock is only taken for read in mwriteprotect_range() and defers
flushes, and since there is insufficient consideration of concurrent
deferred TLB flushes in wp_page_copy(). Although the PTE is flushed from
the TLBs in wp_page_copy(), this flush takes place after the copy has
already been performed, and therefore changes of the page are possible
between the time of the copy and the time in which the PTE is flushed.

To make matters worse, memory-unprotection using userfaultfd also poses
a problem. Although memory unprotection is logically a promotion of PTE
permissions, and therefore should not require a TLB flush, the current
userrfaultfd code might actually cause a demotion of the architectural
PTE permission: when userfaultfd_writeprotect() unprotects memory
region, it unintentionally *clears* the RW-bit if it was already set.
Note that this unprotecting a PTE that is not write-protected is a valid
use-case: the userfaultfd monitor might ask to unprotect a region that
holds both write-protected and write-unprotected PTEs.

The scenario that happens in selftests/vm/userfaultfd is as follows:

cpu0				cpu1			cpu2
----				----			----
							[ Writable PTE
							  cached in TLB ]
userfaultfd_writeprotect()
[ write-*unprotect* ]
mwriteprotect_range()
mmap_read_lock()
change_protection()

change_protection_range()
...
change_pte_range()
[ *clear* “write”-bit ]
[ defer TLB flushes ]
				[ page-fault ]
				...
				wp_page_copy()
				 cow_user_page()
				  [ copy page ]
							[ write to old
							  page ]
				...
				 set_pte_at_notify()

A similar scenario can happen:

cpu0		cpu1		cpu2		cpu3
----		----		----		----
						[ Writable PTE
				  		  cached in TLB ]
userfaultfd_writeprotect()
[ write-protect ]
[ deferred TLB flush ]
		userfaultfd_writeprotect()
		[ write-unprotect ]
		[ deferred TLB flush]
				[ page-fault ]
				wp_page_copy()
				 cow_user_page()
				 [ copy page ]
				 ...		[ write to page ]
				set_pte_at_notify()

This race exists since commit 292924b26024 ("userfaultfd: wp: apply
_PAGE_UFFD_WP bit"). Yet, as Yu Zhao pointed, these races became
apparent since commit 09854ba94c6a ("mm: do_wp_page() simplification")
which made wp_page_copy() more likely to take place, specifically if
page_count(page) > 1.

To resolve the aforementioned races, check whether there are pending
flushes on uffd-write-protected VMAs, and if there are, perform a flush
before doing the COW.

Further optimizations will follow to avoid during uffd-write-unprotect
unnecassary PTE write-protection and TLB flushes.

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org # 5.9+
Suggested-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Tested-by: Peter Xu <peterx@redhat.com>
Fixes: 09854ba94c6a ("mm: do_wp_page() simplification")
Signed-off-by: Nadav Amit <namit@vmware.com>

---
v3->v4:
* Fix the "Fixes" tag for real [Peter Xu]
* Reviewed-by, suggested-by tags [Peter Xu]
* Adding unlikely() [Peter Xu]

v2->v3:
* Do not acquire mmap_lock for write, flush conditionally instead [Yu]
* Change the fixes tag to the patch that made the race apparent [Yu]
* Removing patch to avoid write-protect on uffd unprotect. More
  comprehensive solution to follow (and avoid the TLB flush as well).
---
 mm/memory.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index 9e8576a83147..79253cb3bcd5 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3092,6 +3092,14 @@ static vm_fault_t do_wp_page(struct vm_fault *vmf)
 		return handle_userfault(vmf, VM_UFFD_WP);
 	}
 
+	/*
+	 * Userfaultfd write-protect can defer flushes. Ensure the TLB
+	 * is flushed in this case before copying.
+	 */
+	if (unlikely(userfaultfd_wp(vmf->vma) &&
+		     mm_tlb_flush_pending(vmf->vma->vm_mm)))
+		flush_tlb_page(vmf->vma, vmf->address);
+
 	vmf->page = vm_normal_page(vma, vmf->address, vmf->orig_pte);
 	if (!vmf->page) {
 		/*
-- 
2.25.1

