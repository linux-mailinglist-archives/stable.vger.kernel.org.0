Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49B4612C7F3
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731532AbfL2Rsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:48:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:60454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731522AbfL2Rsu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:48:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADBD621744;
        Sun, 29 Dec 2019 17:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641730;
        bh=zlV9gXt1Og3XOzQDLJ0WVaMtduY/e1aNdRn45bVZsUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sO9YHA56Znr+4A07i7CAxdy5wCFBKsXaoMk+qEbz5Und8/W8zXEgCnI1Vs14i0BP1
         x6CG+K0dgJw9acN80mTSexZTuvxdhFIcm4IJEeT9KcVrMBAmqR9ifBkb1VhXbmfxgF
         DE3nnI+deDTL7H1g7WnOz9gG4kFD3cTZiXK2xh/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>,
        NeilBrown <neilb@suse.com>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 185/434] md/bitmap: avoid race window between md_bitmap_resize and bitmap_file_clear_bit
Date:   Sun, 29 Dec 2019 18:23:58 +0100
Message-Id: <20191229172714.106145567@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>

[ Upstream commit fadcbd2901a0f7c8721f3bdb69eac95c272dc8ed ]

We need to move "spin_lock_irq(&bitmap->counts.lock)" before unmap previous
storage, otherwise panic like belows could happen as follows.

[  902.353802] sdl: detected capacity change from 1077936128 to 3221225472
[  902.616948] general protection fault: 0000 [#1] SMP
[snip]
[  902.618588] CPU: 12 PID: 33698 Comm: md0_raid1 Tainted: G           O    4.14.144-1-pserver #4.14.144-1.1~deb10
[  902.618870] Hardware name: Supermicro SBA-7142G-T4/BHQGE, BIOS 3.00       10/24/2012
[  902.619120] task: ffff9ae1860fc600 task.stack: ffffb52e4c704000
[  902.619301] RIP: 0010:bitmap_file_clear_bit+0x90/0xd0 [md_mod]
[  902.619464] RSP: 0018:ffffb52e4c707d28 EFLAGS: 00010087
[  902.619626] RAX: ffe8008b0d061000 RBX: ffff9ad078c87300 RCX: 0000000000000000
[  902.619792] RDX: ffff9ad986341868 RSI: 0000000000000803 RDI: ffff9ad078c87300
[  902.619986] RBP: ffff9ad0ed7a8000 R08: 0000000000000000 R09: 0000000000000000
[  902.620154] R10: ffffb52e4c707ec0 R11: ffff9ad987d1ed44 R12: ffff9ad0ed7a8360
[  902.620320] R13: 0000000000000003 R14: 0000000000060000 R15: 0000000000000800
[  902.620487] FS:  0000000000000000(0000) GS:ffff9ad987d00000(0000) knlGS:0000000000000000
[  902.620738] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  902.620901] CR2: 000055ff12aecec0 CR3: 0000001005207000 CR4: 00000000000406e0
[  902.621068] Call Trace:
[  902.621256]  bitmap_daemon_work+0x2dd/0x360 [md_mod]
[  902.621429]  ? find_pers+0x70/0x70 [md_mod]
[  902.621597]  md_check_recovery+0x51/0x540 [md_mod]
[  902.621762]  raid1d+0x5c/0xeb0 [raid1]
[  902.621939]  ? try_to_del_timer_sync+0x4d/0x80
[  902.622102]  ? del_timer_sync+0x35/0x40
[  902.622265]  ? schedule_timeout+0x177/0x360
[  902.622453]  ? call_timer_fn+0x130/0x130
[  902.622623]  ? find_pers+0x70/0x70 [md_mod]
[  902.622794]  ? md_thread+0x94/0x150 [md_mod]
[  902.622959]  md_thread+0x94/0x150 [md_mod]
[  902.623121]  ? wait_woken+0x80/0x80
[  902.623280]  kthread+0x119/0x130
[  902.623437]  ? kthread_create_on_node+0x60/0x60
[  902.623600]  ret_from_fork+0x22/0x40
[  902.624225] RIP: bitmap_file_clear_bit+0x90/0xd0 [md_mod] RSP: ffffb52e4c707d28

Because mdadm was running on another cpu to do resize, so bitmap_resize was
called to replace bitmap as below shows.

PID: 38801  TASK: ffff9ad074a90e00  CPU: 0   COMMAND: "mdadm"
   [exception RIP: queued_spin_lock_slowpath+56]
   [snip]
-- <NMI exception stack> --
 #5 [ffffb52e60f17c58] queued_spin_lock_slowpath at ffffffff9c0b27b8
 #6 [ffffb52e60f17c58] bitmap_resize at ffffffffc0399877 [md_mod]
 #7 [ffffb52e60f17d30] raid1_resize at ffffffffc0285bf9 [raid1]
 #8 [ffffb52e60f17d50] update_size at ffffffffc038a31a [md_mod]
 #9 [ffffb52e60f17d70] md_ioctl at ffffffffc0395ca4 [md_mod]

And the procedure to keep resize bitmap safe is allocate new storage
space, then quiesce, copy bits, replace bitmap, and re-start.

However the daemon (bitmap_daemon_work) could happen even the array is
quiesced, which means when bitmap_file_clear_bit is triggered by raid1d,
then it thinks it should be fine to access store->filemap since
counts->lock is held, but resize could change the storage without the
protection of the lock.

Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
Cc: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md-bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index b092c7b5282f..3ad18246fcb3 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2139,6 +2139,7 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 		memcpy(page_address(store.sb_page),
 		       page_address(bitmap->storage.sb_page),
 		       sizeof(bitmap_super_t));
+	spin_lock_irq(&bitmap->counts.lock);
 	md_bitmap_file_unmap(&bitmap->storage);
 	bitmap->storage = store;
 
@@ -2154,7 +2155,6 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 	blocks = min(old_counts.chunks << old_counts.chunkshift,
 		     chunks << chunkshift);
 
-	spin_lock_irq(&bitmap->counts.lock);
 	/* For cluster raid, need to pre-allocate bitmap */
 	if (mddev_is_clustered(bitmap->mddev)) {
 		unsigned long page;
-- 
2.20.1



