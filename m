Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7DA54A424E
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359504AbiAaLLW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:11:22 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56888 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376609AbiAaLIm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:08:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 059B5B82A68;
        Mon, 31 Jan 2022 11:08:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 100A8C340EE;
        Mon, 31 Jan 2022 11:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627319;
        bh=ecJFmKJDYdU3rLXxZJsdCvxkFYyBlEkQ5JXzF9zoskE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2l9XV5ukkIUN1etd2n0jk1pEVN27+bEZ/sN6Uz/WZGSN5lsrsceF1xyzr5mwzuEM/
         K6SINoPyvQq9xvxmU/kzzr7PzF0+laajb4f7uM5GSAVmDX0S/lisQSuSQ8TtOzsAK0
         x2AFefuOI9D92LoknVVeMpFPrdMR2DdN+F14z0Io=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bud Brown <bubrown@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 045/171] dm: properly fix redundant bio-based IO accounting
Date:   Mon, 31 Jan 2022 11:55:10 +0100
Message-Id: <20220131105231.546721826@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Snitzer <snitzer@redhat.com>

commit b879f915bc48a18d4f4462729192435bb0f17052 upstream.

Record the start_time for a bio but defer the starting block core's IO
accounting until after IO is submitted using bio_start_io_acct_time().

This approach avoids the need to mess around with any of the
individual IO stats in response to a bio_split() that follows bio
submission.

Reported-by: Bud Brown <bubrown@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org
Depends-on: e45c47d1f94e ("block: add bio_start_io_acct_time() to control start_time")
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Link: https://lore.kernel.org/r/20220128155841.39644-4-snitzer@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -489,7 +489,7 @@ static void start_io_acct(struct dm_io *
 	struct mapped_device *md = io->md;
 	struct bio *bio = io->orig_bio;
 
-	io->start_time = bio_start_io_acct(bio);
+	bio_start_io_acct_time(bio, io->start_time);
 	if (unlikely(dm_stats_used(&md->stats)))
 		dm_stats_account_io(&md->stats, bio_data_dir(bio),
 				    bio->bi_iter.bi_sector, bio_sectors(bio),
@@ -535,7 +535,7 @@ static struct dm_io *alloc_io(struct map
 	io->md = md;
 	spin_lock_init(&io->endio_lock);
 
-	start_io_acct(io);
+	io->start_time = jiffies;
 
 	return io;
 }
@@ -1555,6 +1555,7 @@ static blk_qc_t __split_and_process_bio(
 			ret = submit_bio_noacct(bio);
 		}
 	}
+	start_io_acct(ci.io);
 
 	/* drop the extra reference count */
 	dm_io_dec_pending(ci.io, errno_to_blk_status(error));


