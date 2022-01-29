Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFBCB4A2FD1
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 14:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345789AbiA2Ndk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 08:33:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239973AbiA2Ndk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 08:33:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13E1C061714
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 05:33:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BF1D60DC4
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 13:33:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77717C340E5;
        Sat, 29 Jan 2022 13:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643463219;
        bh=3N0JtF1B77u7SNlXbJna5VFBojxai8TCPg3lYKQWmyk=;
        h=Subject:To:Cc:From:Date:From;
        b=Ys7sIPrg+VXC403LxxSXa+SNjB9KrhsSCajVwWVgTr8fNM+mivDEvSC6RZLs0IfJB
         +sANqfJf0p4Nx8FdWscD47tGLG5DK5jcv1QFyUsBtIfwJyj+zQ8Z2HTodgE/8kvnUh
         K12EFL5f6XUz4dz0YY+XmToJdhuekalVVokb2sOE=
Subject: FAILED: patch "[PATCH] dm: properly fix redundant bio-based IO accounting" failed to apply to 5.10-stable tree
To:     snitzer@redhat.com, axboe@kernel.dk, bubrown@redhat.com, hch@lst.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 Jan 2022 14:33:36 +0100
Message-ID: <164346321635255@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b879f915bc48a18d4f4462729192435bb0f17052 Mon Sep 17 00:00:00 2001
From: Mike Snitzer <snitzer@redhat.com>
Date: Fri, 28 Jan 2022 10:58:41 -0500
Subject: [PATCH] dm: properly fix redundant bio-based IO accounting

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

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 9849114b3c08..dcbd6d201619 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -489,7 +489,7 @@ static void start_io_acct(struct dm_io *io)
 	struct mapped_device *md = io->md;
 	struct bio *bio = io->orig_bio;
 
-	io->start_time = bio_start_io_acct(bio);
+	bio_start_io_acct_time(bio, io->start_time);
 	if (unlikely(dm_stats_used(&md->stats)))
 		dm_stats_account_io(&md->stats, bio_data_dir(bio),
 				    bio->bi_iter.bi_sector, bio_sectors(bio),
@@ -535,7 +535,7 @@ static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
 	io->md = md;
 	spin_lock_init(&io->endio_lock);
 
-	start_io_acct(io);
+	io->start_time = jiffies;
 
 	return io;
 }
@@ -1482,6 +1482,7 @@ static void __split_and_process_bio(struct mapped_device *md,
 			submit_bio_noacct(bio);
 		}
 	}
+	start_io_acct(ci.io);
 
 	/* drop the extra reference count */
 	dm_io_dec_pending(ci.io, errno_to_blk_status(error));

