Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18FF3FDBA8
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345297AbhIAMnB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:43:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343883AbhIAMky (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:40:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BF726120A;
        Wed,  1 Sep 2021 12:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499855;
        bh=wDXf/Kjp0EA3Z2E98KVXQXTekKE7nY6mg8joA5djng4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e2ktO4X1Pd4hdsTO1YnIbfPjC4okJlK9tJMfHhbo0fOoqBzJX6hOGR+HqDkuwtw2y
         G/g/lojAO3XGjHegyjSztSkENuwmBz7lmlYNAmJaUuyIQbW+TB+u00YnHXyi55+Icn
         sGDfAqdTdz+z2s9/T2DUa2vS3fS0kLUNh2sFCBUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 010/113] io_uring: rsrc ref lock needs to be IRQ safe
Date:   Wed,  1 Sep 2021 14:27:25 +0200
Message-Id: <20210901122302.320638650@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 4956b9eaad456a88b0d56947bef036e086250beb ]

Nadav reports running into the below splat on re-enabling softirqs:

WARNING: CPU: 2 PID: 1777 at kernel/softirq.c:364 __local_bh_enable_ip+0xaa/0xe0
Modules linked in:
CPU: 2 PID: 1777 Comm: umem Not tainted 5.13.1+ #161
Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/22/2020
RIP: 0010:__local_bh_enable_ip+0xaa/0xe0
Code: a9 00 ff ff 00 74 38 65 ff 0d a2 21 8c 7a e8 ed 1a 20 00 fb 66 0f 1f 44 00 00 5b 41 5c 5d c3 65 8b 05 e6 2d 8c 7a 85 c0 75 9a <0f> 0b eb 96 e8 2d 1f 20 00 eb a5 4c 89 e7 e8 73 4f 0c 00 eb ae 65
RSP: 0018:ffff88812e58fcc8 EFLAGS: 00010046
RAX: 0000000000000000 RBX: 0000000000000201 RCX: dffffc0000000000
RDX: 0000000000000007 RSI: 0000000000000201 RDI: ffffffff8898c5ac
RBP: ffff88812e58fcd8 R08: ffffffff8575dbbf R09: ffffed1028ef14f9
R10: ffff88814778a7c3 R11: ffffed1028ef14f8 R12: ffffffff85c9e9ae
R13: ffff88814778a000 R14: ffff88814778a7b0 R15: ffff8881086db890
FS:  00007fbcfee17700(0000) GS:ffff8881e0300000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c0402a5008 CR3: 000000011c1ac003 CR4: 00000000003706e0
Call Trace:
 _raw_spin_unlock_bh+0x31/0x40
 io_rsrc_node_ref_zero+0x13e/0x190
 io_dismantle_req+0x215/0x220
 io_req_complete_post+0x1b8/0x720
 __io_complete_rw.isra.0+0x16b/0x1f0
 io_complete_rw+0x10/0x20

where it's clear we end up calling the percpu count release directly
from the completion path, as it's in atomic mode and we drop the last
ref. For file/block IO, this can be from IRQ context already, and the
softirq locking for rsrc isn't enough.

Just make the lock fully IRQ safe, and ensure we correctly safe state
from the release path as we don't know the full context there.

Reported-by: Nadav Amit <nadav.amit@gmail.com>
Tested-by: Nadav Amit <nadav.amit@gmail.com>
Link: https://lore.kernel.org/io-uring/C187C836-E78B-4A31-B24C-D16919ACA093@gmail.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9df82eee440a..f6ddc7182943 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7105,16 +7105,6 @@ static void io_free_file_tables(struct io_file_table *table, unsigned nr_files)
 	table->files = NULL;
 }
 
-static inline void io_rsrc_ref_lock(struct io_ring_ctx *ctx)
-{
-	spin_lock_bh(&ctx->rsrc_ref_lock);
-}
-
-static inline void io_rsrc_ref_unlock(struct io_ring_ctx *ctx)
-{
-	spin_unlock_bh(&ctx->rsrc_ref_lock);
-}
-
 static void io_rsrc_node_destroy(struct io_rsrc_node *ref_node)
 {
 	percpu_ref_exit(&ref_node->refs);
@@ -7131,9 +7121,9 @@ static void io_rsrc_node_switch(struct io_ring_ctx *ctx,
 		struct io_rsrc_node *rsrc_node = ctx->rsrc_node;
 
 		rsrc_node->rsrc_data = data_to_kill;
-		io_rsrc_ref_lock(ctx);
+		spin_lock_irq(&ctx->rsrc_ref_lock);
 		list_add_tail(&rsrc_node->node, &ctx->rsrc_ref_list);
-		io_rsrc_ref_unlock(ctx);
+		spin_unlock_irq(&ctx->rsrc_ref_lock);
 
 		atomic_inc(&data_to_kill->refs);
 		percpu_ref_kill(&rsrc_node->refs);
@@ -7625,9 +7615,10 @@ static void io_rsrc_node_ref_zero(struct percpu_ref *ref)
 {
 	struct io_rsrc_node *node = container_of(ref, struct io_rsrc_node, refs);
 	struct io_ring_ctx *ctx = node->rsrc_data->ctx;
+	unsigned long flags;
 	bool first_add = false;
 
-	io_rsrc_ref_lock(ctx);
+	spin_lock_irqsave(&ctx->rsrc_ref_lock, flags);
 	node->done = true;
 
 	while (!list_empty(&ctx->rsrc_ref_list)) {
@@ -7639,7 +7630,7 @@ static void io_rsrc_node_ref_zero(struct percpu_ref *ref)
 		list_del(&node->node);
 		first_add |= llist_add(&node->llist, &ctx->rsrc_put_llist);
 	}
-	io_rsrc_ref_unlock(ctx);
+	spin_unlock_irqrestore(&ctx->rsrc_ref_lock, flags);
 
 	if (first_add)
 		mod_delayed_work(system_wq, &ctx->rsrc_put_work, HZ);
-- 
2.30.2



