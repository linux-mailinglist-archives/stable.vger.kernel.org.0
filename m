Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF1728894
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390967AbfEWT1T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:27:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:39420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391560AbfEWT1Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:27:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 671A6217D9;
        Thu, 23 May 2019 19:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639634;
        bh=OM323lilaXTT5GZ/zcOGrhKKBjdRwxa1Q4gP6gKPlek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t0c7Tf8bybU7uf9qxcsySwo7IFMlhbn57OTxAHo4S54/TgppjlFljwPQX1tPmYB8o
         RUoPPgRrXnw9avdscjNJ87KfW4JwACey2b1Tz6gdOI15DPuMPdEmfYE3Kw3KbVICAx
         T3gj77MECG57XjlkNdDEKsZA0Ids3vElatCk///8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiao Ni <xni@redhat.com>,
        NeilBrown <neilb@suse.com>, Song Liu <songliubraving@fb.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.1 038/122] md: batch flush requests.
Date:   Thu, 23 May 2019 21:06:00 +0200
Message-Id: <20190523181709.823320592@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: NeilBrown <neilb@suse.com>

commit 2bc13b83e6298486371761de503faeffd15b7534 upstream.

Currently if many flush requests are submitted to an md device is quick
succession, they are serialized and can take a long to process them all.
We don't really need to call flush all those times - a single flush call
can satisfy all requests submitted before it started.
So keep track of when the current flush started and when it finished,
allow any pending flush that was requested before the flush started
to complete without waiting any more.

Test results from Xiao:

Test is done on a raid10 device which is created by 4 SSDs. The tool is
dbench.

1. The latest linux stable kernel
  Operation                Count    AvgLat    MaxLat
  --------------------------------------------------
  Deltree                    768    10.509    78.305
  Flush                  2078376     0.013    10.094
  Close                  21787697     0.019    18.821
  LockX                    96580     0.007     3.184
  Mkdir                      384     0.008     0.062
  Rename                 1255883     0.191    23.534
  ReadX                  46495589     0.020    14.230
  WriteX                 14790591     7.123    60.706
  Unlink                 5989118     0.440    54.551
  UnlockX                  96580     0.005     2.736
  FIND_FIRST             10393845     0.042    12.079
  SET_FILE_INFORMATION   2415558     0.129    10.088
  QUERY_FILE_INFORMATION 4711725     0.005     8.462
  QUERY_PATH_INFORMATION 26883327     0.032    21.715
  QUERY_FS_INFORMATION   4929409     0.010     8.238
  NTCreateX              29660080     0.100    53.268

Throughput 1034.88 MB/sec (sync open)  128 clients  128 procs
max_latency=60.712 ms

2. With patch1 "Revert "MD: fix lock contention for flush bios""
  Operation                Count    AvgLat    MaxLat
  --------------------------------------------------
  Deltree                    256     8.326    36.761
  Flush                   693291     3.974   180.269
  Close                  7266404     0.009    36.929
  LockX                    32160     0.006     0.840
  Mkdir                      128     0.008     0.021
  Rename                  418755     0.063    29.945
  ReadX                  15498708     0.007     7.216
  WriteX                 4932310    22.482   267.928
  Unlink                 1997557     0.109    47.553
  UnlockX                  32160     0.004     1.110
  FIND_FIRST             3465791     0.036     7.320
  SET_FILE_INFORMATION    805825     0.015     1.561
  QUERY_FILE_INFORMATION 1570950     0.005     2.403
  QUERY_PATH_INFORMATION 8965483     0.013    14.277
  QUERY_FS_INFORMATION   1643626     0.009     3.314
  NTCreateX              9892174     0.061    41.278

Throughput 345.009 MB/sec (sync open)  128 clients  128 procs
max_latency=267.939 m

