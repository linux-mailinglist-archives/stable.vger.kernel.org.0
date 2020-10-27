Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C3E29B8C0
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1801861AbgJ0Pog (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:44:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:52504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799967AbgJ0PeY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:34:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADFC122202;
        Tue, 27 Oct 2020 15:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812863;
        bh=76kdpGoWy43gNIh6VEjUCOyF0dmmkr5cmldvPVhRa8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pDytOAtRFxHkGiO8j09jVGD8mjoK/WDRurF7adWA6ZeWYXYmUnh+3jH0m/1G6rO+f
         8gy7lSgkqnH+Zmj5+lLyci3SOmrTc4CJ4NxrBE3QOmso9yMqf7KqU7YfVm+kow/dH3
         cyflSz1o6gb9+MS6jMu0QUamccvH4GltU/N0pGDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeffle Xu <jefflexu@linux.alibaba.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 357/757] dm: fix missing imposition of queue_limits from dm_wq_work() thread
Date:   Tue, 27 Oct 2020 14:50:07 +0100
Message-Id: <20201027135507.312793690@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Snitzer <snitzer@redhat.com>

[ Upstream commit 0c2915b8c6db108b1dfb240391cc5a175f97f15b ]

If a DM device was suspended when bios were issued to it, those bios
would be deferred using queue_io(). Once the DM device was resumed
dm_process_bio() could be called by dm_wq_work() for original bio that
still needs splitting. dm_process_bio()'s check for current->bio_list
(meaning call chain is within ->submit_bio) as a prerequisite for
calling blk_queue_split() for "abnormal IO" would result in
dm_process_bio() never imposing corresponding queue_limits
(e.g. discard_granularity, discard_max_bytes, etc).

Fix this by always having dm_wq_work() resubmit deferred bios using
submit_bio_noacct().

Side-effect is blk_queue_split() is always called for "abnormal IO" from
->submit_bio, be it from application thread or dm_wq_work() workqueue,
so proper bio splitting and depth-first bio submission is performed.
For sake of clarity, remove current->bio_list check before call to
blk_queue_split().

Also, remove dm_wq_work()'s use of dm_{get,put}_live_table() -- no
longer needed since IO will be reissued in terms of ->submit_bio.
And rename bio variable from 'c' to 'bio'.

Fixes: cf9c37865557 ("dm: fix comment in dm_process_bio()")
Reported-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm.c | 34 +++++++++-------------------------
 1 file changed, 9 insertions(+), 25 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 6ed05ca65a0f8..b060a28ff1c6d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1744,17 +1744,11 @@ static blk_qc_t dm_process_bio(struct mapped_device *md,
 	}
 
 	/*
-	 * If in ->submit_bio we need to use blk_queue_split(), otherwise
-	 * queue_limits for abnormal requests (e.g. discard, writesame, etc)
-	 * won't be imposed.
-	 * If called from dm_wq_work() for deferred bio processing, bio
-	 * was already handled by following code with previous ->submit_bio.
+	 * Use blk_queue_split() for abnormal IO (e.g. discard, writesame, etc)
+	 * otherwise associated queue_limits won't be imposed.
 	 */
-	if (current->bio_list) {
-		if (is_abnormal_io(bio))
-			blk_queue_split(&bio);
-		/* regular IO is split by __split_and_process_bio */
-	}
+	if (is_abnormal_io(bio))
+		blk_queue_split(&bio);
 
 	if (dm_get_md_type(md) == DM_TYPE_NVME_BIO_BASED)
 		return __process_bio(md, map, bio, ti);
@@ -2461,29 +2455,19 @@ static int dm_wait_for_completion(struct mapped_device *md, long task_state)
  */
 static void dm_wq_work(struct work_struct *work)
 {
-	struct mapped_device *md = container_of(work, struct mapped_device,
-						work);
-	struct bio *c;
-	int srcu_idx;
-	struct dm_table *map;
-
-	map = dm_get_live_table(md, &srcu_idx);
+	struct mapped_device *md = container_of(work, struct mapped_device, work);
+	struct bio *bio;
 
 	while (!test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)) {
 		spin_lock_irq(&md->deferred_lock);
-		c = bio_list_pop(&md->deferred);
+		bio = bio_list_pop(&md->deferred);
 		spin_unlock_irq(&md->deferred_lock);
 
-		if (!c)
+		if (!bio)
 			break;
 
-		if (dm_request_based(md))
-			(void) submit_bio_noacct(c);
-		else
-			(void) dm_process_bio(md, map, c);
+		submit_bio_noacct(bio);
 	}
-
-	dm_put_live_table(md, srcu_idx);
 }
 
 static void dm_queue_flush(struct mapped_device *md)
-- 
2.25.1



