Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29BFE300C46
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 20:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730000AbhAVSnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 13:43:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:40006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728530AbhAVOWE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:22:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 075C623B3E;
        Fri, 22 Jan 2021 14:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324935;
        bh=RsxoWlMfUTa4vFmPKk2JKlyzUgduNlQWWc6sowG/9NE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J/7/rXnKdWxaZSII4yrGgLDuO7bou9PK9isjYt+CPFT9E07UBnL7yyZX3KZKG2ugs
         J+UOTZcGdPhf6sArhQRJ9s+mxwts6pge+qnb8y3VZinpYEo7mVlY8tGxwVwTyfS1GS
         81CcWCt5Gqe9ASo6zqK3S2wycVR/qCkOS47ZvoEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Straub <lukasstraub2@web.de>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.19 03/22] dm integrity: fix flush with external metadata device
Date:   Fri, 22 Jan 2021 15:12:21 +0100
Message-Id: <20210122135732.058636221@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135731.921636245@linuxfoundation.org>
References: <20210122135731.921636245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 9b5948267adc9e689da609eb61cf7ed49cae5fa8 upstream.

With external metadata device, flush requests are not passed down to the
data device.

Fix this by submitting the flush request in dm_integrity_flush_buffers. In
order to not degrade performance, we overlap the data device flush with
the metadata device flush.

Reported-by: Lukas Straub <lukasstraub2@web.de>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/md/dm-bufio.c     |    6 +++++
 drivers/md/dm-integrity.c |   50 +++++++++++++++++++++++++++++++++++++++++-----
 include/linux/dm-bufio.h  |    1 
 3 files changed, 52 insertions(+), 5 deletions(-)

--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1471,6 +1471,12 @@ sector_t dm_bufio_get_device_size(struct
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
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1153,12 +1153,52 @@ static int dm_integrity_rw_tag(struct dm
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
@@ -1846,7 +1886,7 @@ static void integrity_commit(struct work
 	flushes = bio_list_get(&ic->flush_bio_list);
 	if (unlikely(ic->mode != 'J')) {
 		spin_unlock_irq(&ic->endio_wait.lock);
-		dm_integrity_flush_buffers(ic);
+		dm_integrity_flush_buffers(ic, true);
 		goto release_flush_bios;
 	}
 
@@ -2057,7 +2097,7 @@ skip_io:
 	complete_journal_op(&comp);
 	wait_for_completion_io(&comp.comp);
 
-	dm_integrity_flush_buffers(ic);
+	dm_integrity_flush_buffers(ic, true);
 }
 
 static void integrity_writer(struct work_struct *w)
@@ -2099,7 +2139,7 @@ static void recalc_write_super(struct dm
 {
 	int r;
 
-	dm_integrity_flush_buffers(ic);
+	dm_integrity_flush_buffers(ic, false);
 	if (dm_integrity_failed(ic))
 		return;
 
@@ -2409,7 +2449,7 @@ static void dm_integrity_postsuspend(str
 		if (ic->meta_dev)
 			queue_work(ic->writer_wq, &ic->writer_work);
 		drain_workqueue(ic->writer_wq);
-		dm_integrity_flush_buffers(ic);
+		dm_integrity_flush_buffers(ic, true);
 	}
 
 	BUG_ON(!RB_EMPTY_ROOT(&ic->in_progress));
--- a/include/linux/dm-bufio.h
+++ b/include/linux/dm-bufio.h
@@ -138,6 +138,7 @@ void dm_bufio_set_minimum_buffers(struct
 
 unsigned dm_bufio_get_block_size(struct dm_bufio_client *c);
 sector_t dm_bufio_get_device_size(struct dm_bufio_client *c);
+struct dm_io_client *dm_bufio_get_dm_io_client(struct dm_bufio_client *c);
 sector_t dm_bufio_get_block_number(struct dm_buffer *b);
 void *dm_bufio_get_block_data(struct dm_buffer *b);
 void *dm_bufio_get_aux_data(struct dm_buffer *b);


