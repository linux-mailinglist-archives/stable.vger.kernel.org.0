Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74026353F37
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239411AbhDEJKm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:10:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:56928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239390AbhDEJKi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:10:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C1206139D;
        Mon,  5 Apr 2021 09:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613825;
        bh=+W+vlglgFHzgRJMyRoXng4w6JlgSrTe8jV0YDN8+uTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rkN5gcEZDcjl0doAyvZmqVtKuU2mBuu+Rrj6C6ydIrA/Uste6XrzmxLceCn4ziTMK
         mtwUbEVux7nuGMNHrwq5FxtsimhIa1Y8Iuys2h8puewFgsfTXoSeMO8KfYHvFHikA4
         NFYQ3+olsRTPyxnxuhWQUsGF4dB34xxeQ5yjmyWA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 104/126] firewire: nosy: Fix a use-after-free bug in nosy_ioctl()
Date:   Mon,  5 Apr 2021 10:54:26 +0200
Message-Id: <20210405085034.486273944@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit 829933ef05a951c8ff140e814656d73e74915faf ]

For each device, the nosy driver allocates a pcilynx structure.
A use-after-free might happen in the following scenario:

 1. Open nosy device for the first time and call ioctl with command
    NOSY_IOC_START, then a new client A will be malloced and added to
    doubly linked list.
 2. Open nosy device for the second time and call ioctl with command
    NOSY_IOC_START, then a new client B will be malloced and added to
    doubly linked list.
 3. Call ioctl with command NOSY_IOC_START for client A, then client A
    will be readded to the doubly linked list. Now the doubly linked
    list is messed up.
 4. Close the first nosy device and nosy_release will be called. In
    nosy_release, client A will be unlinked and freed.
 5. Close the second nosy device, and client A will be referenced,
    resulting in UAF.

The root cause of this bug is that the element in the doubly linked list
is reentered into the list.

Fix this bug by adding a check before inserting a client.  If a client
is already in the linked list, don't insert it.

The following KASAN report reveals it:

   BUG: KASAN: use-after-free in nosy_release+0x1ea/0x210
   Write of size 8 at addr ffff888102ad7360 by task poc
   CPU: 3 PID: 337 Comm: poc Not tainted 5.12.0-rc5+ #6
   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
   Call Trace:
     nosy_release+0x1ea/0x210
     __fput+0x1e2/0x840
     task_work_run+0xe8/0x180
     exit_to_user_mode_prepare+0x114/0x120
     syscall_exit_to_user_mode+0x1d/0x40
     entry_SYSCALL_64_after_hwframe+0x44/0xae

   Allocated by task 337:
     nosy_open+0x154/0x4d0
     misc_open+0x2ec/0x410
     chrdev_open+0x20d/0x5a0
     do_dentry_open+0x40f/0xe80
     path_openat+0x1cf9/0x37b0
     do_filp_open+0x16d/0x390
     do_sys_openat2+0x11d/0x360
     __x64_sys_open+0xfd/0x1a0
     do_syscall_64+0x33/0x40
     entry_SYSCALL_64_after_hwframe+0x44/0xae

   Freed by task 337:
     kfree+0x8f/0x210
     nosy_release+0x158/0x210
     __fput+0x1e2/0x840
     task_work_run+0xe8/0x180
     exit_to_user_mode_prepare+0x114/0x120
     syscall_exit_to_user_mode+0x1d/0x40
     entry_SYSCALL_64_after_hwframe+0x44/0xae

   The buggy address belongs to the object at ffff888102ad7300 which belongs to the cache kmalloc-128 of size 128
   The buggy address is located 96 bytes inside of 128-byte region [ffff888102ad7300, ffff888102ad7380)

[ Modified to use 'list_empty()' inside proper lock  - Linus ]

Link: https://lore.kernel.org/lkml/1617433116-5930-1-git-send-email-zheyuma97@gmail.com/
Reported-and-tested-by: 马哲宇 (Zheyu Ma) <zheyuma97@gmail.com>
Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firewire/nosy.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/firewire/nosy.c b/drivers/firewire/nosy.c
index 5fd6a60b6741..88ed971e32c0 100644
--- a/drivers/firewire/nosy.c
+++ b/drivers/firewire/nosy.c
@@ -346,6 +346,7 @@ nosy_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	struct client *client = file->private_data;
 	spinlock_t *client_list_lock = &client->lynx->client_list_lock;
 	struct nosy_stats stats;
+	int ret;
 
 	switch (cmd) {
 	case NOSY_IOC_GET_STATS:
@@ -360,11 +361,15 @@ nosy_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			return 0;
 
 	case NOSY_IOC_START:
+		ret = -EBUSY;
 		spin_lock_irq(client_list_lock);
-		list_add_tail(&client->link, &client->lynx->client_list);
+		if (list_empty(&client->link)) {
+			list_add_tail(&client->link, &client->lynx->client_list);
+			ret = 0;
+		}
 		spin_unlock_irq(client_list_lock);
 
-		return 0;
+		return ret;
 
 	case NOSY_IOC_STOP:
 		spin_lock_irq(client_list_lock);
-- 
2.30.2



