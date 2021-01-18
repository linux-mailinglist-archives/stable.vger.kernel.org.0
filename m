Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 135612FA9B8
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407897AbhARTI4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:08:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:33434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390518AbhARLjG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:39:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 792CB229C6;
        Mon, 18 Jan 2021 11:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969929;
        bh=urm8ha0V5CPD47Y3FIt/A3tCS+oBdjD0JuXIvVY+Mfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E57hrwWM3FOWbmw/B4nI8BaCWCJ+Mv22oqNkJbcpEeRMiZ/cFSRLMPUOyMkCULWKc
         nWBgMFv0qjmuZFAua/yh5TLLosmNwASc1GO4YdZzyvjWULzD9+mNkoejbifIVVK2tG
         w9tNOUjh4lpvyLgqjwKvA3ef4s5dxwm9BxPKh0+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Straub <lukasstraub2@web.de>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 24/76] dm integrity: fix flush with external metadata device
Date:   Mon, 18 Jan 2021 12:34:24 +0100
Message-Id: <20210118113342.144895243@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113340.984217512@linuxfoundation.org>
References: <20210118113340.984217512@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 9b5948267adc9e689da609eb61cf7ed49cae5fa8 ]

With external metadata device, flush requests are not passed down to the
data device.

Fix this by submitting the flush request in dm_integrity_flush_buffers. In
order to not degrade performance, we overlap the data device flush with
the metadata device flush.

Reported-by: Lukas Straub <lukasstraub2@web.de>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-bufio.c     |  6 +++++
 drivers/md/dm-integrity.c | 56 +++++++++++++++++++++++++++++++++------
 include/linux/dm-bufio.h  |  1 +
 3 files changed, 55 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 2d519c2235626..a9529dc2b26e6 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1446,6 +1446,12 @@ sector_t dm_bufio_get_device_size(struct dm_bufio_client *c)
 }
 EXPORT_SYMBOL_GPL(dm_bufio_get_device_size);
 
+struct dm_io_client *dm_bufio_get_dm_io_client(struct dm_bufio_client *c)
+{
+	return c->dm_io;
+}
+EXPORT_SYMBOL_GPL(dm_bufio_get_dm_io_client);
+
 sector_t dm_bufio_get_block_number(struct dm_buffer *b)
 {
 	return b->block;
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index d99cd45874531..25efe382e78fa 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1343,12 +1343,52 @@ static int dm_integrity_rw_tag(struct dm_integrity_c *ic, unsigned char *tag, se
 	return 0;
 }
 
-static void dm_integrity_flush_buffers(struct dm_integrity_c *ic)
+struct flush_request {
+	struct dm_io_request io_req;
+	struct dm_io_region io_reg;
+	struct dm_integrity_c *ic;
+	struct completion comp;
+};
+
+static void flush_notify(unsigned long error, void *fr_)
+{
+	struct flush_request *fr = fr_;
+	if (unlikely(error != 0))
+		dm_integrity_io_error(fr->ic, "flusing disk cache", -EIO);
+	complete(&fr->comp);
+}
+
+static void dm_integrity_flush_buffers(struct dm_integrity_c *ic, bool flush_data)
 {
 	int r;
+
+	struct flush_request fr;
+
+	if (!ic->meta_dev)
+		flush_data = false;
+	if (flush_data) {
+		fr.io_req.bi_op = REQ_OP_WRITE,
+		fr.io_req.bi_op_flags = REQ_PREFLUSH | REQ_SYNC,
+		fr.io_req.mem.type = DM_IO_KMEM,
+		fr.io_req.mem.ptr.addr = NULL,
+		fr.io_req.notify.fn = flush_notify,
+		fr.io_req.notify.context = &fr;
+		fr.io_req.client = dm_bufio_get_dm_io_client(ic->bufio),
+		fr.io_reg.bdev = ic->dev->bdev,
+		fr.io_reg.sector = 0,
+		fr.io_reg.count = 0,
+		fr.ic = ic;
+		init_completion(&fr.comp);
+		r = dm_io(&fr.io_req, 1, &fr.io_reg, NULL);
+		BUG_ON(r);
+	}
+
 	r = dm_bufio_write_dirty_buffers(ic->bufio);
 	if (unlikely(r))
 		dm_integrity_io_error(ic, "writing tags", r);
+
+	if (flush_data)
+		wait_for_completion(&fr.comp);
 }
 
 static void sleep_on_endio_wait(struct dm_integrity_c *ic)
@@ -2077,7 +2117,7 @@ static void integrity_commit(struct work_struct *w)
 	flushes = bio_list_get(&ic->flush_bio_list);
 	if (unlikely(ic->mode != 'J')) {
 		spin_unlock_irq(&ic->endio_wait.lock);
-		dm_integrity_flush_buffers(ic);
+		dm_integrity_flush_buffers(ic, true);
 		goto release_flush_bios;
 	}
 
@@ -2287,7 +2327,7 @@ skip_io:
 	complete_journal_op(&comp);
 	wait_for_completion_io(&comp.comp);
 
-	dm_integrity_flush_buffers(ic);
+	dm_integrity_flush_buffers(ic, true);
 }
 
 static void integrity_writer(struct work_struct *w)
