Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBC1056FC89
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233355AbiGKJpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233705AbiGKJoo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:44:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4EF22B637;
        Mon, 11 Jul 2022 02:22:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99FA661227;
        Mon, 11 Jul 2022 09:22:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A034BC34115;
        Mon, 11 Jul 2022 09:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531333;
        bh=G9+MC9Bm/hCR6EhwkzzQkRijdDIMmmHji1Qt/+0XSs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ahqFBapuz8l0XFZWnoRnxjBfflH67YenBfoSqV7U0WRpNp8P0xqFTpbEdfT8pMj6
         pPBjOs3rq0XexWX2uw8p1arA/61vlb5AFfMF6Y4bk+xRh/opYoNZYjgqao1aUasZ6f
         rYivH3TyLX2+NHn2IvXcxh2006tweIf7upJe7Wk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 067/230] block: use bdev_get_queue() in bio.c
Date:   Mon, 11 Jul 2022 11:05:23 +0200
Message-Id: <20220711090605.978080465@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 3caee4634be68e755d2fb130962f1623661dbd5b ]

Convert bdev->bd_disk->queue to bdev_get_queue(), it's uses a cached
queue pointer and so is faster.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/85c36ea784d285a5075baa10049e6b59e15fb484.1634219547.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 8381c6690dd6..365bb6362669 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -910,7 +910,7 @@ EXPORT_SYMBOL(bio_add_pc_page);
 int bio_add_zone_append_page(struct bio *bio, struct page *page,
 			     unsigned int len, unsigned int offset)
 {
-	struct request_queue *q = bio->bi_bdev->bd_disk->queue;
+	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
 	bool same_page = false;
 
 	if (WARN_ON_ONCE(bio_op(bio) != REQ_OP_ZONE_APPEND))
@@ -1054,7 +1054,7 @@ static int bio_iov_bvec_set(struct bio *bio, struct iov_iter *iter)
 
 static int bio_iov_bvec_set_append(struct bio *bio, struct iov_iter *iter)
 {
-	struct request_queue *q = bio->bi_bdev->bd_disk->queue;
+	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
 	struct iov_iter i = *iter;
 
 	iov_iter_truncate(&i, queue_max_zone_append_sectors(q) << 9);
@@ -1132,7 +1132,7 @@ static int __bio_iov_append_get_pages(struct bio *bio, struct iov_iter *iter)
 {
 	unsigned short nr_pages = bio->bi_max_vecs - bio->bi_vcnt;
 	unsigned short entries_left = bio->bi_max_vecs - bio->bi_vcnt;
-	struct request_queue *q = bio->bi_bdev->bd_disk->queue;
+	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
 	unsigned int max_append_sectors = queue_max_zone_append_sectors(q);
 	struct bio_vec *bv = bio->bi_io_vec + bio->bi_vcnt;
 	struct page **pages = (struct page **)bv;
@@ -1471,10 +1471,10 @@ void bio_endio(struct bio *bio)
 		return;
 
 	if (bio->bi_bdev && bio_flagged(bio, BIO_TRACKED))
-		rq_qos_done_bio(bio->bi_bdev->bd_disk->queue, bio);
+		rq_qos_done_bio(bdev_get_queue(bio->bi_bdev), bio);
 
 	if (bio->bi_bdev && bio_flagged(bio, BIO_TRACE_COMPLETION)) {
-		trace_block_bio_complete(bio->bi_bdev->bd_disk->queue, bio);
+		trace_block_bio_complete(bdev_get_queue(bio->bi_bdev), bio);
 		bio_clear_flag(bio, BIO_TRACE_COMPLETION);
 	}
 
-- 
2.35.1



