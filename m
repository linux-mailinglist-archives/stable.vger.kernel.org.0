Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC581105D08
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 00:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfKUXGt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 18:06:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:41136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726038AbfKUXGs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Nov 2019 18:06:48 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA6BF20714;
        Thu, 21 Nov 2019 23:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574377608;
        bh=lKNmLeiy/H2KV0f0dVY9Ptqi3HhYLr0M2xTDcKOsva4=;
        h=Date:From:To:Subject:From;
        b=E5hmOzCMkX68lJ8pJMEuBQLLq6Z3V1SLNybQJMiDgbNGbFUmC5yHC3fHPeHVuVId1
         V+oER2kEt5DpgEryOLC5cjcVR2GzE/qNl0ve9gqMZmgidEfzW8iD9o2OInZesG8lCz
         gv7mhv8C2HwAvJX95N3o0EHJDnqiJTZeRCLx3Uqs=
Date:   Thu, 21 Nov 2019 15:06:47 -0800
From:   akpm@linux-foundation.org
To:     hughd@google.com, mhocko@suse.com, minchan@google.com,
        minchan@kernel.org, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, vinmenon@codeaurora.org
Subject:  [merged] mm-do-not-free-shared-swap-slots.patch removed
 from -mm tree
Message-ID: <20191121230647.Ukp2eRdXD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/page_io.c: do not free shared swap slots
has been removed from the -mm tree.  Its filename was
     mm-do-not-free-shared-swap-slots.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from vinmenon@codeaurora.org are


