Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2941A3AEE6D
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbhFUQ2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:28:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:41362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231228AbhFUQZY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:25:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2209A61206;
        Mon, 21 Jun 2021 16:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292510;
        bh=vcHGOihd9yuyK7tR59yQA8NMjwNqhSk135/tw2RNdLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XHNliajakLEwANq0fKvTB2ULkQ1rr7xRDFcW3qqeRZhAt/Tutdn8bAY7Mzg/dUk4V
         SIHeOrjyAtICzYqbS4OnbqkbrMp+SR7D6K6YWcbBLneUjUKP/4LISTFhPnuzOxtsGV
         7G8/2fmgRbi6p0p5J02DWCoxgHq7Rw8T9AXy3vgc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, yangerkun <yangerkun@huawei.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Oscar Salvador <osalvador@suse.de>,
        Yu Kuai <yukuai3@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 009/146] mm/memory-failure: make sure wait for page writeback in memory_failure
Date:   Mon, 21 Jun 2021 18:13:59 +0200
Message-Id: <20210621154911.572521064@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 2d7a667f8e60..25fb82320e3d 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1445,7 +1445,12 @@ int memory_failure(unsigned long pfn, int flags)
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



