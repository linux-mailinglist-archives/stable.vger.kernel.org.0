Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4A03FDB98
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343671AbhIAMma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:42:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:42766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344782AbhIAMkm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:40:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A131611C2;
        Wed,  1 Sep 2021 12:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499814;
        bh=uhKcURRTaR98vy+GE7WWHU6+2pr5t+cRJvCfXo7cuEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z+LgHmQhtyJv9sXGLGmVgN/YieU8bUYO+IHVLR7WEHd5IG2VO3vNwTRobOP5vxU5/
         XOVf7lmG+wTwWx5kLOLoIdRhSK/v5EyqHYWT0gg1xaliJUeKDnyI0KchVULESzQXve
         wPB68sUJVdQOthCZONGW2Tna+JE5DTdGDU7MG6Iw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        John Garry <john.garry@huawei.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/103] blk-mq: dont grab rqs refcount in blk_mq_check_expired()
Date:   Wed,  1 Sep 2021 14:28:16 +0200
Message-Id: <20210901122302.793884512@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit c797b40ccc340b8a66f7a7842aecc90bf749f087 ]

Inside blk_mq_queue_tag_busy_iter() we already grabbed request's
refcount before calling ->fn(), so needn't to grab it one more time
in blk_mq_check_expired().

Meantime remove extra request expire check in blk_mq_check_expired().

Cc: Keith Busch <kbusch@kernel.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.garry@huawei.com>
Link: https://lore.kernel.org/r/20210811155202.629575-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 30 +++++-------------------------
 1 file changed, 5 insertions(+), 25 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index a368eb6dc647..044d0e3a15ad 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -941,34 +941,14 @@ static bool blk_mq_check_expired(struct blk_mq_hw_ctx *hctx,
 	unsigned long *next = priv;
 
 	/*
-	 * Just do a quick check if it is expired before locking the request in
-	 * so we're not unnecessarilly synchronizing across CPUs.
-	 */
-	if (!blk_mq_req_expired(rq, next))
-		return true;
-
-	/*
-	 * We have reason to believe the request may be expired. Take a
-	 * reference on the request to lock this request lifetime into its
-	 * currently allocated context to prevent it from being reallocated in
-	 * the event the completion by-passes this timeout handler.
-	 *
-	 * If the reference was already released, then the driver beat the
-	 * timeout handler to posting a natural completion.
-	 */
-	if (!refcount_inc_not_zero(&rq->ref))
-		return true;
-
-	/*
-	 * The request is now locked and cannot be reallocated underneath the
-	 * timeout handler's processing. Re-verify this exact request is truly
-	 * expired; if it is not expired, then the request was completed and
-	 * reallocated as a new request.
+	 * blk_mq_queue_tag_busy_iter() has locked the request, so it cannot
+	 * be reallocated underneath the timeout handler's processing, then
+	 * the expire check is reliable. If the request is not expired, then
+	 * it was completed and reallocated as a new request after returning
+	 * from blk_mq_check_expired().
 	 */
 	if (blk_mq_req_expired(rq, next))
 		blk_mq_rq_timed_out(rq, reserved);
-
-	blk_mq_put_rq_ref(rq);
 	return true;
 }
 
-- 
2.30.2



