Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0DEC126B4D
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728755AbfLSSzc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:55:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:51558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730675AbfLSSzb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:55:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CEE1227BF;
        Thu, 19 Dec 2019 18:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781731;
        bh=pzxbQw8yXBhI/4CS0KyYK1idrVsZN5R/unWIoJKQVRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vEgi7RbTQFUrHDfIQr2Ywmr9AexxvoamDXo+SLCOcqvc1585v93N3zJFFfovhYPJE
         DXGuG/dLytKk32P9oK6ZG9GjaywVY3gVKBZI9w7HxJIAP8N33D8XgtVlvX99n+TbbK
         AtjTgUhhWtc+vFkq/mHtoyrXzBBbx8NBFZkSKSg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikos Tsironis <ntsironis@arrikto.com>,
        Joe Thornber <ejt@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.4 57/80] dm thin: Flush data device before committing metadata
Date:   Thu, 19 Dec 2019 19:34:49 +0100
Message-Id: <20191219183130.904727172@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikos Tsironis <ntsironis@arrikto.com>

commit 694cfe7f31db36912725e63a38a5179c8628a496 upstream.

The thin provisioning target maintains per thin device mappings that map
virtual blocks to data blocks in the data device.

When we write to a shared block, in case of internal snapshots, or
provision a new block, in case of external snapshots, we copy the shared
block to a new data block (COW), update the mapping for the relevant
virtual block and then issue the write to the new data block.

Suppose the data device has a volatile write-back cache and the
following sequence of events occur:

1. We write to a shared block
2. A new data block is allocated
3. We copy the shared block to the new data block using kcopyd (COW)
4. We insert the new mapping for the virtual block in the btree for that
   thin device.
5. The commit timeout expires and we commit the metadata, that now
   includes the new mapping from step (4).
6. The system crashes and the data device's cache has not been flushed,
   meaning that the COWed data are lost.

The next time we read that virtual block of the thin device we read it
from the data block allocated in step (2), since the metadata have been
successfully committed. The data are lost due to the crash, so we read
garbage instead of the old, shared data.

This has the following implications:

1. In case of writes to shared blocks, with size smaller than the pool's
   block size (which means we first copy the whole block and then issue
   the smaller write), we corrupt data that the user never touched.

2. In case of writes to shared blocks, with size equal to the device's
   logical block size, we fail to provide atomic sector writes. When the
   system recovers the user will read garbage from that sector instead
   of the old data or the new data.

3. Even for writes to shared blocks, with size equal to the pool's block
   size (overwrites), after the system recovers, the written sectors
   will contain garbage instead of a random mix of sectors containing
   either old data or new data, thus we fail again to provide atomic
   sectors writes.

4. Even when the user flushes the thin device, because we first commit
   the metadata and then pass down the flush, the same risk for
   corruption exists (if the system crashes after the metadata have been
   committed but before the flush is passed down to the data device.)

The only case which is unaffected is that of writes with size equal to
the pool's block size and with the FUA flag set. But, because FUA writes
trigger metadata commits, this case can trigger the corruption
indirectly.

Moreover, apart from internal and external snapshots, the same issue
exists for newly provisioned blocks, when block zeroing is enabled.
After the system recovers the provisioned blocks might contain garbage
instead of zeroes.

To solve this and avoid the potential data corruption we flush the
pool's data device **before** committing its metadata.

This ensures that the data blocks of any newly inserted mappings are
properly written to non-volatile storage and won't be lost in case of a
crash.

Cc: stable@vger.kernel.org
Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
Acked-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-thin.c |   42 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -328,6 +328,7 @@ struct pool_c {
 	dm_block_t low_water_blocks;
 	struct pool_features requested_pf; /* Features requested during table load */
 	struct pool_features adjusted_pf;  /* Features used after adjusting for constituent devices */
+	struct bio flush_bio;
 };
 
 /*
@@ -2392,8 +2393,16 @@ static void process_deferred_bios(struct
 	while ((bio = bio_list_pop(&bio_completions)))
 		bio_endio(bio);
 
-	while ((bio = bio_list_pop(&bios)))
-		generic_make_request(bio);
+	while ((bio = bio_list_pop(&bios))) {
+		/*
+		 * The data device was flushed as part of metadata commit,
+		 * so complete redundant flushes immediately.
+		 */
+		if (bio->bi_opf & REQ_PREFLUSH)
+			bio_endio(bio);
+		else
+			generic_make_request(bio);
+	}
 }
 
 static void do_worker(struct work_struct *ws)
@@ -3127,6 +3136,7 @@ static void pool_dtr(struct dm_target *t
 	__pool_dec(pt->pool);
 	dm_put_device(ti, pt->metadata_dev);
 	dm_put_device(ti, pt->data_dev);
+	bio_uninit(&pt->flush_bio);
 	kfree(pt);
 
 	mutex_unlock(&dm_thin_pool_table.mutex);
@@ -3192,6 +3202,29 @@ static void metadata_low_callback(void *
 	dm_table_event(pool->ti->table);
 }
 
+/*
+ * We need to flush the data device **before** committing the metadata.
+ *
+ * This ensures that the data blocks of any newly inserted mappings are
+ * properly written to non-volatile storage and won't be lost in case of a
+ * crash.
+ *
+ * Failure to do so can result in data corruption in the case of internal or
+ * external snapshots and in the case of newly provisioned blocks, when block
+ * zeroing is enabled.
+ */
+static int metadata_pre_commit_callback(void *context)
+{
+	struct pool_c *pt = context;
+	struct bio *flush_bio = &pt->flush_bio;
+
+	bio_reset(flush_bio);
+	bio_set_dev(flush_bio, pt->data_dev->bdev);
+	flush_bio->bi_opf = REQ_OP_WRITE | REQ_PREFLUSH;
+
+	return submit_bio_wait(flush_bio);
+}
+
 static sector_t get_dev_size(struct block_device *bdev)
 {
 	return i_size_read(bdev->bd_inode) >> SECTOR_SHIFT;
@@ -3360,6 +3393,7 @@ static int pool_ctr(struct dm_target *ti
 	pt->data_dev = data_dev;
 	pt->low_water_blocks = low_water_blocks;
 	pt->adjusted_pf = pt->requested_pf = pf;
+	bio_init(&pt->flush_bio, NULL, 0);
 	ti->num_flush_bios = 1;
 
 	/*
@@ -3386,6 +3420,10 @@ static int pool_ctr(struct dm_target *ti
 	if (r)
 		goto out_flags_changed;
 
+	dm_pool_register_pre_commit_callback(pt->pool->pmd,
+					     metadata_pre_commit_callback,
+					     pt);
+
 	pt->callbacks.congested_fn = pool_is_congested;
 	dm_table_add_target_callbacks(ti->table, &pt->callbacks);
 


