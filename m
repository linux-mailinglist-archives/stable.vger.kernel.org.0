Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E682C3B612D
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234403AbhF1OdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:33:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:36914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233693AbhF1Oat (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:30:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4647961CB7;
        Mon, 28 Jun 2021 14:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890433;
        bh=xTB3YB9ZX3NmGs64ppPafeBJ+1rD9FrGam3WAqOW1fc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H8Gjyzm0/8duvQ42RNWcP+Epd0ioG4xqfbSdB8UzxsbP5BNRP5qnJaAX+PDevgJjz
         6KaqzNlgX47JC5utK5/o+it90WilR/LpaCMxr+Gy0U6Iudvkgglt/LIpCwEMeyu2cv
         QuCyidFInyISGOzwTBEJFu5B0SRxzo/R+pfazV+E4nb6ne+5jXKprzqBWSw/ghbNpp
         F8FM11S201dEB+Spvkmw2FqudnMirv6wc0XoKcfZn0p/ikk5RWz7uub2Mn0Re+HRwF
         SYKmS4HGyzf9Mgo2Dj8vhE3dpI8/QFNuoSjaMj5Ao7OZSgZk7jsIi4oyVAWrTrHWRj
         1O2j96muccyng==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xu Yu <xuyu@linux.alibaba.com>, Hugh Dickins <hughd@google.com>,
        Gang Deng <gavin.dg@linux.alibaba.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.10 074/101] mm, thp: use head page in __migration_entry_wait()
Date:   Mon, 28 Jun 2021 10:25:40 -0400
Message-Id: <20210628142607.32218-75-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xu Yu <xuyu@linux.alibaba.com>

commit ffc90cbb2970ab88b66ea51dd580469eede57b67 upstream.

We notice that hung task happens in a corner but practical scenario when
CONFIG_PREEMPT_NONE is enabled, as follows.

Process 0                       Process 1                     Process 2..Inf
split_huge_page_to_list
    unmap_page
        split_huge_pmd_address
                                __migration_entry_wait(head)
                                                              __migration_entry_wait(tail)
    remap_page (roll back)
        remove_migration_ptes
            rmap_walk_anon
                cond_resched

Where __migration_entry_wait(tail) is occurred in kernel space, e.g.,
copy_to_user in fstat, which will immediately fault again without
rescheduling, and thus occupy the cpu fully.

When there are too many processes performing __migration_entry_wait on
tail page, remap_page will never be done after cond_resched.

This makes __migration_entry_wait operate on the compound head page,
thus waits for remap_page to complete, whether the THP is split
successfully or roll back.

Note that put_and_wait_on_page_locked helps to drop the page reference
acquired with get_page_unless_zero, as soon as the page is on the wait
queue, before actually waiting.  So splitting the THP is only prevented
for a brief interval.

Link: https://lkml.kernel.org/r/b9836c1dd522e903891760af9f0c86a2cce987eb.1623144009.git.xuyu@linux.alibaba.com
Fixes: ba98828088ad ("thp: add option to setup migration entries during PMD split")
Suggested-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Gang Deng <gavin.dg@linux.alibaba.com>
Signed-off-by: Xu Yu <xuyu@linux.alibaba.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/migrate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/migrate.c b/mm/migrate.c
index 7982256a5125..278e6f3fa62c 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -326,6 +326,7 @@ void __migration_entry_wait(struct mm_struct *mm, pte_t *ptep,
 		goto out;
 
 	page = migration_entry_to_page(entry);
+	page = compound_head(page);
 
 	/*
 	 * Once page cache replacement of page migration started, page_count
-- 
2.30.2

