Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC22A63E3AD
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 23:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiK3Wvo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 17:51:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiK3Wvk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 17:51:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8898DBDD;
        Wed, 30 Nov 2022 14:51:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48B4A61E26;
        Wed, 30 Nov 2022 22:51:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C29FC433D7;
        Wed, 30 Nov 2022 22:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669848698;
        bh=G1DOaMoZDix8nPelGd1uKcnfhWICnemtQU/uk758EMw=;
        h=Date:To:From:Subject:From;
        b=SOqB8r9JKGjWxOtkH7eCVBW1t1MtUSECrI8CscgvKhpiSanz7dYqx3g927lLSF/25
         X6NOuU1PWibKVCGWqbwczQuUJ52wXBCnrqsyoBKX/t/JobchfcSyyiYdB8kJ5HKsv2
         MBvnF1ZhKfvcBygi6UHKNhsg+RQcyhm9j9++Ym1U=
Date:   Wed, 30 Nov 2022 14:51:37 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        konishi.ryusuke@gmail.com, zhangpeng362@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-fix-null-pointer-dereference-in-nilfs_palloc_commit_free_entry.patch removed from -mm tree
Message-Id: <20221130225138.9C29FC433D7@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: nilfs2: fix NULL pointer dereference in nilfs_palloc_commit_free_entry()
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-null-pointer-dereference-in-nilfs_palloc_commit_free_entry.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: nilfs2: fix NULL pointer dereference in nilfs_palloc_commit_free_entry()
Date: Sat, 19 Nov 2022 21:05:42 +0900

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
---

 fs/nilfs2/dat.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/nilfs2/dat.c~nilfs2-fix-null-pointer-dereference-in-nilfs_palloc_commit_free_entry
+++ a/fs/nilfs2/dat.c
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
 
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are

hfs-fix-oob-read-in-__hfs_brec_find.patch

