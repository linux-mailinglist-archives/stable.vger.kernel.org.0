Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 900882F9F4F
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 13:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391032AbhARMRb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 07:17:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:39146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390880AbhARLqP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:46:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53432222BB;
        Mon, 18 Jan 2021 11:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970342;
        bh=SzQGuHebs9xocX/e/O6/CMMo8MrCd8y4OTB0WjxdZzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bPBR5gv9Zf224eTVkL68EDrYw9pCkzXQsouThFY+WQqA0EtrLfb48aH6q8EBtiY9c
         7aC5NR2gXRp8WB6dSi0+Wh/VdMC55zFnjInMpcphuRtxunvW4gLTVCDOANuB8gBjB7
         Y3NYnx9Pon+Wo3SrO6VYYEZT4fSrmboOXyHsQfWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/152] mm: fix clear_refs_write locking
Date:   Mon, 18 Jan 2021 12:34:44 +0100
Message-Id: <20210118113357.954800440@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 29a951dfb3c3263c3a0f3bd9f7f2c2cfde4baedb ]

Turning page table entries read-only requires the mmap_sem held for
writing.

So stop doing the odd games with turning things from read locks to write
locks and back.  Just get the write lock.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/task_mmu.c | 32 +++++++++-----------------------
 1 file changed, 9 insertions(+), 23 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index ee5a235b30562..ab7d700b2caa4 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1215,41 +1215,26 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 			.type = type,
 		};
 
+		if (mmap_write_lock_killable(mm)) {
+			count = -EINTR;
+			goto out_mm;
+		}
 		if (type == CLEAR_REFS_MM_HIWATER_RSS) {
-			if (mmap_write_lock_killable(mm)) {
-				count = -EINTR;
-				goto out_mm;
-			}
-
 			/*
 			 * Writing 5 to /proc/pid/clear_refs resets the peak
 			 * resident set size to this mm's current rss value.
 			 */
 			reset_mm_hiwater_rss(mm);
-			mmap_write_unlock(mm);
-			goto out_mm;
+			goto out_unlock;
 		}
 
-		if (mmap_read_lock_killable(mm)) {
-			count = -EINTR;
-			goto out_mm;
-		}
 		tlb_gather_mmu(&tlb, mm, 0, -1);
 		if (type == CLEAR_REFS_SOFT_DIRTY) {
 			for (vma = mm->mmap; vma; vma = vma->vm_next) {
 				if (!(vma->vm_flags & VM_SOFTDIRTY))
 					continue;
-				mmap_read_unlock(mm);
-				if (mmap_write_lock_killable(mm)) {
-					count = -EINTR;
-					goto out_mm;
-				}
-				for (vma = mm->mmap; vma; vma = vma->vm_next) {
-					vma->vm_flags &= ~VM_SOFTDIRTY;
-					vma_set_page_prot(vma);
-				}
-				mmap_write_downgrade(mm);
-				break;
+				vma->vm_flags &= ~VM_SOFTDIRTY;
+				vma_set_page_prot(vma);
 			}
 
 			mmu_notifier_range_init(&range, MMU_NOTIFY_SOFT_DIRTY,
@@ -1261,7 +1246,8 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 		if (type == CLEAR_REFS_SOFT_DIRTY)
 			mmu_notifier_invalidate_range_end(&range);
 		tlb_finish_mmu(&tlb, 0, -1);
-		mmap_read_unlock(mm);
+out_unlock:
+		mmap_write_unlock(mm);
 out_mm:
 		mmput(mm);
 	}
-- 
2.27.0



