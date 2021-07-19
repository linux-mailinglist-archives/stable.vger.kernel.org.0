Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4BF83CDB68
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243656AbhGSOmo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:42:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51352 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243289AbhGSOkU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 10:40:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626708056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E7u0fs1rxT75fMwwj8rn7XbXmmDt7TTv9+F3sOyGlyU=;
        b=gVu3JuhcuKaBs+4cAJP7RoJQ4xQpp3wMXGnIVJlF/e2MCHKF3VEw6X0epWMJtz/OV4oDH7
        vA1oR4gTzPnDGxhopURVMdigBH9kezqD+EWTqFkMEROYHmX0vzkpdpE0TuWczfQ052c713
        1reesQRfMB2lUDg3x7wkUKPhw2vXVBY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-xtwFVtfHPCaF02b4AjD0fQ-1; Mon, 19 Jul 2021 11:20:55 -0400
X-MC-Unique: xtwFVtfHPCaF02b4AjD0fQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8DD0802923;
        Mon, 19 Jul 2021 15:20:53 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C82B560861;
        Mon, 19 Jul 2021 15:20:49 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 16JFKnAl018051;
        Mon, 19 Jul 2021 11:20:49 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 16JFKnjX018047;
        Mon, 19 Jul 2021 11:20:49 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Mon, 19 Jul 2021 11:20:49 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     gregkh@linuxfoundation.org
cc:     snitzer@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] dm writecache: fix writing beyond end of
 underlying device" failed to apply to 4.19-stable tree
In-Reply-To: <1614606368115248@kroah.com>
Message-ID: <alpine.LRH.2.02.2107191120160.17791@file01.intranet.prod.int.rdu2.redhat.com>
References: <1614606368115248@kroah.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On Mon, 1 Mar 2021, gregkh@linuxfoundation.org wrote:

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

This is backport of the patch 4134455f2aafdfeab50cabb4cccb35e916034b93 for
the stable branch 4.19.

Mikulas



commit 4134455f2aafdfeab50cabb4cccb35e916034b93
Author: Mikulas Patocka <mpatocka@redhat.com>
Date:   Tue Feb 9 10:56:20 2021 -0500

    dm writecache: fix writing beyond end of underlying device when shrinking
    
    Do not attempt to write any data beyond the end of the underlying data
    device while shrinking it.
    
    The DM writecache device must be suspended when the underlying data
    device is shrunk.
    
    Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
    Cc: stable@vger.kernel.org
    Signed-off-by: Mike Snitzer <snitzer@redhat.com>

---
 drivers/md/dm-writecache.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

Index: linux-stable/drivers/md/dm-writecache.c
===================================================================
--- linux-stable.orig/drivers/md/dm-writecache.c	2021-07-18 21:05:45.000000000 +0200
+++ linux-stable/drivers/md/dm-writecache.c	2021-07-18 21:09:52.000000000 +0200
@@ -142,6 +142,7 @@ struct dm_writecache {
 	size_t metadata_sectors;
 	size_t n_blocks;
 	uint64_t seq_count;
+	sector_t data_device_sectors;
 	void *block_start;
 	struct wc_entry *entries;
 	unsigned block_size;
@@ -929,6 +930,8 @@ static void writecache_resume(struct dm_
 
 	wc_lock(wc);
 
+	wc->data_device_sectors = i_size_read(wc->dev->bdev->bd_inode) >> SECTOR_SHIFT;
+
 	if (WC_MODE_PMEM(wc)) {
 		persistent_memory_invalidate_cache(wc->memory_map, wc->memory_map_size);
 	} else {
@@ -1499,6 +1502,10 @@ static bool wc_add_block(struct writebac
 	void *address = memory_data(wc, e);
 
 	persistent_memory_flush_cache(address, block_size);
+
+	if (unlikely(bio_end_sector(&wb->bio) >= wc->data_device_sectors))
+		return true;
+
 	return bio_add_page(&wb->bio, persistent_memory_page(address),
 			    block_size, persistent_memory_page_offset(address)) != 0;
 }
@@ -1571,6 +1578,9 @@ static void __writecache_writeback_pmem(
 		if (writecache_has_error(wc)) {
 			bio->bi_status = BLK_STS_IOERR;
 			bio_endio(&wb->bio);
+		} else if (unlikely(!bio_sectors(&wb->bio))) {
+			bio->bi_status = BLK_STS_OK;
+			bio_endio(&wb->bio);
 		} else {
 			submit_bio(&wb->bio);
 		}
@@ -1614,6 +1624,14 @@ static void __writecache_writeback_ssd(s
 			e = f;
 		}
 
+		if (unlikely(to.sector + to.count > wc->data_device_sectors)) {
+			if (to.sector >= wc->data_device_sectors) {
+				writecache_copy_endio(0, 0, c);
+				continue;
+			}
+			from.count = to.count = wc->data_device_sectors - to.sector;
+		}
+
 		dm_kcopyd_copy(wc->dm_kcopyd, &from, 1, &to, 0, writecache_copy_endio, c);
 
 		__writeback_throttle(wc, wbl);