@@ -2329,7 +2369,7 @@ static void recalc_write_super(struct dm_integrity_c *ic)
 {
 	int r;
 
-	dm_integrity_flush_buffers(ic);
+	dm_integrity_flush_buffers(ic, false);
 	if (dm_integrity_failed(ic))
 		return;
 
@@ -2532,7 +2572,7 @@ static void bitmap_flush_work(struct work_struct *work)
 	unsigned long limit;
 	struct bio *bio;
 
-	dm_integrity_flush_buffers(ic);
+	dm_integrity_flush_buffers(ic, false);
 
 	range.logical_sector = 0;
 	range.n_sectors = ic->provided_data_sectors;
@@ -2541,7 +2581,7 @@ static void bitmap_flush_work(struct work_struct *work)
 	add_new_range_and_wait(ic, &range);
 	spin_unlock_irq(&ic->endio_wait.lock);
 
-	dm_integrity_flush_buffers(ic);
+	dm_integrity_flush_buffers(ic, true);
 	if (ic->meta_dev)
 		blkdev_issue_flush(ic->dev->bdev, GFP_NOIO, NULL);
 
@@ -2812,11 +2852,11 @@ static void dm_integrity_postsuspend(struct dm_target *ti)
 		if (ic->meta_dev)
 			queue_work(ic->writer_wq, &ic->writer_work);
 		drain_workqueue(ic->writer_wq);
-		dm_integrity_flush_buffers(ic);
+		dm_integrity_flush_buffers(ic, true);
 	}
 
 	if (ic->mode == 'B') {
-		dm_integrity_flush_buffers(ic);
+		dm_integrity_flush_buffers(ic, true);
 #if 1
 		/* set to 0 to test bitmap replay code */
 		init_journal(ic, 0, ic->journal_sections, 0);
diff --git a/include/linux/dm-bufio.h b/include/linux/dm-bufio.h
index 3c8b7d274bd9b..45ba37aaf6b78 100644
--- a/include/linux/dm-bufio.h
+++ b/include/linux/dm-bufio.h
@@ -138,6 +138,7 @@ void dm_bufio_set_minimum_buffers(struct dm_bufio_client *c, unsigned n);
 
 unsigned dm_bufio_get_block_size(struct dm_bufio_client *c);
 sector_t dm_bufio_get_device_size(struct dm_bufio_client *c);
+struct dm_io_client *dm_bufio_get_dm_io_client(struct dm_bufio_client *c);
 sector_t dm_bufio_get_block_number(struct dm_buffer *b);
 void *dm_bufio_get_block_data(struct dm_buffer *b);
 void *dm_bufio_get_aux_data(struct dm_buffer *b);
-- 
2.27.0



