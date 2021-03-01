Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CACA3291ED
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243494AbhCAUg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:36:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:48816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238813AbhCAUaO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:30:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A890E65289;
        Mon,  1 Mar 2021 18:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614622091;
        bh=Nqlo/1suRBDwroBwRBe92vMGQd1k0Eqf49rR/q8FdbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ykhEG/HtGH9i2DopSprGwbrgJQolFdczhg9LnJpeuyOwDdghUxaV74lZNJ6WDeCJL
         ZfoAhhKn5F0R0Uq5macH72EbK7vMGT9NZEAqi5VL8+8m7V32B24DgBmTIkxyu8Myje
         zCBUM1ZTRXp4zogr8cf7H8LP1ZbEel+w02HslC+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.11 753/775] dm: fix deadlock when swapping to encrypted device
Date:   Mon,  1 Mar 2021 17:15:21 +0100
Message-Id: <20210301161238.530735187@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit a666e5c05e7c4aaabb2c5d58117b0946803d03d2 upstream.

The system would deadlock when swapping to a dm-crypt device. The reason
is that for each incoming write bio, dm-crypt allocates memory that holds
encrypted data. These excessive allocations exhaust all the memory and the
result is either deadlock or OOM trigger.

This patch limits the number of in-flight swap bios, so that the memory
consumed by dm-crypt is limited. The limit is enforced if the target set
the "limit_swap_bios" variable and if the bio has REQ_SWAP set.

Non-swap bios are not affected becuase taking the semaphore would cause
performance degradation.

This is similar to request-based drivers - they will also block when the
number of requests is over the limit.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-core.h          |    4 ++
 drivers/md/dm-crypt.c         |    1 
 drivers/md/dm.c               |   60 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/device-mapper.h |    5 +++
 4 files changed, 70 insertions(+)

