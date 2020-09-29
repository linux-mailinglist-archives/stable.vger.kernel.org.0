Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90BC27C682
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730982AbgI2Lp7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:45:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730784AbgI2Lp6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:45:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 222382158C;
        Tue, 29 Sep 2020 11:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379955;
        bh=o+jX1UC9smdm8fMgaTBYlcGUoKwhXwap4VlpVNw2/pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UComp9HJiWg6Vy88kJU5LMz+p/ZaR7+BR2rvZcC76TiRrN8U2dYETCRFKz8T1G5og
         gQmpcY7SYR+ZsqlC1P6JuQHSn+lGvG4/bT4Grtg1a6eMG/JS3L/pX28PoqvDnhBrw+
         aCs1jWn3sppN1ZznvtVdTUT9EFkhLb/z04CNu/h8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.4 384/388] dm: fix bio splitting and its bio completion order for regular IO
Date:   Tue, 29 Sep 2020 13:01:55 +0200
Message-Id: <20200929110029.054124998@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Snitzer <snitzer@redhat.com>

commit ee1dfad5325ff1cfb2239e564cd411b3bfe8667a upstream.

dm_queue_split() is removed because __split_and_process_bio() _must_
handle splitting bios to ensure proper bio submission and completion
ordering as a bio is split.

Otherwise, multiple recursive calls to ->submit_bio will cause multiple
split bios to be allocated from the same ->bio_split mempool at the same
time. This would result in deadlock in low memory conditions because no
progress could be made (only one bio is available in ->bio_split
mempool).

This fix has been verified to still fix the loss of performance, due
to excess splitting, that commit 120c9257f5f1 provided.

Fixes: 120c9257f5f1 ("Revert "dm: always call blk_queue_split() in dm_process_bio()"")
Cc: stable@vger.kernel.org # 5.0+, requires custom backport due to 5.9 changes
Reported-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm.c |   23 ++---------------------
 1 file changed, 2 insertions(+), 21 deletions(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1720,23 +1720,6 @@ out:
 	return ret;
 }
 
-static void dm_queue_split(struct mapped_device *md, struct dm_target *ti, struct bio **bio)
-{
-	unsigned len, sector_count;
-
-	sector_count = bio_sectors(*bio);
-	len = min_t(sector_t, max_io_len((*bio)->bi_iter.bi_sector, ti), sector_count);
-
-	if (sector_count > len) {
-		struct bio *split = bio_split(*bio, len, GFP_NOIO, &md->queue->bio_split);
-
-		bio_chain(split, *bio);
-		trace_block_split(md->queue, split, (*bio)->bi_iter.bi_sector);
-		generic_make_request(*bio);
-		*bio = split;
-	}
-}
-
 static blk_qc_t dm_process_bio(struct mapped_device *md,
 			       struct dm_table *map, struct bio *bio)
 {
@@ -1764,14 +1747,12 @@ static blk_qc_t dm_process_bio(struct ma
 	if (current->bio_list) {
 		if (is_abnormal_io(bio))
 			blk_queue_split(md->queue, &bio);
-		else
-			dm_queue_split(md, ti, &bio);
+		/* regular IO is split by __split_and_process_bio */
 	}
 
 	if (dm_get_md_type(md) == DM_TYPE_NVME_BIO_BASED)
 		return __process_bio(md, map, bio, ti);
-	else
-		return __split_and_process_bio(md, map, bio);
+	return __split_and_process_bio(md, map, bio);
 }
 
 static blk_qc_t dm_make_request(struct request_queue *q, struct bio *bio)