3. With patch1 and patch2
  Operation                Count    AvgLat    MaxLat
  --------------------------------------------------
  Deltree                    768     9.570    54.588
  Flush                  2061354     0.666    15.102
  Close                  21604811     0.012    25.697
  LockX                    95770     0.007     1.424
  Mkdir                      384     0.008     0.053
  Rename                 1245411     0.096    12.263
  ReadX                  46103198     0.011    12.116
  WriteX                 14667988     7.375    60.069
  Unlink                 5938936     0.173    30.905
  UnlockX                  95770     0.005     4.147
  FIND_FIRST             10306407     0.041    11.715
  SET_FILE_INFORMATION   2395987     0.048     7.640
  QUERY_FILE_INFORMATION 4672371     0.005     9.291
  QUERY_PATH_INFORMATION 26656735     0.018    19.719
  QUERY_FS_INFORMATION   4887940     0.010     7.654
  NTCreateX              29410811     0.059    28.551

Throughput 1026.21 MB/sec (sync open)  128 clients  128 procs
max_latency=60.075 ms

Cc: <stable@vger.kernel.org> # v4.19+
Tested-by: Xiao Ni <xni@redhat.com>
Signed-off-by: NeilBrown <neilb@suse.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/md.c |   27 +++++++++++++++++++++++----
 drivers/md/md.h |    3 +++
 2 files changed, 26 insertions(+), 4 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -427,6 +427,7 @@ static void submit_flushes(struct work_s
 	struct mddev *mddev = container_of(ws, struct mddev, flush_work);
 	struct md_rdev *rdev;
 
+	mddev->start_flush = ktime_get_boottime();
 	INIT_WORK(&mddev->flush_work, md_submit_flush_data);
 	atomic_set(&mddev->flush_pending, 1);
 	rcu_read_lock();
@@ -467,6 +468,7 @@ static void md_submit_flush_data(struct
 	 * could wait for this and below md_handle_request could wait for those
 	 * bios because of suspend check
 	 */
+	mddev->last_flush = mddev->start_flush;
 	mddev->flush_bio = NULL;
 	wake_up(&mddev->sb_wait);
 
@@ -481,15 +483,32 @@ static void md_submit_flush_data(struct
 
 void md_flush_request(struct mddev *mddev, struct bio *bio)
 {
+	ktime_t start = ktime_get_boottime();
 	spin_lock_irq(&mddev->lock);
 	wait_event_lock_irq(mddev->sb_wait,
-			    !mddev->flush_bio,
+			    !mddev->flush_bio ||
+			    ktime_after(mddev->last_flush, start),
 			    mddev->lock);
-	mddev->flush_bio = bio;
+	if (!ktime_after(mddev->last_flush, start)) {
+		WARN_ON(mddev->flush_bio);
+		mddev->flush_bio = bio;
+		bio = NULL;
+	}
 	spin_unlock_irq(&mddev->lock);
 
-	INIT_WORK(&mddev->flush_work, submit_flushes);
-	queue_work(md_wq, &mddev->flush_work);
+	if (!bio) {
+		INIT_WORK(&mddev->flush_work, submit_flushes);
+		queue_work(md_wq, &mddev->flush_work);
+	} else {
+		/* flush was performed for some other bio while we waited. */
+		if (bio->bi_iter.bi_size == 0)
+			/* an empty barrier - all done */
+			bio_endio(bio);
+		else {
+			bio->bi_opf &= ~REQ_PREFLUSH;
+			mddev->pers->make_request(mddev, bio);
+		}
+	}
 }
 EXPORT_SYMBOL(md_flush_request);
 
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -463,6 +463,9 @@ struct mddev {
 	 */
 	struct bio *flush_bio;
 	atomic_t flush_pending;
+	ktime_t start_flush, last_flush; /* last_flush is when the last completed
+					  * flush was started.
+					  */
 	struct work_struct flush_work;
 	struct work_struct event_work;	/* used by dm to report failure event */
 	void (*sync_super)(struct mddev *mddev, struct md_rdev *rdev);


