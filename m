Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 121F523F316
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 21:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgHGTcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 15:32:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:33282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbgHGTcp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Aug 2020 15:32:45 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 550B9204EC;
        Fri,  7 Aug 2020 19:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596828763;
        bh=hGcru2JSer3MpZfoxGSOpqOSU2mQifE57/0Zud94SVI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZT6gdCVBZEkXFJJPPWErK0oBetvQDeO90fj+tixuebpw9qUVfxmCHr8PuPHjq9Bk6
         44G9/mPHiE49DIdDGV3hvOTP2y0JCaSHljs4CuC4XASKx8EloIdgSgocqFjFP+Klua
         BfPWMc9LYH+qa7YOcLbMIGpsSmnEUaJB6DUZlF8k=
Date:   Fri, 07 Aug 2020 12:32:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     catalin.marinas@arm.com, hannes@cmpxchg.org, hdanton@sina.com,
        hughd@google.com, josef@toxicpanda.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, will.deacon@arm.com, willy@infradead.org,
        xuyu@linux.alibaba.com, yang.shi@linux.alibaba.com
Subject:  [nacked]
 mm-avoid-access-flag-update-tlb-flush-for-retried-page-fault.patch removed
 from -mm tree
Message-ID: <20200807193242.CtxqvgfOg%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/memory.c: avoid access flag update TLB flush for retried page fault
has been removed from the -mm tree.  Its filename was
     mm-avoid-access-flag-update-tlb-flush-for-retried-page-fault.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm/memory.c: avoid access flag update TLB flush for retried page fault

Recently we found regression when running will_it_scale/page_fault3 test
on ARM64.  Over 70% down for the multi processes cases and over 20% down
for the multi threads cases.  It turns out the regression is caused by
commit 89b15332af7c0312a41e50846819ca6613b58b4c ("mm: drop mmap_sem before
calling balance_dirty_pages() in write fault").

The test mmaps a memory size file then write to the mapping, this would
make all memory dirty and trigger dirty pages throttle, that upstream
commit would release mmap_sem then retry the page fault.  The retried page
fault would see correct PTEs installed by the first try then update dirty
bit and clear read-only bit and flush TLBs for ARM.  The regression is
caused by the excessive TLB flush.  It is fine on x86 since x86 doesn't
clear read-only bit so there is no need to flush TLB for this case.

The page fault would be retried due to:
1. Waiting for page readahead
2. Waiting for page swapped in
3. Waiting for dirty pages throttling

The first two cases don't have PTEs set up at all, so the retried page
fault would install the PTEs, so they don't reach there.  But the #3 case
usually has PTEs installed, the retried page fault would reach the dirty
bit and read-only bit update.  But it seems not necessary to modify those
bits again for #3 since they should be already set by the first page fault
try.

Of course the parallel page fault may set up PTEs, but we just need care
about write fault.  If the parallel page fault setup a writable and dirty
PTE then the retried fault doesn't need do anything extra.  If the
parallel page fault setup a clean read-only PTE, the retried fault should
just call do_wp_page() then return as the below code snippet shows:

if (vmf->flags & FAULT_FLAG_WRITE) {
        if (!pte_write(entry))
            return do_wp_page(vmf);
}

With this fix the test result get back to normal.

[yang.shi@linux.alibaba.com: incorporate comment from Will Deacon, update commit log per discussion]
  Link: http://lkml.kernel.org/r/1594848990-55657-1-git-send-email-yang.shi@linux.alibaba.com
Link: http://lkml.kernel.org/r/1594148072-91273-1-git-send-email-yang.shi@linux.alibaba.com
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Reported-by: Xu Yu <xuyu@linux.alibaba.com>
Debugged-by: Xu Yu <xuyu@linux.alibaba.com>
Tested-by: Xu Yu <xuyu@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/memory.c~mm-avoid-access-flag-update-tlb-flush-for-retried-page-fault
+++ a/mm/memory.c
@@ -4241,8 +4241,14 @@ static vm_fault_t handle_pte_fault(struc
 	if (vmf->flags & FAULT_FLAG_WRITE) {
 		if (!pte_write(entry))
 			return do_wp_page(vmf);
-		entry = pte_mkdirty(entry);
 	}
+
+	if (vmf->flags & FAULT_FLAG_TRIED)
+		goto unlock;
+
+	if (vmf->flags & FAULT_FLAG_WRITE)
+		entry = pte_mkdirty(entry);
+
 	entry = pte_mkyoung(entry);
 	if (ptep_set_access_flags(vmf->vma, vmf->address, vmf->pte, entry,
 				vmf->flags & FAULT_FLAG_WRITE)) {
_

Patches currently in -mm which might be from yang.shi@linux.alibaba.com are

mm-filemap-clear-idle-flag-for-writes.patch
mm-filemap-add-missing-fgp_-flags-in-kerneldoc-comment-for-pagecache_get_page.patch
mm-thp-remove-debug_cow-switch.patch

