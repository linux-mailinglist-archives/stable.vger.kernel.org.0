Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5AE6087B5
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232593AbiJVIF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232875AbiJVIEU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:04:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6238E2D2C24;
        Sat, 22 Oct 2022 00:51:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C22CB82E03;
        Sat, 22 Oct 2022 07:41:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E50C433C1;
        Sat, 22 Oct 2022 07:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424471;
        bh=tQocI4AX+Xkhb6aZXEHJleSRliEKDtndK6ghaeMogRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c2Q00ifCBe8r1fbckqdPW6/ttlvnTDDN+YULJBhhIanTZKifGdQTySNIQEZ3iP92L
         qd8sP4SGWY2UFuBDcPOtydIqngABVkr7zqI9Z5Y2XrxQDnuV4/l8QSy9UXN+PJuznt
         5ty/Og7rV25G0uLaDDo7moig0g6waZ0jVXlgknJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.19 158/717] blk-throttle: fix that io throttle can only work for single bio
Date:   Sat, 22 Oct 2022 09:20:37 +0200
Message-Id: <20221022072443.408341338@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

commit 320fb0f91e55ba248d4bad106b408e59099cfa89 upstream.

Test scripts:
cd /sys/fs/cgroup/blkio/
echo "8:0 1024" > blkio.throttle.write_bps_device
echo $$ > cgroup.procs
dd if=/dev/zero of=/dev/sda bs=10k count=1 oflag=direct &
dd if=/dev/zero of=/dev/sda bs=10k count=1 oflag=direct &

Test result:
10240 bytes (10 kB, 10 KiB) copied, 10.0134 s, 1.0 kB/s
10240 bytes (10 kB, 10 KiB) copied, 10.0135 s, 1.0 kB/s

The problem is that the second bio is finished after 10s instead of 20s.

Root cause:
1) second bio will be flagged:

__blk_throtl_bio
 while (true) {
  ...
  if (sq->nr_queued[rw]) -> some bio is throttled already
   break
 };
 bio_set_flag(bio, BIO_THROTTLED); -> flag the bio

2) flagged bio will be dispatched without waiting:

throtl_dispatch_tg
 tg_may_dispatch
  tg_with_in_bps_limit
   if (bps_limit == U64_MAX || bio_flagged(bio, BIO_THROTTLED))
    *wait = 0; -> wait time is zero
    return true;

commit 9f5ede3c01f9 ("block: throttle split bio in case of iops limit")
support to count split bios for iops limit, thus it adds flagged bio
checking in tg_with_in_bps_limit() so that split bios will only count
once for bps limit, however, it introduce a new problem that io throttle
won't work if multiple bios are throttled.

In order to fix the problem, handle iops/bps limit in different ways:

1) for iops limit, there is no flag to record if the bio is throttled,
   and iops is always applied.
2) for bps limit, original bio will be flagged with BIO_BPS_THROTTLED,
   and io throttle will ignore bio with the flag.

