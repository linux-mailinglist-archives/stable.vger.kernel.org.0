Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41953B5560
	for <lists+stable@lfdr.de>; Sun, 27 Jun 2021 23:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbhF0V4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Jun 2021 17:56:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231694AbhF0V4I (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Jun 2021 17:56:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC7EE61C31;
        Sun, 27 Jun 2021 21:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624830824;
        bh=ddzBxKyn3ApxNWXUgWnYZY/YprQ0awaP/rf4bYYjHZw=;
        h=Date:From:To:Subject:From;
        b=FW16AFDVlpP8/Qr3xVql+rc3pNx6uCt9H5O235WEYoozE/DaqT7tur/q+WrOwjS/7
         snq6qYD9gyH+E8rDqX7QoYzxIgfZX7TVOzrhnzjY4nu2lJp7JJp2MGf6Pk/lXSWN5C
         7wKUE17y4KQwFMsOfZXg+YISwil6p8b4D0FnrmPk=
Date:   Sun, 27 Jun 2021 14:53:43 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, rcampbell@nvidia.com, shy828301@gmail.com,
        stable@vger.kernel.org, wangyugui@e16-tech.com, will@kernel.org,
        willy@infradead.org, ziy@nvidia.com
Subject:  [merged]
 mm-page_vma_mapped_walk-get-vma_address_end-earlier.patch removed from -mm
 tree
Message-ID: <20210627215343.zDyZxVN7o%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: page_vma_mapped_walk(): get vma_address_end() earlier
has been removed from the -mm tree.  Its filename was
     mm-page_vma_mapped_walk-get-vma_address_end-earlier.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: page_vma_mapped_walk(): get vma_address_end() earlier

page_vma_mapped_walk() cleanup: get THP's vma_address_end() at the start,
rather than later at next_pte.  It's a little unnecessary overhead on the
first call, but makes for a simpler loop in the following commit.

Link: https://lkml.kernel.org/r/4542b34d-862f-7cb4-bb22-e0df6ce830a2@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Wang Yugui <wangyugui@e16-tech.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_vma_mapped.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/mm/page_vma_mapped.c~mm-page_vma_mapped_walk-get-vma_address_end-earlier
+++ a/mm/page_vma_mapped.c
@@ -171,6 +171,15 @@ bool page_vma_mapped_walk(struct page_vm
 		return true;
 	}
 
+	/*
+	 * Seek to next pte only makes sense for THP.
+	 * But more important than that optimization, is to filter out
+	 * any PageKsm page: whose page->index misleads vma_address()
+	 * and vma_address_end() to disaster.
+	 */
+	end = PageTransCompound(page) ?
+		vma_address_end(page, pvmw->vma) :
+		pvmw->address + PAGE_SIZE;
 	if (pvmw->pte)
 		goto next_pte;
 restart:
@@ -238,10 +247,6 @@ this_pte:
 		if (check_pte(pvmw))
 			return true;
 next_pte:
-		/* Seek to next pte only makes sense for THP */
-		if (!PageTransHuge(page))
-			return not_found(pvmw);
-		end = vma_address_end(page, pvmw->vma);
 		do {
 			pvmw->address += PAGE_SIZE;
 			if (pvmw->address >= end)
_

Patches currently in -mm which might be from hughd@google.com are

mm-thp-remap_page-is-only-needed-on-anonymous-thp.patch
mm-hwpoison_user_mappings-try_to_unmap-with-ttu_sync.patch

