Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 975DA3EE110
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 02:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235922AbhHQAg2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 20:36:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:35296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235902AbhHQAgW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 20:36:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6226561029;
        Tue, 17 Aug 2021 00:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629160550;
        bh=nG5tCVdorJJwp9SvrVL+Jyv1RT1qayc48nsjUcormKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dl8q6B/B/kehu+tE+nycHuSlVYyY2DnfBm813oxI97+wd+BKZjVud4X5zLLCUYtvi
         wC7cGJ52GmvfcwcYgcP60ccpeqPr6euGbMuju5taonqOgbRAgAZzaM1YiPvTde/fbH
         c7J+Rh3+rXTIpRgwdebwc4WZv3ZZp/90u8yrzTQfhvvrc6jf2G5vvLeyWmXnYFDF7r
         iHnICqytLzl6e/WoDqmOxxoW1YvGTfMWzHlCBC0E+XQTKlCN0chuy2wbNdHFpU4YsP
         kcYlagYlO0cEtJonzEs0mwSrtTvH9rBujUTFioUrEiEfH1vhpZ9dqkPSUn1OYwmEaj
         nQeij9wlA22Zg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Nadav Amit <nadav.amit@gmail.com>,
        Sasha Levin <sashal@kernel.org>, io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 09/12] io_uring: rsrc ref lock needs to be IRQ safe
Date:   Mon, 16 Aug 2021 20:35:33 -0400
Message-Id: <20210817003536.83063-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210817003536.83063-1-sashal@kernel.org>
References: <20210817003536.83063-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 32f3df13a812..29bdf6fa0f83 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7099,16 +7099,6 @@ static void io_free_file_tables(struct io_file_table *table, unsigned nr_files)
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
@@ -7125,9 +7115,9 @@ static void io_rsrc_node_switch(struct io_ring_ctx *ctx,
 		struct io_rsrc_node *rsrc_node = ctx->rsrc_node;
 
 		rsrc_node->rsrc_data = data_to_kill;
-		io_rsrc_ref_lock(ctx);
+		spin_lock_irq(&ctx->rsrc_ref_lock);
 		list_add_tail(&rsrc_node->node, &ctx->rsrc_ref_list);
-		io_rsrc_ref_unlock(ctx);
+		spin_unlock_irq(&ctx->rsrc_ref_lock);
 
 		atomic_inc(&data_to_kill->refs);
 		percpu_ref_kill(&rsrc_node->refs);
@@ -7617,9 +7607,10 @@ static void io_rsrc_node_ref_zero(struct percpu_ref *ref)
 {
 	struct io_rsrc_node *node = container_of(ref, struct io_rsrc_node, refs);
 	struct io_ring_ctx *ctx = node->rsrc_data->ctx;
+	unsigned long flags;
 	bool first_add = false;
 
-	io_rsrc_ref_lock(ctx);
+	spin_lock_irqsave(&ctx->rsrc_ref_lock, flags);
 	node->done = true;
 
 	while (!list_empty(&ctx->rsrc_ref_list)) {
@@ -7631,7 +7622,7 @@ static void io_rsrc_node_ref_zero(struct percpu_ref *ref)
 		list_del(&node->node);
 		first_add |= llist_add(&node->llist, &ctx->rsrc_put_llist);
 	}
-	io_rsrc_ref_unlock(ctx);
+	spin_unlock_irqrestore(&ctx->rsrc_ref_lock, flags);
 
 	if (first_add)
 		mod_delayed_work(system_wq, &ctx->rsrc_put_work, HZ);
-- 
2.30.2