Noted this patch also remove the code to set flag in __bio_clone(), it's
introduced in commit 111be8839817 ("block-throttle: avoid double
charge"), and author thinks split bio can be resubmited and throttled
again, which is wrong because split bio will continue to dispatch from
caller.

Fixes: 9f5ede3c01f9 ("block: throttle split bio in case of iops limit")
Cc: <stable@vger.kernel.org>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20220829022240.3348319-2-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bio.c               |    2 --
 block/blk-throttle.c      |   20 ++++++--------------
 block/blk-throttle.h      |    2 +-
 include/linux/bio.h       |    2 +-
 include/linux/blk_types.h |    2 +-
 5 files changed, 9 insertions(+), 19 deletions(-)

--- a/block/bio.c
+++ b/block/bio.c
@@ -760,8 +760,6 @@ EXPORT_SYMBOL(bio_put);
 static int __bio_clone(struct bio *bio, struct bio *bio_src, gfp_t gfp)
 {
 	bio_set_flag(bio, BIO_CLONED);
-	if (bio_flagged(bio_src, BIO_THROTTLED))
-		bio_set_flag(bio, BIO_THROTTLED);
 	bio->bi_ioprio = bio_src->bi_ioprio;
 	bio->bi_iter = bio_src->bi_iter;
 
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -811,7 +811,7 @@ static bool tg_with_in_bps_limit(struct
 	unsigned int bio_size = throtl_bio_data_size(bio);
 
 	/* no need to throttle if this bio's bytes have been accounted */
-	if (bps_limit == U64_MAX || bio_flagged(bio, BIO_THROTTLED)) {
+	if (bps_limit == U64_MAX || bio_flagged(bio, BIO_BPS_THROTTLED)) {
 		if (wait)
 			*wait = 0;
 		return true;
@@ -921,22 +921,13 @@ static void throtl_charge_bio(struct thr
 	unsigned int bio_size = throtl_bio_data_size(bio);
 
 	/* Charge the bio to the group */
-	if (!bio_flagged(bio, BIO_THROTTLED)) {
+	if (!bio_flagged(bio, BIO_BPS_THROTTLED)) {
 		tg->bytes_disp[rw] += bio_size;
 		tg->last_bytes_disp[rw] += bio_size;
 	}
 
 	tg->io_disp[rw]++;
 	tg->last_io_disp[rw]++;
-
-	/*
-	 * BIO_THROTTLED is used to prevent the same bio to be throttled
-	 * more than once as a throttled bio will go through blk-throtl the
-	 * second time when it eventually gets issued.  Set it when a bio
-	 * is being charged to a tg.
-	 */
-	if (!bio_flagged(bio, BIO_THROTTLED))
-		bio_set_flag(bio, BIO_THROTTLED);
 }
 
 /**
@@ -1026,6 +1017,7 @@ static void tg_dispatch_one_bio(struct t
 	sq->nr_queued[rw]--;
 
 	throtl_charge_bio(tg, bio);
+	bio_set_flag(bio, BIO_BPS_THROTTLED);
 
 	/*
 	 * If our parent is another tg, we just need to transfer @bio to
@@ -2159,8 +2151,10 @@ again:
 		qn = &tg->qnode_on_parent[rw];
 		sq = sq->parent_sq;
 		tg = sq_to_tg(sq);
-		if (!tg)
+		if (!tg) {
+			bio_set_flag(bio, BIO_BPS_THROTTLED);
 			goto out_unlock;
+		}
 	}
 
 	/* out-of-limit, queue to @tg */
@@ -2189,8 +2183,6 @@ again:
 	}
 
 out_unlock:
-	bio_set_flag(bio, BIO_THROTTLED);
-
 #ifdef CONFIG_BLK_DEV_THROTTLING_LOW
 	if (throttled || !td->track_bio_latency)
 		bio->bi_issue.value |= BIO_ISSUE_THROTL_SKIP_LATENCY;
--- a/block/blk-throttle.h
+++ b/block/blk-throttle.h
@@ -175,7 +175,7 @@ static inline bool blk_throtl_bio(struct
 	struct throtl_grp *tg = blkg_to_tg(bio->bi_blkg);
 
 	/* no need to throttle bps any more if the bio has been throttled */
-	if (bio_flagged(bio, BIO_THROTTLED) &&
+	if (bio_flagged(bio, BIO_BPS_THROTTLED) &&
 	    !(tg->flags & THROTL_TG_HAS_IOPS_LIMIT))
 		return false;
 
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -509,7 +509,7 @@ static inline void bio_set_dev(struct bi
 {
 	bio_clear_flag(bio, BIO_REMAPPED);
 	if (bio->bi_bdev != bdev)
-		bio_clear_flag(bio, BIO_THROTTLED);
+		bio_clear_flag(bio, BIO_BPS_THROTTLED);
 	bio->bi_bdev = bdev;
 	bio_associate_blkg(bio);
 }
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -323,7 +323,7 @@ enum {
 	BIO_QUIET,		/* Make BIO Quiet */
 	BIO_CHAIN,		/* chained bio, ->bi_remaining in effect */
 	BIO_REFFED,		/* bio has elevated ->bi_cnt */
-	BIO_THROTTLED,		/* This bio has already been subjected to
+	BIO_BPS_THROTTLED,	/* This bio has already been subjected to
 				 * throttling rules. Don't do it again. */
 	BIO_TRACE_COMPLETION,	/* bio_endio() should trace the final completion
 				 * of this bio. */


