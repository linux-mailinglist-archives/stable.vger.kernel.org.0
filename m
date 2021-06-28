Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE01B3B6246
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234983AbhF1Onm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:43:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:51480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234371AbhF1Olk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:41:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7A2D61CCB;
        Mon, 28 Jun 2021 14:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890810;
        bh=/hMOqfr6QmAnCwcftbwlqwZsdAX+X+QlggWlqc7i1Vc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ob0OuSqu8uq29uNuZtmb38qfXarhaYQ2hNonw06MiRF6l5mLCL7bb7tEoEaFdi7H8
         T+RO25Nrfs2Vm0lWvSVfq1704jeC+v6fVwrXZJAlURV7DrbaPt8/DKAivVBnY0FLDv
         TzAw/tNLVj/lel1vcUzt+jWMohI45W331nxezGggHZTvnr2BXxLlLXk+qNADoTRARH
         s+BOnHo3tGj18l/3jD2ti2g+ucEDiE3w17RPDD0uKSrGN1hWIp/81FK4+v0mD6P16l
         cH8JHwr63A3qtObVzKsv5V36Qk34Z2gjL9JvkDu9zcseyx+1XdnDJBCrcX3+etJdAI
         kQ39rxb0n4AOA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     yangerkun <yangerkun@huawei.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
        Oscar Salvador <osalvador@suse.de>,
        Yu Kuai <yukuai3@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 025/109] mm/memory-failure: make sure wait for page writeback in memory_failure
Date:   Mon, 28 Jun 2021 10:31:41 -0400
Message-Id: <20210628143305.32978-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yangerkun <yangerkun@huawei.com>

[ Upstream commit e8675d291ac007e1c636870db880f837a9ea112a ]

Our syzkaller trigger the "BUG_ON(!list_empty(&inode->i_wb_list))" in
clear_inode:

  kernel BUG at fs/inode.c:519!
  Internal error: Oops - BUG: 0 [#1] SMP
  Modules linked in:
  Process syz-executor.0 (pid: 249, stack limit = 0x00000000a12409d7)
  CPU: 1 PID: 249 Comm: syz-executor.0 Not tainted 4.19.95
  Hardware name: linux,dummy-virt (DT)
  pstate: 80000005 (Nzcv daif -PAN -UAO)
  pc : clear_inode+0x280/0x2a8
  lr : clear_inode+0x280/0x2a8
  Call trace:
    clear_inode+0x280/0x2a8
    ext4_clear_inode+0x38/0xe8
    ext4_free_inode+0x130/0xc68
    ext4_evict_inode+0xb20/0xcb8
    evict+0x1a8/0x3c0
    iput+0x344/0x460
    do_unlinkat+0x260/0x410
    __arm64_sys_unlinkat+0x6c/0xc0
    el0_svc_common+0xdc/0x3b0
    el0_svc_handler+0xf8/0x160
    el0_svc+0x10/0x218
  Kernel panic - not syncing: Fatal exception

A crash dump of this problem show that someone called __munlock_pagevec
to clear page LRU without lock_page: do_mmap -> mmap_region -> do_munmap
-> munlock_vma_pages_range -> __munlock_pagevec.

As a result memory_failure will call identify_page_state without
wait_on_page_writeback.  And after truncate_error_page clear the mapping
of this page.  end_page_writeback won't call sb_clear_inode_writeback to
clear inode->i_wb_list.  That will trigger BUG_ON in clear_inode!

Fix it by checking PageWriteback too to help determine should we skip
wait_on_page_writeback.

Link: https://lkml.kernel.org/r/20210604084705.3729204-1-yangerkun@huawei.com
Fixes: 0bc1f8b0682c ("hwpoison: fix the handling path of the victimized page frame that belong to non-LRU")
Signed-off-by: yangerkun <yangerkun@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory-failure.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 034607a68ccb..3da3c63dccd1 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1387,7 +1387,12 @@ int memory_failure(unsigned long pfn, int flags)
 		return 0;
 	}
 
-	if (!PageTransTail(p) && !PageLRU(p))
+	/*
+	 * __munlock_pagevec may clear a writeback page's LRU flag without
+	 * page_lock. We need wait writeback completion for this page or it
+	 * may trigger vfs BUG while evict inode.
+	 */
+	if (!PageTransTail(p) && !PageLRU(p) && !PageWriteback(p))
 		goto identify_page_state;
 
 	/*
-- 
2.30.2

