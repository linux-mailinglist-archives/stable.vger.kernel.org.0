Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1FB12E7958
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 14:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727373AbgL3NFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 08:05:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:53770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727365AbgL3NFN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 08:05:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F63A22B40;
        Wed, 30 Dec 2020 13:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609333457;
        bh=BAwWTRPZswlWjIFxIaEQzSDhqtA/FklM4VGm/xkLLxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q69ZlGtgc7ZjZEI/WwGpCfC2jIIwIl87aWbg55p7Jh+i4efC8eCR1nWnFbrFYDO3a
         RYh1iToa+C6paro0/g+lY2Osc0JwOeXyigejVtoVVEmOiy4YpQ4eaIpb+bX4NLW86g
         cRgKl20VUu4xTxXb1l4oqCD+5GmuMM9VZjBb2PCzNsNEbZ1sxjrKW6eXHD+HtD5K5t
         uiw6iNBNTq4dZhyWkFwpOnhM3hVaO+AvkflfSV5Atyu7d5ws55cyVaqH3BcanFC/It
         GZ8qBJov1+t0x/c2EvSokk/bwWiOa2uTqKcjrOYTjE/a5nvC3p7d0mksnCUiaLP3Ro
         KWlu7e+8X3S2w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gabriel Krisman Bertazi <krisman@collabora.com>,
        Christopher Obbard <chris.obbard@collabora.com>,
        Martyn Welch <martyn@collabora.com>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>, linux-um@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 14/17] um: ubd: Submit all data segments atomically
Date:   Wed, 30 Dec 2020 08:03:54 -0500
Message-Id: <20201230130357.3637261-14-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201230130357.3637261-1-sashal@kernel.org>
References: <20201230130357.3637261-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gabriel Krisman Bertazi <krisman@collabora.com>

[ Upstream commit fc6b6a872dcd48c6f39c7975836d75113db67d37 ]

Internally, UBD treats each physical IO segment as a separate command to
be submitted in the execution pipe.  If the pipe returns a transient
error after a few segments have already been written, UBD will tell the
block layer to requeue the request, but there is no way to reclaim the
segments already submitted.  When a new attempt to dispatch the request
is done, those segments already submitted will get duplicated, causing
the WARN_ON below in the best case, and potentially data corruption.

In my system, running a UML instance with 2GB of RAM and a 50M UBD disk,
I can reproduce the WARN_ON by simply running mkfs.fvat against the
disk on a freshly booted system.

There are a few ways to around this, like reducing the pressure on
the pipe by reducing the queue depth, which almost eliminates the
occurrence of the problem, increasing the pipe buffer size on the host
system, or by limiting the request to one physical segment, which causes
the block layer to submit way more requests to resolve a single
operation.

Instead, this patch modifies the format of a UBD command, such that all
segments are sent through a single element in the communication pipe,
turning the command submission atomic from the point of view of the
block layer.  The new format has a variable size, depending on the
number of elements, and looks like this:

+------------+-----------+-----------+------------
| cmd_header | segment 0 | segment 1 | segment ...
+------------+-----------+-----------+------------

With this format, we push a pointer to cmd_header in the submission
pipe.

This has the advantage of reducing the memory footprint of executing a
single request, since it allow us to merge some fields in the header.
It is possible to reduce even further each segment memory footprint, by
merging bitmap_words and cow_offset, for instance, but this is not the
focus of this patch and is left as future work.  One issue with the
patch is that for a big number of segments, we now perform one big
memory allocation instead of multiple small ones, but I wasn't able to
trigger any real issues or -ENOMEM because of this change, that wouldn't
be reproduced otherwise.

This was tested using fio with the verify-crc32 option, and by running
an ext4 filesystem over this UBD device.

The original WARN_ON was:

