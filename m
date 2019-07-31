Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84C757B829
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 05:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbfGaDKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 23:10:08 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3256 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727137AbfGaDKI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Jul 2019 23:10:08 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id CEE4DA57303E09839F76;
        Wed, 31 Jul 2019 11:10:05 +0800 (CST)
Received: from RH5885H-V3.huawei.com (10.90.53.225) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Wed, 31 Jul 2019 11:09:55 +0800
From:   SunKe <sunke32@huawei.com>
To:     <sunke32@huawei.com>, <josef@toxicpanda.com>, <axboe@kernel.dk>,
        <linux-block@vger.kernel.org>, <nbd@other.debian.org>,
        <linux-kernel@vger.kernel.org>, <kamatam@amazon.com>,
        <manoj.br@gmail.com>, <stable@vger.kernel.org>, <dwmw@amazon.com>
Subject: [PATCH] nbd: replace kill_bdev() with __invalidate_device() again
Date:   Wed, 31 Jul 2019 11:15:46 +0800
Message-ID: <1564542946-26255-1-git-send-email-sunke32@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Munehisa Kamata <kamatam@amazon.com>

Commit abbbdf12497d ("replace kill_bdev() with __invalidate_device()")
once did this, but 29eaadc03649 ("nbd: stop using the bdev everywhere")
resurrected kill_bdev() and it has been there since then. So buffer_head
mappings still get killed on a server disconnection, and we can still
hit the BUG_ON on a filesystem on the top of the nbd device.

  EXT4-fs (nbd0): mounted filesystem with ordered data mode. Opts: (null)
  block nbd0: Receive control failed (result -32)
  block nbd0: shutting down sockets
  print_req_error: I/O error, dev nbd0, sector 66264 flags 3000
  EXT4-fs warning (device nbd0): htree_dirblock_to_tree:979: inode #2: lblock 0: comm ls: error -5 reading directory block
  print_req_error: I/O error, dev nbd0, sector 2264 flags 3000
  EXT4-fs error (device nbd0): __ext4_get_inode_loc:4690: inode #2: block 283: comm ls: unable to read itable block
  EXT4-fs error (device nbd0) in ext4_reserve_inode_write:5894: IO failure
  ------------[ cut here ]------------
  kernel BUG at fs/buffer.c:3057!
  invalid opcode: 0000 [#1] SMP PTI
  CPU: 7 PID: 40045 Comm: jbd2/nbd0-8 Not tainted 5.1.0-rc3+ #4
  Hardware name: Amazon EC2 m5.12xlarge/, BIOS 1.0 10/16/2017
  RIP: 0010:submit_bh_wbc+0x18b/0x190
  ...
  Call Trace:
   jbd2_write_superblock+0xf1/0x230 [jbd2]
   ? account_entity_enqueue+0xc5/0xf0
   jbd2_journal_update_sb_log_tail+0x94/0xe0 [jbd2]
   jbd2_journal_commit_transaction+0x12f/0x1d20 [jbd2]
   ? __switch_to_asm+0x40/0x70
   ...
   ? lock_timer_base+0x67/0x80
   kjournald2+0x121/0x360 [jbd2]
   ? remove_wait_queue+0x60/0x60
   kthread+0xf8/0x130
   ? commit_timeout+0x10/0x10 [jbd2]
   ? kthread_bind+0x10/0x10
   ret_from_fork+0x35/0x40

With __invalidate_device(), I no longer hit the BUG_ON with sync or
unmount on the disconnected device.

Fixes: 29eaadc03649 ("nbd: stop using the bdev everywhere")
Cc: linux-block@vger.kernel.org
Cc: Ratna Manoj Bolla <manoj.br@gmail.com>
Cc: nbd@other.debian.org
Cc: stable@vger.kernel.org
Cc: David Woodhouse <dwmw@amazon.com>
Signed-off-by: Munehisa Kamata <kamatam@amazon.com>

CR: https://code.amazon.com/reviews/CR-7629288
---
I reproduced this phenomenon on the fat file system.
reproduce steps :
1.Establish a nbd connection.
2.Run two threads:one do mount and umount,anther one do clear_sock ioctl
3.Then hit the BUG_ON.


 drivers/block/nbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 9bcde23..e21d2de 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1231,7 +1231,7 @@ static void nbd_clear_sock_ioctl(struct nbd_device *nbd,
 				 struct block_device *bdev)
 {
 	sock_shutdown(nbd);
-	kill_bdev(bdev);
+	__invalidate_device(bdev, true);
 	nbd_bdev_reset(bdev);
 	if (test_and_clear_bit(NBD_HAS_CONFIG_REF,
 			       &nbd->config->runtime_flags))
-- 
2.7.4

