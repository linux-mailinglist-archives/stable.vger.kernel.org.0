Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0B22FBBD9
	for <lists+stable@lfdr.de>; Tue, 19 Jan 2021 17:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729307AbhASQCC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 11:02:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50787 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391827AbhASQBk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jan 2021 11:01:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611072013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3dRp2vTcVRSayPopnxXqzHcCqaDeLGVXc/rlh/3HU3o=;
        b=YZCP9HFCS1WaVTq+HABvbXi/05SX2DZawTkObToar/7xD0nLR5LKti13y91njROSXiXQ4b
        WA8eNPm4ZvlXx6T4KMMxWA0Hg/B4eMfFBj2x4OrTKAm0TUJvgJ/oqF2JPROqy2hUfwKTre
        g+l/QFtT1k6c2uDbPoXgkM9U5lFIuRw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-Y9KApoFGOJqt_X94SB7ESQ-1; Tue, 19 Jan 2021 11:00:08 -0500
X-MC-Unique: Y9KApoFGOJqt_X94SB7ESQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 012B7800D53;
        Tue, 19 Jan 2021 16:00:07 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C82CD5D964;
        Tue, 19 Jan 2021 15:59:59 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 10JFxx21012172;
        Tue, 19 Jan 2021 10:59:59 -0500
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 10JFxvaT012168;
        Tue, 19 Jan 2021 10:59:57 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Tue, 19 Jan 2021 10:59:57 -0500 (EST)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     gregkh@linuxfoundation.org
cc:     lukasstraub2@web.de, snitzer@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] dm integrity: fix flush with external
 metadata device" failed to apply to 4.19-stable tree
In-Reply-To: <161089356815125@kroah.com>
Message-ID: <alpine.LRH.2.02.2101191057280.9916@file01.intranet.prod.int.rdu2.redhat.com>
References: <161089356815125@kroah.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On Sun, 17 Jan 2021, gregkh@linuxfoundation.org wrote:

> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h

Hi

Here I'm submitting the backported patch for the branch 4.19-stable:


upstream commit 9b5948267adc9e689da609eb61cf7ed49cae5fa8
Author: Mikulas Patocka <mpatocka@redhat.com>
Date:   Fri Jan 8 11:15:56 2021 -0500

    dm integrity: fix flush with external metadata device
    
    With external metadata device, flush requests are not passed down to the
    data device.
    
    Fix this by submitting the flush request in dm_integrity_flush_buffers. In
    order to not degrade performance, we overlap the data device flush with
    the metadata device flush.
    
    Reported-by: Lukas Straub <lukasstraub2@web.de>
    Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
    Cc: stable@vger.kernel.org
    Signed-off-by: Mike Snitzer <snitzer@redhat.com>

---
 drivers/md/dm-bufio.c     |    6 +++++
 drivers/md/dm-integrity.c |   50 +++++++++++++++++++++++++++++++++++++++++-----
 include/linux/dm-bufio.h  |    1 
 3 files changed, 52 insertions(+), 5 deletions(-)

Index: linux-stable/drivers/md/dm-bufio.c
===================================================================
--- linux-stable.orig/drivers/md/dm-bufio.c	2021-01-19 16:51:16.000000000 +0100
+++ linux-stable/drivers/md/dm-bufio.c	2021-01-19 16:51:16.000000000 +0100
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
Index: linux-stable/drivers/md/dm-integrity.c
===================================================================
--- linux-stable.orig/drivers/md/dm-integrity.c	2021-01-19 16:51:16.000000000 +0100
+++ linux-stable/drivers/md/dm-integrity.c	2021-01-19 16:52:35.000000000 +0100
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
Index: linux-stable/include/linux/dm-bufio.h
===================================================================
--- linux-stable.orig/include/linux/dm-bufio.h	2021-01-19 16:51:16.000000000 +0100
+++ linux-stable/include/linux/dm-bufio.h	2021-01-19 16:51:16.000000000 +0100
@@ -138,6 +138,7 @@ void dm_bufio_set_minimum_buffers(struct
 
 unsigned dm_bufio_get_block_size(struct dm_bufio_client *c);
 sector_t dm_bufio_get_device_size(struct dm_bufio_client *c);
+struct dm_io_client *dm_bufio_get_dm_io_client(struct dm_bufio_client *c);
 sector_t dm_bufio_get_block_number(struct dm_buffer *b);
 void *dm_bufio_get_block_data(struct dm_buffer *b);
 void *dm_bufio_get_aux_data(struct dm_buffer *b);