------------[ cut here ]------------
WARNING: CPU: 0 PID: 0 at lib/refcount.c:28 refcount_warn_saturate+0x13f/0x141
refcount_t: underflow; use-after-free.
Modules linked in:
CPU: 0 PID: 0 Comm: swapper Not tainted 5.5.0-rc6-00002-g2a5bb2cf75c8 #346
Stack:
 6084eed0 6063dc77 00000009 6084ef60
 00000000 604b8d9f 6084eee0 6063dcbc
 6084ef40 6006ab8d e013d780 1c00000000
Call Trace:
 [<600a0c1c>] ? printk+0x0/0x94
 [<6004a888>] show_stack+0x13b/0x155
 [<6063dc77>] ? dump_stack_print_info+0xdf/0xe8
 [<604b8d9f>] ? refcount_warn_saturate+0x13f/0x141
 [<6063dcbc>] dump_stack+0x2a/0x2c
 [<6006ab8d>] __warn+0x107/0x134
 [<6008da6c>] ? wake_up_process+0x17/0x19
 [<60487628>] ? blk_queue_max_discard_sectors+0x0/0xd
 [<6006b05f>] warn_slowpath_fmt+0xd1/0xdf
 [<6006af8e>] ? warn_slowpath_fmt+0x0/0xdf
 [<600acc14>] ? raw_read_seqcount_begin.constprop.0+0x0/0x15
 [<600619ae>] ? os_nsecs+0x1d/0x2b
 [<604b8d9f>] refcount_warn_saturate+0x13f/0x141
 [<6048bc8f>] refcount_sub_and_test.constprop.0+0x2f/0x37
 [<6048c8de>] blk_mq_free_request+0xf1/0x10d
 [<6048ca06>] __blk_mq_end_request+0x10c/0x114
 [<6005ac0f>] ubd_intr+0xb5/0x169
 [<600a1a37>] __handle_irq_event_percpu+0x6b/0x17e
 [<600a1b70>] handle_irq_event_percpu+0x26/0x69
 [<600a1bd9>] handle_irq_event+0x26/0x34
 [<600a1bb3>] ? handle_irq_event+0x0/0x34
 [<600a5186>] ? unmask_irq+0x0/0x37
 [<600a57e6>] handle_edge_irq+0xbc/0xd6
 [<600a131a>] generic_handle_irq+0x21/0x29
 [<60048f6e>] do_IRQ+0x39/0x54
 [...]
---[ end trace c6e7444e55386c0f ]---

Cc: Christopher Obbard <chris.obbard@collabora.com>
Reported-by: Martyn Welch <martyn@collabora.com>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Tested-by: Christopher Obbard <chris.obbard@collabora.com>
Acked-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/ubd_kern.c | 191 ++++++++++++++++++++++---------------
 1 file changed, 115 insertions(+), 76 deletions(-)

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 0f5d0a699a49b..4e59ab817d3e7 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -47,18 +47,25 @@
 /* Max request size is determined by sector mask - 32K */
 #define UBD_MAX_REQUEST (8 * sizeof(long))
 
+struct io_desc {
+	char *buffer;
+	unsigned long length;
+	unsigned long sector_mask;
+	unsigned long long cow_offset;
+	unsigned long bitmap_words[2];
+};
+
 struct io_thread_req {
 	struct request *req;
 	int fds[2];
 	unsigned long offsets[2];
 	unsigned long long offset;
-	unsigned long length;
-	char *buffer;
 	int sectorsize;
-	unsigned long sector_mask;
-	unsigned long long cow_offset;
-	unsigned long bitmap_words[2];
 	int error;
+
+	int desc_cnt;
+	/* io_desc has to be the last element of the struct */
+	struct io_desc io_desc[];
 };
 
 
@@ -524,12 +531,7 @@ static void ubd_handler(void)
 				blk_queue_max_write_zeroes_sectors(io_req->req->q, 0);
 				blk_queue_flag_clear(QUEUE_FLAG_DISCARD, io_req->req->q);
 			}
