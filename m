Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F97524BFCC
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731016AbgHTNyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:54:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727898AbgHTJ0e (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:26:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F10AF22D00;
        Thu, 20 Aug 2020 09:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915594;
        bh=OR7j9qoFQeMiFNy5PaaWKvdEV1b7geYDxd0P+SguzH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yI1K5NPK1nGgSwLKPdIxFu+3w1h6qAV1BLNFnbnsuVGL8FimmcigmHVNOeLEjwbBs
         kUppKSAV8ohBiRHSJDZutJCu6jXvfSBltcVCwSvkS1ZJWMOUBOXAuI5Q2noT3KFo4L
         KXfszU9Ziwyt5sjrcE/C1BybXADU1Zs9sAtSpUXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.8 069/232] bcache: use disk_{start,end}_io_acct() to count I/O for bcache device
Date:   Thu, 20 Aug 2020 11:18:40 +0200
Message-Id: <20200820091616.139861355@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

commit c5be1f2c5bab1538aa29cd42e226d6b80391e3ff upstream.

This patch is a fix to patch "bcache: fix bio_{start,end}_io_acct with
proper device". The previous patch uses a hack to temporarily set
bi_disk to bcache device, which is mistaken too.

As Christoph suggests, this patch uses disk_{start,end}_io_acct() to
count I/O for bcache device in the correct way.

Fixes: 85750aeb748f ("bcache: use bio_{start,end}_io_acct")
Signed-off-by: Coly Li <colyli@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/request.c |   37 +++++++++----------------------------
 1 file changed, 9 insertions(+), 28 deletions(-)

--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -617,28 +617,6 @@ static void cache_lookup(struct closure
 
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
@@ -690,7 +668,9 @@ static void backing_request_endio(struct
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
@@ -750,8 +730,8 @@ static inline struct search *search_allo
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
@@ -1102,7 +1082,8 @@ static void detached_dev_end_io(struct b
 	bio->bi_end_io = ddip->bi_end_io;
 	bio->bi_private = ddip->bi_private;
 
-	bch_bio_end_io_acct(ddip->d->disk, bio, ddip->start_time);
+	/* Count on the bcache device */
+	disk_end_io_acct(ddip->d->disk, bio_op(bio), ddip->start_time);
 
 	if (bio->bi_status) {
 		struct cached_dev *dc = container_of(ddip->d,
@@ -1127,8 +1108,8 @@ static void detached_dev_do_request(stru
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


