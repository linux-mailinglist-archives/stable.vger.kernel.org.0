Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D19D73C4D8B
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244230AbhGLHN3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:13:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239110AbhGLHLp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:11:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA93160FE7;
        Mon, 12 Jul 2021 07:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073736;
        bh=+/JFy+slToYPRalqVJJOi9ffJwiRSsiakNYtXkNAREA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bXkZAFIgRCjX7/ChKDECsO4m8t6F8hxabXv0PlKQingxWkukruf72EzZg8drn5odP
         8X7+jchA0OFKa1c4KcppTXRaobfBFjswh26mJib9ko1DRIzlIdIKLe5wogY75eiVPp
         Xy+AloDC2TEDz4cwpmE5rag0rj4f+DZXG6xJRRyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wade Liang <wadel@synology.com>,
        BingJing Chang <bingjingc@synology.com>,
        Edward Hsieh <edwardh@synology.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 341/700] block: fix trace completion for chained bio
Date:   Mon, 12 Jul 2021 08:07:04 +0200
Message-Id: <20210712061012.579182430@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Edward Hsieh <edwardh@synology.com>

[ Upstream commit 60b6a7e6a0f4382cd689f9afdac816964fec2921 ]

For chained bio, trace_block_bio_complete in bio_endio is currently called
only by the parent bio once upon all chained bio completed.
However, the sector and size for the parent bio are modified in bio_split.
Therefore, the size and sector of the complete events might not match the
queue events in blktrace.

The original fix of bio completion trace <fbbaf700e7b1> ("block: trace
completion of all bios.") wants multiple complete events to correspond
to one queue event but missed this.

The issue can be reproduced by md/raid5 read with bio cross chunks.

To fix, move trace completion into the loop for every chained bio to call.

Fixes: fbbaf700e7b1 ("block: trace completion of all bios.")
Reviewed-by: Wade Liang <wadel@synology.com>
Reviewed-by: BingJing Chang <bingjingc@synology.com>
Signed-off-by: Edward Hsieh <edwardh@synology.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20210624123030.27014-1-edwardh@synology.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 50e579088aca..b00c5a88a743 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1412,8 +1412,7 @@ static inline bool bio_remaining_done(struct bio *bio)
  *
  *   bio_endio() can be called several times on a bio that has been chained
  *   using bio_chain().  The ->bi_end_io() function will only be called the
- *   last time.  At this point the BLK_TA_COMPLETE tracing event will be
- *   generated if BIO_TRACE_COMPLETION is set.
+ *   last time.
  **/
 void bio_endio(struct bio *bio)
 {
@@ -1426,6 +1425,11 @@ again:
 	if (bio->bi_bdev)
 		rq_qos_done_bio(bio->bi_bdev->bd_disk->queue, bio);
 
+	if (bio->bi_bdev && bio_flagged(bio, BIO_TRACE_COMPLETION)) {
+		trace_block_bio_complete(bio->bi_bdev->bd_disk->queue, bio);
+		bio_clear_flag(bio, BIO_TRACE_COMPLETION);
+	}
+
 	/*
 	 * Need to have a real endio function for chained bios, otherwise
 	 * various corner cases will break (like stacking block devices that
@@ -1439,11 +1443,6 @@ again:
 		goto again;
 	}
 
-	if (bio->bi_bdev && bio_flagged(bio, BIO_TRACE_COMPLETION)) {
-		trace_block_bio_complete(bio->bi_bdev->bd_disk->queue, bio);
-		bio_clear_flag(bio, BIO_TRACE_COMPLETION);
-	}
-
 	blk_throtl_bio_endio(bio);
 	/* release cgroup info */
 	bio_uninit(bio);
-- 
2.30.2



