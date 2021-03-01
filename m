Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64E5328EDD
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238075AbhCATjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:39:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:48622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241947AbhCATaA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:30:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB2F76529A;
        Mon,  1 Mar 2021 17:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619971;
        bh=Un2jYswws1ByDrwhtiyuuxeMrwd3O2Oegrx4yVkBNpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aHWHnV5DtJRFEo7UJBwPhekjBgGBYafFu1zW0gVGhluqIqIh7NeX5HjW8Mks+QvFH
         3LxU0YfrvSaI7jCQlHHD5WiURPUAZmdmR0nFgwiFbZLFbd0V1bG0S7ycL5GQqeGpmJ
         pQb8TFs8NsghVAJQpJc9pH+0SelTpERmxew6SYJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.10 647/663] dm writecache: fix writing beyond end of underlying device when shrinking
Date:   Mon,  1 Mar 2021 17:14:55 +0100
Message-Id: <20210301161213.863328176@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 4134455f2aafdfeab50cabb4cccb35e916034b93 upstream.

Do not attempt to write any data beyond the end of the underlying data
device while shrinking it.

The DM writecache device must be suspended when the underlying data
device is shrunk.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-writecache.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -148,6 +148,7 @@ struct dm_writecache {
 	size_t metadata_sectors;
 	size_t n_blocks;
 	uint64_t seq_count;
+	sector_t data_device_sectors;
 	void *block_start;
 	struct wc_entry *entries;
 	unsigned block_size;
@@ -977,6 +978,8 @@ static void writecache_resume(struct dm_
 
 	wc_lock(wc);
 
+	wc->data_device_sectors = i_size_read(wc->dev->bdev->bd_inode) >> SECTOR_SHIFT;
+
 	if (WC_MODE_PMEM(wc)) {
 		persistent_memory_invalidate_cache(wc->memory_map, wc->memory_map_size);
 	} else {
@@ -1646,6 +1649,10 @@ static bool wc_add_block(struct writebac
 	void *address = memory_data(wc, e);
 
 	persistent_memory_flush_cache(address, block_size);
+
+	if (unlikely(bio_end_sector(&wb->bio) >= wc->data_device_sectors))
+		return true;
+
 	return bio_add_page(&wb->bio, persistent_memory_page(address),
 			    block_size, persistent_memory_page_offset(address)) != 0;
 }
@@ -1717,6 +1724,9 @@ static void __writecache_writeback_pmem(
 		if (writecache_has_error(wc)) {
 			bio->bi_status = BLK_STS_IOERR;
 			bio_endio(bio);
+		} else if (unlikely(!bio_sectors(bio))) {
+			bio->bi_status = BLK_STS_OK;
+			bio_endio(bio);
 		} else {
 			submit_bio(bio);
 		}
@@ -1760,6 +1770,14 @@ static void __writecache_writeback_ssd(s
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


