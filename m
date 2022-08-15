Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D804594E0B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346137AbiHPAeE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345858AbiHPAcI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:32:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 236AE186E9B;
        Mon, 15 Aug 2022 13:36:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE145B80EAD;
        Mon, 15 Aug 2022 20:36:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B6BC433C1;
        Mon, 15 Aug 2022 20:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595814;
        bh=3RDUYiYWlOXlYyzZASQdjSczNWXrOuHoi2nejWQy+qU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nPdu6sw6nsHKVeWsWbfz2rYaQKR0pEe8ytRzn4ORuD0PAqONFAzDXVCKPxeaGkT6e
         wTo3/21fHOeWQ6t5Ar0t6dTQsGe+DiGZEzTYsaAR/5IoPcD1H6RcAFUdz+nAiyH1sp
         y2sKnHj1qcdpkCBmaXBvfFSD9y5t03QOJYPjZXOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0883/1157] block/bio: remove duplicate append pages code
Date:   Mon, 15 Aug 2022 20:03:59 +0200
Message-Id: <20220815180514.742695834@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit c58c0074c54c2e2bb3bb0d5a4d8896bb660cc8bc ]

The getting pages setup for zone append and normal IO are identical. Use
common code for each.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220610195830.3574005-3-kbusch@fb.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c | 102 ++++++++++++++++++++++------------------------------
 1 file changed, 42 insertions(+), 60 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index d9ff51fc457e..ee5fe1bb015e 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1159,6 +1159,37 @@ static void bio_put_pages(struct page **pages, size_t size, size_t off)
 		put_page(pages[i]);
 }
 
+static int bio_iov_add_page(struct bio *bio, struct page *page,
+		unsigned int len, unsigned int offset)
+{
+	bool same_page = false;
+
+	if (!__bio_try_merge_page(bio, page, len, offset, &same_page)) {
+		if (WARN_ON_ONCE(bio_full(bio, len)))
+			return -EINVAL;
+		__bio_add_page(bio, page, len, offset);
+		return 0;
+	}
+
+	if (same_page)
+		put_page(page);
+	return 0;
+}
+
+static int bio_iov_add_zone_append_page(struct bio *bio, struct page *page,
+		unsigned int len, unsigned int offset)
+{
+	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
+	bool same_page = false;
+
+	if (bio_add_hw_page(q, bio, page, len, offset,
+			queue_max_zone_append_sectors(q), &same_page) != len)
+		return -EINVAL;
+	if (same_page)
+		put_page(page);
+	return 0;
+}
+
 #define PAGE_PTRS_PER_BVEC     (sizeof(struct bio_vec) / sizeof(struct page *))
 
 /**
@@ -1177,7 +1208,6 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 	unsigned short entries_left = bio->bi_max_vecs - bio->bi_vcnt;
 	struct bio_vec *bv = bio->bi_io_vec + bio->bi_vcnt;
 	struct page **pages = (struct page **)bv;
-	bool same_page = false;
 	ssize_t size, left;
 	unsigned len, i;
 	size_t offset;
@@ -1186,7 +1216,7 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 	 * Move page array up in the allocated memory for the bio vecs as far as
 	 * possible so that we can start filling biovecs from the beginning
 	 * without overwriting the temporary page array.
-	*/
+	 */
 	BUILD_BUG_ON(PAGE_PTRS_PER_BVEC < 2);
 	pages += entries_left * (PAGE_PTRS_PER_BVEC - 1);
 
@@ -1196,18 +1226,18 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 
 	for (left = size, i = 0; left > 0; left -= len, i++) {
 		struct page *page = pages[i];
+		int ret;
 
 		len = min_t(size_t, PAGE_SIZE - offset, left);
+		if (bio_op(bio) == REQ_OP_ZONE_APPEND)
+			ret = bio_iov_add_zone_append_page(bio, page, len,
+					offset);
+		else
+			ret = bio_iov_add_page(bio, page, len, offset);
 
-		if (__bio_try_merge_page(bio, page, len, offset, &same_page)) {
-			if (same_page)
-				put_page(page);
-		} else {
-			if (WARN_ON_ONCE(bio_full(bio, len))) {
-				bio_put_pages(pages + i, left, offset);
-				return -EINVAL;
-			}
-			__bio_add_page(bio, page, len, offset);
+		if (ret) {
+			bio_put_pages(pages + i, left, offset);
+			return ret;
 		}
 		offset = 0;
 	}
@@ -1216,51 +1246,6 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 	return 0;
 }
 
-static int __bio_iov_append_get_pages(struct bio *bio, struct iov_iter *iter)
-{
-	unsigned short nr_pages = bio->bi_max_vecs - bio->bi_vcnt;
-	unsigned short entries_left = bio->bi_max_vecs - bio->bi_vcnt;
-	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
-	unsigned int max_append_sectors = queue_max_zone_append_sectors(q);
-	struct bio_vec *bv = bio->bi_io_vec + bio->bi_vcnt;
-	struct page **pages = (struct page **)bv;
-	ssize_t size, left;
-	unsigned len, i;
-	size_t offset;
-	int ret = 0;
-
-	/*
-	 * Move page array up in the allocated memory for the bio vecs as far as
-	 * possible so that we can start filling biovecs from the beginning
-	 * without overwriting the temporary page array.
-	 */
-	BUILD_BUG_ON(PAGE_PTRS_PER_BVEC < 2);
-	pages += entries_left * (PAGE_PTRS_PER_BVEC - 1);
-
-	size = iov_iter_get_pages(iter, pages, LONG_MAX, nr_pages, &offset);
-	if (unlikely(size <= 0))
-		return size ? size : -EFAULT;
-
-	for (left = size, i = 0; left > 0; left -= len, i++) {
-		struct page *page = pages[i];
-		bool same_page = false;
-
-		len = min_t(size_t, PAGE_SIZE - offset, left);
-		if (bio_add_hw_page(q, bio, page, len, offset,
-				max_append_sectors, &same_page) != len) {
-			bio_put_pages(pages + i, left, offset);
-			ret = -EINVAL;
-			break;
-		}
-		if (same_page)
-			put_page(page);
-		offset = 0;
-	}
-
-	iov_iter_advance(iter, size - left);
-	return ret;
-}
-
 /**
  * bio_iov_iter_get_pages - add user or kernel pages to a bio
  * @bio: bio to add pages to
@@ -1295,10 +1280,7 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 	}
 
 	do {
-		if (bio_op(bio) == REQ_OP_ZONE_APPEND)
-			ret = __bio_iov_append_get_pages(bio, iter);
-		else
-			ret = __bio_iov_iter_get_pages(bio, iter);
+		ret = __bio_iov_iter_get_pages(bio, iter);
 	} while (!ret && iov_iter_count(iter) && !bio_full(bio, 0));
 
 	/* don't account direct I/O as memory stall */
-- 
2.35.1



