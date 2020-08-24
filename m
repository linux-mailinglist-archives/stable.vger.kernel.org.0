Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81EDF24F81A
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728725AbgHXJ0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:26:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:59926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730132AbgHXIxB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:53:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17A7B2072D;
        Mon, 24 Aug 2020 08:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598259180;
        bh=qVU8jQNWyLlXjnrNh2gzlHqO6Dq7uBhUCkw5dhQOHOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FfEmtYUTxaOLFbvF8srDq8B/fbQuggL22l1qeYQVZLTgkQu0bVeIeJsioUDThRzoy
         qKo2JPOgqLzP+CJ9pRrG1TQplgBf4qnRVqrimH74UiebnPSUx2HARvyq5NHV5TIjWA
         Sgx8n6B3Qfwv3QaEPiA+X9/x/7QGykP7tWy8+lUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Song Liu <songliubraving@fb.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 03/50] khugepaged: khugepaged_test_exit() check mmget_still_valid()
Date:   Mon, 24 Aug 2020 10:31:04 +0200
Message-Id: <20200824082352.040818505@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082351.823243923@linuxfoundation.org>
References: <20200824082351.823243923@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

[ Upstream commit bbe98f9cadff58cdd6a4acaeba0efa8565dabe65 ]

Move collapse_huge_page()'s mmget_still_valid() check into
khugepaged_test_exit() itself.  collapse_huge_page() is used for anon THP
only, and earned its mmget_still_valid() check because it inserts a huge
pmd entry in place of the page table's pmd entry; whereas
collapse_file()'s retract_page_tables() or collapse_pte_mapped_thp()
merely clears the page table's pmd entry.  But core dumping without mmap
lock must have been as open to mistaking a racily cleared pmd entry for a
page table at physical page 0, as exit_mmap() was.  And we certainly have
no interest in mapping as a THP once dumping core.

Fixes: 59ea6d06cfa9 ("coredump: fix race condition between collapse_huge_page() and core dumping")
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kernel.org>	[4.8+]
Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2008021217020.27773@eggly.anvils
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/khugepaged.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 04b4c38d0c184..a1b7475c05d04 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -394,7 +394,7 @@ static void insert_to_mm_slots_hash(struct mm_struct *mm,
 
 static inline int khugepaged_test_exit(struct mm_struct *mm)
 {
-	return atomic_read(&mm->mm_users) == 0;
+	return atomic_read(&mm->mm_users) == 0 || !mmget_still_valid(mm);
 }
 
 int __khugepaged_enter(struct mm_struct *mm)
@@ -1006,9 +1006,6 @@ static void collapse_huge_page(struct mm_struct *mm,
 	 * handled by the anon_vma lock + PG_lock.
 	 */
 	down_write(&mm->mmap_sem);
-	result = SCAN_ANY_PROCESS;
-	if (!mmget_still_valid(mm))
-		goto out;
 	result = hugepage_vma_revalidate(mm, address, &vma);
 	if (result)
 		goto out;
-- 
2.25.1



