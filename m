Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB5269566
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732659AbfGOO4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:56:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:49650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390006AbfGOOWR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:22:17 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3849B21841;
        Mon, 15 Jul 2019 14:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200537;
        bh=eflVd/TBCznpHOlph0rvv5Y/cnF+YGvAub+CSpoCRk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zOROzWYV5BwE6QWi4FWNUWo7tdkwrb5ODP7lSq7c+hsYFPuOXoygFHeYDiXN/JUHo
         XwCXNsGF2jNvfwWTc81Us6UFjcLiBkj5Hj2QAwOUu/ckyKpoibnlx9HIwwc+GaRF5C
         cDbLeka+WJv4NXB19Rxo9Qe3WKYQElm8yLwttMhw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Liu <bob.liu@oracle.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 071/158] block: null_blk: fix race condition for null_del_dev
Date:   Mon, 15 Jul 2019 10:16:42 -0400
Message-Id: <20190715141809.8445-71-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715141809.8445-1-sashal@kernel.org>
References: <20190715141809.8445-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Liu <bob.liu@oracle.com>

[ Upstream commit 7602843fd873cae43a444b83b14dfdd114a9659c ]

Dulicate call of null_del_dev() will trigger null pointer error like below.
The reason is a race condition between nullb_device_power_store() and
nullb_group_drop_item().

  CPU#0                         CPU#1
  ----------------              -----------------
  do_rmdir()
   >configfs_rmdir()
    >client_drop_item()
     >nullb_group_drop_item()
                                nullb_device_power_store()
				>null_del_dev()

      >test_and_clear_bit(NULLB_DEV_FL_UP
       >null_del_dev()
       ^^^^^
       Duplicated null_dev_dev() triger null pointer error

				>clear_bit(NULLB_DEV_FL_UP

The fix could be keep the sequnce of clear NULLB_DEV_FL_UP and null_del_dev().

[  698.613600] BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
[  698.613608] #PF error: [normal kernel read fault]
[  698.613611] PGD 0 P4D 0
[  698.613619] Oops: 0000 [#1] SMP PTI
[  698.613627] CPU: 3 PID: 6382 Comm: rmdir Not tainted 5.0.0+ #35
[  698.613631] Hardware name: LENOVO 20LJS2EV08/20LJS2EV08, BIOS R0SET33W (1.17 ) 07/18/2018
[  698.613644] RIP: 0010:null_del_dev+0xc/0x110 [null_blk]
[  698.613649] Code: 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 0b eb 97 e8 47 bb 2a e8 0f 1f 80 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 41 54 53 <8b> 77 18 48 89 fb 4c 8b 27 48 c7 c7 40 57 1e c1 e8 bf c7 cb e8 48
[  698.613654] RSP: 0018:ffffb887888bfde0 EFLAGS: 00010286
[  698.613659] RAX: 0000000000000000 RBX: ffff9d436d92bc00 RCX: ffff9d43a9184681
[  698.613663] RDX: ffffffffc11e5c30 RSI: 0000000068be6540 RDI: 0000000000000000
[  698.613667] RBP: ffffb887888bfdf0 R08: 0000000000000001 R09: 0000000000000000
[  698.613671] R10: ffffb887888bfdd8 R11: 0000000000000f16 R12: ffff9d436d92bc08
[  698.613675] R13: ffff9d436d94e630 R14: ffffffffc11e5088 R15: ffffffffc11e5000
[  698.613680] FS:  00007faa68be6540(0000) GS:ffff9d43d14c0000(0000) knlGS:0000000000000000
[  698.613685] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  698.613689] CR2: 0000000000000018 CR3: 000000042f70c002 CR4: 00000000003606e0
[  698.613693] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  698.613697] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  698.613700] Call Trace:
[  698.613712]  nullb_group_drop_item+0x50/0x70 [null_blk]
[  698.613722]  client_drop_item+0x29/0x40
[  698.613728]  configfs_rmdir+0x1ed/0x300
[  698.613738]  vfs_rmdir+0xb2/0x130
[  698.613743]  do_rmdir+0x1c7/0x1e0
[  698.613750]  __x64_sys_rmdir+0x17/0x20
[  698.613759]  do_syscall_64+0x5a/0x110
[  698.613768]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Signed-off-by: Bob Liu <bob.liu@oracle.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk_main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_main.c
index 093b614d6524..c5c0b7c89481 100644
--- a/drivers/block/null_blk_main.c
+++ b/drivers/block/null_blk_main.c
@@ -321,11 +321,12 @@ static ssize_t nullb_device_power_store(struct config_item *item,
 		set_bit(NULLB_DEV_FL_CONFIGURED, &dev->flags);
 		dev->power = newp;
 	} else if (dev->power && !newp) {
-		mutex_lock(&lock);
-		dev->power = newp;
-		null_del_dev(dev->nullb);
-		mutex_unlock(&lock);
-		clear_bit(NULLB_DEV_FL_UP, &dev->flags);
+		if (test_and_clear_bit(NULLB_DEV_FL_UP, &dev->flags)) {
+			mutex_lock(&lock);
+			dev->power = newp;
+			null_del_dev(dev->nullb);
+			mutex_unlock(&lock);
+		}
 		clear_bit(NULLB_DEV_FL_CONFIGURED, &dev->flags);
 	}
 
-- 
2.20.1