-			if ((io_req->error) || (io_req->buffer == NULL))
-				blk_mq_end_request(io_req->req, io_req->error);
-			else {
-				if (!blk_update_request(io_req->req, io_req->error, io_req->length))
-					__blk_mq_end_request(io_req->req, io_req->error);
-			}
+			blk_mq_end_request(io_req->req, io_req->error);
 			kfree(io_req);
 		}
 	}
@@ -945,6 +947,7 @@ static int ubd_add(int n, char **error_out)
 	blk_queue_write_cache(ubd_dev->queue, true, false);
 
 	blk_queue_max_segments(ubd_dev->queue, MAX_SG);
+	blk_queue_segment_boundary(ubd_dev->queue, PAGE_SIZE - 1);
 	err = ubd_disk_register(UBD_MAJOR, ubd_dev->size, n, &ubd_gendisk[n]);
 	if(err){
 		*error_out = "Failed to register device";
@@ -1288,37 +1291,74 @@ static void cowify_bitmap(__u64 io_offset, int length, unsigned long *cow_mask,
 	*cow_offset += bitmap_offset;
 }
 
-static void cowify_req(struct io_thread_req *req, unsigned long *bitmap,
+static void cowify_req(struct io_thread_req *req, struct io_desc *segment,
+		       unsigned long offset, unsigned long *bitmap,
 		       __u64 bitmap_offset, __u64 bitmap_len)
 {
-	__u64 sector = req->offset >> SECTOR_SHIFT;
+	__u64 sector = offset >> SECTOR_SHIFT;
 	int i;
 
-	if (req->length > (sizeof(req->sector_mask) * 8) << SECTOR_SHIFT)
+	if (segment->length > (sizeof(segment->sector_mask) * 8) << SECTOR_SHIFT)
 		panic("Operation too long");
 
 	if (req_op(req->req) == REQ_OP_READ) {
-		for (i = 0; i < req->length >> SECTOR_SHIFT; i++) {
+		for (i = 0; i < segment->length >> SECTOR_SHIFT; i++) {
 			if(ubd_test_bit(sector + i, (unsigned char *) bitmap))
 				ubd_set_bit(i, (unsigned char *)
-					    &req->sector_mask);
+					    &segment->sector_mask);
+		}
+	} else {
+		cowify_bitmap(offset, segment->length, &segment->sector_mask,
+			      &segment->cow_offset, bitmap, bitmap_offset,
+			      segment->bitmap_words, bitmap_len);
+	}
+}
+
+static void ubd_map_req(struct ubd *dev, struct io_thread_req *io_req,
+			struct request *req)
+{
+	struct bio_vec bvec;
+	struct req_iterator iter;
+	int i = 0;
+	unsigned long byte_offset = io_req->offset;
+	int op = req_op(req);
+
+	if (op == REQ_OP_WRITE_ZEROES || op == REQ_OP_DISCARD) {
+		io_req->io_desc[0].buffer = NULL;
+		io_req->io_desc[0].length = blk_rq_bytes(req);
+	} else {
+		rq_for_each_segment(bvec, req, iter) {
+			BUG_ON(i >= io_req->desc_cnt);
+
+			io_req->io_desc[i].buffer =
+				page_address(bvec.bv_page) + bvec.bv_offset;
+			io_req->io_desc[i].length = bvec.bv_len;
+			i++;
+		}
+	}
+
+	if (dev->cow.file) {
+		for (i = 0; i < io_req->desc_cnt; i++) {
+			cowify_req(io_req, &io_req->io_desc[i], byte_offset,
+				   dev->cow.bitmap, dev->cow.bitmap_offset,
+				   dev->cow.bitmap_len);
+			byte_offset += io_req->io_desc[i].length;
 		}
+
 	}
-	else cowify_bitmap(req->offset, req->length, &req->sector_mask,
-			   &req->cow_offset, bitmap, bitmap_offset,
-			   req->bitmap_words, bitmap_len);
 }
 
-static int ubd_queue_one_vec(struct blk_mq_hw_ctx *hctx, struct request *req,
-		u64 off, struct bio_vec *bvec)
+static struct io_thread_req *ubd_alloc_req(struct ubd *dev, struct request *req,
+					   int desc_cnt)
 {
-	struct ubd *dev = hctx->queue->queuedata;
 	struct io_thread_req *io_req;
-	int ret;
+	int i;
 
-	io_req = kmalloc(sizeof(struct io_thread_req), GFP_ATOMIC);
+	io_req = kmalloc(sizeof(*io_req) +
+			 (desc_cnt * sizeof(struct io_desc)),
+			 GFP_ATOMIC);
 	if (!io_req)
-		return -ENOMEM;
+		return NULL;
 
 	io_req->req = req;
 	if (dev->cow.file)
@@ -1326,26 +1366,41 @@ static int ubd_queue_one_vec(struct blk_mq_hw_ctx *hctx, struct request *req,
 	else
 		io_req->fds[0] = dev->fd;
 	io_req->error = 0;
-
-	if (bvec != NULL) {
-		io_req->buffer = page_address(bvec->bv_page) + bvec->bv_offset;
-		io_req->length = bvec->bv_len;
-	} else {
-		io_req->buffer = NULL;
-		io_req->length = blk_rq_bytes(req);
-	}
-
 	io_req->sectorsize = SECTOR_SIZE;
 	io_req->fds[1] = dev->fd;
-	io_req->cow_offset = -1;
-	io_req->offset = off;
-	io_req->sector_mask = 0;
+	io_req->offset = (u64) blk_rq_pos(req) << SECTOR_SHIFT;
 	io_req->offsets[0] = 0;
 	io_req->offsets[1] = dev->cow.data_offset;
 
-	if (dev->cow.file)
-		cowify_req(io_req, dev->cow.bitmap,
-			   dev->cow.bitmap_offset, dev->cow.bitmap_len);
+	for (i = 0 ; i < desc_cnt; i++) {
+		io_req->io_desc[i].sector_mask = 0;
+		io_req->io_desc[i].cow_offset = -1;
+	}
+
+	return io_req;
+}
+
+static int ubd_submit_request(struct ubd *dev, struct request *req)
+{
+	int segs = 0;
+	struct io_thread_req *io_req;
+	int ret;
+	int op = req_op(req);
+
+	if (op == REQ_OP_FLUSH)
+		segs = 0;
+	else if (op == REQ_OP_WRITE_ZEROES || op == REQ_OP_DISCARD)
+		segs = 1;
+	else
+		segs = blk_rq_nr_phys_segments(req);
+
+	io_req = ubd_alloc_req(dev, req, segs);
+	if (!io_req)
+		return -ENOMEM;
+
+	io_req->desc_cnt = segs;
+	if (segs)
+		ubd_map_req(dev, io_req, req);
 
 	ret = os_write_file(thread_fd, &io_req, sizeof(io_req));
 	if (ret != sizeof(io_req)) {
@@ -1356,22 +1411,6 @@ static int ubd_queue_one_vec(struct blk_mq_hw_ctx *hctx, struct request *req,
 	return ret;
 }
 
-static int queue_rw_req(struct blk_mq_hw_ctx *hctx, struct request *req)
-{
-	struct req_iterator iter;
-	struct bio_vec bvec;
-	int ret;
-	u64 off = (u64)blk_rq_pos(req) << SECTOR_SHIFT;
-
-	rq_for_each_segment(bvec, req, iter) {
-		ret = ubd_queue_one_vec(hctx, req, off, &bvec);
-		if (ret < 0)
-			return ret;
-		off += bvec.bv_len;
-	}
-	return 0;
-}
-
 static blk_status_t ubd_queue_rq(struct blk_mq_hw_ctx *hctx,
 				 const struct blk_mq_queue_data *bd)
 {
@@ -1384,17 +1423,12 @@ static blk_status_t ubd_queue_rq(struct blk_mq_hw_ctx *hctx,
 	spin_lock_irq(&ubd_dev->lock);
 
 	switch (req_op(req)) {
-	/* operations with no lentgth/offset arguments */
 	case REQ_OP_FLUSH:
-		ret = ubd_queue_one_vec(hctx, req, 0, NULL);
-		break;
 	case REQ_OP_READ:
 	case REQ_OP_WRITE:
-		ret = queue_rw_req(hctx, req);
-		break;
 	case REQ_OP_DISCARD:
 	case REQ_OP_WRITE_ZEROES:
-		ret = ubd_queue_one_vec(hctx, req, (u64)blk_rq_pos(req) << 9, NULL);
+		ret = ubd_submit_request(ubd_dev, req);
 		break;
 	default:
 		WARN_ON_ONCE(1);
@@ -1482,22 +1516,22 @@ static int map_error(int error_code)
  * will result in unpredictable behaviour and/or crashes.
  */
 
-static int update_bitmap(struct io_thread_req *req)
+static int update_bitmap(struct io_thread_req *req, struct io_desc *segment)
 {
 	int n;
 
-	if(req->cow_offset == -1)
+	if (segment->cow_offset == -1)
 		return map_error(0);
 
-	n = os_pwrite_file(req->fds[1], &req->bitmap_words,
-			  sizeof(req->bitmap_words), req->cow_offset);
-	if (n != sizeof(req->bitmap_words))
+	n = os_pwrite_file(req->fds[1], &segment->bitmap_words,
+			  sizeof(segment->bitmap_words), segment->cow_offset);
+	if (n != sizeof(segment->bitmap_words))
 		return map_error(-n);
 
 	return map_error(0);
 }
 
-static void do_io(struct io_thread_req *req)
+static void do_io(struct io_thread_req *req, struct io_desc *desc)
 {
 	char *buf = NULL;
 	unsigned long len;
@@ -1512,21 +1546,20 @@ static void do_io(struct io_thread_req *req)
 		return;
 	}
 
-	nsectors = req->length / req->sectorsize;
+	nsectors = desc->length / req->sectorsize;
 	start = 0;
 	do {
-		bit = ubd_test_bit(start, (unsigned char *) &req->sector_mask);
+		bit = ubd_test_bit(start, (unsigned char *) &desc->sector_mask);
 		end = start;
 		while((end < nsectors) &&
-		      (ubd_test_bit(end, (unsigned char *)
-				    &req->sector_mask) == bit))
+		      (ubd_test_bit(end, (unsigned char *) &desc->sector_mask) == bit))
 			end++;
 
 		off = req->offset + req->offsets[bit] +
 			start * req->sectorsize;
 		len = (end - start) * req->sectorsize;
-		if (req->buffer != NULL)
-			buf = &req->buffer[start * req->sectorsize];
+		if (desc->buffer != NULL)
+			buf = &desc->buffer[start * req->sectorsize];
 
 		switch (req_op(req->req)) {
 		case REQ_OP_READ:
@@ -1566,7 +1599,8 @@ static void do_io(struct io_thread_req *req)
 		start = end;
 	} while(start < nsectors);
 
-	req->error = update_bitmap(req);
+	req->offset += len;
+	req->error = update_bitmap(req, desc);
 }
 
 /* Changed in start_io_thread, which is serialized by being called only
@@ -1599,8 +1633,13 @@ int io_thread(void *arg)
 		}
 
 		for (count = 0; count < n/sizeof(struct io_thread_req *); count++) {
+			struct io_thread_req *req = (*io_req_buffer)[count];
+			int i;
+
 			io_count++;
-			do_io((*io_req_buffer)[count]);
+			for (i = 0; !req->error && i < req->desc_cnt; i++)
+				do_io(req, &(req->io_desc[i]));
+
 		}
 
 		written = 0;
-- 
2.27.0

