Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9649A9E1F7
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730023AbfH0HyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:54:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:45928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730011AbfH0HyT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:54:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D659D217F5;
        Tue, 27 Aug 2019 07:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892458;
        bh=zBFIuOVncQ0mQk1/RZt6zBngG9P9fsV2Cwm1yrUWVrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1cuijysvWaE/eSItsiDr+HsUPYjR2F0eqUtb16+Hx5hi2FPn+lZOGL50JHXZXrW2f
         r636FpjgLuiDRycfyA18WHmJWs9Qg1oIYDFwBv0RrJTUvEcS5qksI8BMoOwQsSXsE7
         hhBDBZJw48TQVqG+bQYJ9QZj0AZxaotBUf7FUl0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Fomichev <dmitry.fomichev@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.14 54/62] dm zoned: improve error handling in i/o map code
Date:   Tue, 27 Aug 2019 09:50:59 +0200
Message-Id: <20190827072703.645002259@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072659.803647352@linuxfoundation.org>
References: <20190827072659.803647352@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Fomichev <dmitry.fomichev@wdc.com>

commit d7428c50118e739e672656c28d2b26b09375d4e0 upstream.

Some errors are ignored in the I/O path during queueing chunks
for processing by chunk works. Since at least these errors are
transient in nature, it should be possible to retry the failed
incoming commands.

The fix -

Errors that can happen while queueing chunks are carried upwards
to the main mapping function and it now returns DM_MAPIO_REQUEUE
for any incoming requests that can not be properly queued.

Error logging/debug messages are added where needed.

Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-zoned-target.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -513,22 +513,24 @@ static void dmz_flush_work(struct work_s
  * Get a chunk work and start it to process a new BIO.
  * If the BIO chunk has no work yet, create one.
  */
-static void dmz_queue_chunk_work(struct dmz_target *dmz, struct bio *bio)
+static int dmz_queue_chunk_work(struct dmz_target *dmz, struct bio *bio)
 {
 	unsigned int chunk = dmz_bio_chunk(dmz->dev, bio);
 	struct dm_chunk_work *cw;
+	int ret = 0;
 
 	mutex_lock(&dmz->chunk_lock);
 
 	/* Get the BIO chunk work. If one is not active yet, create one */
 	cw = radix_tree_lookup(&dmz->chunk_rxtree, chunk);
 	if (!cw) {
-		int ret;
 
 		/* Create a new chunk work */
 		cw = kmalloc(sizeof(struct dm_chunk_work), GFP_NOIO);
-		if (!cw)
+		if (unlikely(!cw)) {
+			ret = -ENOMEM;
 			goto out;
+		}
 
 		INIT_WORK(&cw->work, dmz_chunk_work);
 		atomic_set(&cw->refcount, 0);
@@ -539,7 +541,6 @@ static void dmz_queue_chunk_work(struct
 		ret = radix_tree_insert(&dmz->chunk_rxtree, chunk, cw);
 		if (unlikely(ret)) {
 			kfree(cw);
-			cw = NULL;
 			goto out;
 		}
 	}
@@ -547,10 +548,12 @@ static void dmz_queue_chunk_work(struct
 	bio_list_add(&cw->bio_list, bio);
 	dmz_get_chunk_work(cw);
 
+	dmz_reclaim_bio_acc(dmz->reclaim);
 	if (queue_work(dmz->chunk_wq, &cw->work))
 		dmz_get_chunk_work(cw);
 out:
 	mutex_unlock(&dmz->chunk_lock);
+	return ret;
 }
 
 /*
@@ -564,6 +567,7 @@ static int dmz_map(struct dm_target *ti,
 	sector_t sector = bio->bi_iter.bi_sector;
 	unsigned int nr_sectors = bio_sectors(bio);
 	sector_t chunk_sector;
+	int ret;
 
 	dmz_dev_debug(dev, "BIO op %d sector %llu + %u => chunk %llu, block %llu, %u blocks",
 		      bio_op(bio), (unsigned long long)sector, nr_sectors,
@@ -601,8 +605,14 @@ static int dmz_map(struct dm_target *ti,
 		dm_accept_partial_bio(bio, dev->zone_nr_sectors - chunk_sector);
 
 	/* Now ready to handle this BIO */
-	dmz_reclaim_bio_acc(dmz->reclaim);
-	dmz_queue_chunk_work(dmz, bio);
+	ret = dmz_queue_chunk_work(dmz, bio);
+	if (ret) {
+		dmz_dev_debug(dmz->dev,
+			      "BIO op %d, can't process chunk %llu, err %i\n",
+			      bio_op(bio), (u64)dmz_bio_chunk(dmz->dev, bio),
+			      ret);
+		return DM_MAPIO_REQUEUE;
+	}
 
 	return DM_MAPIO_SUBMITTED;
 }


