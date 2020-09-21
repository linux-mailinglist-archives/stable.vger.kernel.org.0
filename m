Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE05271D10
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 10:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgIUIEa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 04:04:30 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:41545 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbgIUIEa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 04:04:30 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Sep 2020 04:04:29 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1600675470; x=1632211470;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=48HiImodvOyQMEz7h4Vt1pdh1Eg+kT48TxB7yfvS/j8=;
  b=X40IOBq3zeofJIk5rtqLgWCqQmB/qTYSj1a3t5Y1Upg7nYyPHOQSn2id
   eiRZWhQoVVkjKCeE4AV/xCBqpSN5+LhJqfZZdPL48KuNz2AtiiaZeoHbb
   zN16uz2yOWNH3WbHJ6pXEY08OUWTojUoiP7K8tbKVhbx2+83iRJn79eQl
   E9bC1RVQcS8qXXUVozKjkWBd4PdyhFSa14DILEtQlgdaoyp+8YlN/3zD5
   HVdQMe12++j77J8tBTBOwTBiAWnKJdgchoyuVgK/bVHJJdMprIUqrsg4Q
   nw6pdlDWcVACuTbFQis4tU1TRwMeVr3YDG0MW3NEUI+kNKTbWLCNUVpNH
   A==;
IronPort-SDR: smNwlxYx6Xk2+AYcY8h+mgP/WJMHdjzuafnj/bNIf+y6L1lFSgiySBOSnu8diLswooiNhv5JhY
 XAmK9QneTn8XW6uieXJ1wR0ejHfyK0GIKVCByVM8GyjjbPDq9/mhhy6nSzmUud0KGdGQrVc1aJ
 0AuNd+iyObYDTTZeyYNyTGW+nHphg4BmuhVvsqZgw+gYGJ+RKChr/9mdxyBnES21paTgvvQW4i
 vx0oAbJh77jauJaIXssPuZfndwVaxiwGIr7alyQ2otByyAGns3qUIptTkjoTcx9IV0pkIPTPHC
 iCI=
X-IronPort-AV: E=Sophos;i="5.77,286,1596470400"; 
   d="scan'208";a="147887197"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Sep 2020 15:57:23 +0800
IronPort-SDR: F6LhAAYkTHbv4hVC553iNYOTv8IbyMQVr2bEU6U3YWF4bmkUKRb/e0qpq5iwgqRxj3eUEp/GIp
 jZ6e23YVQy+A==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 00:44:26 -0700
IronPort-SDR: Utobc2A7Y4Qgxtsg05gMASCQgQT/JPQ9lIlvv+FZM1kTu8OLJqqtrJy4R+Y6so77wLNFyKkSIU
 Z78PCXx5ptog==
WDCIronportException: Internal
Received: from unknown (HELO redsun60.ssa.fujisawa.hgst.com) ([10.149.66.36])
  by uls-op-cesaip02.wdc.com with ESMTP; 21 Sep 2020 00:57:22 -0700
