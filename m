Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB4C9E079
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732486AbfH0IEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:04:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:33488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731986AbfH0IEL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:04:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81D4C2173E;
        Tue, 27 Aug 2019 08:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893050;
        bh=T76hk9suREYgpjoLZQg3na5LCWVAF5dSPvq6Y5909ZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RwPP6dMXlICiKi7EidUA/3BQ11TK6DxK02rImBrymQRekygQmrEL6lrtrbj/l0mgq
         UB9VE8a/OTXtzTx3Le2IY25YprRs36tAMdFqCEGvuFgieeiiYclfyZLmP9AIYBB3M9
         bsh94bEvynQSzTl+t94NWeyrwSdqK2QMhWNVMTKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, He Zhe <zhe.he@windriver.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 101/162] block: aoe: Fix kernel crash due to atomic sleep when exiting
Date:   Tue, 27 Aug 2019 09:50:29 +0200
Message-Id: <20190827072741.773707982@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 430380b4637aec646996b4aef67ad417593923b2 ]

Since commit 3582dd291788 ("aoe: convert aoeblk to blk-mq"), aoedev_downdev
has had the possibility of sleeping and causing the following crash.

BUG: scheduling while atomic: rmmod/2242/0x00000003
Modules linked in: aoe
Preemption disabled at:
[<ffffffffc01d95e5>] flush+0x95/0x4a0 [aoe]
CPU: 7 PID: 2242 Comm: rmmod Tainted: G          I       5.2.3 #1
Hardware name: Intel Corporation S5520HC/S5520HC, BIOS S5500.86B.01.10.0025.030220091519 03/02/2009
Call Trace:
 dump_stack+0x4f/0x6a
 ? flush+0x95/0x4a0 [aoe]
 __schedule_bug.cold+0x44/0x54
 __schedule+0x44f/0x680
 schedule+0x44/0xd0
 blk_mq_freeze_queue_wait+0x46/0xb0
 ? wait_woken+0x80/0x80
 blk_mq_freeze_queue+0x1b/0x20
 aoedev_downdev+0x111/0x160 [aoe]
 flush+0xff/0x4a0 [aoe]
 aoedev_exit+0x23/0x30 [aoe]
 aoe_exit+0x35/0x948 [aoe]
 __se_sys_delete_module+0x183/0x210
 __x64_sys_delete_module+0x16/0x20
 do_syscall_64+0x4d/0x130
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f24e0043b07
Code: 73 01 c3 48 8b 0d 89 73 0b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f
1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 b0 00 00 00 0f 05 <48> 3d 01 f0 ff
ff 73 01 c3 48 8b 0d 59 73 0b 00 f7 d8 64 89 01 48
RSP: 002b:00007ffe18f7f1e8 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f24e0043b07
RDX: 000000000000000a RSI: 0000000000000800 RDI: 0000555c3ecf87c8
RBP: 00007ffe18f7f1f0 R08: 0000000000000000 R09: 0000000000000000
R10: 00007f24e00b4ac0 R11: 0000000000000206 R12: 00007ffe18f7f238
R13: 00007ffe18f7f410 R14: 00007ffe18f80e73 R15: 0000555c3ecf8760

This patch, handling in the same way of pass two, unlocks the locks and
restart pass one after aoedev_downdev is done.

Fixes: 3582dd291788 ("aoe: convert aoeblk to blk-mq")
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/aoe/aoedev.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index 5b49f1b33ebec..e2ea2356da061 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -323,10 +323,14 @@ flush(const char __user *str, size_t cnt, int exiting)
 	}
 
 	flush_scheduled_work();
-	/* pass one: without sleeping, do aoedev_downdev */
+	/* pass one: do aoedev_downdev, which might sleep */
+restart1:
 	spin_lock_irqsave(&devlist_lock, flags);
 	for (d = devlist; d; d = d->next) {
 		spin_lock(&d->lock);
+		if (d->flags & DEVFL_TKILL)
+			goto cont;
+
 		if (exiting) {
 			/* unconditionally take each device down */
 		} else if (specified) {
@@ -338,8 +342,11 @@ flush(const char __user *str, size_t cnt, int exiting)
 		|| d->ref)
 			goto cont;
 
+		spin_unlock(&d->lock);
+		spin_unlock_irqrestore(&devlist_lock, flags);
 		aoedev_downdev(d);
 		d->flags |= DEVFL_TKILL;
+		goto restart1;
 cont:
 		spin_unlock(&d->lock);
 	}
@@ -348,7 +355,7 @@ cont:
 	/* pass two: call freedev, which might sleep,
 	 * for aoedevs marked with DEVFL_TKILL
 	 */
-restart:
+restart2:
 	spin_lock_irqsave(&devlist_lock, flags);
 	for (d = devlist; d; d = d->next) {
 		spin_lock(&d->lock);
@@ -357,7 +364,7 @@ restart:
 			spin_unlock(&d->lock);
 			spin_unlock_irqrestore(&devlist_lock, flags);
 			freedev(d);
-			goto restart;
+			goto restart2;
 		}
 		spin_unlock(&d->lock);
 	}
-- 
2.20.1



