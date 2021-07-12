Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2583C4CD6
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241868AbhGLHJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:09:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242476AbhGLHGw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:06:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9500161249;
        Mon, 12 Jul 2021 07:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073444;
        bh=QWCbIG7iV9V4z4yd1CkxChUNr4DihwCdfMDmJ+sYQts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ytGkhQ77KuqtaJ8CQSrbj4CJ/yeWQXWno86/GJfTpk2fERkN+jPcWCPopiaBEosW3
         0O1Axw5rpchN0Zq8W3VLf5B7wXey7ZE16hZ52sCfpvd3yUrUrzf6BAmL0CGn0vJMhC
         CeqQhfxYnZrklSG1RT9VMn4UqjQ7citw93AVB/VE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Wang Shanker <shankerwangmiao@gmail.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 243/700] block: fix discard request merge
Date:   Mon, 12 Jul 2021 08:05:26 +0200
Message-Id: <20210712061001.329283632@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 4d97fb6dd226..bcdff1879c34 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -559,10 +559,14 @@ static inline unsigned int blk_rq_get_max_segments(struct request *rq)
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