From:   Johannes Thumshirn <johannes.thumshirn@wdc.com>
To:     David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org, Anand Jain <anand.jain@oracle.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        syzbot+e864a35d361e1d4e29a5@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Subject: [PATCH v2] btrfs: fix overflow when copying corrupt csums for a message
Date:   Mon, 21 Sep 2020 16:57:14 +0900
Message-Id: <20200921075714.33372-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Syzkaller reported a buffer overflow in btree_readpage_end_io_hook()
when loop mounting a crafted image:

  detected buffer overflow in memcpy
  ------------[ cut here ]------------
  kernel BUG at lib/string.c:1129!
  invalid opcode: 0000 [#1] PREEMPT SMP KASAN
  CPU: 1 PID: 26 Comm: kworker/u4:2 Not tainted 5.9.0-rc4-syzkaller #0
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
  Workqueue: btrfs-endio-meta btrfs_work_helper
  RIP: 0010:fortify_panic+0xf/0x20 lib/string.c:1129
  RSP: 0018:ffffc90000e27980 EFLAGS: 00010286
  RAX: 0000000000000022 RBX: ffff8880a80dca64 RCX: 0000000000000000
  RDX: ffff8880a90860c0 RSI: ffffffff815dba07 RDI: fffff520001c4f22
  RBP: ffff8880a80dca00 R08: 0000000000000022 R09: ffff8880ae7318e7
  R10: 0000000000000000 R11: 0000000000077578 R12: 00000000ffffff6e
  R13: 0000000000000008 R14: ffffc90000e27a40 R15: 1ffff920001c4f3c
  FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000557335f440d0 CR3: 000000009647d000 CR4: 00000000001506e0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   memcpy include/linux/string.h:405 [inline]
   btree_readpage_end_io_hook.cold+0x206/0x221 fs/btrfs/disk-io.c:642
   end_bio_extent_readpage+0x4de/0x10c0 fs/btrfs/extent_io.c:2854
   bio_endio+0x3cf/0x7f0 block/bio.c:1449
   end_workqueue_fn+0x114/0x170 fs/btrfs/disk-io.c:1695
   btrfs_work_helper+0x221/0xe20 fs/btrfs/async-thread.c:318
   process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
   worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
   kthread+0x3b5/0x4a0 kernel/kthread.c:292
   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
  Modules linked in:
  ---[ end trace b68924293169feef ]---
  RIP: 0010:fortify_panic+0xf/0x20 lib/string.c:1129
  RSP: 0018:ffffc90000e27980 EFLAGS: 00010286
  RAX: 0000000000000022 RBX: ffff8880a80dca64 RCX: 0000000000000000
  RDX: ffff8880a90860c0 RSI: ffffffff815dba07 RDI: fffff520001c4f22
  RBP: ffff8880a80dca00 R08: 0000000000000022 R09: ffff8880ae7318e7
  R10: 0000000000000000 R11: 0000000000077578 R12: 00000000ffffff6e
  R13: 0000000000000008 R14: ffffc90000e27a40 R15: 1ffff920001c4f3c
  FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007f95b7c4d008 CR3: 000000009647d000 CR4: 00000000001506e0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

The overflow happens, because in btree_readpage_end_io_hook() we assume
that we have found a 4 byte checksum instead of the real possible 32
bytes we have for the checksums.

With the fix applied:

[   35.726623] BTRFS: device fsid 815caf9a-dc43-4d2a-ac54-764b8333d765 devid 1 transid 5 /dev/loop0 scanned by syz-repro (215)
[   35.738994] BTRFS info (device loop0): disk space caching is enabled
[   35.738998] BTRFS info (device loop0): has skinny extents
[   35.743337] BTRFS warning (device loop0): loop0 checksum verify failed on 1052672 wanted 0xf9c035fc8d239a54 found 0x67a25c14b7eabcf9 level 0
[   35.743420] BTRFS error (device loop0): failed to read chunk root
[   35.745899] BTRFS error (device loop0): open_ctree failed

Reported-by: syzbot+e864a35d361e1d4e29a5@syzkaller.appspotmail.com
Fixes: d5178578bcd4 ("btrfs: directly call into crypto framework for checksumming")
CC: stable@vger.kernel.org # 5.4+
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

---
Changes to v1:
- Use CSUM_FMT (David)
- Fix the 2nd possible overflow (David)
- Remove some unnecessary local variables and memcpy (David)
- Update commit log to have the now correct new log entries
---
 fs/btrfs/disk-io.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 160b485d2cc0..53b588a7e150 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -586,16 +586,15 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 	csum_tree_block(eb, result);
 
 	if (memcmp_extent_buffer(eb, result, 0, csum_size)) {
-		u32 val;
-		u32 found = 0;
-
-		memcpy(&found, result, csum_size);
+		u8 val[BTRFS_CSUM_SIZE] = { 0 };
 
 		read_extent_buffer(eb, &val, 0, csum_size);
 		btrfs_warn_rl(fs_info,
-		"%s checksum verify failed on %llu wanted %x found %x level %d",
+	"%s checksum verify failed on %llu wanted " CSUM_FMT " found " CSUM_FMT " level %d",
 			      fs_info->sb->s_id, eb->start,
-			      val, found, btrfs_header_level(eb));
+			      CSUM_FMT_VALUE(csum_size, val),
+			      CSUM_FMT_VALUE(csum_size, result),
+			      btrfs_header_level(eb));
 		ret = -EUCLEAN;
 		goto err;
 	}
-- 
2.26.2

