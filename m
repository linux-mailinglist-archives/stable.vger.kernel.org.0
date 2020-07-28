Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E891F230BEC
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 15:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730277AbgG1N7c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jul 2020 09:59:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:51566 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730056AbgG1N7c (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jul 2020 09:59:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 318EFB130;
        Tue, 28 Jul 2020 13:59:42 +0000 (UTC)
From:   colyli@suse.de
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, Christoph Hellwig <hch@lst.de>,
        stable@vger.kernel.org
Subject: [PATCH] bcache: use disk_{start,end}_io_acct() to count I/O for bcache device
Date:   Tue, 28 Jul 2020 21:59:20 +0800
Message-Id: <20200728135920.4618-1-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

This patch is a fix to patch "bcache: fix bio_{start,end}_io_acct with
proper device". The previous patch uses a hack to temporarily set
bi_disk to bcache device, which is mistaken too.

As Christoph suggests, this patch uses disk_{start,end}_io_acct() to
count I/O for bcache device in the correct way.

Fixes: 85750aeb748f ("bcache: use bio_{start,end}_io_acct")
Signed-off-by: Coly Li <colyli@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org
---
 drivers/md/bcache/request.c | 37 +++++++++----------------------------
 1 file changed, 9 insertions(+), 28 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 8ea0f079c1d0..9cc044293acd 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -617,28 +617,6 @@ static void cache_lookup(struct closure *cl)
 
 /* Common code for the make_request functions */
 
-static inline void bch_bio_start_io_acct(struct gendisk *acct_bi_disk,
-					 struct bio *bio,
-					 unsigned long *start_time)
-{
-	struct gendisk *saved_bi_disk = bio->bi_disk;
-
-	bio->bi_disk = acct_bi_disk;
-	*start_time = bio_start_io_acct(bio);
-	bio->bi_disk = saved_bi_disk;
-}
-
-static inline void bch_bio_end_io_acct(struct gendisk *acct_bi_disk,
-				       struct bio *bio,
-				       unsigned long start_time)
-{
-	struct gendisk *saved_bi_disk = bio->bi_disk;
-
-	bio->bi_disk = acct_bi_disk;
-	bio_end_io_acct(bio, start_time);
-	bio->bi_disk = saved_bi_disk;
-}
-
 static void request_endio(struct bio *bio)
 {
 	struct closure *cl = bio->bi_private;
@@ -690,7 +668,9 @@ static void backing_request_endio(struct bio *bio)
 static void bio_complete(struct search *s)
 {
 	if (s->orig_bio) {
-		bch_bio_end_io_acct(s->d->disk, s->orig_bio, s->start_time);
+		/* Count on bcache device */
+		disk_end_io_acct(s->d->disk, bio_op(s->orig_bio), s->start_time);
+
 		trace_bcache_request_end(s->d, s->orig_bio);
 		s->orig_bio->bi_status = s->iop.status;
 		bio_endio(s->orig_bio);
@@ -750,8 +730,8 @@ static inline struct search *search_alloc(struct bio *bio,
 	s->recoverable		= 1;
 	s->write		= op_is_write(bio_op(bio));
 	s->read_dirty_data	= 0;
-	bch_bio_start_io_acct(d->disk, bio, &s->start_time);
-
+	/* Count on the bcache device */
+	s->start_time		= disk_start_io_acct(d->disk, bio_sectors(bio), bio_op(bio));
 	s->iop.c		= d->c;
 	s->iop.bio		= NULL;
 	s->iop.inode		= d->id;
@@ -1102,7 +1082,8 @@ static void detached_dev_end_io(struct bio *bio)
 	bio->bi_end_io = ddip->bi_end_io;
 	bio->bi_private = ddip->bi_private;
 
-	bch_bio_end_io_acct(ddip->d->disk, bio, ddip->start_time);
+	/* Count on the bcache device */
+	disk_end_io_acct(ddip->d->disk, bio_op(bio), ddip->start_time);
 
 	if (bio->bi_status) {
 		struct cached_dev *dc = container_of(ddip->d,
@@ -1127,8 +1108,8 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio)
 	 */
 	ddip = kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
 	ddip->d = d;
-	bch_bio_start_io_acct(d->disk, bio, &ddip->start_time);
-
+	/* Count on the bcache device */
+	ddip->start_time = disk_start_io_acct(d->disk, bio_sectors(bio), bio_op(bio));
 	ddip->bi_end_io = bio->bi_end_io;
 	ddip->bi_private = bio->bi_private;
 	bio->bi_end_io = detached_dev_end_io;
-- 
2.26.2

