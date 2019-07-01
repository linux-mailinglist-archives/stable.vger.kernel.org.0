Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23F90EE38
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 03:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729238AbfD3BQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 21:16:15 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:65012 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728997AbfD3BQP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Apr 2019 21:16:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1556586974; x=1588122974;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=kZJmUUu3KOr0i1JHdMOfq6JZUSh1OG/XY75e7KDiEcU=;
  b=l5ZBMWVPPrO/GE1ajOWD/sdQr1LemuGhCQcNJhbJTtBIW75IaromR+OR
   r8LGT0zRwBbvugymruZ7AxFe4qTnt7dsDRMNmY2EF1Nwj5qo6TJc7rrGF
   upecGBJyOhxp8rJaLTB0gHIdArXyLowCjVS87tBZoF6fWgdkaOc/sGPfj
   g=;
X-IronPort-AV: E=Sophos;i="5.60,411,1549929600"; 
   d="scan'208";a="671782175"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-2b-3714e498.us-west-2.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 30 Apr 2019 01:16:11 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-3714e498.us-west-2.amazon.com (8.14.7/8.14.7) with ESMTP id x3U1GBFj113482
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 30 Apr 2019 01:16:11 GMT
Received: from EX13D10UWB002.ant.amazon.com (10.43.161.130) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 30 Apr 2019 01:16:11 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D10UWB002.ant.amazon.com (10.43.161.130) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 30 Apr 2019 01:16:10 +0000
Received: from u480fcf3d32ea57e0427f.ant.amazon.com (10.60.244.90) by
 mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Tue, 30 Apr 2019 01:16:10 +0000
From:   Munehisa Kamata <kamatam@amazon.com>
To:     <josef@toxicpanda.com>, <axboe@kernel.dk>
CC:     Munehisa Kamata <kamatam@amazon.com>,
        <linux-block@vger.kernel.org>,
        "Ratna Manoj Bolla" <manoj.br@gmail.com>, <nbd@other.debian.org>,
        <stable@vger.kernel.org>, David Woodhouse <dwmw@amazon.com>
Subject: [PATCH] nbd: replace kill_bdev() with __invalidate_device() again
Date:   Mon, 29 Apr 2019 18:15:41 -0700
Message-ID: <1556586941-21818-1-git-send-email-kamatam@amazon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
 drivers/block/nbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 90ba9f4..6d6eedd 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1217,7 +1217,7 @@ static void nbd_clear_sock_ioctl(struct nbd_device *nbd,
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

