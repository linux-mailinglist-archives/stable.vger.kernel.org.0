Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A33A26B4903
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232988AbjCJPIo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:08:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233923AbjCJPIO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:08:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63AF311F619
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:00:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CC5D61AC7
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:00:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 217D0C433A0;
        Fri, 10 Mar 2023 15:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460449;
        bh=6JY7nC9havmw34Q/i5vEwNC6TiD475MMcz0qJV0pXMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FpcIBxouWRW0ucvHih2YNH2zyRyN7/5cfwMiI0AFvcyRN5reAI3bdlcrtpBcWYEMu
         ACNsm/5dYUHTp6mFPFhExxacJAIFySRNEyMYCoMsnoMYpnmeANu9V+ex/wVNC6S3DV
         5O109IUZTT0nFvroCrFGZUvBiN//ef6FicjOh2iM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+5b04b49a7ec7226c7426@syzkaller.appspotmail.com,
        Liu Shixin <liushixin2@huawei.com>,
        "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 338/529] hfs: fix missing hfs_bnode_get() in __hfs_bnode_create
Date:   Fri, 10 Mar 2023 14:38:01 +0100
Message-Id: <20230310133820.670562371@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Shixin <liushixin2@huawei.com>

commit a9dc087fd3c484fd1ed18c5efb290efaaf44ce03 upstream.

Syzbot found a kernel BUG in hfs_bnode_put():

 kernel BUG at fs/hfs/bnode.c:466!
 invalid opcode: 0000 [#1] PREEMPT SMP KASAN
 CPU: 0 PID: 3634 Comm: kworker/u4:5 Not tainted 6.1.0-rc7-syzkaller-00190-g97ee9d1c1696 #0
 Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
 Workqueue: writeback wb_workfn (flush-7:0)
 RIP: 0010:hfs_bnode_put+0x46f/0x480 fs/hfs/bnode.c:466
 Code: 8a 80 ff e9 73 fe ff ff 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c a0 fe ff ff 48 89 df e8 db 8a 80 ff e9 93 fe ff ff e8 a1 68 2c ff <0f> 0b e8 9a 68 2c ff 0f 0b 0f 1f 84 00 00 00 00 00 55 41 57 41 56
 RSP: 0018:ffffc90003b4f258 EFLAGS: 00010293
 RAX: ffffffff825e318f RBX: 0000000000000000 RCX: ffff8880739dd7c0
 RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
 RBP: ffffc90003b4f430 R08: ffffffff825e2d9b R09: ffffed10045157d1
 R10: ffffed10045157d1 R11: 1ffff110045157d0 R12: ffff8880228abe80
 R13: ffff88807016c000 R14: dffffc0000000000 R15: ffff8880228abe00
 FS:  0000000000000000(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007fa6ebe88718 CR3: 000000001e93d000 CR4: 00000000003506f0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  <TASK>
  hfs_write_inode+0x1bc/0xb40
  write_inode fs/fs-writeback.c:1440 [inline]
  __writeback_single_inode+0x4d6/0x670 fs/fs-writeback.c:1652
  writeback_sb_inodes+0xb3b/0x18f0 fs/fs-writeback.c:1878
  __writeback_inodes_wb+0x125/0x420 fs/fs-writeback.c:1949
  wb_writeback+0x440/0x7b0 fs/fs-writeback.c:2054
  wb_check_start_all fs/fs-writeback.c:2176 [inline]
  wb_do_writeback fs/fs-writeback.c:2202 [inline]
  wb_workfn+0x827/0xef0 fs/fs-writeback.c:2235
  process_one_work+0x877/0xdb0 kernel/workqueue.c:2289
  worker_thread+0xb14/0x1330 kernel/workqueue.c:2436
  kthread+0x266/0x300 kernel/kthread.c:376
  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
  </TASK>

The BUG_ON() is triggered at here:

/* Dispose of resources used by a node */
void hfs_bnode_put(struct hfs_bnode *node)
{
	if (node) {
 		<skipped>
 		BUG_ON(!atomic_read(&node->refcnt)); <- we have issue here!!!!
 		<skipped>
 	}
}

By tracing the refcnt, I found the node is created by hfs_bmap_alloc()
with refcnt 1.  Then the node is used by hfs_btree_write().  There is a
missing of hfs_bnode_get() after find the node.  The issue happened in
following path:

<alloc>
 hfs_bmap_alloc
   hfs_bnode_find
     __hfs_bnode_create   <- allocate a new node with refcnt 1.
   hfs_bnode_put          <- decrease the refcnt

<write>
 hfs_btree_write
   hfs_bnode_find
     __hfs_bnode_create
       hfs_bnode_findhash <- find the node without refcnt increased.
   hfs_bnode_put	  <- trigger the BUG_ON() since refcnt is 0.

Link: https://lkml.kernel.org/r/20221212021627.3766829-1-liushixin2@huawei.com
Reported-by: syzbot+5b04b49a7ec7226c7426@syzkaller.appspotmail.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Cc: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/hfs/bnode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/hfs/bnode.c
+++ b/fs/hfs/bnode.c
@@ -281,6 +281,7 @@ static struct hfs_bnode *__hfs_bnode_cre
 		tree->node_hash[hash] = node;
 		tree->node_hash_cnt++;
 	} else {
+		hfs_bnode_get(node2);
 		spin_unlock(&tree->hash_lock);
 		kfree(node);
 		wait_event(node2->lock_wq, !test_bit(HFS_BNODE_NEW, &node2->flags));


