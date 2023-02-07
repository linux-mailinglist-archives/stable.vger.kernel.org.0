Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04D2168D8FF
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbjBGNPH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:15:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232361AbjBGNOn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:14:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3CB63A5A2
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:14:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8320361383
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:14:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91075C433EF;
        Tue,  7 Feb 2023 13:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775661;
        bh=hJOQz22fDLLfmXmfB0riMRdiLiRwk5a8SsvE6ejWhSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lPY/xU4BM7A5dIN//iwm55gO6//V+8sD01c7zxHYT3okGXxrhnNs5KtMp8sanN5VR
         2oySBEza1aRkwW36sMVJazH/CJ8oUfKQJn9i5aD2wOcsILK6UzTxvrBxGpdAX0l1gS
         T03GDasbX9p3r15TxhiwqHcpeIsjO6itKsXy7LyY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+f8f3dfa4abc489e768a1@syzkaller.appspotmail.com,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.15 116/120] f2fs: fix to do sanity check on i_extra_isize in is_alive()
Date:   Tue,  7 Feb 2023 13:58:07 +0100
Message-Id: <20230207125623.717170674@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <chao@kernel.org>

commit d3b7b4afd6b2c344eabf9cc26b8bfa903c164c7c upstream.

syzbot found a f2fs bug:

BUG: KASAN: slab-out-of-bounds in data_blkaddr fs/f2fs/f2fs.h:2891 [inline]
BUG: KASAN: slab-out-of-bounds in is_alive fs/f2fs/gc.c:1117 [inline]
BUG: KASAN: slab-out-of-bounds in gc_data_segment fs/f2fs/gc.c:1520 [inline]
BUG: KASAN: slab-out-of-bounds in do_garbage_collect+0x386a/0x3df0 fs/f2fs/gc.c:1734
Read of size 4 at addr ffff888076557568 by task kworker/u4:3/52

CPU: 1 PID: 52 Comm: kworker/u4:3 Not tainted 6.1.0-rc4-syzkaller-00362-gfef7fd48922d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: writeback wb_workfn (flush-7:0)
Call Trace:
<TASK>
__dump_stack lib/dump_stack.c:88 [inline]
dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
print_address_description mm/kasan/report.c:284 [inline]
print_report+0x15e/0x45d mm/kasan/report.c:395
kasan_report+0xbb/0x1f0 mm/kasan/report.c:495
data_blkaddr fs/f2fs/f2fs.h:2891 [inline]
is_alive fs/f2fs/gc.c:1117 [inline]
gc_data_segment fs/f2fs/gc.c:1520 [inline]
do_garbage_collect+0x386a/0x3df0 fs/f2fs/gc.c:1734
f2fs_gc+0x88c/0x20a0 fs/f2fs/gc.c:1831
f2fs_balance_fs+0x544/0x6b0 fs/f2fs/segment.c:410
f2fs_write_inode+0x57e/0xe20 fs/f2fs/inode.c:753
write_inode fs/fs-writeback.c:1440 [inline]
__writeback_single_inode+0xcfc/0x1440 fs/fs-writeback.c:1652
writeback_sb_inodes+0x54d/0xf90 fs/fs-writeback.c:1870
wb_writeback+0x2c5/0xd70 fs/fs-writeback.c:2044
wb_do_writeback fs/fs-writeback.c:2187 [inline]
wb_workfn+0x2dc/0x12f0 fs/fs-writeback.c:2227
process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
worker_thread+0x665/0x1080 kernel/workqueue.c:2436
kthread+0x2e4/0x3a0 kernel/kthread.c:376
ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306

The root cause is that we forgot to do sanity check on .i_extra_isize
in below path, result in accessing invalid address later, fix it.
- gc_data_segment
 - is_alive
  - data_blkaddr
   - offset_in_addr

Reported-by: syzbot+f8f3dfa4abc489e768a1@syzkaller.appspotmail.com
Link: https://lore.kernel.org/linux-f2fs-devel/0000000000003cb3c405ed5c17f9@google.com/T/#u
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/gc.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1002,7 +1002,7 @@ static bool is_alive(struct f2fs_sb_info
 {
 	struct page *node_page;
 	nid_t nid;
-	unsigned int ofs_in_node, max_addrs;
+	unsigned int ofs_in_node, max_addrs, base;
 	block_t source_blkaddr;
 
 	nid = le32_to_cpu(sum->nid);
@@ -1028,11 +1028,17 @@ static bool is_alive(struct f2fs_sb_info
 		return false;
 	}
 
-	max_addrs = IS_INODE(node_page) ? DEF_ADDRS_PER_INODE :
-						DEF_ADDRS_PER_BLOCK;
-	if (ofs_in_node >= max_addrs) {
-		f2fs_err(sbi, "Inconsistent ofs_in_node:%u in summary, ino:%u, nid:%u, max:%u",
-			ofs_in_node, dni->ino, dni->nid, max_addrs);
+	if (IS_INODE(node_page)) {
+		base = offset_in_addr(F2FS_INODE(node_page));
+		max_addrs = DEF_ADDRS_PER_INODE;
+	} else {
+		base = 0;
+		max_addrs = DEF_ADDRS_PER_BLOCK;
+	}
+
+	if (base + ofs_in_node >= max_addrs) {
+		f2fs_err(sbi, "Inconsistent blkaddr offset: base:%u, ofs_in_node:%u, max:%u, ino:%u, nid:%u",
+			base, ofs_in_node, max_addrs, dni->ino, dni->nid);
 		f2fs_put_page(node_page, 1);
 		return false;
 	}


