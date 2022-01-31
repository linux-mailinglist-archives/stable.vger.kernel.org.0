Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0D74A44C8
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359787AbiAaLck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:32:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379409AbiAaLaR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:30:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD97C0617AF;
        Mon, 31 Jan 2022 03:20:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B805B82A5D;
        Mon, 31 Jan 2022 11:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13FA9C340E8;
        Mon, 31 Jan 2022 11:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628014;
        bh=dBu42MrnqeKGNNg7unlA+oZ+dotkMkyhoERN96fJpAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z10GHwLZAy8aWX2TyBP7bXtkTZSliyGkyQUqfXq7g5fWWwdTTM5t1e/KBK1cHG55c
         ktNgM76KhmKrV51sGiwpNj0zyTUN+Q9Dw1xvhPgWjQ+TlCMv5qUnRU0NbhBliqNMlm
         R/ABg4XVIhFKVGUvOpqOmHZ8IEww8ANo0nDj4txU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bud Brown <bubrown@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.16 064/200] dm: properly fix redundant bio-based IO accounting
Date:   Mon, 31 Jan 2022 11:55:27 +0100
Message-Id: <20220131105235.725751726@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
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
@@ -1550,6 +1550,7 @@ static void __split_and_process_bio(stru
 			submit_bio_noacct(bio);
 		}
 	}
+	start_io_acct(ci.io);
 
 	/* drop the extra reference count */
 	dm_io_dec_pending(ci.io, errno_to_blk_status(error));


