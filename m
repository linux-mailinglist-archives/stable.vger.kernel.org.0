Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB056FEA21
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 02:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727365AbfKPBfC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 20:35:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:46200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727089AbfKPBfC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 20:35:02 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4837820815;
        Sat, 16 Nov 2019 01:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573868101;
        bh=Kv1yug5QUnHpKv2L6ZJuYSuJkNFgsyaXFiTSn61696s=;
        h=Date:From:To:Subject:From;
        b=ulW2qUbzXU+hkBZG8iumBZIngX+2AsIu8MFJQRZgrbIrYJcSyz8Nonp32scefcPZF
         qCa4jvygr6f7Y0oul4xV95FUdKSxqo1o/m6qlSBzrUWAngoERBC8BpwkhC+FAjBXbx
         QEqmp4WUZKmzgZzBjteu2Wl7NXUGzOY0gYVkgnEY=
Date:   Fri, 15 Nov 2019 17:35:00 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, hughd@google.com, linux-mm@kvack.org,
        mhocko@suse.com, minchan@google.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vinmenon@codeaurora.org
Subject:  [patch 09/11] mm/page_io.c: do not free shared swap slots
Message-ID: <20191116013500.fmyyvsUau%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinayak Menon <vinmenon@codeaurora.org>
Subject: mm/page_io.c: do not free shared swap slots

The following race is observed due to which a processes faulting on a swap
entry, finds the page neither in swapcache nor swap.  This causes zram to
give a zero filled page that gets mapped to the process, resulting in a
user space crash later.

Consider parent and child processes Pa and Pb sharing the same swap slot
with swap_count 2.  Swap is on zram with SWP_SYNCHRONOUS_IO set.  Virtual
address 'VA' of Pa and Pb points to the shared swap entry.

Pa                                       Pb

fault on VA                              fault on VA
do_swap_page                             do_swap_page
lookup_swap_cache fails                  lookup_swap_cache fails
                                         Pb scheduled out
swapin_readahead (deletes zram entry)
swap_free (makes swap_count 1)
                                         Pb scheduled in
                                         swap_readpage (swap_count == 1)
                                         Takes SWP_SYNCHRONOUS_IO path
                                         zram enrty absent
                                         zram gives a zero filled page

Fix this by making sure that swap slot is freed only when swap count drops
down to one.

Link: http://lkml.kernel.org/r/1571743294-14285-1-git-send-email-vinmenon@codeaurora.org
Fixes: aa8d22a11da9 ("mm: swap: SWP_SYNCHRONOUS_IO: skip swapcache only if swapped page has no other reference")
Signed-off-by: Vinayak Menon <vinmenon@codeaurora.org>
Suggested-by: Minchan Kim <minchan@google.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_io.c~mm-do-not-free-shared-swap-slots
+++ a/mm/page_io.c
@@ -73,6 +73,7 @@ static void swap_slot_free_notify(struct
 {
 	struct swap_info_struct *sis;
 	struct gendisk *disk;
+	swp_entry_t entry;
 
 	/*
 	 * There is no guarantee that the page is in swap cache - the software
@@ -104,11 +105,10 @@ static void swap_slot_free_notify(struct
 	 * we again wish to reclaim it.
 	 */
 	disk = sis->bdev->bd_disk;
-	if (disk->fops->swap_slot_free_notify) {
-		swp_entry_t entry;
+	entry.val = page_private(page);
+	if (disk->fops->swap_slot_free_notify && __swap_count(entry) == 1) {
 		unsigned long offset;
 
-		entry.val = page_private(page);
 		offset = swp_offset(entry);
 
 		SetPageDirty(page);
_
