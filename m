Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83C9F328E4E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241563AbhCAT1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:27:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:46182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241559AbhCATYN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:24:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BC1D6512E;
        Mon,  1 Mar 2021 17:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618217;
        bh=KiPz5d8keEHTvz15eabUZwvjxe7M1UPtTCLWhmaDE/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wDxFWw4Bl4UiTWYB2PaYOwtgM+9maVeGjemEmEMCUCjT21V0mifewM6d63a3ROx82
         dk9m1swQX1B3vzL/nare0qHtXdco6A+OJcKXtVt05l/mSwdzw6vo11svlq9/E5KtpY
         x8kVSgNsBA6tbmmXSDCXBV/TulW6dWGCZNR0O6Q4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.4 323/340] dm writecache: fix writing beyond end of underlying device when shrinking
Date:   Mon,  1 Mar 2021 17:14:27 +0100
Message-Id: <20210301161104.198664803@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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
@@ -142,6 +142,7 @@ struct dm_writecache {
 	size_t metadata_sectors;
 	size_t n_blocks;
 	uint64_t seq_count;
+	sector_t data_device_sectors;
 	void *block_start;
 	struct wc_entry *entries;
 	unsigned block_size;
@@ -918,6 +919,8 @@ static void writecache_resume(struct dm_
 
 	wc_lock(wc);
 
+	wc->data_device_sectors = i_size_read(wc->dev->bdev->bd_inode) >> SECTOR_SHIFT;
+
 	if (WC_MODE_PMEM(wc)) {
 		persistent_memory_invalidate_cache(wc->memory_map, wc->memory_map_size);
 	} else {
@@ -1488,6 +1491,10 @@ static bool wc_add_block(struct writebac
 	void *address = memory_data(wc, e);
 
 	persistent_memory_flush_cache(address, block_size);
+
+	if (unlikely(bio_end_sector(&wb->bio) >= wc->data_device_sectors))
+		return true;
+
 	return bio_add_page(&wb->bio, persistent_memory_page(address),
 			    block_size, persistent_memory_page_offset(address)) != 0;
 }
@@ -1559,6 +1566,9 @@ static void __writecache_writeback_pmem(
 		if (writecache_has_error(wc)) {
 			bio->bi_status = BLK_STS_IOERR;
 			bio_endio(bio);
+		} else if (unlikely(!bio_sectors(bio))) {
+			bio->bi_status = BLK_STS_OK;
+			bio_endio(bio);
 		} else {
 			submit_bio(bio);
 		}
@@ -1602,6 +1612,14 @@ static void __writecache_writeback_ssd(s
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


