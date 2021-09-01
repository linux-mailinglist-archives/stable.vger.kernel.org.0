Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFA03FDC81
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345349AbhIAMvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:51:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346018AbhIAMtJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:49:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92D9861056;
        Wed,  1 Sep 2021 12:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630500066;
        bh=FmJrPgqahJSF3AYRo7ObxDBx//CyYZDRWcmP0H4tFRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rbtVmELx3FUN1mmTVS3I//q4Jjur7DPQHGC+UrbkHH8XnZfxs3H9Bpf27JxlzouOX
         VpRihvoH2HLrgZQmm662n0MN2//OM8ckF9eGLlyM9uKmIDtC49cs/77YRM01D/WEu5
         cNsJmIb6NiZm03pDudCrgBIHaUrCOHy0+ZTWR1Ko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        John Garry <john.garry@huawei.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 089/113] blk-mq: dont grab rqs refcount in blk_mq_check_expired()
Date:   Wed,  1 Sep 2021 14:28:44 +0200
Message-Id: <20210901122304.938183638@linuxfoundation.org>
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
index c732aa581124..6dfa572ac1fc 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -923,34 +923,14 @@ static bool blk_mq_check_expired(struct blk_mq_hw_ctx *hctx,
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



