Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFF932BC31
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347900AbhCCNoA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:44:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1842929AbhCCKWi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 05:22:38 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0435CC08ECB5;
        Wed,  3 Mar 2021 02:01:39 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id j12so15874803pfj.12;
        Wed, 03 Mar 2021 02:01:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8DrZrPQbyPtgf2aW639cqNZTuk5sChQgDw7fi81dRqU=;
        b=GRI7FdF3WjDJBJwLyAIRUyb/6dNvkGLEFbRin86oTgDmPfK8yt2xIz9eD6Y54f1QqI
         Sk+ekbnCaBOpIIhSMfTIGLFF0fZpvTSbESePjq2VIvfczqPdiEnSBsjeBz6alijtOgsB
         sVA/7DRhikwKbl2eWxQv8GKx6bZFn5i5auNco+fQU2oh/4eXQ9yfr/jqXnyOSvpBlRzB
         88f2bYJcGQ5lZ0QknYqUygzV4IiMIXkN5MMmDQgJiRA/kX988l00Vvao3DS3VVAtt0AK
         itH+6r4S8ZSXhjghXAOX8njzvFY7NG6OpwDUXkpSxPw0tCuPmRW8jf7iOCdOVBMsyHog
         kVRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8DrZrPQbyPtgf2aW639cqNZTuk5sChQgDw7fi81dRqU=;
        b=FT9UzjvqVcSxy0dNJSvprH+ybZ+X/qs2dbYuK0zGy68PT7lkkO/8Rj099AZGbbixVV
         FE4rmDMzs+r8QnT+aJ/VlvgUY77pcxpnOrlYrvslTTztftRrWDvX58gbRjYKdHyy4n0a
         fqH98dO7XTzCEE2e6MK5yShBhJSFNIKVZ6RG8teuYKJFWZsVvWeKAM3DyxUd74VkhKR7
         fiDlYWdN8mIljCEiQamOPIojCOc5fG+Nkxb6ZZBxPIyAYN8Xp4WOvmVoVtzd7CTRQC7q
         O4PogNuFs9LeP/M3PYRhM6EDtPyoIDXGiTSvVTmkbgpIUXienFDqIauMNhFN0uou6xz7
         g+gA==
X-Gm-Message-State: AOAM533HOT1rmBjkqOwUQl674l+jUBGcYRTdcc809h+FMw9gZTgMyTOz
        g7TekLOIl7ZygTrP2p1UaIEza4IZxm5ZTVh7
X-Google-Smtp-Source: ABdhPJwO84KcxWuPUTPVV2FhPZV0rM7ZW1OyKzHFpIIDtlCgIYuaYNUj8cHdCyvvqOm8S9Kb8dtGYA==
X-Received: by 2002:a62:e809:0:b029:1ed:c7ec:179b with SMTP id c9-20020a62e8090000b02901edc7ec179bmr2306577pfi.43.1614765699341;
        Wed, 03 Mar 2021 02:01:39 -0800 (PST)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id 132sm2292606pfu.158.2021.03.03.02.01.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 02:01:38 -0800 (PST)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     linux-mm@kvack.org
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Nadav Amit <namit@vmware.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Minchan Kim <minchan@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org,
        Yu Zhao <yuzhao@google.com>
Subject: [PATCH RESEND v3] mm/userfaultfd: fix memory corruption due to writeprotect
Date:   Wed,  3 Mar 2021 01:57:02 -0800
Message-Id: <20210303095702.3814618-1-namit@vmware.com>
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
Cc: Peter Xu <peterx@redhat.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org
Suggested-by: Yu Zhao <yuzhao@google.com>
Fixes: 292924b26024 ("userfaultfd: wp: apply _PAGE_UFFD_WP bit")
Signed-off-by: Nadav Amit <namit@vmware.com>

---
v2->v3:
* Do not acquire mmap_lock for write, flush conditionally instead [Yu]
* Change the fixes tag to the patch that made the race apparent [Yu]
* Removing patch to avoid write-protect on uffd unprotect. More
  comprehensive solution to follow (and avoid the TLB flush as well).
---
 mm/memory.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index 9e8576a83147..06da04f98936 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3092,6 +3092,13 @@ static vm_fault_t do_wp_page(struct vm_fault *vmf)
 		return handle_userfault(vmf, VM_UFFD_WP);
 	}
 
+	/*
+	 * Userfaultfd write-protect can defer flushes. Ensure the TLB
+	 * is flushed in this case before copying.
+	 */
+	if (userfaultfd_wp(vmf->vma) && mm_tlb_flush_pending(vmf->vma->vm_mm))
+		flush_tlb_page(vmf->vma, vmf->address);
+
 	vmf->page = vm_normal_page(vma, vmf->address, vmf->orig_pte);
 	if (!vmf->page) {
 		/*
-- 
2.25.1

