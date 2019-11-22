Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 500701070F8
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728315AbfKVKgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:36:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:35114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727838AbfKVKgA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:36:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3D8720715;
        Fri, 22 Nov 2019 10:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574418959;
        bh=PSGBCmK1vQnLwrXnLndA1ipR72bdzcBxl+nx8cOli5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T0hy9d+f2tQ8h8y/nRtADb1xeJH3k22E8IEsukuAbwSXCE3RidTV0sZ0eRBOa+KCP
         Yp+zx8nRr2QaK7CtuqFcb8tL8kf2hMmq3G0jJV6Nt7moZyn1/nocdljLLpWlIX3jHr
         XOOahqsTR+JwexkNZcl6iV6BoPnVtIW4wzoCtkns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@fb.com>
Subject: [PATCH 4.4 109/159] block: introduce blk_rq_is_passthrough
Date:   Fri, 22 Nov 2019 11:28:20 +0100
Message-Id: <20191122100826.862750257@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100704.194776704@linuxfoundation.org>
References: <20191122100704.194776704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 57292b58ddb58689e8c3b4c6eadbef10d9ca44dd upstream.

This can be used to check for fs vs non-fs requests and basically
removes all knowledge of BLOCK_PC specific from the block layer,
as well as preparing for removing the cmd_type field in struct request.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@fb.com>
[only take the blkdev.h changes as we only want the function for backported
patches - gregkh]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/blkdev.h |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -199,6 +199,11 @@ struct request {
 	struct request *next_rq;
 };
 
+static inline bool blk_rq_is_passthrough(struct request *rq)
+{
+	return rq->cmd_type != REQ_TYPE_FS;
+}
+
 static inline unsigned short req_get_ioprio(struct request *req)
 {
 	return req->ioprio;
@@ -582,9 +587,10 @@ static inline void queue_flag_clear(unsi
 	((rq)->cmd_flags & (REQ_FAILFAST_DEV|REQ_FAILFAST_TRANSPORT| \
 			     REQ_FAILFAST_DRIVER))
 
-#define blk_account_rq(rq) \
-	(((rq)->cmd_flags & REQ_STARTED) && \
-	 ((rq)->cmd_type == REQ_TYPE_FS))
+static inline bool blk_account_rq(struct request *rq)
+{
+	return (rq->cmd_flags & REQ_STARTED) && !blk_rq_is_passthrough(rq);
+}
 
 #define blk_rq_cpu_valid(rq)	((rq)->cpu != -1)
 #define blk_bidi_rq(rq)		((rq)->next_rq != NULL)
@@ -645,7 +651,7 @@ static inline void blk_clear_rl_full(str
 
 static inline bool rq_mergeable(struct request *rq)
 {
-	if (rq->cmd_type != REQ_TYPE_FS)
+	if (blk_rq_is_passthrough(rq))
 		return false;
 
 	if (rq->cmd_flags & REQ_NOMERGE_FLAGS)
@@ -890,7 +896,7 @@ static inline unsigned int blk_rq_get_ma
 {
 	struct request_queue *q = rq->q;
 
-	if (unlikely(rq->cmd_type != REQ_TYPE_FS))
+	if (blk_rq_is_passthrough(rq))
 		return q->limits.max_hw_sectors;
 
 	if (!q->limits.chunk_sectors || (rq->cmd_flags & REQ_DISCARD))


