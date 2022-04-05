Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07AFE4F2AA9
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242258AbiDEIhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239886AbiDEIVp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:21:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C376368;
        Tue,  5 Apr 2022 01:19:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CA4360B14;
        Tue,  5 Apr 2022 08:19:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9594C385A8;
        Tue,  5 Apr 2022 08:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146762;
        bh=pBjIgxy2sbQ3b5Xi7k2taKqFKSHjiJX5s66jWRpPa5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mibJKEzyFvlsP7Z46WRgA06rxKUW+zF090af7GGYIdgGQdBl057MjeNT5sHq4x48P
         EFJrIWHLcBOTv1lriCZeqzbUI9Ip/2G0ROhJmjO7R5bP81aRYJD4Sl77MpU2jlFDJT
         AgEoelOkx4PkuBYhqVqzTxmxojkvy/gpYz/loErU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ning Li <lining2020x@163.com>,
        Tejun Heo <tj@kernel.org>, Chunguang Xu <brookxu@tencent.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0841/1126] block: throttle split bio in case of iops limit
Date:   Tue,  5 Apr 2022 09:26:28 +0200
Message-Id: <20220405070432.239336896@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 9f5ede3c01f9951b0ae7d68b28762ad51d9bacc8 ]

Commit 111be8839817 ("block-throttle: avoid double charge") marks bio as
BIO_THROTTLED unconditionally if __blk_throtl_bio() is called on this bio,
then this bio won't be called into __blk_throtl_bio() any more. This way
is to avoid double charge in case of bio splitting. It is reasonable for
read/write throughput limit, but not reasonable for IOPS limit because
block layer provides io accounting against split bio.

Chunguang Xu has already observed this issue and fixed it in commit
4f1e9630afe6 ("blk-throtl: optimize IOPS throttle for large IO scenarios").
However, that patch only covers bio splitting in __blk_queue_split(), and
we have other kind of bio splitting, such as bio_split() &
submit_bio_noacct() and other ways.

This patch tries to fix the issue in one generic way by always charging
the bio for iops limit in blk_throtl_bio(). This way is reasonable:
re-submission & fast-cloned bio is charged if it is submitted to same
disk/queue, and BIO_THROTTLED will be cleared if bio->bi_bdev is changed.

This new approach can get much more smooth/stable iops limit compared with
commit 4f1e9630afe6 ("blk-throtl: optimize IOPS throttle for large IO
scenarios") since that commit can't throttle current split bios actually.

Also this way won't cause new double bio iops charge in
blk_throtl_dispatch_work_fn() in which blk_throtl_bio() won't be called
any more.

Reported-by: Ning Li <lining2020x@163.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Chunguang Xu <brookxu@tencent.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20220216044514.2903784-7-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-merge.c    |  2 --
 block/blk-throttle.c | 10 +++++++---
 block/blk-throttle.h |  2 --
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 47d253f79f32..ea6968313b4a 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -369,8 +369,6 @@ void __blk_queue_split(struct request_queue *q, struct bio **bio,
 		trace_block_split(split, (*bio)->bi_iter.bi_sector);
 		submit_bio_noacct(*bio);
 		*bio = split;
-
-		blk_throtl_charge_bio_split(*bio);
 	}
 }
 
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 7c462c006b26..87769b337fc5 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -808,7 +808,8 @@ static bool tg_with_in_bps_limit(struct throtl_grp *tg, struct bio *bio,
 	unsigned long jiffy_elapsed, jiffy_wait, jiffy_elapsed_rnd;
 	unsigned int bio_size = throtl_bio_data_size(bio);
 
-	if (bps_limit == U64_MAX) {
+	/* no need to throttle if this bio's bytes have been accounted */
+	if (bps_limit == U64_MAX || bio_flagged(bio, BIO_THROTTLED)) {
 		if (wait)
 			*wait = 0;
 		return true;
@@ -920,9 +921,12 @@ static void throtl_charge_bio(struct throtl_grp *tg, struct bio *bio)
 	unsigned int bio_size = throtl_bio_data_size(bio);
 
 	/* Charge the bio to the group */
-	tg->bytes_disp[rw] += bio_size;
+	if (!bio_flagged(bio, BIO_THROTTLED)) {
+		tg->bytes_disp[rw] += bio_size;
+		tg->last_bytes_disp[rw] += bio_size;
+	}
+
 	tg->io_disp[rw]++;
-	tg->last_bytes_disp[rw] += bio_size;
 	tg->last_io_disp[rw]++;
 
 	/*
diff --git a/block/blk-throttle.h b/block/blk-throttle.h
index 175f03abd9e4..cb43f4417d6e 100644
--- a/block/blk-throttle.h
+++ b/block/blk-throttle.h
@@ -170,8 +170,6 @@ static inline bool blk_throtl_bio(struct bio *bio)
 {
 	struct throtl_grp *tg = blkg_to_tg(bio->bi_blkg);
 
-	if (bio_flagged(bio, BIO_THROTTLED))
-		return false;
 	if (!tg->has_rules[bio_data_dir(bio)])
 		return false;
 
-- 
2.34.1



