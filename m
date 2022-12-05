Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0012F6434AB
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235102AbiLETsf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:48:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235098AbiLETr5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:47:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 821172612C
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:44:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 204C861314
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32485C433C1;
        Mon,  5 Dec 2022 19:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269491;
        bh=jes/b9baVpTtzoU4BvzHzrA7wgmkJdGgbrzBpkt2NAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0uaqmseTLY2vcYFNmWkv5Gn+7+kjP++PzherHHtlnZJ9jol/5AZ19Okcc/iZbphyy
         7iXhVfcFykpZipDVfBdksONW+5GZ1VQBZ2nhReO7DzXL7xDW3kSsby3hMOfNx+lfxh
         r2vY/AB4YtNijupwiY6p+ZIuJ0BWGC8rPrsJrIwU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, ZhangPeng <zhangpeng362@huawei.com>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        syzbot+ebe05ee8e98f755f61d0@syzkaller.appspotmail.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.4 119/153] nilfs2: fix NULL pointer dereference in nilfs_palloc_commit_free_entry()
Date:   Mon,  5 Dec 2022 20:10:43 +0100
Message-Id: <20221205190812.123231883@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
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

From: ZhangPeng <zhangpeng362@huawei.com>

commit f0a0ccda18d6fd826d7c7e7ad48a6ed61c20f8b4 upstream.

Syzbot reported a null-ptr-deref bug:

 NILFS (loop0): segctord starting. Construction interval = 5 seconds, CP
 frequency < 30 seconds
 general protection fault, probably for non-canonical address
 0xdffffc0000000002: 0000 [#1] PREEMPT SMP KASAN
 KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
 CPU: 1 PID: 3603 Comm: segctord Not tainted
 6.1.0-rc2-syzkaller-00105-gb229b6ca5abb #0
 Hardware name: Google Compute Engine/Google Compute Engine, BIOS Google
 10/11/2022
 RIP: 0010:nilfs_palloc_commit_free_entry+0xe5/0x6b0
 fs/nilfs2/alloc.c:608
 Code: 00 00 00 00 fc ff df 80 3c 02 00 0f 85 cd 05 00 00 48 b8 00 00 00
 00 00 fc ff df 4c 8b 73 08 49 8d 7e 10 48 89 fa 48 c1 ea 03 <80> 3c 02
 00 0f 85 26 05 00 00 49 8b 46 10 be a6 00 00 00 48 c7 c7
 RSP: 0018:ffffc90003dff830 EFLAGS: 00010212
 RAX: dffffc0000000000 RBX: ffff88802594e218 RCX: 000000000000000d
 RDX: 0000000000000002 RSI: 0000000000002000 RDI: 0000000000000010
 RBP: ffff888071880222 R08: 0000000000000005 R09: 000000000000003f
 R10: 000000000000000d R11: 0000000000000000 R12: ffff888071880158
 R13: ffff88802594e220 R14: 0000000000000000 R15: 0000000000000004
 FS:  0000000000000000(0000) GS:ffff8880b9b00000(0000)
 knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007fb1c08316a8 CR3: 0000000018560000 CR4: 0000000000350ee0
 Call Trace:
  <TASK>
  nilfs_dat_commit_free fs/nilfs2/dat.c:114 [inline]
  nilfs_dat_commit_end+0x464/0x5f0 fs/nilfs2/dat.c:193
  nilfs_dat_commit_update+0x26/0x40 fs/nilfs2/dat.c:236
  nilfs_btree_commit_update_v+0x87/0x4a0 fs/nilfs2/btree.c:1940
  nilfs_btree_commit_propagate_v fs/nilfs2/btree.c:2016 [inline]
  nilfs_btree_propagate_v fs/nilfs2/btree.c:2046 [inline]
  nilfs_btree_propagate+0xa00/0xd60 fs/nilfs2/btree.c:2088
  nilfs_bmap_propagate+0x73/0x170 fs/nilfs2/bmap.c:337
  nilfs_collect_file_data+0x45/0xd0 fs/nilfs2/segment.c:568
  nilfs_segctor_apply_buffers+0x14a/0x470 fs/nilfs2/segment.c:1018
  nilfs_segctor_scan_file+0x3f4/0x6f0 fs/nilfs2/segment.c:1067
  nilfs_segctor_collect_blocks fs/nilfs2/segment.c:1197 [inline]
  nilfs_segctor_collect fs/nilfs2/segment.c:1503 [inline]
  nilfs_segctor_do_construct+0x12fc/0x6af0 fs/nilfs2/segment.c:2045
  nilfs_segctor_construct+0x8e3/0xb30 fs/nilfs2/segment.c:2379
  nilfs_segctor_thread_construct fs/nilfs2/segment.c:2487 [inline]
  nilfs_segctor_thread+0x3c3/0xf30 fs/nilfs2/segment.c:2570
  kthread+0x2e4/0x3a0 kernel/kthread.c:376
  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
  </TASK>
 ...

If DAT metadata file is corrupted on disk, there is a case where
req->pr_desc_bh is NULL and blocknr is 0 at nilfs_dat_commit_end() during
a b-tree operation that cascadingly updates ancestor nodes of the b-tree,
because nilfs_dat_commit_alloc() for a lower level block can initialize
the blocknr on the same DAT entry between nilfs_dat_prepare_end() and
nilfs_dat_commit_end().

If this happens, nilfs_dat_commit_end() calls nilfs_dat_commit_free()
without valid buffer heads in req->pr_desc_bh and req->pr_bitmap_bh, and
causes the NULL pointer dereference above in
nilfs_palloc_commit_free_entry() function, which leads to a crash.

Fix this by adding a NULL check on req->pr_desc_bh and req->pr_bitmap_bh
before nilfs_palloc_commit_free_entry() in nilfs_dat_commit_free().

This also calls nilfs_error() in that case to notify that there is a fatal
flaw in the filesystem metadata and prevent further operations.

Link: https://lkml.kernel.org/r/00000000000097c20205ebaea3d6@google.com
Link: https://lkml.kernel.org/r/20221114040441.1649940-1-zhangpeng362@huawei.com
Link: https://lkml.kernel.org/r/20221119120542.17204-1-konishi.ryusuke@gmail.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+ebe05ee8e98f755f61d0@syzkaller.appspotmail.com
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/dat.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -111,6 +111,13 @@ static void nilfs_dat_commit_free(struct
 	kunmap_atomic(kaddr);
 
 	nilfs_dat_commit_entry(dat, req);
+
+	if (unlikely(req->pr_desc_bh == NULL || req->pr_bitmap_bh == NULL)) {
+		nilfs_error(dat->i_sb,
+			    "state inconsistency probably due to duplicate use of vblocknr = %llu",
+			    (unsigned long long)req->pr_entry_nr);
+		return;
+	}
 	nilfs_palloc_commit_free_entry(dat, req);
 }
 


