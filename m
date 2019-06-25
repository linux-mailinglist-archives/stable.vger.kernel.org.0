Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3374B55164
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 16:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729578AbfFYORa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 10:17:30 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:45471 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728155AbfFYORa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 10:17:30 -0400
Received: by mail-ed1-f65.google.com with SMTP id a14so27365021edv.12
        for <stable@vger.kernel.org>; Tue, 25 Jun 2019 07:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sNHmRCD+UAc5EYjvh0YBVXM4h6q6UUpf8LEYH6HFyw4=;
        b=u6QYXffvr8nxrIqPa6sI6WwZ+rlYPSMRiP43c1KLFa0oASxj0LvW2jB8kn4i8kEO4F
         KuphPqee39DJVpRypU+dimaaVX5gl2puAxdwcPf+gYygw+M2pNpHd/qjbnRYVckBSWFU
         d3RC3NKrtCsyAi3jzrmPOc3OIdc0aHuMOzBIisMq1LkTezGEfOa2XTabaDa4UTMf10s8
         NBA4UDqtNrGz3+90HvrKi0DweecP7qS5g0Cjpiym0ntEDGrtRho6sZEAUP/5Gt+kvqsq
         jTV9UmX3E9sutbgpiasEOEhFRnoFZO4pis1r2MAl6VN1K1CNiCmKIfUXloXbJdM4LUTP
         xuew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sNHmRCD+UAc5EYjvh0YBVXM4h6q6UUpf8LEYH6HFyw4=;
        b=dOHv/IEzNPzPgoTvTMtFLgtJpmB6V33uOvgOkaERQRVWQP9bW8GA4ZjpaLkkyydETQ
         fqkxnb7rfB4wpBOraGjzN/aKFpn5oPVN1bCuUZ4y2yeLcayzPWDlghBh6KSR8ekp+r8x
         NE8cK6AwA6j77OVbyeXeTkLMR5GO5kpQdukt6unqxFmRM7HqtXFLHJz/0/iCZ+9+DBeb
         CUovsRCc7OTiIPCTx+LNYritDRnLHBqFPo7K2ZSSIECCXjctDAqCVid3ersU/cM5SNMz
         gSt1Xg0tNf0O4+jkcmv1aTyD2YICU/yrs1IMoL4WNuQAbJkBZR4HbZW7ScbaPDw19rgq
         Ke6g==
X-Gm-Message-State: APjAAAWhEhOBJwoRzsUfWu6elK1TWXcIU+AVZ+V3REBp1DhzGNlR+kny
        vjFcFOiyvjcF52KI15/C12g=
X-Google-Smtp-Source: APXvYqyb20Z1tKeE76HpagZKoUz757p2l31NHKoJsEJwieuWWm468o1W9UFVFjnbzrCBT536ST7jKg==
X-Received: by 2002:aa7:c99a:: with SMTP id c26mr76942944edt.118.1561472248347;
        Tue, 25 Jun 2019 07:17:28 -0700 (PDT)
Received: from jwang-Latitude-5491.pb.local ([62.217.45.26])
        by smtp.gmail.com with ESMTPSA id u9sm4917158edm.71.2019.06.25.07.17.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 07:17:27 -0700 (PDT)
From:   Jack Wang <jinpuwang@gmail.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [stable-4.14 1/2] block: add a lower-level bio_add_page interface
Date:   Tue, 25 Jun 2019 16:17:24 +0200
Message-Id: <20190625141725.26220-2-jinpuwang@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190625141725.26220-1-jinpuwang@gmail.com>
References: <20190625141725.26220-1-jinpuwang@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 0aa69fd32a5f766e997ca8ab4723c5a1146efa8b upstream

For the upcoming removal of buffer heads in XFS we need to keep track of
the number of outstanding writeback requests per page.  For this we need
to know if bio_add_page merged a region with the previous bvec or not.
Instead of adding additional arguments this refactors bio_add_page to
be implemented using three lower level helpers which users like XFS can
use directly if they care about the merge decisions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
[jwang: cherry pick to 4.14, requred for next patch to build]
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 block/bio.c         | 96 +++++++++++++++++++++++++++++----------------
 include/linux/bio.h |  9 +++++
 2 files changed, 72 insertions(+), 33 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index d01ab919b313..c1386ce2c014 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -773,7 +773,7 @@ int bio_add_pc_page(struct request_queue *q, struct bio *bio, struct page
 			return 0;
 	}
 
