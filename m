Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDBF3D5F19
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236412AbhGZPQt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:16:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:52760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236599AbhGZPLo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:11:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 740576056C;
        Mon, 26 Jul 2021 15:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314732;
        bh=Ux1H0St56avHHzq9SAdKMjvg6hQevOm4gS/CGOgDzBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TYkjvHBLV0QBec738MxcR60Dub+ZAxeeZMWJAC8ZNBppuHiG2/3d5fG2SlfLDvFmY
         c0iHpAIIZRCaVkM1ocwpFhtjs0Gp3fHLKpMms3YL52zgpig1UOhYvS/5q7PtG2WJ3b
         Kx73d4KUjymySg6mt6U5IYOeAdRjphucetEGKduY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.19 036/120] dm writecache: fix writing beyond end of underlying device when shrinking
Date:   Mon, 26 Jul 2021 17:38:08 +0200
Message-Id: <20210726153833.554907713@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153832.339431936@linuxfoundation.org>
References: <20210726153832.339431936@linuxfoundation.org>
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


