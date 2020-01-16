Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2356D13F6D5
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388289AbgAPTHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:07:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:52058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388049AbgAPRBP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:01:15 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C806520730;
        Thu, 16 Jan 2020 17:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194075;
        bh=VH6Ot6iZUhwLCZjJgw6dRkJxF8WjyXnJUUWjVLlB6WM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U1fG0Y0vF60f94ebjswDzcvAHvcknAN8jiF0vHmCB/Qz6y5w9WpZPi0tLE9GMcj6u
         40ny+6XWbBIfXDzcZT+aDAi2tICToAltw6xgx/ZeNOzcIE9YDWXnZyw669V9nv77XK
         N8Xdr+SNe7mlGfzvICElV1jo6wCzr+csG9uZOhyY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 182/671] block: don't use bio->bi_vcnt to figure out segment number
Date:   Thu, 16 Jan 2020 11:51:31 -0500
Message-Id: <20200116165940.10720-65-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 1a67356e9a4829da2935dd338630a550c59c8489 ]

It is wrong to use bio->bi_vcnt to figure out how many segments
there are in the bio even though CLONED flag isn't set on this bio,
because this bio may be splitted or advanced.

So always use bio_segments() in blk_recount_segments(), and it shouldn't
cause any performance loss now because the physical segment number is figured
out in blk_queue_split() and BIO_SEG_VALID is set meantime since
bdced438acd83ad83a6c ("block: setup bi_phys_segments after splitting").

Reviewed-by: Omar Sandoval <osandov@fb.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Fixes: 76d8137a3113 ("blk-merge: recaculate segment if it isn't less than max segments")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-merge.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 2776ee6c5c3d..7efa8c3e2b72 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -309,13 +309,7 @@ void blk_recalc_rq_segments(struct request *rq)
 
 void blk_recount_segments(struct request_queue *q, struct bio *bio)
 {
-	unsigned short seg_cnt;
-
-	/* estimate segment number by bi_vcnt for non-cloned bio */
-	if (bio_flagged(bio, BIO_CLONED))
-		seg_cnt = bio_segments(bio);
-	else
-		seg_cnt = bio->bi_vcnt;
+	unsigned short seg_cnt = bio_segments(bio);
 
 	if (test_bit(QUEUE_FLAG_NO_SG_MERGE, &q->queue_flags) &&
 			(seg_cnt < queue_max_segments(q)))
-- 
2.20.1

