Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43E5332EAD3
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbhCEMk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:40:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:55198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233406AbhCEMkN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:40:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B98A964EE8;
        Fri,  5 Mar 2021 12:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614948013;
        bh=u5USE8R/J2OYRFRbEhPZWmx7hQpjdJCn5O93JZ9gCfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vWIP2HrYU1kgOWDeBO+yQMlUdaeqrZaUQWwPye1Nljr6VnNF7qROyvhxAPQu0GqAu
         5mfViwEnHWqC/Aa18snaPiium+Eo0GO5y05QAl6hR6+LzsIlt/QF1tLJ8zFf+J1ht3
         o1FSRPr/lodJxI1oENWcK/F6mGKWF8atxpu5ZRR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Anthony Iliopoulos <ailiop@suse.com>
Subject: [PATCH 4.14 38/39] swap: fix swapfile read/write offset
Date:   Fri,  5 Mar 2021 13:22:37 +0100
Message-Id: <20210305120853.680252429@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120851.751937389@linuxfoundation.org>
References: <20210305120851.751937389@linuxfoundation.org>
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
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_io.c  |   11 +++--------
 mm/swapfile.c |    2 +-
 2 files changed, 4 insertions(+), 9 deletions(-)

--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -38,7 +38,6 @@ static struct bio *get_swap_bio(gfp_t gf
 
 		bio->bi_iter.bi_sector = map_swap_page(page, &bdev);
 		bio_set_dev(bio, bdev);
-		bio->bi_iter.bi_sector <<= PAGE_SHIFT - 9;
 		bio->bi_end_io = end_io;
 
 		for (i = 0; i < nr; i++)
@@ -261,11 +260,6 @@ out:
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
@@ -324,7 +318,8 @@ int __swap_writepage(struct page *page,
 		return ret;
 	}
 
-	ret = bdev_write_page(sis->bdev, swap_page_sector(page), page, wbc);
+	ret = bdev_write_page(sis->bdev, map_swap_page(page, &sis->bdev),
+			      page, wbc);
 	if (!ret) {
 		count_swpout_vm_event(page);
 		return 0;
@@ -374,7 +369,7 @@ int swap_readpage(struct page *page, boo
 		return ret;
 	}
 
-	ret = bdev_read_page(sis->bdev, swap_page_sector(page), page);
+	ret = bdev_read_page(sis->bdev, map_swap_page(page, &sis->bdev), page);
 	if (!ret) {
 		if (trylock_page(page)) {
 			swap_slot_free_notify(page);
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2304,7 +2304,7 @@ sector_t map_swap_page(struct page *page
 {
 	swp_entry_t entry;
 	entry.val = page_private(page);
-	return map_swap_entry(entry, bdev);
+	return map_swap_entry(entry, bdev) << (PAGE_SHIFT - 9);
 }
 
 /*


