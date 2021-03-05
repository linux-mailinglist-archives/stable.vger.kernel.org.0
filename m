Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A361032E95D
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbhCEMc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:32:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:42222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232468AbhCEMbz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:31:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 656CF65013;
        Fri,  5 Mar 2021 12:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947515;
        bh=q7I4pmhwraH2lRHfLtNcM8GYzt2Ga/wuWQ3myYhyTSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OFhUKmC724q1e8Aw57ejb9bv3y8Hw9hTy9H2UMUTLJ/XYZV/PUn12pBdKgqymmuQg
         soPLCCEnT+a0bI1mNeDVR2bMk398mV/6m2mVGkFze1lhtYPcUbo6BkT4DHv8fYhSYR
         qXkj9CDXyKa/Lcs2PNTKc87vHF3VZrbrHrhGqAT4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Anthony Iliopoulos <ailiop@suse.com>
Subject: [PATCH 5.10 091/102] swap: fix swapfile read/write offset
Date:   Fri,  5 Mar 2021 13:21:50 +0100
Message-Id: <20210305120907.758781565@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
References: <20210305120903.276489876@linuxfoundation.org>
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
@@ -484,6 +484,7 @@ struct backing_dev_info;
 extern int init_swap_address_space(unsigned int type, unsigned long nr_pages);
 extern void exit_swap_address_space(unsigned int type);
 extern struct swap_info_struct *get_swap_device(swp_entry_t entry);
+sector_t swap_page_sector(struct page *page);
 
 static inline void put_swap_device(struct swap_info_struct *si)
 {
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -273,11 +273,6 @@ out:
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
@@ -220,6 +220,19 @@ offset_to_swap_extent(struct swap_info_s
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


