Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8F2412147F
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730832AbfLPSLv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:11:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:56220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730848AbfLPSLv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:11:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41C17206E0;
        Mon, 16 Dec 2019 18:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519910;
        bh=eG3X9XDJRoibZA/dYPT0bLlqrUgByqjaKy6cXiBxyK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GseUdmDnr2aRC6OIWRQcYsP03F2HLkWo6rylWssMIViztk+3Ca0u595bUpbOA6K6s
         O9itXiXCRog6AuVsZ/JykbwUbDsVtTGdollyc3Z6ptt2I0v7Xd7suDXrIF3yULm+Y9
         zWGFgTdklpEWYc7qWDD1TXT5CZDXppEScvBpqcXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NeilBrown <neilb@suse.com>,
        David Jeffery <djeffery@redhat.com>, Xiao Ni <xni@redhat.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH 5.3 079/180] md: improve handling of bio with REQ_PREFLUSH in md_flush_request()
Date:   Mon, 16 Dec 2019 18:48:39 +0100
Message-Id: <20191216174831.092655352@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Jeffery <djeffery@redhat.com>

commit 775d78319f1ceb32be8eb3b1202ccdc60e9cb7f1 upstream.

If pers->make_request fails in md_flush_request(), the bio is lost. To
fix this, pass back a bool to indicate if the original make_request call
should continue to handle the I/O and instead of assuming the flush logic
will push it to completion.

Convert md_flush_request to return a bool and no longer calls the raid
driver's make_request function.  If the return is true, then the md flush
logic has or will complete the bio and the md make_request call is done.
If false, then the md make_request function needs to keep processing like
it is a normal bio. Let the original call to md_handle_request handle any
need to retry sending the bio to the raid driver's make_request function
should it be needed.

Also mark md_flush_request and the make_request function pointer as
__must_check to issue warnings should these critical return values be
ignored.

Fixes: 2bc13b83e629 ("md: batch flush requests.")
Cc: stable@vger.kernel.org # # v4.19+
Cc: NeilBrown <neilb@suse.com>
Signed-off-by: David Jeffery <djeffery@redhat.com>
Reviewed-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/md-linear.c    |    5 ++---
 drivers/md/md-multipath.c |    5 ++---
 drivers/md/md.c           |   11 +++++++++--
 drivers/md/md.h           |    4 ++--
 drivers/md/raid0.c        |    5 ++---
 drivers/md/raid1.c        |    5 ++---
 drivers/md/raid10.c       |    5 ++---
 drivers/md/raid5.c        |    4 ++--
 8 files changed, 23 insertions(+), 21 deletions(-)

--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -244,10 +244,9 @@ static bool linear_make_request(struct m
 	sector_t start_sector, end_sector, data_offset;
 	sector_t bio_sector = bio->bi_iter.bi_sector;
 
-	if (unlikely(bio->bi_opf & REQ_PREFLUSH)) {
-		md_flush_request(mddev, bio);
+	if (unlikely(bio->bi_opf & REQ_PREFLUSH)
+	    && md_flush_request(mddev, bio))
 		return true;
-	}
 
 	tmp_dev = which_dev(mddev, bio_sector);
 	start_sector = tmp_dev->end_sector - tmp_dev->rdev->sectors;
--- a/drivers/md/md-multipath.c
+++ b/drivers/md/md-multipath.c
@@ -104,10 +104,9 @@ static bool multipath_make_request(struc
 	struct multipath_bh * mp_bh;
 	struct multipath_info *multipath;
 
-	if (unlikely(bio->bi_opf & REQ_PREFLUSH)) {
-		md_flush_request(mddev, bio);
+	if (unlikely(bio->bi_opf & REQ_PREFLUSH)
+	    && md_flush_request(mddev, bio))
 		return true;
-	}
 
 	mp_bh = mempool_alloc(&conf->pool, GFP_NOIO);
 
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -545,7 +545,13 @@ static void md_submit_flush_data(struct
 	}
 }
 
-void md_flush_request(struct mddev *mddev, struct bio *bio)
+/*
+ * Manages consolidation of flushes and submitting any flushes needed for
+ * a bio with REQ_PREFLUSH.  Returns true if the bio is finished or is
+ * being finished in another context.  Returns false if the flushing is
+ * complete but still needs the I/O portion of the bio to be processed.
+ */
+bool md_flush_request(struct mddev *mddev, struct bio *bio)
 {
 	ktime_t start = ktime_get_boottime();
 	spin_lock_irq(&mddev->lock);
@@ -570,9 +576,10 @@ void md_flush_request(struct mddev *mdde
 			bio_endio(bio);
 		else {
 			bio->bi_opf &= ~REQ_PREFLUSH;
-			mddev->pers->make_request(mddev, bio);
+			return false;
 		}
 	}
+	return true;
 }
 EXPORT_SYMBOL(md_flush_request);
 
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -546,7 +546,7 @@ struct md_personality
 	int level;
 	struct list_head list;
 	struct module *owner;
-	bool (*make_request)(struct mddev *mddev, struct bio *bio);
+	bool __must_check (*make_request)(struct mddev *mddev, struct bio *bio);
 	/*
 	 * start up works that do NOT require md_thread. tasks that
 	 * requires md_thread should go into start()
@@ -699,7 +699,7 @@ extern void md_error(struct mddev *mddev
 extern void md_finish_reshape(struct mddev *mddev);
 
 extern int mddev_congested(struct mddev *mddev, int bits);
-extern void md_flush_request(struct mddev *mddev, struct bio *bio);
+extern bool __must_check md_flush_request(struct mddev *mddev, struct bio *bio);
 extern void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
 			   sector_t sector, int size, struct page *page);
 extern int md_super_wait(struct mddev *mddev);
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -572,10 +572,9 @@ static bool raid0_make_request(struct md
 	unsigned chunk_sects;
 	unsigned sectors;
 
-	if (unlikely(bio->bi_opf & REQ_PREFLUSH)) {
-		md_flush_request(mddev, bio);
+	if (unlikely(bio->bi_opf & REQ_PREFLUSH)
+	    && md_flush_request(mddev, bio))
 		return true;
-	}
 
 	if (unlikely((bio_op(bio) == REQ_OP_DISCARD))) {
 		raid0_handle_discard(mddev, bio);
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1564,10 +1564,9 @@ static bool raid1_make_request(struct md
 {
 	sector_t sectors;
 
-	if (unlikely(bio->bi_opf & REQ_PREFLUSH)) {
-		md_flush_request(mddev, bio);
+	if (unlikely(bio->bi_opf & REQ_PREFLUSH)
+	    && md_flush_request(mddev, bio))
 		return true;
-	}
 
 	/*
 	 * There is a limit to the maximum size, but
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1523,10 +1523,9 @@ static bool raid10_make_request(struct m
 	int chunk_sects = chunk_mask + 1;
 	int sectors = bio_sectors(bio);
 
-	if (unlikely(bio->bi_opf & REQ_PREFLUSH)) {
-		md_flush_request(mddev, bio);
+	if (unlikely(bio->bi_opf & REQ_PREFLUSH)
+	    && md_flush_request(mddev, bio))
 		return true;
-	}
 
 	if (!md_write_start(mddev, bio))
 		return false;
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5587,8 +5587,8 @@ static bool raid5_make_request(struct md
 		if (ret == 0)
 			return true;
 		if (ret == -ENODEV) {
-			md_flush_request(mddev, bi);
-			return true;
+			if (md_flush_request(mddev, bi))
+				return true;
 		}
 		/* ret == -EAGAIN, fallback */
 		/*


