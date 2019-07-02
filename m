Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C43965CAEE
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728649AbfGBIJe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:09:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728671AbfGBIJd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:09:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A824A21479;
        Tue,  2 Jul 2019 08:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054972;
        bh=Kc0XjGKfQdfmxSYJmjju9/pGuuC4ceI9CF999iOOnW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UQcq+gCpAkoeZ7loTWxgbBA8HqSfIdloOOviN+fDvNmDoQa/iwVKa1d00ye0LFcF2
         sWn90B7hm/gs5icl3XzBHFYscwfQ6i9yJDmU176qQk/lEGraCBNGh1TnYuu5vu/DvO
         thul8EoHRfxCyJaaF/MauXUxkMjIMt9BR8zTRqn0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Martin Wilck <mwilck@suse.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 07/43] block: bio_iov_iter_get_pages: pin more pages for multi-segment IOs
Date:   Tue,  2 Jul 2019 10:01:47 +0200
Message-Id: <20190702080124.234196405@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080123.904399496@linuxfoundation.org>
References: <20190702080123.904399496@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 17d51b10d7773e4618bcac64648f30f12d4078fb ]

bio_iov_iter_get_pages() currently only adds pages for the next non-zero
segment from the iov_iter to the bio. That's suboptimal for callers,
which typically try to pin as many pages as fit into the bio. This patch
converts the current bio_iov_iter_get_pages() into a static helper, and
introduces a new helper that allocates as many pages as

 1) fit into the bio,
 2) are present in the iov_iter,
 3) and can be pinned by MM.

Error is returned only if zero pages could be pinned. Because of 3), a
zero return value doesn't necessarily mean all pages have been pinned.
Callers that have to pin every page in the iov_iter must still call this
function in a loop (this is currently the case).

This change matters most for __blkdev_direct_IO_simple(), which calls
bio_iov_iter_get_pages() only once. If it obtains less pages than
requested, it returns a "short write" or "short read", and
__generic_file_write_iter() falls back to buffered writes, which may
lead to data corruption.

Fixes: 72ecad22d9f1 ("block: support a full bio worth of IO for simplified bdev direct-io")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c | 35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index c1386ce2c014..1384f9790882 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -902,14 +902,16 @@ int bio_add_page(struct bio *bio, struct page *page,
 EXPORT_SYMBOL(bio_add_page);
 
 /**
- * bio_iov_iter_get_pages - pin user or kernel pages and add them to a bio
+ * __bio_iov_iter_get_pages - pin user or kernel pages and add them to a bio
  * @bio: bio to add pages to
  * @iter: iov iterator describing the region to be mapped
  *
- * Pins as many pages from *iter and appends them to @bio's bvec array. The
+ * Pins pages from *iter and appends them to @bio's bvec array. The
  * pages will have to be released using put_page() when done.
+ * For multi-segment *iter, this function only adds pages from the
+ * the next non-empty segment of the iov iterator.
  */
-int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
+static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 {
 	unsigned short nr_pages = bio->bi_max_vecs - bio->bi_vcnt, idx;
 	struct bio_vec *bv = bio->bi_io_vec + bio->bi_vcnt;
@@ -946,6 +948,33 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 	iov_iter_advance(iter, size);
 	return 0;
 }
+
+/**
+ * bio_iov_iter_get_pages - pin user or kernel pages and add them to a bio
+ * @bio: bio to add pages to
+ * @iter: iov iterator describing the region to be mapped
+ *
+ * Pins pages from *iter and appends them to @bio's bvec array. The
+ * pages will have to be released using put_page() when done.
+ * The function tries, but does not guarantee, to pin as many pages as
+ * fit into the bio, or are requested in *iter, whatever is smaller.
+ * If MM encounters an error pinning the requested pages, it stops.
+ * Error is returned only if 0 pages could be pinned.
+ */
+int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
+{
+	unsigned short orig_vcnt = bio->bi_vcnt;
+
+	do {
+		int ret = __bio_iov_iter_get_pages(bio, iter);
+
+		if (unlikely(ret))
+			return bio->bi_vcnt > orig_vcnt ? 0 : ret;
+
+	} while (iov_iter_count(iter) && !bio_full(bio));
+
+	return 0;
+}
 EXPORT_SYMBOL_GPL(bio_iov_iter_get_pages);
 
 struct submit_bio_ret {
-- 
2.20.1



