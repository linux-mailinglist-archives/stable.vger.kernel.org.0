Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5645B504D8D
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 10:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236333AbiDRIII (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 04:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237088AbiDRIIH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 04:08:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E920DBC9E
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 01:05:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 854A76104A
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 08:05:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78180C385A1;
        Mon, 18 Apr 2022 08:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650269128;
        bh=6ctw0IMME55bQHvGTjhaH9FFoxddVdy3v7Rwgq7eLxQ=;
        h=Subject:To:Cc:From:Date:From;
        b=vx98an9K4E+07TzkSqjgju4d0h0t6OoXwoO2zsffm+p+H2z7l4U1Z77Pd9go3zo3V
         Y0ux7iN8/PGoCanyBLblMb5ComYG79sUseylMbCJpZmEPXktg37V2qxL0uYhseIdNb
         BOUNMAuPSRpsOEEjRVLdmQUgLSqW40Acfaxn1LLI=
Subject: FAILED: patch "[PATCH] mm: fix unexpected zeroed page mapping with zram swap" failed to apply to 4.19-stable tree
To:     minchan@kernel.org, akpm@linux-foundation.org, axboe@kernel.dk,
        david@redhat.com, ivan@cloudflare.com, ngupta@vflare.org,
        senozhatsky@chromium.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Apr 2022 10:05:16 +0200
Message-ID: <16502691166558@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e914d8f00391520ecc4495dd0ca0124538ab7119 Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan@kernel.org>
Date: Thu, 14 Apr 2022 19:13:46 -0700
Subject: [PATCH] mm: fix unexpected zeroed page mapping with zram swap

Two processes under CLONE_VM cloning, user process can be corrupted by
seeing zeroed page unexpectedly.

      CPU A                        CPU B

  do_swap_page                do_swap_page
  SWP_SYNCHRONOUS_IO path     SWP_SYNCHRONOUS_IO path
  swap_readpage valid data
    swap_slot_free_notify
      delete zram entry
                              swap_readpage zeroed(invalid) data
                              pte_lock
                              map the *zero data* to userspace
                              pte_unlock
  pte_lock
  if (!pte_same)
    goto out_nomap;
  pte_unlock
  return and next refault will
  read zeroed data

The swap_slot_free_notify is bogus for CLONE_VM case since it doesn't
increase the refcount of swap slot at copy_mm so it couldn't catch up
whether it's safe or not to discard data from backing device.  In the
case, only the lock it could rely on to synchronize swap slot freeing is
page table lock.  Thus, this patch gets rid of the swap_slot_free_notify
function.  With this patch, CPU A will see correct data.

      CPU A                        CPU B

  do_swap_page                do_swap_page
  SWP_SYNCHRONOUS_IO path     SWP_SYNCHRONOUS_IO path
                              swap_readpage original data
                              pte_lock
                              map the original data
                              swap_free
                                swap_range_free
                                  bd_disk->fops->swap_slot_free_notify
  swap_readpage read zeroed data
                              pte_unlock
  pte_lock
  if (!pte_same)
    goto out_nomap;
  pte_unlock
  return
  on next refault will see mapped data by CPU B

The concern of the patch would increase memory consumption since it
could keep wasted memory with compressed form in zram as well as
uncompressed form in address space.  However, most of cases of zram uses
no readahead and do_swap_page is followed by swap_free so it will free
the compressed form from in zram quickly.

Link: https://lkml.kernel.org/r/YjTVVxIAsnKAXjTd@google.com
Fixes: 0bcac06f27d7 ("mm, swap: skip swapcache for swapin of synchronous device")
Reported-by: Ivan Babrou <ivan@cloudflare.com>
Tested-by: Ivan Babrou <ivan@cloudflare.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>	[4.14+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/page_io.c b/mm/page_io.c
index b417f000b49e..89fbf3cae30f 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -51,54 +51,6 @@ void end_swap_bio_write(struct bio *bio)
 	bio_put(bio);
 }
 
-static void swap_slot_free_notify(struct page *page)
-{
-	struct swap_info_struct *sis;
-	struct gendisk *disk;
-	swp_entry_t entry;
-
-	/*
-	 * There is no guarantee that the page is in swap cache - the software
-	 * suspend code (at least) uses end_swap_bio_read() against a non-
-	 * swapcache page.  So we must check PG_swapcache before proceeding with
-	 * this optimization.
-	 */
-	if (unlikely(!PageSwapCache(page)))
-		return;
-
-	sis = page_swap_info(page);
-	if (data_race(!(sis->flags & SWP_BLKDEV)))
-		return;
-
-	/*
-	 * The swap subsystem performs lazy swap slot freeing,
-	 * expecting that the page will be swapped out again.
-	 * So we can avoid an unnecessary write if the page
-	 * isn't redirtied.
-	 * This is good for real swap storage because we can
-	 * reduce unnecessary I/O and enhance wear-leveling
-	 * if an SSD is used as the as swap device.
-	 * But if in-memory swap device (eg zram) is used,
-	 * this causes a duplicated copy between uncompressed
-	 * data in VM-owned memory and compressed data in
-	 * zram-owned memory.  So let's free zram-owned memory
-	 * and make the VM-owned decompressed page *dirty*,
-	 * so the page should be swapped out somewhere again if
-	 * we again wish to reclaim it.
-	 */
-	disk = sis->bdev->bd_disk;
-	entry.val = page_private(page);
-	if (disk->fops->swap_slot_free_notify && __swap_count(entry) == 1) {
-		unsigned long offset;
-
-		offset = swp_offset(entry);
-
-		SetPageDirty(page);
-		disk->fops->swap_slot_free_notify(sis->bdev,
-				offset);
-	}
-}
-
 static void end_swap_bio_read(struct bio *bio)
 {
 	struct page *page = bio_first_page_all(bio);
@@ -114,7 +66,6 @@ static void end_swap_bio_read(struct bio *bio)
 	}
 
 	SetPageUptodate(page);
-	swap_slot_free_notify(page);
 out:
 	unlock_page(page);
 	WRITE_ONCE(bio->bi_private, NULL);
@@ -394,11 +345,6 @@ int swap_readpage(struct page *page, bool synchronous)
 	if (sis->flags & SWP_SYNCHRONOUS_IO) {
 		ret = bdev_read_page(sis->bdev, swap_page_sector(page), page);
 		if (!ret) {
-			if (trylock_page(page)) {
-				swap_slot_free_notify(page);
-				unlock_page(page);
-			}
-
 			count_vm_event(PSWPIN);
 			goto out;
 		}

