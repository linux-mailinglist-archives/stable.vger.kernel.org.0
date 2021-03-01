Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13E6F328DEF
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241370AbhCATUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:20:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:43888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241241AbhCATPW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:15:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32B1F651AF;
        Mon,  1 Mar 2021 17:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618757;
        bh=RdvySk7ALmoxG7/GzYcbVXfFdanWz8h3ZF6f4wQFiQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RK3OSQyCzL+Pcddu9vQ9w/D9XkQ8EH5ABZGuOyirbQEVZtlaiHiQ9ESEFl+8sKA8g
         EwkSvViozqhY0uZ35aR0OXPYms6/Y0ke6xqKES/LH16sNGo7OmNFla8dqc4IY+3n2p
         MEOoHAAlDDC9p0YPNnVGr/9QQUX1wWmjrP5QSShw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Yu Zhao <yuzhao@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 206/663] mm: proc: Invalidate TLB after clearing soft-dirty page state
Date:   Mon,  1 Mar 2021 17:07:34 +0100
Message-Id: <20210301161151.979499054@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

[ Upstream commit 912efa17e5121693dfbadae29768f4144a3f9e62 ]

Since commit 0758cd830494 ("asm-generic/tlb: avoid potential double
flush"), TLB invalidation is elided in tlb_finish_mmu() if no entries
were batched via the tlb_remove_*() functions. Consequently, the
page-table modifications performed by clear_refs_write() in response to
a write to /proc/<pid>/clear_refs do not perform TLB invalidation.
Although this is fine when simply aging the ptes, in the case of
clearing the "soft-dirty" state we can end up with entries where
pte_write() is false, yet a writable mapping remains in the TLB.

Fix this by avoiding the mmu_gather API altogether: managing both the
'tlb_flush_pending' flag on the 'mm_struct' and explicit TLB
invalidation for the sort-dirty path, much like mprotect() does already.

Fixes: 0758cd830494 ("asm-generic/tlb: avoid potential double flush”)
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Yu Zhao <yuzhao@google.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lkml.kernel.org/r/20210127235347.1402-2-will@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/task_mmu.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 602e3a52884d8..3cec6fbef725e 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1210,7 +1210,6 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
 	enum clear_refs_types type;
-	struct mmu_gather tlb;
 	int itype;
 	int rv;
 
@@ -1249,7 +1248,6 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 			goto out_unlock;
 		}
 
-		tlb_gather_mmu(&tlb, mm, 0, -1);
 		if (type == CLEAR_REFS_SOFT_DIRTY) {
 			for (vma = mm->mmap; vma; vma = vma->vm_next) {
 				if (!(vma->vm_flags & VM_SOFTDIRTY))
@@ -1258,15 +1256,18 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 				vma_set_page_prot(vma);
 			}
 
+			inc_tlb_flush_pending(mm);
 			mmu_notifier_range_init(&range, MMU_NOTIFY_SOFT_DIRTY,
 						0, NULL, mm, 0, -1UL);
 			mmu_notifier_invalidate_range_start(&range);
 		}
 		walk_page_range(mm, 0, mm->highest_vm_end, &clear_refs_walk_ops,
 				&cp);
-		if (type == CLEAR_REFS_SOFT_DIRTY)
+		if (type == CLEAR_REFS_SOFT_DIRTY) {
 			mmu_notifier_invalidate_range_end(&range);
-		tlb_finish_mmu(&tlb, 0, -1);
+			flush_tlb_mm(mm);
+			dec_tlb_flush_pending(mm);
+		}
 out_unlock:
 		mmap_write_unlock(mm);
 out_mm:
-- 
2.27.0



