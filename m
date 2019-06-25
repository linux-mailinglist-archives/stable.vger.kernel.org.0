Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7139555165
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 16:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728155AbfFYORb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 10:17:31 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:39817 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbfFYORb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 10:17:31 -0400
Received: by mail-ed1-f65.google.com with SMTP id m10so27418592edv.6
        for <stable@vger.kernel.org>; Tue, 25 Jun 2019 07:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kJcY1rVl8IOUF7Dm9k4R6BblGaYfSWGH1jh1VAhQ7tM=;
        b=p4f5IlpKge58HcPh/KAX0M9c1UENA9aMJZpVIn1eA8cn1wKjLPdwuWYhGda0Hq5lR7
         UP5UxpZCK3/gcf8FzQtB3qFyDfCc9Cmsll3Z7Aug7caXigavR3MAogu3qKGCIbvK0wLJ
         HH4HeyYpDFHbT+dOcYVnoRLmfp64/vV5dT7mxZMPksBQyADc/kJMqtYhrdBde2ahGgMU
         81HZ8tX8qNtfOUttuxPNAWznBCJ36Him9nvT2icBbz77imxF0lZe6E163r4NINP28shL
         lm4jEKoCM8+UhB7t6CRZ9qn79PRVa4TMg183S2x2iRK5oZmGuA40jYd+5OZqQnrEe0yq
         XqUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kJcY1rVl8IOUF7Dm9k4R6BblGaYfSWGH1jh1VAhQ7tM=;
        b=R9zg2wc6K529DszvG9kIamoJt5WAT79CoBGfyTON2NgsdczqrLqpw0J/AVp4zjwClb
         zwcvxahBYxzi2MT0zia6QZBxaQVUOSv8D0bgr3WJJGw6tMQ/g9BJMM1UzZRk+e9vi72A
         aLRJ1MvaGUGU5P9fpmUHBLSYLxdLYLBu1LZ4wbPFNuB7Hf/b03Q6hLb32QU2EHwht3pb
         Eo4/v6HMI4w4n7OuY5/O4xTLwri5I7yMePT2LbydAo54zN4Lb7c5qn1zIl1tEtUbKqF4
         BcP5WHd1N+yONNWTcfdZWvk1o/J/8f2nopMPhZmEmEAtyRjcT87P27ayMUGvW44oxayQ
         mxTA==
X-Gm-Message-State: APjAAAUKgJw7a3Y3778xLjSZGI7y3nGYD2NT/WaZxDoVaONrix1NBxmy
        K0W+Bv0+gu9tW0dVMkmsQ2s=
X-Google-Smtp-Source: APXvYqz9GbJosLDYGaf5N572jrRuo6xsSUWM1C1a9OGPKyPC3gk7Fr/pfDO3jkNMVoTIiHVjmVjSew==
X-Received: by 2002:a50:b7a7:: with SMTP id h36mr55976631ede.234.1561472249495;
        Tue, 25 Jun 2019 07:17:29 -0700 (PDT)
Received: from jwang-Latitude-5491.pb.local ([62.217.45.26])
        by smtp.gmail.com with ESMTPSA id u9sm4917158edm.71.2019.06.25.07.17.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 07:17:28 -0700 (PDT)
From:   Jack Wang <jinpuwang@gmail.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Cc:     Martin Wilck <mwilck@suse.com>, Jens Axboe <axboe@kernel.dk>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [stable-4.14 2/2] block: bio_iov_iter_get_pages: pin more pages for multi-segment IOs
Date:   Tue, 25 Jun 2019 16:17:25 +0200
Message-Id: <20190625141725.26220-3-jinpuwang@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190625141725.26220-1-jinpuwang@gmail.com>
References: <20190625141725.26220-1-jinpuwang@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

commit 17d51b10d7773e4618bcac64648f30f12d4078fb upstream

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
[jwang: cherry-picked to 4.14]
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
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
2.17.1

