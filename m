Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE5932EA0C
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbhCEMgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:36:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:48280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232679AbhCEMfl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:35:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 843986501B;
        Fri,  5 Mar 2021 12:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947741;
        bh=enjSeCqzd/MJ3Mnoo7+wbqTE7juO0T4rT6upWNEVdwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J/p/FD0j7DyB3VlPJleQXphh5jW9WTfxBJmp/g+5sgzlGITR7Fm7ot/L0ovJ15fEE
         dORN1eTqXiIAPE5HwCZ4rkO6XiyH0z2kFYd+PO/a994begHzX2T6F3cltoFgn6J+/X
         KNa1aiLXgDw//a1NZTE+Ov5WQ/idz2dhKjM4h93M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Anthony Iliopoulos <ailiop@suse.com>
Subject: [PATCH 5.4 68/72] swap: fix swapfile read/write offset
Date:   Fri,  5 Mar 2021 13:22:10 +0100
Message-Id: <20210305120900.669108095@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120857.341630346@linuxfoundation.org>
References: <20210305120857.341630346@linuxfoundation.org>
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

Fixes: dd6bd0d9c7db ("swap: use bdev_read_page() / bdev_write_page()")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Anthony Iliopoulos <ailiop@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/swap.h |    1 +
 mm/page_io.c         |    5 -----
 mm/swapfile.c        |   13 +++++++++++++
 3 files changed, 14 insertions(+), 5 deletions(-)

--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -473,6 +473,7 @@ struct backing_dev_info;
 extern int init_swap_address_space(unsigned int type, unsigned long nr_pages);
 extern void exit_swap_address_space(unsigned int type);
 extern struct swap_info_struct *get_swap_device(swp_entry_t entry);
+sector_t swap_page_sector(struct page *page);
 
 static inline void put_swap_device(struct swap_info_struct *si)
 {
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -260,11 +260,6 @@ out:
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
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -221,6 +221,19 @@ offset_to_swap_extent(struct swap_info_s
 	BUG();
 }
 
+sector_t swap_page_sector(struct page *page)
+{
+	struct swap_info_struct *sis = page_swap_info(page);
+	struct swap_extent *se;
+	sector_t sector;
+	pgoff_t offset;
+
+	offset = __page_file_index(page);
+	se = offset_to_swap_extent(sis, offset);
+	sector = se->start_block + (offset - se->start_page);
+	return sector << (PAGE_SHIFT - 9);
+}
+
 /*
  * swap allocation tell device that a cluster of swap can now be discarded,
  * to allow the swap device to optimize its wear-levelling.


