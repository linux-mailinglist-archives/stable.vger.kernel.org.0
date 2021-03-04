Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B9C32D604
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 16:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233450AbhCDPHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 10:07:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:53240 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233069AbhCDPGn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 10:06:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1614870357; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u2IPL+4K7Gzcn2aR2TdTKFS32fsr+9Mxr2uOOfE+Wtw=;
        b=byv63b5MTvZhpYt/Nf5rY1Q4q9UNj3BmYYDH4pg2Vq7eIo+CZEcI0koS24Al/dcIzxlPiL
        U2n2HkbgGdDuByd3bCdVnsNpZy6lIK0PHy5ebdY/tw77EiMroISHppPUIM87mTtYpQ7I2J
        mOJgSVsDQls9tYAMXzA/uvzGt7ZbqJQ=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 48D35AE15;
        Thu,  4 Mar 2021 15:05:57 +0000 (UTC)
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>
Cc:     stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH STABLE 5.10 5.11] swap: fix swapfile page to sector mapping
Date:   Thu,  4 Mar 2021 16:08:24 +0100
Message-Id: <20210304150824.29878-5-ailiop@suse.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304150824.29878-1-ailiop@suse.com>
References: <20210304150824.29878-1-ailiop@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit caf6912f3f4af7232340d500a4a2008f81b93f14 upstream.

Fix block device sector offset calculation for swap page io on top of
blockdevs that provide a rw_page operation and do page-sized io directly
(without the block layer).

Currently swap_page_sector() maps a swap page into a blockdev sector by
obtaining the swap page offset (swap map slot), but ignores the swapfile
starting offset into the blockdev.

In setups where swapfiles are sitting on top of a filesystem, this
results into swapping out activity potentially overwriting filesystem
blocks that fall outside the swapfile region.

[This issue only affects swapfiles on filesystems on top of blockdevs
that implement rw_page ops (brd, zram, btt, pmem), and not on top of any
other block devices, in contrast to the upstream commit fix.]

Fixes: dd6bd0d9c7db ("swap: use bdev_read_page() / bdev_write_page()")
Cc: stable@vger.kernel.org # 5.10+

Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
---
 mm/page_io.c  | 12 ++++--------
 mm/swapfile.c |  2 +-
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 433df1263349..1541c0d6ad6e 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -37,7 +37,6 @@ static struct bio *get_swap_bio(gfp_t gfp_flags,
 
 		bio->bi_iter.bi_sector = map_swap_page(page, &bdev);
 		bio_set_dev(bio, bdev);
-		bio->bi_iter.bi_sector <<= PAGE_SHIFT - 9;
 		bio->bi_end_io = end_io;
 
 		bio_add_page(bio, page, thp_size(page), 0);
@@ -273,11 +272,6 @@ int swap_writepage(struct page *page, struct writeback_control *wbc)
 	return ret;
 }
 
-static sector_t swap_page_sector(struct page *page)
-{
-	return (sector_t)__page_file_index(page) << (PAGE_SHIFT - 9);
-}
-
 static inline void count_swpout_vm_event(struct page *page)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -353,7 +347,8 @@ int __swap_writepage(struct page *page, struct writeback_control *wbc,
 		return ret;
 	}
 
-	ret = bdev_write_page(sis->bdev, swap_page_sector(page), page, wbc);
+	ret = bdev_write_page(sis->bdev, map_swap_page(page, &sis->bdev),
+			      page, wbc);
 	if (!ret) {
 		count_swpout_vm_event(page);
 		return 0;
@@ -412,7 +407,8 @@ int swap_readpage(struct page *page, bool synchronous)
 	}
 
 	if (sis->flags & SWP_SYNCHRONOUS_IO) {
-		ret = bdev_read_page(sis->bdev, swap_page_sector(page), page);
+		ret = bdev_read_page(sis->bdev, map_swap_page(page, &sis->bdev),
+				     page);
 		if (!ret) {
 			if (trylock_page(page)) {
 				swap_slot_free_notify(page);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 16db9d1ebcbf..4adbb2a4a2ad 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2311,7 +2311,7 @@ sector_t map_swap_page(struct page *page, struct block_device **bdev)
 {
 	swp_entry_t entry;
 	entry.val = page_private(page);
-	return map_swap_entry(entry, bdev);
+	return map_swap_entry(entry, bdev) << (PAGE_SHIFT - 9);
 }
 
 /*
-- 
2.30.1

