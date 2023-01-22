Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE63E676EEF
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbjAVPQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:16:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbjAVPQA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:16:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED76B22025
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:15:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A288BB80B1D
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:15:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 069ACC433EF;
        Sun, 22 Jan 2023 15:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400556;
        bh=ofh4Uir+K1O9vvUAmB+PkljF2Xcrf5crGV/g2Np60IA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZzopLbUGyCzLL2sPor2Cq7WrnKgYSBuf7l7tTaXbUSdyyjjwOs3NvAh7DVWybLeP5
         8w6BN7VR3lnaBC6NHbn6Mcmz6iAAZ0qN/xHQML2iH85qjXGbRFr17bGaPWgAq7Y4bF
         sKmsSWAj+AWhbH8DvPs8nDUMKYtkYmWyNc8hg510=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        syzbot+ede796cecd5296353515@syzkaller.appspotmail.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 020/117] nilfs2: fix general protection fault in nilfs_btree_insert()
Date:   Sun, 22 Jan 2023 16:03:30 +0100
Message-Id: <20230122150233.533722403@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit 7633355e5c7f29c049a9048e461427d1d8ed3051 upstream.

If nilfs2 reads a corrupted disk image and tries to reads a b-tree node
block by calling __nilfs_btree_get_block() against an invalid virtual
block address, it returns -ENOENT because conversion of the virtual block
address to a disk block address fails.  However, this return value is the
same as the internal code that b-tree lookup routines return to indicate
that the block being searched does not exist, so functions that operate on
that b-tree may misbehave.

When nilfs_btree_insert() receives this spurious 'not found' code from
nilfs_btree_do_lookup(), it misunderstands that the 'not found' check was
successful and continues the insert operation using incomplete lookup path
data, causing the following crash:

 general protection fault, probably for non-canonical address
 0xdffffc0000000005: 0000 [#1] PREEMPT SMP KASAN
 KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
 ...
 RIP: 0010:nilfs_btree_get_nonroot_node fs/nilfs2/btree.c:418 [inline]
 RIP: 0010:nilfs_btree_prepare_insert fs/nilfs2/btree.c:1077 [inline]
 RIP: 0010:nilfs_btree_insert+0x6d3/0x1c10 fs/nilfs2/btree.c:1238
 Code: bc 24 80 00 00 00 4c 89 f8 48 c1 e8 03 42 80 3c 28 00 74 08 4c 89
 ff e8 4b 02 92 fe 4d 8b 3f 49 83 c7 28 4c 89 f8 48 c1 e8 03 <42> 80 3c
 28 00 74 08 4c 89 ff e8 2e 02 92 fe 4d 8b 3f 49 83 c7 02
 ...
 Call Trace:
 <TASK>
  nilfs_bmap_do_insert fs/nilfs2/bmap.c:121 [inline]
  nilfs_bmap_insert+0x20d/0x360 fs/nilfs2/bmap.c:147
  nilfs_get_block+0x414/0x8d0 fs/nilfs2/inode.c:101
  __block_write_begin_int+0x54c/0x1a80 fs/buffer.c:1991
  __block_write_begin fs/buffer.c:2041 [inline]
  block_write_begin+0x93/0x1e0 fs/buffer.c:2102
  nilfs_write_begin+0x9c/0x110 fs/nilfs2/inode.c:261
  generic_perform_write+0x2e4/0x5e0 mm/filemap.c:3772
  __generic_file_write_iter+0x176/0x400 mm/filemap.c:3900
  generic_file_write_iter+0xab/0x310 mm/filemap.c:3932
  call_write_iter include/linux/fs.h:2186 [inline]
  new_sync_write fs/read_write.c:491 [inline]
  vfs_write+0x7dc/0xc50 fs/read_write.c:584
  ksys_write+0x177/0x2a0 fs/read_write.c:637
  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
  do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
  entry_SYSCALL_64_after_hwframe+0x63/0xcd
 ...
 </TASK>

This patch fixes the root cause of this problem by replacing the error
code that __nilfs_btree_get_block() returns on block address conversion
failure from -ENOENT to another internal code -EINVAL which means that the
b-tree metadata is corrupted.

By returning -EINVAL, it propagates without glitches, and for all relevant
b-tree operations, functions in the upper bmap layer output an error
message indicating corrupted b-tree metadata via
nilfs_bmap_convert_error(), and code -EIO will be eventually returned as
it should be.

Link: https://lkml.kernel.org/r/000000000000bd89e205f0e38355@google.com
Link: https://lkml.kernel.org/r/20230105055356.8811-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+ede796cecd5296353515@syzkaller.appspotmail.com
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/btree.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -480,9 +480,18 @@ static int __nilfs_btree_get_block(const
 	ret = nilfs_btnode_submit_block(btnc, ptr, 0, REQ_OP_READ, 0, &bh,
 					&submit_ptr);
 	if (ret) {
-		if (ret != -EEXIST)
-			return ret;
-		goto out_check;
+		if (likely(ret == -EEXIST))
+			goto out_check;
+		if (ret == -ENOENT) {
+			/*
+			 * Block address translation failed due to invalid
+			 * value of 'ptr'.  In this case, return internal code
+			 * -EINVAL (broken bmap) to notify bmap layer of fatal
+			 * metadata corruption.
+			 */
+			ret = -EINVAL;
+		}
+		return ret;
 	}
 
 	if (ra) {


