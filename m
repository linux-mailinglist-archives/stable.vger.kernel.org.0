Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5CBCA3EF
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389891AbfJCQUW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:20:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389877AbfJCQUW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:20:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D58E6222BE;
        Thu,  3 Oct 2019 16:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119621;
        bh=WbFGzKa+WGJChvzA/KCdzaWwqgs1oYs8LIMyu5WgWpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V4M+u3SevYh3M5c5AfcWugOaH5cqNeVGLOB0l/aItuBaIQwCnxQJUiNNN1sSLxmXT
         Cd2pDly0N/t9UJFFQ7HPflktCqMYyTCHqU+7aOXt2zb1dfPIuIvcpBHlgdufZK3Dtt
         pbRP12F/w93oFkRvZeXOlrfdT5iqmoGSTIwULBkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 132/211] raid5: dont set STRIPE_HANDLE to stripe which is in batch list
Date:   Thu,  3 Oct 2019 17:53:18 +0200
Message-Id: <20191003154517.031787080@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>

[ Upstream commit 6ce220dd2f8ea71d6afc29b9a7524c12e39f374a ]

If stripe in batch list is set with STRIPE_HANDLE flag, then the stripe
could be set with STRIPE_ACTIVE by the handle_stripe function. And if
error happens to the batch_head at the same time, break_stripe_batch_list
is called, then below warning could happen (the same report in [1]), it
means a member of batch list was set with STRIPE_ACTIVE.

[7028915.431770] stripe state: 2001
[7028915.431815] ------------[ cut here ]------------
[7028915.431828] WARNING: CPU: 18 PID: 29089 at drivers/md/raid5.c:4614 break_stripe_batch_list+0x203/0x240 [raid456]
[...]
[7028915.431879] CPU: 18 PID: 29089 Comm: kworker/u82:5 Tainted: G           O    4.14.86-1-storage #4.14.86-1.2~deb9
[7028915.431881] Hardware name: Supermicro SSG-2028R-ACR24L/X10DRH-iT, BIOS 3.1 06/18/2018
[7028915.431888] Workqueue: raid5wq raid5_do_work [raid456]
[7028915.431890] task: ffff9ab0ef36d7c0 task.stack: ffffb72926f84000
[7028915.431896] RIP: 0010:break_stripe_batch_list+0x203/0x240 [raid456]
[7028915.431898] RSP: 0018:ffffb72926f87ba8 EFLAGS: 00010286
[7028915.431900] RAX: 0000000000000012 RBX: ffff9aaa84a98000 RCX: 0000000000000000
[7028915.431901] RDX: 0000000000000000 RSI: ffff9ab2bfa15458 RDI: ffff9ab2bfa15458
[7028915.431902] RBP: ffff9aaa8fb4e900 R08: 0000000000000001 R09: 0000000000002eb4
[7028915.431903] R10: 00000000ffffffff R11: 0000000000000000 R12: ffff9ab1736f1b00
[7028915.431904] R13: 0000000000000000 R14: ffff9aaa8fb4e900 R15: 0000000000000001
[7028915.431906] FS:  0000000000000000(0000) GS:ffff9ab2bfa00000(0000) knlGS:0000000000000000
[7028915.431907] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[7028915.431908] CR2: 00007ff953b9f5d8 CR3: 0000000bf4009002 CR4: 00000000003606e0
[7028915.431909] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[7028915.431910] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[7028915.431910] Call Trace:
[7028915.431923]  handle_stripe+0x8e7/0x2020 [raid456]
[7028915.431930]  ? __wake_up_common_lock+0x89/0xc0
[7028915.431935]  handle_active_stripes.isra.58+0x35f/0x560 [raid456]
[7028915.431939]  raid5_do_work+0xc6/0x1f0 [raid456]

Also commit 59fc630b8b5f9f ("RAID5: batch adjacent full stripe write")
said "If a stripe is added to batch list, then only the first stripe
of the list should be put to handle_list and run handle_stripe."

So don't set STRIPE_HANDLE to stripe which is already in batch list,
otherwise the stripe could be put to handle_list and run handle_stripe,
then the above warning could be triggered.

[1]. https://www.spinics.net/lists/raid/msg62552.html

Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a147619498dfb..d26e5e9bea427 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5721,7 +5721,8 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 				do_flush = false;
 			}
 
-			set_bit(STRIPE_HANDLE, &sh->state);
+			if (!sh->batch_head)
+				set_bit(STRIPE_HANDLE, &sh->state);
 			clear_bit(STRIPE_DELAYED, &sh->state);
 			if ((!sh->batch_head || sh == sh->batch_head) &&
 			    (bi->bi_opf & REQ_SYNC) &&
-- 
2.20.1



