Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B4D32EB7F
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233617AbhCEMoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:44:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:32810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232815AbhCEMn7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:43:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBD666501E;
        Fri,  5 Mar 2021 12:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614948239;
        bh=5A8MzKuBa5QwN4+e03SXTTAE+aNwmgxjioVn5zLiJhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yS7j+TWNiGuk5A2qb52wl3sCit6GD5pZqYQagi0V7gXKU4j3GK+foJbK+/Ifw95uE
         N1fgMiX/pdKUpe7aBrn3NaO5mRbvdKxFPxcDo10hDUEWgDYUoZdBdwUddUodYPyxTN
         kwrO/PSOIi6Add/zk7w9vcf6FQs1pGBaxrsAeB8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anthony Iliopoulos <ailiop@suse.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.4 29/30] swap: fix swapfile read/write offset
Date:   Fri,  5 Mar 2021 13:22:58 +0100
Message-Id: <20210305120850.860813577@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120849.381261651@linuxfoundation.org>
References: <20210305120849.381261651@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit caf6912f3f4af7232340d500a4a2008f81b93f14 upstream.

We're not factoring in the start of the file for where to write and
read the swapfile, which leads to very unfortunate side effects of
writing where we should not be...

[This issue only affects swapfiles on filesystems on top of blockdevs
that implement rw_page ops (brd, zram, btt, pmem), and not on top of any
other block devices, in contrast to the upstream commit fix.]

Fixes: dd6bd0d9c7db ("swap: use bdev_read_page() / bdev_write_page()")
Cc: stable@vger.kernel.org # 4.4
Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_io.c  |   11 +++--------
 mm/swapfile.c |    2 +-
 2 files changed, 4 insertions(+), 9 deletions(-)

--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -32,7 +32,6 @@ static struct bio *get_swap_bio(gfp_t gf
 	bio = bio_alloc(gfp_flags, 1);
 	if (bio) {
 		bio->bi_iter.bi_sector = map_swap_page(page, &bio->bi_bdev);
-		bio->bi_iter.bi_sector <<= PAGE_SHIFT - 9;
 		bio->bi_end_io = end_io;
 
 		bio_add_page(bio, page, PAGE_SIZE, 0);
@@ -244,11 +243,6 @@ out:
 	return ret;
 }
 
-static sector_t swap_page_sector(struct page *page)
-{
-	return (sector_t)__page_file_index(page) << (PAGE_CACHE_SHIFT - 9);
-}
-
 int __swap_writepage(struct page *page, struct writeback_control *wbc,
 		bio_end_io_t end_write_func)
 {
@@ -297,7 +291,8 @@ int __swap_writepage(struct page *page,
 		return ret;
 	}
 
-	ret = bdev_write_page(sis->bdev, swap_page_sector(page), page, wbc);
+	ret = bdev_write_page(sis->bdev, map_swap_page(page, &sis->bdev),
+			      page, wbc);
 	if (!ret) {
 		count_vm_event(PSWPOUT);
 		return 0;
@@ -345,7 +340,7 @@ int swap_readpage(struct page *page)
 		return ret;
 	}
 
-	ret = bdev_read_page(sis->bdev, swap_page_sector(page), page);
+	ret = bdev_read_page(sis->bdev, map_swap_page(page, &sis->bdev), page);
 	if (!ret) {
 		count_vm_event(PSWPIN);
 		return 0;
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1653,7 +1653,7 @@ sector_t map_swap_page(struct page *page
 {
 	swp_entry_t entry;
 	entry.val = page_private(page);
-	return map_swap_entry(entry, bdev);
+	return map_swap_entry(entry, bdev) << (PAGE_SHIFT - 9);
 }
 
 /*


