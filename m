Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4AF32D605
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 16:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbhCDPHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 10:07:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:53184 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232984AbhCDPGn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 10:06:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1614870357; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IelbdHFdsyOkbu2alG35onEPhuBF6w4DkG7+lHkRi8s=;
        b=Hjs/U3D7mzGUeaK/ChDXtO9SUH74RxkGkj5ExjRXm91WbB573QCb4aJ0y33bzvfdb72hGn
        RAvp9cNbbUB39VqyUbl3oaDc2+yFL8JypU6/iH30XUPsbIoI0eb1VEYGMo3DnArwLIVApb
        7Wn1Z6+YdsGFPrqI4OtGriS802ddgik=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3B8EDAC1F;
        Thu,  4 Mar 2021 15:05:57 +0000 (UTC)
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>
Cc:     stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH STABLE 4.14 4.19] swap: fix swapfile page to sector mapping
Date:   Thu,  4 Mar 2021 16:08:21 +0100
Message-Id: <20210304150824.29878-2-ailiop@suse.com>
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
Cc: stable@vger.kernel.org # 4.14 4.19

Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
---
 mm/page_io.c  | 11 +++--------
 mm/swapfile.c |  2 +-
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 08d2eae58fce..9b646f07f47f 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -38,7 +38,6 @@ static struct bio *get_swap_bio(gfp_t gfp_flags,
 
 		bio->bi_iter.bi_sector = map_swap_page(page, &bdev);
 		bio_set_dev(bio, bdev);
-		bio->bi_iter.bi_sector <<= PAGE_SHIFT - 9;
 		bio->bi_end_io = end_io;
 
 		for (i = 0; i < nr; i++)
@@ -262,11 +261,6 @@ int swap_writepage(struct page *page, struct writeback_control *wbc)
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
@@ -325,7 +319,8 @@ int __swap_writepage(struct page *page, struct writeback_control *wbc,
 		return ret;
 	}
 
-	ret = bdev_write_page(sis->bdev, swap_page_sector(page), page, wbc);
+	ret = bdev_write_page(sis->bdev, map_swap_page(page, &sis->bdev),
+			      page, wbc);
 	if (!ret) {
 		count_swpout_vm_event(page);
 		return 0;
@@ -376,7 +371,7 @@ int swap_readpage(struct page *page, bool synchronous)
 		return ret;
 	}
 
-	ret = bdev_read_page(sis->bdev, swap_page_sector(page), page);
+	ret = bdev_read_page(sis->bdev, map_swap_page(page, &sis->bdev), page);
 	if (!ret) {
 		if (trylock_page(page)) {
 			swap_slot_free_notify(page);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 130e2e41a48c..057e6907bf7b 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2305,7 +2305,7 @@ sector_t map_swap_page(struct page *page, struct block_device **bdev)
 {
 	swp_entry_t entry;
 	entry.val = page_private(page);
-	return map_swap_entry(entry, bdev);
+	return map_swap_entry(entry, bdev) << (PAGE_SHIFT - 9);
 }
 
 /*
-- 
2.30.1