--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -102,6 +102,10 @@ struct mapped_device {
 	/* kobject and completion */
 	struct dm_kobject_holder kobj_holder;
 
+	int swap_bios;
+	struct semaphore swap_bios_semaphore;
+	struct mutex swap_bios_lock;
+
 	struct dm_stats stats;
 
 	/* for blk-mq request-based DM support */
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -3324,6 +3324,7 @@ static int crypt_ctr(struct dm_target *t
 	wake_up_process(cc->write_thread);
 
 	ti->num_flush_bios = 1;
+	ti->limit_swap_bios = true;
 
 	return 0;
 
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -148,6 +148,16 @@ EXPORT_SYMBOL_GPL(dm_bio_get_target_bio_
 #define DM_NUMA_NODE NUMA_NO_NODE
 static int dm_numa_node = DM_NUMA_NODE;
 
+#define DEFAULT_SWAP_BIOS	(8 * 1048576 / PAGE_SIZE)
+static int swap_bios = DEFAULT_SWAP_BIOS;
+static int get_swap_bios(void)
+{
+	int latch = READ_ONCE(swap_bios);
+	if (unlikely(latch <= 0))
+		latch = DEFAULT_SWAP_BIOS;
+	return latch;
+}
+
 /*
  * For mempools pre-allocation at the table loading time.
  */
@@ -969,6 +979,11 @@ void disable_write_zeroes(struct mapped_
 	limits->max_write_zeroes_sectors = 0;
 }
 
+static bool swap_bios_limit(struct dm_target *ti, struct bio *bio)
+{
+	return unlikely((bio->bi_opf & REQ_SWAP) != 0) && unlikely(ti->limit_swap_bios);
+}
+
 static void clone_endio(struct bio *bio)
 {
 	blk_status_t error = bio->bi_status;
@@ -1019,6 +1034,11 @@ static void clone_endio(struct bio *bio)
 		}
 	}
 
+	if (unlikely(swap_bios_limit(tio->ti, bio))) {
+		struct mapped_device *md = io->md;
+		up(&md->swap_bios_semaphore);
+	}
+
 	free_tio(tio);
 	dec_pending(io, error);
 }
@@ -1252,6 +1272,22 @@ void dm_accept_partial_bio(struct bio *b
 }
 EXPORT_SYMBOL_GPL(dm_accept_partial_bio);
 
+static noinline void __set_swap_bios_limit(struct mapped_device *md, int latch)
+{
+	mutex_lock(&md->swap_bios_lock);
+	while (latch < md->swap_bios) {
+		cond_resched();
+		down(&md->swap_bios_semaphore);
+		md->swap_bios--;
+	}
+	while (latch > md->swap_bios) {
+		cond_resched();
+		up(&md->swap_bios_semaphore);
+		md->swap_bios++;
+	}
+	mutex_unlock(&md->swap_bios_lock);
+}
+
 static blk_qc_t __map_bio(struct dm_target_io *tio)
 {
 	int r;
@@ -1271,6 +1307,14 @@ static blk_qc_t __map_bio(struct dm_targ
 	atomic_inc(&io->io_count);
 	sector = clone->bi_iter.bi_sector;
 
+	if (unlikely(swap_bios_limit(ti, clone))) {
+		struct mapped_device *md = io->md;
+		int latch = get_swap_bios();
+		if (unlikely(latch != md->swap_bios))
+			__set_swap_bios_limit(md, latch);
+		down(&md->swap_bios_semaphore);
+	}
+
 	r = ti->type->map(ti, clone);
 	switch (r) {
 	case DM_MAPIO_SUBMITTED:
@@ -1281,10 +1325,18 @@ static blk_qc_t __map_bio(struct dm_targ
 		ret = submit_bio_noacct(clone);
 		break;
 	case DM_MAPIO_KILL:
+		if (unlikely(swap_bios_limit(ti, clone))) {
+			struct mapped_device *md = io->md;
+			up(&md->swap_bios_semaphore);
+		}
 		free_tio(tio);
 		dec_pending(io, BLK_STS_IOERR);
 		break;
 	case DM_MAPIO_REQUEUE:
+		if (unlikely(swap_bios_limit(ti, clone))) {
+			struct mapped_device *md = io->md;
+			up(&md->swap_bios_semaphore);
+		}
 		free_tio(tio);
 		dec_pending(io, BLK_STS_DM_REQUEUE);
 		break;
@@ -1747,6 +1799,7 @@ static void cleanup_mapped_device(struct
 	mutex_destroy(&md->suspend_lock);
 	mutex_destroy(&md->type_lock);
 	mutex_destroy(&md->table_devices_lock);
+	mutex_destroy(&md->swap_bios_lock);
 
 	dm_mq_cleanup_mapped_device(md);
 }
@@ -1814,6 +1867,10 @@ static struct mapped_device *alloc_dev(i
 	init_waitqueue_head(&md->eventq);
 	init_completion(&md->kobj_holder.completion);
 
+	md->swap_bios = get_swap_bios();
+	sema_init(&md->swap_bios_semaphore, md->swap_bios);
+	mutex_init(&md->swap_bios_lock);
+
 	md->disk->major = _major;
 	md->disk->first_minor = minor;
 	md->disk->fops = &dm_blk_dops;
@@ -3097,6 +3154,9 @@ MODULE_PARM_DESC(reserved_bio_based_ios,
 module_param(dm_numa_node, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(dm_numa_node, "NUMA node for DM device memory allocations");
 
+module_param(swap_bios, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(swap_bios, "Maximum allowed inflight swap IOs");
+
 MODULE_DESCRIPTION(DM_NAME " driver");
 MODULE_AUTHOR("Joe Thornber <dm-devel@redhat.com>");
 MODULE_LICENSE("GPL");
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -325,6 +325,11 @@ struct dm_target {
 	 * whether or not its underlying devices have support.
 	 */
 	bool discards_supported:1;
+
+	/*
+	 * Set if we need to limit the number of in-flight bios when swapping.
+	 */
+	bool limit_swap_bios:1;
 };
 
 void *dm_per_bio_data(struct bio *bio, size_t data_size);


