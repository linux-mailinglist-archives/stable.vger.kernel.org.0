Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6CB3BC058
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233279AbhGEPfZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:35:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232380AbhGEPeN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:34:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F389619CB;
        Mon,  5 Jul 2021 15:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499068;
        bh=GoeJ6QtsonK8GSez6muOYu6J939okEtS/8qcrZYi8OQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hf2u+KN2Wd1Do+3rmzdwfjEjGj7jPbLJYc8Y3kPqXw/h7sPA+Z5UdaTLTGoNTzTcm
         CVMpHeDDiaPNQvcL5VXLaetSXrLIYrpbUC1rA0KDm/gsdvc6jE/cEHI79BtI04TbjZ
         LTFKgCqsEbFMN/PFcPTtN0znGQwUzVncisLmQ7L0giX6ACHVgjfgmcKqBRao2xI8SQ
         bbx4fUWhQ3XFgEUkR1XdEk1lTdXIIYh9NsZZMqKIFq303kFwaHzz4mmcKALakZL1Rl
         j0athMCRgUrJWNGd6IXMyR9PO8sK0obtCh1cYOLdITw8uCYqt9AeQEkPV1hZM+I4P5
         qRKQkP+B6oBmA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Wang Shanker <shankerwangmiao@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 23/26] block: fix discard request merge
Date:   Mon,  5 Jul 2021 11:30:36 -0400
Message-Id: <20210705153039.1521781-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153039.1521781-1-sashal@kernel.org>
References: <20210705153039.1521781-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 2705dfb2094777e405e065105e307074af8965c1 ]

ll_new_hw_segment() is reached only in case of single range discard
merge, and we don't have max discard segment size limit actually, so
it is wrong to run the following check:

if (req->nr_phys_segments + nr_phys_segs > blk_rq_get_max_segments(req))

it may be always false since req->nr_phys_segments is initialized as
one, and bio's segment count is still 1, blk_rq_get_max_segments(reg)
is 1 too.

Fix the issue by not doing the check and bypassing the calculation of
discard request's nr_phys_segments.

Based on analysis from Wang Shanker.

Cc: Christoph Hellwig <hch@lst.de>
Reported-by: Wang Shanker <shankerwangmiao@gmail.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20210628023312.1903255-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-merge.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 03959bfe961c..4b022f0c49d2 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -571,10 +571,14 @@ static inline unsigned int blk_rq_get_max_segments(struct request *rq)
 static inline int ll_new_hw_segment(struct request *req, struct bio *bio,
 		unsigned int nr_phys_segs)
 {
-	if (req->nr_phys_segments + nr_phys_segs > blk_rq_get_max_segments(req))
+	if (blk_integrity_merge_bio(req->q, req, bio) == false)
 		goto no_merge;
 
-	if (blk_integrity_merge_bio(req->q, req, bio) == false)
+	/* discard request merge won't add new segment */
+	if (req_op(req) == REQ_OP_DISCARD)
+		return 1;
+
+	if (req->nr_phys_segments + nr_phys_segs > blk_rq_get_max_segments(req))
 		goto no_merge;
 
 	/*
-- 
2.30.2

