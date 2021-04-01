Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEAB8351F9C
	for <lists+stable@lfdr.de>; Thu,  1 Apr 2021 21:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235030AbhDATWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Apr 2021 15:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234326AbhDATWr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Apr 2021 15:22:47 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CFA1C049FD1
        for <stable@vger.kernel.org>; Thu,  1 Apr 2021 11:21:39 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id gy8so3855913qvb.4
        for <stable@vger.kernel.org>; Thu, 01 Apr 2021 11:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc:content-transfer-encoding;
        bh=1v73NpRb4gNLtIJ6f4iTsLt04NK7xDWlZvvGIJeIyOY=;
        b=BGhVoWtyVDS11um69GvHWaBxjInp0xc3nZ5igQbDAiVstwD+DwfnURZTAVsHvefgul
         54CNcu4PR19AQT/0CY7RzNPbivkK8sBS4gr5l9Y8nIqdzfWJXgPSfyuryUbXs1i117CW
         ypS9RQXBq/eURlzTCMmK5OT5dgKf2sJM9PYhQwlJ24MLApAGorTD0mAVAvC8SCFmekKR
         rJ53gDagXqpf+orSrLVUX6slrSoSNg32aHBosaupo8IXy6ULWRPhUqVFRP319BpvKy4q
         0jADW5Au3xewFYvz4nt8yaXmmPjjO63lVrGa6MCKaHqCIhu3+iCbTWipUikh7ZnmJxXZ
         YgBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc:content-transfer-encoding;
        bh=1v73NpRb4gNLtIJ6f4iTsLt04NK7xDWlZvvGIJeIyOY=;
        b=tCjhmXAKTd/H8OeqXDOTNnm9PkxbryiQoqMZf2ipnep2XiZQfw25UXzDmKpASrU3VN
         ZK8gfSDIM6TGCkbllZgB/NrahAOr6PTGZdzgGTqzmSESeXywSMBmrRk1QptDe/5RB1kJ
         gAYBlhOXetXQpa9BuxXd9EEon7GG2VlUl2Fk5zAR51ng2Pwwfacf2cBhkYNaJpOWBnOa
         01KroUwT6SyxiUycUYeltLGbHAEiBoVkfSxtYnJc8W8Lqs2zTHzAoN28fdiWHWOOHG1Y
         nJU85gqXY9wv+V5v2aRTfmL6cMQcFKS7e6osHFqewI4Sthe1xBqzAP6fpM4/N+hrtUyR
         rGdw==
X-Gm-Message-State: AOAM533jRBKRYlpBbmqVyttqNL3bjWBP8xWaeeywAgO9HKwupLKvYl0i
        BTteKUNg0EyUvKSKMjX8j+7Dpo6FZtAlaM/XKKSXTRm3xARI/++QsR77GaRoBmvsXaA17oXJhfG
        QBRgk1JfejQmNDnJinlcPtJz/oQjYY8DOhU73JKvK0UTBbVHYH7BNtz5NQ9lLVg==
X-Google-Smtp-Source: ABdhPJwxEkRxWitj7VWGtbxQbGP2KZXXbWNT/3WR7Y0OIP2YMtheTtde/hB1RIvwzNn28Us9gKp/DzrgxuY=
X-Received: from surenb1.mtv.corp.google.com ([2620:15c:211:200:899:1066:21fc:b3c5])
 (user=surenb job=sendgmr) by 2002:ad4:50c7:: with SMTP id e7mr9408265qvq.58.1617301298047;
 Thu, 01 Apr 2021 11:21:38 -0700 (PDT)
Date:   Thu,  1 Apr 2021 11:21:25 -0700
In-Reply-To: <20210401182125.171484-1-surenb@google.com>
Message-Id: <20210401182125.171484-6-surenb@google.com>
Mime-Version: 1.0
References: <20210401182125.171484-1-surenb@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 5/5] mm/userfaultfd: fix memory corruption due to writeprotect
From:   Suren Baghdasaryan <surenb@google.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, jannh@google.com, ktkhai@virtuozzo.com,
        torvalds@linux-foundation.org, shli@fb.com, namit@vmware.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, surenb@google.com,
        Yu Zhao <yuzhao@google.com>, Peter Xu <peterx@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Minchan Kim <minchan@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

Userfaultfd self-test fails occasionally, indicating a memory corruption.

Analyzing this problem indicates that there is a real bug since mmap_lock
is only taken for read in mwriteprotect_range() and defers flushes, and
since there is insufficient consideration of concurrent deferred TLB
flushes in wp_page_copy().  Although the PTE is flushed from the TLBs in
wp_page_copy(), this flush takes place after the copy has already been
performed, and therefore changes of the page are possible between the time
of the copy and the time in which the PTE is flushed.

To make matters worse, memory-unprotection using userfaultfd also poses a
problem.  Although memory unprotection is logically a promotion of PTE
permissions, and therefore should not require a TLB flush, the current
userrfaultfd code might actually cause a demotion of the architectural PTE
permission: when userfaultfd_writeprotect() unprotects memory region, it
unintentionally *clears* the RW-bit if it was already set.  Note that this
unprotecting a PTE that is not write-protected is a valid use-case: the
userfaultfd monitor might ask to unprotect a region that holds both
write-protected and write-unprotected PTEs.

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
[ *clear* =E2=80=9Cwrite=E2=80=9D-bit ]
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
_PAGE_UFFD_WP bit").  Yet, as Yu Zhao pointed, these races became apparent
since commit 09854ba94c6a ("mm: do_wp_page() simplification") which made
wp_page_copy() more likely to take place, specifically if page_count(page)
> 1.

To resolve the aforementioned races, check whether there are pending
flushes on uffd-write-protected VMAs, and if there are, perform a flush
before doing the COW.

Further optimizations will follow to avoid during uffd-write-unprotect
unnecassary PTE write-protection and TLB flushes.

Link: https://lkml.kernel.org/r/20210304095423.3825684-1-namit@vmware.com
Fixes: 09854ba94c6a ("mm: do_wp_page() simplification")
Signed-off-by: Nadav Amit <namit@vmware.com>
Suggested-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Tested-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: <stable@vger.kernel.org>	[5.9+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 mm/memory.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index 656d90a75cf8..fe6e92de9bec 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2825,6 +2825,14 @@ static vm_fault_t do_wp_page(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma =3D vmf->vma;
=20
+	/*
+	 * Userfaultfd write-protect can defer flushes. Ensure the TLB
+	 * is flushed in this case before copying.
+	 */
+	if (unlikely(userfaultfd_wp(vmf->vma) &&
+		     mm_tlb_flush_pending(vmf->vma->vm_mm)))
+		flush_tlb_page(vmf->vma, vmf->address);
+
 	vmf->page =3D vm_normal_page(vma, vmf->address, vmf->orig_pte);
 	if (!vmf->page) {
 		/*
--=20
2.31.0.291.g576ba9dcdaf-goog

