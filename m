Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B32922D761
	for <lists+stable@lfdr.de>; Sat, 25 Jul 2020 14:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbgGYMDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jul 2020 08:03:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:52864 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727085AbgGYMDq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 25 Jul 2020 08:03:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 96484AB55;
        Sat, 25 Jul 2020 12:03:53 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        Coly Li <colyli@suse.de>, Christoph Hellwig <hch@lst.de>,
        stable@vger.kernel.org
Subject: [PATCH 25/25] bcache: fix bio_{start,end}_io_acct with proper device
Date:   Sat, 25 Jul 2020 20:00:39 +0800
Message-Id: <20200725120039.91071-26-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200725120039.91071-1-colyli@suse.de>
References: <20200725120039.91071-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 85750aeb748f ("bcache: use bio_{start,end}_io_acct") moves the
io account code to the location after bio_set_dev(bio, dc->bdev) in
cached_dev_make_request(). Then the account is performed incorrectly on
backing device, indeed the I/O should be counted to bcache device like
/dev/bcache0.

With the mistaken I/O account, iostat does not display I/O counts for
bcache device and all the numbers go to backing device. In writeback
mode, the hard drive may have 340K+ IOPS which is impossible and wrong
for spinning disk.

This patch introduces bch_bio_start_io_acct() and bch_bio_end_io_acct(),
which switches bio->bi_disk to bcache device before calling
bio_start_io_acct() or bio_end_io_acct(). Now the I/Os are counted to
bcache device, and bcache device, cache device and backing device have
their correct I/O count information back.

Fixes: 85750aeb748f ("bcache: use bio_{start,end}_io_acct")
Signed-off-by: Coly Li <colyli@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org
---
 drivers/md/bcache/request.c | 31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 7acf024e99f3..8ea0f079c1d0 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -617,6 +617,28 @@ static void cache_lookup(struct closure *cl)
 
 /* Common code for the make_request functions */
 
+static inline void bch_bio_start_io_acct(struct gendisk *acct_bi_disk,
+					 struct bio *bio,
+					 unsigned long *start_time)
+{
+	struct gendisk *saved_bi_disk = bio->bi_disk;
+
+	bio->bi_disk = acct_bi_disk;
+	*start_time = bio_start_io_acct(bio);
+	bio->bi_disk = saved_bi_disk;
+}
+
+static inline void bch_bio_end_io_acct(struct gendisk *acct_bi_disk,
+				       struct bio *bio,
+				       unsigned long start_time)
+{
+	struct gendisk *saved_bi_disk = bio->bi_disk;
+
+	bio->bi_disk = acct_bi_disk;
+	bio_end_io_acct(bio, start_time);
+	bio->bi_disk = saved_bi_disk;
+}
+
 static void request_endio(struct bio *bio)
 {
 	struct closure *cl = bio->bi_private;
@@ -668,7 +690,7 @@ static void backing_request_endio(struct bio *bio)
 static void bio_complete(struct search *s)
 {
 	if (s->orig_bio) {
-		bio_end_io_acct(s->orig_bio, s->start_time);
+		bch_bio_end_io_acct(s->d->disk, s->orig_bio, s->start_time);
 		trace_bcache_request_end(s->d, s->orig_bio);
 		s->orig_bio->bi_status = s->iop.status;
 		bio_endio(s->orig_bio);
@@ -728,7 +750,7 @@ static inline struct search *search_alloc(struct bio *bio,
 	s->recoverable		= 1;
 	s->write		= op_is_write(bio_op(bio));
 	s->read_dirty_data	= 0;
-	s->start_time		= bio_start_io_acct(bio);
+	bch_bio_start_io_acct(d->disk, bio, &s->start_time);
 
 	s->iop.c		= d->c;
 	s->iop.bio		= NULL;
@@ -1080,7 +1102,7 @@ static void detached_dev_end_io(struct bio *bio)
 	bio->bi_end_io = ddip->bi_end_io;
 	bio->bi_private = ddip->bi_private;
 
-	bio_end_io_acct(bio, ddip->start_time);
+	bch_bio_end_io_acct(ddip->d->disk, bio, ddip->start_time);
 
 	if (bio->bi_status) {
 		struct cached_dev *dc = container_of(ddip->d,
@@ -1105,7 +1127,8 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio)
 	 */
 	ddip = kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
 	ddip->d = d;
-	ddip->start_time = bio_start_io_acct(bio);
+	bch_bio_start_io_acct(d->disk, bio, &ddip->start_time);
+
 	ddip->bi_end_io = bio->bi_end_io;
 	ddip->bi_private = bio->bi_private;
 	bio->bi_end_io = detached_dev_end_io;
-- 
2.26.2

