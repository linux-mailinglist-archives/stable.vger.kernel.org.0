Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C392F3E5CF5
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 16:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242489AbhHJOQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 10:16:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:53076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242450AbhHJOP7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 10:15:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F040F60F41;
        Tue, 10 Aug 2021 14:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628604937;
        bh=B7Mc6+bu3nOA9xNACCyDGH25quCXPgXomeh32na7dbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iExtOShjto0dM1rWNczTFtib+JEejASTOY5JY+TQRg4nZd1pooQHY8phxPCFJq/zz
         3OMrWRfEpXBbhy0yP7xtkXpPBWde4HlOODPJTpZ33wK3Er/7lxmGucMimAQfuTPoVk
         cQg4daV7ITlJtwz/cOEBj+/okgQ9+E7CKVpkqakJf5mM9L1Oh2QKAhMkNAU4fWVuQV
         TxIrUulTIONMHA3b2vMMtj/r3XMZNeWkv4kALfdtpofBEZAgLHMR/0xs91UO1DJlZN
         SpRPEiIxhjC+ia2tIEawT6qJGfYgUm45iSB1F5Wjtx7g1RDNrpaFXjddL8oQFIXgDK
         lpfi3/++bU1jg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincent Fu <vincent.fu@samsung.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 24/24] kyber: make trace_block_rq call consistent with documentation
Date:   Tue, 10 Aug 2021 10:15:05 -0400
Message-Id: <20210810141505.3117318-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810141505.3117318-1-sashal@kernel.org>
References: <20210810141505.3117318-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Fu <vincent.fu@samsung.com>

[ Upstream commit fb7b9b0231ba8f77587c23f5257a4fdb6df1219e ]

The kyber ioscheduler calls trace_block_rq_insert() *after* the request
is added to the queue but the documentation for trace_block_rq_insert()
says that the call should be made *before* the request is added to the
queue.  Move the tracepoint for the kyber ioscheduler so that it is
consistent with the documentation.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
Link: https://lore.kernel.org/r/20210804194913.10497-1-vincent.fu@samsung.com
Reviewed by: Adam Manzanares <a.manzanares@samsung.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/kyber-iosched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/kyber-iosched.c b/block/kyber-iosched.c
index 81e3279ecd57..15a8be57203d 100644
--- a/block/kyber-iosched.c
+++ b/block/kyber-iosched.c
@@ -596,13 +596,13 @@ static void kyber_insert_requests(struct blk_mq_hw_ctx *hctx,
 		struct list_head *head = &kcq->rq_list[sched_domain];
 
 		spin_lock(&kcq->lock);
+		trace_block_rq_insert(rq);
 		if (at_head)
 			list_move(&rq->queuelist, head);
 		else
 			list_move_tail(&rq->queuelist, head);
 		sbitmap_set_bit(&khd->kcq_map[sched_domain],
 				rq->mq_ctx->index_hw[hctx->type]);
-		trace_block_rq_insert(rq);
 		spin_unlock(&kcq->lock);
 	}
 }
-- 
2.30.2

