Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9A9B3B6203
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234168AbhF1Ok5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:40:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234241AbhF1OhR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:37:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B31361CB5;
        Mon, 28 Jun 2021 14:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890649;
        bh=k1tYb5xcu1TChJp/RY88O147DyCKHGkV7SwDRskNel8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SHYZq2NEkY5b4mevKnY21Ht8V2MD61+DNIQkfLvht5/YuQi06ERtEltabKqkgmAle
         vSF+ScrUbOC09g6QNik71cGQhMbsfRDaJDHAtIVFSRcSxSf90N6aWAIwrWXMD4f268
         MFyWq52WooOKSgq7u1tJk/gv8llKojXlzlSPrwB1B7vd2QXBAha5g7pT0uqHV4DkEm
         EDUzYUuFtL2B9AJReD7qIUXkSVfuDqheC3541WkjFCDKcJXySNmouoiReSyg7H6go6
         MagwQ2Wf0GVwiSj4/rVHVr0bg67sLSGQ45Scpy6HY6LsNm9CXecVXr/G4FATgsvALH
         ahWQ+vT02WLTw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xu Yu <xuyu@linux.alibaba.com>, Hugh Dickins <hughd@google.com>,
        Gang Deng <gavin.dg@linux.alibaba.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 48/71] mm, thp: use head page in __migration_entry_wait()
Date:   Mon, 28 Jun 2021 10:29:41 -0400
Message-Id: <20210628143004.32596-49-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143004.32596-1-sashal@kernel.org>
References: <20210628143004.32596-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.129-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.129-rc1
X-KernelTest-Deadline: 2021-06-30T14:29+00:00
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
index 00bbe57c1ce2..5092ef2aa8a1 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -321,6 +321,7 @@ void __migration_entry_wait(struct mm_struct *mm, pte_t *ptep,
 		goto out;
 
 	page = migration_entry_to_page(entry);
+	page = compound_head(page);
 
 	/*
 	 * Once page cache replacement of page migration started, page_count
-- 
2.30.2