-	if (bio->bi_vcnt >= bio->bi_max_vecs)
+	if (bio_full(bio))
 		return 0;
 
 	/*
@@ -821,52 +821,82 @@ int bio_add_pc_page(struct request_queue *q, struct bio *bio, struct page
 EXPORT_SYMBOL(bio_add_pc_page);
 
 /**
- *	bio_add_page	-	attempt to add page to bio
- *	@bio: destination bio
- *	@page: page to add
- *	@len: vec entry length
- *	@offset: vec entry offset
+ * __bio_try_merge_page - try appending data to an existing bvec.
+ * @bio: destination bio
+ * @page: page to add
+ * @len: length of the data to add
+ * @off: offset of the data in @page
  *
- *	Attempt to add a page to the bio_vec maplist. This will only fail
- *	if either bio->bi_vcnt == bio->bi_max_vecs or it's a cloned bio.
+ * Try to add the data at @page + @off to the last bvec of @bio.  This is a
+ * a useful optimisation for file systems with a block size smaller than the
+ * page size.
+ *
+ * Return %true on success or %false on failure.
  */
-int bio_add_page(struct bio *bio, struct page *page,
-		 unsigned int len, unsigned int offset)
+bool __bio_try_merge_page(struct bio *bio, struct page *page,
+		unsigned int len, unsigned int off)
 {
-	struct bio_vec *bv;
-
-	/*
-	 * cloned bio must not modify vec list
-	 */
 	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
-		return 0;
+		return false;
 
-	/*
-	 * For filesystems with a blocksize smaller than the pagesize
-	 * we will often be called with the same page as last time and
-	 * a consecutive offset.  Optimize this special case.
-	 */
 	if (bio->bi_vcnt > 0) {
-		bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
+		struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
 
-		if (page == bv->bv_page &&
-		    offset == bv->bv_offset + bv->bv_len) {
+		if (page == bv->bv_page && off == bv->bv_offset + bv->bv_len) {
 			bv->bv_len += len;
-			goto done;
+			bio->bi_iter.bi_size += len;
+			return true;
 		}
 	}
+	return false;
+}
+EXPORT_SYMBOL_GPL(__bio_try_merge_page);
 
-	if (bio->bi_vcnt >= bio->bi_max_vecs)
-		return 0;
+/**
+ * __bio_add_page - add page to a bio in a new segment
+ * @bio: destination bio
+ * @page: page to add
+ * @len: length of the data to add
+ * @off: offset of the data in @page
+ *
+ * Add the data at @page + @off to @bio as a new bvec.  The caller must ensure
+ * that @bio has space for another bvec.
+ */
+void __bio_add_page(struct bio *bio, struct page *page,
+		unsigned int len, unsigned int off)
+{
+	struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt];
 
-	bv		= &bio->bi_io_vec[bio->bi_vcnt];
-	bv->bv_page	= page;
-	bv->bv_len	= len;
-	bv->bv_offset	= offset;
+	WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED));
+	WARN_ON_ONCE(bio_full(bio));
+
+	bv->bv_page = page;
+	bv->bv_offset = off;
+	bv->bv_len = len;
 
-	bio->bi_vcnt++;
-done:
 	bio->bi_iter.bi_size += len;
+	bio->bi_vcnt++;
+}
+EXPORT_SYMBOL_GPL(__bio_add_page);
+
+/**
+ *	bio_add_page	-	attempt to add page to bio
+ *	@bio: destination bio
+ *	@page: page to add
+ *	@len: vec entry length
+ *	@offset: vec entry offset
+ *
+ *	Attempt to add a page to the bio_vec maplist. This will only fail
+ *	if either bio->bi_vcnt == bio->bi_max_vecs or it's a cloned bio.
+ */
+int bio_add_page(struct bio *bio, struct page *page,
+		 unsigned int len, unsigned int offset)
+{
+	if (!__bio_try_merge_page(bio, page, len, offset)) {
+		if (bio_full(bio))
+			return 0;
+		__bio_add_page(bio, page, len, offset);
+	}
 	return len;
 }
 EXPORT_SYMBOL(bio_add_page);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index d4b39caf081d..e260f000b9ac 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -123,6 +123,11 @@ static inline void *bio_data(struct bio *bio)
 	return NULL;
 }
 
+static inline bool bio_full(struct bio *bio)
+{
+	return bio->bi_vcnt >= bio->bi_max_vecs;
+}
+
 /*
  * will die
  */
@@ -459,6 +464,10 @@ void bio_chain(struct bio *, struct bio *);
 extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
 			   unsigned int, unsigned int);
+bool __bio_try_merge_page(struct bio *bio, struct page *page,
+		unsigned int len, unsigned int off);
+void __bio_add_page(struct bio *bio, struct page *page,
+		unsigned int len, unsigned int off);
 int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter);
 struct rq_map_data;
 extern struct bio *bio_map_user_iov(struct request_queue *,
-- 
2.17.1

