Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF68C3C4940
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237602AbhGLGnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:43:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238647AbhGLGlj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:41:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 512F461008;
        Mon, 12 Jul 2021 06:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071920;
        bh=O24PZaQC9+WmVpAnHZLud64EGWmN8B/X3stNANXkEpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ITpRHXYDWTtJBeCrWv8+VsyrI5DyVGePVqa6uYjxyrlOidvccuIQh+dLRUf8IALCa
         Z8SzMjG87vwvi4t8XqkO86OfwWurghiK1yyLdDp/MMB1SoyUtaGcrw1wluh3qqNJVI
         hndO9RDXIJ/gVv+U3X6wbJ4MsJ96kz8//IQWsnLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 276/593] block: avoid double io accounting for flush request
Date:   Mon, 12 Jul 2021 08:07:16 +0200
Message-Id: <20210712060914.267900165@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 84da7acc3ba53af26f15c4b0ada446127b7a7836 ]

For flush request, rq->end_io() may be called two times, one is from
timeout handling(blk_mq_check_expired()), another is from normal
completion(__blk_mq_end_request()).

Move blk_account_io_flush() after flush_rq->ref drops to zero, so
io accounting can be done just once for flush request.

Fixes: b68663186577 ("block: add iostat counters for flush requests")
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: John Garry <john.garry@huawei.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20210511152236.763464-2-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-flush.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index fd5cee9f1a3b..7ee7e5e8905d 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -220,8 +220,6 @@ static void flush_end_io(struct request *flush_rq, blk_status_t error)
 	unsigned long flags = 0;
 	struct blk_flush_queue *fq = blk_get_flush_queue(q, flush_rq->mq_ctx);
 
-	blk_account_io_flush(flush_rq);
-
 	/* release the tag's ownership to the req cloned from */
 	spin_lock_irqsave(&fq->mq_flush_lock, flags);
 
@@ -231,6 +229,7 @@ static void flush_end_io(struct request *flush_rq, blk_status_t error)
 		return;
 	}
 
+	blk_account_io_flush(flush_rq);
 	/*
 	 * Flush request has to be marked as IDLE when it is really ended
 	 * because its .end_io() is called from timeout code path too for
-- 
2.30.2



