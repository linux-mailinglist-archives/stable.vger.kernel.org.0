Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6EA3353CE7
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 10:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbhDEI5X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 04:57:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233142AbhDEI5Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 04:57:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6B3A6139E;
        Mon,  5 Apr 2021 08:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613030;
        bh=teHUG3InJy7OYJvmr2kg+wS5qfOI8ycdVjxF0yfQmvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B4vtbxkIZUbp0OTsS2pJ1CxLX9w2XXoi/qlFmXjUXaoRKFPGAbGZxAuVsQngzng3h
         4vcT4USnWSc8ZNpV2V3feuIuyenK90sJkD2PGUicz1VXs/CgeUohAXvFsHyxMbDnwI
         B6W7C+q9cmrvzpkNL4LzkcPMMf1cVMJrYDu0o04c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 26/35] firewire: nosy: Fix a use-after-free bug in nosy_ioctl()
Date:   Mon,  5 Apr 2021 10:54:01 +0200
Message-Id: <20210405085019.702434804@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085018.871387942@linuxfoundation.org>
References: <20210405085018.871387942@linuxfoundation.org>
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
index 180f0a96528c..646dca0a8d73 100644
--- a/drivers/firewire/nosy.c
+++ b/drivers/firewire/nosy.c
@@ -359,6 +359,7 @@ nosy_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	struct client *client = file->private_data;
 	spinlock_t *client_list_lock = &client->lynx->client_list_lock;
 	struct nosy_stats stats;
+	int ret;
 
 	switch (cmd) {
 	case NOSY_IOC_GET_STATS:
@@ -373,11 +374,15 @@ nosy_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
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



