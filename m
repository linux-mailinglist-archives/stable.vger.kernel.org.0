Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 048AC148052
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731498AbgAXLJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:09:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:45612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731494AbgAXLJz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:09:55 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E61F920708;
        Fri, 24 Jan 2020 11:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864194;
        bh=UUXvP3SbIS91PkMmRcOiNxQ0e2u4Yh//JW7hyW+tfZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CSqGqDkhGPJ6MKGqEDExo8JuSVDOvfkL/3+wOFRlTbnK3b9Uni/ogaB2Z4btT9ZHe
         zW9vSbezroQaQgZhtTVqMX5Aywt+o0kQgAF0GTyvZW/J7qVo54pa2E6Oki+ImOE/ba
         pmv0fP9pJEOql9piypts0Gj45jndluHz/S16gtG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Omar Sandoval <osandov@fb.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 198/639] block: dont use bio->bi_vcnt to figure out segment number
Date:   Fri, 24 Jan 2020 10:26:08 +0100
Message-Id: <20200124093111.848553382@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 2776ee6c5c3dc..7efa8c3e2b727 100644
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



