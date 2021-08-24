Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8EA63F63A6
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233998AbhHXQ5i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:57:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233963AbhHXQ5R (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:57:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09955613D5;
        Tue, 24 Aug 2021 16:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824193;
        bh=B7Mc6+bu3nOA9xNACCyDGH25quCXPgXomeh32na7dbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h2ff8oK9nlxOfCFkkg5UJALrCaq5mAcFTDif77gCt62uaLYbfhBGUkvJijzkrH9Oj
         xKwKpYizJC+sJ6CK0OZBVRQMjd9D48uK1i3yz5kIIA7Z+gAj7XZoML7erlzgDcs5WH
         tuz/gf/vNm54oBQcPH2ztFdbiWRTFbTKoKIGUTafF07semuar4gKXsMYuz88F0O4Pp
         70x2YTfb0Mz+vROHx08Hzj0Hb6fJFOmoH8WsG/ZPr6lAHxXpbEkyBZgtx0xO0FaOOs
         /iq2itoaXotsbivtgfhybjNPVuqnaYPMty8iwJu+O0YcdKlpTw1MYpLwys3Ff85L3K
         ulauY+eG3m0LA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincent Fu <vincent.fu@samsung.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 025/127] kyber: make trace_block_rq call consistent with documentation
Date:   Tue, 24 Aug 2021 12:54:25 -0400
Message-Id: <20210824165607.709387-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
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

