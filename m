Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54E6E134BEA
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728427AbgAHTsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:48:03 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43738 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730466AbgAHTqE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:04 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHD-0006ot-B8; Wed, 08 Jan 2020 19:45:59 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHC-007dnL-EN; Wed, 08 Jan 2020 19:45:58 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Christoph Hellwig" <hch@lst.de>, "Pavel Machek" <pavel@ucw.cz>,
        "Ming Lin" <mlin@kernel.org>, "Jens Axboe" <axboe@fb.com>
Date:   Wed, 08 Jan 2020 19:43:34 +0000
Message-ID: <lsq.1578512578.558399554@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 36/63] suspend: simplify block I/O handling
In-Reply-To: <lsq.1578512578.117275639@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.81-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit 343df3c79c62b644ce6ff5dff96c9e0be1ecb242 upstream.

Stop abusing struct page functionality and the swap end_io handler, and
instead add a modified version of the blk-lib.c bio_batch helpers.

Also move the block I/O code into swap.c as they are directly tied into
each other.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Pavel Machek <pavel@ucw.cz>
Tested-by: Ming Lin <mlin@kernel.org>
Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Rafael J. Wysocki <rjw@rjwysocki.net>
Signed-off-by: Jens Axboe <axboe@fb.com>
[bwh: Backported to 3.16 as dependency of commit f6cf0545ec69
 "PM / Hibernate: Call flush_icache_range() on pages restored in-place":
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/swap.h    |   1 -
 kernel/power/Makefile   |   3 +-
 kernel/power/block_io.c | 103 --------------------------
 kernel/power/power.h    |   9 ---
 kernel/power/swap.c     | 159 ++++++++++++++++++++++++++++++----------
 mm/page_io.c            |   2 +-
 6 files changed, 122 insertions(+), 155 deletions(-)
 delete mode 100644 kernel/power/block_io.c

--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -395,7 +395,6 @@ extern void end_swap_bio_write(struct bi
 extern int __swap_writepage(struct page *page, struct writeback_control *wbc,
 	void (*end_write_func)(struct bio *, int));
 extern int swap_set_page_dirty(struct page *page);
-extern void end_swap_bio_read(struct bio *bio, int err);
 
 int add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
 		unsigned long nr_pages, sector_t start_block);
--- a/kernel/power/Makefile
+++ b/kernel/power/Makefile
@@ -7,8 +7,7 @@ obj-$(CONFIG_VT_CONSOLE_SLEEP)	+= consol
 obj-$(CONFIG_FREEZER)		+= process.o
 obj-$(CONFIG_SUSPEND)		+= suspend.o
 obj-$(CONFIG_PM_TEST_SUSPEND)	+= suspend_test.o
-obj-$(CONFIG_HIBERNATION)	+= hibernate.o snapshot.o swap.o user.o \
-				   block_io.o
+obj-$(CONFIG_HIBERNATION)	+= hibernate.o snapshot.o swap.o user.o
 obj-$(CONFIG_PM_AUTOSLEEP)	+= autosleep.o
 obj-$(CONFIG_PM_WAKELOCKS)	+= wakelock.o
 
--- a/kernel/power/block_io.c
+++ /dev/null
@@ -1,103 +0,0 @@
-/*
- * This file provides functions for block I/O operations on swap/file.
- *
- * Copyright (C) 1998,2001-2005 Pavel Machek <pavel@ucw.cz>
- * Copyright (C) 2006 Rafael J. Wysocki <rjw@sisk.pl>
- *
- * This file is released under the GPLv2.
- */
-
-#include <linux/bio.h>
-#include <linux/kernel.h>
-#include <linux/pagemap.h>
-#include <linux/swap.h>
-
-#include "power.h"
-
-/**
- *	submit - submit BIO request.
- *	@rw:	READ or WRITE.
- *	@off	physical offset of page.
- *	@page:	page we're reading or writing.
- *	@bio_chain: list of pending biod (for async reading)
- *
- *	Straight from the textbook - allocate and initialize the bio.
- *	If we're reading, make sure the page is marked as dirty.
- *	Then submit it and, if @bio_chain == NULL, wait.
- */
-static int submit(int rw, struct block_device *bdev, sector_t sector,
-		struct page *page, struct bio **bio_chain)
-{
-	const int bio_rw = rw | REQ_SYNC;
-	struct bio *bio;
-
-	bio = bio_alloc(__GFP_WAIT | __GFP_HIGH, 1);
-	bio->bi_iter.bi_sector = sector;
-	bio->bi_bdev = bdev;
-	bio->bi_end_io = end_swap_bio_read;
-
-	if (bio_add_page(bio, page, PAGE_SIZE, 0) < PAGE_SIZE) {
-		printk(KERN_ERR "PM: Adding page to bio failed at %llu\n",
-			(unsigned long long)sector);
-		bio_put(bio);
-		return -EFAULT;
-	}
-
-	lock_page(page);
-	bio_get(bio);
-
-	if (bio_chain == NULL) {
-		submit_bio(bio_rw, bio);
-		wait_on_page_locked(page);
-		if (rw == READ)
-			bio_set_pages_dirty(bio);
-		bio_put(bio);
-	} else {
-		if (rw == READ)
-			get_page(page);	/* These pages are freed later */
-		bio->bi_private = *bio_chain;
-		*bio_chain = bio;
-		submit_bio(bio_rw, bio);
-	}
-	return 0;
-}
-
-int hib_bio_read_page(pgoff_t page_off, void *addr, struct bio **bio_chain)
-{
-	return submit(READ, hib_resume_bdev, page_off * (PAGE_SIZE >> 9),
-			virt_to_page(addr), bio_chain);
-}
-
-int hib_bio_write_page(pgoff_t page_off, void *addr, struct bio **bio_chain)
-{
-	return submit(WRITE, hib_resume_bdev, page_off * (PAGE_SIZE >> 9),
-			virt_to_page(addr), bio_chain);
-}
-
-int hib_wait_on_bio_chain(struct bio **bio_chain)
-{
-	struct bio *bio;
-	struct bio *next_bio;
-	int ret = 0;
-
-	if (bio_chain == NULL)
-		return 0;
-
-	bio = *bio_chain;
-	if (bio == NULL)
-		return 0;
-	while (bio) {
-		struct page *page;
-
-		next_bio = bio->bi_private;
-		page = bio->bi_io_vec[0].bv_page;
-		wait_on_page_locked(page);
-		if (!PageUptodate(page) || PageError(page))
-			ret = -EIO;
-		put_page(page);
-		bio_put(bio);
-		bio = next_bio;
-	}
-	*bio_chain = NULL;
-	return ret;
-}
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -163,15 +163,6 @@ extern void swsusp_close(fmode_t);
 extern int swsusp_unmark(void);
 #endif
 
-/* kernel/power/block_io.c */
-extern struct block_device *hib_resume_bdev;
-
-extern int hib_bio_read_page(pgoff_t page_off, void *addr,
-		struct bio **bio_chain);
-extern int hib_bio_write_page(pgoff_t page_off, void *addr,
-		struct bio **bio_chain);
-extern int hib_wait_on_bio_chain(struct bio **bio_chain);
-
 struct timeval;
 /* kernel/power/swsusp.c */
 extern void swsusp_show_speed(struct timeval *, struct timeval *,
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -211,7 +211,84 @@ int swsusp_swap_in_use(void)
  */
 
 static unsigned short root_swap = 0xffff;
-struct block_device *hib_resume_bdev;
+static struct block_device *hib_resume_bdev;
+
+struct hib_bio_batch {
+	atomic_t		count;
+	wait_queue_head_t	wait;
+	int			error;
+};
+
+static void hib_init_batch(struct hib_bio_batch *hb)
+{
+	atomic_set(&hb->count, 0);
+	init_waitqueue_head(&hb->wait);
+	hb->error = 0;
+}
+
+static void hib_end_io(struct bio *bio, int error)
+{
+	struct hib_bio_batch *hb = bio->bi_private;
+	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
+	struct page *page = bio->bi_io_vec[0].bv_page;
+
+	if (!uptodate || error) {
+		printk(KERN_ALERT "Read-error on swap-device (%u:%u:%Lu)\n",
+				imajor(bio->bi_bdev->bd_inode),
+				iminor(bio->bi_bdev->bd_inode),
+				(unsigned long long)bio->bi_iter.bi_sector);
+
+		if (!error)
+			error = -EIO;
+	}
+
+	if (bio_data_dir(bio) == WRITE)
+		put_page(page);
+
+	if (error && !hb->error)
+		hb->error = error;
+	if (atomic_dec_and_test(&hb->count))
+		wake_up(&hb->wait);
+
+	bio_put(bio);
+}
+
+static int hib_submit_io(int rw, pgoff_t page_off, void *addr,
+		struct hib_bio_batch *hb)
+{
+	struct page *page = virt_to_page(addr);
+	struct bio *bio;
+	int error = 0;
+
+	bio = bio_alloc(__GFP_WAIT | __GFP_HIGH, 1);
+	bio->bi_iter.bi_sector = page_off * (PAGE_SIZE >> 9);
+	bio->bi_bdev = hib_resume_bdev;
+
+	if (bio_add_page(bio, page, PAGE_SIZE, 0) < PAGE_SIZE) {
+		printk(KERN_ERR "PM: Adding page to bio failed at %llu\n",
+			(unsigned long long)bio->bi_iter.bi_sector);
+		bio_put(bio);
+		return -EFAULT;
+	}
+
+	if (hb) {
+		bio->bi_end_io = hib_end_io;
+		bio->bi_private = hb;
+		atomic_inc(&hb->count);
+		submit_bio(rw, bio);
+	} else {
+		error = submit_bio_wait(rw, bio);
+		bio_put(bio);
+	}
+
+	return error;
+}
+
+static int hib_wait_io(struct hib_bio_batch *hb)
+{
+	wait_event(hb->wait, atomic_read(&hb->count) == 0);
+	return hb->error;
+}
 
 /*
  * Saving part
@@ -221,7 +298,7 @@ static int mark_swapfiles(struct swap_ma
 {
 	int error;
 
-	hib_bio_read_page(swsusp_resume_block, swsusp_header, NULL);
+	hib_submit_io(READ_SYNC, swsusp_resume_block, swsusp_header, NULL);
 	if (!memcmp("SWAP-SPACE",swsusp_header->sig, 10) ||
 	    !memcmp("SWAPSPACE2",swsusp_header->sig, 10)) {
 		memcpy(swsusp_header->orig_sig,swsusp_header->sig, 10);
@@ -230,7 +307,7 @@ static int mark_swapfiles(struct swap_ma
 		swsusp_header->flags = flags;
 		if (flags & SF_CRC32_MODE)
 			swsusp_header->crc32 = handle->crc32;
-		error = hib_bio_write_page(swsusp_resume_block,
+		error = hib_submit_io(WRITE_SYNC, swsusp_resume_block,
 					swsusp_header, NULL);
 	} else {
 		printk(KERN_ERR "PM: Swap header not found!\n");
@@ -270,10 +347,10 @@ static int swsusp_swap_check(void)
  *	write_page - Write one page to given swap location.
  *	@buf:		Address we're writing.
  *	@offset:	Offset of the swap page we're writing to.
- *	@bio_chain:	Link the next write BIO here
+ *	@hb:		bio completion batch
  */
 
-static int write_page(void *buf, sector_t offset, struct bio **bio_chain)
+static int write_page(void *buf, sector_t offset, struct hib_bio_batch *hb)
 {
 	void *src;
 	int ret;
@@ -281,13 +358,13 @@ static int write_page(void *buf, sector_
 	if (!offset)
 		return -ENOSPC;
 
-	if (bio_chain) {
+	if (hb) {
 		src = (void *)__get_free_page(__GFP_WAIT | __GFP_NOWARN |
 		                              __GFP_NORETRY);
 		if (src) {
 			copy_page(src, buf);
 		} else {
-			ret = hib_wait_on_bio_chain(bio_chain); /* Free pages */
+			ret = hib_wait_io(hb); /* Free pages */
 			if (ret)
 				return ret;
 			src = (void *)__get_free_page(__GFP_WAIT |
@@ -297,14 +374,14 @@ static int write_page(void *buf, sector_
 				copy_page(src, buf);
 			} else {
 				WARN_ON_ONCE(1);
-				bio_chain = NULL;	/* Go synchronous */
+				hb = NULL;	/* Go synchronous */
 				src = buf;
 			}
 		}
 	} else {
 		src = buf;
 	}
-	return hib_bio_write_page(offset, src, bio_chain);
+	return hib_submit_io(WRITE_SYNC, offset, src, hb);
 }
 
 static void release_swap_writer(struct swap_map_handle *handle)
@@ -347,7 +424,7 @@ err_close:
 }
 
 static int swap_write_page(struct swap_map_handle *handle, void *buf,
-				struct bio **bio_chain)
+		struct hib_bio_batch *hb)
 {
 	int error = 0;
 	sector_t offset;
@@ -355,7 +432,7 @@ static int swap_write_page(struct swap_m
 	if (!handle->cur)
 		return -EINVAL;
 	offset = alloc_swapdev_block(root_swap);
-	error = write_page(buf, offset, bio_chain);
+	error = write_page(buf, offset, hb);
 	if (error)
 		return error;
 	handle->cur->entries[handle->k++] = offset;
@@ -364,15 +441,15 @@ static int swap_write_page(struct swap_m
 		if (!offset)
 			return -ENOSPC;
 		handle->cur->next_swap = offset;
-		error = write_page(handle->cur, handle->cur_swap, bio_chain);
+		error = write_page(handle->cur, handle->cur_swap, hb);
 		if (error)
 			goto out;
 		clear_page(handle->cur);
 		handle->cur_swap = offset;
 		handle->k = 0;
 
-		if (bio_chain && low_free_pages() <= handle->reqd_free_pages) {
-			error = hib_wait_on_bio_chain(bio_chain);
+		if (hb && low_free_pages() <= handle->reqd_free_pages) {
+			error = hib_wait_io(hb);
 			if (error)
 				goto out;
 			/*
@@ -444,23 +521,24 @@ static int save_image(struct swap_map_ha
 	int ret;
 	int nr_pages;
 	int err2;
-	struct bio *bio;
+	struct hib_bio_batch hb;
 	struct timeval start;
 	struct timeval stop;
 
+	hib_init_batch(&hb);
+
 	printk(KERN_INFO "PM: Saving image data pages (%u pages)...\n",
 		nr_to_write);
 	m = nr_to_write / 10;
 	if (!m)
 		m = 1;
 	nr_pages = 0;
-	bio = NULL;
 	do_gettimeofday(&start);
 	while (1) {
 		ret = snapshot_read_next(snapshot);
 		if (ret <= 0)
 			break;
-		ret = swap_write_page(handle, data_of(*snapshot), &bio);
+		ret = swap_write_page(handle, data_of(*snapshot), &hb);
 		if (ret)
 			break;
 		if (!(nr_pages % m))
@@ -468,7 +546,7 @@ static int save_image(struct swap_map_ha
 			       nr_pages / m * 10);
 		nr_pages++;
 	}
-	err2 = hib_wait_on_bio_chain(&bio);
+	err2 = hib_wait_io(&hb);
 	do_gettimeofday(&stop);
 	if (!ret)
 		ret = err2;
@@ -579,7 +657,7 @@ static int save_image_lzo(struct swap_ma
 	int ret = 0;
 	int nr_pages;
 	int err2;
-	struct bio *bio;
+	struct hib_bio_batch hb;
 	struct timeval start;
 	struct timeval stop;
 	size_t off;
@@ -588,6 +666,8 @@ static int save_image_lzo(struct swap_ma
 	struct cmp_data *data = NULL;
 	struct crc_data *crc = NULL;
 
+	hib_init_batch(&hb);
+
 	/*
 	 * We'll limit the number of threads for compression to limit memory
 	 * footprint.
@@ -673,7 +753,6 @@ static int save_image_lzo(struct swap_ma
 	if (!m)
 		m = 1;
 	nr_pages = 0;
-	bio = NULL;
 	do_gettimeofday(&start);
 	for (;;) {
 		for (thr = 0; thr < nr_threads; thr++) {
@@ -747,7 +826,7 @@ static int save_image_lzo(struct swap_ma
 			     off += PAGE_SIZE) {
 				memcpy(page, data[thr].cmp + off, PAGE_SIZE);
 
-				ret = swap_write_page(handle, page, &bio);
+				ret = swap_write_page(handle, page, &hb);
 				if (ret)
 					goto out_finish;
 			}
@@ -758,7 +837,7 @@ static int save_image_lzo(struct swap_ma
 	}
 
 out_finish:
-	err2 = hib_wait_on_bio_chain(&bio);
+	err2 = hib_wait_io(&hb);
 	do_gettimeofday(&stop);
 	if (!ret)
 		ret = err2;
@@ -905,7 +984,7 @@ static int get_swap_reader(struct swap_m
 			return -ENOMEM;
 		}
 
-		error = hib_bio_read_page(offset, tmp->map, NULL);
+		error = hib_submit_io(READ_SYNC, offset, tmp->map, NULL);
 		if (error) {
 			release_swap_reader(handle);
 			return error;
@@ -918,7 +997,7 @@ static int get_swap_reader(struct swap_m
 }
 
 static int swap_read_page(struct swap_map_handle *handle, void *buf,
-				struct bio **bio_chain)
+		struct hib_bio_batch *hb)
 {
 	sector_t offset;
 	int error;
@@ -929,7 +1008,7 @@ static int swap_read_page(struct swap_ma
 	offset = handle->cur->entries[handle->k];
 	if (!offset)
 		return -EFAULT;
-	error = hib_bio_read_page(offset, buf, bio_chain);
+	error = hib_submit_io(READ_SYNC, offset, buf, hb);
 	if (error)
 		return error;
 	if (++handle->k >= MAP_PAGE_ENTRIES) {
@@ -967,27 +1046,28 @@ static int load_image(struct swap_map_ha
 	int ret = 0;
 	struct timeval start;
 	struct timeval stop;
-	struct bio *bio;
+	struct hib_bio_batch hb;
 	int err2;
 	unsigned nr_pages;
 
+	hib_init_batch(&hb);
+
 	printk(KERN_INFO "PM: Loading image data pages (%u pages)...\n",
 		nr_to_read);
 	m = nr_to_read / 10;
 	if (!m)
 		m = 1;
 	nr_pages = 0;
-	bio = NULL;
 	do_gettimeofday(&start);
 	for ( ; ; ) {
 		ret = snapshot_write_next(snapshot);
 		if (ret <= 0)
 			break;
-		ret = swap_read_page(handle, data_of(*snapshot), &bio);
+		ret = swap_read_page(handle, data_of(*snapshot), &hb);
 		if (ret)
 			break;
 		if (snapshot->sync_read)
-			ret = hib_wait_on_bio_chain(&bio);
+			ret = hib_wait_io(&hb);
 		if (ret)
 			break;
 		if (!(nr_pages % m))
@@ -995,7 +1075,7 @@ static int load_image(struct swap_map_ha
 			       nr_pages / m * 10);
 		nr_pages++;
 	}
-	err2 = hib_wait_on_bio_chain(&bio);
+	err2 = hib_wait_io(&hb);
 	do_gettimeofday(&stop);
 	if (!ret)
 		ret = err2;
@@ -1066,7 +1146,7 @@ static int load_image_lzo(struct swap_ma
 	unsigned int m;
 	int ret = 0;
 	int eof = 0;
-	struct bio *bio;
+	struct hib_bio_batch hb;
 	struct timeval start;
 	struct timeval stop;
 	unsigned nr_pages;
@@ -1079,6 +1159,8 @@ static int load_image_lzo(struct swap_ma
 	struct dec_data *data = NULL;
 	struct crc_data *crc = NULL;
 
+	hib_init_batch(&hb);
+
 	/*
 	 * We'll limit the number of threads for decompression to limit memory
 	 * footprint.
@@ -1189,7 +1271,6 @@ static int load_image_lzo(struct swap_ma
 	if (!m)
 		m = 1;
 	nr_pages = 0;
-	bio = NULL;
 	do_gettimeofday(&start);
 
 	ret = snapshot_write_next(snapshot);
@@ -1198,7 +1279,7 @@ static int load_image_lzo(struct swap_ma
 
 	for(;;) {
 		for (i = 0; !eof && i < want; i++) {
-			ret = swap_read_page(handle, page[ring], &bio);
+			ret = swap_read_page(handle, page[ring], &hb);
 			if (ret) {
 				/*
 				 * On real read error, finish. On end of data,
@@ -1225,7 +1306,7 @@ static int load_image_lzo(struct swap_ma
 			if (!asked)
 				break;
 
-			ret = hib_wait_on_bio_chain(&bio);
+			ret = hib_wait_io(&hb);
 			if (ret)
 				goto out_finish;
 			have += asked;
@@ -1280,7 +1361,7 @@ static int load_image_lzo(struct swap_ma
 		 * Wait for more data while we are decompressing.
 		 */
 		if (have < LZO_CMP_PAGES && asked) {
-			ret = hib_wait_on_bio_chain(&bio);
+			ret = hib_wait_io(&hb);
 			if (ret)
 				goto out_finish;
 			have += asked;
@@ -1429,7 +1510,7 @@ int swsusp_check(void)
 	if (!IS_ERR(hib_resume_bdev)) {
 		set_blocksize(hib_resume_bdev, PAGE_SIZE);
 		clear_page(swsusp_header);
-		error = hib_bio_read_page(swsusp_resume_block,
+		error = hib_submit_io(READ_SYNC, swsusp_resume_block,
 					swsusp_header, NULL);
 		if (error)
 			goto put;
@@ -1437,7 +1518,7 @@ int swsusp_check(void)
 		if (!memcmp(HIBERNATE_SIG, swsusp_header->sig, 10)) {
 			memcpy(swsusp_header->sig, swsusp_header->orig_sig, 10);
 			/* Reset swap signature now */
-			error = hib_bio_write_page(swsusp_resume_block,
+			error = hib_submit_io(WRITE_SYNC, swsusp_resume_block,
 						swsusp_header, NULL);
 		} else {
 			error = -EINVAL;
@@ -1481,10 +1562,10 @@ int swsusp_unmark(void)
 {
 	int error;
 
-	hib_bio_read_page(swsusp_resume_block, swsusp_header, NULL);
+	hib_submit_io(READ_SYNC, swsusp_resume_block, swsusp_header, NULL);
 	if (!memcmp(HIBERNATE_SIG,swsusp_header->sig, 10)) {
 		memcpy(swsusp_header->sig,swsusp_header->orig_sig, 10);
-		error = hib_bio_write_page(swsusp_resume_block,
+		error = hib_submit_io(WRITE_SYNC, swsusp_resume_block,
 					swsusp_header, NULL);
 	} else {
 		printk(KERN_ERR "PM: Cannot find swsusp signature!\n");
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -69,7 +69,7 @@ void end_swap_bio_write(struct bio *bio,
 	bio_put(bio);
 }
 
-void end_swap_bio_read(struct bio *bio, int err)
+static void end_swap_bio_read(struct bio *bio, int err)
 {
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct page *page = bio->bi_io_vec[0].bv_page;

